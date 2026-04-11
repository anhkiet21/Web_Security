package com.proj.webprojrct.websocket.chat;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ChatMessageRepository extends JpaRepository<ChatMessage, Long> {
    List<ChatMessage> findByChatId(String chatId);
    
    @Query("SELECT DISTINCT c.senderId FROM ChatMessage c WHERE c.recipientId = :recipientId")
    List<String> findDistinctSenderIdsByRecipientId(@Param("recipientId") String recipientId);
    
    // Đếm tổng số tin nhắn chưa đọc của admin
    @Query("SELECT COUNT(c) FROM ChatMessage c WHERE c.recipientId = :adminId AND c.isRead = false")
    Long countUnreadMessagesByRecipientId(@Param("adminId") String adminId);
    
    // Đếm số tin nhắn chưa đọc theo từng user gửi đến admin
    @Query("SELECT c.senderId as senderId, COUNT(c) as count FROM ChatMessage c " +
           "WHERE c.recipientId = :adminId AND c.isRead = false " +
           "GROUP BY c.senderId")
    List<Object[]> countUnreadMessagesBySender(@Param("adminId") String adminId);
    
    // Đánh dấu tất cả tin nhắn từ một user là đã đọc
    @Modifying
    @Query("UPDATE ChatMessage c SET c.isRead = true " +
           "WHERE c.recipientId = :adminId AND c.senderId = :senderId AND c.isRead = false")
    int markMessagesAsRead(@Param("adminId") String adminId, @Param("senderId") String senderId);
}
