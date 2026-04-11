package com.proj.webprojrct.document.repository;

import com.proj.webprojrct.document.entity.DocumentImage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DocumentImageRepository extends JpaRepository<DocumentImage, Long> {

    // Tìm tất cả ảnh của 1 document
    List<DocumentImage> findByDocumentId(Long documentId);
}
