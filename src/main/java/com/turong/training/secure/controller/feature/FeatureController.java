package com.turong.training.secure.controller.feature;

import lombok.extern.log4j.Log4j2;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/authority/get")
@Log4j2
public class FeatureController {

    @GetMapping
    @PreAuthorize("hasPermission(#c, 'Tr Admin')")
    public ResponseEntity<FeatureResponse> search(@RequestBody final FeatureSearchRequest searchRequest) {
        log.info("searchRequest={}", searchRequest);
        FeatureResponse res = new FeatureResponse();
        res.setMessage("feature");
        return ResponseEntity.ok(res);
    }


}
