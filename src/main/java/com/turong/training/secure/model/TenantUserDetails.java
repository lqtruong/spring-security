package com.turong.training.secure.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.apache.commons.collections4.CollectionUtils;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

import static org.apache.commons.lang3.StringUtils.equalsIgnoreCase;

@Getter
@Setter
@ToString
public class TenantUserDetails implements UserDetails {

    private final String adminId;
    private final String tenantId;
    private String url;
    private String verb;
    private String role;
    private Collection<TenantPermission> authorities;

    public TenantUserDetails(final String adminId, final String tenantId) {
        this.adminId = adminId;
        this.tenantId = tenantId;
    }

    @Override
    public Collection<? extends TenantPermission> getAuthorities() {
        return authorities;
    }

    @Override
    public String getPassword() {
        return null;
    }

    @Override
    public String getUsername() {
        return this.adminId;
    }

    @Override
    public boolean isAccountNonExpired() {
        return false;
    }

    @Override
    public boolean isAccountNonLocked() {
        return false;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return false;
    }

    @Override
    public boolean isEnabled() {
        return false;
    }

    public List<TenantFunction> urls() {
        if (CollectionUtils.isEmpty(authorities)) {
            return Collections.emptyList();
        }
        return authorities.stream().filter(Objects::nonNull).flatMap(p -> p.getFunctions().stream()).collect(Collectors.toList());
    }

    public boolean hasAccess(final String url, final String verb) {
        return urls().stream()
                .anyMatch(tf -> equalsIgnoreCase(tf.getFuncUrl(), url) && equalsIgnoreCase(tf.getFuncVerb(), verb));
    }
}
