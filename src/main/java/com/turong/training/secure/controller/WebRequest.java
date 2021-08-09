package com.turong.training.secure.controller;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@JsonIgnoreProperties(ignoreUnknown = true)
@ToString
public class WebRequest {

    private String userId;
    private String userName;
    private String userRole;

}
