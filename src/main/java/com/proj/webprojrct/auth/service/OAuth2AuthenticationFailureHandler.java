package com.proj.webprojrct.auth.service;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@Component
public class OAuth2AuthenticationFailureHandler implements AuthenticationFailureHandler {

    @Override
    public void onAuthenticationFailure(HttpServletRequest request,
            HttpServletResponse response,
            AuthenticationException exception) throws IOException, ServletException {

        String redirect = request.getContextPath() + "/login?error";
        if (exception instanceof OAuth2AuthenticationException) {
            var oauthEx = (OAuth2AuthenticationException) exception;
            String code = oauthEx.getError().getErrorCode();
            if ("NEW_USER".equals(code)) {
                redirect = request.getContextPath() + "/oauth2/complete";
            }
        }
        response.sendRedirect(redirect);
    }
}
