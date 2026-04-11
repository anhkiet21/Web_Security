package com.proj.webprojrct.payment.dto.response;

import java.io.Serializable;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class PaymentResDto implements Serializable {

    private String status;
    private String message;
    private String URL;

}
