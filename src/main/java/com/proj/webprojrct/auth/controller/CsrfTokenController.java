package com.proj.webprojrct.auth.controller;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * Endpoint trả về CSRF token hiện tại cho các client JS cần gắn vào header.
 * Yêu cầu: User phải đã đăng nhập (cookie access_token hợp lệ).
 * Endpoint này KHÔNG nằm trong danh sách ignoringRequestMatchers để đảm bảo bảo mật.
 */
@RestController
public class CsrfTokenController {

    @GetMapping("/api/csrf-token")
    public Map<String, String> getCsrfToken(HttpServletRequest request) {
        // Spring đã resolve deferred token và đặt vào request attribute
        CsrfToken token = (CsrfToken) request.getAttribute(CsrfToken.class.getName());
        if (token == null) {
            return Map.of("error", "CSRF token not available. Make sure CSRF is enabled.");
        }
        return Map.of(
                "headerName",    token.getHeaderName(),      // "X-XSRF-TOKEN"
                "parameterName", token.getParameterName(),   // "_csrf"
                "token",         token.getToken()            // UUID value
        );
    }
}
