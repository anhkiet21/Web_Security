package com.proj.webprojrct.seller.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.proj.webprojrct.payment.vnpay.service.PaymentService;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.proj.webprojrct.order.dto.response.OrderSellerResponse;
import com.proj.webprojrct.seller.service.SellerService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequiredArgsConstructor
public class SellerController {

    private final SellerService sellerService;
    private final PaymentService paymentService;

    @GetMapping("/seller/all-orders")
    public String getAllSellerOrders(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) Long orderId,
            Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }
        try {
            List<OrderSellerResponse> allOrders = sellerService.getAllOrders(authentication);

            // Filter by orderId if provided
            if (orderId != null) {
                final Long searchId = orderId;
                allOrders = allOrders.stream()
                        .filter(order -> searchId.equals(order.getOrderId()))
                        .collect(java.util.stream.Collectors.toList());
            }

            // Filter by status if provided
            if (status != null && !status.isEmpty() && !status.equals("ALL")) {
                allOrders = allOrders.stream()
                        .filter(order -> status.equals(order.getStatus()))
                        .collect(java.util.stream.Collectors.toList());
            }

            // Calculate pagination
            int totalOrders = allOrders.size();
            int totalPages = (int) Math.ceil((double) totalOrders / size);

            // Validate page number
            if (page < 1) {
                page = 1;
            }
            if (page > totalPages && totalPages > 0) {
                page = totalPages;
            }

            // Get orders for current page
            int startIndex = (page - 1) * size;
            int endIndex = Math.min(startIndex + size, totalOrders);

            List<OrderSellerResponse> paginatedOrders;
            if (startIndex < totalOrders) {
                paginatedOrders = allOrders.subList(startIndex, endIndex);
            } else {
                paginatedOrders = java.util.Collections.emptyList();
            }

            model.addAttribute("orders", paginatedOrders);
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("pageSize", size);
            model.addAttribute("totalOrders", totalOrders);
            model.addAttribute("startIndex", startIndex + 1);
            model.addAttribute("endIndex", endIndex);
            model.addAttribute("selectedStatus", status != null ? status : "ALL");
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/home";
        }
        return "seller/all_orders";
    }

    @GetMapping("/seller/orders")
    public String getSellerOrders(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) Long orderId,
            Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }
        try {
            // Get ALL orders in system (same as all-orders page)
            List<OrderSellerResponse> allOrders = sellerService.getOrdersPaid(authentication);

            // Filter by orderId if provided
            if (orderId != null) {
                final Long searchId = orderId;
                allOrders = allOrders.stream()
                        .filter(order -> searchId.equals(order.getOrderId()))
                        .collect(java.util.stream.Collectors.toList());
            }

            // Filter by status if provided
            if (status != null && !status.isEmpty() && !status.equals("ALL")) {
                allOrders = allOrders.stream()
                        .filter(order -> status.equals(order.getStatus()))
                        .collect(java.util.stream.Collectors.toList());
            }

            // Calculate pagination
            int totalOrders = allOrders.size();
            int totalPages = (int) Math.ceil((double) totalOrders / size);

            // Validate page number
            if (page < 1) {
                page = 1;
            }
            if (page > totalPages && totalPages > 0) {
                page = totalPages;
            }

            // Get orders for current page
            int startIndex = (page - 1) * size;
            int endIndex = Math.min(startIndex + size, totalOrders);

            List<OrderSellerResponse> paginatedOrders;
            if (startIndex < totalOrders) {
                paginatedOrders = allOrders.subList(startIndex, endIndex);
            } else {
                paginatedOrders = java.util.Collections.emptyList();
            }

            model.addAttribute("orders", paginatedOrders);
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("pageSize", size);
            model.addAttribute("totalOrders", totalOrders);
            model.addAttribute("startIndex", startIndex + 1);
            model.addAttribute("endIndex", endIndex);
            model.addAttribute("selectedStatus", status != null ? status : "ALL");
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/home";
        }
        return "seller/orders";
    }

    @PostMapping("/seller/accept-order/{orderId}")
    public String postSellerOrders(@PathVariable("orderId") Long orderId, Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }
        try {
            if (sellerService.acceptOrder(orderId, authentication)) {
                model.addAttribute("success", "Order accepted successfully.");
            } else {
                model.addAttribute("error", "Failed to accept the order.");
            }

        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/home";
        }
        return "redirect:/seller/orders";
    }

    @PostMapping("/seller/cancel-order/{orderId}")
    public String cancelOrder(
            @PathVariable("orderId") Long orderId,
            @RequestParam("cancelNote") String cancelNote,
            Model model,
            HttpServletRequest request) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }
        try {
            // Validate cancel note
            if (cancelNote == null || cancelNote.trim().length() < 10) {
                model.addAttribute("error", "Lý do hủy đơn phải có ít nhất 10 ký tự.");
                return "redirect:/seller/orders";
            }

            // Cancel order with refund if needed
            boolean isRefunded = sellerService.cancelOrder(orderId, cancelNote.trim(), authentication, request);

            if (isRefunded) {
                model.addAttribute("success", "Đơn hàng đã được hủy và hoàn tiền thành công. Tiền sẽ được hoàn lại vào tài khoản khách hàng trong 5-7 ngày làm việc.");
            } else {
                model.addAttribute("success", "Đơn hàng đã được hủy thành công. Thông báo đã được gửi đến khách hàng.");
            }
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi hủy đơn hàng: " + e.getMessage());
        }
        return "redirect:/seller/orders";
    }

    @PostMapping("/seller/ship-order/{orderId}")
    public String shipOrder(@PathVariable("orderId") Long orderId, Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }
        try {
            if (sellerService.shipOrder(orderId, authentication)) {
                model.addAttribute("success", "Order marked as shipping successfully.");
            } else {
                model.addAttribute("error", "Failed to mark the order as shipping.");
            }
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/home";
        }
        return "redirect:/seller/orders-accepted";
    }

    @PostMapping("/seller/deliver-order/{orderId}")
    public String deliverOrder(@PathVariable("orderId") Long orderId, Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }
        try {
            if (sellerService.deliverOrder(orderId, authentication)) {
                model.addAttribute("success", "Order marked as delivered successfully.");
            } else {
                model.addAttribute("error", "Failed to mark the order as delivered.");
            }
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/home";
        }
        return "redirect:/seller/orders-shipping";
    }

    @GetMapping("/seller/orders-refund")
    public String getSellerOrdersRefund(Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }
        try {
            List<OrderSellerResponse> orderSellerResponse = sellerService.getAllOrderRefund(authentication);

            model.addAttribute("orders", orderSellerResponse);
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/home";
        }
        return "seller/orders_refund";
    }

    @GetMapping("/seller/orders-accepted")
    public String getSellerOrdersAccepted(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) Long orderId,
            Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }
        try {
            List<OrderSellerResponse> allOrders = sellerService.getAllOrderAccepted(authentication);

            // Filter by orderId if provided
            if (orderId != null) {
                allOrders = allOrders.stream()
                        .filter(order -> order.getOrderId().equals(orderId))
                        .collect(java.util.stream.Collectors.toList());
            }

            // Calculate pagination
            int totalOrders = allOrders.size();
            int totalPages = (int) Math.ceil((double) totalOrders / size);

            // Validate page number
            if (page < 1) {
                page = 1;
            }
            if (page > totalPages && totalPages > 0) {
                page = totalPages;
            }

            // Get orders for current page
            int startIndex = (page - 1) * size;
            int endIndex = Math.min(startIndex + size, totalOrders);

            List<OrderSellerResponse> paginatedOrders;
            if (startIndex < totalOrders) {
                paginatedOrders = allOrders.subList(startIndex, endIndex);
            } else {
                paginatedOrders = java.util.Collections.emptyList();
            }

            model.addAttribute("orders", paginatedOrders);
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("pageSize", size);
            model.addAttribute("totalOrders", totalOrders);
            model.addAttribute("startIndex", startIndex + 1);
            model.addAttribute("endIndex", endIndex);
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/home";
        }
        return "seller/orders_accepted";
    }

    @GetMapping("/seller/orders-shipping")
    public String getSellerOrdersShipping(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) Long orderId,
            Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }
        try {
            List<OrderSellerResponse> allOrders = sellerService.getAllOrdersShipping(authentication);

            // Filter by orderId if provided
            if (orderId != null) {
                final Long searchId = orderId;
                allOrders = allOrders.stream()
                        .filter(order -> searchId.equals(order.getOrderId()))
                        .collect(java.util.stream.Collectors.toList());
            }

            // Calculate pagination
            int totalOrders = allOrders.size();
            int totalPages = (int) Math.ceil((double) totalOrders / size);

            // Validate page number
            if (page < 1) {
                page = 1;
            }
            if (page > totalPages && totalPages > 0) {
                page = totalPages;
            }

            // Get orders for current page
            int startIndex = (page - 1) * size;
            int endIndex = Math.min(startIndex + size, totalOrders);

            List<OrderSellerResponse> paginatedOrders;
            if (startIndex < totalOrders) {
                paginatedOrders = allOrders.subList(startIndex, endIndex);
            } else {
                paginatedOrders = java.util.Collections.emptyList();
            }

            model.addAttribute("orders", paginatedOrders);
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("pageSize", size);
            model.addAttribute("totalOrders", totalOrders);
            model.addAttribute("startIndex", startIndex + 1);
            model.addAttribute("endIndex", endIndex);
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/home";
        }
        return "seller/orders_shipping";
    }

    @GetMapping("/seller/orders-delivered")
    public String getSellerOrdersDelivered(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) Long orderId,
            Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }
        try {
            List<OrderSellerResponse> allOrders = sellerService.getAllOrdersDelivered(authentication);

            // Filter by orderId if provided
            if (orderId != null) {
                final Long searchId = orderId;
                allOrders = allOrders.stream()
                        .filter(order -> searchId.equals(order.getOrderId()))
                        .collect(java.util.stream.Collectors.toList());
            }

            // Calculate pagination
            int totalOrders = allOrders.size();
            int totalPages = (int) Math.ceil((double) totalOrders / size);

            // Validate page number
            if (page < 1) {
                page = 1;
            }
            if (page > totalPages && totalPages > 0) {
                page = totalPages;
            }

            // Get orders for current page
            int startIndex = (page - 1) * size;
            int endIndex = Math.min(startIndex + size, totalOrders);

            List<OrderSellerResponse> paginatedOrders;
            if (startIndex < totalOrders) {
                paginatedOrders = allOrders.subList(startIndex, endIndex);
            } else {
                paginatedOrders = java.util.Collections.emptyList();
            }

            model.addAttribute("orders", paginatedOrders);
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("pageSize", size);
            model.addAttribute("totalOrders", totalOrders);
            model.addAttribute("startIndex", startIndex + 1);
            model.addAttribute("endIndex", endIndex);
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/home";
        }
        return "seller/orders_delivered";
    }

    @GetMapping("/seller/order/{orderId}")
    public String getOrderDetail(@PathVariable("orderId") Long orderId, Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }
        try {
            OrderSellerResponse order = sellerService.getOrderById(orderId, authentication);
            model.addAttribute("order", order);
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/seller/all-orders";
        }
        return "seller/order_detail";
    }

    @PostMapping("/seller/orders-refund/{orderId}/process")
    public ResponseEntity<String> processOrderRefund(
            @PathVariable("orderId") Long orderId,
            @RequestParam String trantype,
            @RequestParam int percent,
            Authentication authentication,
            HttpServletRequest request) {

        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body("Vui lòng đăng nhập để thực hiện.");
        }
        String paymentMethod = sellerService.getPaymentMethodByOrderId(orderId);
        if (paymentMethod.equals("COD")) {
            try {
                sellerService.acceptOrderRefund(orderId, authentication);
                return ResponseEntity.ok("Hoàn tiền thành công cho đơn COD!");
            } catch (IllegalArgumentException e) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body("Lỗi khi xử lý hoàn tiền: " + e.getMessage());
            }
        }

        try {

            String refundResult = paymentService.handleRefund(orderId, trantype, percent, request);

            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(refundResult);
            String responseCode = root.path("vnp_ResponseCode").asText();
            String txnStatus = root.path("vnp_TransactionStatus").asText();
            System.out.println("Refund Response Code: " + responseCode);
            System.out.println("Refund Transaction Status: " + txnStatus);
            if ("00".equals(responseCode) && "05".equals(txnStatus)) {
                sellerService.acceptOrderRefund(orderId, authentication);
                return ResponseEntity.ok("Hoàn tiền thành công! API trả về: " + refundResult);
            } else {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body("Hoàn tiền thất bại hoặc chưa xác nhận. API trả về: " + refundResult);
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Lỗi khi xử lý hoàn tiền: " + e.getMessage());
        }
    }

}
