package com.turong.training.secure.service.auth;

import com.turong.training.secure.model.TenantUserDetails;
import lombok.extern.log4j.Log4j2;
import org.apache.commons.lang3.StringUtils;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;

@Component
@Log4j2
public class WebUrlSecurity {

    public boolean check(Authentication authentication, HttpServletRequest request) throws AccessDeniedException {
        log.info("request params={}", request.getParameterMap().entrySet());
        log.info("request headers x-admin-id={}", request.getHeader("x-admin-id"));
        log.info("request headers x-role={}", request.getHeader("x-role"));
        log.info("request headers x-tenant-id={}", request.getHeader("x-tenant-id"));

        if (!(authentication.getPrincipal() instanceof TenantUserDetails)) {
            return false;
        }

        TenantUserDetails userDetails = (TenantUserDetails) authentication.getPrincipal();
        final String requestUri = request.getRequestURI();
        final String contextPath = request.getContextPath();
        final String url = StringUtils.substring(requestUri, contextPath.length());
        final String verb = request.getMethod();
        log.info("Url {}:{}, to check", verb, url);

        boolean hasAccessRight = userDetails.hasAccess(url, verb);
        if (hasAccessRight) {
            return true;
        }
        throw new AccessDeniedException(userDetails.getAdminId(), userDetails.getRole(), userDetails.getTenantId());
    }

}
