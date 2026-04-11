package com.proj.webprojrct.reviewandrating.dto.request;

import lombok.*;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;


@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class ReviewRequest {

    private Long productId;

    private Long parentReviewId;

    //cho phép rating null để các reply không cần rating nữa
    //xử lý rating đầu tiên không được để trống ở phần front-end
    @Min(1)
    @Max(5)
    private Integer rating;

    @NotBlank
    @Size(max = 2000)
    private String comment;
    // không trả về userId vì đã dùng auth để xác thực user rồi không cần trả về nữa

}
