package com.proj.webprojrct.seller.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import jakarta.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;
import org.springframework.security.core.Authentication;

import com.proj.webprojrct.order.entity.Order;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.order.entity.OrderItem;
import com.proj.webprojrct.order.repository.OrderRepository;
import com.proj.webprojrct.common.config.security.CustomUserDetails;
import com.proj.webprojrct.order.dto.response.OrderItemResponse;
import com.proj.webprojrct.order.dto.response.OrderSellerResponse;
import com.proj.webprojrct.payment.entity.Payment;
import com.proj.webprojrct.payment.repository.PaymentRepository;
import com.proj.webprojrct.payment.vnpay.service.PaymentService;
import com.proj.webprojrct.user.entity.UserRole;
import com.proj.webprojrct.product.entity.Product;
import com.proj.webprojrct.product.repository.ProductRepository;
import com.proj.webprojrct.product.entity.ProductImage;
import com.proj.webprojrct.product.repository.ProductImageRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SellerService {

    private final OrderRepository orderRepository;
    private final PaymentRepository paymentRepository;
    private final ProductRepository productRepository;
    private final ProductImageRepository productImageRepository;
    private final PaymentService paymentService;

    public List<OrderSellerResponse> getAllOrders(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() == null || (user.getRole() != UserRole.SELLER && user.getRole() != UserRole.ADMIN)) {
            throw new IllegalArgumentException("User is not a seller or admin");
        }
        List<Order> orders = orderRepository.findAll();
        List<OrderSellerResponse> orderResponses = new ArrayList<>();

        for (Order order : orders) {
            if (order == null || order.getId() == null) {
                continue;
            }

            String paymentStatus = getPaymentStatusByOrderId(order.getId());
            String paymentMethod = getPaymentMethodByOrderId(order.getId());

            List<OrderItemResponse> orderItemResponses = new ArrayList<>();
            if (order.getOrderItems() == null || order.getOrderItems().isEmpty()) {
                continue;
            }

            for (OrderItem item : order.getOrderItems()) {
                if (item == null) {
                    continue;
                }
                Product product = productRepository.findById(item.getProductId()).orElse(null);
                ProductImage productImage = productImageRepository.findFirstByProductOrderByIdAsc(product).orElse(null);

                OrderItemResponse itemResponse = new OrderItemResponse();
                itemResponse.setOrderItemId(item.getId());
                itemResponse.setOrderId(order.getId());
                itemResponse.setProductId(item.getProductId());
                itemResponse.setQuantity(item.getQuantity());
                itemResponse.setPrice(item.getPrice());
                itemResponse.setProductName(product != null ? product.getName() : "Unknown Product");
                itemResponse.setProductImageUrl(productImage != null ? productImage.getUrl() : null);
                orderItemResponses.add(itemResponse);
            }

            OrderSellerResponse orderSellerResponse = new OrderSellerResponse(
                    order.getId(),
                    order.getUser() != null ? order.getUser().getId() : null,
                    order.getStatus(),
                    paymentStatus,
                    paymentMethod,
                    order.getTotalAmount(),
                    order.getShippingAddress(),
                    order.getCreatedAt() != null ? order.getCreatedAt().toString() : null,
                    orderItemResponses
            );

            orderResponses.add(orderSellerResponse);
        }

        return orderResponses;
    }

    public List<OrderSellerResponse> getOrdersPaid(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() == null || (user.getRole() != UserRole.SELLER && user.getRole() != UserRole.ADMIN)) {
            throw new IllegalArgumentException("User is not a seller or admin");
        }
        List<OrderSellerResponse> orderResponses = new ArrayList<>();
        List<String> allowedStatuses = Arrays.asList("PAID");
        List<Order> orders = orderRepository.findByStatusIn(allowedStatuses);
        for (Order order : orders) {
            if (order == null || order.getId() == null) {
                continue;
            }

            String paymentStatus = getPaymentStatusByOrderId(order.getId());
            String paymentMethod = getPaymentMethodByOrderId(order.getId());

            // Chá»‰ láº¥y Ä‘Æ¡n Ä‘Ã£ thanh toÃ¡n thÃ nh cÃ´ng hoáº·c COD
            if (!"SUCCESS".equalsIgnoreCase(paymentStatus) && !"COD".equalsIgnoreCase(paymentMethod)) {
                continue;
            }

            List<OrderItemResponse> orderItemResponses = new ArrayList<>();
            if (order.getOrderItems() == null || order.getOrderItems().isEmpty()) {
                continue;
            }

            for (OrderItem item : order.getOrderItems()) {
                if (item == null) {
                    continue;
                }
                Product product = productRepository.findById(item.getProductId()).orElse(null);
                ProductImage productImage = productImageRepository.findFirstByProductOrderByIdAsc(product).orElse(null);

                OrderItemResponse itemResponse = new OrderItemResponse();
                itemResponse.setOrderItemId(item.getId());
                itemResponse.setOrderId(order.getId());
                itemResponse.setProductId(item.getProductId());
                itemResponse.setQuantity(item.getQuantity());
                itemResponse.setPrice(item.getPrice());
                itemResponse.setProductName(product != null ? product.getName() : "Unknown Product");
                itemResponse.setProductImageUrl(productImage != null ? productImage.getUrl() : null);
                orderItemResponses.add(itemResponse);
            }

            OrderSellerResponse orderSellerResponse = new OrderSellerResponse(
                    order.getId(),
                    order.getUser() != null ? order.getUser().getId() : null,
                    order.getStatus(),
                    paymentStatus,
                    paymentMethod,
                    order.getTotalAmount(),
                    order.getShippingAddress(),
                    order.getCreatedAt() != null ? order.getCreatedAt().toString() : null,
                    orderItemResponses
            );

            orderResponses.add(orderSellerResponse);
        }

        return orderResponses;
    }

    public boolean acceptOrder(Long orderId, Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();

        if (user.getRole() == null || (user.getRole() != UserRole.SELLER && user.getRole() != UserRole.ADMIN)) {
            throw new IllegalArgumentException("User is not a seller or admin");
        }
        Order order = orderRepository.findById(orderId).orElse(null);
        if (order == null) {
            throw new IllegalArgumentException("Order not found with id: " + orderId);
        }
        order.setStatus("ACCEPTED");
        orderRepository.save(order);
        return true;
    }

    public boolean cancelOrder(Long orderId, String cancelNote, Authentication authentication, HttpServletRequest request) throws Exception {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();

        if (user.getRole() == null || (user.getRole() != UserRole.SELLER && user.getRole() != UserRole.ADMIN)) {
            throw new IllegalArgumentException("User is not a seller or admin");
        }

        Order order = orderRepository.findById(orderId).orElse(null);
        if (order == null) {
            throw new IllegalArgumentException("Order not found with id: " + orderId);
        }

        // Chá»‰ cho phÃ©p há»§y Ä‘Æ¡n hÃ ng cÃ³ tráº¡ng thÃ¡i PAID hoáº·c ACCEPTED
        if (!"PAID".equals(order.getStatus()) && !"ACCEPTED".equals(order.getStatus())) {
            throw new IllegalArgumentException("KhÃ´ng thá»ƒ há»§y Ä‘Æ¡n hÃ ng vá»›i tráº¡ng thÃ¡i: " + order.getStatus());
        }

        // Kiá»ƒm tra phÆ°Æ¡ng thá»©c thanh toÃ¡n
        String paymentMethod = getPaymentMethodByOrderId(orderId);
        String paymentStatus = getPaymentStatusByOrderId(orderId);

        boolean isRefunded = false;

        // Náº¿u lÃ  VNPay vÃ  Ä‘Ã£ thanh toÃ¡n thÃ nh cÃ´ng, thá»±c hiá»‡n hoÃ n tiá»n
        if ("VNPAY".equalsIgnoreCase(paymentMethod) && "SUCCESS".equalsIgnoreCase(paymentStatus)) {
            String refundResult = paymentService.handleRefund(orderId, "02", 100, request);

            // Kiá»ƒm tra káº¿t quáº£ hoÃ n tiá»n
            // VNPay tráº£ vá» JSON response vá»›i:
            // - vnp_ResponseCode = "00": Giao dá»‹ch thÃ nh cÃ´ng
            // - vnp_TransactionStatus = "05": Äang hoÃ n tiá»n
            if (refundResult == null
                    || !refundResult.contains("\"vnp_ResponseCode\":\"00\"")
                    || !refundResult.contains("\"vnp_TransactionStatus\":\"05\"")) {
                throw new Exception("HoÃ n tiá»n VNPay tháº¥t báº¡i. Vui lÃ²ng thá»­ láº¡i sau.");
            }
            isRefunded = true;
        }

        // Cáº­p nháº­t tráº¡ng thÃ¡i Ä‘Æ¡n hÃ ng thÃ nh CANCELLED
        order.setStatus("CANCELLED");
        order.setCancelNote(cancelNote);
        orderRepository.save(order);

        // HoÃ n láº¡i sá»‘ lÆ°á»£ng sáº£n pháº©m khi há»§y Ä‘Æ¡n
        restoreProductStock(order, "Order Cancelled");

        // LÆ°u thÃ´ng tin cÃ³ hoÃ n tiá»n hay khÃ´ng vÃ o cancelNote Ä‘á»ƒ hiá»ƒn thá»‹ sau
        if (isRefunded) {
            order.setCancelNote("[ÄÃƒ HOÃ€N TIá»€N] " + cancelNote);
            orderRepository.save(order);
        }

        // TODO: Gá»­i thÃ´ng bÃ¡o cho user vá» viá»‡c há»§y Ä‘Æ¡n
        return isRefunded;
    }

    public List<OrderSellerResponse> getAllOrderRefund(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() == null || (user.getRole() != UserRole.SELLER && user.getRole() != UserRole.ADMIN)) {
            throw new IllegalArgumentException("User is not a seller or admin");
        }
        List<String> allowedStatuses = Arrays.asList("REFUNDED_REQUESTED");
        List<Order> orders = orderRepository.findByStatusIn(allowedStatuses);

        List<OrderSellerResponse> orderResponses = new ArrayList<>();

        for (Order order : orders) {
            if (order == null || order.getId() == null) {
                continue;
            }

            String paymentStatus = getPaymentStatusByOrderId(order.getId());
            String paymentMethod = getPaymentMethodByOrderId(order.getId());
            if (!paymentStatus.equals("SUCCESS")) {
                continue;
            }
            List<OrderItemResponse> orderItemResponses = new ArrayList<>();
            if (order.getOrderItems() == null || order.getOrderItems().isEmpty()) {
                continue;
            }

            for (OrderItem item : order.getOrderItems()) {
                if (item == null) {
                    continue;
                }
                Product product = productRepository.findById(item.getProductId()).orElse(null);
                ProductImage productImage = productImageRepository.findFirstByProductOrderByIdAsc(product).orElse(null);

                OrderItemResponse itemResponse = new OrderItemResponse();
                itemResponse.setOrderItemId(item.getId());
                itemResponse.setOrderId(order.getId());
                itemResponse.setProductId(item.getProductId());
                itemResponse.setQuantity(item.getQuantity());
                itemResponse.setPrice(item.getPrice());
                itemResponse.setProductName(product != null ? product.getName() : "Unknown Product");
                itemResponse.setProductImageUrl(productImage != null ? productImage.getUrl() : null);
                orderItemResponses.add(itemResponse);
            }

            OrderSellerResponse orderSellerResponse = new OrderSellerResponse(
                    order.getId(),
                    order.getUser() != null ? order.getUser().getId() : null,
                    order.getStatus(),
                    paymentStatus,
                    paymentMethod,
                    order.getTotalAmount(),
                    order.getShippingAddress(),
                    order.getCreatedAt() != null ? order.getCreatedAt().toString() : null,
                    orderItemResponses
            );

            orderResponses.add(orderSellerResponse);
        }

        return orderResponses;
    }

    public boolean acceptOrderRefund(Long orderId, Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();

        if (user.getRole() == null || (user.getRole() != UserRole.SELLER && user.getRole() != UserRole.ADMIN)) {
            throw new IllegalArgumentException("User is not a seller or admin");
        }
        Order order = orderRepository.findById(orderId).orElse(null);
        if (order == null) {
            throw new IllegalArgumentException("Order not found with id: " + orderId);
        }

        // HoÃ n láº¡i sá»‘ lÆ°á»£ng sáº£n pháº©m khi cháº¥p nháº­n hoÃ n tiá»n
        restoreProductStock(order, "Refund Accepted");

        // Logic to process refund based on transType and percent
        order.setStatus("REFUNDED_ACCEPTED");
        orderRepository.save(order);
        return true;
    }

    public List<OrderSellerResponse> getAllOrderAccepted(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() == null || (user.getRole() != UserRole.SELLER && user.getRole() != UserRole.ADMIN)) {
            throw new IllegalArgumentException("User is not a seller or admin");
        }

        List<Order> orders = orderRepository.findByStatus("ACCEPTED");
        List<OrderSellerResponse> responses = new ArrayList<>();

        for (Order order : orders) {
            if (order == null || order.getId() == null) {
                continue;
            }

            String paymentStatus = getPaymentStatusByOrderId(order.getId());
            String paymentMethod = getPaymentMethodByOrderId(order.getId());

            List<OrderItemResponse> orderItemResponses = new ArrayList<>();
            if (order.getOrderItems() == null || order.getOrderItems().isEmpty()) {
                continue;
            }

            for (OrderItem item : order.getOrderItems()) {
                if (item == null) {
                    continue;
                }
                Product product = productRepository.findById(item.getProductId()).orElse(null);
                ProductImage productImage = productImageRepository.findFirstByProductOrderByIdAsc(product).orElse(null);

                OrderItemResponse itemResponse = new OrderItemResponse();
                itemResponse.setOrderItemId(item.getId());
                itemResponse.setOrderId(order.getId());
                itemResponse.setProductId(item.getProductId());
                itemResponse.setQuantity(item.getQuantity());
                itemResponse.setPrice(item.getPrice());
                itemResponse.setProductName(product != null ? product.getName() : "Unknown Product");
                itemResponse.setProductImageUrl(productImage != null ? productImage.getUrl() : null);
                orderItemResponses.add(itemResponse);
            }

            OrderSellerResponse orderSellerResponse = new OrderSellerResponse(
                    order.getId(),
                    order.getUser() != null ? order.getUser().getId() : null,
                    order.getStatus(),
                    paymentStatus,
                    paymentMethod,
                    order.getTotalAmount(),
                    order.getShippingAddress(),
                    order.getCreatedAt() != null ? order.getCreatedAt().toString() : null,
                    orderItemResponses
            );

            responses.add(orderSellerResponse);
        }
        return responses;
    }

    public boolean shipOrder(Long orderId, Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();

        if (user.getRole() == null || (user.getRole() != UserRole.SELLER && user.getRole() != UserRole.ADMIN)) {
            throw new IllegalArgumentException("User is not a seller or admin");
        }
        Order order = orderRepository.findById(orderId).orElse(null);
        if (order == null) {
            throw new IllegalArgumentException("Order not found with id: " + orderId);
        }
        order.setStatus("SHIPPING");
        orderRepository.save(order);
        return true;
    }

    public List<OrderSellerResponse> getAllOrdersShipping(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() == null || (user.getRole() != UserRole.SELLER && user.getRole() != UserRole.ADMIN)) {
            throw new IllegalArgumentException("User is not a seller or admin");
        }
        List<Order> orders = orderRepository.findByStatus("SHIPPING");
        List<OrderSellerResponse> responses = new ArrayList<>();

        for (Order order : orders) {
            if (order == null || order.getId() == null) {
                continue;
            }

            String paymentStatus = getPaymentStatusByOrderId(order.getId());
            String paymentMethod = getPaymentMethodByOrderId(order.getId());

            List<OrderItemResponse> orderItemResponses = new ArrayList<>();
            if (order.getOrderItems() == null || order.getOrderItems().isEmpty()) {
                continue;
            }

            for (OrderItem item : order.getOrderItems()) {
                if (item == null) {
                    continue;
                }
                Product product = productRepository.findById(item.getProductId()).orElse(null);
                ProductImage productImage = productImageRepository.findFirstByProductOrderByIdAsc(product).orElse(null);

                OrderItemResponse itemResponse = new OrderItemResponse();
                itemResponse.setOrderItemId(item.getId());
                itemResponse.setOrderId(order.getId());
                itemResponse.setProductId(item.getProductId());
                itemResponse.setQuantity(item.getQuantity());
                itemResponse.setPrice(item.getPrice());
                itemResponse.setProductName(product != null ? product.getName() : "Unknown Product");
                itemResponse.setProductImageUrl(productImage != null ? productImage.getUrl() : null);
                orderItemResponses.add(itemResponse);
            }

            OrderSellerResponse orderSellerResponse = new OrderSellerResponse(
                    order.getId(),
                    order.getUser() != null ? order.getUser().getId() : null,
                    order.getStatus(),
                    paymentStatus,
                    paymentMethod,
                    order.getTotalAmount(),
                    order.getShippingAddress(),
                    order.getCreatedAt() != null ? order.getCreatedAt().toString() : null,
                    orderItemResponses
            );

            responses.add(orderSellerResponse);
        }
        return responses;
    }

    public boolean deliverOrder(Long orderId, Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();

        if (user.getRole() == null || (user.getRole() != UserRole.SELLER && user.getRole() != UserRole.ADMIN)) {
            throw new IllegalArgumentException("User is not a seller or admin");
        }
        Order order = orderRepository.findById(orderId).orElse(null);
        if (order == null) {
            throw new IllegalArgumentException("Order not found with id: " + orderId);
        }
        Payment payment = paymentRepository.findByOrderId(orderId);
        if (payment.getMethod().equals("COD")) {
            payment.setStatus("SUCCESS");
            paymentRepository.save(payment);
        }
        order.setStatus("DELIVERED");
        orderRepository.save(order);
        return true;
    }

    public List<OrderSellerResponse> getAllOrdersDelivered(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() == null || (user.getRole() != UserRole.SELLER && user.getRole() != UserRole.ADMIN)) {
            throw new IllegalArgumentException("User is not a seller or admin");
        }
        List<Order> orders = orderRepository.findByStatus("DELIVERED");
        List<OrderSellerResponse> responses = new ArrayList<>();

        for (Order order : orders) {
            if (order == null || order.getId() == null) {
                continue;
            }

            String paymentStatus = getPaymentStatusByOrderId(order.getId());
            String paymentMethod = getPaymentMethodByOrderId(order.getId());

            List<OrderItemResponse> orderItemResponses = new ArrayList<>();
            if (order.getOrderItems() == null || order.getOrderItems().isEmpty()) {
                continue;
            }

            for (OrderItem item : order.getOrderItems()) {
                if (item == null) {
                    continue;
                }
                Product product = productRepository.findById(item.getProductId()).orElse(null);
                ProductImage productImage = productImageRepository.findFirstByProductOrderByIdAsc(product).orElse(null);

                OrderItemResponse itemResponse = new OrderItemResponse();
                itemResponse.setOrderItemId(item.getId());
                itemResponse.setOrderId(order.getId());
                itemResponse.setProductId(item.getProductId());
                itemResponse.setQuantity(item.getQuantity());
                itemResponse.setPrice(item.getPrice());
                itemResponse.setProductName(product != null ? product.getName() : "Unknown Product");
                itemResponse.setProductImageUrl(productImage != null ? productImage.getUrl() : null);
                orderItemResponses.add(itemResponse);
            }

            OrderSellerResponse orderSellerResponse = new OrderSellerResponse(
                    order.getId(),
                    order.getUser() != null ? order.getUser().getId() : null,
                    order.getStatus(),
                    paymentStatus,
                    paymentMethod,
                    order.getTotalAmount(),
                    order.getShippingAddress(),
                    order.getCreatedAt() != null ? order.getCreatedAt().toString() : null,
                    orderItemResponses
            );

            responses.add(orderSellerResponse);
        }
        return responses;
    }

    public OrderSellerResponse getOrderById(Long orderId, Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() == null || (user.getRole() != UserRole.SELLER && user.getRole() != UserRole.ADMIN)) {
            throw new IllegalArgumentException("User is not a seller or admin");
        }

        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Order not found with ID: " + orderId));

        String paymentStatus = getPaymentStatusByOrderId(order.getId());
        String paymentMethod = getPaymentMethodByOrderId(order.getId());

        List<OrderItemResponse> orderItemResponses = new ArrayList<>();
        if (order.getOrderItems() != null && !order.getOrderItems().isEmpty()) {
            for (OrderItem item : order.getOrderItems()) {
                if (item == null) {
                    continue;
                }
                Product product = productRepository.findById(item.getProductId()).orElse(null);
                ProductImage productImage = productImageRepository.findFirstByProductOrderByIdAsc(product).orElse(null);

                OrderItemResponse itemResponse = new OrderItemResponse();
                itemResponse.setOrderItemId(item.getId());
                itemResponse.setOrderId(order.getId());
                itemResponse.setProductId(item.getProductId());
                itemResponse.setQuantity(item.getQuantity());
                itemResponse.setPrice(item.getPrice());
                itemResponse.setProductName(product != null ? product.getName() : "Unknown Product");
                itemResponse.setProductImageUrl(productImage != null ? productImage.getUrl() : null);
                orderItemResponses.add(itemResponse);
            }
        }

        return new OrderSellerResponse(
                order.getId(),
                order.getUser() != null ? order.getUser().getId() : null,
                order.getStatus(),
                paymentStatus,
                paymentMethod,
                order.getTotalAmount(),
                order.getShippingAddress(),
                order.getCreatedAt() != null ? order.getCreatedAt().toString() : null,
                orderItemResponses
        );
    }

    public String getPaymentStatusByOrderId(Long orderId) {
        Payment p = paymentRepository.findByOrderId(orderId);
        if (p == null) {
            return "UNKNOWN";
        } else {
            return p.getStatus();
        }
    }

    public String getPaymentMethodByOrderId(Long orderId) {
        Payment p = paymentRepository.findByOrderId(orderId);
        if (p == null) {
            return "UNKNOWN";
        }
        return p.getMethod();
    }

    /**
     * HoÃ n láº¡i sá»‘ lÆ°á»£ng sáº£n pháº©m vÃ o kho khi há»§y Ä‘Æ¡n hoáº·c hoÃ n tiá»n
     *
     * @param order ÄÆ¡n hÃ ng cáº§n hoÃ n láº¡i stock
     * @param reason LÃ½ do hoÃ n (Ä‘á»ƒ log)
     */
    private void restoreProductStock(Order order, String reason) {
        List<OrderItem> orderItems = order.getOrderItems();
        if (orderItems == null || orderItems.isEmpty()) {
            return;
        }

        for (OrderItem item : orderItems) {
            Product product = productRepository.findById(item.getProductId()).orElse(null);
            if (product != null) {
                int restoredStock = product.getStock() + item.getQuantity();
                product.setStock(restoredStock);
                productRepository.save(product);
            } else {
                System.err.println("Product not found with ID: " + item.getProductId() + " for order #" + order.getId());
            }
        }
    }

}
