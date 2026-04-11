package com.proj.webprojrct.product.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.proj.webprojrct.product.entity.ProductSpec;

public interface ProductSpecRepository extends JpaRepository<ProductSpec, Long> {}
