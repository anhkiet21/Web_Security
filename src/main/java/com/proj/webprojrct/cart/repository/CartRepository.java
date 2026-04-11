package com.proj.webprojrct.cart.repository;

import com.proj.webprojrct.cart.entity.Cart;
import com.proj.webprojrct.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface CartRepository extends JpaRepository<Cart, Long> {
    Optional<Cart> findByUser(User user);
}