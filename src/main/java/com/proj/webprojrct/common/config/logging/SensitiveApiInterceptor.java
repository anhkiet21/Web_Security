package com.proj.webprojrct.common.config.logging;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.proj.webprojrct.common.config.security.CustomUserDetails;

/**
 * [OWASP A09] Ghi log mọi truy cập vào các API nhạy cảm:
 *  - /api/orders/** (tạo / hủy / hoàn tiền đơn hàng)
 *  - /api/vnpay/payment/** (thanh toán VNPay)
 */
@Component
public class SensitiveApiInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        String username = "anonymous";
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.getPrincipal() instanceof CustomUserDetails) {
            username = ((CustomUserDetails) auth.getPrincipal()).getUsername();
        }

        SecurityEventLogger.sensitiveApiAccess(
                username,
                getClientIp(request),
                request.getMethod(),
                request.getRequestURI());

        return true;
    }

    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip != null && !ip.isEmpty() && !"unknown".equalsIgnoreCase(ip)) {
            return ip.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }
}
