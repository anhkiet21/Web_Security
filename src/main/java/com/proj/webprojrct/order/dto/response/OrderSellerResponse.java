package com.proj.webprojrct.order.dto.response;

import lombok.*;
import java.math.BigDecimal;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Data

public class OrderSellerResponse {

    private Long orderId;
    private Long userId;
    private String status;
    private String paymentStatus;
    private String paymentMethod;
    private BigDecimal totalAmount;
    private String shippingAddress;
    private String createdAt;
    private List<OrderItemResponse> items;
}
