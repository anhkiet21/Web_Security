package com.proj.webprojrct.reviewandrating.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import jakarta.validation.Valid;

import org.springframework.validation.BindingResult;

import com.proj.webprojrct.common.config.security.CustomUserDetails;
import com.proj.webprojrct.reviewandrating.dto.request.ReviewRequest;
import com.proj.webprojrct.reviewandrating.service.ReviewService;

@Controller
//@RequestMapping("/user")
public class ReviewController {

    @Autowired
    private ReviewService reviewService;

    // hiện phần review của product dựa trên product id
    @GetMapping("/products/{productId}/reviews")
    public String showProductReviews(@PathVariable Long productId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        model.addAttribute("productId", productId);
        // request top-level reviews sorted by createdAt ascending to preserve chronological order
        model.addAttribute("reviewsPage", reviewService.handleGetReviewsByProduct(productId, org.springframework.data.domain.PageRequest.of(page, size, org.springframework.data.domain.Sort.by("createdAt").ascending())));
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        return "reviews/product-reviews";
    }

    // Hiện form để rating và bình luận 
    @GetMapping("/products/{productId}/reviews/new")
    public String showCreateReviewForm(@PathVariable Long productId, @RequestParam(required = false) Long parentReviewId, Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated() || authentication instanceof AnonymousAuthenticationToken) {
            model.addAttribute("error", "Bạn chưa đăng nhập.");
            return "redirect:/login";
        }
        ReviewRequest req = new ReviewRequest();
        req.setProductId(productId);
        req.setParentReviewId(parentReviewId);
        model.addAttribute("reviewRequest", req);
        return "reviews/new-review";
    }

    // Xử lý submit rating và bình luận
    @PostMapping("/products/{productId}/reviews")
    public String handleCreateReview(@PathVariable Long productId,
            @ModelAttribute ReviewRequest reviewRequest,
            BindingResult bindingResult,
            Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated() || authentication instanceof AnonymousAuthenticationToken) {
            model.addAttribute("error", "Bạn chưa đăng nhập.");
            return "redirect:/login";
        }

        // lấy product id từ url chèn vào review request
        reviewRequest.setProductId(productId);

        if (bindingResult.hasErrors()) {
            model.addAttribute("reviewRequest", reviewRequest);
            model.addAttribute("errors", bindingResult.getAllErrors());
            return "reviews/new-review";
        }

        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long currentUserId = userDetails.getUser().getId();

        reviewService.handleCreateReview(reviewRequest, currentUserId);
        //return "redirect:/user/products/" + productId + "/reviews";
        return "redirect:/products/" + productId + "/reviews";
    }

}
