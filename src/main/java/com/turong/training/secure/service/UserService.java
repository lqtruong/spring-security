package com.turong.training.secure.service;

import com.turong.training.secure.entity.SiteUser;

import java.util.List;

public interface UserService {

    SiteUser searchUser(final String email);

    List<SiteUser> countSiteUsers();
}
