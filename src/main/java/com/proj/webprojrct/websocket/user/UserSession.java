package com.proj.webprojrct.websocket.user;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserSession {
    private String nickName;
    private String fullName;
    private String status;
    private String sessionId;
    private String role; // e.g. ADMIN or USER
}
