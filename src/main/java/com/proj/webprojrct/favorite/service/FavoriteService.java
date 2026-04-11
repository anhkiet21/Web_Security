package com.proj.webprojrct.favorite.service;

import com.proj.webprojrct.favorite.dto.response.FavoriteResponse;

import java.util.List;

public interface FavoriteService {
    
    void addToFavorite(Long userId, Long productId);
    
    void removeFromFavorite(Long userId, Long productId);
    
    List<FavoriteResponse> getFavoritesByUserId(Long userId);
    
    boolean isFavorite(Long userId, Long productId);
    
    void clearFavorites(Long userId);
}
