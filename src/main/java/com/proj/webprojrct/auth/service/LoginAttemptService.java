package com.proj.webprojrct.auth.service;

import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.concurrent.ConcurrentHashMap;

/**
 * FIX V-09: Chống brute force bằng cách đếm số lần đăng nhập sai.
 * Sau 5 lần thất bại → khoá 15 phút.
 */
@Service
public class LoginAttemptService {

    private static final int MAX_ATTEMPTS = 5;
    private static final int LOCKOUT_MINUTES = 15;

    private record AttemptInfo(int count, LocalDateTime lockedUntil) {}

    private final ConcurrentHashMap<String, AttemptInfo> attemptCache = new ConcurrentHashMap<>();

    /** Trả về true nếu tài khoản đang bị khoá */
    public boolean isBlocked(String phone) {
        AttemptInfo info = attemptCache.get(phone);
        if (info == null) return false;
        if (info.lockedUntil() != null && LocalDateTime.now().isBefore(info.lockedUntil())) {
            return true;
        }
        // Hết thời gian khoá, xoá cache
        if (info.lockedUntil() != null) {
            attemptCache.remove(phone);
        }
        return false;
    }

    /** Gọi khi đăng nhập thất bại */
    public void loginFailed(String phone) {
        AttemptInfo current = attemptCache.getOrDefault(phone, new AttemptInfo(0, null));
        int newCount = current.count() + 1;
        LocalDateTime lockedUntil = (newCount >= MAX_ATTEMPTS)
                ? LocalDateTime.now().plusMinutes(LOCKOUT_MINUTES)
                : null;
        attemptCache.put(phone, new AttemptInfo(newCount, lockedUntil));
    }

    /** Gọi khi đăng nhập thành công — xoá bộ đếm */
    public void loginSucceeded(String phone) {
        attemptCache.remove(phone);
    }

    /** Trả về thời gian còn lại (phút) của lệnh khoá, 0 nếu chưa bị khoá */
    public long getRemainingLockMinutes(String phone) {
        AttemptInfo info = attemptCache.get(phone);
        if (info == null || info.lockedUntil() == null) return 0;
        long remaining = java.time.Duration.between(LocalDateTime.now(), info.lockedUntil()).toMinutes() + 1;
        return Math.max(remaining, 0);
    }
}
