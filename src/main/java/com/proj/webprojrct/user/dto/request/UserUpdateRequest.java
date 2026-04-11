package com.proj.webprojrct.user.dto.request;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class UserUpdateRequest {

    private String address;
    private String fullname;
    private String email;
}
