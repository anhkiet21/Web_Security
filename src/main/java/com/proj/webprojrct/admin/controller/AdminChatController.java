package com.proj.webprojrct.admin.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import com.proj.webprojrct.common.config.security.CustomUserDetails;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.entity.UserRole;
import com.proj.webprojrct.websocket.chat.ChatMessageRepository;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/admin/api/chat")
public class AdminChatController {

    @Autowired
    private ChatMessageRepository chatMessageRepository;

    /**
     * API láº¥y thá»‘ng kÃª tin nháº¯n chÆ°a Ä‘á»c GET /admin/api/chat/unread-stats
     * Response: {totalUnread: 5, userCounts: {userId1: 3, userId2: 2}}
     */
    @GetMapping("/unread-stats")
    public ResponseEntity<Map<String, Object>> getUnreadStats(Authentication authentication) {

        authentication = SecurityContextHolder.getContext().getAuthentication();

        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() != UserRole.ADMIN) {
            return ResponseEntity.status(403)
                    .body(Map.of("error", "Access denied: Only ADMIN users can access category management."));
        }

        if (authentication == null || authentication.getName() == null) {
            Map<String, Object> emptyResponse = new HashMap<>();
            emptyResponse.put("totalUnread", 0L);
            emptyResponse.put("userCounts", new HashMap<>());
            return ResponseEntity.ok(emptyResponse);
        }

        String adminId = authentication.getName(); // Username cá»§a admin

        // Äáº¿m tá»•ng sá»‘ tin nháº¯n chÆ°a Ä‘á»c
        Long totalUnread = chatMessageRepository.countUnreadMessagesByRecipientId(adminId);

        // Äáº¿m theo tá»«ng user
        List<Object[]> unreadBySender = chatMessageRepository.countUnreadMessagesBySender(adminId);
        Map<String, Long> userCounts = new HashMap<>();
        for (Object[] row : unreadBySender) {
            String senderId = (String) row[0];
            Long count = (Long) row[1];
            userCounts.put(senderId, count);
        }

        Map<String, Object> response = new HashMap<>();
        response.put("totalUnread", totalUnread != null ? totalUnread : 0L);
        response.put("userCounts", userCounts);

        return ResponseEntity.ok(response);
    }

    /**
     * API Ä‘Ã¡nh dáº¥u táº¥t cáº£ tin nháº¯n tá»« má»™t user lÃ  Ä‘Ã£ Ä‘á»c POST
     * /admin/api/chat/mark-all-read/{userId}
     */
    @PostMapping("/mark-all-read/{userId}")
    @Transactional
    public ResponseEntity<Map<String, Object>> markAllAsRead(
            @PathVariable String userId,
            Authentication authentication) {
        authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() != UserRole.ADMIN) {
            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN, "Access denied");
        }

        String adminId = authentication.getName();

        int updatedCount = chatMessageRepository.markMessagesAsRead(adminId, userId);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("markedCount", updatedCount);

        return ResponseEntity.ok(response);
    }
}
