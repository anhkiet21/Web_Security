package com.proj.webprojrct.payment.dto.request;

import java.math.BigDecimal;
import lombok.Data;

@Data
public class PaymentRequest {

    private Long orderId;
    private String method;
    private BigDecimal amount;
}
