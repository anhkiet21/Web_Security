package com.proj.webprojrct.reviewandrating.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import com.proj.webprojrct.common.config.security.CustomUserDetails;
import com.proj.webprojrct.reviewandrating.dto.request.ReviewRequest;
import com.proj.webprojrct.reviewandrating.dto.response.ReviewResponse;
import com.proj.webprojrct.reviewandrating.service.ReviewService;

import jakarta.validation.Valid;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/reviews")
public class ReviewRestController {

    @Autowired
    private ReviewService reviewService;

    // API lấy danh sách reviews của một sản phẩm
    @GetMapping("/product/{productId}")
    public ResponseEntity<Map<String, Object>> getProductReviews(
            @PathVariable Long productId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {

        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").ascending());
        Page<ReviewResponse> reviewsPage = reviewService.handleGetReviewsByProduct(productId, pageable);

        Map<String, Object> response = new HashMap<>();
        response.put("reviews", reviewsPage.getContent());
        response.put("currentPage", reviewsPage.getNumber());
        response.put("totalPages", reviewsPage.getTotalPages());
        response.put("totalReviews", reviewsPage.getTotalElements());
        response.put("hasNext", reviewsPage.hasNext());
        response.put("hasPrevious", reviewsPage.hasPrevious());

        return ResponseEntity.ok(response);
    }

    // API lấy thống kê rating của sản phẩm
    @GetMapping("/product/{productId}/stats")
    public ResponseEntity<Map<String, Object>> getProductRatingStats(@PathVariable Long productId) {
        Map<String, Object> stats = reviewService.getRatingStatistics(productId);
        return ResponseEntity.ok(stats);
    }

    // API tạo review mới
    @PostMapping("/product/{productId}")
    public ResponseEntity<?> createReview(
            @PathVariable Long productId,
            @Valid @RequestBody ReviewRequest reviewRequest) {

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("error", "Bạn cần đăng nhập để đánh giá sản phẩm"));
        }

        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long currentUserId = userDetails.getUser().getId();

        reviewRequest.setProductId(productId);
        ReviewResponse response = reviewService.handleCreateReview(reviewRequest, currentUserId);

        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }
}
