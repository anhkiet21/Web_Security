package com.proj.webprojrct.cart.dto.response;

import lombok.*;
import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Data
public class CartResponse {

    private Long cartId;
    private Long userId;
    private LocalDateTime createdAt;
    private List<CartItemResponse> items;
}
