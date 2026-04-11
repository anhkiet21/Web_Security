package com.proj.webprojrct.favorite.controller;

import com.proj.webprojrct.common.ResponseMessage;
import com.proj.webprojrct.common.config.security.CustomUserDetails;
import com.proj.webprojrct.favorite.dto.request.FavoriteRequest;
import com.proj.webprojrct.favorite.dto.response.FavoriteResponse;
import com.proj.webprojrct.favorite.service.FavoriteService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

@RestController
@RequestMapping("/api/favorite")
public class FavoriteController {

    @Autowired
    private FavoriteService favoriteService;

    // Lấy danh sách yêu thích của user
    @GetMapping
    public ResponseEntity<?> getFavorites() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ResponseMessage("Vui lòng đăng nhập!"));
        }

        List<FavoriteResponse> favorites = favoriteService.getFavoritesByUserId(userDetails.getUser().getId());
        return ResponseEntity.ok(favorites);
    }

    // Thêm sản phẩm vào yêu thích
    @PostMapping("/add")
    public ResponseEntity<ResponseMessage> addToFavorite(
            @RequestBody FavoriteRequest request) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();

        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ResponseMessage("Vui lòng đăng nhập!"));
        }

        try {
            favoriteService.addToFavorite(userDetails.getUser().getId(), request.getProductId());
            return ResponseEntity.ok(new ResponseMessage("Đã thêm vào danh sách yêu thích!"));
        } catch (RuntimeException e) {
            if (e.getMessage().contains("already in favorites")) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(new ResponseMessage("Sản phẩm đã có trong danh sách yêu thích!"));
            }
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new ResponseMessage(e.getMessage()));
        }
    }

    // Xóa sản phẩm khỏi yêu thích
    @DeleteMapping("/remove/{productId}")
    public ResponseEntity<ResponseMessage> removeFromFavorite(
            @PathVariable Long productId) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();

        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ResponseMessage("Vui lòng đăng nhập!"));
        }

        try {
            favoriteService.removeFromFavorite(userDetails.getUser().getId(), productId);
            return ResponseEntity.ok(new ResponseMessage("Đã xóa khỏi danh sách yêu thích!"));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new ResponseMessage(e.getMessage()));
        }
    }

    // Kiểm tra sản phẩm có trong yêu thích không
    @GetMapping("/check/{productId}")
    public ResponseEntity<?> checkFavorite(
            @PathVariable Long productId) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ResponseMessage("Vui lòng đăng nhập!"));
        }

        boolean isFavorite = favoriteService.isFavorite(userDetails.getUser().getId(), productId);
        Map<String, Boolean> response = new HashMap<>();
        response.put("isFavorite", isFavorite);
        return ResponseEntity.ok(response);
    }

    // Xóa tất cả yêu thích
    @DeleteMapping("/clear")
    public ResponseEntity<ResponseMessage> clearFavorites() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ResponseMessage("Vui lòng đăng nhập!"));
        }

        favoriteService.clearFavorites(userDetails.getUser().getId());
        return ResponseEntity.ok(new ResponseMessage("Đã xóa tất cả yêu thích!"));
    }
}
