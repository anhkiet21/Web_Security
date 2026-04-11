package com.proj.webprojrct.category.controller;

import com.proj.webprojrct.category.dto.CategoryDto;
import com.proj.webprojrct.category.service.CategoryService;
import com.proj.webprojrct.common.config.security.CustomUserDetails;

import org.springframework.http.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.entity.UserRole;

@RestController
@RequestMapping(value = "/api/categories", produces = MediaType.APPLICATION_JSON_VALUE)
public class CategoryController {

    private final CategoryService service;

    public CategoryController(CategoryService service) {
        this.service = service;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public CategoryDto create(@RequestBody CategoryDto dto) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Access denied: Only ADMIN users can create categories.");
        }

        return service.create(dto);
    }

    @PutMapping("/{id}")
    public CategoryDto update(@PathVariable Long id, @RequestBody CategoryDto dto) {

        return service.update(id, dto);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {

        service.delete(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}")
    public CategoryDto getById(@PathVariable Long id) {

        return service.getById(id);
    }

    @GetMapping
    public List<CategoryDto> getAll() {

        return service.getAll();
    }

    // Lấy danh mục cha (Hãng) - dùng cho dropdown "Hãng" trong form sản phẩm
    @GetMapping("/parents")
    public List<CategoryDto> getParentCategories() {

        return service.getParentCategories();
    }

    // Lấy danh mục con (Dòng sản phẩm) theo parentId - AJAX từ form khi chọn hãng
    @GetMapping("/children/{parentId}")
    public List<CategoryDto> getChildCategories(@PathVariable Long parentId) {

        return service.getChildCategories(parentId);
    }
}
