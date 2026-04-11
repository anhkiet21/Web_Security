package com.proj.webprojrct.order.dto.response;

import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Data
public class OrderResponse {

    private Long orderId;
    private Long userId;
    private String status;
    private BigDecimal totalAmount;
    private String shippingAddress;
    private String createdAt;
    private String cancelNote;
    private List<OrderItemResponse> items;
}
