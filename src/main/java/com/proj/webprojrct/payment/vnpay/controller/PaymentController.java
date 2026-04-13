package com.proj.webprojrct.payment.vnpay.controller;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.proj.webprojrct.payment.vnpay.config.Config;

import org.springframework.web.bind.annotation.RestController;

import com.nimbusds.jose.shaded.gson.Gson;
import com.nimbusds.jose.shaded.gson.JsonObject;
import com.proj.webprojrct.payment.dto.response.PaymentResDto;
import com.proj.webprojrct.payment.entity.Payment;
import com.proj.webprojrct.payment.vnpay.service.PaymentService;
import com.proj.webprojrct.order.dto.response.OrderResponse;
import com.proj.webprojrct.order.repository.OrderRepository;
import com.proj.webprojrct.order.service.OrderService;
import com.proj.webprojrct.common.config.security.CustomUserDetails;
import com.proj.webprojrct.user.entity.UserRole;
import com.twilio.http.Response;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 * @author CTT VNPAY
 */
@Controller
@RequiredArgsConstructor
@RequestMapping("/api/vnpay/payment")
public class PaymentController {

    private static final Logger log = LoggerFactory.getLogger(PaymentController.class);

    private final PaymentService paymentService;

    private final OrderRepository orderRepository;

    private final OrderService orderService;

    @GetMapping("/create_payment")
    public ResponseEntity<?> createPayment(@RequestParam("orderId") Long orderId, @RequestParam("method") String method, HttpServletRequest request) throws UnsupportedEncodingException {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("vui lòng đăng nhập để thực hiện thanh toán.");
        }
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getUser().getId();

        // Ownership check đầu tiên — 403 ngay nếu orderId không thuộc user này
        OrderResponse order = orderService.getOrderById(orderId, userId);

        if (order.getStatus().equals("CANCELLED")) {
            return ResponseEntity.status(HttpStatus.OK).body("Đơn hàng đã bị hủy, không thể thanh toán.");
        }
        if (paymentService.existsByOrderId(orderId)) {
            if (!("PENDING".equalsIgnoreCase(paymentService.getPaymentStatusByOrderId(orderId)))) {
                return ResponseEntity.status(HttpStatus.OK).body("Đơn hàng đã được thanh toán thành công hoặc bị hủy.");
            }
        }
        if (("COD").equalsIgnoreCase(paymentService.getPaymentMethodByOrderId(orderId))) {
            return ResponseEntity.status(HttpStatus.OK).body("Đơn hàng đã được thanh toán bằng COD.");
        }
        if (paymentService.getPaymentByOrderId(orderId)) {
            PaymentResDto res = paymentService.getUrlVnpayPayment(orderId);
            return ResponseEntity.status(HttpStatus.OK).body(res);
        }

        if ("COD".equalsIgnoreCase(method)) {
            paymentService.createPaymentCOD(orderId, userId);
            PaymentResDto codResponse = new PaymentResDto();
            codResponse.setStatus("OK");
            codResponse.setMessage("Tạo đơn hàng COD thành công!");
            codResponse.setURL("/order/success/" + orderId); // URL trang thành công của bạn
            return ResponseEntity.status(HttpStatus.OK).body(codResponse);
        }

        PaymentResDto paymentResDto = paymentService.createPaymentUrl(orderId, userId, request);

        return ResponseEntity.status(HttpStatus.OK).body(paymentResDto);
    }

    @GetMapping("/vnpay_return")
    public ResponseEntity<?> handleReturn(HttpServletRequest request) throws Exception {
        Map<String, Object> result = paymentService.handleVnPayReturn(request);
        return ResponseEntity.ok(result);
    }

    @PostMapping("/query")
    public ResponseEntity<String> queryTransaction(
            @RequestParam("order_id") long orderId,
            HttpServletRequest request) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("vui lòng đăng nhập để thực hiện.");
        }
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getUser().getId();

        OrderResponse order = orderService.getOrderById(orderId, userId);


        Payment payment = paymentService.getPaymentByOrderId(orderId);
        if (payment == null || payment.getMethod().equals("COD")) {
            return ResponseEntity.ok("ok");
        }

        try {
            String result = paymentService.handleQuery(orderId,userId, request);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("Lỗi khi query giao dịch orderId={}", orderId, e);
            return ResponseEntity.status(500).body("Lỗi hệ thống khi truy vấn giao dịch. Vui lòng thử lại sau.");
        }
    }

    @PostMapping("/refund")
    public ResponseEntity<String> refundTransaction(
            @RequestParam("order_id") long orderId,
            @RequestParam("trantype") String trantype,
            @RequestParam("percent") int percent,
            HttpServletRequest request) throws MalformedURLException, ProtocolException, IOException, Exception {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("vui lòng đăng nhập để thực hiện.");
        }
        CustomUserDetails refundUser = (CustomUserDetails) authentication.getPrincipal();
        UserRole role = refundUser.getUser().getRole();
        if (role != UserRole.SELLER && role != UserRole.ADMIN) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Chỉ SELLER hoặc ADMIN mới có thể thực hiện hoàn tiền.");
        }
        
        if (!("SUCCESS".equalsIgnoreCase(paymentService.getPaymentStatusByOrderId(orderId)))) {
            return ResponseEntity.status(HttpStatus.OK).body("Đơn hàng chưa được thanh toán, không thể hoàn tiền.");
        }
        String result = paymentService.handleRefund(orderId, trantype, percent, request);
        return ResponseEntity.ok(result);

    }

}
