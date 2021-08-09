package com.turong.training.secure.service;

import com.turong.training.secure.entity.SiteUser;
import com.turong.training.secure.mapper.SiteUserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private SiteUserMapper userMapper;

    @Override
    public SiteUser searchUser(String email) {
        return userMapper.findUser(email);
    }

    @Override
    public List<SiteUser> countSiteUsers() {
        return userMapper.countUsersByTenantIds(Arrays.asList("tr", "ind"));
    }

}
