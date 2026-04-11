package com.proj.webprojrct.admin.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import com.proj.webprojrct.common.config.security.CustomUserDetails;
import com.proj.webprojrct.reviewandrating.service.ReviewService;
import com.proj.webprojrct.user.entity.UserRole;

import java.util.Map;

import org.springframework.security.core.Authentication;

import com.proj.webprojrct.user.entity.User;

@RestController
@RequestMapping("/admin/api/reviews")
public class AdminReviewController {

    @Autowired
    private ReviewService reviewService;

    /**
     * API xóa review (admin only) DELETE /admin/api/reviews/{reviewId}
     */
    @DeleteMapping("/{reviewId}")
    public ResponseEntity<?> deleteReview(@PathVariable Long reviewId) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Access denied: Only ADMIN users can access category management.");
        }

        try {
            reviewService.deleteReview(reviewId);
            return ResponseEntity.ok(Map.of("message", "Đã xóa đánh giá thành công"));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("error", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Không thể xóa đánh giá: " + e.getMessage()));
        }
    }
}
