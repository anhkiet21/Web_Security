package com.proj.webprojrct.cart.service;

import com.proj.webprojrct.cart.dto.request.CartRequest;
import com.proj.webprojrct.cart.dto.response.CartResponse;

public interface CartService {
    CartResponse getCartByUserId(Long userId);
    void addItemToCart(Long userId, CartRequest request);
    void updateItemQuantity(Long userId, Long cartItemId, int quantity);
    void removeItemFromCart(Long userId, Long productId);
    void clearCart(Long userId);
}