package com.turong.training.secure.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@JsonIgnoreProperties(ignoreUnknown = true)
public class TenantFunction {

    private String funcName;
    private String funcDesc;
    private String funcVerb;
    private String funcUrl;

}
