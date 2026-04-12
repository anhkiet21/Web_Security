package com.proj.webprojrct.common.config;

import com.proj.webprojrct.common.config.logging.SecurityEventLogger;
import com.proj.webprojrct.common.dto.ErrorResponse;
import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;

import java.util.stream.Collectors;

@ControllerAdvice
public class GlobalExceptionHandler {

    // [LOGGING] Logger thông thường cho lỗi validation/runtime - OWASP A09
    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ResponseEntity<ErrorResponse> handleValidationExceptions(MethodArgumentNotValidException ex,
                                                                    HttpServletRequest request) {
        var details = ex.getBindingResult().getFieldErrors().stream()
                .map(e -> e.getField() + ": " + e.getDefaultMessage())
                .collect(Collectors.toList());

        // [LOGGING] Log lỗi validation ở mức WARN - OWASP A09
        log.warn("VALIDATION_ERROR | uri={} | ip={} | fields={}",
                request.getRequestURI(), getClientIp(request), details);

        var body = ErrorResponse.builder()
                .message("Validation failed")
                .details(details)
                .build();

        return new ResponseEntity<>(body, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<ErrorResponse> handleRuntime(RuntimeException ex, HttpServletRequest request) {
        // [LOGGING] Log lỗi runtime nghiêm trọng qua SecurityEventLogger - OWASP A09
        SecurityEventLogger.systemError(
                ex.getClass().getSimpleName(),
                getClientIp(request),
                ex.getMessage()
        );

        var body = ErrorResponse.builder()
                .message("Internal error")
                .details(java.util.List.of(ex.getMessage()))
                .build();
        return new ResponseEntity<>(body, HttpStatus.INTERNAL_SERVER_ERROR);
    }

    /**
     * [LOGGING HELPER] Lấy IP thực của client, hỗ trợ reverse proxy.
     */
    private String getClientIp(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isBlank()) {
            return xForwardedFor.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }
}
