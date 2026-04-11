package com.proj.webprojrct.product.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import com.proj.webprojrct.product.service.ProductService;
import com.proj.webprojrct.category.service.CategoryService;
import com.proj.webprojrct.product.dto.response.ProductResponse;

import java.util.List;

@Controller
public class ProductPageController {

    private final ProductService productService;

    @Autowired
    private CategoryService categoryService;

    public ProductPageController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping("/shop")
    public String shop(@RequestParam(required = false) List<Long> category,
            @RequestParam(required = false) List<String> brand,
            @RequestParam(required = false) List<String> series, // Thêm param series
            @RequestParam(required = false) String name,
            @RequestParam(required = false, defaultValue = "popular") String sort,
            @RequestParam(required = false, defaultValue = "12") int limit,
            @RequestParam(required = false, defaultValue = "1") int page,
            Model model) {
        try {
            List<ProductResponse> allProducts = productService.getAll();
            List<ProductResponse> products = allProducts;

            // Lọc theo tên sản phẩm (search) với fuzzy matching
            if (name != null && !name.trim().isEmpty()) {
                String searchTerm = name.trim().toLowerCase();
                String[] searchWords = searchTerm.split("\\s+");

                products = products.stream()
                        .filter(p -> {
                            if (p.getName() == null) {
                                return false;
                            }
                            String productName = p.getName().toLowerCase();

                            // Exact match
                            if (productName.contains(searchTerm)) {
                                return true;
                            }

                            // Check if any search word is in product name
                            for (String word : searchWords) {
                                if (word.length() >= 2 && productName.contains(word)) {
                                    return true;
                                }
                            }

                            // Fuzzy matching for typos
                            return isFuzzyMatch(productName, searchTerm);
                        })
                        .collect(java.util.stream.Collectors.toList());
            }

            // Lọc theo categories (có thể chọn nhiều)
            if (category != null && !category.isEmpty()) {
                products = products.stream()
                        .filter(p -> p.getCategory() != null && category.contains(p.getCategory().getId()))
                        .collect(java.util.stream.Collectors.toList());
            }

            // Lọc theo brands (có thể chọn nhiều)
            if (brand != null && !brand.isEmpty()) {
                products = products.stream()
                        .filter(p -> p.getBrand() != null && brand.contains(p.getBrand()))
                        .collect(java.util.stream.Collectors.toList());
            }

            // Lọc theo series (có thể chọn nhiều) - lọc theo category con từ DB
            if (series != null && !series.isEmpty()) {
                // Lấy tất cả categories từ database
                List<com.proj.webprojrct.category.dto.CategoryDto> allCategories = categoryService.getAll();

                // Tạo set chứa tên các category con (series) được chọn
                java.util.Set<Long> seriesCategoryIds = new java.util.HashSet<>();
                for (String seriesName : series) {
                    for (com.proj.webprojrct.category.dto.CategoryDto cat : allCategories) {
                        if (cat.getParentId() != null && seriesName.equals(cat.getName())) {
                            seriesCategoryIds.add(cat.getId());
                        }
                    }
                }

                // Lọc products theo category IDs
                products = products.stream()
                        .filter(p -> p.getCategory() != null
                        && seriesCategoryIds.contains(p.getCategory().getId()))
                        .collect(java.util.stream.Collectors.toList());
            }

            // Sắp xếp
            java.util.Comparator<ProductResponse> comparator = null;
            switch (sort) {
                case "price-asc":
                    comparator = java.util.Comparator.comparing(ProductResponse::getPrice);
                    break;
                case "price-desc":
                    comparator = java.util.Comparator.comparing(ProductResponse::getPrice).reversed();
                    break;
                case "popular":
                default:
                    // Sắp xếp theo ID giảm dần (sản phẩm mới nhất)
                    comparator = java.util.Comparator.comparing(ProductResponse::getId).reversed();
                    break;
            }

            if (comparator != null) {
                products = products.stream()
                        .sorted(comparator)
                        .collect(java.util.stream.Collectors.toList());
            }

            // Tính toán phân trang
            int totalProducts = products.size();
            int totalPages = (int) Math.ceil((double) totalProducts / limit);

            // Đảm bảo page không vượt quá số trang
            if (page < 1) {
                page = 1;
            }
            if (page > totalPages && totalPages > 0) {
                page = totalPages;
            }

            // Lấy products cho trang hiện tại
            int startIndex = (page - 1) * limit;
            int endIndex = Math.min(startIndex + limit, totalProducts);

            List<ProductResponse> paginatedProducts;
            if (startIndex < totalProducts) {
                paginatedProducts = products.subList(startIndex, endIndex);
            } else {
                paginatedProducts = java.util.Collections.emptyList();
            }

            model.addAttribute("products", paginatedProducts);

            // Lấy series động dựa theo brand đã chọn (thay vì categories từ DB)
            List<com.proj.webprojrct.product.dto.ProductSeriesDto> availableSeries;
            System.out.println("Selected brands: " + brand);
            if (brand != null && !brand.isEmpty()) {
                // Có chọn brand → Tự động generate series từ products của các brand đã chọn
                availableSeries = generateSeriesByBrands(allProducts, brand);
            } else {
                // Chưa chọn brand → Không hiện series (để user chọn brand trước)
                availableSeries = java.util.Collections.emptyList();
            }

            model.addAttribute("series", availableSeries);
            model.addAttribute("brands", productService.getAllBrands());
            model.addAttribute("selectedCategories", category != null ? category : java.util.Collections.emptyList());
            model.addAttribute("selectedBrands", brand != null ? brand : java.util.Collections.emptyList());
            model.addAttribute("selectedSeries", series != null ? series : java.util.Collections.emptyList()); // Thêm selected series
            model.addAttribute("searchName", name != null ? name : "");
            model.addAttribute("selectedSort", sort);
            model.addAttribute("selectedLimit", limit);
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("totalProducts", totalProducts);
            model.addAttribute("startIndex", startIndex + 1);
            model.addAttribute("endIndex", endIndex);
        } catch (Exception e) {
            model.addAttribute("error", "Không thể tải dữ liệu: " + e.getMessage());
        }
        return "shop";
    }

    // //admin
    // @GetMapping("/products")
    // public String products(Model model) {
    //     // Có thể thêm logic load products vào model nếu cần
    //     return "product_list";
    // }
    //user
    @GetMapping("/product/{id}")
    public String productDetail(@PathVariable Long id, Model model) {
        ProductResponse product = productService.getById(id);
        model.addAttribute("product", product);

        // Sản phẩm liên quan: cùng category
        List<ProductResponse> relatedProducts = new java.util.ArrayList<>();
        if (product.getCategory() != null) {
            relatedProducts = productService.getByCategoryId(product.getCategory().getId());
            // Loại bỏ chính sản phẩm đang xem
            relatedProducts.removeIf(p -> p.getId().equals(product.getId()));
        }
        model.addAttribute("relatedProducts", relatedProducts);

        // Sản phẩm cùng dòng (cùng series, khác model variant)
        // Ví dụ: iPhone 15 → hiện iPhone 15 Pro, iPhone 15 Pro Max, iPhone 15 Plus
        List<ProductResponse> versionProducts = new java.util.ArrayList<>();
        if (product.getName() != null && product.getBrand() != null) {
            String currentSeries = extractSeriesName(product.getName());

            List<ProductResponse> allProducts = productService.getAll();
            for (ProductResponse p : allProducts) {
                if (p.getId().equals(product.getId())) {
                    continue; // Skip current product

                }
                if (p.getName() == null || p.getBrand() == null) {
                    continue;
                }

                // Cùng brand và cùng series
                if (product.getBrand().equals(p.getBrand())) {
                    String productSeries = extractSeriesName(p.getName());
                    if (currentSeries.equals(productSeries)) {
                        versionProducts.add(p);
                    }
                }
            }
        }

        List<ProductResponse> sameProducts = new java.util.ArrayList<>();
        // Sản phẩm cùng thương hiệu
        if (product.getBrand() != null) {
            List<ProductResponse> allProducts = productService.getAll();
            for (ProductResponse p : allProducts) {
                if (product.getBrand().equals(p.getBrand()) && !p.getId().equals(product.getId())) {
                    sameProducts.add(p);
                }
            }
        }
        model.addAttribute("sameProducts", sameProducts);
        model.addAttribute("versionProducts", versionProducts);

        return "product_detail";
    }

    @GetMapping("/deals")
    public String deals(Model model) {
        try {
            // Get all products with onDeal=true
            List<ProductResponse> allProducts = productService.getAll();
            List<ProductResponse> dealProducts = allProducts.stream()
                    .filter(p -> p.getOnDeal() != null && p.getOnDeal())
                    .collect(java.util.stream.Collectors.toList());

            model.addAttribute("products", dealProducts);
            model.addAttribute("categories", categoryService.getAll());
        } catch (Exception e) {
            model.addAttribute("error", "Không thể tải dữ liệu khuyến mãi: " + e.getMessage());
        }
        return "deals";
    }

    // Helper method for fuzzy matching
    private boolean isFuzzyMatch(String productName, String searchTerm) {
        if (searchTerm.length() < 3) {
            return false;
        }

        int searchIndex = 0;
        for (int i = 0; i < productName.length() && searchIndex < searchTerm.length(); i++) {
            if (productName.charAt(i) == searchTerm.charAt(searchIndex)) {
                searchIndex++;
            }
        }

        // If we matched at least 70% of search term characters
        return searchIndex >= (searchTerm.length() * 0.7);
    }

    /**
     * Extract series name from product name Example: "iPhone 15 Pro Max 256GB
     * Titan Đen" → "iPhone 15" Example: "Samsung Galaxy S24 Ultra 512GB" →
     * "Galaxy S24" Example: "Xiaomi 14 Ultra 16GB/512GB" → "Xiaomi 14"
     */
    private String extractSeriesName(String productName) {
        if (productName == null || productName.trim().isEmpty()) {
            return "";
        }

        String name = productName.trim();

        // List of known series patterns (brand + series number)
        // Pattern: Brand + Number (e.g., iPhone 15, Galaxy S24, Xiaomi 14)
        String[] patterns = {
            // Apple
            "iPhone SE", "iPhone 17", "iPhone 16", "iPhone 15", "iPhone 14", "iPhone 13",
            "iPhone 12", "iPhone 11", "iPad Pro", "iPad Air", "iPad Mini",
            // Samsung
            "Galaxy S24", "Galaxy S23", "Galaxy S22", "Galaxy S21",
            "Galaxy Z Fold6", "Galaxy Z Fold5", "Galaxy Z Flip6", "Galaxy Z Flip5",
            "Galaxy A55", "Galaxy A54", "Galaxy A35", "Galaxy A34", "Galaxy A25", "Galaxy A15",
            "Galaxy M55", "Galaxy M35",
            // Xiaomi
            "Xiaomi 14", "Xiaomi 13", "Xiaomi 12",
            "Redmi Note 13", "Redmi Note 12", "Redmi Note 11",
            "Redmi 13", "Redmi 12", "POCO X6", "POCO F6", "POCO M6",
            // OPPO
            "OPPO Find X7", "OPPO Find X6", "OPPO Reno12", "OPPO Reno11",
            "OPPO A79", "OPPO A78", "OPPO A60", "OPPO A58",
            // Vivo
            "vivo V30", "vivo V29", "vivo Y58", "vivo Y36", "vivo Y28",
            // Realme
            "realme 12", "realme 11", "realme C67", "realme C65", "realme C55",
            // OnePlus
            "OnePlus 12", "OnePlus 11", "OnePlus Nord CE4",
            // Google
            "Google Pixel 9", "Google Pixel 8", "Google Pixel 7"
        };

        // Find matching series (longest first to match correctly)
        for (String pattern : patterns) {
            if (name.startsWith(pattern)) {
                return pattern;
            }
        }

        // Fallback: Extract brand + first number/word
        // Example: "ASUS ROG Phone 8" → "ASUS ROG Phone 8"
        String[] words = name.split("\\s+");
        if (words.length >= 2) {
            // Try to find pattern: Brand + Number
            for (int i = 0; i < words.length - 1; i++) {
                if (words[i + 1].matches(".*\\d+.*")) { // Contains digit
                    return String.join(" ", java.util.Arrays.copyOfRange(words, 0, i + 2));
                }
            }
            // If no number found, return first 2 words
            return words[0] + " " + words[1];
        }

        return words.length > 0 ? words[0] : "";
    }

    /**
     * Lấy danh sách category con (subcategories) từ database dựa theo brands đã
     * chọn Trả về dưới dạng ProductSeriesDto để tương thích với code hiện tại
     *
     * @param products Danh sách sản phẩm để đếm
     * @param brands Danh sách brands đã chọn
     * @return Danh sách ProductSeriesDto (seriesName = category name, brand =
     * parent category name)
     */
    private List<com.proj.webprojrct.product.dto.ProductSeriesDto> generateSeriesByBrands(
            List<ProductResponse> products,
            List<String> brands) {

        List<com.proj.webprojrct.product.dto.ProductSeriesDto> result = new java.util.ArrayList<>();

        // Lấy tất cả categories từ database
        List<com.proj.webprojrct.category.dto.CategoryDto> allCategories = categoryService.getAll();

        // Tạo map: category parent name -> category parent ID
        java.util.Map<String, Long> brandToCategoryId = new java.util.HashMap<>();
        for (com.proj.webprojrct.category.dto.CategoryDto cat : allCategories) {
            if (cat.getParentId() == null && brands.contains(cat.getName())) {
                brandToCategoryId.put(cat.getName(), cat.getId());
            }
        }

        // Tạo map: category parent ID -> category parent name
        java.util.Map<Long, String> categoryIdToBrand = new java.util.HashMap<>();
        for (java.util.Map.Entry<String, Long> entry : brandToCategoryId.entrySet()) {
            categoryIdToBrand.put(entry.getValue(), entry.getKey());
        }

        // Lấy tất cả category con của các brands đã chọn
        for (com.proj.webprojrct.category.dto.CategoryDto subCat : allCategories) {
            if (subCat.getParentId() != null && brandToCategoryId.containsValue(subCat.getParentId())) {
                // Đếm số lượng sản phẩm thuộc category con này
                long productCount = products.stream()
                        .filter(p -> p.getCategory() != null
                        && p.getCategory().getId().equals(subCat.getId()))
                        .count();

                // Lấy tên brand (category cha)
                String brandName = categoryIdToBrand.getOrDefault(subCat.getParentId(), "Unknown");

                // Tạo ProductSeriesDto
                com.proj.webprojrct.product.dto.ProductSeriesDto seriesDto
                        = new com.proj.webprojrct.product.dto.ProductSeriesDto(
                                subCat.getName(), // seriesName = tên category con
                                brandName, // brand = tên category cha
                                Long.valueOf(productCount) // số lượng sản phẩm
                        );

                result.add(seriesDto);
            }
        }

        return result;
    }
}
