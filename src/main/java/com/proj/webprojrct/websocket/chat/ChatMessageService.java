package com.proj.webprojrct.websocket.chat;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import com.proj.webprojrct.websocket.chatroom.ChatRoomService;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ChatMessageService {
    private final ChatMessageRepository repository;
    private final ChatRoomService chatRoomService;

    public ChatMessage save(ChatMessage chatMessage) {
        var chatId = chatRoomService
                .getChatRoomId(chatMessage.getSenderId(), chatMessage.getRecipientId(), true)
                .orElseThrow(); // You can create your own dedicated exception
        chatMessage.setChatId(chatId);
        if (chatMessage.getTimestamp() == null) {
            chatMessage.setTimestamp(new java.util.Date());
        }
        repository.save(chatMessage);
        return chatMessage;
    }

    public List<ChatMessage> findChatMessages(String senderId, String recipientId) {
        var chatId = chatRoomService.getChatRoomId(senderId, recipientId, false);
        return chatId.map(repository::findByChatId).orElse(new ArrayList<>());
    }

    public List<String> findConversationUsersForRecipient(String recipientId) {
        return repository.findDistinctSenderIdsByRecipientId(recipientId);
    }
}
