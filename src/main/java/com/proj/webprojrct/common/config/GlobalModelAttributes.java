package com.proj.webprojrct.common.config;

import com.proj.webprojrct.product.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import java.util.List;

/**
 * Global Model Attributes - Tự động inject attributes vào tất cả các View
 * Dùng để thêm brands vào header dropdown trên mọi trang
 */
@ControllerAdvice
public class GlobalModelAttributes {

    @Autowired
    private ProductService productService;

    /**
     * Tự động thêm danh sách brands vào model cho tất cả các controller
     * Để sử dụng trong header dropdown
     */
    @ModelAttribute
    public void addBrandsToModel(Model model) {
        try {
            List<String> brands = productService.getAllBrands();
            model.addAttribute("globalBrands", brands);
        } catch (Exception e) {
            // Nếu lỗi, set empty list để không crash
            model.addAttribute("globalBrands", java.util.Collections.emptyList());
        }
    }
}
