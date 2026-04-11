package com.proj.webprojrct.reviewandrating.dto.response;

import lombok.*;

import java.time.LocalDateTime;
import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class ReviewResponse {

    private Long reviewId;
    private Long userId;
    private String userName;
    private Long productId;
    private Long parentReviewId;
    // Nếu trả về một list review response như này thì chỉ tốn 1 lần gọi request từ front-end
    // nhưng kích thước dữ liệu quá lớn được truyền đi trong một yêu cầu (request) hoặc phản hồi (response) 
    private List<ReviewResponse> childReviews; 
    private Integer rating;
    private String comment;
    private LocalDateTime createdAt;

}