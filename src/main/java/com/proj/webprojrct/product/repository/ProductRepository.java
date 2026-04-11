package com.proj.webprojrct.product.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import com.proj.webprojrct.product.entity.Product;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long>, JpaSpecificationExecutor<Product> {

    @org.springframework.data.jpa.repository.Query("select distinct p.brand from Product p where p.brand is not null order by p.brand asc")
    java.util.List<String> findDistinctBrands();

    @org.springframework.data.jpa.repository.Query(value = "select distinct p.name from Product p where lower(p.name) like lower(concat('%', :q, '%')) order by p.name asc")
    java.util.List<String> findDistinctNamesMatching(@org.springframework.data.repository.query.Param("q") String q, org.springframework.data.domain.Pageable pageable);

    // Find products by category ID
    java.util.List<Product> findByCategoryId(Long categoryId);

}
