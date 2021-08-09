package com.turong.training.secure.config;

import com.turong.training.secure.service.auth.WebUrlSecurity;
import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@Log4j2
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    private TenantRequestFilter tenantRequestFilter;

    @Bean
    @Primary
    public WebUrlSecurity webSecurity() {
        return new WebUrlSecurity();
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.authorizeRequests()
                .antMatchers("/").permitAll()
                .antMatchers("/swagger-ui").permitAll()
                .antMatchers("/feature/**").access("@webSecurity.check(authentication,request)")
                .antMatchers("/message/**").access("@webSecurity.check(authentication,request)")
                .antMatchers("/user/**").permitAll()
                .anyRequest().authenticated();
        http.addFilterBefore(tenantRequestFilter, UsernamePasswordAuthenticationFilter.class);
    }

}
