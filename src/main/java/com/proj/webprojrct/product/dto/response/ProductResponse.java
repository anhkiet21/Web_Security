package com.proj.webprojrct.product.dto.response;

import com.proj.webprojrct.category.dto.CategoryDto;
import com.proj.webprojrct.product.dto.SpecDto;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor @Builder
public class ProductResponse {

    private Long id;
    private String name;
    private String brand;
    private BigDecimal price;
    private Integer stock;
    private LocalDateTime createdAt;
    private String imageUrl;
    private java.util.List<String> imageUrls;
    private java.util.List<com.proj.webprojrct.product.dto.ImageDto> images;
    private CategoryDto category;
    private List<SpecDto> specs;

    private String screenSize;
    private String displayTech;
    private String resolution;
    private String displayFeatures;
    private String rearCamera;
    private String frontCamera;
    private String chipset;
    private String cpuSpecs;
    private String ram;
    private String storage;
    private String battery;
    private String simType;
    private String os;
    private String nfcSupport;
    private Boolean onDeal;
    private Integer dealPercentage;
    private Boolean isActive;
}
