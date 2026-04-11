package com.proj.webprojrct.payment.entity;

import java.math.BigDecimal;

import com.proj.webprojrct.order.entity.Order;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.*;

@Entity
@Table(name = "payment_url_vnpay")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@Setter
public class PaymentUrlVnpay {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long paymentUrlId;

    @Column(name = "order_id", nullable = false, unique = true)
    private long orderId;

    @Column(name = "payment_url", length = 1000)
    private String paymentUrl;

    @Column(name = "created_at", nullable = false)
    private String createdAt;

    @Column(name = "expires_at", nullable = false)
    private String expiresAt;
}
