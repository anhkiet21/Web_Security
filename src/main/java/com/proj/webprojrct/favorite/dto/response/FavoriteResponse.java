package com.proj.webprojrct.favorite.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class FavoriteResponse {

    private Long id;
    private Long userId;
    private Long productId;
    private String productName;
    private Double productPrice;
    private String productImageUrl;
    private Integer productStock;
    private String productBrand;
    private Integer dealPercentage;
    private Boolean productIsActive;
    private LocalDateTime createdAt;
}
