package com.proj.webprojrct.auth.dto.request;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ChangePassRequest {

    private String password;
    private String newPassword;
    private String confirmNewPassword;
}
