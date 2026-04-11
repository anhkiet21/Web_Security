package com.proj.webprojrct.cart.controller;

import com.proj.webprojrct.cart.dto.request.CartRequest;
import com.proj.webprojrct.cart.dto.response.CartResponse;
import com.proj.webprojrct.cart.service.CartService;
import com.proj.webprojrct.common.ResponseMessage;
import com.proj.webprojrct.common.config.security.CustomUserDetails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    // Lấy giỏ hàng của user đang login
    @GetMapping
    public ResponseEntity<?> getCart() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Vui lòng đăng nhập!");
        }
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();

        CartResponse cart = cartService.getCartByUserId(userDetails.getUser().getId());
        return ResponseEntity.ok(cart);
    }

    // Thêm sản phẩm vào giỏ hàng
    @PostMapping("/add")
    public ResponseEntity<ResponseMessage> addItem(@RequestBody CartRequest request) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Vui lòng đăng nhập!");
        }
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        cartService.addItemToCart(userDetails.getUser().getId(), request);
        return ResponseEntity.ok(new ResponseMessage("Thêm hàng vào giỏ thành công!"));
    }

    // Cập nhật số lượng sản phẩm trong giỏ hàng
    @PutMapping("/update/{cartItemId}")
    public ResponseEntity<ResponseMessage> updateItem(
            @PathVariable Long cartItemId,
            @RequestBody CartRequest request) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Vui lòng đăng nhập!");
        }
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        cartService.updateItemQuantity(userDetails.getUser().getId(), cartItemId, request.getQuantity());
        return ResponseEntity.ok(new ResponseMessage("Đã cập nhật số lượng sản phẩm!"));
    }

    // Xóa sản phẩm khỏi giỏ hàng
    @DeleteMapping("/remove/{productId}")
    public ResponseEntity<ResponseMessage> removeItem(@PathVariable Long productId) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Vui lòng đăng nhập!");
        }
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        cartService.removeItemFromCart(userDetails.getUser().getId(), productId);
        return ResponseEntity.ok(new ResponseMessage("Đã xóa sản phẩm khỏi giỏ hàng!"));
    }

    // Xóa toàn bộ giỏ hàng
    @DeleteMapping("/clear")
    public ResponseEntity<ResponseMessage> clearCart() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Vui lòng đăng nhập!");
        }
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        cartService.clearCart(userDetails.getUser().getId());
        return ResponseEntity.ok(new ResponseMessage("Đã xóa toàn bộ giỏ hàng!"));
    }
}
