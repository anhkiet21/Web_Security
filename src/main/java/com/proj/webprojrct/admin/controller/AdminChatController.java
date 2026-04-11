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

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/admin/api/chat")
public class AdminChatController {

    @Autowired
    private ChatMessageRepository chatMessageRepository;

    /**
     * API lấy thống kê tin nhắn chưa đọc GET /admin/api/chat/unread-stats
     * Response: {totalUnread: 5, userCounts: {userId1: 3, userId2: 2}}
     */
    @GetMapping("/unread-stats")
    public ResponseEntity<Map<String, Object>> getUnreadStats(Authentication authentication) {

        authentication = SecurityContextHolder.getContext().getAuthentication();

        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Access denied: Only ADMIN users can access category management.");
        }

        if (authentication == null || authentication.getName() == null) {
            System.out.println("[AdminChatController] No authentication found");
            Map<String, Object> emptyResponse = new HashMap<>();
            emptyResponse.put("totalUnread", 0L);
            emptyResponse.put("userCounts", new HashMap<>());
            return ResponseEntity.ok(emptyResponse);
        }

        String adminId = authentication.getName(); // Username của admin
        System.out.println("[AdminChatController] Getting unread stats for admin: " + adminId);

        // Đếm tổng số tin nhắn chưa đọc
        Long totalUnread = chatMessageRepository.countUnreadMessagesByRecipientId(adminId);
        System.out.println("[AdminChatController] Total unread: " + totalUnread);

        // Đếm theo từng user
        List<Object[]> unreadBySender = chatMessageRepository.countUnreadMessagesBySender(adminId);
        Map<String, Long> userCounts = new HashMap<>();
        for (Object[] row : unreadBySender) {
            String senderId = (String) row[0];
            Long count = (Long) row[1];
            userCounts.put(senderId, count);
        }
        System.out.println("[AdminChatController] User counts: " + userCounts);

        Map<String, Object> response = new HashMap<>();
        response.put("totalUnread", totalUnread != null ? totalUnread : 0L);
        response.put("userCounts", userCounts);

        return ResponseEntity.ok(response);
    }

    /**
     * API đánh dấu tất cả tin nhắn từ một user là đã đọc POST
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
            throw new RuntimeException("Access denied: Only ADMIN users can access category management.");
        }

        String adminId = authentication.getName();

        int updatedCount = chatMessageRepository.markMessagesAsRead(adminId, userId);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("markedCount", updatedCount);

        return ResponseEntity.ok(response);
    }
}
