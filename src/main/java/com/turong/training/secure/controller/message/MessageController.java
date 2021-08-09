package com.turong.training.secure.controller.message;

import org.springframework.http.ResponseEntity;
import org.springframework.lang.Nullable;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/message")
public class MessageController {

    @GetMapping("")
    public ResponseEntity<MessageResponse> search(@Nullable @RequestParam final MessageSearchRequest searchRequest) {
        MessageResponse res = new MessageResponse();
        res.setMessage("message");
        return ResponseEntity.ok(res);
    }
}
