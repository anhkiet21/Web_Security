package com.proj.webprojrct.admin.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;
import java.util.List;

import org.springframework.security.core.Authentication;
import com.proj.webprojrct.admin.service.AdminStatsService;
import com.proj.webprojrct.common.config.security.CustomUserDetails;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.entity.UserRole;

@RestController
@RequestMapping("/admin/api/stats")
public class AdminStatsController {

    @Autowired
    private AdminStatsService statsService;

    @GetMapping("/overview")
    public Map<String, Object> overview() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Access denied: Only ADMIN users can access category management.");
        }

        return statsService.overview();
    }

    @GetMapping("/orders")
    public Map<String, Long> orders(
            @RequestParam String period,
            @RequestParam(required = false) String week,
            @RequestParam(required = false) Integer month,
            @RequestParam(required = false) Integer year) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Access denied: Only ADMIN users can access category management.");
        }

        return statsService.orders(period, week, month, year);
    }

    @GetMapping("/revenue")
    public Map<String, Double> revenue(
            @RequestParam String period,
            @RequestParam(required = false) String week,
            @RequestParam(required = false) Integer month,
            @RequestParam(required = false) Integer year) {

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Access denied: Only ADMIN users can access category management.");
        }

        return statsService.revenue(period, week, month, year);
    }

    @GetMapping("/top-products")
    public List<Map<String, Object>> topProducts(Integer limit) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Access denied: Only ADMIN users can access category management.");
        }

        return statsService.topProducts(limit);
    }

    @GetMapping("/users-by-time")
    public Map<String, Long> usersByTime(
            @RequestParam String period,
            @RequestParam(required = false) String week,
            @RequestParam(required = false) Integer month,
            @RequestParam(required = false) Integer year) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Access denied: Only ADMIN users can access category management.");
        }

        return statsService.usersByTime(period, week, month, year);
    }
}
