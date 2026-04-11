package com.proj.webprojrct.auth.dto.request;

import lombok.*;

@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter

public class LoginRequest {

    private String phone;
    private String password;
}
