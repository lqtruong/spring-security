package com.turong.training.secure.config;

import lombok.extern.log4j.Log4j2;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.access.PermissionCacheOptimizer;
import org.springframework.security.access.expression.method.DefaultMethodSecurityExpressionHandler;
import org.springframework.security.access.expression.method.MethodSecurityExpressionHandler;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.method.configuration.GlobalMethodSecurityConfiguration;
import org.springframework.security.core.Authentication;

import java.util.Collection;

@Configuration
@Log4j2
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class WebMethodSecurity extends GlobalMethodSecurityConfiguration {

    @Override
    public MethodSecurityExpressionHandler createExpressionHandler() {
        log.info("MethodSecurityExpressionHandler");
        DefaultMethodSecurityExpressionHandler expressionHandler = new DefaultMethodSecurityExpressionHandler();
        expressionHandler.setPermissionEvaluator(new WebPermissionEvaluator());
        expressionHandler.setPermissionCacheOptimizer(new PermissionCacheOptimizer() {
            @Override
            public void cachePermissionsFor(Authentication authentication, Collection<?> collection) {
                log.info("cachePermissionsFor={},\ncollection={}", authentication, collection);
            }
        });
        return expressionHandler;
    }



}
