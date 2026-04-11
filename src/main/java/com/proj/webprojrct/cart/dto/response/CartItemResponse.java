package com.proj.webprojrct.cart.dto.response;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Data
public class CartItemResponse {
    private Long cartItemId;
    private Long cartId;
    private Long productId;
    private Integer quantity;
    
    // Thông tin sản phẩm để hiển thị
    private String productName;
    private Double productPrice;
    private String productImageUrl;
    private Integer productStock; // Thêm field stock
    private Boolean productOnDeal; // Thêm field onDeal
    private Integer productDealPercentage; // Thêm field dealPercentage

    private Boolean productIsActive; // Thêm trạng thái hoạt động

    public Boolean getProductIsActive() {
        return productIsActive;
    }

    public void setProductIsActive(Boolean productIsActive) {
        this.productIsActive = productIsActive;
    }
}
