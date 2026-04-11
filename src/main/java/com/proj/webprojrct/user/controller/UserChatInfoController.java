package com.proj.webprojrct.user.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.proj.webprojrct.user.dto.response.UserResponse;
import com.proj.webprojrct.user.service.UserService;

import lombok.RequiredArgsConstructor;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class UserChatInfoController {

    private final UserService userService;

    @GetMapping("/me")
    public ResponseEntity<?> me() {
        try {
            var auth = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
            UserResponse ur = userService.handleGetUserProfile(auth);
            Map<String, Object> resp = new HashMap<>();
            resp.put("authenticated", true);
            resp.put("phone", ur.getPhone());
            resp.put("email", ur.getEmail());
            resp.put("fullName", ur.getFullname());
            String role = "USER";
            var secAuth = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
            if (secAuth != null && secAuth.isAuthenticated()) {
                role = secAuth.getAuthorities().stream()
                        .map(a -> a.getAuthority())
                        .filter(a -> a.startsWith("ROLE_"))
                        .findFirst()
                        .map(r -> r.replace("ROLE_", "")).orElse("USER");
            }
            resp.put("role", role);
            return ResponseEntity.ok(resp);
        } catch (RuntimeException e) {
            return ResponseEntity.ok(Map.of("authenticated", false));
        }
    }
}
