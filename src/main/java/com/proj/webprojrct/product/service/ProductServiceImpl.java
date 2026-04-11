package com.proj.webprojrct.product.service;

import com.proj.webprojrct.category.entity.Category;
import com.proj.webprojrct.category.repository.CategoryRepository;
import com.proj.webprojrct.product.dto.request.*;
import com.proj.webprojrct.product.dto.response.ProductResponse;
import com.proj.webprojrct.product.entity.*;
import com.proj.webprojrct.product.mapper.ProductMapper;
import com.proj.webprojrct.product.repository.ProductRepository;
import org.springframework.data.domain.*;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Service
@Transactional
public class ProductServiceImpl implements ProductService {

    private final ProductRepository repo;
    private final ProductMapper mapper;
    private final CategoryRepository categoryRepo;
    private final com.proj.webprojrct.product.repository.ProductImageRepository imageRepo;

    public ProductServiceImpl(ProductRepository repo, ProductMapper mapper, CategoryRepository categoryRepo, com.proj.webprojrct.product.repository.ProductImageRepository imageRepo) {
        this.repo = repo;
        this.mapper = mapper;
        this.categoryRepo = categoryRepo;
        this.imageRepo = imageRepo;
    }

    @Override
    public ProductResponse create(ProductCreateRequest req) {
        Product p = mapper.toEntity(req);

        if (req.getCategoryId() != null) {
            Category c = categoryRepo.findById(req.getCategoryId())
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Danh mục không tồn tại"));
            p.setCategory(c);
        }

        if (req.getSpecs() != null) {
            List<ProductSpec> specs = new ArrayList<>();
            for (var s : req.getSpecs()) {
                specs.add(ProductSpec.builder().key(s.getKey()).value(s.getValue()).product(p).build());
            }
            p.setSpecifications(specs);
        }

        return mapper.toResponse(repo.save(p));
    }

    @Override
    public ProductResponse update(Long id, ProductUpdateRequest req) {
        Product p = repo.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy sản phẩm #" + id));

        mapper.updateEntityFromDto(req, p);

        if (req.getCategoryId() != null) {
            Category c = categoryRepo.findById(req.getCategoryId())
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Danh mục không tồn tại"));
            p.setCategory(c);
        }

        if (req.getSpecs() != null) {
            p.getSpecifications().clear();
            for (var s : req.getSpecs()) {
                p.getSpecifications().add(ProductSpec.builder().key(s.getKey()).value(s.getValue()).product(p).build());
            }
        }

        return mapper.toResponse(repo.save(p));
    }

    @Override
    public void delete(Long id) {
        if (!repo.existsById(id))
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy sản phẩm #" + id);
        repo.deleteById(id);
    }

    @Override
    public ProductResponse getById(Long id) {
        return mapper.toResponse(repo.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy sản phẩm #" + id)));
    }

    @Override
    public List<ProductResponse> getAll() {
        return mapper.toResponseList(repo.findAll(Sort.by(Sort.Direction.DESC, "createdAt")));
    }

    @Override
    public List<ProductResponse> getByCategoryId(Long categoryId) {
        List<Product> products = repo.findByCategoryId(categoryId);
        return mapper.toResponseList(products);
    }

    @Override
    public Page<ProductResponse> search(String brand, String name, BigDecimal minPrice, BigDecimal maxPrice, int page, int size, String sort) {
        String[] parts = sort.split(",");
        Sort s = parts.length == 2 ? Sort.by(Sort.Direction.fromString(parts[1]), parts[0]) : Sort.by(Sort.Direction.DESC, "createdAt");
        Pageable pageable = PageRequest.of(page, size, s);

        Specification<Product> spec = (root, cq, cb) -> cb.conjunction();
        if (brand != null && !brand.isBlank()) spec = spec.and((r, cq2, cb2) -> cb2.like(cb2.lower(r.get("brand")), "%" + brand.toLowerCase() + "%"));
        if (name != null && !name.isBlank()) spec = spec.and((r, cq2, cb2) -> cb2.like(cb2.lower(r.get("name")), "%" + name.toLowerCase() + "%"));
        if (minPrice != null) spec = spec.and((r, cq2, cb2) -> cb2.greaterThanOrEqualTo(r.get("price"), minPrice));
        if (maxPrice != null) spec = spec.and((r, cq2, cb2) -> cb2.lessThanOrEqualTo(r.get("price"), maxPrice));

        return repo.findAll(spec, pageable).map(mapper::toResponse);
    }

    @Override
    public List<String> getAllBrands() {
        return repo.findDistinctBrands();
    }

    @Override
    public List<String> suggestNames(String q, int limit) {
        if (q == null || q.isBlank()) return java.util.Collections.emptyList();
        var page = PageRequest.of(0, Math.max(1, limit));
        return repo.findDistinctNamesMatching(q, page);
    }

    @Override
    public String uploadImage(Long id, MultipartFile file) throws IOException {
        if (file == null || file.isEmpty())
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Ảnh không hợp lệ");

        Product p = repo.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy sản phẩm #" + id));

        File dir = new File(System.getProperty("user.dir"), "uploads/products");
        if (!dir.exists()) {
            if (!dir.mkdirs()) {
                throw new IOException("Không thể tạo thư mục upload: " + dir.getAbsolutePath());
            }
        }

    String original = file.getOriginalFilename() == null ? "" : file.getOriginalFilename();
        String ext = "";
        int idx = original.lastIndexOf('.');
        if (idx >= 0) ext = original.substring(idx);
        String filename = id + "_" + System.currentTimeMillis() + ext;
        File dest = new File(dir, filename);

        try (InputStream in = file.getInputStream()) {
            Files.copy(in, dest.toPath(), StandardCopyOption.REPLACE_EXISTING);
        }

        String url = "/uploads/products/" + filename;

        var img = com.proj.webprojrct.product.entity.ProductImage.builder()
                .url(url)
                .product(p)
                .build();
        // recordtheme vào product và lưu ảnh
        p.getImages().add(img);
        // if product has no primary imageUrl, set it for backward compatibility
        if (p.getImageUrl() == null || p.getImageUrl().isBlank()) p.setImageUrl(url);

        // Lưu product
        repo.save(p);
        return url;
    }

    @Override
    public void deleteImage(Long imageId) throws IOException {
        var imgOpt = imageRepo.findById(imageId);
        if (imgOpt.isEmpty()) throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy ảnh #" + imageId);
        var img = imgOpt.get();

        final String url = img.getUrl();
        Long productId = null;
        try {
            if (img.getProduct() != null) productId = img.getProduct().getId();
        } catch (Exception ignore) {
            
        }

        // Xóa file nếu tồn tại
        if (url != null && url.startsWith("/uploads/")) {
            File f = new File(System.getProperty("user.dir"), url.substring(1));
            try { Files.deleteIfExists(f.toPath()); } catch (IOException e) {
                // log but don't prevent deletion of DB record
            }
        }

        // If we know the product, load it fully and remove the image from its collection
        if (productId != null) {
            var pOpt = repo.findById(productId);
            if (pOpt.isPresent()) {
                var p = pOpt.get();
                // Ensure images collection is initialized then remove the image
                if (p.getImages() != null) {
                    p.getImages().removeIf(i -> i.getId() != null && i.getId().equals(imageId));
                }
                // If the deleted image was the product's primary imageUrl, pick another or clear
                if (p.getImageUrl() != null && url != null && p.getImageUrl().equals(url)) {
                    String newUrl = null;
                    if (p.getImages() != null && !p.getImages().isEmpty()) {
                        // pick first remaining image
                        newUrl = p.getImages().get(0).getUrl();
                    }
                    p.setImageUrl(newUrl);
                }
                repo.save(p);
                // Finally ensure the image row is removed from DB if still present
                if (imageRepo.existsById(imageId)) imageRepo.deleteById(imageId);
                return;
            }
        }

        // Fallback: delete image record directly
        if (imageRepo.existsById(imageId)) imageRepo.deleteById(imageId);
    }

    @Override
    public ProductResponse setDealStatus(Long id, Boolean onDeal, Integer dealPercentage) {
        Product p = repo.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy sản phẩm #" + id));
        p.setOnDeal(onDeal != null && onDeal);
        if (onDeal != null && onDeal) {
            // Validate percentage
            if (dealPercentage != null && dealPercentage >= 0 && dealPercentage <= 100) {
                p.setDealPercentage(dealPercentage);
            } else {
                p.setDealPercentage(0); // Default to 0% if invalid
            }
        } else {
            p.setDealPercentage(null); // Clear percentage when deal is turned off
        }
        return mapper.toResponse(repo.save(p));
    }
}
