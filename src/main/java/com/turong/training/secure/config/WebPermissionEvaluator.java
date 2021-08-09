package com.turong.training.secure.config;

import com.turong.training.secure.model.TenantUserDetails;
import com.turong.training.secure.service.auth.AccessDeniedException;
import com.turong.training.secure.service.auth.RolePermissionService;
import lombok.extern.log4j.Log4j2;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.PermissionEvaluator;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.WebAuthenticationDetails;
import org.springframework.stereotype.Component;

import java.io.Serializable;

@Log4j2
@Component
public class WebPermissionEvaluator implements PermissionEvaluator {

    @Autowired
    private RolePermissionService rolePermissionService;

    @Override
    public boolean hasPermission(Authentication authentication, Object requestObject, Object role) {
        log.info("hasPermission1; authentication={},\no1={},\no2={}", authentication, requestObject, role);
        WebDetails webDetails = (WebDetails) authentication.getDetails();

        final String url = webDetails.getUrl();
        final String verb = webDetails.getVerb();
        log.info("Url {}:{}, to check", verb, url);

        TenantUserDetails userDetails = (TenantUserDetails) authentication.getPrincipal();
        boolean hasAccessRight = userDetails.hasAccess(url, verb);
        if (hasAccessRight) {
            return true;
        }
//        throw new AccessDeniedException(userDetails.getAdminId(), userDetails.getRole(), userDetails.getTenantId());
        return false;
    }

    @Override
    public boolean hasPermission(Authentication authentication, Serializable serializable, String s, Object o) {
        log.info("hasPermission2; authentication={},\nserializable={},\ns={},o={}", authentication, serializable, s, o);
        return true;
    }

}
