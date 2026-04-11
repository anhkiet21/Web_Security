package com.proj.webprojrct.document.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.proj.webprojrct.document.entity.Document;
import com.proj.webprojrct.document.dto.response.DocumentPublicResponse;
import com.proj.webprojrct.document.service.DocumentService;

@RestController
@RequestMapping("/api/documents")
public class PublicDocumentController {

    @Autowired
    private DocumentService documentService;
    
    /**
     * Public API endpoint để lấy document theo productId
     * Được sử dụng trong trang product detail (không yêu cầu authentication)
     */
    @GetMapping("/product/{productId}")
    public ResponseEntity<?> getDocumentByProductId(@PathVariable Long productId) {
        try {
            Document document = documentService.getDocumentByProductId(productId);
            if (document == null) {
                return ResponseEntity.notFound().build();
            }
            // Chuyển đổi sang DTO để tránh circular reference và chỉ trả về data cần thiết
            DocumentPublicResponse response = new DocumentPublicResponse(document);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(Map.of("error", e.getMessage()));
        }
    }
}
