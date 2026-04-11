package com.proj.webprojrct.favorite.controller;

import com.proj.webprojrct.common.config.security.CustomUserDetails;
import com.proj.webprojrct.favorite.service.FavoriteService;
import com.proj.webprojrct.user.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class FavoritePageController {

    @Autowired
    private FavoriteService favoriteService;

    @GetMapping("/wishlist")
    public String wishlistPage(Model model) {
        try {
            // Lấy thông tin user nếu đã đăng nhập
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth != null && auth.isAuthenticated() && auth.getPrincipal() instanceof CustomUserDetails) {
                CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
                User user = userDetails.getUser();
                model.addAttribute("currentUser", user);
            } else {
                // Chưa đăng nhập, chuyển về trang login
                return "redirect:/login";
            }
        } catch (Exception e) {
            model.addAttribute("error", "Không thể tải dữ liệu: " + e.getMessage());
        }

        return "user/wishlist";
    }
}
