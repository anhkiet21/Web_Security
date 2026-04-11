package com.proj.webprojrct.user.dto.request;

import com.proj.webprojrct.user.entity.UserRole;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class UserCreateRequest {

    private UserRole role;
    private String fullname;
    private String email;
    private String phone;
}
