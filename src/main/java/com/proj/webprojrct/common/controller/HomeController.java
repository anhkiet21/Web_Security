package com.proj.webprojrct.common.controller;

import com.proj.webprojrct.category.service.CategoryService;
import com.proj.webprojrct.product.service.ProductService;
import com.proj.webprojrct.common.config.security.CustomUserDetails;
import com.proj.webprojrct.user.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @Autowired
    private ProductService productService;

    @Autowired
    private CategoryService categoryService;

    @GetMapping("/")
    public String home(Model model) {
        try {
            // Lấy thông tin user nếu đã đăng nhập (để hiển thị ở header)
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth != null && auth.isAuthenticated() && auth.getPrincipal() instanceof CustomUserDetails) {
                CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
                User user = userDetails.getUser();
                model.addAttribute("currentUser", user);
            }

            // Lấy tất cả sản phẩm
            model.addAttribute("products", productService.getAll());

            // Lấy tất cả categories (nếu cần cho phần khác)
            model.addAttribute("categories", categoryService.getAll());

            // Lấy danh sách các thương hiệu (dùng cho phần Sản phẩm mới)
            model.addAttribute("brands", productService.getAllBrands());

        } catch (Exception e) {
            model.addAttribute("error", "Không thể tải dữ liệu: " + e.getMessage());
        }

        return "home";
    }

    @GetMapping("/about")
    public String about() {
        return "about";
    }

    @GetMapping("/faq")
    public String faq() {
        return "faq";
    }

    @GetMapping("/warranty")
    public String warranty() {
        return "warranty";
    }

    @GetMapping("/return")
    public String returnPolicy() {
        return "return";
    }

    @GetMapping("/payment")
    public String paymentGuide() {
        return "payment";
    }

    @GetMapping("/shipping")
    public String shipping() {
        return "shipping";
    }

    @GetMapping("/contact")
    public String contact() {
        return "contact";
    }
}
