package com.proj.webprojrct.category.service;

import com.proj.webprojrct.category.dto.CategoryDto;
import com.proj.webprojrct.category.entity.Category;
import com.proj.webprojrct.category.repository.CategoryRepository;
import com.proj.webprojrct.product.repository.ProductRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class CategoryServiceImpl implements CategoryService {

    private final CategoryRepository repo;
    private final ProductRepository productRepository;

    public CategoryServiceImpl(CategoryRepository repo, ProductRepository productRepository) {
        this.repo = repo;
        this.productRepository = productRepository;
    }

    @Override
    public CategoryDto create(CategoryDto dto) {
        if (repo.findByName(dto.getName()).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Tên danh mục đã tồn tại");
        }
        Category c = Category.builder()
                .name(dto.getName())
                .description(dto.getDescription())
                .parentId(dto.getParentId())
                .build();
        return map(repo.save(c));
    }

    @Override
    public CategoryDto update(Long id, CategoryDto dto) {
        Category c = repo.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy danh mục #" + id));
        c.setName(dto.getName());
        c.setDescription(dto.getDescription());
        c.setParentId(dto.getParentId());
        return map(repo.save(c));
    }

    @Override
    public void delete(Long id) {
        if (!repo.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy danh mục #" + id);
        }

        // Kiểm tra xem có sản phẩm nào đang sử dụng category này không
        List<com.proj.webprojrct.product.entity.Product> products = productRepository.findByCategoryId(id);
        if (!products.isEmpty()) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Không thể xóa danh mục này vì có " + products.size() + " sản phẩm đang sử dụng. Vui lòng xóa hoặc chuyển các sản phẩm sang danh mục khác trước."
            );
        }

        repo.deleteById(id);
    }

    @Override
    public CategoryDto getById(Long id) {
        return map(repo.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy danh mục #" + id)));
    }

    @Override
    public List<CategoryDto> getAll() {
        return repo.findAll().stream().map(this::map).collect(Collectors.toList());
    }

    @Override
    public Page<CategoryDto> getPagedCategories(Pageable pageable, String name) {
        Page<Category> categoryPage;
        if (name != null && !name.trim().isEmpty()) {
            categoryPage = repo.findByNameContainingIgnoreCase(name, pageable);
        } else {
            categoryPage = repo.findAll(pageable);
        }
        return categoryPage.map(this::map);
    }

    @Override
    public List<CategoryDto> getParentCategories() {
        return repo.findByParentIdIsNull().stream()
                .map(this::map)
                .collect(Collectors.toList());
    }

    @Override
    public List<CategoryDto> getChildCategories(Long parentId) {
        return repo.findByParentId(parentId).stream()
                .map(this::map)
                .collect(Collectors.toList());
    }

    private CategoryDto map(Category c) {
        return new CategoryDto(c.getId(), c.getName(), c.getDescription(), c.getParentId());
    }
}
