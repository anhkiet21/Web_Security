package com.proj.webprojrct.category.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;

import com.proj.webprojrct.common.config.security.CustomUserDetails;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.entity.UserRole;
import org.springframework.security.core.annotation.AuthenticationPrincipal;

@Controller
public class CategoryPageController {

    @GetMapping("/category_list")
    public String list() {
        return "category_list";
    }

    @GetMapping("/category_detail")
    public String detail(@AuthenticationPrincipal CustomUserDetails userDetails, Model model) {
        User user = userDetails.getUser();
        if (user.getRole() != UserRole.ADMIN) {
            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN, "Access denied");
        }
        return "admin/category_detail";
    }

    // Note: All /admin/categories/* routes have been moved to
    // AdminCategoryController
    // to avoid routing conflicts and maintain proper separation of concerns
}
