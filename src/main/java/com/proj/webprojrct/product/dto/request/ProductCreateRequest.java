package com.proj.webprojrct.product.dto.request;

import com.proj.webprojrct.product.dto.SpecDto;
import jakarta.validation.constraints.*;
import lombok.*;
import java.math.BigDecimal;
import java.util.List;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor @Builder
public class ProductCreateRequest {

    @NotBlank private String name;
    @NotBlank private String brand;
    @NotNull @Positive private BigDecimal price;
    @NotNull @PositiveOrZero private Integer stock;

    private List<SpecDto> specs;
    private Long categoryId;
    private String imageUrl;

    // Thông số kỹ thuật
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
}
