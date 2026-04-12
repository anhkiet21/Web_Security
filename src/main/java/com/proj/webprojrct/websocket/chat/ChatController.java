package com.proj.webprojrct.websocket.chat;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import com.proj.webprojrct.common.config.security.CustomUserDetails;
import org.springframework.http.HttpStatus;
import com.proj.webprojrct.user.entity.UserRole;
import org.springframework.web.server.ResponseStatusException;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class ChatController {

    private final SimpMessagingTemplate messagingTemplate;
    private final ChatMessageService chatMessageService;
    private final ChatMessageRepository chatMessageRepository;

    @GetMapping("/user/chat")
    public String chatuser() {
        return "chat_user";
    }

    @GetMapping("/admin/chat")
    public String chatadmin(@AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null) {
            return "redirect:/login";
        }
        if (userDetails.getUser().getRole() != UserRole.ADMIN) {
            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN, "Access denied");
        }
        return "admin/chat_admin";
    }

    @MessageMapping("/chat")
    public void processMessage(@Payload ChatMessage chatMessage,
            java.security.Principal principal) {
        // Trong WebSocket STOMP, dÃ¹ng Principal thay vÃ¬ @AuthenticationPrincipal
        // Ä‘á»ƒ trÃ¡nh lá»—i MessageConversionException khi deserialize CustomUserDetails
        if (principal == null) {
            return;
        }
        ChatMessage savedMsg = chatMessageService.save(chatMessage);

        ChatNotification notification = ChatNotification.builder()
                .id(String.valueOf(savedMsg.getId()))
                .senderId(savedMsg.getSenderId())
                .recipientId(savedMsg.getRecipientId())
                .content(savedMsg.getContent())
                .mediaPath(savedMsg.getMediaPath())
                .mediaType(savedMsg.getMediaType())
                .timestamp(savedMsg.getTimestamp())
                .build();

        messagingTemplate.convertAndSendToUser(
                chatMessage.getRecipientId(),
                "/queue/messages",
                notification);

        messagingTemplate.convertAndSendToUser(
                chatMessage.getSenderId(),
                "/queue/messages",
                notification);

    }

    @GetMapping("/messages/{senderId}/{recipientId}")
    public ResponseEntity<List<ChatMessage>> findChatMessages(
            @PathVariable String senderId,
            @PathVariable String recipientId,
            @AuthenticationPrincipal CustomUserDetails userDetails) {

        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        if (!senderId.equals(userDetails.getUsername())) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        try {
            return ResponseEntity
                    .ok(chatMessageService.findChatMessages(senderId, recipientId));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PreAuthorize("hasAnyRole('ADMIN')")
    @GetMapping("/conversations/{recipientId}")
    public ResponseEntity<List<String>> findConversationsForRecipient(
            @PathVariable String recipientId,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        if (!recipientId.equals(userDetails.getUsername())) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        return ResponseEntity.ok(chatMessageService.findConversationUsersForRecipient(recipientId));
    }

    /**
     * API láº¥y sá»‘ lÆ°á»£ng tin nháº¯n chÆ°a Ä‘á»c cho user
     * GET /api/chat/unread-count
     */
    @GetMapping("/api/chat/unread-count")
    public ResponseEntity<Map<String, Object>> getUnreadCount(Authentication authentication) {
        if (authentication == null || authentication.getName() == null) {
            Map<String, Object> response = new HashMap<>();
            response.put("unreadCount", 0L);
            return ResponseEntity.ok(response);
        }

        String userId = authentication.getName();
        Long unreadCount = chatMessageRepository.countUnreadMessagesByRecipientId(userId);

        Map<String, Object> response = new HashMap<>();
        response.put("unreadCount", unreadCount != null ? unreadCount : 0L);
        return ResponseEntity.ok(response);
    }

    /**
     * API Ä‘Ã¡nh dáº¥u tin nháº¯n tá»« admin lÃ  Ä‘Ã£ Ä‘á»c
     * POST /api/chat/mark-read/{senderId}
     */
    @Transactional
    @GetMapping("/api/chat/mark-read/{senderId}")
    public ResponseEntity<Map<String, Object>> markMessagesAsRead(
            @PathVariable String senderId,
            Authentication authentication) {
        if (authentication == null || authentication.getName() == null) {
            return ResponseEntity.ok(Map.of("success", false, "markedCount", 0));
        }

        String userId = authentication.getName();

        int markedCount = chatMessageRepository.markMessagesAsRead(userId, senderId);


        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("markedCount", markedCount);
        return ResponseEntity.ok(response);
    }

}
