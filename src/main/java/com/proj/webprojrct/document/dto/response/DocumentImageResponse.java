package com.proj.webprojrct.document.dto.response;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DocumentImageResponse {

    private Long id;
    private String fileName;
    private String fileType;
    private String url; // hoặc base64 nếu muốn gửi trực tiếp
}
