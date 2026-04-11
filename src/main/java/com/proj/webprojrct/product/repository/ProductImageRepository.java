package com.proj.webprojrct.product.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.proj.webprojrct.product.entity.ProductImage;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

import com.proj.webprojrct.product.entity.Product;

public interface ProductImageRepository extends JpaRepository<ProductImage, Long> {

    @Query("select p.id from ProductImage i join i.product p where i.id = :id")
    Optional<Long> findProductIdByImageId(@Param("id") Long id);

    // Lấy danh sách hình của product
    List<ProductImage> findByProduct(Product product);

    // Hoặc lấy hình đầu tiên của product
    Optional<ProductImage> findFirstByProductOrderByIdAsc(Product product);
}
