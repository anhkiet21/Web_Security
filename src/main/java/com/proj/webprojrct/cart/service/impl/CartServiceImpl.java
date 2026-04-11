package com.proj.webprojrct.cart.service.impl;

import com.proj.webprojrct.cart.dto.request.CartRequest;
import com.proj.webprojrct.cart.dto.response.CartResponse;
import com.proj.webprojrct.cart.dto.response.CartItemResponse;
import com.proj.webprojrct.cart.entity.Cart;
import com.proj.webprojrct.cart.entity.CartItem;
import com.proj.webprojrct.cart.repository.CartRepository;
import com.proj.webprojrct.cart.repository.CartItemRepository;
import com.proj.webprojrct.cart.service.CartService;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.repository.UserRepository;
import com.proj.webprojrct.product.entity.Product;
import com.proj.webprojrct.product.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class CartServiceImpl implements CartService {

    @Autowired
    private CartRepository cartRepository;

    @Autowired
    private CartItemRepository cartItemRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ProductRepository productRepository;

    @Override
    public CartResponse getCartByUserId(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Cart cart = cartRepository.findByUser(user)
                .orElseGet(() -> {
                    Cart newCart = new Cart();
                    newCart.setUser(user);
                    newCart.setCreatedAt(LocalDateTime.now());
                    return cartRepository.save(newCart);
                });
        List<CartItem> items = cartItemRepository.findByCart(cart);
        List<CartItemResponse> itemResponses = items.stream().map(item -> {
            CartItemResponse resp = new CartItemResponse();
            resp.setCartItemId(item.getId());  
            resp.setCartId(item.getCart().getId());
            resp.setProductId(item.getProductId());
            resp.setQuantity(item.getQuantity());
            
            // Lấy thông tin sản phẩm
            Product product = productRepository.findById(item.getProductId()).orElse(null);
            if (product != null) {
                resp.setProductName(product.getName());
                resp.setProductPrice(product.getPrice().doubleValue());
                resp.setProductImageUrl(product.getImageUrl());
                resp.setProductStock(product.getStock()); // Thêm stock
                resp.setProductOnDeal(product.getOnDeal()); // Thêm onDeal
                resp.setProductDealPercentage(product.getDealPercentage()); // Thêm dealPercentage
                resp.setProductIsActive(product.getIsActive()); // Thêm trạng thái hoạt động
            }
            
            return resp;
        }).collect(Collectors.toList());

        CartResponse response = new CartResponse();
        response.setCartId(cart.getId()); 
        response.setUserId(cart.getUser().getId());
        response.setCreatedAt(cart.getCreatedAt());  
        response.setItems(itemResponses);
        return response;
    }

    @Override
    public void addItemToCart(Long userId, CartRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Cart cart = cartRepository.findByUser(user)
                .orElseGet(() -> {
                    Cart newCart = new Cart();
                    newCart.setUser(user);
                    newCart.setCreatedAt(LocalDateTime.now());
                    return cartRepository.save(newCart);
                });
        List<CartItem> items = cartItemRepository.findByCart(cart);
        Optional<CartItem> existing = items.stream()
                .filter(i -> i.getProductId().equals(request.getProductId()))
                .findFirst();
        if (existing.isPresent()) {
            CartItem item = existing.get();
            item.setQuantity(item.getQuantity() + request.getQuantity());
            cartItemRepository.save(item);
        } else {
            CartItem item = new CartItem();
            item.setCart(cart);
            item.setProductId(request.getProductId());
            item.setQuantity(request.getQuantity());
            cartItemRepository.save(item);
        }
    }

    @Override
    public void updateItemQuantity(Long userId, Long cartItemId, int quantity) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Cart cart = cartRepository.findByUser(user)
                .orElseThrow(() -> new RuntimeException("Cart not found"));
        CartItem cartItem = cartItemRepository.findById(cartItemId)
                .orElseThrow(() -> new RuntimeException("Cart item not found"));
        
        if (!cartItem.getCart().getId().equals(cart.getId())) {
            throw new RuntimeException("Cart item does not belong to this user");
        }
        
        if (quantity <= 0) {
            cartItemRepository.deleteById(cartItemId);
        } else {
            cartItem.setQuantity(quantity);
            cartItemRepository.save(cartItem);
        }
    }

    @Override
    @Transactional
    public void removeItemFromCart(Long userId, Long productId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Cart cart = cartRepository.findByUser(user)
                .orElseThrow(() -> new RuntimeException("Cart not found"));
        List<CartItem> items = cartItemRepository.findByCart(cart);
        items.stream()
                .filter(i -> i.getProductId().equals(productId))
                .findFirst()
                .ifPresent(item -> cartItemRepository.deleteById(item.getId()));
    }

    @Override
    @Transactional
    public void clearCart(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Cart cart = cartRepository.findByUser(user)
                .orElseThrow(() -> new RuntimeException("Cart not found"));
        cartItemRepository.deleteByCart(cart);
    }
}