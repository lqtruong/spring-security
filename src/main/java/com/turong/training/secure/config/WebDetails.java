package com.turong.training.secure.config;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Getter;
import lombok.Setter;

import javax.servlet.http.HttpServletRequest;

import static org.apache.commons.lang3.StringUtils.substring;

@Getter
@Setter
@JsonIgnoreProperties(ignoreUnknown = true)
public class WebDetails {

    private String url;
    private String verb;

    public WebDetails(HttpServletRequest request) {
        final String requestUri = request.getRequestURI();
        final String contextPath = request.getContextPath();
        final String url = substring(requestUri, contextPath.length());
        final String verb = request.getMethod();
        setUrl(url);
        setVerb(verb);
    }

}
