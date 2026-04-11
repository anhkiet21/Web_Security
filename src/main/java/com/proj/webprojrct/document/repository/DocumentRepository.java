package com.proj.webprojrct.document.repository;

import com.proj.webprojrct.document.entity.Document;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DocumentRepository extends JpaRepository<Document, Long> {

    // Tìm tất cả document theo productId
    List<Document> findByProductId(Long productId);
    
    // Lấy danh sách productId đã có document
    @Query("SELECT DISTINCT d.productId FROM Document d")
    List<Long> findAllProductIdsWithDocuments();
    
    // Phân trang với tìm kiếm theo title
    Page<Document> findByTitleContainingIgnoreCase(String title, Pageable pageable);
}
