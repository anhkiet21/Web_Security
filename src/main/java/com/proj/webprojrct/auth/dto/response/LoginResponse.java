package com.proj.webprojrct.auth.dto.response;

import lombok.*;
import com.proj.webprojrct.user.entity.User;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class LoginResponse {

    private User user;
    private String accessToken;
    private String refreshToken;

}
