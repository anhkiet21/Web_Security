package com.proj.webprojrct.payment.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.proj.webprojrct.payment.entity.PaymentUrlVnpay;

@Repository
public interface PaymentUrlVnpayRepository extends JpaRepository<PaymentUrlVnpay, Long> {

    PaymentUrlVnpay findByOrderId(Long orderId);
}
