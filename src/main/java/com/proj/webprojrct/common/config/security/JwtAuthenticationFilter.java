package com.proj.webprojrct.common.config.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import java.io.IOException;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtUtil jwtUtil;
    private final UserDetailsService userDetailsService;

    public JwtAuthenticationFilter(JwtUtil jwtUtil, UserDetailsService uds) {
        this.jwtUtil = jwtUtil;
        this.userDetailsService = uds;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest req,
            HttpServletResponse res,
            FilterChain chain) throws IOException, ServletException {
        String accessToken = null;

        // lấy access_token trong cookie
        if (req.getCookies() != null) {
            for (Cookie c : req.getCookies()) {
                if ("access_token".equals(c.getName())) {
                    accessToken = c.getValue();
                }
            }
        }

        try {
            if (accessToken != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                String username = jwtUtil.extractUsername(accessToken);
                var userDetails = userDetailsService.loadUserByUsername(username);

                if (jwtUtil.isTokenValid(accessToken, userDetails)) {
                    var auth = new UsernamePasswordAuthenticationToken(
                            userDetails, null, userDetails.getAuthorities());
                    SecurityContextHolder.getContext().setAuthentication(auth);
                } else {
                    // Token không hợp lệ -> xóa cả 2 token
                    clearTokens(res);
                }
            }
        } catch (io.jsonwebtoken.ExpiredJwtException ex) {
            // access_token hết hạn → thử dùng refresh_token
            String refreshToken = null;
            if (req.getCookies() != null) {
                for (Cookie c : req.getCookies()) {
                    if ("refresh_token".equals(c.getName())) {
                        refreshToken = c.getValue();
                    }
                }
            }

            if (refreshToken != null && jwtUtil.validateRefreshToken(refreshToken)) {
                String username = jwtUtil.extractUsername(refreshToken);
                var userDetails = userDetailsService.loadUserByUsername(username);

                // cấp access mới
                String newAccess = jwtUtil.generateAccessToken(userDetails);

                Cookie newAccessCookie = new Cookie("access_token", newAccess);
                newAccessCookie.setHttpOnly(true);
                newAccessCookie.setPath("/");
                res.addCookie(newAccessCookie);

                var auth = new UsernamePasswordAuthenticationToken(
                        userDetails, null, userDetails.getAuthorities());
                SecurityContextHolder.getContext().setAuthentication(auth);
            } else {
                // Refresh token không hợp lệ hoặc hết hạn -> xóa cả 2 token
                clearTokens(res);
            }
        } catch (Exception ex) {
            // Token bị lỗi (malformed, signature invalid, etc.) -> xóa cả 2 token
            clearTokens(res);
        }

        chain.doFilter(req, res);
    }

    private void clearTokens(HttpServletResponse response) {
        // Xóa access_token
        Cookie accessCookie = new Cookie("access_token", null);
        accessCookie.setHttpOnly(true);
        accessCookie.setPath("/");
        accessCookie.setMaxAge(0);
        response.addCookie(accessCookie);

        // Xóa refresh_token
        Cookie refreshCookie = new Cookie("refresh_token", null);
        refreshCookie.setHttpOnly(true);
        refreshCookie.setPath("/");
        refreshCookie.setMaxAge(0);
        response.addCookie(refreshCookie);
    }

}
