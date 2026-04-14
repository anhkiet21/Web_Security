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
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service
public class OrderServiceImpl implements OrderService {

    private static final Logger log = LoggerFactory.getLogger(OrderServiceImpl.class);

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
    @Transactional // FIX V-22: Bọc toàn bộ trong transaction để tránh race condition
    public OrderResponse createOrder(Long userId, OrderRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (request.getOrderItems() == null || request.getOrderItems().isEmpty()) {
            throw new RuntimeException("Đơn hàng phải có ít nhất 1 sản phẩm.");
        }

        // FIX V-21 + V-22: Validate quantity VÀ lock từng sản phẩm theo thứ tự ID tăng
        // dần
        // (sắp xếp để tránh deadlock khi nhiều transaction cùng lock)
        List<OrderRequest.OrderItemRequest> sortedItems = request.getOrderItems().stream()
                .sorted(java.util.Comparator.comparing(OrderRequest.OrderItemRequest::getProductId))
                .collect(Collectors.toList());

        BigDecimal serverTotalAmount = BigDecimal.ZERO;
        for (OrderRequest.OrderItemRequest itemReq : sortedItems) {
            // FIX V-21: Validate số lượng tại đây
            if (itemReq.getQuantity() <= 0) {
                throw new IllegalArgumentException("Số lượng sản phẩm phải lớn hơn 0");
            }
            if (itemReq.getQuantity() > 100) {
                throw new IllegalArgumentException("Số lượng mỗi sản phẩm không được vượt quá 100");
            }

            // FIX V-22: Dùng PESSIMISTIC_WRITE lock — chặn transaction khác đọc/ghi cùng
            // lúc
            Product product = productRepository.findByIdWithLock(itemReq.getProductId())
                    .orElseThrow(() -> new RuntimeException("Product not found: " + itemReq.getProductId()));

            if (product.getStock() < itemReq.getQuantity()) {
                throw new RuntimeException("Không đủ số lượng sản phẩm " + product.getName()
                        + ". Còn lại: " + product.getStock() + ", yêu cầu: " + itemReq.getQuantity());
            }

            // FIX V-22: Trừ stock ngay trong cùng transaction — không để TOCTOU
            product.setStock(product.getStock() - itemReq.getQuantity());
            productRepository.save(product);

            // FIX V-20: Lấy giá từ DB
            BigDecimal itemTotal = product.getPrice()
                    .multiply(BigDecimal.valueOf(itemReq.getQuantity()));
            serverTotalAmount = serverTotalAmount.add(itemTotal);
        }

        Order order = new Order();
        order.setUser(user);
        order.setStatus("PENDING");
        order.setTotalAmount(serverTotalAmount);
        order.setShippingAddress(request.getShippingAddress());
        order.setCreatedAt(LocalDateTime.now());
        order = orderRepository.save(order);

        final Order savedOrder = order;
        for (OrderRequest.OrderItemRequest itemReq : sortedItems) {
            OrderItem orderItem = new OrderItem();
            orderItem.setOrder(savedOrder);
            orderItem.setProductId(itemReq.getProductId());
            orderItem.setQuantity(itemReq.getQuantity());
            orderItem.setPrice(itemReq.getPrice());
            orderItemRepository.save(orderItem);
        }

        // Send order confirmation email
        try {
            sendOrderConfirmationEmail(user, savedOrder, request.getOrderItems());
        } catch (Exception e) {
            // Log error but don't fail the order
            log.error("Failed to send order confirmation email for order {}", savedOrder.getId(), e);
        }

        return getOrderById(savedOrder.getId());
    }

    private void sendOrderConfirmationEmail(User user, Order order, List<OrderRequest.OrderItemRequest> items) {
        StringBuilder emailBody = new StringBuilder();
        emailBody.append("Xin chào ").append(user.getFullName()).append(",\n\n");
        emailBody.append("Cảm ơn bạn đã đặt hàng tại CellPhoneStore!\n\n");
        emailBody.append("Chi tiết đơn hàng #").append(order.getId()).append(":\n");
        emailBody.append("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n");

        // Add order items
        for (OrderRequest.OrderItemRequest item : items) {
            Product product = productRepository.findById(item.getProductId()).orElse(null);
            if (product != null) {
                double itemPrice = item.getPrice().doubleValue();
                double itemTotal = itemPrice * item.getQuantity();
                emailBody.append(String.format("• %s\n", product.getName()));
                emailBody.append(String.format("  Số lượng: %d x %,.0fđ = %,.0fđ\n\n",
                        item.getQuantity(), itemPrice, itemTotal));
            }
        }

        emailBody.append("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");
        emailBody.append(String.format("Tổng tiền: %,.0fđ\n\n", order.getTotalAmount().doubleValue()));

        // Add shipping info
        emailBody.append("Thông tin giao hàng:\n");
        emailBody.append("Người nhận: ").append(user.getFullName()).append("\n");
        emailBody.append("Số điện thoại: ").append(user.getPhone()).append("\n");
        emailBody.append("Địa chỉ: ").append(order.getShippingAddress()).append("\n\n");

        emailBody.append("Đơn hàng sẽ được giao trong 2-3 ngày làm việc.\n");
        emailBody.append("Chúng tôi sẽ liên hệ với bạn để xác nhận đơn hàng.\n\n");
        emailBody.append("Cảm ơn bạn đã tin tưởng CellPhoneStore!\n\n");
        emailBody.append("---\n");
        emailBody.append("CellPhoneStore\n");
        emailBody.append("Email: kietccc21@gmail.com\n");
        emailBody.append("Hotline: +84 889-251-007");

        emailService.sendEmail(user.getEmail(),
                "Xác nhận đơn hàng #" + order.getId() + " - CellPhoneStore",
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

        // Sắp xếp đơn hàng theo thời gian tạo giảm dần (mới nhất trước)
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
    @Transactional 
    public void cancelOrder(Long orderId, long userId) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));

        if (order.getUser() == null || !order.getUser().getId().equals(userId)) {
            throw new AccessDeniedException("You do not have permission to cancel this order");
        }
        if (!order.getStatus().equals("PENDING") && !order.getStatus().equals("PAID")) {
            throw new IllegalArgumentException("Only PENDING or PAID orders can be cancelled.");
        }

        // Hoàn stock với lock để tránh race condition
        List<OrderItem> orderItems = orderItemRepository.findByOrder(order);
        for (OrderItem item : orderItems) {
            Product product = productRepository.findByIdWithLock(item.getProductId())
                    .orElseThrow(() -> new RuntimeException("Product not found: " + item.getProductId()));

            product.setStock(product.getStock() + item.getQuantity());
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
    @Transactional // FIX V-22: Race condition payment
    public void updateProductStockAfterPayment(Long orderId) {
        // FIX V-22: Stock da duoc tru tai createOrder() bang PESSIMISTIC_WRITE lock.
        // Method nay chi can xac nhan order thanh PAID - KHONG tru stock lan 2.
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));

        if (!"PENDING".equals(order.getStatus())) {
            return;
        }

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
        // Chỉ đổi status, chưa hoàn stock
        // Stock sẽ được hoàn khi seller chấp nhận hoàn tiền
        order.setStatus("REFUNDED_REQUESTED");
        orderRepository.save(order);
    }

}
