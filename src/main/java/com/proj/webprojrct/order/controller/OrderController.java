package com.proj.webprojrct.order.controller;

import com.proj.webprojrct.order.dto.request.OrderRequest;
import com.proj.webprojrct.order.dto.response.OrderResponse;
import com.proj.webprojrct.order.service.OrderService;
import com.proj.webprojrct.payment.vnpay.service.PaymentService;

import jakarta.servlet.http.HttpServletRequest;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.proj.webprojrct.common.ResponseMessage;
import com.proj.webprojrct.common.config.security.CustomUserDetails;
import com.proj.webprojrct.common.config.logging.SecurityEventLogger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/orders")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private PaymentService paymentService;

    // Create order
    @PostMapping("/create")
    public ResponseEntity<?> createOrder(@RequestBody OrderRequest request) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ResponseMessage("Vui lòng đăng nhập để tạo đơn hàng!"));
        }
        try {
            OrderResponse order = orderService.createOrder(userDetails.getUser().getId(), request);
            return ResponseEntity.ok(order);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ResponseMessage("Lỗi khi tạo đơn hàng: " + e.getMessage()));
        }
    }

    // Get order details (only view your own orders)
    @GetMapping("/{orderId}")
    public ResponseEntity<?> getOrder(@PathVariable Long orderId) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ResponseMessage("Vui lòng đăng nhập để xem đơn hàng!"));
        }
        Long currentUserId = userDetails.getUser().getId();
        // add userId to service to check access rights
        try {
            OrderResponse order = orderService.getOrderById(orderId, currentUserId);
            // TODO: Check order.userId == userDetails.getUser().getId() to bảo mật
            return ResponseEntity.ok(order);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ResponseMessage("Lỗi khi lấy đơn hàng: " + e.getMessage()));
        }
    }

    // Get orders by user
    @GetMapping
    public ResponseEntity<?> getOrdersByUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ResponseMessage("Vui lòng đăng nhập để xem đơn hàng!"));
        }
        try {
            List<OrderResponse> orders = orderService.getOrdersByUserId(userDetails.getUser().getId());
            return ResponseEntity.ok(orders);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ResponseMessage("Lỗi khi lấy danh sách đơn hàng: " + e.getMessage()));
        }
    }

    // Cancel order (only view your own orders)
    @PutMapping("/{orderId}/cancel")
    public ResponseEntity<ResponseMessage> cancelOrder(
            @PathVariable Long orderId,
            HttpServletRequest request) {

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ResponseMessage("Vui lòng đăng nhập để thực hiện!"));
        }
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        long currentUserId = userDetails.getUser().getId();

        try {
            // Check payment method and status
            String paymentStatus = paymentService.getPaymentStatusByOrderId(orderId);
            String paymentMethod = paymentService.getPaymentMethodByOrderId(orderId);

            boolean isRefunded = false;

            // If VNPay and payment successful, call refund API
            if ("SUCCESS".equals(paymentStatus) && "VNPAY".equals(paymentMethod)) {
                // Call VNPay refund (100% when user cancels)
                String refundResult = paymentService.handleRefund(orderId, "02", 100, request);

                // Parse JSON result from VNPay
                ObjectMapper mapper = new ObjectMapper();
                JsonNode root = mapper.readTree(refundResult);
                String responseCode = root.path("vnp_ResponseCode").asText();
                String txnStatus = root.path("vnp_TransactionStatus").asText();

                // If refund successful (ResponseCode = 00 and TransactionStatus = 05)
                if ("00".equals(responseCode) && "05".equals(txnStatus)) {
                    isRefunded = true;
                    orderService.cancelOrder(orderId, currentUserId);
                    // [LOGGING] Ghi log hủy đơn hàng VNPay - OWASP A09
                    String username = ((CustomUserDetails) authentication.getPrincipal()).getUsername();
                    SecurityEventLogger.orderCancelled(username, orderId, getClientIp(request), "VNPAY_REFUND");
                    return ResponseEntity.ok(new ResponseMessage(
                            "Đơn hàng đã được hủy và hoàn tiền thành công! Tiền sẽ được hoàn lại vào tài khoản của bạn trong 5-7 ngày làm việc."));
                } else {
                    return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                            .body(new ResponseMessage(
                                    "Hoàn tiền thất bại. Vui lòng liên hệ hỗ trợ. Chi tiết: "
                                            + refundResult));
                }
            } else {
                // COD or not paid - only cancel order
                orderService.cancelOrder(orderId, currentUserId);
                // [LOGGING] Ghi log hủy đơn hàng COD - OWASP A09
                String username = ((CustomUserDetails) authentication.getPrincipal()).getUsername();
                SecurityEventLogger.orderCancelled(username, orderId, getClientIp(request), "COD_CANCEL");
                return ResponseEntity.ok(new ResponseMessage("Đơn hàng đã được hủy thành công!"));
            }

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ResponseMessage("Lỗi khi xử lý hủy đơn hàng: " + e.getMessage()));
        }
    }

    // [LOGGING] Lấy IP thực của client - OWASP A09
    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip != null && !ip.isEmpty() && !"unknown".equalsIgnoreCase(ip)) {
            return ip.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }

    @PutMapping("/{orderId}/refund")
    public ResponseEntity<ResponseMessage> requestRefund(@PathVariable Long orderId) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ResponseMessage("Vui lòng đăng nhập để thực hiện!"));
        }
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        long currentUserId = userDetails.getUser().getId();

        try {
            orderService.refundOrderRequest(orderId, currentUserId);
            return ResponseEntity.ok(new ResponseMessage("Yêu cầu hoàn tiền đã được gửi thành công!"));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new ResponseMessage(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ResponseMessage("Lỗi khi gửi yêu cầu hoàn tiền: " + e.getMessage()));
        }
    }

}
