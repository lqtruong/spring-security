package com.turong.training.secure.mapper;

import com.turong.training.secure.model.TenantFunction;
import com.turong.training.secure.model.TenantPermission;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface SiteRolePermissionMapper {

    @Select("select r.role as role,\n" +
            "    srp.tenant_id as tenant_id,\n" +
            "    p.id as permission_id,\n" +
            "    p.perm_name as permission_name,\n" +
            "    p.perm_desc as permission_desc" +
            "    from site_role_permission srp\n" +
            "    inner join site_role r on r.id = srp.role and r.tenant_id = srp.tenant_id\n" +
            "    inner join site_permission p on p.id = srp.perm_id and p.tenant_id = srp.tenant_id\n" +
            "    where r.role = #{role} and srp.tenant_id = #{tenantId}")
    @Results(value = {
            @Result(property="id", column = "permission_id"),
            @Result(property="permName", column = "permission_name"),
            @Result(property="permDesc", column = "permission_desc"),
            @Result(property="functions", column="permission_id", javaType= List.class, many=@Many(select="selectFunctionsByPermission"))
    })
//    @ResultMap("allRolePermissionsMap")
    List<TenantPermission> selectPermissionsByRole(@Param("role") String role, @Param("tenantId") String tenantId);


    @Select("select f.func_name as function_name,\n" +
            "    f.func_desc as function_desc,\n" +
            "    f.func_verb as function_verb,\n" +
            "    f.func_url as function_url" +
            "    from site_function f\n" +
            "    inner join site_permission_function pf on f.id = pf.func_id\n" +
            "    where pf.perm_id = #{permId}")
    @Results(value = {
            @Result(property="funcName", column = "function_name"),
            @Result(property="funcDesc", column = "function_desc"),
            @Result(property="funcVerb", column = "function_verb"),
            @Result(property="funcUrl", column="function_url")
    })
    List<TenantFunction> selectFunctionsByPermission(@Param("permId") Long permId);

//    @ResultMap("allRolePermissionsMap")
//    TenantRolePermission getAllRolePermissions(@Param("role") String role, @Param("tenantId") String tenantId);

//    r.role as role,
//    srp.tenant_id as tenant_id,
//    p.id as permission_id,
//    p.perm_name as permission_name,
//    p.perm_desc as permission_desc
//            f.func_name as function_name,
//            f.func_desc as function_desc,
//            f.func_verb as function_verb,
//            f.func_url as function_url
//    from site_role_permission srp
//    inner join site_role r on r.id = srp.role and r.tenant_id = srp.tenant_id
//    inner join site_permission p on p.id = srp.perm_id and p.tenant_id = srp.tenant_id
//    inner join site_permission_function pf on pf.perm_id = p.id and pf.tenant_id = srp.tenant_id
//    inner join site_function f on f.id = pf.func_id and f.tenant_id = srp.tenant_id
//    where r.role = #{role} and srp.tenant_id = #{tenantId}
}
