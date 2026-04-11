package com.proj.webprojrct.reviewandrating.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.proj.webprojrct.user.repository.UserRepository;
import com.proj.webprojrct.product.repository.ProductRepository;
import com.proj.webprojrct.reviewandrating.dto.request.ReviewRequest;
import com.proj.webprojrct.reviewandrating.dto.response.ReviewResponse;
import com.proj.webprojrct.reviewandrating.entity.Review;
import com.proj.webprojrct.reviewandrating.mapper.ReviewMapper;
import com.proj.webprojrct.reviewandrating.repository.ReviewRepository;

import java.util.Optional;

@Service
public class ReviewService {

    @Autowired
    private ReviewRepository reviewRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private ReviewMapper reviewMapper;

    @Transactional
    public ReviewResponse handleCreateReview(ReviewRequest dto, Long currentUserId) {
        Review review = reviewMapper.toEntity(dto); //chuyển dto sang entity
        //getReferenceById là hàm mặc định của JPA
        review.setUser(userRepository.getReferenceById(currentUserId));
        review.setProduct(productRepository.getReferenceById(dto.getProductId()));
        if (dto.getParentReviewId() != null) {
            // If replying to a reply, attach this new reply to the top-level parent
            // so all replies to the same top-level review are siblings (same level).
            Review intendedParent = reviewRepository.findById(dto.getParentReviewId()).orElse(null);
            if (intendedParent != null) {
                Review rootParent = intendedParent.getParentReview() != null ? intendedParent.getParentReview() : intendedParent;
                review.setParentReview(rootParent);
            }
        }
        Review saved = reviewRepository.save(review);
        return reviewMapper.toDto(saved);
    }

    /*
    Lấy từng đối tượng review trong trang, 
    sau đó gọi phương thức toDto của reviewMapper 
    và truyền đối tượng review đó vào để tạo thành dto response
     */
    public Page<ReviewResponse> handleGetReviewsByProduct(Long productId, Pageable pageable) {
        // fetch only top-level reviews (parentReview null) so child replies are shown nested only
        Page<Review> page = reviewRepository.findByProduct_IdAndParentReviewIsNull(productId, pageable);
        return page.map(reviewMapper::toDto);
    }

    public Optional<ReviewResponse> handleGetReviewThread(Long reviewId) {
        Optional<Review> r = reviewRepository.findById(reviewId);
        return r.map(reviewMapper::toDto);
    }

    /**
     * Get rating statistics for a product
     * @param productId the product ID
     * @return Map containing average rating, total reviews, and rating distribution
     */
    public java.util.Map<String, Object> getRatingStatistics(Long productId) {
        java.util.Map<String, Object> stats = new java.util.HashMap<>();
        
        // Get average rating
        Double avgRating = reviewRepository.getAverageRatingByProductId(productId);
        stats.put("averageRating", avgRating != null ? Math.round(avgRating * 10.0) / 10.0 : 0.0);
        
        // Get total reviews with rating
        Long totalReviews = reviewRepository.countReviewsWithRatingByProductId(productId);
        stats.put("totalReviews", totalReviews != null ? totalReviews : 0L);
        
        // Get rating distribution (count for each star rating 1-5)
        int[] ratingDistribution = new int[5];
        for (int i = 1; i <= 5; i++) {
            Long count = reviewRepository.countByProductIdAndRating(productId, i);
            ratingDistribution[i - 1] = count != null ? count.intValue() : 0;
        }
        stats.put("ratingDistribution", ratingDistribution);
        
        return stats;
    }

    /**
     * Delete a review (admin only - authorization checked in controller)
     * @param reviewId the review ID to delete
     */
    @Transactional
    public void deleteReview(Long reviewId) {
        Review review = reviewRepository.findById(reviewId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đánh giá với ID: " + reviewId));
        
        // Delete will cascade to child reviews due to CascadeType.ALL
        reviewRepository.delete(review);
    }
}
