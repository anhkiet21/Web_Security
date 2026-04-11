package com.proj.webprojrct.order.service;

import com.proj.webprojrct.order.dto.request.OrderRequest;
import com.proj.webprojrct.order.dto.response.OrderResponse;
import com.proj.webprojrct.payment.entity.Payment;
import com.proj.webprojrct.order.entity.Order;
import java.util.List;

public interface OrderService {

    OrderResponse createOrder(Long userId, OrderRequest request);

    OrderResponse getOrderById(Long orderId);

    List<OrderResponse> getOrdersByUserId(Long userId);

    void cancelOrder(Long orderId);

    Payment updateOrderPayment(Long orderId);

    Order getOrderByOrderId(Long orderId);

    // Get user statistics
    int getTotalOrdersByUserId(Long userId);

    double getTotalSpentByUserId(Long userId);

    // cập nhât số lượng
    void updateProductStockAfterPayment(Long orderId);

    void refundOrderRequest(Long orderId);
}
