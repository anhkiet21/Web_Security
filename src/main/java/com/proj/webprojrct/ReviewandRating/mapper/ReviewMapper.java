package com.proj.webprojrct.reviewandrating.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;

import com.proj.webprojrct.reviewandrating.dto.request.ReviewRequest;
import com.proj.webprojrct.reviewandrating.dto.response.ReviewResponse;
import com.proj.webprojrct.reviewandrating.entity.Review;

import java.util.List;



@Mapper(componentModel = "spring")
public interface ReviewMapper {

    //ignore để bỏ qua các trường dữ liệu mà không phải người dùng nhập
    //các dữ liệu này được lấy từ auth hoặc trả về product id để tìm product gán cho một review
    @Mapping(target = "reviewId", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "user", ignore = true)
    @Mapping(target = "product", ignore = true)
    @Mapping(target = "parentReview", ignore = true)
    @Mapping(target = "childReviews", ignore = true)
    public Review toEntity(ReviewRequest review);

    @Mapping(target = "userId", source = "user.id")
    @Mapping(target = "userName", source = "user.fullName")
    @Mapping(target = "productId", source = "product.id")
    @Mapping(target = "parentReviewId", source = "parentReview.reviewId")
    @Mapping(target = "childReviews", source = "childReviews", qualifiedByName = "mapChildReviews")
    public ReviewResponse toDto(Review review);

    //chuyển từ list thành list để đảm bảo yêu cầu cho review response và để giữ thứ tự reply
    //list đảm bảo thứ tự nhờ @OrderBy ở entity
    @Named("mapChildReviews")
    default List<ReviewResponse> mapChildReviews(List<Review> children) {
        if (children == null || children.isEmpty()) return null;
        // JPA đã sort bằng @OrderBy("createdAt ASC"), chỉ cần map
        return children.stream()
                .map(this::toDto)
                .toList();
    }


   
}