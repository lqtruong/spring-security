package com.turong.training.secure.mapper;

import com.turong.training.secure.entity.SiteUser;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.ResultMap;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface SiteUserMapper {

    @Select("select * from site_user where email = #{email}")
    @ResultMap("findUserMap")
    SiteUser findUser(String email);

//    @Select("select tenant_id, count(1) as user_count from site_user where tenant_id in #{tenantIds} group by tenant_id")
//    @ResultMap("countUserMap")
    List<SiteUser> countUsersByTenantIds(@Param("tenantIds") List<String> tenantIds);
}
