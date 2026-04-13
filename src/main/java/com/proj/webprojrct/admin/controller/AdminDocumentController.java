package com.proj.webprojrct.admin.controller;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.proj.webprojrct.document.entity.Document;
import com.proj.webprojrct.common.config.security.CustomUserDetails;
import com.proj.webprojrct.document.dto.request.DocumentCreateRequest;
import com.proj.webprojrct.document.service.DocumentService;
import com.proj.webprojrct.product.dto.response.ProductResponse;
import com.proj.webprojrct.product.service.ProductService;
import com.proj.webprojrct.user.entity.UserRole;
import com.proj.webprojrct.document.repository.DocumentRepository;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;

import java.util.Map;

import org.springframework.security.core.Authentication;

import com.proj.webprojrct.user.entity.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
@RequestMapping("/admin/document")
public class AdminDocumentController {

    private static final Logger log = LoggerFactory.getLogger(AdminDocumentController.class);

    @Autowired
    private DocumentService documentService;

    @Autowired
    private ProductService productService;

    @Autowired
    private DocumentRepository documentRepository;

    @GetMapping
    public String show(
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "size", defaultValue = "10") int size,
            @RequestParam(value = "title", required = false) String title,
            @RequestParam(value = "sort", defaultValue = "id,asc") String sort,
            Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() != UserRole.ADMIN) {
            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN, "Access denied");
        }

        // Parse sort parameter
        String[] sortParams = sort.split(",");
        String sortField = sortParams.length > 0 ? sortParams[0] : "id";
        String sortDir = sortParams.length > 1 ? sortParams[1] : "asc";

        Sort.Direction direction = sortDir.equalsIgnoreCase("desc") ? Sort.Direction.DESC : Sort.Direction.ASC;
        Pageable pageable = PageRequest.of(page, size, Sort.by(direction, sortField));

        Page<Document> documentPage = documentService.getPagedDocuments(pageable, title);
        List<ProductResponse> products = productService.getAll();

        model.addAttribute("documents", documentPage);
        model.addAttribute("products", products);

        // Add filter parameters to model
        if (title != null) {
            model.addAttribute("filterTitle", title);
        }
        model.addAttribute("filterSort", sort);

        return "admin/document_list";
    }

    @GetMapping({ "/all", "/list" })
    public String showAllDocuments(
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "size", defaultValue = "10") int size,
            @RequestParam(value = "title", required = false) String title,
            @RequestParam(value = "sort", defaultValue = "id,asc") String sort,
            Model model) {
        return show(page, size, title, sort, model);
    }

    @GetMapping({ "/create", "/new" })
    public String showCreateForm(Model model) {
        model.addAttribute("document", null);
        model.addAttribute("formAction", "/admin/document/create");

        // Load danh sách products chưa có document
        List<ProductResponse> allProducts = productService.getAll();
        List<Long> productIdsWithDocuments = documentRepository.findAllProductIdsWithDocuments();

        // Lọc ra những sản phẩm chưa có document
        List<ProductResponse> availableProducts = allProducts.stream()
                .filter(product -> !productIdsWithDocuments.contains(product.getId()))
                .collect(Collectors.toList());

        model.addAttribute("products", availableProducts);

        return "admin/document_form";
    }

    @PostMapping("/create")
    public String handleCreateDocument(@ModelAttribute DocumentCreateRequest dto,
            @RequestParam(value = "images", required = false) List<MultipartFile> images,
            Model model,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null) {
            return "redirect:/login";
        }
        if (userDetails.getUser().getRole() != UserRole.ADMIN) {
            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN, "Access denied");
        }
        try {
            documentService.createDocument(dto, images == null ? List.of() : images);
            model.addAttribute("success", "Tạo Document thành công!");
            return "redirect:/admin/document";
        } catch (RuntimeException e) {
            log.error("Lỗi khi tạo document", e);
            model.addAttribute("error", "Lỗi khi tạo document. Vui lòng thử lại.");
            return "admin/document_form";
        }
    }

    @GetMapping("/{id}")
    public String showDocumentDetail(@PathVariable Long id, Model model,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null) {
            return "redirect:/login";
        }
        if (userDetails.getUser().getRole() != UserRole.ADMIN) {
            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN, "Access denied");
        }
        Document doc = documentService.getDocument(id);
        model.addAttribute("document", doc);
        return "admin/document_detail";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null) {
            return "redirect:/login";
        }
        if (userDetails.getUser().getRole() != UserRole.ADMIN) {
            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN, "Access denied");
        }
        Document document = documentService.getDocument(id);
        model.addAttribute("document", document);

        // Load danh sách products chưa có document
        List<ProductResponse> allProducts = productService.getAll();
        List<Long> productIdsWithDocuments = documentRepository.findAllProductIdsWithDocuments();

        // Lọc ra những sản phẩm chưa có document, NHƯNG vẫn giữ lại sản phẩm hiện tại
        // của document này
        List<ProductResponse> availableProducts = allProducts.stream()
                .filter(product -> !productIdsWithDocuments.contains(product.getId())
                        || product.getId().equals(document.getProductId()))
                .collect(Collectors.toList());

        model.addAttribute("products", availableProducts);

        return "admin/document_form";
    }

    @PostMapping("/update/{id}")
    public String updateDocument(@PathVariable Long id,
            @ModelAttribute DocumentCreateRequest dto,
            @RequestParam(value = "images", required = false) List<MultipartFile> images,
            Model model,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null) {
            return "redirect:/login";
        }
        if (userDetails.getUser().getRole() != UserRole.ADMIN) {
            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN, "Access denied");
        }
        documentService.updateDocument(id, dto, images == null ? List.of() : images);
        model.addAttribute("success", "Cập nhật document thành công!");
        return "redirect:/admin/document";
    }

    @PostMapping("/upload-image")
    @ResponseBody
    public ResponseEntity<?> handleEditorImageUpload(@RequestParam("image") MultipartFile image,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null) {
            return ResponseEntity.status(401).body(Map.of("error", "Unauthorized"));
        }
        if (userDetails.getUser().getRole() != UserRole.ADMIN) {
            return ResponseEntity.status(403)
                    .body(Map.of("error", "Access denied: Only ADMIN users can access category management."));
        }
        try {
            String imageUrl = documentService.saveImage(image);
            return ResponseEntity.ok(Map.of("imageUrl", imageUrl));
        } catch (IllegalArgumentException e) {
            // Lỗi validate: sai định dạng / nội dung file
            return ResponseEntity.status(400).body(Map.of("error", "File không hợp lệ. Vui lòng kiểm tra lại."));
        } catch (Exception e) {
            log.error("Lỗi hệ thống khi upload ảnh", e);
            return ResponseEntity.status(500).body(Map.of("error", "Lỗi hệ thống khi upload ảnh."));
        }
    }

    @GetMapping("/delete/{id}")
    public String deleteDocument(@PathVariable Long id, Model model) {
        try {
            documentService.deleteDocument(id);
            model.addAttribute("success", "Xóa document thành công!");
        } catch (Exception e) {
            log.error("Lỗi khi xóa document id={}", id, e);
            model.addAttribute("error", "Không thể xóa document. Vui lòng thử lại.");
        }
        return "redirect:/admin/document";
    }

    // API endpoint to get document by productId (for product detail page)
    @GetMapping("/api/product/{productId}")
    @ResponseBody
    public ResponseEntity<?> getDocumentByProductId(@PathVariable Long productId,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null) {
            return ResponseEntity.status(401).body(Map.of("error", "Unauthorized"));
        }
        if (userDetails.getUser().getRole() != UserRole.ADMIN) {
            return ResponseEntity.status(403)
                    .body(Map.of("error", "Access denied: Only ADMIN users can access category management."));
        }
        try {
            Document document = documentService.getDocumentByProductId(productId);
            if (document == null) {
                return ResponseEntity.notFound().build();
            }
            return ResponseEntity.ok(document);
        } catch (Exception e) {
            log.error("Lỗi khi lấy document cho product id={}", productId, e);
            return ResponseEntity.status(500).body(Map.of("error", "Lỗi hệ thống. Vui lòng thử lại sau."));
        }
    }
}
