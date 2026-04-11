package com.proj.webprojrct.category.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import com.proj.webprojrct.category.entity.Category;
import java.util.List;
import java.util.Optional;

public interface CategoryRepository extends JpaRepository<Category, Long> {
    Optional<Category> findByName(String name);
    
    // Phân trang với tìm kiếm theo tên
    Page<Category> findByNameContainingIgnoreCase(String name, Pageable pageable);
    
    // Lấy danh mục cha (parentId = null) - Các hãng: Apple, Samsung, Xiaomi...
    List<Category> findByParentIdIsNull();
    
    // Lấy danh mục con theo parentId - Các dòng sản phẩm: iPhone 17, Galaxy S24...
    List<Category> findByParentId(Long parentId);
}
