package com.proj.webprojrct.product.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO đại diện cho Series sản phẩm (auto-generated từ tên sản phẩm)
 * VD: iPhone 15 Series, Galaxy S24 Series, Redmi Note 13 Series
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProductSeriesDto {
    
    /**
     * Tên series (VD: "iPhone 15", "Galaxy S24", "Redmi Note 13")
     */
    private String seriesName;
    
    /**
     * Brand của series (VD: "Apple", "Samsung", "Xiaomi")
     */
    private String brand;
    
    /**
     * Số lượng sản phẩm trong series
     */
    private Long productCount;
    
    public ProductSeriesDto(String seriesName, String brand) {
        this.seriesName = seriesName;
        this.brand = brand;
        this.productCount = 0L;
    }
}
