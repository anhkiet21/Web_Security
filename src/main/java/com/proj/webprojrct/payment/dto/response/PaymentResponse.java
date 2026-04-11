package com.proj.webprojrct.payment.dto.response;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import lombok.Data;

@Data
public class PaymentResponse {

    private Long paymentId;
    private Long orderId;
    private String method;
    private BigDecimal amount;
    private String status;
    private LocalDateTime paidAt;
}
