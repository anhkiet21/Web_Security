package com.proj.webprojrct.reviewandrating.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.proj.webprojrct.reviewandrating.entity.Review;

import java.util.List;

public interface ReviewRepository extends JpaRepository<Review, Long> {
    // only fetch top-level reviews (parentReview is null) for product listing
    Page<Review> findByProduct_IdAndParentReviewIsNull(Long productId, Pageable pageable);
    
    // Get all reviews for a product (including child reviews) for rating calculation
    List<Review> findByProduct_IdAndRatingIsNotNull(Long productId);
    
    // Count reviews by product and rating
    @Query("SELECT COUNT(r) FROM Review r WHERE r.product.id = :productId AND r.rating = :rating AND r.rating IS NOT NULL")
    Long countByProductIdAndRating(@Param("productId") Long productId, @Param("rating") Integer rating);
    
    // Get average rating for a product
    @Query("SELECT AVG(r.rating) FROM Review r WHERE r.product.id = :productId AND r.rating IS NOT NULL")
    Double getAverageRatingByProductId(@Param("productId") Long productId);
    
    // Count total reviews with rating for a product
    @Query("SELECT COUNT(r) FROM Review r WHERE r.product.id = :productId AND r.rating IS NOT NULL")
    Long countReviewsWithRatingByProductId(@Param("productId") Long productId);
}
