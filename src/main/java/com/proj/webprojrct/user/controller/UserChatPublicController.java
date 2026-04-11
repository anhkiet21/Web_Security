package com.proj.webprojrct.user.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.service.UserService;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
public class UserChatPublicController {

    private final UserService userService;

    @GetMapping("/admins")
    public ResponseEntity<List<User>> getAdmins() {
        List<User> admins = userService.findAdmins();
        return ResponseEntity.ok(admins);
    }

    @GetMapping("/{phone}")
    public ResponseEntity<?> getUserByPhone(Authentication authentication, @PathVariable String phone) {
        try {
            var resp = userService.handleGetUserByPhone(authentication, phone);
            return ResponseEntity.ok(resp);
        } catch (RuntimeException e) {
            return ResponseEntity.status(404).body(Map.of("error", e.getMessage()));
        }
    }
}
