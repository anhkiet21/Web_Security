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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
public class ProductPageController {

    private static final Logger log = LoggerFactory.getLogger(ProductPageController.class);

    private final ProductService productService;

    @Autowired
    private CategoryService categoryService;

    public ProductPageController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping("/shop")
    public String shop(@RequestParam(required = false) List<Long> category,
            @RequestParam(required = false) List<String> brand,
            @RequestParam(required = false) List<String> series, // ThÃªm param series
            @RequestParam(required = false) String name,
            @RequestParam(required = false, defaultValue = "popular") String sort,
            @RequestParam(required = false, defaultValue = "12") int limit,
            @RequestParam(required = false, defaultValue = "1") int page,
            Model model) {
        try {
            List<ProductResponse> allProducts = productService.getAll();
            List<ProductResponse> products = allProducts;

            // Lá»c theo tÃªn sáº£n pháº©m (search) vá»›i fuzzy matching
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

            // Lá»c theo categories (cÃ³ thá»ƒ chá»n nhiá»u)
            if (category != null && !category.isEmpty()) {
                products = products.stream()
                        .filter(p -> p.getCategory() != null && category.contains(p.getCategory().getId()))
                        .collect(java.util.stream.Collectors.toList());
            }

            // Lá»c theo brands (cÃ³ thá»ƒ chá»n nhiá»u)
            if (brand != null && !brand.isEmpty()) {
                products = products.stream()
                        .filter(p -> p.getBrand() != null && brand.contains(p.getBrand()))
                        .collect(java.util.stream.Collectors.toList());
            }

            // Lá»c theo series (cÃ³ thá»ƒ chá»n nhiá»u) - lá»c theo category con tá»« DB
            if (series != null && !series.isEmpty()) {
                // Láº¥y táº¥t cáº£ categories tá»« database
                List<com.proj.webprojrct.category.dto.CategoryDto> allCategories = categoryService.getAll();

                // Táº¡o set chá»©a tÃªn cÃ¡c category con (series) Ä‘Æ°á»£c chá»n
                java.util.Set<Long> seriesCategoryIds = new java.util.HashSet<>();
                for (String seriesName : series) {
                    for (com.proj.webprojrct.category.dto.CategoryDto cat : allCategories) {
                        if (cat.getParentId() != null && seriesName.equals(cat.getName())) {
                            seriesCategoryIds.add(cat.getId());
                        }
                    }
                }

                // Lá»c products theo category IDs
                products = products.stream()
                        .filter(p -> p.getCategory() != null
                        && seriesCategoryIds.contains(p.getCategory().getId()))
                        .collect(java.util.stream.Collectors.toList());
            }

            // Sáº¯p xáº¿p
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
                    // Sáº¯p xáº¿p theo ID giáº£m dáº§n (sáº£n pháº©m má»›i nháº¥t)
                    comparator = java.util.Comparator.comparing(ProductResponse::getId).reversed();
                    break;
            }

            if (comparator != null) {
                products = products.stream()
                        .sorted(comparator)
                        .collect(java.util.stream.Collectors.toList());
            }

            // TÃ­nh toÃ¡n phÃ¢n trang
            int totalProducts = products.size();
            int totalPages = (int) Math.ceil((double) totalProducts / limit);

            // Äáº£m báº£o page khÃ´ng vÆ°á»£t quÃ¡ sá»‘ trang
            if (page < 1) {
                page = 1;
            }
            if (page > totalPages && totalPages > 0) {
                page = totalPages;
            }

            // Láº¥y products cho trang hiá»‡n táº¡i
            int startIndex = (page - 1) * limit;
            int endIndex = Math.min(startIndex + limit, totalProducts);

            List<ProductResponse> paginatedProducts;
            if (startIndex < totalProducts) {
                paginatedProducts = products.subList(startIndex, endIndex);
            } else {
                paginatedProducts = java.util.Collections.emptyList();
            }

            model.addAttribute("products", paginatedProducts);

            // Láº¥y series Ä‘á»™ng dá»±a theo brand Ä‘Ã£ chá»n (thay vÃ¬ categories tá»« DB)
            List<com.proj.webprojrct.product.dto.ProductSeriesDto> availableSeries;
            if (brand != null && !brand.isEmpty()) {
                // CÃ³ chá»n brand â†’ Tá»± Ä‘á»™ng generate series tá»« products cá»§a cÃ¡c brand Ä‘Ã£ chá»n
                availableSeries = generateSeriesByBrands(allProducts, brand);
            } else {
                // ChÆ°a chá»n brand â†’ KhÃ´ng hiá»‡n series (Ä‘á»ƒ user chá»n brand trÆ°á»›c)
                availableSeries = java.util.Collections.emptyList();
            }

            model.addAttribute("series", availableSeries);
            model.addAttribute("brands", productService.getAllBrands());
            model.addAttribute("selectedCategories", category != null ? category : java.util.Collections.emptyList());
            model.addAttribute("selectedBrands", brand != null ? brand : java.util.Collections.emptyList());
            model.addAttribute("selectedSeries", series != null ? series : java.util.Collections.emptyList()); // ThÃªm selected series
            model.addAttribute("searchName", name != null ? name : "");
            model.addAttribute("selectedSort", sort);
            model.addAttribute("selectedLimit", limit);
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("totalProducts", totalProducts);
            model.addAttribute("startIndex", startIndex + 1);
            model.addAttribute("endIndex", endIndex);
        } catch (Exception e) {
            log.error("Lỗi khi tải dữ liệu shop", e);
            model.addAttribute("error", "Không thể tải dữ liệu. Vui lòng thử lại sau.");
        }
        return "shop";
    }

    // //admin
    // @GetMapping("/products")
    // public String products(Model model) {
    //     // CÃ³ thá»ƒ thÃªm logic load products vÃ o model náº¿u cáº§n
    //     return "product_list";
    // }
    //user
    @GetMapping("/product/{id:\\d+}")
    public String productDetail(@PathVariable Long id, Model model) {
        ProductResponse product = productService.getById(id);
        model.addAttribute("product", product);

        // Sáº£n pháº©m liÃªn quan: cÃ¹ng category
        List<ProductResponse> relatedProducts = new java.util.ArrayList<>();
        if (product.getCategory() != null) {
            relatedProducts = productService.getByCategoryId(product.getCategory().getId());
            // Loáº¡i bá» chÃ­nh sáº£n pháº©m Ä‘ang xem
            relatedProducts.removeIf(p -> p.getId().equals(product.getId()));
        }
        model.addAttribute("relatedProducts", relatedProducts);

        // Sáº£n pháº©m cÃ¹ng dÃ²ng (cÃ¹ng series, khÃ¡c model variant)
        // VÃ­ dá»¥: iPhone 15 â†’ hiá»‡n iPhone 15 Pro, iPhone 15 Pro Max, iPhone 15 Plus
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

                // CÃ¹ng brand vÃ  cÃ¹ng series
                if (product.getBrand().equals(p.getBrand())) {
                    String productSeries = extractSeriesName(p.getName());
                    if (currentSeries.equals(productSeries)) {
                        versionProducts.add(p);
                    }
                }
            }
        }

        List<ProductResponse> sameProducts = new java.util.ArrayList<>();
        // Sáº£n pháº©m cÃ¹ng thÆ°Æ¡ng hiá»‡u
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
            log.error("Lỗi khi tải dữ liệu khuyến mãi", e);
            model.addAttribute("error", "Không thể tải dữ liệu khuyến mãi. Vui lòng thử lại sau.");
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
     * Titan Äen" â†’ "iPhone 15" Example: "Samsung Galaxy S24 Ultra 512GB" â†’
     * "Galaxy S24" Example: "Xiaomi 14 Ultra 16GB/512GB" â†’ "Xiaomi 14"
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
        // Example: "ASUS ROG Phone 8" â†’ "ASUS ROG Phone 8"
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
     * Láº¥y danh sÃ¡ch category con (subcategories) tá»« database dá»±a theo brands Ä‘Ã£
     * chá»n Tráº£ vá» dÆ°á»›i dáº¡ng ProductSeriesDto Ä‘á»ƒ tÆ°Æ¡ng thÃ­ch vá»›i code hiá»‡n táº¡i
     *
     * @param products Danh sÃ¡ch sáº£n pháº©m Ä‘á»ƒ Ä‘áº¿m
     * @param brands Danh sÃ¡ch brands Ä‘Ã£ chá»n
     * @return Danh sÃ¡ch ProductSeriesDto (seriesName = category name, brand =
     * parent category name)
     */
    private List<com.proj.webprojrct.product.dto.ProductSeriesDto> generateSeriesByBrands(
            List<ProductResponse> products,
            List<String> brands) {

        List<com.proj.webprojrct.product.dto.ProductSeriesDto> result = new java.util.ArrayList<>();

        // Láº¥y táº¥t cáº£ categories tá»« database
        List<com.proj.webprojrct.category.dto.CategoryDto> allCategories = categoryService.getAll();

        // Táº¡o map: category parent name -> category parent ID
        java.util.Map<String, Long> brandToCategoryId = new java.util.HashMap<>();
        for (com.proj.webprojrct.category.dto.CategoryDto cat : allCategories) {
            if (cat.getParentId() == null && brands.contains(cat.getName())) {
                brandToCategoryId.put(cat.getName(), cat.getId());
            }
        }

        // Táº¡o map: category parent ID -> category parent name
        java.util.Map<Long, String> categoryIdToBrand = new java.util.HashMap<>();
        for (java.util.Map.Entry<String, Long> entry : brandToCategoryId.entrySet()) {
            categoryIdToBrand.put(entry.getValue(), entry.getKey());
        }

        // Láº¥y táº¥t cáº£ category con cá»§a cÃ¡c brands Ä‘Ã£ chá»n
        for (com.proj.webprojrct.category.dto.CategoryDto subCat : allCategories) {
            if (subCat.getParentId() != null && brandToCategoryId.containsValue(subCat.getParentId())) {
                // Äáº¿m sá»‘ lÆ°á»£ng sáº£n pháº©m thuá»™c category con nÃ y
                long productCount = products.stream()
                        .filter(p -> p.getCategory() != null
                        && p.getCategory().getId().equals(subCat.getId()))
                        .count();

                // Láº¥y tÃªn brand (category cha)
                String brandName = categoryIdToBrand.getOrDefault(subCat.getParentId(), "Unknown");

                // Táº¡o ProductSeriesDto
                com.proj.webprojrct.product.dto.ProductSeriesDto seriesDto
                        = new com.proj.webprojrct.product.dto.ProductSeriesDto(
                                subCat.getName(), // seriesName = tÃªn category con
                                brandName, // brand = tÃªn category cha
                                Long.valueOf(productCount) // sá»‘ lÆ°á»£ng sáº£n pháº©m
                        );

                result.add(seriesDto);
            }
        }

        return result;
    }
}
