package com.proj.webprojrct.document.dto.response;

import com.proj.webprojrct.document.entity.Document;

public class DocumentPublicResponse {
    private Long id;
    private String title;
    private String description;
    private Long productId;
    
    public DocumentPublicResponse() {
    }
    
    public DocumentPublicResponse(Document document) {
        this.id = document.getId();
        this.title = document.getTitle();
        this.description = document.getDescription();
        this.productId = document.getProductId();
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public Long getProductId() {
        return productId;
    }
    
    public void setProductId(Long productId) {
        this.productId = productId;
    }
}
