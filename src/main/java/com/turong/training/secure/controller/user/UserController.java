package com.turong.training.secure.controller.user;

import com.turong.training.secure.entity.SiteUser;
import com.turong.training.secure.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping("/user/count")
    public ResponseEntity<List<SiteUser>> countSiteUsers() {
        List<SiteUser> users = userService.countSiteUsers();
        return ResponseEntity.ok(users);
    }

}
