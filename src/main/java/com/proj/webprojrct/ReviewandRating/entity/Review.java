package com.proj.webprojrct.reviewandrating.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.LocalDateTime;
import java.util.List;
import java.util.ArrayList;

import com.proj.webprojrct.product.entity.Product;
import com.proj.webprojrct.user.entity.User;

@Entity
@Table(name = "reviews")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Review {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "review_id")
    private Long reviewId;

    @ManyToOne(fetch = FetchType.LAZY)
    // cột tên là user_id tham chiếu đến id của bảng user (do id bên user không có tên column nên tên mặc định là id)
    @JoinColumn(name = "user_id", referencedColumnName = "id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    // cột tên là user_id tham chiếu đến id của bảng user (do id bên user không có tên column nên tên mặc định là id)
    @JoinColumn(name = "product_id", referencedColumnName = "id", nullable = false)
    private Product product; //thêm product sau

    @Column
    private Integer rating;

    @Column(columnDefinition = "TEXT") // chỉ cho phép bình luận dạng text
    private String comment;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }


    // 1. Mối quan hệ với bình luận CHA (Parent Review)
    // @ManyToOne là mối quan hệ mặc định cần dùng cho một bình luận con
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_review_id") // Đây là cột khóa ngoại trong bảng review
    private Review parentReview;

    // 2. Mối quan hệ với các bình luận CON (Children Reviews)
    // Tham chiếu đến tập hợp các bình luận con
    @OneToMany(mappedBy = "parentReview", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("createdAt ASC") // Cũ nhất lên đầu (oldest first) - giống flow chat tự nhiên
    private List<Review> childReviews = new ArrayList<>(); // Sử dụng List để giữ thứ tự
}