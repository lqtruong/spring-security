package com.turong.training.secure.controller.auth;

import com.turong.training.secure.convert.AuthConvert;
import com.turong.training.secure.service.auth.AuthServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/authorize")
public class AuthController {

    @Autowired
    private AuthConvert authConvert;

    @Autowired
    private AuthServiceImpl authService;

    @GetMapping("")
    public ResponseEntity<AuthResponse> authorize(@RequestBody final AuthRequest authRequest) {
        return ResponseEntity.ok(new AuthResponse());
    }

}
