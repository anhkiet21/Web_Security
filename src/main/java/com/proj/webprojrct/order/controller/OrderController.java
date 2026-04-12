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

    // Táº¡o Ä‘Æ¡n hÃ ng má»›i
    @PostMapping("/create")
    public ResponseEntity<?> createOrder(@RequestBody OrderRequest request) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ResponseMessage("Vui lÃ²ng Ä‘Äƒng nháº­p Ä‘á»ƒ táº¡o Ä‘Æ¡n hÃ ng!"));
        }
            try{
            OrderResponse order = orderService.createOrder(userDetails.getUser().getId(), request);
            return ResponseEntity.ok(order);
        }catch(Exception e){
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ResponseMessage("Lá»—i khi táº¡o Ä‘Æ¡n hÃ ng: " + e.getMessage()));
        }
    }

    // Láº¥y chi tiáº¿t Ä‘Æ¡n hÃ ng (chá»‰ Ä‘Æ°á»£c xem Ä‘Æ¡n cá»§a mÃ¬nh)
    @GetMapping("/{orderId}")
    public ResponseEntity<?> getOrder(@PathVariable Long orderId) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ResponseMessage("Vui lÃ²ng Ä‘Äƒng nháº­p Ä‘á»ƒ xem Ä‘Æ¡n hÃ ng!"));
        }
        Long currentUserId = userDetails.getUser().getId();
        //thÃªm userId vÃ o service Ä‘á»ƒ kiá»ƒm tra quyá»n truy cáº­p
        try{
            OrderResponse order = orderService.getOrderById(orderId, currentUserId);
            // TODO: Kiá»ƒm tra order.userId == userDetails.getUser().getId() Ä‘á»ƒ báº£o máº­t
            return ResponseEntity.ok(order);
        }catch(Exception e){
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ResponseMessage("Lá»—i khi láº¥y Ä‘Æ¡n hÃ ng: " + e.getMessage()));
        }   
    }

    // Láº¥y danh sÃ¡ch Ä‘Æ¡n hÃ ng cá»§a user Ä‘ang login
    @GetMapping
    public ResponseEntity<?> getOrdersByUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ResponseMessage("Vui lÃ²ng Ä‘Äƒng nháº­p Ä‘á»ƒ xem Ä‘Æ¡n hÃ ng!"));
        }
        try{
            List<OrderResponse> orders = orderService.getOrdersByUserId(userDetails.getUser().getId());
            return ResponseEntity.ok(orders);
        }catch(Exception e){
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ResponseMessage("Lá»—i khi láº¥y danh sÃ¡ch Ä‘Æ¡n hÃ ng: " + e.getMessage()));
        }
    }

    // Há»§y Ä‘Æ¡n hÃ ng (chá»‰ Ä‘Æ°á»£c há»§y Ä‘Æ¡n cá»§a mÃ¬nh)
    @PutMapping("/{orderId}/cancel")
    public ResponseEntity<ResponseMessage> cancelOrder(
            @PathVariable Long orderId,
            HttpServletRequest request) {

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ResponseMessage("Vui lÃ²ng Ä‘Äƒng nháº­p Ä‘á»ƒ thá»±c hiá»‡n!"));
        }
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        long currentUserId = userDetails.getUser().getId();

        try {
            // Kiá»ƒm tra phÆ°Æ¡ng thá»©c thanh toÃ¡n vÃ  tráº¡ng thÃ¡i
            String paymentStatus = paymentService.getPaymentStatusByOrderId(orderId);
            String paymentMethod = paymentService.getPaymentMethodByOrderId(orderId);

            boolean isRefunded = false;

            // Náº¿u lÃ  VNPay vÃ  Ä‘Ã£ thanh toÃ¡n thÃ nh cÃ´ng, gá»i API hoÃ n tiá»n
            if ("SUCCESS".equals(paymentStatus) && "VNPAY".equals(paymentMethod)) {
                // Gá»i VNPay refund (100% khi user há»§y)
                String refundResult = paymentService.handleRefund(orderId, "02", 100, request);

                // Parse JSON káº¿t quáº£ tá»« VNPay
                ObjectMapper mapper = new ObjectMapper();
                JsonNode root = mapper.readTree(refundResult);
                String responseCode = root.path("vnp_ResponseCode").asText();
                String txnStatus = root.path("vnp_TransactionStatus").asText();

                // Náº¿u refund thÃ nh cÃ´ng (ResponseCode = 00 vÃ  TransactionStatus = 05)
                if ("00".equals(responseCode) && "05".equals(txnStatus)) {
                    isRefunded = true;
                    orderService.cancelOrder(orderId,currentUserId);
                    return ResponseEntity.ok(new ResponseMessage("ÄÆ¡n hÃ ng Ä‘Ã£ Ä‘Æ°á»£c há»§y vÃ  hoÃ n tiá»n thÃ nh cÃ´ng! Tiá»n sáº½ Ä‘Æ°á»£c hoÃ n láº¡i vÃ o tÃ i khoáº£n cá»§a báº¡n trong 5-7 ngÃ y lÃ m viá»‡c."));
                } else {
                    return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                            .body(new ResponseMessage("HoÃ n tiá»n tháº¥t báº¡i. Vui lÃ²ng liÃªn há»‡ há»— trá»£. Chi tiáº¿t: " + refundResult));
                }
            } else {
                // COD hoáº·c chÆ°a thanh toÃ¡n - chá»‰ há»§y Ä‘Æ¡n
                orderService.cancelOrder(orderId,currentUserId );
                return ResponseEntity.ok(new ResponseMessage("ÄÆ¡n hÃ ng Ä‘Ã£ Ä‘Æ°á»£c há»§y thÃ nh cÃ´ng!"));
            }

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ResponseMessage("Lá»—i khi xá»­ lÃ½ há»§y Ä‘Æ¡n hÃ ng: " + e.getMessage()));
        }
    }

    @PutMapping("/{orderId}/refund")
    public ResponseEntity<ResponseMessage> requestRefund(@PathVariable Long orderId) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ResponseMessage("Vui lÃ²ng Ä‘Äƒng nháº­p Ä‘á»ƒ thá»±c hiá»‡n!"));
        }
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        long currentUserId = userDetails.getUser().getId();

        try {
            orderService.refundOrderRequest(orderId, currentUserId);
            return ResponseEntity.ok(new ResponseMessage("YÃªu cáº§u hoÃ n tiá»n Ä‘Ã£ Ä‘Æ°á»£c gá»­i thÃ nh cÃ´ng!"));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new ResponseMessage(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ResponseMessage("Lá»—i khi gá»­i yÃªu cáº§u hoÃ n tiá»n: " + e.getMessage()));
        }
    }

}
