package com.proj.webprojrct.common.config.logging;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Utility class ghi log các sự kiện bảo mật quan trọng.
 * Giải quyết OWASP A09 - Security Logging & Monitoring Failures.
 *
 * Tất cả log được ghi vào logger "SECURITY_EVENT" - tương ứng với
 * appender SECURITY_FILE trong logback-spring.xml (file: logs/security.log).
 *
 * Không phải Spring bean => không có dependency injection,
 * dùng static methods cho tiện gọi từ bất kỳ đâu.
 */
public final class SecurityEventLogger {

    // Logger name phải khớp chính xác với <logger name="SECURITY_EVENT"> trong logback-spring.xml
    private static final Logger SECURITY_LOG = LoggerFactory.getLogger("SECURITY_EVENT");

    // Utility class - không cho khởi tạo
    private SecurityEventLogger() {}

    /**
     * Log khi đăng nhập thành công (không có role — giữ lại cho backward-compat).
     */
    public static void loginSuccess(String username, String ip) {
        SECURITY_LOG.info("LOGIN_SUCCESS | user={} | role=USER | ip={}", mask(username), ip);
    }

    /**
     * Log khi đăng nhập thành công, kèm role thực tế của user.
     * Admin login sẽ hiển thị rõ role=ADMIN để phân biệt với user thường.
     */
    public static void loginSuccess(String username, String ip, String role) {
        if ("ADMIN".equals(role) || "SELLER".equals(role)) {
            // WARN thay vì INFO để admin login nổi bật hơn trong log
            SECURITY_LOG.warn("LOGIN_SUCCESS | user={} | role={} | ip={}", mask(username), role, ip);
        } else {
            SECURITY_LOG.info("LOGIN_SUCCESS | user={} | role={} | ip={}", mask(username), role, ip);
        }
    }

    /**
     * Log khi đăng nhập thất bại.
     * Level WARN - dấu hiệu có thể bị tấn công brute-force.
     */
    public static void loginFailure(String username, String ip, String reason) {
        SECURITY_LOG.warn("LOGIN_FAILURE | user={} | ip={} | reason={}", mask(username), ip, reason);
    }

    /**
     * Log khi đăng ký tài khoản mới thành công.
     * Level INFO - theo dõi hoạt động đăng ký bất thường.
     */
    public static void registerSuccess(String username, String ip) {
        SECURITY_LOG.info("REGISTER_SUCCESS | user={} | ip={}", mask(username), ip);
    }

    /**
     * Log khi user truy cập vào vùng admin.
     * Level INFO - audit trail cho hành động quản trị.
     */
    public static void adminAccess(String username, String ip, String uri) {
        SECURITY_LOG.info("ADMIN_ACCESS | user={} | ip={} | uri={}", mask(username), ip, uri);
    }

    /**
     * Log lỗi hệ thống nghiêm trọng.
     * Level ERROR - cần xử lý ngay.
     */
    public static void systemError(String errorType, String ip, String message) {
        SECURITY_LOG.error("SYSTEM_ERROR | type={} | ip={} | message={}", errorType, ip, message);
    }

    /**
     * Log khi user đổi mật khẩu thành công.
     * Level WARN - hành động nhạy cảm, cần audit trail.
     */
    public static void passwordChanged(String username, String ip) {
        SECURITY_LOG.warn("PASSWORD_CHANGED | user={} | ip={}", mask(username), ip);
    }

    /**
     * Log khi reset mật khẩu (qua phone hoặc email).
     * Level WARN - nếu user không tự reset => tài khoản có thể bị chiếm.
     */
    public static void passwordReset(String identifier, String ip, String method) {
        SECURITY_LOG.warn("PASSWORD_RESET | identifier={} | method={} | ip={}", mask(identifier), method, ip);
    }

    /**
     * Log khi user đăng xuất.
     * Level INFO - audit trail session lifecycle.
     */
    public static void logout(String username, String ip) {
        SECURITY_LOG.info("LOGOUT | user={} | ip={}", mask(username), ip);
    }

    /**
     * Log khi admin thay đổi role của user.
     * Level WARN - thay đổi quyền là hành động đặc quyền cao.
     */
    public static void roleChanged(String adminUser, String targetUser, String oldRole, String newRole, String ip) {
        SECURITY_LOG.warn("ROLE_CHANGED | admin={} | target={} | from={} | to={} | ip={}",
                mask(adminUser), mask(targetUser), oldRole, newRole, ip);
    }

    /**
     * Log khi admin xóa user.
     * Level WARN - xóa user là hành động không thể hoàn tác.
     */
    public static void userDeleted(String adminUser, String targetUserId, String ip) {
        SECURITY_LOG.warn("USER_DELETED | admin={} | targetUserId={} | ip={}", mask(adminUser), targetUserId, ip);
    }

    /**
     * Log khi user hủy/xóa order.
     * Level WARN - thao tác tài chính nhạy cảm.
     */
    public static void orderCancelled(String username, Long orderId, String ip, String reason) {
        SECURITY_LOG.warn("ORDER_CANCELLED | user={} | orderId={} | reason={} | ip={}",
                mask(username), orderId, reason, ip);
    }

    /**
     * Log khi có request đến API quan trọng (payment, order create...).
     * Level INFO - theo dõi lưu lượng API nhạy cảm.
     */
    public static void sensitiveApiAccess(String username, String ip, String method, String uri) {
        SECURITY_LOG.info("SENSITIVE_API | user={} | ip={} | uri={}", mask(username), ip, method + " " + uri);
    }

    /**
     * Che giấu phần giữa của phone/email để bảo vệ thông tin cá nhân trong log.
     * Ví dụ: "0912345678" -> "09***78"
     */
    private static String mask(String value) {
        if (value == null || value.length() <= 4) {
            return "***";
        }
        return value.substring(0, 2) + "***" + value.substring(value.length() - 2);
    }
}
