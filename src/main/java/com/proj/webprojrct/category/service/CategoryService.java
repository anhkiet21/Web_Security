package com.proj.webprojrct.category.service;

import com.proj.webprojrct.category.dto.CategoryDto;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import java.util.List;

public interface CategoryService {

    CategoryDto create(CategoryDto dto);

    CategoryDto update(Long id, CategoryDto dto);

    void delete(Long id);

    CategoryDto getById(Long id);

    List<CategoryDto> getAll();
    
    Page<CategoryDto> getPagedCategories(Pageable pageable, String name);
    
    // Lấy danh mục cha (Hãng: Apple, Samsung, Xiaomi...)
    List<CategoryDto> getParentCategories();
    
    // Lấy danh mục con theo parentId (Dòng sản phẩm: iPhone 17, Galaxy S24...)
    List<CategoryDto> getChildCategories(Long parentId);
}
