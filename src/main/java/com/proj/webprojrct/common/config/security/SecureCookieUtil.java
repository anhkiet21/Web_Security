package com.proj.webprojrct.common.config.security;

import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseCookie;
import jakarta.servlet.http.HttpServletResponse;

/**
 * [FIX V-04] Utility tạo cookie bảo mật thống nhất toàn hệ thống.
 * Tất cả cookie đều có: HttpOnly, Secure, SameSite=Lax, Path=/.
 * Thay thế new Cookie(...) để tránh thiếu flag bảo mật.
 */
public final class SecureCookieUtil {

    private SecureCookieUtil() {
    }

    /**
     * Tạo và gắn cookie access_token bảo mật vào response.
     * MaxAge = 15 phút (900 giây).
     */
    public static void addAccessTokenCookie(HttpServletResponse response, String token) {
        ResponseCookie cookie = ResponseCookie.from("access_token", token)
                .httpOnly(true)
                .secure(true)
                .path("/")
                .sameSite("Lax")
                .maxAge(15 * 60) // 15 phút
                .build();
        response.addHeader(HttpHeaders.SET_COOKIE, cookie.toString());
    }

    /**
     * Tạo và gắn cookie refresh_token bảo mật vào response.
     * MaxAge = 7 ngày.
     */
    public static void addRefreshTokenCookie(HttpServletResponse response, String token) {
        ResponseCookie cookie = ResponseCookie.from("refresh_token", token)
                .httpOnly(true)
                .secure(true)
                .path("/")
                .sameSite("Lax")
                .maxAge(7 * 24 * 60 * 60) // 7 ngày
                .build();
        response.addHeader(HttpHeaders.SET_COOKIE, cookie.toString());
    }

    /**
     * Xóa cookie access_token (set MaxAge=0).
     */
    public static void clearAccessTokenCookie(HttpServletResponse response) {
        ResponseCookie cookie = ResponseCookie.from("access_token", "")
                .httpOnly(true)
                .secure(true)
                .path("/")
                .sameSite("Lax")
                .maxAge(0)
                .build();
        response.addHeader(HttpHeaders.SET_COOKIE, cookie.toString());
    }

    /**
     * Xóa cookie refresh_token (set MaxAge=0).
     */
    public static void clearRefreshTokenCookie(HttpServletResponse response) {
        ResponseCookie cookie = ResponseCookie.from("refresh_token", "")
                .httpOnly(true)
                .secure(true)
                .path("/")
                .sameSite("Lax")
                .maxAge(0)
                .build();
        response.addHeader(HttpHeaders.SET_COOKIE, cookie.toString());
    }
}
