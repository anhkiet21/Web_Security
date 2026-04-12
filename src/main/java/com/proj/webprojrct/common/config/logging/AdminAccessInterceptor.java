package com.proj.webprojrct.common.config.logging;

import com.proj.webprojrct.common.config.security.CustomUserDetails;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.lang.NonNull;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * Interceptor ghi log mỗi request vào vùng /admin/**.
 * Giải quyết OWASP A09 - Security Logging & Monitoring Failures.
 *
 * Cách hoạt động:
 * - Đăng ký trong WebConfig.addInterceptors() với path /admin/**
 * - Chặn request TRƯỚC khi vào controller (preHandle)
 * - Chỉ GHI LOG, không can thiệp logic => return true luôn
 *
 * Không cần sửa bất kỳ AdminController nào.
 */
@Component
public class AdminAccessInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(@NonNull HttpServletRequest request,
                             @NonNull HttpServletResponse response,
                             @NonNull Object handler) {
        // Lấy thông tin để log
        String ip = getClientIp(request);
        String username = resolveUsername();
        String uri = request.getRequestURI();
        String method = request.getMethod();

        // Ghi log qua SecurityEventLogger => vào logs/security.log
        SecurityEventLogger.adminAccess(username, ip, method + " " + uri);

        // QUAN TRỌNG: phải return true để request tiếp tục xử lý bình thường
        return true;
    }

    /**
     * Lấy IP thực của client, hỗ trợ reverse proxy.
     */
    private String getClientIp(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isBlank()) {
            return xForwardedFor.split(",")[0].trim();
        }
        String xRealIp = request.getHeader("X-Real-IP");
        if (xRealIp != null && !xRealIp.isBlank()) {
            return xRealIp.trim();
        }
        return request.getRemoteAddr();
    }

    /**
     * Lấy username từ SecurityContext (đã được JwtAuthenticationFilter set sẵn).
     */
    private String resolveUsername() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.getPrincipal() instanceof CustomUserDetails userDetails) {
            return userDetails.getUsername();
        }
        return "anonymous";
    }
}
