package com.proj.webprojrct.product.service;

import com.proj.webprojrct.product.dto.request.*;
import com.proj.webprojrct.product.dto.response.*;
import org.springframework.data.domain.Page;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

public interface ProductService {
    ProductResponse create(ProductCreateRequest req);
    ProductResponse update(Long id, ProductUpdateRequest req);
    void delete(Long id);
    ProductResponse getById(Long id);
    List<ProductResponse> getAll();
    List<ProductResponse> getByCategoryId(Long categoryId);
    Page<ProductResponse> search(String brand, String name, BigDecimal minPrice, BigDecimal maxPrice, int page, int size, String sort);
    String uploadImage(Long id, MultipartFile file) throws IOException;
    void deleteImage(Long imageId) throws IOException;
    List<String> getAllBrands();
    List<String> suggestNames(String q, int limit);
    ProductResponse setDealStatus(Long id, Boolean onDeal, Integer dealPercentage);
}
