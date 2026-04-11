package com.proj.webprojrct.product.entity;

import com.proj.webprojrct.category.entity.Category;
import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "products")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;
    @Column(nullable = false)
    private String brand;

    @Column(precision = 12, scale = 2, nullable = false)
    private BigDecimal price;

    @Column(nullable = false)
    private Integer stock;

    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    private String imageUrl;

    @Column(name = "on_deal")
    @Builder.Default
    private Boolean onDeal = false;

    @Column(name = "deal_percentage")
    private Integer dealPercentage;

    @Column(name = "is_active")
    @Builder.Default
    private Boolean isActive = true;

    // --- Specs ---
    private String screenSize;
    private String displayTech;
    private String rearCamera;
    private String frontCamera;
    private String chipset;
    private String nfcSupport;
    private String ram;
    private String storage;
    private String battery;
    private String simType;
    private String os;
    private String resolution;
    private String displayFeatures;
    private String cpuSpecs;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private Category category;

    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<ProductSpec> specifications = new ArrayList<>();

    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<ProductImage> images = new ArrayList<>();
}
