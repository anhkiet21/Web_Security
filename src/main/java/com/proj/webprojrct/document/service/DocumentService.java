package com.proj.webprojrct.document.service;

import com.proj.webprojrct.document.dto.request.DocumentCreateRequest;
import com.proj.webprojrct.document.entity.Document;
import com.proj.webprojrct.document.entity.DocumentImage;
import com.proj.webprojrct.document.repository.DocumentRepository;
import com.proj.webprojrct.storage.service.DocumentStorageService;

import com.proj.webprojrct.storage.service.FileSignatureValidator;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class DocumentService {

    private final DocumentRepository documentRepository;
    private final DocumentStorageService documentStorageService;

    @Transactional
    public Document createDocument(DocumentCreateRequest dto, List<MultipartFile> images) {
        Document doc = Document.builder()
                .title(dto.getTitle())
                .description(dto.getDescription())
                .productId(dto.getProductId())
                .build();

        List<DocumentImage> imgList = new ArrayList<>();
        for (MultipartFile file : images) {
            if (file != null && !file.isEmpty()) {
                try (InputStream inputStream = file.getInputStream()) {
                    // Lưu file bằng DocumentStorageService
                    String savedFileName = documentStorageService.save(file.getOriginalFilename(), inputStream);

                    // Tạo entity ảnh
                    DocumentImage img = new DocumentImage();
                    img.setImageUrl("/uploads/documents/" + savedFileName);
                    img.setDocument(doc);
                    imgList.add(img);
                } catch (IOException e) {
                    throw new RuntimeException("Lỗi khi lưu ảnh: " + e.getMessage());
                }
            }
        }

        doc.setImages(imgList);
        return documentRepository.save(doc);
    }

    @Transactional
    public Document updateDocument(Long id, DocumentCreateRequest dto, List<MultipartFile> images) {
        Document existing = documentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Document không tồn tại với id: " + id));

        existing.setTitle(dto.getTitle());
        existing.setDescription(dto.getDescription());
        existing.setProductId(dto.getProductId());

        if (images != null && !images.isEmpty()) {
            List<DocumentImage> newImages = new ArrayList<>();
            for (MultipartFile file : images) {
                if (file != null && !file.isEmpty()) {
                    try (InputStream inputStream = file.getInputStream()) {
                        String savedFileName = documentStorageService.save(file.getOriginalFilename(), inputStream);
                        DocumentImage img = new DocumentImage();
                        img.setImageUrl("/uploads/documents/" + savedFileName);
                        img.setDocument(existing);
                        newImages.add(img);
                    } catch (IOException e) {
                        throw new RuntimeException("Lỗi khi lưu ảnh: " + e.getMessage());
                    }
                }
            }
            existing.getImages().addAll(newImages);
        }

        return documentRepository.save(existing);
    }

    private final String uploadDir = "uploads/document/";

    public String saveImage(MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("File không được để trống.");
        }

        String originalFileName = file.getOriginalFilename();
        String fileExtension = "";
        if (originalFileName != null && originalFileName.contains(".")) {
            fileExtension = originalFileName.substring(originalFileName.lastIndexOf(".")).toLowerCase();
        }

        // Bước 1: Kiểm tra đuôi file
        java.util.List<String> allowedExtensions = java.util.Arrays.asList(".jpg", ".jpeg", ".png", ".gif", ".webp");
        if (allowedExtensions.stream().noneMatch(fileExtension::equals)) {
            throw new IllegalArgumentException(
                "Định dạng file không được phép. Chỉ chấp nhận: JPG, JPEG, PNG, GIF, WEBP.");
        }

        // Bước 2: Kiểm tra nội dung thực (magic bytes qua Tika)
        InputStream input = FileSignatureValidator.ensureMarkSupported(file.getInputStream());
        if (!FileSignatureValidator.isValidImage(input)) {
            String detected = FileSignatureValidator.detectMimeType(
                FileSignatureValidator.ensureMarkSupported(file.getInputStream()));
            throw new IllegalArgumentException(
                "Nội dung file không hợp lệ (phát hiện: " + detected + "). Vui lòng chỉ tải lên file ảnh thực sự.");
        }

        Path uploadPath = Paths.get(uploadDir);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
        Path filePath = uploadPath.resolve(uniqueFileName);
        Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);

        return "/" + uploadDir + uniqueFileName;
    }

    // Nếu cần, có thể thêm hàm xóa ảnh
    public void deleteImage(String fileName) {
        try {
            Path filePath = Paths.get(uploadDir).resolve(fileName);
            if (Files.exists(filePath)) {
                Files.delete(filePath);
            }
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi xóa ảnh: " + e.getMessage(), e);
        }
    }

    public List<Document> getAllDocuments() {
        return documentRepository.findAll();
    }

    public Document getDocument(Long id) {
        return documentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Document không tồn tại với id: " + id));
    }
    
    public Document getDocumentByProductId(Long productId) {
        List<Document> documents = documentRepository.findByProductId(productId);
        return documents.isEmpty() ? null : documents.get(0);
    }

    public void deleteDocument(Long id) {
        Document document = documentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Document không tồn tại với id: " + id));
        
        // Xóa các file ảnh liên quan
        if (document.getImages() != null && !document.getImages().isEmpty()) {
            for (DocumentImage image : document.getImages()) {
                try {
                    deleteImage(image.getImageUrl());
                } catch (Exception e) {
                    System.err.println("Không thể xóa ảnh: " + image.getImageUrl());
                }
            }
        }
        
        // Xóa document (cascade sẽ xóa images trong DB)
        documentRepository.delete(document);
    }
    
    public Page<Document> getPagedDocuments(Pageable pageable, String title) {
        if (title != null && !title.trim().isEmpty()) {
            String safeTitle = title.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_");
            return documentRepository.findByTitleContainingIgnoreCase(safeTitle, pageable);
        }
        return documentRepository.findAll(pageable);
    }
}
