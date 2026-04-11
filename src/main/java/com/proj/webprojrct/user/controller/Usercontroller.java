package com.proj.webprojrct.user.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.proj.webprojrct.common.config.security.CustomUserDetails;
import com.proj.webprojrct.user.dto.request.UserAdminUpdateRequest;
import com.proj.webprojrct.user.dto.request.UserUpdateRequest;
import com.proj.webprojrct.user.dto.response.UserResponse;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.service.UserService;
import com.proj.webprojrct.order.service.OrderService;

import lombok.NoArgsConstructor;

import com.proj.webprojrct.user.dto.request.UserCreateRequest;
import com.proj.webprojrct.user.dto.response.UserAdminResponse;
import com.proj.webprojrct.user.dto.response.UserResponse;
import com.proj.webprojrct.user.entity.UserRole;

@NoArgsConstructor
@Controller
public class Usercontroller {

    @Autowired
    private UserService userService;

    @Autowired
    private OrderService orderService;

    @GetMapping("/profile")
    public String getUserProfile(Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        try {
            UserResponse userResponse = userService.handleGetUserProfile(authentication);
            model.addAttribute("user", userResponse);

            // Get user statistics
            try {
                CustomUserDetails cud = (CustomUserDetails) authentication.getPrincipal();
                com.proj.webprojrct.user.entity.User u = cud.getUser();
                Long userId = u.getId();

                // Get total orders and total spent
                int totalOrders = orderService.getTotalOrdersByUserId(userId);
                double totalSpent = orderService.getTotalSpentByUserId(userId);

                model.addAttribute("totalOrders", totalOrders);
                model.addAttribute("totalSpent", totalSpent);

                // Lấy tất cả đơn hàng và 3 đơn gần nhất
                var allOrders = orderService.getOrdersByUserId(userId);
                var recentOrders = allOrders.stream().limit(3).toList();
                model.addAttribute("recentOrders", recentOrders);
                model.addAttribute("orders", allOrders);

                // Verification flags
                boolean verifyPhone = u.getVerifyPhone() != null && u.getVerifyPhone();
                boolean verifyEmail = u.getVerifyEmail() != null && u.getVerifyEmail();
                model.addAttribute("verifyPhone", verifyPhone);
                model.addAttribute("verifyEmail", verifyEmail);
            } catch (Exception e) {
                model.addAttribute("totalOrders", 0);
                model.addAttribute("totalSpent", 0.0);
                model.addAttribute("verifyPhone", false);
                model.addAttribute("verifyEmail", false);
            }
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
        }

        return "user/profile";
    }

    @PostMapping("/profile-update")
    public String handleUpdateUserProfile(
            @ModelAttribute UserUpdateRequest userReq,
            @RequestParam(value = "avt", required = false) MultipartFile avt,
            Model model) {

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        try {
            UserResponse updatedUser = userService.updateCurrentUserProfile(authentication, userReq, avt);
            model.addAttribute("user", updatedUser);
            return "redirect:/profile";
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/profile";
        }
    }
}
