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
        //     throw new RuntimeException("Chưa xác thực số điện thoại.");
        // }
        // lấy số lượng trước khi order
        if (request.getOrderItems() != null) {
            for (OrderRequest.OrderItemRequest itemReq : request.getOrderItems()) {
                Product product = productRepository.findById(itemReq.getProductId())
                        .orElseThrow(() -> new RuntimeException("Product not found: " + itemReq.getProductId()));

                if (product.getStock() < itemReq.getQuantity()) {
                    throw new RuntimeException("Không đủ số lượng sản phẩm " + product.getName()
                            + ". Còn lại: " + product.getStock() + ", yêu cầu: " + itemReq.getQuantity());
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
        // **Chuyển LocalDateTime sang String đã format**
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
    public void cancelOrder(Long orderId) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));
        System.out.println("Order status: " + order.getStatus());
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

            System.out.println("Restored stock for product " + product.getName()
                    + ": " + (restoredStock - item.getQuantity()) + " -> " + restoredStock);
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

        // cập nhật số lượng
        for (OrderItem item : orderItems) {
            Product product = productRepository.findById(item.getProductId())
                    .orElseThrow(() -> new RuntimeException("Product not found: " + item.getProductId()));

            int newStock = product.getStock() - item.getQuantity();

            if (newStock < 0) {
                throw new RuntimeException("Insufficient stock for product: " + product.getName());
            }

            product.setStock(newStock);
            productRepository.save(product);

            System.out.println("Updated stock for product " + product.getName()
                    + ": " + (product.getStock() + item.getQuantity()) + " -> " + newStock);
        }

        // Update order status to PAID
        order.setStatus("PAID");
        orderRepository.save(order);
    }

    @Override
    public void refundOrderRequest(Long orderId) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));

        if (!order.getStatus().equals("DELIVERED")) {
            throw new IllegalArgumentException("Only DELIVERED orders can be refunded.");
        }

        // Update order status to REFUNDED_REQUESTED
        // Chỉ đổi status, chưa hoàn stock
        // Stock sẽ được hoàn khi seller chấp nhận hoàn tiền
        order.setStatus("REFUNDED_REQUESTED");
        orderRepository.save(order);
    }

}
