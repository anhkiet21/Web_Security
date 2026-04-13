package com.proj.webprojrct.payment.vnpay.service;

import com.proj.webprojrct.order.entity.Order;
import com.proj.webprojrct.order.repository.OrderRepository;
import com.proj.webprojrct.order.service.OrderService;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.TimeZone;

import org.eclipse.tags.shaded.org.apache.regexp.recompile;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.beans.factory.annotation.Autowired;

import lombok.*;

import org.springframework.stereotype.Service;

import com.nimbusds.jose.shaded.gson.JsonObject;
import com.nimbusds.jose.shaded.gson.JsonParser;
import com.proj.webprojrct.payment.vnpay.config.Config;
import com.proj.webprojrct.payment.dto.response.PaymentResDto;
import com.proj.webprojrct.payment.entity.Payment;
import com.proj.webprojrct.payment.entity.PaymentUrlVnpay;
import com.proj.webprojrct.payment.repository.PaymentRepository;
import com.proj.webprojrct.payment.repository.PaymentUrlVnpayRepository;
import com.twilio.twiml.voice.Pay;

import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@RequiredArgsConstructor
@Service
public class PaymentService {

    private static final Logger log = LoggerFactory.getLogger(PaymentService.class);

    private final PaymentRepository paymentRepository;

    private final OrderRepository orderRepository;

    private final PaymentUrlVnpayRepository paymentUrlVnpayRepository;

    private final OrderService orderService;

    public PaymentResDto createPaymentUrl(Long orderId, Long userId, HttpServletRequest request) throws UnsupportedEncodingException {

        String orderType = "other";

        Order order = orderRepository.findById(orderId).orElseThrow(() -> new EntityNotFoundException("KhÃ´ng tÃ¬m tháº¥y Ä‘Æ¡n hÃ ng (Order) vá»›i ID: " + orderId));
        
        Long orderUserId = order.getUser().getId();
        if (!orderUserId.equals(userId)) {
            throw new AccessDeniedException("Báº¡n khÃ´ng cÃ³ quyá»n thanh toÃ¡n cho Ä‘Æ¡n hÃ ng nÃ y.");
        }
        
        BigDecimal totalAmountBigDecimal = order.getTotalAmount();
        BigDecimal multiplier = new BigDecimal("100");
        long amount = totalAmountBigDecimal.multiply(multiplier).longValue();
        // String bankCode = req.getParameter("bankCode");
        //long amount = 100000 * 100; //test

        String vnp_TxnRef = String.valueOf(orderId);

        String vnp_IpAddr = Config.getIpAddress(request);

        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", Config.vnp_Version);
        vnp_Params.put("vnp_Command", Config.vnp_Command);
        vnp_Params.put("vnp_TmnCode", Config.vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amount));
        vnp_Params.put("vnp_CurrCode", "VND");
        //vnp_Params.put("vnp_BankCode", "NCB");
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_OrderInfo", "Thanh toan don hang:" + vnp_TxnRef);
        vnp_Params.put("vnp_OrderType", orderType);  // ðŸ”¹ báº¯t buá»™c
        vnp_Params.put("vnp_Locale", "vn");
        vnp_Params.put("vnp_ReturnUrl", Config.vnp_ReturnUrl); // ðŸ”¹ báº¯t buá»™c
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr); // ðŸ”¹ báº¯t buá»™c

        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

        cld.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

        List fieldNames = new ArrayList(vnp_Params.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        Iterator itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = (String) itr.next();
            String fieldValue = (String) vnp_Params.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                //Build hash data
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                //Build query
                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                query.append('=');
                query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                if (itr.hasNext()) {
                    query.append('&');
                    hashData.append('&');
                }
            }
        }

        String queryUrl = query.toString();
        String vnp_SecureHash = Config.hmacSHA512(Config.secretKey, hashData.toString());
        queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
        String paymentUrl = Config.vnp_PayUrl + "?" + queryUrl;

        if (!paymentRepository.existsByOrderId(orderId)) {
            Payment payment = Payment.builder()
                    .method("VNPAY")
                    .orderId(orderId)
                    .amount(BigDecimal.valueOf(amount / 100.0))
                    .status("PENDING")
                    .paidAt(vnp_CreateDate)
                    .build();
            savePayment(payment);
        }

        PaymentUrlVnpay existing = paymentUrlVnpayRepository.findByOrderId(orderId);

        PaymentUrlVnpay paymentUrlVnpay;
        if (existing != null) {
            paymentUrlVnpay = existing;
            paymentUrlVnpay.setPaymentUrl(paymentUrl);
            paymentUrlVnpay.setCreatedAt(vnp_CreateDate);
            paymentUrlVnpay.setExpiresAt(vnp_ExpireDate);
        } else {

            paymentUrlVnpay = PaymentUrlVnpay.builder()
                    .orderId(orderId)
                    .paymentUrl(paymentUrl)
                    .createdAt(vnp_CreateDate)
                    .expiresAt(vnp_ExpireDate)
                    .build();
        }

        paymentUrlVnpayRepository.save(paymentUrlVnpay);

        PaymentResDto paymentResDto = new PaymentResDto();
        paymentResDto.setStatus("OK");
        paymentResDto.setMessage("Successfully");
        paymentResDto.setURL(paymentUrl);

        return paymentResDto;
    }

    public Map<String, Object> handleVnPayReturn(HttpServletRequest request) throws Exception {

        Map<String, String> fields = new HashMap<>();
        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String fieldName = paramNames.nextElement();
            String fieldValue = request.getParameter(fieldName);

            if (fieldValue != null && fieldValue.length() > 0) {
                // Chá»‰ encode value theo chuáº©n US-ASCII
                String encodedValue = URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString());
                fields.put(fieldName, encodedValue);
            }
        }

        String vnp_SecureHash = request.getParameter("vnp_SecureHash");

        fields.remove("vnp_SecureHashType");
        fields.remove("vnp_SecureHash");


        String signValue = Config.hashAllFields(fields);


        Map<String, Object> result = new HashMap<>();
        if (signValue.equals(vnp_SecureHash)) {
            // Chá»¯ kÃ½ há»£p lá»‡
            String responseCode = request.getParameter("vnp_ResponseCode");
            String transactionStatus = request.getParameter("vnp_TransactionStatus");

            // ThÃ´ng bÃ¡o vnp_ResponseCode - Báº£ng mÃ£ lá»—i truy váº¥n giao dá»‹ch querydr
            Map<String, String> queryResponseMessages = new HashMap<>();
            queryResponseMessages.put("00", "YÃªu cáº§u thÃ nh cÃ´ng");
            queryResponseMessages.put("02", "MÃ£ Ä‘á»‹nh danh káº¿t ná»‘i khÃ´ng há»£p lá»‡ (kiá»ƒm tra láº¡i TmnCode)");
            queryResponseMessages.put("03", "Dá»¯ liá»‡u gá»­i sang khÃ´ng Ä‘Ãºng Ä‘á»‹nh dáº¡ng");
            queryResponseMessages.put("91", "KhÃ´ng tÃ¬m tháº¥y giao dá»‹ch yÃªu cáº§u");
            queryResponseMessages.put("94", "YÃªu cáº§u trÃ¹ng láº·p, duplicate request trong thá»i gian giá»›i háº¡n cá»§a API");
            queryResponseMessages.put("97", "Checksum khÃ´ng há»£p lá»‡");
            queryResponseMessages.put("99", "CÃ¡c lá»—i khÃ¡c (lá»—i cÃ²n láº¡i, khÃ´ng cÃ³ trong danh sÃ¡ch mÃ£ lá»—i Ä‘Ã£ liá»‡t kÃª)");

            // ThÃ´ng bÃ¡o vnp_ResponseCode - Báº£ng mÃ£ lá»—i yÃªu cáº§u hoÃ n tráº£ (refund)
            Map<String, String> refundResponseMessages = new HashMap<>();
            refundResponseMessages.put("00", "YÃªu cáº§u thÃ nh cÃ´ng");
            refundResponseMessages.put("02", "MÃ£ Ä‘á»‹nh danh káº¿t ná»‘i khÃ´ng há»£p lá»‡ (kiá»ƒm tra láº¡i TmnCode)");
            refundResponseMessages.put("03", "Dá»¯ liá»‡u gá»­i sang khÃ´ng Ä‘Ãºng Ä‘á»‹nh dáº¡ng");
            refundResponseMessages.put("91", "KhÃ´ng tÃ¬m tháº¥y giao dá»‹ch yÃªu cáº§u hoÃ n tráº£");
            refundResponseMessages.put("94", "Giao dá»‹ch Ä‘Ã£ Ä‘Æ°á»£c gá»­i yÃªu cáº§u hoÃ n tiá»n trÆ°á»›c Ä‘Ã³. YÃªu cáº§u nÃ y VNPAY Ä‘ang xá»­ lÃ½");
            refundResponseMessages.put("95", "Giao dá»‹ch nÃ y khÃ´ng thÃ nh cÃ´ng bÃªn VNPAY. VNPAY tá»« chá»‘i xá»­ lÃ½ yÃªu cáº§u");
            refundResponseMessages.put("97", "Checksum khÃ´ng há»£p lá»‡");
            refundResponseMessages.put("99", "CÃ¡c lá»—i khÃ¡c (lá»—i cÃ²n láº¡i, khÃ´ng cÃ³ trong danh sÃ¡ch mÃ£ lá»—i Ä‘Ã£ liá»‡t kÃª)");

            // ThÃ´ng bÃ¡o vnp_ResponseCode - MÃ£ lá»—i thanh toÃ¡n
            Map<String, String> responseMessages = new HashMap<>();
            responseMessages.put("00", "Giao dá»‹ch thÃ nh cÃ´ng");
            responseMessages.put("07", "Trá»« tiá»n thÃ nh cÃ´ng. Giao dá»‹ch bá»‹ nghi ngá» (liÃªn quan tá»›i lá»«a Ä‘áº£o, giao dá»‹ch báº¥t thÆ°á»ng)");
            responseMessages.put("09", "Giao dá»‹ch khÃ´ng thÃ nh cÃ´ng do: Tháº»/TÃ i khoáº£n cá»§a khÃ¡ch hÃ ng chÆ°a Ä‘Äƒng kÃ½ dá»‹ch vá»¥ InternetBanking táº¡i ngÃ¢n hÃ ng");
            responseMessages.put("10", "Giao dá»‹ch khÃ´ng thÃ nh cÃ´ng do: KhÃ¡ch hÃ ng xÃ¡c thá»±c thÃ´ng tin tháº»/tÃ i khoáº£n khÃ´ng Ä‘Ãºng quÃ¡ 3 láº§n");
            responseMessages.put("11", "Giao dá»‹ch khÃ´ng thÃ nh cÃ´ng do: ÄÃ£ háº¿t háº¡n chá» thanh toÃ¡n. Xin quÃ½ khÃ¡ch vui lÃ²ng thá»±c hiá»‡n láº¡i giao dá»‹ch");
            responseMessages.put("12", "Giao dá»‹ch khÃ´ng thÃ nh cÃ´ng do: Tháº»/TÃ i khoáº£n cá»§a khÃ¡ch hÃ ng bá»‹ khÃ³a");
            responseMessages.put("13", "Giao dá»‹ch khÃ´ng thÃ nh cÃ´ng do QuÃ½ khÃ¡ch nháº­p sai máº­t kháº©u xÃ¡c thá»±c giao dá»‹ch (OTP). Xin quÃ½ khÃ¡ch vui lÃ²ng thá»±c hiá»‡n láº¡i giao dá»‹ch");
            responseMessages.put("24", "Giao dá»‹ch khÃ´ng thÃ nh cÃ´ng do: KhÃ¡ch hÃ ng há»§y giao dá»‹ch");
            responseMessages.put("51", "Giao dá»‹ch khÃ´ng thÃ nh cÃ´ng do: TÃ i khoáº£n cá»§a quÃ½ khÃ¡ch khÃ´ng Ä‘á»§ sá»‘ dÆ° Ä‘á»ƒ thá»±c hiá»‡n giao dá»‹ch");
            responseMessages.put("65", "Giao dá»‹ch khÃ´ng thÃ nh cÃ´ng do: TÃ i khoáº£n cá»§a QuÃ½ khÃ¡ch Ä‘Ã£ vÆ°á»£t quÃ¡ háº¡n má»©c giao dá»‹ch trong ngÃ y");
            responseMessages.put("75", "NgÃ¢n hÃ ng thanh toÃ¡n Ä‘ang báº£o trÃ¬");
            responseMessages.put("79", "Giao dá»‹ch khÃ´ng thÃ nh cÃ´ng do: KH nháº­p sai máº­t kháº©u thanh toÃ¡n quÃ¡ sá»‘ láº§n quy Ä‘á»‹nh. Xin quÃ½ khÃ¡ch vui lÃ²ng thá»±c hiá»‡n láº¡i giao dá»‹ch");
            responseMessages.put("99", "CÃ¡c lá»—i khÃ¡c (lá»—i cÃ²n láº¡i, khÃ´ng cÃ³ trong danh sÃ¡ch mÃ£ lá»—i Ä‘Ã£ liá»‡t kÃª)");

            // ThÃ´ng bÃ¡o vnp_TransactionStatus - Báº£ng mÃ£ lá»—i tÃ¬nh tráº¡ng thanh toÃ¡n
            Map<String, String> statusMessages = new HashMap<>();
            statusMessages.put("00", "Giao dá»‹ch thanh toÃ¡n thÃ nh cÃ´ng");
            statusMessages.put("01", "Giao dá»‹ch chÆ°a hoÃ n táº¥t");
            statusMessages.put("02", "Giao dá»‹ch bá»‹ lá»—i");
            statusMessages.put("04", "Giao dá»‹ch Ä‘áº£o (KhÃ¡ch hÃ ng Ä‘Ã£ bá»‹ trá»« tiá»n táº¡i NgÃ¢n hÃ ng nhÆ°ng GD chÆ°a thÃ nh cÃ´ng á»Ÿ VNPAY)");
            statusMessages.put("05", "VNPAY Ä‘ang xá»­ lÃ½ giao dá»‹ch nÃ y (GD hoÃ n tiá»n)");
            statusMessages.put("06", "VNPAY Ä‘Ã£ gá»­i yÃªu cáº§u hoÃ n tiá»n sang NgÃ¢n hÃ ng (GD hoÃ n tiá»n)");
            statusMessages.put("07", "Giao dá»‹ch bá»‹ nghi ngá» gian láº­n");
            statusMessages.put("09", "GD HoÃ n tráº£ bá»‹ tá»« chá»‘i");

            // Log thÃ´ng tin chi tiáº¿t ra console

            // Log táº¥t cáº£ parameters tá»« VNPAY
            request.getParameterMap().forEach((key, value) -> {
            });

            result.put("responseCode", responseCode);
            result.put("responseMessage", responseMessages.getOrDefault(responseCode, "KhÃ´ng xÃ¡c Ä‘á»‹nh"));
            result.put("transactionStatus", transactionStatus);
            result.put("transactionMessage", statusMessages.getOrDefault(transactionStatus, "KhÃ´ng xÃ¡c Ä‘á»‹nh"));

            //xoa paymentUrlVnpay sau khi thanh toan thanh cong
            long orderId = Long.parseLong(request.getParameter("vnp_TxnRef"));
            PaymentUrlVnpay paymentUrl = paymentUrlVnpayRepository.findByOrderId(orderId);
            paymentUrlVnpayRepository.delete(paymentUrl);
            if (transactionStatus.equals("00")) {
                //cáº­p nháº­t tráº¡ng thÃ¡i payment
                Payment payment = paymentRepository.findByOrderId(orderId);
                payment.setStatus("SUCCESS");
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
                String paidAtStr = request.getParameter("vnp_PayDate");
                LocalDateTime paidAt = LocalDateTime.parse(paidAtStr, formatter);
                payment.setPaidAt(paidAtStr);
                paymentRepository.save(payment);
            } // Update product stock when payment is successful (responseCode = "00")
            if ("00".equals(responseCode)) {
                try {
                    orderService.updateProductStockAfterPayment(orderId);
                } catch (Exception e) {
                    log.error("Failed to update product stock for order {}", orderId, e);
                    // Don't throw exception here to avoid breaking the payment flow
                }
            }
        } else {
            // Chá»¯ kÃ½ khÃ´ng há»£p lá»‡
            result.put("error", "Chá»¯ kÃ½ khÃ´ng há»£p lá»‡");
        }

        return result;
    }

    public String handleQuery(long orderId, Long userId, HttpServletRequest request) throws Exception {

        Order order = orderRepository.findById(orderId).orElseThrow(() -> new EntityNotFoundException("KhÃ´ng tÃ¬m tháº¥y Ä‘Æ¡n hÃ ng (Order) vá»›i ID: " + orderId));
        
        Long orderUserId = order.getUser().getId();
        if (!orderUserId.equals(userId)) {
            throw new AccessDeniedException("Báº¡n khÃ´ng cÃ³ quyá»n thanh toÃ¡n cho Ä‘Æ¡n hÃ ng nÃ y.");
        }
        try {

            // CÃ¡c tham sá»‘ cÆ¡ báº£n
            String vnp_RequestId = Config.getRandomNumber(8);
            String vnp_Version = "2.1.0";
            String vnp_Command = "querydr";
            String vnp_TmnCode = Config.vnp_TmnCode;
            String vnp_TxnRef = String.valueOf(orderId);
            String vnp_OrderInfo = "Kiem tra ket qua GD OrderId:" + vnp_TxnRef;
            Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
            String vnp_CreateDate = formatter.format(cld.getTime());
            String vnp_IpAddr = Config.getIpAddress(request);
            String vnp_TransDate = vnp_CreateDate;
            // JSON request body
            JsonObject vnp_Params = new JsonObject();
            vnp_Params.addProperty("vnp_RequestId", vnp_RequestId);
            vnp_Params.addProperty("vnp_Version", vnp_Version);
            vnp_Params.addProperty("vnp_Command", vnp_Command);
            vnp_Params.addProperty("vnp_TmnCode", vnp_TmnCode);
            vnp_Params.addProperty("vnp_TxnRef", vnp_TxnRef);
            vnp_Params.addProperty("vnp_OrderInfo", vnp_OrderInfo);
            vnp_Params.addProperty("vnp_TransactionDate", vnp_TransDate);
            vnp_Params.addProperty("vnp_CreateDate", vnp_CreateDate);
            vnp_Params.addProperty("vnp_IpAddr", vnp_IpAddr);
            // Hash data
            String hash_Data = String.join("|",
                    vnp_RequestId, vnp_Version, vnp_Command, vnp_TmnCode,
                    vnp_TxnRef, vnp_TransDate, vnp_CreateDate, vnp_IpAddr, vnp_OrderInfo);
            String vnp_SecureHash = Config.hmacSHA512(Config.secretKey, hash_Data);
            vnp_Params.addProperty("vnp_SecureHash", vnp_SecureHash);
            // Gá»­i request POST
            URL url = new URL(Config.vnp_ApiUrl);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("Content-Type", "application/json");
            con.setDoOutput(true);
            try (DataOutputStream wr = new DataOutputStream(con.getOutputStream())) {
                wr.writeBytes(vnp_Params.toString());
                wr.flush();
            }
            int responseCode = con.getResponseCode();
            StringBuilder response = new StringBuilder();
            try (BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()))) {
                String output;
                while ((output = in.readLine()) != null) {
                    response.append(output);
                }
            }
            String res = response.toString(); // DÃ²ng code cá»§a báº¡n

            // 1. Parse chuá»—i JSON response
            JsonObject responseJson = JsonParser.parseString(res).getAsJsonObject();

            // 2. Láº¥y mÃ£ tráº¡ng thÃ¡i giao dá»‹ch
            String transactionStatus = "UNDEFINED"; // Äáº·t mÃ£ máº·c Ä‘á»‹nh
            if (responseJson.has("vnp_TransactionStatus")) {
                transactionStatus = responseJson.get("vnp_TransactionStatus").getAsString();
            }

            // 3. Láº¥y Ä‘á»‘i tÆ°á»£ng Payment
            Payment payment = paymentRepository.findByOrderId(orderId);

            // 4. Ãnh xáº¡ mÃ£ VNPAY sang tráº¡ng thÃ¡i cá»§a báº¡n
            String appStatus;
            switch (transactionStatus) {
                case "00":
                    appStatus = "SUCCESS";
                    break;
                case "01":
                    appStatus = "PENDING";
                    break;
                case "02":
                    appStatus = "FAILED";
                    break;
                case "04":
                    appStatus = "REVERSED";
                    break;
                case "05":
                    appStatus = "REFUND_PENDING";
                    break;
                case "06":
                    appStatus = "REFUND_PROCESSING";
                    break;
                case "07":
                    appStatus = "FRAUD_SUSPECTED";
                    break;
                case "09":
                    appStatus = "REFUND_FAILED";
                    break;
                default:
                    appStatus = "UNKNOWN";
                    break;
            }

            payment.setStatus(appStatus);
            paymentRepository.save(payment);
            return response.toString();
        } catch (Exception e) {
            log.error("Lỗi khi query giao dịch orderId={}", orderId, e);
            return "Lỗi hệ thống khi truy vấn giao dịch.";
        }
    }

    public String handleRefund(long orderId, String trantype, int percent, HttpServletRequest request) throws Exception {
        if ("02".equals(trantype)) {
            percent = 100;
        }
        Order order = orderRepository.findById(orderId).orElseThrow(() -> new EntityNotFoundException("KhÃ´ng tÃ¬m tháº¥y Ä‘Æ¡n hÃ ng (Order) vá»›i ID: " + orderId));
        BigDecimal totalAmountBigDecimal = order.getTotalAmount();
        BigDecimal multiplier = new BigDecimal("100");
        long originalAmountVND = totalAmountBigDecimal.multiply(multiplier).longValue();
        double refundAmountVND = originalAmountVND * ((double) percent / 100.0);
        long amount = (long) refundAmountVND;

        String vnp_RequestId = Config.getRandomNumber(8);
        String vnp_Version = "2.1.0";
        String vnp_Command = "refund";
        String vnp_TmnCode = Config.vnp_TmnCode;
        String vnp_TransactionType = trantype;
        String vnp_TxnRef = String.valueOf(orderId);
        double discount = (double) percent / 100.0;
        //long amount = 100000 * 100; //test
        String vnp_Amount = String.valueOf(amount);
        String vnp_OrderInfo = "Hoan tien GD OrderId:" + vnp_TxnRef;
        String vnp_TransactionNo = ""; //Assuming value of the parameter "vnp_TransactionNo" does not exist on your system.
        String vnp_CreateBy = "kiet";

        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        String vnp_TransactionDate = vnp_CreateDate;

        String vnp_IpAddr = Config.getIpAddress(request);

        JsonObject vnp_Params = new JsonObject();

        vnp_Params.addProperty("vnp_RequestId", vnp_RequestId);
        vnp_Params.addProperty("vnp_Version", vnp_Version);
        vnp_Params.addProperty("vnp_Command", vnp_Command);
        vnp_Params.addProperty("vnp_TmnCode", vnp_TmnCode);
        vnp_Params.addProperty("vnp_TransactionType", vnp_TransactionType);
        vnp_Params.addProperty("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.addProperty("vnp_Amount", vnp_Amount);
        vnp_Params.addProperty("vnp_OrderInfo", vnp_OrderInfo);

        if (vnp_TransactionNo != null && !vnp_TransactionNo.isEmpty()) {
            vnp_Params.addProperty("vnp_TransactionNo", "{get value of vnp_TransactionNo}");
        }

        vnp_Params.addProperty("vnp_TransactionDate", vnp_TransactionDate);
        vnp_Params.addProperty("vnp_CreateBy", vnp_CreateBy);
        vnp_Params.addProperty("vnp_CreateDate", vnp_CreateDate);
        vnp_Params.addProperty("vnp_IpAddr", vnp_IpAddr);

        String hash_Data = String.join("|", vnp_RequestId, vnp_Version, vnp_Command, vnp_TmnCode,
                vnp_TransactionType, vnp_TxnRef, vnp_Amount, vnp_TransactionNo, vnp_TransactionDate,
                vnp_CreateBy, vnp_CreateDate, vnp_IpAddr, vnp_OrderInfo);

        String vnp_SecureHash = Config.hmacSHA512(Config.secretKey, hash_Data.toString());

        vnp_Params.addProperty("vnp_SecureHash", vnp_SecureHash);

        URL url = new URL(Config.vnp_ApiUrl);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("POST");
        con.setRequestProperty("Content-Type", "application/json");
        con.setDoOutput(true);
        DataOutputStream wr = new DataOutputStream(con.getOutputStream());
        wr.writeBytes(vnp_Params.toString());
        wr.flush();
        wr.close();
        int responseCode = con.getResponseCode();
        BufferedReader in = new BufferedReader(
                new InputStreamReader(con.getInputStream()));
        String output;
        StringBuffer response = new StringBuffer();
        while ((output = in.readLine()) != null) {
            response.append(output);
        }
        in.close();

        if (response.toString().contains("\"vnp_TransactionStatus\":\"05\"")) {
            Payment payment = paymentRepository.findByOrderId(orderId);
            payment.setStatus("REFUNDING");
            paymentRepository.save(payment);
        }

        return response.toString();
    }

    public void createPaymentCOD(Long orderId, Long userId) {
        Order order = orderRepository.findById(orderId).orElseThrow(() -> new EntityNotFoundException("KhÃ´ng tÃ¬m tháº¥y Ä‘Æ¡n hÃ ng (Order) vá»›i ID: " + orderId));
        Long orderUserId = order.getUser().getId();
        if (!orderUserId.equals(userId)) {
            throw new AccessDeniedException("Báº¡n khÃ´ng cÃ³ quyá»n thanh toÃ¡n cho Ä‘Æ¡n hÃ ng nÃ y.");
        }
        
        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String createdAt = formatter.format(cld.getTime());
        Payment payment = Payment.builder()
                .method("COD")
                .orderId(orderId)
                .amount(order.getTotalAmount())
                .status("PENDING")
                .paidAt(createdAt)
                .build();
        paymentRepository.save(payment);

        // cáº­p nháº­t sá»‘ lÆ°á»£ng 
        try {
            orderService.updateProductStockAfterPayment(orderId);
        } catch (Exception e) {
            log.error("Cập nhật thất bại cho đơn hàng {}", orderId, e);
            throw new RuntimeException("Không thể cập nhật số lượng sản phẩm. Vui lòng thử lại.");
        }
    }

    public PaymentResDto getUrlVnpayPayment(Long orderId) {
        PaymentUrlVnpay paymentUrl = paymentUrlVnpayRepository.findByOrderId(orderId);
        PaymentResDto paymentResDto = new PaymentResDto();
        paymentResDto.setStatus("OK");
        paymentResDto.setMessage("Tiáº¿p tá»¥c thanh toÃ¡n.");
        paymentResDto.setURL(paymentUrl.getPaymentUrl());
        return paymentResDto;
    }

    public Payment getPaymentById(Long id) {
        return paymentRepository.findById(id).orElse(null);
    }

    public Payment savePayment(Payment payment) {
        return paymentRepository.save(payment);
    }

    public void deletePayment(Long id) {
        paymentRepository.deleteById(id);
    }

    public List<Payment> getAllPayments() {
        return paymentRepository.findAll();
    }

    public Payment getPaymentByOrderId(long orderId) {
        return paymentRepository.findByOrderId(orderId);
    }

    public String getPaymentMethodByOrderId(long orderId) {
        Payment payment = paymentRepository.findByOrderId(orderId);
        if (payment != null) {
            return payment.getMethod();
        }
        return null;
    }

    public String getPaymentStatusByOrderId(long orderId) {
        Payment payment = paymentRepository.findByOrderId(orderId);
        if (payment != null) {
            return payment.getStatus();
        }
        return null;
    }

    public boolean existsByOrderId(Long orderId) {
        Payment payment = paymentRepository.findByOrderId(orderId);
        if (payment == null) {
            return false;
        }
        return true;
    }

    public boolean getPaymentByOrderId(Long orderId) {
        // Kiá»ƒm tra cÃ³ order khÃ´ng
        if (!paymentRepository.existsByOrderId(orderId)) {
            return false;
        }

        // Láº¥y paymentUrl tÆ°Æ¡ng á»©ng
        PaymentUrlVnpay paymentUrl = paymentUrlVnpayRepository.findByOrderId(orderId);
        if (paymentUrl == null) {
            return false;
        }

        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
            LocalDateTime expiresAt = LocalDateTime.parse(paymentUrl.getExpiresAt(), formatter);

            return expiresAt.isAfter(LocalDateTime.now());
        } catch (Exception e) {
            // log lỗi parse format
            log.error("Lỗi kiểm tra thời hạn thanh toán cho đơn hàng {}", orderId, e);
            return false;
        }
    }

}
