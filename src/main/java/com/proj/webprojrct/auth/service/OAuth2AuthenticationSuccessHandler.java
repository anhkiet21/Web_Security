package com.proj.webprojrct.auth.service;

import java.io.IOException;
import java.util.Optional;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.springframework.http.ResponseCookie;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import com.proj.webprojrct.common.config.security.JwtUtil;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.repository.UserRepository;

@Component
public class OAuth2AuthenticationSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler {

    private final JwtUtil jwtUtil;
    private final UserRepository userRepository;

    public OAuth2AuthenticationSuccessHandler(JwtUtil jwtUtil, UserRepository userRepository) {
        this.jwtUtil = jwtUtil;
        this.userRepository = userRepository;
        setDefaultTargetUrl("/");
    }

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request,
            HttpServletResponse response,
            Authentication authentication) throws ServletException, IOException {

        Object principal = authentication.getPrincipal();
        if (principal instanceof OAuth2User) {
            OAuth2User oauth2User = (OAuth2User) principal;
            String email = oauth2User.getAttribute("email");

            if (email != null) {
                Optional<User> maybe = userRepository.findByEmail(email);
                if (maybe.isPresent()) {
                    User user = maybe.get();
                    String accessToken = jwtUtil.generateAccessToken(user);
                    String refreshToken = jwtUtil.generateRefreshToken(user);

                    boolean secure = request.isSecure();

                    ResponseCookie accessCookie = ResponseCookie.from("access_token", accessToken)
                            .httpOnly(true)
                            .secure(secure)
                            .path("/")
                            .maxAge(60 * 60 * 24)
                            .sameSite("Lax")
                            .build();

                    ResponseCookie refreshCookie = ResponseCookie.from("refresh_token", refreshToken)
                            .httpOnly(true)
                            .secure(secure)
                            .path("/")
                            .maxAge(60 * 60 * 24 * 30)
                            .sameSite("Lax")
                            .build();

                    response.addHeader("Set-Cookie", accessCookie.toString());
                    response.addHeader("Set-Cookie", refreshCookie.toString());
                    // clean temp session attrs if any
                    HttpSession session = request.getSession(false);
                    if (session != null) {
                        session.removeAttribute("oauth2_email");
                        session.removeAttribute("oauth2_name");
                        session.removeAttribute("oauth2_picture");
                    }
                } else {
                    // no user -> let failure flow or redirect to /oauth2/complete
                    response.sendRedirect(request.getContextPath() + "/oauth2/complete");
                    return;
                }
            }
        }

        super.onAuthenticationSuccess(request, response, authentication);
    }
}
