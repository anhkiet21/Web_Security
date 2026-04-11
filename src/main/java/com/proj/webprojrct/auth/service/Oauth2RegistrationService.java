package com.proj.webprojrct.auth.service;

import java.security.SecureRandom;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.proj.webprojrct.auth.dto.request.RegisterRequest;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.entity.UserRole;
import com.proj.webprojrct.user.repository.UserRepository;

@Service
public class Oauth2RegistrationService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public Oauth2RegistrationService(UserRepository userRepository,
            PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    /**
     * Lưu user mới từ OAuth2 + thông tin bổ sung
     */
    @Transactional
    public User registerNewUser(RegisterRequest registerRequest) {
        if (userRepository.findByEmail(registerRequest.getEmail()).isPresent()) {
            throw new RuntimeException("Email đã tồn tại: " + registerRequest.getEmail());
        }

        String generationPassword = generateRandomPassword(12);

        if (userRepository.findByPhone(registerRequest.getPhone()).isPresent()) {
            throw new RuntimeException("Số điện thoại đã tồn tại: " + registerRequest.getPhone());
        }
        User user = new User();
        user.setFullName(registerRequest.getFullName());
        user.setEmail(registerRequest.getEmail());
        user.setPhone(registerRequest.getPhone());
        user.setAddress(registerRequest.getAddress());
        user.setPasswordHash(passwordEncoder.encode(generationPassword));
        user.setRole(UserRole.USER);
        user.setIsActive(true);
        user.setVerifyEmail(true);

        return userRepository.save(user);
    }

    public String generateRandomPassword(int length) {
        final String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-_";
        SecureRandom random = new SecureRandom();
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            int index = random.nextInt(chars.length());
            sb.append(chars.charAt(index));
        }
        return sb.toString();
    }
}
