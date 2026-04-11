package com.proj.webprojrct.auth.service;

import java.util.Optional;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.OAuth2Error;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import lombok.RequiredArgsConstructor;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.repository.UserRepository;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.OAuth2Error;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import jakarta.servlet.http.HttpSession;

@Service
@RequiredArgsConstructor
public class Oauth2Service {

    private final UserRepository userRepository;
    private final HttpSession session;

    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2User oauth2User = new DefaultOAuth2UserService().loadUser(userRequest);
        return oauth2User;
    }

    public OAuth2User processOauth2User(OAuth2User oauth2User) {
        String email = oauth2User.getAttribute("email");

        if (email == null) {
            throw new OAuth2AuthenticationException("Không thể lấy email từ Google");
        }

        User optionalUser = userRepository.findByEmail(email).orElse(null);
        if (optionalUser == null) {
            // 🔸 Lưu tạm thông tin vào session để chuyển sang form nhập dữ liệu bổ sung
            session.setAttribute("oauth2_email", email);
            session.setAttribute("oauth2_name", oauth2User.getAttribute("name"));
            session.setAttribute("oauth2_picture", oauth2User.getAttribute("picture"));

            return null;
        }

        User user = optionalUser;
        return new CustomOauth2User(user, oauth2User.getAttributes());
    }
}
