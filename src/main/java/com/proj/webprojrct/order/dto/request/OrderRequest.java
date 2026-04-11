package com.proj.webprojrct.order.dto.request;

import lombok.*;
import java.math.BigDecimal;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Data
public class OrderRequest {

    private List<OrderItemRequest> orderItems;
    private BigDecimal totalAmount;
    private String shippingAddress;
    private String fullName;
    private String phone;
    private String notes;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Data
    public static class OrderItemRequest {
        private Long productId;
        private Integer quantity;
        private BigDecimal price;
    }
}
