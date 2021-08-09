package com.turong.training.secure.service.auth;

import com.turong.training.secure.entity.SiteUser;
import com.turong.training.secure.model.TenantPermission;
import com.turong.training.secure.model.TenantUserDetails;
import com.turong.training.secure.service.UserService;
import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Objects;

@Service
@Log4j2
public class AuthServiceImpl implements AuthService {

    @Autowired
    private UserService userService;

    @Autowired
    private RolePermissionService rolePermissionService;

    @Override
    public TenantUserDetails loadUserByEmail(String email) {
        log.info("loadUserByEmail => email{}", email);
        // cache
        final SiteUser user = userService.searchUser(email);
        if (Objects.isNull(user)) {
            return null;
        }
        // find user in cache
        TenantUserDetails userDetails = new TenantUserDetails(
                email,
                user.getTenantId()
        );

        return userDetails;
    }

    @Override
    public Collection<TenantPermission> loadAuthorities(String role, String tenant) {
        // cache
        List<TenantPermission> rolePermissions = rolePermissionService.getAllRolePermissions(role, tenant);
        log.info("Tenant role permission found {}", rolePermissions);
        if (Objects.isNull(rolePermissions)) {
            return Collections.emptyList();
        }
        return rolePermissions;
    }

}
