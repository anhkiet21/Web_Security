package com.proj.webprojrct.admin.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.proj.webprojrct.user.dto.request.UserCreateRequest;
import com.proj.webprojrct.common.config.security.CustomUserDetails;
import com.proj.webprojrct.user.dto.request.UserAdminUpdateRequest;
import com.proj.webprojrct.user.dto.response.UserAdminResponse;
import com.proj.webprojrct.user.entity.UserRole;
import com.proj.webprojrct.user.service.UserService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.proj.webprojrct.user.entity.User;

@Controller
public class AdminUserController {

    private static final Logger logger = LoggerFactory.getLogger(AdminUserController.class);

    @Autowired
    private UserService userService;

    @GetMapping("/admin/users")
    public String getAllAdminUsers(
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "size", defaultValue = "10") int size,
            @RequestParam(value = "phone", required = false) String phone,
            @RequestParam(value = "fullname", required = false) String fullname,
            @RequestParam(value = "email", required = false) String email,
            @RequestParam(value = "role", required = false) String role,
            @RequestParam(value = "active", required = false) Boolean active,
            Model model, Authentication authentication) {
        authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Access denied: Only ADMIN users can access category management.");
        }

        try {
            logger.debug("Getting users with filters - page: {}, size: {}, phone: {}, fullname: {}, email: {}, role: {}, active: {}",
                    page, size, phone, fullname, email, role, active);

            // Tạo pageable với sắp xếp theo ID
            Pageable pageable = PageRequest.of(page, size, Sort.by("id").ascending());

            // Gọi service với pageable và các filter
            Page<UserAdminResponse> userPage = userService.getPagedUsers(
                    authentication, pageable, phone, fullname, email, role, active);

            // Thêm dữ liệu vào model
            model.addAttribute("users", userPage);

            // Thêm các tham số filter vào model để giữ trạng thái
            if (phone != null) {
                model.addAttribute("filterPhone", phone);
            }
            if (fullname != null) {
                model.addAttribute("filterFullname", fullname);
            }
            if (email != null) {
                model.addAttribute("filterEmail", email);
            }
            if (role != null) {
                model.addAttribute("filterRole", role);
            }
            if (active != null) {
                model.addAttribute("filterActive", active.toString());
            }

            return "admin/users";
        } catch (RuntimeException e) {
            logger.error("Error getting users", e);
            model.addAttribute("error", e.getMessage());
            return "admin/users";
        }
    }

    @PostMapping("/admin/createUser")
    public String handleCreateUser(@ModelAttribute UserCreateRequest userCreateRequest,
            Model model, Authentication authentication) {

        authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Access denied: Only ADMIN users can access category management.");
        }

        try {
            userService.handleCreateUser(authentication, userCreateRequest);
            return "redirect:/admin/users";
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            // reload users to show the page
            try {
                model.addAttribute("users", userService.getAllUsers(authentication));
            } catch (Exception ex) {
                // ignore
            }
            return "admin/users";
        }
    }

    @PostMapping("/admin/updateUser/{id}")
    public String handleUpdateUser(@PathVariable("id") Long userId,
            @ModelAttribute UserAdminUpdateRequest updateRequest,
            Model model, Authentication authentication) {
        authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Access denied: Only ADMIN users can access category management.");
        }

        try {
            userService.handleUpdateUser(authentication, updateRequest, userId);
            return "redirect:/admin/users";
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            return "admin/users";
        }
    }

    @PostMapping("/admin/deleteUser/{id}")
    public String handleDeleteUser(@PathVariable("id") long userId,
            Model model, Authentication authentication) {
        authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Access denied: Only ADMIN users can access category management.");
        }
        try {
            userService.handleDeleteUser(authentication, userId);
            return "redirect:/admin/users";
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/admin/users";
        }
    }
}
