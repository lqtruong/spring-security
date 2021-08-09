package com.turong.training.secure.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@JsonIgnoreProperties(ignoreUnknown = true)
public class SiteFunction extends BaseEntity {

    private String funcName;
    private String funcDesc;
    private String funcUrl;

}
