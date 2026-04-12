package com.proj.webprojrct.order.service.impl;

import com.proj.webprojrct.payment.entity.Payment;
import com.proj.webprojrct.payment.repository.PaymentRepository;
import com.proj.webprojrct.order.dto.request.OrderRequest;
import com.proj.webprojrct.order.dto.response.OrderResponse;
import com.proj.webprojrct.order.dto.response.OrderItemResponse;
import com.proj.webprojrct.order.entity.Order;
import com.proj.webprojrct.order.entity.OrderItem;
import com.proj.webprojrct.order.repository.OrderRepository;
import com.proj.webprojrct.order.repository.OrderItemRepository;
import com.proj.webprojrct.order.service.OrderService;
import com.proj.webprojrct.product.entity.Product;
import com.proj.webprojrct.product.entity.ProductImage;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.repository.UserRepository;
import com.proj.webprojrct.product.repository.ProductRepository;
import com.proj.webprojrct.product.repository.ProductImageRepository;
import com.proj.webprojrct.email.emailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import com.proj.webprojrct.payment.vnpay.service.PaymentService;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private OrderItemRepository orderItemRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private ProductImageRepository productImageRepository;

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private emailService emailService;

    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

    @Override
    public OrderResponse createOrder(Long userId, OrderRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        // TODO: UNCOMMENT THIS LINE WHEN PHONE VERIFICATION IS READY
        // if (!user.getVerifyPhone()) {
        //     throw new RuntimeException("ChÆ°a xÃ¡c thá»±c sá»‘ Ä‘iá»‡n thoáº¡i.");
        // }
        // láº¥y sá»‘ lÆ°á»£ng trÆ°á»›c khi order
        if (request.getOrderItems() != null) {
            for (OrderRequest.OrderItemRequest itemReq : request.getOrderItems()) {
                Product product = productRepository.findById(itemReq.getProductId())
                        .orElseThrow(() -> new RuntimeException("Product not found: " + itemReq.getProductId()));

                if (product.getStock() < itemReq.getQuantity()) {
                    throw new RuntimeException("KhÃ´ng Ä‘á»§ sá»‘ lÆ°á»£ng sáº£n pháº©m " + product.getName()
                            + ". CÃ²n láº¡i: " + product.getStock() + ", yÃªu cáº§u: " + itemReq.getQuantity());
                }
            }
        }

        Order order = new Order();
        order.setUser(user);
        order.setStatus("PENDING");
        order.setTotalAmount(request.getTotalAmount());
        order.setShippingAddress(request.getShippingAddress()); // Use address from request
        order.setCreatedAt(LocalDateTime.now());
        order = orderRepository.save(order);

        final Order savedOrder = order;
        if (request.getOrderItems() != null) {
            for (OrderRequest.OrderItemRequest itemReq : request.getOrderItems()) {
                OrderItem orderItem = new OrderItem();
                orderItem.setOrder(savedOrder);
                orderItem.setProductId(itemReq.getProductId());
                orderItem.setQuantity(itemReq.getQuantity());
                orderItem.setPrice(itemReq.getPrice());
                orderItemRepository.save(orderItem);
            }
        }

        // Send order confirmation email
        try {
            sendOrderConfirmationEmail(user, savedOrder, request.getOrderItems());
        } catch (Exception e) {
            // Log error but don't fail the order
            System.err.println("Failed to send order confirmation email: " + e.getMessage());
        }

        return getOrderById(savedOrder.getId());
    }

    private void sendOrderConfirmationEmail(User user, Order order, List<OrderRequest.OrderItemRequest> items) {
        StringBuilder emailBody = new StringBuilder();
        emailBody.append("Xin chÃ o ").append(user.getFullName()).append(",\n\n");
        emailBody.append("Cáº£m Æ¡n báº¡n Ä‘Ã£ Ä‘áº·t hÃ ng táº¡i CellPhoneStore!\n\n");
        emailBody.append("Chi tiáº¿t Ä‘Æ¡n hÃ ng #").append(order.getId()).append(":\n");
        emailBody.append("â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n\n");

        // Add order items
        for (OrderRequest.OrderItemRequest item : items) {
            Product product = productRepository.findById(item.getProductId()).orElse(null);
            if (product != null) {
                double itemPrice = item.getPrice().doubleValue();
                double itemTotal = itemPrice * item.getQuantity();
                emailBody.append(String.format("â€¢ %s\n", product.getName()));
                emailBody.append(String.format("  Sá»‘ lÆ°á»£ng: %d x %,.0fÄ‘ = %,.0fÄ‘\n\n",
                        item.getQuantity(), itemPrice, itemTotal));
            }
        }

        emailBody.append("â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n");
        emailBody.append(String.format("Tá»•ng tiá»n: %,.0fÄ‘\n\n", order.getTotalAmount().doubleValue()));

        // Add shipping info
        emailBody.append("ThÃ´ng tin giao hÃ ng:\n");
        emailBody.append("NgÆ°á»i nháº­n: ").append(user.getFullName()).append("\n");
        emailBody.append("Sá»‘ Ä‘iá»‡n thoáº¡i: ").append(user.getPhone()).append("\n");
        emailBody.append("Äá»‹a chá»‰: ").append(order.getShippingAddress()).append("\n\n");

        emailBody.append("ÄÆ¡n hÃ ng sáº½ Ä‘Æ°á»£c giao trong 2-3 ngÃ y lÃ m viá»‡c.\n");
        emailBody.append("ChÃºng tÃ´i sáº½ liÃªn há»‡ vá»›i báº¡n Ä‘á»ƒ xÃ¡c nháº­n Ä‘Æ¡n hÃ ng.\n\n");
        emailBody.append("Cáº£m Æ¡n báº¡n Ä‘Ã£ tin tÆ°á»Ÿng CellPhoneStore!\n\n");
        emailBody.append("---\n");
        emailBody.append("CellPhoneStore\n");
        emailBody.append("Email: kietccc21@gmail.com\n");
        emailBody.append("Hotline: +84 889-251-007");

        emailService.sendEmail(user.getEmail(),
                "XÃ¡c nháº­n Ä‘Æ¡n hÃ ng #" + order.getId() + " - CellPhoneStore",
                emailBody.toString());
    }

    @Override
    public OrderResponse getOrderById(Long orderId) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));

        return buildOrderResponse(order);
    }

    @Override
    public OrderResponse getOrderById(Long orderId, Long userId) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));

        if (order.getUser() == null || !order.getUser().getId().equals(userId)) {
            throw new AccessDeniedException("Order has no associated user or user is not authorized");
        }

        return buildOrderResponse(order);
    }

    private OrderResponse buildOrderResponse(Order order) {
        List<OrderItem> items = orderItemRepository.findByOrder(order);
        List<OrderItemResponse> itemResponses = items.stream().map(item -> {
            OrderItemResponse resp = new OrderItemResponse();
            resp.setOrderItemId(item.getId());
            resp.setOrderId(item.getOrder().getId());
            resp.setProductId(item.getProductId());
            resp.setQuantity(item.getQuantity());
            resp.setPrice(item.getPrice());

            Product product = productRepository.findById(item.getProductId())
                    .orElseThrow(() -> new RuntimeException("Product not found"));
            resp.setProductName(product.getName());

            List<ProductImage> images = productImageRepository.findByProduct(product);
            if (!images.isEmpty()) {
                resp.setProductImageUrl(images.get(0).getUrl());
            } else {
                resp.setProductImageUrl(null);
            }
            return resp;
        }).collect(Collectors.toList());

        OrderResponse response = new OrderResponse();
        response.setOrderId(order.getId());
        response.setUserId(order.getUser().getId());
        response.setStatus(order.getStatus());
        response.setTotalAmount(order.getTotalAmount());
        response.setShippingAddress(order.getShippingAddress());
        response.setCreatedAt(order.getCreatedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")));
        response.setCancelNote(order.getCancelNote());
        response.setItems(itemResponses);
        return response;
    }

    @Override
    public List<OrderResponse> getOrdersByUserId(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        List<Order> orders = orderRepository.findByUser(user);

        // Sáº¯p xáº¿p Ä‘Æ¡n hÃ ng theo thá»i gian táº¡o giáº£m dáº§n (má»›i nháº¥t trÆ°á»›c)
        orders.sort((o1, o2) -> o2.getCreatedAt().compareTo(o1.getCreatedAt()));

        return orders.stream().map(order -> {
            List<OrderItem> items = orderItemRepository.findByOrder(order);
            List<OrderItemResponse> itemResponses = items.stream().map(item -> {
                OrderItemResponse resp = new OrderItemResponse();
                resp.setOrderItemId(item.getId());
                resp.setOrderId(order.getId());
                resp.setProductId(item.getProductId());
                resp.setQuantity(item.getQuantity());
                resp.setPrice(item.getPrice());

                Product product = productRepository.findById(item.getProductId())
                        .orElseThrow(() -> new RuntimeException("Product not found"));
                resp.setProductName(product.getName());

                List<ProductImage> images = productImageRepository.findByProduct(product);
                if (!images.isEmpty()) {
                    resp.setProductImageUrl(images.get(0).getUrl());
                } else {
                    resp.setProductImageUrl(null);
                }
                return resp;
            }).collect(Collectors.toList());

            OrderResponse response = new OrderResponse();
            response.setOrderId(order.getId());
            response.setUserId(userId);
            response.setStatus(order.getStatus());
            response.setTotalAmount(order.getTotalAmount());
            response.setShippingAddress(order.getShippingAddress());
            response.setCreatedAt(order.getCreatedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")));
            response.setCancelNote(order.getCancelNote());
            response.setItems(itemResponses);
            return response;
        }).collect(Collectors.toList());
    }

    @Override
    public void cancelOrder(Long orderId,long userId) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));


        if (order.getUser() == null || !order.getUser().getId().equals(userId)) {
            throw new AccessDeniedException("You do not have permission to cancel this order");
        }
        if (!order.getStatus().equals("PENDING") && !order.getStatus().equals("PAID")) {
            throw new IllegalArgumentException("Only PENDING or PAID orders can be cancelled.");
        }

        // Restore product stock when cancelling
        List<OrderItem> orderItems = orderItemRepository.findByOrder(order);
        for (OrderItem item : orderItems) {
            Product product = productRepository.findById(item.getProductId())
                    .orElseThrow(() -> new RuntimeException("Product not found: " + item.getProductId()));

            int restoredStock = product.getStock() + item.getQuantity();
            product.setStock(restoredStock);
            productRepository.save(product);
        }

        order.setStatus("CANCELLED");
        orderRepository.save(order);
    }

    @Override
    public Payment updateOrderPayment(Long orderId) {
        Payment existingPayment = paymentRepository.findByOrderId(orderId);
        if (existingPayment == null) {
            return null;
        }
        return existingPayment;
    }

    @Override
    public int getTotalOrdersByUserId(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        List<Order> orders = orderRepository.findByUser(user);
        return orders.size();
    }

    @Override
    public double getTotalSpentByUserId(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        List<Order> orders = orderRepository.findByUser(user);

        return orders.stream()
                .filter(order -> !"CANCELLED".equals(order.getStatus())) // Exclude cancelled orders
                .mapToDouble(order -> order.getTotalAmount().doubleValue())
                .sum();
    }

    @Override
    public Order getOrderByOrderId(Long orderId) {
        return orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));
    }

    @Override
    public void updateProductStockAfterPayment(Long orderId) {
        // Get order and its items
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));

        List<OrderItem> orderItems = orderItemRepository.findByOrder(order);

        // cáº­p nháº­t sá»‘ lÆ°á»£ng
        for (OrderItem item : orderItems) {
            Product product = productRepository.findById(item.getProductId())
                    .orElseThrow(() -> new RuntimeException("Product not found: " + item.getProductId()));

            int newStock = product.getStock() - item.getQuantity();

            if (newStock < 0) {
                throw new RuntimeException("Insufficient stock for product: " + product.getName());
            }

            product.setStock(newStock);
            productRepository.save(product);
        }

        // Update order status to PAID
        order.setStatus("PAID");
        orderRepository.save(order);
    }

    @Override
    public void refundOrderRequest(Long orderId, Long userId) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));

        if (!order.getStatus().equals("DELIVERED")) {
            throw new IllegalArgumentException("Only DELIVERED orders can be refunded.");
        }
        if (order.getUser() == null || !order.getUser().getId().equals(userId)) {
            throw new AccessDeniedException("You do not have permission to refund this order");
        }

        // Update order status to REFUNDED_REQUESTED
        // Chá»‰ Ä‘á»•i status, chÆ°a hoÃ n stock
        // Stock sáº½ Ä‘Æ°á»£c hoÃ n khi seller cháº¥p nháº­n hoÃ n tiá»n
        order.setStatus("REFUNDED_REQUESTED");
        orderRepository.save(order);
    }

}
