package com.turong.training.secure.controller.feature;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.turong.training.secure.controller.WebRequest;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@JsonIgnoreProperties(ignoreUnknown = true)
public class FeatureSearchRequest extends WebRequest {

}
