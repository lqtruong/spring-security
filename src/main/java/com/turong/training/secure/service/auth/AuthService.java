package com.turong.training.secure.service.auth;

import com.turong.training.secure.model.TenantPermission;
import com.turong.training.secure.model.TenantUserDetails;

import java.util.Collection;

public interface AuthService {

    TenantUserDetails loadUserByEmail(String email);

    Collection<TenantPermission> loadAuthorities(String role, String tenant);
}
