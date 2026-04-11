package com.proj.webprojrct.favorite.service.impl;

import com.proj.webprojrct.favorite.dto.response.FavoriteResponse;
import com.proj.webprojrct.favorite.entity.Favorite;
import com.proj.webprojrct.favorite.repository.FavoriteRepository;
import com.proj.webprojrct.favorite.service.FavoriteService;
import com.proj.webprojrct.product.entity.Product;
import com.proj.webprojrct.product.repository.ProductRepository;
import com.proj.webprojrct.user.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class FavoriteServiceImpl implements FavoriteService {

    @Autowired
    private FavoriteRepository favoriteRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private UserRepository userRepository;

    @Override
    @Transactional
    public void addToFavorite(Long userId, Long productId) {
        // Kiểm tra user tồn tại
        userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        // Kiểm tra product tồn tại
        productRepository.findById(productId)
                .orElseThrow(() -> new RuntimeException("Product not found"));

        // Kiểm tra đã yêu thích chưa
        if (favoriteRepository.existsByUserIdAndProductId(userId, productId)) {
            throw new RuntimeException("Product already in favorites");
        }

        // Thêm vào yêu thích
        Favorite favorite = new Favorite();
        favorite.setUserId(userId);
        favorite.setProductId(productId);
        favorite.setCreatedAt(LocalDateTime.now());
        favoriteRepository.save(favorite);
    }

    @Override
    @Transactional
    public void removeFromFavorite(Long userId, Long productId) {
        // Kiểm tra favorite tồn tại
        if (!favoriteRepository.existsByUserIdAndProductId(userId, productId)) {
            throw new RuntimeException("Favorite not found");
        }

        favoriteRepository.deleteByUserIdAndProductId(userId, productId);
    }

    @Override
    public List<FavoriteResponse> getFavoritesByUserId(Long userId) {
        List<Favorite> favorites = favoriteRepository.findByUserId(userId);

        return favorites.stream().map(favorite -> {
            FavoriteResponse response = new FavoriteResponse();
            response.setId(favorite.getId());
            response.setUserId(favorite.getUserId());
            response.setProductId(favorite.getProductId());
            response.setCreatedAt(favorite.getCreatedAt());

            // Lấy thông tin sản phẩm
            Product product = productRepository.findById(favorite.getProductId()).orElse(null);
            if (product != null) {
                response.setProductName(product.getName());
                response.setProductPrice(product.getPrice().doubleValue());
                response.setProductImageUrl(product.getImageUrl());
                response.setProductStock(product.getStock());
                response.setProductBrand(product.getBrand());
                response.setDealPercentage(product.getDealPercentage());
                response.setProductIsActive(product.getIsActive());
            }

            return response;
        }).collect(Collectors.toList());
    }

    @Override
    public boolean isFavorite(Long userId, Long productId) {
        return favoriteRepository.existsByUserIdAndProductId(userId, productId);
    }

    @Override
    @Transactional
    public void clearFavorites(Long userId) {
        favoriteRepository.deleteByUserId(userId);
    }
}
