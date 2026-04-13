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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@RestController
@RequestMapping("/api/cart")
public class CartController {

    private static final Logger log = LoggerFactory.getLogger(CartController.class);

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
        try{
            CartResponse cart = cartService.getCartByUserId(userDetails.getUser().getId());
            return ResponseEntity.ok(cart);
        }catch(Exception e){
            log.error("Lỗi khi lấy giỏ hàng cho user", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ResponseMessage("Lỗi hệ thống khi lấy giỏ hàng. Vui lòng thử lại sau."));
        }
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
          try{
            cartService.addItemToCart(userDetails.getUser().getId(), request);
            return ResponseEntity.ok(new ResponseMessage("Thêm hàng vào giỏ thành công!"));
        }catch(Exception e){
            log.error("Lỗi khi thêm hàng vào giỏ", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ResponseMessage("Lỗi hệ thống khi thêm hàng vào giỏ. Vui lòng thử lại sau."));
        }
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
        try{
            cartService.updateItemQuantity(userDetails.getUser().getId(), cartItemId, request.getQuantity());
            return ResponseEntity.ok(new ResponseMessage("Đã cập nhật số lượng sản phẩm!"));
        }catch(Exception e){
            log.error("Lỗi khi cập nhật số lượng sản phẩm", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ResponseMessage("Lỗi hệ thống khi cập nhật số lượng. Vui lòng thử lại sau."));
        }
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
        try{
            cartService.removeItemFromCart(userDetails.getUser().getId(), productId);
            return ResponseEntity.ok(new ResponseMessage("Đã xóa sản phẩm khỏi giỏ hàng!"));
        }catch(Exception e){
            log.error("Lỗi khi xóa sản phẩm khỏi giỏ hàng", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ResponseMessage("Lỗi hệ thống khi xóa sản phẩm. Vui lòng thử lại sau."));
        }
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
        try{
            cartService.clearCart(userDetails.getUser().getId());
            return ResponseEntity.ok(new ResponseMessage("Đã xóa toàn bộ giỏ hàng!"));
        }catch(Exception e){
            log.error("Lỗi khi xóa toàn bộ giỏ hàng", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ResponseMessage("Lỗi hệ thống khi xóa giỏ hàng. Vui lòng thử lại sau."));
        }
    }
}
