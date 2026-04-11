package com.proj.webprojrct.websocket.user;

import org.springframework.messaging.handler.annotation.Header;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import com.proj.webprojrct.common.config.security.CustomUserDetails;
import java.util.Collections;
import java.util.List;

import java.util.Collection;

@RestController
public class UserRegistryController {

    private final UserRegistryService registryService;

    public UserRegistryController(UserRegistryService registryService) {
        this.registryService = registryService;
    }

    @MessageMapping("/user.addUser")
    @SendTo("/user/public")
    public void addUser(@Payload UserSession user, @Header("simpSessionId") String sessionId) {
        registryService.add(sessionId, user);
    }

    @MessageMapping("/user.disconnectUser")
    @SendTo("/user/public")
    public void disconnectUser(@Payload UserSession user, @Header("simpSessionId") String sessionId) {
        registryService.remove(sessionId);
    }

    @PreAuthorize("hasAnyRole('ADMIN')")
    @GetMapping("/users")
    public Collection<UserSession> listUsers(@AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null) {
            return List.of();
        }
        return registryService.listUsers();
    }
}
