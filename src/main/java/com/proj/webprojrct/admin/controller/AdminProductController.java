package com.proj.webprojrct.admin.controller;

import com.proj.webprojrct.product.dto.response.ProductResponse;
import com.proj.webprojrct.product.entity.Product;
import com.proj.webprojrct.product.repository.ProductRepository;
import com.proj.webprojrct.product.service.ProductService;
import com.proj.webprojrct.storage.service.ProductStorageService;
import com.proj.webprojrct.user.entity.UserRole;
import com.proj.webprojrct.reviewandrating.repository.ReviewRepository;
import com.proj.webprojrct.cart.repository.CartItemRepository;
import com.proj.webprojrct.common.config.security.CustomUserDetails;
import com.proj.webprojrct.favorite.repository.FavoriteRepository;

import lombok.RequiredArgsConstructor;

import org.springframework.data.domain.Page;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.math.BigDecimal;

import org.springframework.http.HttpStatus;

import com.proj.webprojrct.user.entity.User;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/products")
public class AdminProductController {

    private final ProductRepository productRepository;

    private final ProductStorageService productStorageService;
    private final ProductService productService;

    //admin
    @GetMapping
    public String products(
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "size", defaultValue = "10") int size,
            @RequestParam(value = "brand", required = false) String brand,
            @RequestParam(value = "name", required = false) String name,
            @RequestParam(value = "minPrice", required = false) BigDecimal minPrice,
            @RequestParam(value = "maxPrice", required = false) BigDecimal maxPrice,
            @RequestParam(value = "sort", defaultValue = "id,asc") String sort,
            Model model) {

        // Use service search method for pagination
        Page<ProductResponse> productPage = productService.search(brand, name, minPrice, maxPrice, page, size, sort);

        model.addAttribute("products", productPage);

        // Add filter parameters to model
        if (brand != null) {
            model.addAttribute("filterBrand", brand);
        }
        if (name != null) {
            model.addAttribute("filterName", name);
        }
        if (minPrice != null) {
            model.addAttribute("filterMinPrice", minPrice);
        }
        if (maxPrice != null) {
            model.addAttribute("filterMaxPrice", maxPrice);
        }
        model.addAttribute("filterSort", sort);

        return "admin/product_list_new";
    }

    // Trang form thêm mới
    @GetMapping("/new")
    public String form() {
        return "admin/product_form";
    }

    // Xử lý tạo sản phẩm mới
    @PostMapping("/create")
    public String createProduct(
            @RequestParam String name,
            @RequestParam String brand,
            @RequestParam BigDecimal price,
            @RequestParam Integer stock,
            // technical specs
            @RequestParam(required = false) String screenSize,
            @RequestParam(required = false) String displayTech,
            @RequestParam(required = false) String rearCamera,
            @RequestParam(required = false) String frontCamera,
            @RequestParam(required = false) String chipset,
            @RequestParam(required = false) String nfcSupport,
            @RequestParam(required = false) String ram,
            @RequestParam(required = false) String storage,
            @RequestParam(required = false) String battery,
            @RequestParam(required = false) String simType,
            @RequestParam(required = false) String os,
            @RequestParam(required = false) String resolution,
            @RequestParam(required = false) String displayFeatures,
            @RequestParam(required = false) String cpuSpecs,
            @RequestParam(value = "image", required = false) MultipartFile image
    ) throws IOException {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Access denied: Only ADMIN users can access category management.");
        }

        // Tạo sản phẩm mới
        Product p = Product.builder()
                .name(name)
                .brand(brand)
                .price(price)
                .stock(stock)
                .screenSize(screenSize)
                .displayTech(displayTech)
                .rearCamera(rearCamera)
                .frontCamera(frontCamera)
                .chipset(chipset)
                .nfcSupport(nfcSupport)
                .ram(ram)
                .storage(storage)
                .battery(battery)
                .simType(simType)
                .os(os)
                .resolution(resolution)
                .displayFeatures(displayFeatures)
                .cpuSpecs(cpuSpecs)
                .build();

        // Upload ảnh nếu có
        if (image != null && !image.isEmpty()) {
            String fileName = productStorageService.save(image.getOriginalFilename(), image.getInputStream());
            p.setImageUrl("/uploads/products/" + fileName);
        }

        productRepository.save(p);
        return "redirect:/admin/product_list_new";
    }

    // Xử lý xóa sản phẩm
    @ResponseBody
    @DeleteMapping("/{id}")
    public void deleteProduct(@PathVariable Long id) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Access denied: Only ADMIN users can access category management.");
        }

        productRepository.deleteById(id);
    }

    @ResponseBody
    @PostMapping("/{id}/delete")
    public void deleteProductPost(@PathVariable Long id) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Access denied: Only ADMIN users can access category management.");
        }

        productRepository.deleteById(id);
    }

    //admin
    @GetMapping("/edit")
    public String edit() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Access denied: Only ADMIN users can access category management.");
        }

        return "admin/product_edit";
    }

    //admin
    @GetMapping("/edit/{id}")
    public String editById(@PathVariable Long id, Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Access denied: Only ADMIN users can access category management.");
        }

        ProductResponse p = productService.getById(id);
        model.addAttribute("product", p);
        return "admin/product_edit";
    }

    /////////////////////////////////////// Deal admin/////////////////////////////////////////////////////////////////////////////////////
    @ResponseBody
    @PostMapping("/{id}/deal-toggle")
    public ProductResponse toggleDeal(@PathVariable Long id, @RequestBody java.util.Map<String, Object> body) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Access denied: Only ADMIN users can access category management.");
        }

        Boolean onDeal = false;
        Integer dealPercentage = null;

        if (body != null && body.containsKey("onDeal")) {
            Object v = body.get("onDeal");
            onDeal = Boolean.valueOf(String.valueOf(v));
        }
        if (body != null && body.containsKey("dealPercentage")) {
            Object v = body.get("dealPercentage");
            try {
                dealPercentage = Integer.valueOf(String.valueOf(v));
            } catch (NumberFormatException e) {
                dealPercentage = 0;
            }
        }

        return productService.setDealStatus(id, onDeal, dealPercentage);
    }

    // Toggle isActive status
    @Transactional
    @PostMapping("/{id}/active-toggle")
    @ResponseBody
    public Product toggleActiveStatus(@PathVariable Long id) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Access denied: Only ADMIN users can access category management.");
        }

        Product product = productRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Sản phẩm không tồn tại"));

        // Handle null case - default to true if null
        Boolean currentStatus = product.getIsActive();
        if (currentStatus == null) {
            currentStatus = true; // Default value
        }

        product.setIsActive(!currentStatus);
        return productRepository.save(product);
    }

}
