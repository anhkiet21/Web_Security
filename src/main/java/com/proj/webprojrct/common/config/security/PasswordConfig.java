package com.proj.webprojrct.common.config.security;

import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
public class PasswordConfig {

    private static final String UPPER   = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    private static final String LOWER   = "abcdefghijklmnopqrstuvwxyz";
    private static final String DIGITS  = "0123456789";
    private static final String SPECIAL = "@#$%!^&*";
    // [FIX A04] PASSWORD_LENGTH tăng từ 10 lên 12 để đảm bảo policy tối thiểu 12 ký tự
    private static final int PASSWORD_LENGTH = 12;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    /**
     * [FIX A04]
     */
    public static String generateRandomPassword() {
        SecureRandom random = new SecureRandom();
        List<Character> chars = new ArrayList<>(PASSWORD_LENGTH);

        // Đảm bảo ít nhất 1 ký tự mỗi loại bắt buộc
        chars.add(UPPER.charAt(random.nextInt(UPPER.length())));
        chars.add(LOWER.charAt(random.nextInt(LOWER.length())));
        chars.add(DIGITS.charAt(random.nextInt(DIGITS.length())));
        chars.add(SPECIAL.charAt(random.nextInt(SPECIAL.length())));

        // Điền phần còn lại từ toàn bộ bộ ký tự
        String ALL = UPPER + LOWER + DIGITS + SPECIAL;
        for (int i = 4; i < PASSWORD_LENGTH; i++) {
            chars.add(ALL.charAt(random.nextInt(ALL.length())));
        }

        // Xáo trộn để tránh vị trí ký tự bắt buộc cố định (dễ đoán pattern)
        Collections.shuffle(chars, random);

        StringBuilder sb = new StringBuilder(PASSWORD_LENGTH);
        for (char c : chars) sb.append(c);
        return sb.toString();
    }
}
