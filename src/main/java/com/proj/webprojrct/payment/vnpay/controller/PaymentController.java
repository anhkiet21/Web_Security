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
import com.proj.webprojrct.order.repository.OrderRepository;
import com.proj.webprojrct.order.service.OrderService;
import com.twilio.http.Response;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;

/**
 *
 * @author CTT VNPAY
 */
@Controller
@RequiredArgsConstructor
@RequestMapping("/api/vnpay/payment")
public class PaymentController {

    private final PaymentService paymentService;

    private final OrderRepository orderRepository;

    private final OrderService orderService;

    @GetMapping("/create_payment")
    public ResponseEntity<?> createPayment(@RequestParam("orderId") Long orderId, @RequestParam("method") String method, HttpServletRequest request) throws UnsupportedEncodingException {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("vui lòng đăng nhập để thực hiện thanh toán.");
        }
        if (paymentService.existsByOrderId(orderId)) {
            if (!("PENDING".equalsIgnoreCase(paymentService.getPaymentStatusByOrderId(orderId)))) {
                return ResponseEntity.status(HttpStatus.OK).body("Đơn hàng đã được thanh toán thành công hoặc bị hủy.");
            }
        }
        System.out.println(orderService.getOrderById(orderId).getStatus());
        if (orderService.getOrderById(orderId).getStatus().equals("CANCELLED")) {
            return ResponseEntity.status(HttpStatus.OK).body("Đơn hàng đã bị hủy, không thể thanh toán.");
        }
        if (("COD").equalsIgnoreCase(paymentService.getPaymentMethodByOrderId(orderId))) {
            return ResponseEntity.status(HttpStatus.OK).body("Đơn hàng đã được thanh toán bằng COD.");
        }
        if (paymentService.getPaymentByOrderId(orderId)) {
            PaymentResDto res = paymentService.getUrlVnpayPayment(orderId);
            return ResponseEntity.status(HttpStatus.OK).body(res);
        }

        if ("COD".equalsIgnoreCase(method)) {
            paymentService.createPaymentCOD(orderId);
            PaymentResDto codResponse = new PaymentResDto();
            codResponse.setStatus("OK");
            codResponse.setMessage("Tạo đơn hàng COD thành công!");
            codResponse.setURL("/order/success/" + orderId); // URL trang thành công của bạn
            return ResponseEntity.status(HttpStatus.OK).body(codResponse);
        }

        PaymentResDto paymentResDto = paymentService.createPaymentUrl(orderId, request);

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
        Payment payment = paymentService.getPaymentByOrderId(orderId);
        if (payment.getMethod().equals("COD") || payment == null) {
            return ResponseEntity.ok("ok");
        }
        try {
            String result = paymentService.handleQuery(orderId, request);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Error: " + e.getMessage());
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
        if (("Success").equalsIgnoreCase(paymentService.getPaymentStatusByOrderId(orderId)) == false) {
            return ResponseEntity.status(HttpStatus.OK).body("Đơn hàng chưa được thanh toán, không thể hoàn tiền.");
        }
        String result = paymentService.handleRefund(orderId, trantype, percent, request);
        return ResponseEntity.ok(result);

    }

}
