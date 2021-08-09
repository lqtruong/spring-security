package com.turong.training.secure.config;

import lombok.extern.slf4j.Slf4j;
import org.apache.ibatis.plugin.Interceptor;
import org.apache.ibatis.session.ExecutorType;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.type.JdbcType;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import javax.sql.DataSource;
import java.util.Properties;

@Configuration
@Slf4j
@MapperScan(basePackages = {"com.turong.training.secure.mapper"})
public class MybatisConfig {

    private static final String TENANT_COLUMN = "tenant_id";

    @Bean
    @Primary
    public SqlSessionFactory sqlSessionFactory(@Qualifier("dataSource") DataSource dataSource) throws Exception {
        SqlSessionFactoryBean sessionFactory = new SqlSessionFactoryBean();
        sessionFactory.setDataSource(dataSource);
        sessionFactory.setConfiguration(this.getConfiguration());
        log.info("Session F");
        sessionFactory.setPlugins(new Interceptor[]{new TenantInterceptor(
                new TenantHandler() {
                    @Override
                    public String getTenantColumnId() {
                        return TENANT_COLUMN;
                    }
                }
        )});
        return sessionFactory.getObject();
    }

    protected org.apache.ibatis.session.Configuration getConfiguration() {
        org.apache.ibatis.session.Configuration config = new org.apache.ibatis.session.Configuration();
        config.setMapUnderscoreToCamelCase(true);
        Properties properties = new Properties();
        properties.setProperty("dialect", "MySQL");
        config.setVariables(properties);
        config.setJdbcTypeForNull(JdbcType.NULL);
        config.setCacheEnabled(false);
        config.setLazyLoadingEnabled(false);
        config.setDefaultExecutorType(ExecutorType.SIMPLE);
        return config;
    }

}
