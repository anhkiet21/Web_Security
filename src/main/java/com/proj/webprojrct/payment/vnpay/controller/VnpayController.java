package com.proj.webprojrct.payment.vnpay.controller;

import com.proj.webprojrct.payment.vnpay.service.PaymentService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.TimeZone;

@Controller
@RequiredArgsConstructor
public class VnpayController {

    private final PaymentService paymentService;

    @GetMapping("/payment/return")
    public String handleVnPayReturn(HttpServletRequest request, Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            model.addAttribute("success", false);
            model.addAttribute("message", "vui lòng đăng nhập.");
            return "user/vnpay_result";
        }
        try {
            Map<String, Object> result = paymentService.handleVnPayReturn(request);

            if (result.containsKey("error")) {
                model.addAttribute("success", false);
                model.addAttribute("message", result.get("error"));
                return "user/vnpay_result";
            }

            String responseCode = (String) result.get("responseCode");
            String transactionStatus = (String) result.get("transactionStatus");

            model.addAttribute("success", "00".equals(responseCode) && "00".equals(transactionStatus));
            model.addAttribute("responseCode", responseCode);
            model.addAttribute("responseCodeMessage", getResponseCodeMessage(responseCode));
            model.addAttribute("transactionStatus", transactionStatus);
            model.addAttribute("transactionStatusMessage", getTransactionStatusMessage(transactionStatus));

            return "payment/return";

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("success", false);
            model.addAttribute("message", "Lỗi xử lý callback VNPAY: " + e.getMessage());
            return "user/vnpay_result";
        }
    }

    // Helper method to convert response code to Vietnamese message
    private String getResponseCodeMessage(String code) {
        if (code == null) {
            return "Không xác định";
        }
        switch (code) {
            case "00":
                return "Giao dịch thành công";
            case "07":
                return "Trừ tiền thành công. Giao dịch bị nghi ngờ (liên quan tới lừa đảo, giao dịch bất thường)";
            case "09":
                return "Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng chưa đăng ký dịch vụ InternetBanking tại ngân hàng";
            case "10":
                return "Giao dịch không thành công do: Khách hàng xác thực thông tin thẻ/tài khoản không đúng quá 3 lần";
            case "11":
                return "Giao dịch không thành công do: Đã hết hạn chờ thanh toán. Xin quý khách vui lòng thực hiện lại giao dịch";
            case "12":
                return "Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng bị khóa";
            case "13":
                return "Giao dịch không thành công do Quý khách nhập sai mật khẩu xác thực giao dịch (OTP). Xin quý khách vui lòng thực hiện lại giao dịch";
            case "24":
                return "Giao dịch không thành công do: Khách hàng hủy giao dịch";
            case "51":
                return "Giao dịch không thành công do: Tài khoản của quý khách không đủ số dư để thực hiện giao dịch";
            case "65":
                return "Giao dịch không thành công do: Tài khoản của Quý khách đã vượt quá hạn mức giao dịch trong ngày";
            case "75":
                return "Ngân hàng thanh toán đang bảo trì";
            case "79":
                return "Giao dịch không thành công do: KH nhập sai mật khẩu thanh toán quá số lần quy định. Xin quý khách vui lòng thực hiện lại giao dịch";
            case "99":
                return "Các lỗi khác (lỗi còn lại, không có trong danh sách mã lỗi đã liệt kê)";
            default:
                return "Mã lỗi không xác định: " + code;
        }
    }

    // Helper method to convert transaction status to Vietnamese message
    private String getTransactionStatusMessage(String status) {
        if (status == null) {
            return "Không xác định";
        }
        switch (status) {
            case "00":
                return "Giao dịch thanh toán thành công";
            case "01":
                return "Giao dịch chưa hoàn tất";
            case "02":
                return "Giao dịch bị lỗi";
            case "04":
                return "Giao dịch đảo (Khách hàng đã bị trừ tiền tại Ngân hàng nhưng GD chưa thành công ở VNPAY)";
            case "05":
                return "VNPAY đang xử lý giao dịch này (GD hoàn tiền)";
            case "06":
                return "VNPAY đã gửi yêu cầu hoàn tiền sang Ngân hàng (GD hoàn tiền)";
            case "07":
                return "Giao dịch bị nghi ngờ gian lận";
            case "09":
                return "GD Hoàn trả bị từ chối";
            default:
                return "Trạng thái không xác định: " + status;
        }
    }
}
