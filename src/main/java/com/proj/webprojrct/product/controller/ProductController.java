package com.proj.webprojrct.product.controller;

import com.proj.webprojrct.common.config.security.CustomUserDetails;
import com.proj.webprojrct.product.dto.request.*;
import com.proj.webprojrct.product.dto.response.ProductResponse;
import com.proj.webprojrct.product.service.ProductService;
import jakarta.validation.Valid;

import org.springframework.data.domain.Page;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/////////////////////////////////Dành cho USER////////////////////////////////////////////
@RestController
@RequestMapping(value = "/api/products", produces = MediaType.APPLICATION_JSON_VALUE)
public class ProductController {

    private final ProductService service;

    public ProductController(ProductService service) {
        this.service = service;
    }

    @PostMapping(consumes = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.CREATED)
    public ProductResponse create(@Valid @RequestBody ProductCreateRequest req) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Vui lòng đăng nhập!");
        }

        return service.create(req);
    }

    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @ResponseStatus(HttpStatus.CREATED)
    public ProductResponse createMultipart(
            @Valid @RequestPart("data") ProductCreateRequest req,
            @RequestPart(value = "image", required = false) MultipartFile image
    ) {

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Vui lòng đăng nhập!");
        }
        try {
            ProductResponse res = service.create(req);
            if (image != null && !image.isEmpty()) {
                service.uploadImage(res.getId(), image);
                res = service.getById(res.getId());
            }
            return res;
        } catch (IOException e) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Lỗi tải ảnh: " + e.getMessage());
        }
    }

    /* Xem tổng */
    @GetMapping
    public List<ProductResponse> getAll(
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) Integer limit) {
        // Allow public access for product listing
        List<ProductResponse> products;

        if (categoryId != null) {
            products = service.getByCategoryId(categoryId);
        } else {
            products = service.getAll();
        }

        // Apply limit if specified
        if (limit != null && limit > 0 && products.size() > limit) {
            return products.subList(0, limit);
        }

        return products;
    }

    @GetMapping("/{id}")
    public ProductResponse getById(@PathVariable Long id) {
        // Allow public access for viewing product details
        return service.getById(id);
    }

    @GetMapping("/search")
    public Page<ProductResponse> search(@RequestParam(required = false) String brand,
            @RequestParam(required = false) String name,
            @RequestParam(required = false) BigDecimal minPrice,
            @RequestParam(required = false) BigDecimal maxPrice,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(defaultValue = "createdAt,desc") String sort) {
        // Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        // if (authentication == null || !authentication.isAuthenticated()
        //         || authentication instanceof AnonymousAuthenticationToken) {
        //     throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Vui lòng đăng nhập!");
        // }
        return service.search(brand, name, minPrice, maxPrice, page, size, sort);
    }

    @GetMapping("/brands")
    public List<String> getBrands() {
        // Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        // if (authentication == null || !authentication.isAuthenticated()
        //         || authentication instanceof AnonymousAuthenticationToken) {
        //     throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Vui lòng đăng nhập!");
        // }
        return service.getAllBrands();
    }

    @GetMapping("/suggest")
    public List<String> suggestNames(@RequestParam("q") String q, @RequestParam(value = "limit", defaultValue = "10") int limit) {
        // Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        // if (authentication == null || !authentication.isAuthenticated()
        //         || authentication instanceof AnonymousAuthenticationToken) {
        //     throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Vui lòng đăng nhập!");
        // }
        return service.suggestNames(q, limit);
    }

    @GetMapping("/search-suggestions")
    public List<ProductResponse> searchSuggestions(
            @RequestParam("q") String query,
            @RequestParam(value = "limit", defaultValue = "5") int limit) {
        // Public endpoint - no authentication required
        if (query == null || query.trim().isEmpty()) {
            return List.of();
        }

        String searchTerm = query.trim().toLowerCase();

        // Split search term into words for better matching
        String[] searchWords = searchTerm.split("\\s+");

        return service.getAll().stream()
                .filter(p -> {
                    if (p.getName() == null) {
                        return false;
                    }
                    String productName = p.getName().toLowerCase();

                    // Check if product name contains the full search term
                    if (productName.contains(searchTerm)) {
                        return true;
                    }

                    // Check if product name contains any of the search words
                    for (String word : searchWords) {
                        if (word.length() >= 2 && productName.contains(word)) {
                            return true;
                        }
                    }

                    // Fuzzy matching: check if search term is similar to product name
                    // Allow for typos or partial matches
                    return isFuzzyMatch(productName, searchTerm);
                })
                .sorted((p1, p2) -> {
                    // Sort by relevance
                    String name1 = p1.getName().toLowerCase();
                    String name2 = p2.getName().toLowerCase();

                    // Exact match gets highest priority
                    boolean exact1 = name1.contains(searchTerm);
                    boolean exact2 = name2.contains(searchTerm);
                    if (exact1 && !exact2) {
                        return -1;
                    }
                    if (!exact1 && exact2) {
                        return 1;
                    }

                    // Then by number of matching words
                    int matches1 = countMatchingWords(name1, searchWords);
                    int matches2 = countMatchingWords(name2, searchWords);
                    if (matches1 != matches2) {
                        return matches2 - matches1;
                    }

                    // Finally by name length (shorter names first)
                    return name1.length() - name2.length();
                })
                .limit(limit)
                .toList();
    }

    private boolean isFuzzyMatch(String productName, String searchTerm) {
        // Check if search term characters appear in order in product name
        if (searchTerm.length() < 3) {
            return false;
        }

        int searchIndex = 0;
        for (int i = 0; i < productName.length() && searchIndex < searchTerm.length(); i++) {
            if (productName.charAt(i) == searchTerm.charAt(searchIndex)) {
                searchIndex++;
            }
        }

        // If we matched at least 70% of search term characters
        return searchIndex >= (searchTerm.length() * 0.7);
    }

    private int countMatchingWords(String productName, String[] searchWords) {
        int count = 0;
        for (String word : searchWords) {
            if (word.length() >= 2 && productName.contains(word)) {
                count++;
            }
        }
        return count;
    }

    /* Cập nhật */
    @PutMapping(value = "/{id}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ProductResponse update(@PathVariable Long id,
            @Valid @RequestPart("data") ProductUpdateRequest req,
            @RequestPart(value = "image", required = false) MultipartFile image) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Vui lòng đăng nhập!");
        }
        try {
            ProductResponse res = service.update(id, req);
            if (image != null && !image.isEmpty()) {
                service.uploadImage(id, image);
                res = service.getById(id);
            }
            return res;
        } catch (IOException e) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Lỗi tải ảnh: " + e.getMessage());
        }
    }

    /* Xóa */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Vui lòng đăng nhập!");
        }
        service.delete(id);
        return ResponseEntity.noContent().build();
    }

    /**
     * deal
     */
    @PostMapping(value = "/{id}/deal-toggle", consumes = MediaType.APPLICATION_JSON_VALUE)
    public ProductResponse setDeal(@PathVariable Long id, @RequestBody Map<String, Object> body) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Vui lòng đăng nhập!");
        }

        boolean isAdmin = authentication.getAuthorities().stream()
                .anyMatch(auth -> auth.getAuthority().equals("ROLE_ADMIN"));

        if (!isAdmin) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Chỉ admin mới có quyền cập nhật deal!");
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
        return service.setDealStatus(id, onDeal, dealPercentage);
    }

    /* Upload ảnh riêng */
    @PostMapping("/{id}/image")
    public ResponseEntity<ProductResponse> uploadImage(@PathVariable Long id, @RequestParam("image") MultipartFile file) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Vui lòng đăng nhập!");
        }
        try {
            service.uploadImage(id, file);
            return ResponseEntity.ok(service.getById(id));
        } catch (IOException e) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Lỗi tải ảnh: " + e.getMessage());
        }
    }

    /**
     * Upload multiple images in one request. This appends images to the
     * product.
     */
    @PostMapping("/{id}/images")
    public ResponseEntity<ProductResponse> uploadImages(@PathVariable Long id, @RequestParam("images") MultipartFile[] files) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Vui lòng đăng nhập!");
        }
        try {
            if (files != null) {
                for (MultipartFile f : files) {
                    if (f != null && !f.isEmpty()) {
                        service.uploadImage(id, f);
                    }
                }
            }
            return ResponseEntity.ok(service.getById(id));
        } catch (IOException e) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Lỗi tải ảnh: " + e.getMessage());
        }
    }

    @DeleteMapping("/images/{id}")
    public ResponseEntity<Void> deleteImage(@PathVariable("id") Long id) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Vui lòng đăng nhập!");
        }
        try {
            service.deleteImage(id);
            return ResponseEntity.noContent().build();
        } catch (IOException e) {
            throw new org.springframework.web.server.ResponseStatusException(org.springframework.http.HttpStatus.INTERNAL_SERVER_ERROR, "Lỗi xóa ảnh: " + e.getMessage());
        }
    }
}
