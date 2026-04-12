package com.proj.webprojrct.common.config.metrics;

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import org.springframework.stereotype.Component;

/**
 * Custom Prometheus metrics cho sự kiện bảo mật.
 * Giải quyết OWASP A09 - Security Logging & Monitoring Failures.
 *
 * Các metric này được expose tại endpoint /actuator/prometheus
 * và Prometheus sẽ scrape để tạo alert (xem alert.rules.yml).
 *
 * Metric names:
 *   - security_login_failure_total   : đếm login thất bại
 *   - security_login_success_total   : đếm login thành công
 *   - security_register_total        : đếm đăng ký mới
 */
@Component
public class LoginMetrics {

    private final Counter loginFailureCounter;
    private final Counter loginSuccessCounter;
    private final Counter registerCounter;

    // MeterRegistry được Spring Boot inject tự động khi có micrometer-registry-prometheus
    public LoginMetrics(MeterRegistry registry) {
        this.loginFailureCounter = Counter.builder("security_login_failure_total")
                .description("Tổng số lần đăng nhập thất bại - dùng để phát hiện brute-force")
                .register(registry);

        this.loginSuccessCounter = Counter.builder("security_login_success_total")
                .description("Tổng số lần đăng nhập thành công")
                .register(registry);

        this.registerCounter = Counter.builder("security_register_total")
                .description("Tổng số tài khoản được đăng ký")
                .register(registry);
    }

    /** Gọi khi đăng nhập thất bại (sai mật khẩu, tài khoản bị khóa...) */
    public void recordLoginFailure() {
        loginFailureCounter.increment();
    }

    /** Gọi khi đăng nhập thành công */
    public void recordLoginSuccess() {
        loginSuccessCounter.increment();
    }

    /** Gọi khi đăng ký tài khoản mới thành công */
    public void recordRegister() {
        registerCounter.increment();
    }
}
