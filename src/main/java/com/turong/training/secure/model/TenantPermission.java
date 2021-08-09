package com.turong.training.secure.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.security.core.GrantedAuthority;

import java.util.List;

@Getter
@Setter
@ToString
@JsonIgnoreProperties(ignoreUnknown = true)
public class TenantPermission implements GrantedAuthority {

    private Long id;
    private String permName;
    private String permDesc;

    private List<TenantFunction> functions;

    @Override
    public String getAuthority() {
        return permName;
    }
}
