package com.turong.training.secure.config;

import lombok.extern.slf4j.Slf4j;
import net.sf.jsqlparser.JSQLParserException;
import net.sf.jsqlparser.expression.BinaryExpression;
import net.sf.jsqlparser.expression.Expression;
import net.sf.jsqlparser.expression.StringValue;
import net.sf.jsqlparser.expression.operators.conditional.AndExpression;
import net.sf.jsqlparser.expression.operators.relational.EqualsTo;
import net.sf.jsqlparser.expression.operators.relational.ExpressionList;
import net.sf.jsqlparser.parser.CCJSqlParserUtil;
import net.sf.jsqlparser.schema.Column;
import net.sf.jsqlparser.statement.Statement;
import net.sf.jsqlparser.statement.delete.Delete;
import net.sf.jsqlparser.statement.insert.Insert;
import net.sf.jsqlparser.statement.select.PlainSelect;
import net.sf.jsqlparser.statement.select.Select;
import net.sf.jsqlparser.statement.update.Update;
import net.sf.jsqlparser.util.TablesNamesFinder;
import org.apache.ibatis.executor.Executor;
import org.apache.ibatis.mapping.BoundSql;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.mapping.SqlSource;
import org.apache.ibatis.plugin.*;
import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.session.RowBounds;

import java.util.List;
import java.util.Objects;
import java.util.Properties;

import static org.apache.commons.collections4.CollectionUtils.isEmpty;
import static org.apache.commons.lang3.StringUtils.isBlank;

@Slf4j
@Intercepts({
        @Signature(type = Executor.class, method = "query", args = {MappedStatement.class, Object.class, RowBounds.class, ResultHandler.class}),
        @Signature(type = Executor.class, method = "update", args = {MappedStatement.class, Object.class})
})
public class TenantInterceptor implements Interceptor {

    private TenantHandler tenantHandler;

    public TenantInterceptor(final TenantHandler tenantHandler) {
        this.tenantHandler = tenantHandler;
    }

    @Override
    public Object intercept(Invocation invocation) throws Throwable {
        process(invocation);
        return invocation.proceed();
    }

    public void process(Invocation invocation) throws Throwable {
        if (isBlank(AppContextHolder.getTenant())) {
            return;
        }
        MappedStatement mappedStatement = (MappedStatement) invocation.getArgs()[0];

        Object parameters = null;
        if (invocation.getArgs().length > 1) {
            parameters = invocation.getArgs()[1];
        }
        BoundSql boundSql = mappedStatement.getBoundSql(parameters);
        BoundSql newBoundSql = new BoundSql(
                mappedStatement.getConfiguration(),
                addWhere(boundSql.getSql()), // to add where condition with column based
                boundSql.getParameterMappings(),
                boundSql.getParameterObject());

        if (!isEmpty(boundSql.getParameterMappings())) {
            boundSql.getParameterMappings().forEach(parameterMapping -> {
                final String param = parameterMapping.getProperty();
                if (boundSql.hasAdditionalParameter(param)) {
                    newBoundSql.setAdditionalParameter(param, boundSql.getAdditionalParameter(param));
                }
            });
        }

        MappedStatement.Builder modifiedMappedStatementBuilder = new MappedStatement.Builder(
                mappedStatement.getConfiguration(),
                mappedStatement.getId(),
                new BoundSqlSqlSource(newBoundSql),
                mappedStatement.getSqlCommandType());
        modifiedMappedStatementBuilder.resource(mappedStatement.getResource());
        modifiedMappedStatementBuilder.fetchSize(mappedStatement.getFetchSize());
        modifiedMappedStatementBuilder.statementType(mappedStatement.getStatementType());
        modifiedMappedStatementBuilder.keyGenerator(mappedStatement.getKeyGenerator());
        modifiedMappedStatementBuilder.timeout(mappedStatement.getTimeout());
        modifiedMappedStatementBuilder.parameterMap(mappedStatement.getParameterMap());
        modifiedMappedStatementBuilder.resultMaps(mappedStatement.getResultMaps());
        modifiedMappedStatementBuilder.cache(mappedStatement.getCache());

        MappedStatement modifiedMappedStatement = modifiedMappedStatementBuilder.build();
        invocation.getArgs()[0] = modifiedMappedStatement;
    }

    @Override
    public Object plugin(Object target) {
        return Plugin.wrap(target, this);
    }

    @Override
    public void setProperties(Properties properties) {
    }

    private String addWhere(final String sql) throws JSQLParserException {
        Statement statement = CCJSqlParserUtil.parse(sql);
        if (statement instanceof Insert) {
            return processInsertStatement((Insert) statement);
        }
        if (statement instanceof Update) {
            return processUpdateStatement((Update) statement);
        }
        if (statement instanceof Select) {
            return processSelectStatement((Select) statement);
        }
        if (statement instanceof Delete) {
            return processDeleteStatement((Delete) statement);
        }
        throw new UnsupportedOperationException("Query not supported for multi-tenant based filtering.");
    }

    private String processDeleteStatement(Delete deleteStatement) {
        Expression where = deleteStatement.getWhere();
        if (where instanceof BinaryExpression) {
            EqualsTo equalsTo = new EqualsTo();
            equalsTo.setLeftExpression(new Column(tenantHandler.getTenantColumnId()));
            equalsTo.setRightExpression(new StringValue(AppContextHolder.getTenant()));
            AndExpression andExpression = new AndExpression(equalsTo, where);
            deleteStatement.setWhere(andExpression);
        }
        return deleteStatement.toString();
    }

    private String processSelectStatement(Select selectStatement) {
        PlainSelect ps = (PlainSelect) selectStatement.getSelectBody();
        TablesNamesFinder tablesNamesFinder = new TablesNamesFinder();
        List<String> tableList = tablesNamesFinder.getTableList(selectStatement);
        if (tableList.size() > 1) { // only allow query to selectStatement on one table, no nested selectStatement table
            return selectStatement.toString();
        }
        for (final String table : tableList) {
            EqualsTo equalsTo = new EqualsTo();
            equalsTo.setLeftExpression(new Column(table + '.' + tenantHandler.getTenantColumnId()));
            equalsTo.setRightExpression(new StringValue(AppContextHolder.getTenant()));
            if (Objects.isNull(ps.getWhere())) {
                ps.setWhere(equalsTo);
            } else {
                ps.setWhere(new AndExpression(equalsTo, ps.getWhere()));
            }
        }
        return selectStatement.toString();
    }

    private String processUpdateStatement(Update updateStatement) {
        Expression where = updateStatement.getWhere();
        if (where instanceof BinaryExpression) {
            EqualsTo equalsTo = new EqualsTo();
            equalsTo.setLeftExpression(new Column(tenantHandler.getTenantColumnId()));
            equalsTo.setRightExpression(new StringValue(AppContextHolder.getTenant()));
            AndExpression andExpression = new AndExpression(equalsTo, where);
            updateStatement.setWhere(andExpression);
        }
        return updateStatement.toString();
    }

    private String processInsertStatement(Insert insertStatement) {
        Insert insert = (Insert) insertStatement;
        insert.getColumns().add(new Column(tenantHandler.getTenantColumnId()));
        ((ExpressionList) insert.getItemsList()).getExpressions().add(new StringValue(AppContextHolder.getTenant()));
        return insert.toString();
    }

    static class BoundSqlSqlSource implements SqlSource {
        private BoundSql boundSql;

        public BoundSqlSqlSource(BoundSql boundSql) {
            this.boundSql = boundSql;
        }

        public BoundSql getBoundSql(Object parameterObject) {
            return boundSql;
        }
    }
}
