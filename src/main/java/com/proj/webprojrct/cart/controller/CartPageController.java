package com.proj.webprojrct.cart.controller;

import com.proj.webprojrct.cart.dto.response.CartResponse;
import com.proj.webprojrct.cart.service.CartService;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.repository.UserRepository;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.server.ResponseStatusException;
import com.proj.webprojrct.user.repository.UserRepository;
import com.proj.webprojrct.user.entity.User;

import java.security.Principal;

import org.springframework.http.HttpStatus;

@Controller
public class CartPageController {

    @Autowired
    private CartService cartService;

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/cart")
    public String cartPage(Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Vui lòng đăng nhập!");
        }
        User user = userRepository.findByPhone(authentication.getName())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Vui lòng đăng nhập!"));
        Long userId = (user != null) ? user.getId() : null;

        if (userId == null) {
            // Chưa đăng nhập, chuyển về trang đăng nhập
            return "redirect:/login";
        }

        CartResponse cart = cartService.getCartByUserId(userId);
        model.addAttribute("cart", cart);
        return "user/cart";
    }

    @GetMapping("/cart.jsp")
    public String cartTestPage() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return "user/cart";
    }
}
