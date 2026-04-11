package com.proj.webprojrct.websocket.chat;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

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
    public String chatadmin() {
        return "admin/chat_admin"; 
    }




    @MessageMapping("/chat")
    public void processMessage(@Payload ChatMessage chatMessage) {
    
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
            notification
        );
  
        messagingTemplate.convertAndSendToUser(
            chatMessage.getSenderId(), 
            "/queue/messages", 
            notification
        );
        
       
    }

  
    @GetMapping("/messages/{senderId}/{recipientId}")
    public ResponseEntity<List<ChatMessage>> findChatMessages(
        @PathVariable String senderId,
        @PathVariable String recipientId) 
    {
       
        return ResponseEntity
            .ok(chatMessageService.findChatMessages(senderId, recipientId));
    }
    
 
    @GetMapping("/conversations/{recipientId}")
    public ResponseEntity<List<String>> findConversationsForRecipient(@PathVariable String recipientId) {
        return ResponseEntity.ok(chatMessageService.findConversationUsersForRecipient(recipientId));
    }

    /**
     * API lấy số lượng tin nhắn chưa đọc cho user
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
     * API đánh dấu tin nhắn từ admin là đã đọc
     * POST /api/chat/mark-read/{senderId}
     */
    @Transactional
    @GetMapping("/api/chat/mark-read/{senderId}")
    public ResponseEntity<Map<String, Object>> markMessagesAsRead(
        @PathVariable String senderId,
        Authentication authentication
    ) {
        if (authentication == null || authentication.getName() == null) {
            System.out.println("[ChatController] Mark-read failed: No authentication");
            return ResponseEntity.ok(Map.of("success", false, "markedCount", 0));
        }

        String userId = authentication.getName();
        System.out.println("[ChatController] Marking messages as read - userId: " + userId + ", senderId: " + senderId);
        
        int markedCount = chatMessageRepository.markMessagesAsRead(userId, senderId);
        
        System.out.println("[ChatController] Marked " + markedCount + " messages as read");

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("markedCount", markedCount);
        return ResponseEntity.ok(response);
    }

  
}