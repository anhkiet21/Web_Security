package com.proj.webprojrct.user.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.proj.webprojrct.common.config.security.CustomUserDetails;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import com.proj.webprojrct.user.service.UserService;
import org.springframework.http.HttpStatus;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
public class UserChatPublicController {

    private final UserService userService;

    @GetMapping("/admins")
    public ResponseEntity<List<String>> getAdmins(@AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        List<String> adminPhones = userService.findAdmins();
        return ResponseEntity.ok(adminPhones);
    }

    @GetMapping("/{phone}")
    public ResponseEntity<?> getUserByPhone(Authentication authentication, @PathVariable String phone) {
        try {
            var resp = userService.handleGetUserByPhone(authentication, phone);
            return ResponseEntity.ok(resp);
        } catch (RuntimeException e) {
            return ResponseEntity.status(404).body(Map.of("error", "Không tìm thấy người dùng."));
        }
    }
}
