package com.turong.training.secure.service.auth;

import com.turong.training.secure.mapper.SiteRolePermissionMapper;
import com.turong.training.secure.model.TenantPermission;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RolePermissionServiceImpl implements RolePermissionService {

    @Autowired
    private SiteRolePermissionMapper rolePermissionMapper;

    @Override
    public List<TenantPermission> getAllRolePermissions(String role, String tenantId) {
        return rolePermissionMapper.selectPermissionsByRole(role, tenantId);
    }

}
