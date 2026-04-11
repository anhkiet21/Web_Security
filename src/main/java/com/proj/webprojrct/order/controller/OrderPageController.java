package com.proj.webprojrct.order.controller;

import com.proj.webprojrct.order.dto.response.OrderResponse;
import com.proj.webprojrct.order.service.OrderService;
import com.proj.webprojrct.common.config.security.CustomUserDetails;
import com.proj.webprojrct.payment.entity.Payment;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/order")
public class OrderPageController {

    @Autowired
    private OrderService orderService;

    @GetMapping("/create")
    public String createOrderPage(Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        if (userDetails == null) {
            return "redirect:/login";
        }

        model.addAttribute("user", userDetails.getUser());
        return "user/order_create"; // JSP: order_create.jsp
    }

    // Trang chi tiết đơn hàng theo orderId
    @GetMapping("/{orderId}")
    public String viewOrder(@PathVariable Long orderId, Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        if (userDetails == null) {
            return "redirect:/login";
        }

        OrderResponse order = orderService.getOrderById(orderId);
        Payment statusPayment = orderService.updateOrderPayment(orderId);

        // Bảo mật: chỉ user tạo đơn mới xem được
        if (!order.getUserId().equals(userDetails.getUser().getId())) {
            return "redirect:/shop";
        }
        model.addAttribute("statusPayment", statusPayment);
        model.addAttribute("order", order);
        model.addAttribute("user", userDetails.getUser());
        return "user/order_detail"; // JSP: order_detail.jsp
    }

    // Trang danh sách đơn hàng của user
    @GetMapping
    public String listOrders(Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        if (userDetails == null) {
            return "redirect:/login";
        }

        model.addAttribute("orders", orderService.getOrdersByUserId(userDetails.getUser().getId()));
        return "user/order_list"; // JSP: order_list.jsp
    }

    @GetMapping("/success/{orderId}")
    public String orderSuccess(@PathVariable Long orderId, Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        if (userDetails == null) {
            return "redirect:/login";
        }

        OrderResponse order = orderService.getOrderById(orderId);

        // Security check: only order creator can view success page
        if (!order.getUserId().equals(userDetails.getUser().getId())) {
            return "redirect:/shop";
        }

        model.addAttribute("orderId", orderId);
        model.addAttribute("order", order);
        model.addAttribute("user", userDetails.getUser());
        return "user/order_success";
    }
}
