<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Sản phẩm yêu thích - CellPhoneStore</title>
            <style>
                /* Đảm bảo width đồng nhất cho tất cả product cards */
                #wishlistContainer {
                    display: flex;
                    flex-wrap: wrap;
                }

                #wishlistContainer>[class*="col-"] {
                    display: flex;
                }

                /* Hover animation cho product cards */
                .product {
                    transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
                    position: relative;
                    cursor: pointer;
                    display: flex;
                    flex-direction: column;
                    height: 100%;
                    min-height: 500px;
                    width: 100%;
                }

                .product:hover {
                    transform: translateY(-10px);
                    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
                }

                .product-img {
                    position: relative;
                    overflow: hidden;
                    height: 250px;
                    width: 100%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }

                .product-img img {
                    transition: transform 0.6s cubic-bezier(0.4, 0, 0.2, 1);
                    max-width: 100%;
                    max-height: 100%;
                }

                .product:hover .product-img img {
                    transform: scale(1.08);
                }

                .product-body {
                    flex: 1;
                    display: flex;
                    flex-direction: column;
                    width: 100%;
                }

                .product-name {
                    min-height: 48px;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    display: -webkit-box;
                    -webkit-line-clamp: 2;
                    -webkit-box-orient: vertical;
                }

                .product-price {
                    min-height: 80px;
                }
            </style>
        </head>

        <body>

            <!-- BREADCRUMB -->
            <div id="breadcrumb" class="section">
                <div class="container">
                    <div class="row">
                        <div class="col-md-12">
                            <ul class="breadcrumb-tree">
                                <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                                <li class="active">Sản phẩm yêu thích</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /BREADCRUMB -->

            <!-- SECTION -->
            <div class="section">
                <div class="container">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="section-title">
                                <h3 class="title"><i class="fa fa-heart"></i> Sản phẩm yêu thích của bạn</h3>
                            </div>
                        </div>
                    </div>

                    <!-- Wishlist Items -->
                    <div class="row" id="wishlistContainer">
                        <!-- Items will be loaded by JavaScript -->
                        <div class="col-md-12 text-center" style="padding: 40px 0;">
                            <i class="fa fa-spinner fa-spin" style="font-size: 48px; color: #D10024;"></i>
                            <p style="margin-top: 20px; color: #999;">Đang tải...</p>
                        </div>
                    </div>
                    <!-- /Wishlist Items -->

                    <!-- Empty State -->
                    <div class="row" id="emptyWishlist" style="display: none;">
                        <div class="col-md-12">
                            <div
                                style="text-align: center; padding: 80px 20px; background: #f9f9f9; border-radius: 8px;">
                                <i class="fa fa-heart-o" style="font-size: 80px; color: #ddd; margin-bottom: 20px;"></i>
                                <h3 style="color: #666; margin-bottom: 10px;">Chưa có sản phẩm yêu thích</h3>
                                <p style="color: #999; margin-bottom: 30px;">Hãy thêm sản phẩm yêu thích để theo dõi!
                                </p>
                                <a href="${pageContext.request.contextPath}/shop" class="primary-btn">Khám phá sản
                                    phẩm</a>
                            </div>
                        </div>
                    </div>
                    <!-- /Empty State -->
                </div>
            </div>
            <!-- /SECTION -->

            <script>
                const ctx = '${pageContext.request.contextPath}';
                let wishlistData = [];

                // Load wishlist on page load
                window.addEventListener('DOMContentLoaded', function () {
                    loadWishlist();
                });

                function loadWishlist() {
                    fetch(ctx + '/api/favorite', {
                        method: 'GET',
                        credentials: 'include',
                        headers: {
                            'Content-Type': 'application/json'
                        }
                    })
                        .then(function (response) {
                            if (!response.ok) {
                                if (response.status === 401 || response.status === 403) {
                                    window.location.href = ctx + '/login';
                                    throw new Error('Unauthorized');
                                }
                                throw new Error('Không thể tải danh sách');
                            }
                            return response.json();
                        })
                        .then(function (data) {
                            wishlistData = data;
                            renderWishlist();
                        })
                        .catch(function (error) {
                            console.error('Error loading wishlist:', error);
                            if (!error.message.includes('Unauthorized')) {
                                document.getElementById('wishlistContainer').innerHTML =
                                    '<div class="col-md-12 text-center" style="padding: 40px 0;">' +
                                    '<p style="color: #d70018;">Có lỗi xảy ra khi tải danh sách yêu thích</p>' +
                                    '</div>';
                            }
                        });
                }

                function renderWishlist() {
                    const container = document.getElementById('wishlistContainer');
                    const emptyState = document.getElementById('emptyWishlist');

                    if (!wishlistData || wishlistData.length === 0) {
                        container.style.display = 'none';
                        emptyState.style.display = 'block';
                        return;
                    }

                    container.style.display = 'flex';
                    emptyState.style.display = 'none';

                    let html = '';
                    wishlistData.forEach(function (item) {
                        // Image URL
                        let imgSrc = ctx + '/img/product-placeholder.png';
                        if (item.productImageUrl && item.productImageUrl.trim() !== '') {
                            imgSrc = ctx + item.productImageUrl;
                        }

                        // Deal labels
                        let dealLabels = '';
                        if (item.dealPercentage && item.dealPercentage > 0) {
                            dealLabels = '<div class="product-label" style="position:absolute;top:10px;right:10px;z-index:2;">' +
                                '<span class="sale" style="background:#c50b12;color:#fff;padding:4px 6px;border-radius:4px;font-weight:700;box-shadow:0 1px 0 rgba(0,0,0,0.08);border:none;animation:pulse 2s infinite;">-' + item.dealPercentage + '%</span>' +
                                '<span class="new" style="background:#ff3b5c;color:#fff;padding:4px 6px;border-radius:4px;font-weight:700;box-shadow:0 1px 0 rgba(0,0,0,0.08);border:none;animation:pulse 2s infinite;margin-left:6px;">HOT</span>' +
                                '</div>';
                        }

                        // Stock/Active label
                        let statusLabel = '';
                        if (item.productIsActive === false) {
                            statusLabel = '<div class="product-label">' +
                                '<span class="sale" style="background:#ff3b5c;color:#fff;padding:4px 6px;border-radius:4px;border:1px solid rgba(0,0,0,0.06);margin-left:6px;">NGỪNG KINH DOANH</span>' +
                                '</div>';
                        } else if (item.productStock === 0) {
                            statusLabel = '<div class="product-label">' +
                                '<span class="sale">HẾT HÀNG</span>' +
                                '</div>';
                        }

                        // Price calculation
                        let priceHtml = '';
                        if (item.dealPercentage && item.dealPercentage > 0) {
                            const discountedPrice = item.productPrice * (100 - item.dealPercentage) / 100;
                            const savedAmount = item.productPrice - discountedPrice;
                            priceHtml = '<span style="color: #d70018; font-size: 18px; font-weight: bold;">' +
                                formatPrice(discountedPrice) +
                                '</span><br>' +
                                '<del style="color: #999; font-size: 14px;">' +
                                formatPrice(item.productPrice) +
                                '</del><br>' +
                                '<span style="color: #ff4444; font-size: 12px; font-weight: bold; background: #ffe8e8; padding: 1px 5px; border-radius: 3px;">-' + item.dealPercentage + '%</span><br>' +
                                '<span style="color: #28a745; font-size: 12px; font-weight: bold; background: #e8f5e8; padding: 1px 5px; border-radius: 3px;">Tiết kiệm ' +
                                formatPrice(savedAmount) +
                                '</span>';
                        } else {
                            priceHtml = formatPrice(item.productPrice);
                        }

                        // Add to cart button
                        let addCartBtn = '';
                        if (item.productIsActive === false) {
                            addCartBtn = '<button class="add-to-cart-btn" disabled style="background: #999;">' +
                                '<i class="fa fa-ban"></i> Ngừng kinh doanh' +
                                '</button>';
                        } else if (item.productStock > 0) {
                            addCartBtn = '<button class="add-to-cart-btn" onclick="addToCartFromWishlist(' + item.productId + ')">' +
                                '<i class="fa fa-shopping-cart"></i> Thêm vào giỏ' +
                                '</button>';
                        } else {
                            addCartBtn = '<button class="add-to-cart-btn" disabled style="background: #999;">' +
                                '<i class="fa fa-ban"></i> Hết hàng' +
                                '</button>';
                        }

                        html +=
                            '<div class="col-md-4 col-xs-6">' +
                            '<div class="product">' +
                            '<div class="product-img">' +
                            dealLabels +
                            '<img src="' + imgSrc + '" alt="' + item.productName + '" style="max-height: 250px; object-fit: contain;">' +
                            statusLabel +
                            '</div>' +
                            '<div class="product-body">' +
                            '<p class="product-category">' + (item.productBrand || 'Chưa phân loại') + '</p>' +
                            '<h3 class="product-name">' +
                            '<a href="' + ctx + '/product/' + item.productId + '">' + item.productName + '</a>' +
                            '</h3>' +
                            '<h4 class="product-price">' + priceHtml + '</h4>' +
                            '<div class="product-rating" id="rating-' + item.productId + '">' +
                            '<i class="fa fa-star-o"></i>' +
                            '<i class="fa fa-star-o"></i>' +
                            '<i class="fa fa-star-o"></i>' +
                            '<i class="fa fa-star-o"></i>' +
                            '<i class="fa fa-star-o"></i>' +
                            '</div>' +
                            '<div class="product-btns">' +
                            '<button class="add-to-wishlist" onclick="removeFromWishlist(' + item.productId + ')" style="color: #D10024;">' +
                            '<i class="fa fa-heart"></i>' +
                            '<span class="tooltipp">Xóa khỏi yêu thích</span>' +
                            '</button>' +
                            '<a href="' + ctx + '/product/' + item.productId + '" class="quick-view">' +
                            '<i class="fa fa-eye"></i>' +
                            '<span class="tooltipp">Xem chi tiết</span>' +
                            '</a>' +
                            '</div>' +
                            '</div>' +
                            '<div class="add-to-cart">' +
                            addCartBtn +
                            '</div>' +
                            '</div>' +
                            '</div>';
                    });

                    container.innerHTML = html;

                    // Load rating sau khi render
                    loadProductRatings();
                }

                // Load rating cho tất cả sản phẩm
                function loadProductRatings() {
                    wishlistData.forEach(function (item) {
                        loadProductRating(item.productId);
                    });
                }

                // Load rating cho một sản phẩm cụ thể
                async function loadProductRating(productId) {
                    try {
                        const response = await fetch(ctx + '/api/reviews/product/' + productId + '/stats');

                        if (!response.ok) {
                            console.error('Failed to load rating for product ' + productId);
                            return;
                        }

                        const stats = await response.json();

                        // Update rating stars cho sản phẩm này
                        displayProductStars('rating-' + productId, stats.averageRating);
                    } catch (error) {
                        console.error('Error loading rating for product ' + productId + ':', error);
                    }
                }

                // Hiển thị stars dựa trên rating value
                function displayProductStars(elementId, rating) {
                    const starsContainer = document.getElementById(elementId);
                    if (!starsContainer) return;

                    const fullStars = Math.floor(rating);
                    const hasHalfStar = rating % 1 >= 0.5;
                    let html = '';

                    for (let i = 0; i < 5; i++) {
                        if (i < fullStars) {
                            html += '<i class="fa fa-star"></i>';
                        } else if (i === fullStars && hasHalfStar) {
                            html += '<i class="fa fa-star-half-o"></i>';
                        } else {
                            html += '<i class="fa fa-star-o"></i>';
                        }
                    }

                    starsContainer.innerHTML = html;
                }

                function addToCartFromWishlist(productId) {
                    fetch(ctx + '/api/cart/add', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        credentials: 'include',
                        body: JSON.stringify({
                            productId: productId,
                            quantity: 1
                        })
                    })
                        .then(function (response) {
                            if (response.ok) {
                                return response.json();
                            } else if (response.status === 401 || response.status === 403) {
                                window.location.href = ctx + '/login';
                                throw new Error('Unauthorized');
                            } else {
                                throw new Error('Có lỗi xảy ra');
                            }
                        })
                        .then(function (data) {
                            // Update cart count in header
                            if (typeof updateGlobalCartCount === 'function') {
                                updateGlobalCartCount();
                            }
                        })
                        .catch(function (error) {
                            if (error.message !== 'Unauthorized') {
                                alert('Có lỗi: ' + error.message);
                            }
                        });
                }

                function removeFromWishlist(productId) {
                    fetch(ctx + '/api/favorite/remove/' + productId, {
                        method: 'DELETE',
                        credentials: 'include',
                        headers: {
                            'Content-Type': 'application/json'
                        }
                    })
                        .then(function (response) {
                            if (!response.ok) {
                                throw new Error('Không thể xóa');
                            }
                            return response.json();
                        })
                        .then(function (data) {
                            // Update wishlist count in header
                            if (typeof updateGlobalWishlistCount === 'function') {
                                updateGlobalWishlistCount();
                            }
                            // Reload wishlist
                            loadWishlist();
                        })
                        .catch(function (error) {
                            console.error('Error removing from wishlist:', error);
                            alert('Lỗi khi xóa sản phẩm: ' + error.message);
                        });
                }

                function formatPrice(price) {
                    if (!price) return '0 ₫';
                    return new Intl.NumberFormat('vi-VN').format(price) + ' ₫';
                }
            </script>

        </body>

        </html>