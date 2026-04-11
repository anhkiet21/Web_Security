package com.proj.webprojrct.cart.repository;

import com.proj.webprojrct.cart.entity.CartItem;
import com.proj.webprojrct.cart.entity.Cart;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

public interface CartItemRepository extends JpaRepository<CartItem, Long> {
    List<CartItem> findByCart(Cart cart);
    
    @Modifying
    @Transactional
    void deleteByCart(Cart cart);
}