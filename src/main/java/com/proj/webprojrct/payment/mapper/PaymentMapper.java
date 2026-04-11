package com.proj.webprojrct.payment.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

import com.proj.webprojrct.payment.dto.response.PaymentResponse;
import com.proj.webprojrct.payment.dto.request.PaymentRequest;
import com.proj.webprojrct.payment.entity.Payment;

@Mapper(componentModel = "spring")
public interface PaymentMapper {

    Payment toEntity(PaymentRequest paymentRequest);

    PaymentResponse toDto(Payment payment);
}
