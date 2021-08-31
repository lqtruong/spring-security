package com.turong.training.secure.config;

import com.turong.training.secure.model.TenantUserDetails;
import com.turong.training.secure.service.auth.AuthService;
import lombok.extern.log4j.Log4j2;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Collections;
import java.util.Objects;
import java.util.Optional;

import static org.apache.logging.log4j.util.Strings.isBlank;

@Component
@Log4j2
public class TenantRequestFilter extends OncePerRequestFilter {

    private static final String HEADER_ADMIN_ID = "x-admin-id";
    private static final String HEADER_ROLE = "x-role";
    private static final String HEADER_TENANT = "x-tenant-id";

    @Autowired
    private AuthService authService;

    @Override
    protected void doFilterInternal(
            HttpServletRequest httpServletRequest,
            HttpServletResponse httpServletResponse, FilterChain filterChain) throws ServletException, IOException {
        final String adminId = httpServletRequest.getHeader(HEADER_ADMIN_ID);
        final String role = httpServletRequest.getHeader(HEADER_ROLE);
        if (isBlank(adminId) || isBlank(role)) {
            throw new IllegalArgumentException("Request has not been authorized. No identification found.");
        }

        TenantUserDetails userDetails = authService.loadUserByEmail(adminId);
        if (Objects.isNull(userDetails)) {
            throw new IllegalArgumentException(String.format("No user profile found with id=%s.", adminId));
        }

        String foundTenant = userDetails.getTenantId();
        log.info("Found user {} in tenant {}", adminId, foundTenant);
        final String requestTenant = httpServletRequest.getHeader(HEADER_TENANT);
        if (!isBlank(requestTenant) && !StringUtils.equalsIgnoreCase(foundTenant, requestTenant)) {
            throw new IllegalArgumentException("Request is invalid.");
        }

        userDetails.setRole(role);
        userDetails.setAuthorities(authService.loadAuthorities(role, foundTenant));

//        final String requestUri = httpServletRequest.getRequestURI();
//        final String contextPath = httpServletRequest.getContextPath();
//        final String url = StringUtils.substring(requestUri, contextPath.length());
//        final String verb = httpServletRequest.getMethod();
//        userDetails.setUrl(url);
//        userDetails.setVerb(verb);

        UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                userDetails, null,
                Optional.ofNullable(userDetails).map(UserDetails::getAuthorities).orElse(Collections.emptyList())
        );
        authentication.setDetails(new WebDetails(httpServletRequest));
        SecurityContextHolder.getContext().setAuthentication(authentication);
        AppContextHolder.setUser(userDetails);

        filterChain.doFilter(httpServletRequest, httpServletResponse);
    }

}
