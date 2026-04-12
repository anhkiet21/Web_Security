package com.proj.webprojrct.common.config.configJsp;

import com.proj.webprojrct.common.config.logging.AdminAccessInterceptor;
import com.proj.webprojrct.common.config.logging.SensitiveApiInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Paths;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    // [LOGGING] Inject interceptor ghi log truy cập admin - OWASP A09
    @Autowired
    private AdminAccessInterceptor adminAccessInterceptor;

    // [LOGGING] Inject interceptor ghi log truy cập API nhạy cảm - OWASP A09
    @Autowired
    private SensitiveApiInterceptor sensitiveApiInterceptor;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {

        //Cho phép truy cập thư mục uploads (ngoài classpath)
        String uploadPath = Paths.get("uploads").toAbsolutePath().toUri().toString();
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(uploadPath);
    }

    // [LOGGING] Đăng ký interceptor - chỉ áp dụng cho /admin và /admin/** - OWASP A09
    // Lý do thêm "/admin": AntPathMatcher không match "/admin/**" với exact path "/admin"
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(adminAccessInterceptor)
                .addPathPatterns("/admin", "/admin/**");

        // [LOGGING] Ghi log mọi truy cập vào API nhạy cảm - OWASP A09
        registry.addInterceptor(sensitiveApiInterceptor)
                .addPathPatterns("/api/orders/**", "/api/vnpay/payment/**");
    }
}
