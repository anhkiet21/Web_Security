package com.proj.webprojrct.document.dto.request;

import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class DocumentCreateRequest {

    private String title;
    private String description; // HTML content
    private long productId;
}
