package com.proj.webprojrct.auth.service;

import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.OAuth2Error;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CustomOauth2UserService implements OAuth2UserService<OAuth2UserRequest, OAuth2User> {

    private final Oauth2Service oauth2Service;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2User oauth2User = oauth2Service.loadUser(userRequest);
        OAuth2User processed = oauth2Service.processOauth2User(oauth2User);

        if (processed == null) {
            // Chưa có user → redirect sang form nhập thêm
            throw new OAuth2AuthenticationException(new OAuth2Error("NEW_USER"));
        }

        return processed;
    }
}
