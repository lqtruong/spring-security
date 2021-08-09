package com.turong.training.secure.service.auth;

import com.turong.training.secure.model.TenantPermission;

import java.util.List;

public interface RolePermissionService {

    List<TenantPermission> getAllRolePermissions(final String role, final String tenantId);

}
