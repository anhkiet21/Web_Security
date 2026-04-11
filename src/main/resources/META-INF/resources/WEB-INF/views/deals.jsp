<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
< lang="vi">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Khuyến mãi - CellPhoneStore</title>
    
    <style>
        /* Flash Sale Countdown Styling */
        .hot-deal-countdown {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 20px;
            margin: 30px 0;
            padding: 0;
        }

        .hot-deal-countdown li {
            list-style: none;
            display: flex;
            align-items: center;
        }

        .hot-deal-countdown li > div {
            background: linear-gradient(135deg, #fff 0%, #f8f9fa 100%);
            border-radius: 15px;
            padding: 25px 20px;
            width: 100px;
            height: 100px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            position: relative;
            overflow: hidden;
            animation: pulse 2s ease-in-out infinite;
            border: 3px solid rgba(255, 255, 255, 0.3);
        }

        .hot-deal-countdown li > div::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(
                45deg,
                transparent,
                rgba(215, 0, 24, 0.1),
                transparent
            );
            transform: rotate(45deg);
            animation: shine 3s infinite;
        }

        .hot-deal-countdown h3 {
            font-size: 42px;
            font-weight: 900;
            color: #cc0000;
            margin: 0;
            line-height: 1;
            text-shadow: 0 3px 10px rgba(204, 0, 0, 0.5);
            font-family: 'Arial Black', sans-serif;
            position: relative;
            z-index: 1;
        }

        .hot-deal-countdown span {
            display: block;
            color: #666;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-top: 5px;
            font-weight: 600;
            position: relative;
            z-index: 1;
        }

        /* Animations */
        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            }
            50% {
                transform: scale(1.05);
                box-shadow: 0 15px 40px rgba(215, 0, 24, 0.4);
            }
        }

        @keyframes shine {
            0% {
                left: -50%;
                top: -50%;
            }
            100% {
                left: 150%;
                top: 150%;
            }
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-10px);
            }
        }

        /* Flash Sale Section */
        .hot-deal {
            text-align: center;
            padding: 60px 30px;
            position: relative;
            overflow: hidden;
            animation: fadeInUp 1s ease-out;
        }

        .hot-deal::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.15) 0%, transparent 70%);
            animation: rotate 20s linear infinite;
        }

        @keyframes rotate {
            0% {
                transform: rotate(0deg);
            }
            100% {
                transform: rotate(360deg);
            }
        }

        .hot-deal h2 {
            color: #fff;
            font-size: 48px;
            font-weight: 900;
            text-shadow: 0 5px 20px rgba(0, 0, 0, 0.4);
            margin: 20px 0;
            position: relative;
            z-index: 1;
            animation: fadeInUp 1s ease-out 0.2s both, float 3s ease-in-out infinite;
        }

        .hot-deal p {
            color: rgba(255, 255, 255, 0.95);
            font-size: 24px;
            font-weight: 600;
            margin: 20px 0 30px;
            position: relative;
            z-index: 1;
            animation: fadeInUp 1s ease-out 0.4s both;
        }

        /* Deal Badge Animation */
        @keyframes badgePulse {
            0%, 100% {
                transform: scale(1) rotate(-10deg);
            }
            50% {
                transform: scale(1.1) rotate(-10deg);
            }
        }

        .shop-img > div {
            animation: badgePulse 2s ease-in-out infinite;
        }

        /* Category Card Hover Effect */
        .shop {
            transition: all 0.3s ease;
        }

        .shop:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.2) !important;
        }

        .cta-btn {
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .cta-btn::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.3);
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }

        .cta-btn:hover::before {
            width: 300px;
            height: 300px;
        }

        .cta-btn:hover {
            transform: scale(1.05);
            box-shadow: 0 10px 25px rgba(215, 0, 24, 0.4);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .hot-deal-countdown {
                gap: 10px;
            }

            .hot-deal-countdown li > div {
                padding: 15px;
                min-width: 70px;
            }

            .hot-deal-countdown h3 {
                font-size: 32px;
            }

            .hot-deal h2 {
                font-size: 32px;
            }

            .hot-deal p {
                font-size: 18px;
            }
        }
    </style>
</head>

<body>
    <!-- HOT DEAL HERO SECTION -->
    <div id="hot-deal" class="section" style="background: linear-gradient(135deg, #d70018 0%, #ff6b6b 100%);">
        <div class="container">
            <div class="row">
                <div class="col-md-12">
                    <div class="hot-deal">
                
                        <h2 class="text-uppercase">🔥 FLASH SALE 🔥</h2>
                        <p>Giảm giá khủng cho các khách hàng!</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- /HOT DEAL HERO SECTION -->

    <!-- DEALS CATEGORIES (render by brand) -->
    <div class="section">
        <div class="container">
            <div class="row">
                <div class="col-md-12">
                    <div class="section-title">
                        <h3 class="title">🔥 Danh mục khuyến mãi</h3>
                    </div>
                </div>
            </div>
            <div class="row">
                <%-- Build a list of unique brands (group by first token) from the products model so we render one card per brand --%>
                <%
                    java.util.List productsList = (java.util.List) request.getAttribute("products");
                    java.util.Map<String, String> brandMap = new java.util.LinkedHashMap<>(); // key: canonical (lower first token), value: display
                    if (productsList != null) {
                        for (Object obj : productsList) {
                            try {
                                // Try to call getBrand() method
                                java.lang.reflect.Method m = obj.getClass().getMethod("getBrand");
                                Object b = m.invoke(obj);
                                if (b != null) {
                                    String brand = b.toString().trim();
                                    if (brand.length() == 0) continue;
                                    String firstToken = brand.split("\\s+")[0];
                                    String key = firstToken.toLowerCase(java.util.Locale.ROOT);
                                    if (!brandMap.containsKey(key)) {
                                        brandMap.put(key, firstToken);
                                    }
                                }
                            } catch (Exception e) {
                                // ignore reflection errors for safety
                            }
                        }
                    }
                    java.util.List dealBrands = new java.util.ArrayList<>(brandMap.values());
                    request.setAttribute("dealBrands", dealBrands);
                %>

                <c:forEach items="${dealBrands}" var="brand" varStatus="status">
                    <div class="col-md-4 col-xs-6" style="margin-bottom: 30px;">
                        <div class="shop" style="position: relative; overflow: hidden; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.1);">
                            <div class="shop-img" style="position: relative;">
                                <c:choose>
                                    <c:when test="${status.index == 0}">
                                        <img src="${pageContext.request.contextPath}/uploads/products/banersamsung.jpg"
                                            alt="${brand}" style="width: 100%; height: 250px; object-fit: cover;">
                                    </c:when>
                                    <c:when test="${status.index == 1}">
                                        <img src="${pageContext.request.contextPath}/uploads/products/banerapple.jpg"
                                            alt="${brand}" style="width: 100%; height: 250px; object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/uploads/products/banerxiaomi.jpg"
                                            alt="${brand}" style="width: 100%; height: 250px; object-fit: cover;">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="shop-body" style="text-align: center; padding: 20px;">
                                <h3 style="color: #333; margin-bottom: 15px;">${brand}<br><span style="color: #d70018;">Hot Deals</span></h3>
                                <a href="javascript:void(0)" onclick="filterDealsByCategory('${brand}')"
                                   class="cta-btn" style="background: linear-gradient(45deg, #d70018, #ff6b6b); border: none; padding: 12px 25px; border-radius: 25px; cursor: pointer;">
                                   Xem ngay <i class="fa fa-arrow-circle-right"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
    <!-- /DEALS CATEGORIES -->

    <!-- FLASH DEALS PRODUCTS -->
    <div id="deals-products" class="section" style="background: #f8f9fa;">
        <div class="container">
            <div class="row">
                <div class="col-md-12">
                    <div class="section-title">
                        <h3 class="title" id="deals-section-title">⚡ Flash Sale - Giá sốc mỗi giờ</h3>
                        <p style="color: #666;">Cơ hội cuối cùng để sở hữu sản phẩm với giá không thể rẻ hơn!</p>
                        <div style="margin-top: 15px;">
                            <button class="btn btn-outline-secondary btn-sm" onclick="showAllDeals()" style="margin-right: 10px;">
                                <i class="fa fa-th"></i> Tất cả
                            </button>
                            <c:forEach items="${dealBrands}" var="brand">
                                <button class="btn btn-outline-secondary btn-sm category-filter-btn" onclick="filterDealsByCategory('${brand}')" style="margin-right: 10px;">
                                    ${brand}
                                </button>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Products grid -->
            <div class="row" id="products-container">
                <c:forEach items="${products}" var="product" varStatus="status">
                    <div class="col-md-3 col-xs-6 product-item" 
                         data-category="${product.category != null ? product.category.name : ''}"
                         data-brand="${product.brand}"
                         style="margin-bottom: 30px;">
                        <div class="product" style="border-radius: 10px; overflow: hidden; box-shadow: 0 5px 15px rgba(0,0,0,0.1); transition: transform 0.3s ease; background: white;">
                            <div class="product-img" style="position: relative;">
                                <c:choose>
                                    <c:when test="${not empty product.imageUrl}">
                                        <img src="${pageContext.request.contextPath}${product.imageUrl}"
                                            alt="${product.name}"
                                            style="max-height: 250px; object-fit: contain; width: 100%;">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/img/product-placeholder.png"
                                            alt="${product.name}"
                                            style="max-height: 250px; object-fit: contain; width: 100%;">
                                    </c:otherwise>
                                </c:choose>
                                
                                <!-- Deal labels -->
                                <div class="product-label">
                                    <c:if test="${product.dealPercentage != null && product.dealPercentage > 0}">
                                        <span class="sale" style="background:#c50b12;color:#fff;padding:4px 6px;border-radius:4px;border:1px solid rgba(0,0,0,0.06);">-${product.dealPercentage}%</span>
                                        <span class="new" style="background:#ff3b5c;color:#fff;padding:4px 6px;border-radius:4px;border:1px solid rgba(0,0,0,0.06);margin-left:6px;">HOT</span>
                                    </c:if>
                                </div>
                                
                                <!-- Flash sale countdown for first few products -->
                                
                            </div>
                            
                            <div class="product-body">
                                <p class="product-category">
                                    ${product.brand}
                                </p>
                                <h3 class="product-name">
                                    <a href="${pageContext.request.contextPath}/product/${product.id}">
                                       ${product.name}
                                    </a>
                                </h3>
                                
                                <!-- Price with original and discounted -->
                                <h4 class="product-price">
                                    <c:if test="${product.dealPercentage != null && product.dealPercentage > 0}">
                                        <c:set var="discountedPrice" value="${product.price * (100 - product.dealPercentage) / 100}"/>
                                        <c:set var="savedAmount" value="${product.price - discountedPrice}"/>
                                        <span style="color: #d70018; font-size: 18px; font-weight: bold;">
                                            <fmt:formatNumber value="${discountedPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                        </span>
                                        <br>
                                        <del style="color: #999; font-size: 14px;">
                                            <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                        </del>
                                        <span style="color: #ff4444; font-size: 12px; margin-left: 5px; font-weight: bold; background: #ffe8e8; padding: 1px 5px; border-radius: 3px;">
                                            -${product.dealPercentage}%
                                        </span>
                                        <br>
                                        <span style="color: #28a745; font-size: 12px; font-weight: bold; background: #e8f5e8; padding: 1px 5px; border-radius: 3px;">
                                            Tiết kiệm <fmt:formatNumber value="${savedAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                        </span>
                                    </c:if>
                                </h4>
                                
                                <div class="product-rating" id="rating-deal-${status.index}-${product.id}">
														<i class="fa fa-star-o"></i>
														<i class="fa fa-star-o"></i>
														<i class="fa fa-star-o"></i>
														<i class="fa fa-star-o"></i>
														<i class="fa fa-star-o"></i>
													</div>
                                
                                <div class="product-btns">
                                    <button class="add-to-wishlist" data-product-id="${product.id}"
                                        onclick="toggleFavorite(${product.id}, this)">
                                        <i class="fa fa-heart-o"></i>
                                        <span class="tooltipp">Yêu thích</span>
                                    </button>
                                    <a href="${pageContext.request.contextPath}/product/${product.id}"
                                       class="quick-view">
                                        <i class="fa fa-eye"></i>
                                        <span class="tooltipp">Xem chi tiết</span>
                                    </a>
                                </div>
                            </div>
                            
                            <div class="add-to-cart">
                                <c:choose>
                                    <c:when test="${product.stock > 0}">
                                        <button class="add-to-cart-btn" data-product-id="${product.id}"
                                            onclick="addToCart(${product.id})">
                                            <i class="fa fa-shopping-cart"></i> THÊM VÀO GIỎ
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="add-to-cart-btn" disabled>
                                            <i class="fa fa-ban"></i> HẾT HÀNG
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
    <!-- /FLASH DEALS PRODUCTS -->

    <!-- NEWSLETTER -->
    <div id="newsletter" class="section">
        <div class="container">
            <div class="row">
                <div class="col-md-12">
                    <div class="newsletter">
                        <p>Đăng ký nhận thông báo <strong>KHUYẾN MÃI MỚI</strong></p>
                        <form>
                            <input class="input" type="email" placeholder="Nhập email để nhận ưu đãi đặc biệt">
                            <button class="newsletter-btn"><i class="fa fa-envelope"></i> Đăng ký ngay</button>
                        </form>
                        <ul class="newsletter-follow">
                            <li><a href="https://www.facebook.com/nhan.le.24813" target="_blank"><i class="fa fa-facebook"></i></a></li>
                            <li><a href="https://x.com/Apple" target="_blank"><i class="fa fa-twitter"></i></a></li>
                            <li><a href="https://www.instagram.com/apple/" target="_blank"><i class="fa fa-instagram"></i></a></li>
                            <li><a href="https://www.pinterest.com/apple/" target="_blank"><i class="fa fa-pinterest"></i></a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- /NEWSLETTER -->

    <script>
        <%
            org.springframework.security.core.Authentication auth = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
            boolean isAuthenticated = auth != null && auth.isAuthenticated() && !(auth instanceof org.springframework.security.authentication.AnonymousAuthenticationToken);
        %>
        var IS_LOGGED_IN = <%= isAuthenticated %>;

        // Synchronized 24-hour countdown system
        function updateCountdown() {
            // Get or create countdown start time
            let startTime = localStorage.getItem('flashSaleStartTime');
            if (!startTime) {
                startTime = new Date().getTime();
                localStorage.setItem('flashSaleStartTime', startTime);
            } else {
                startTime = parseInt(startTime);
            }

            // Calculate 24-hour countdown
            const duration = 24 * 60 * 60 * 1000; // 24 hours in milliseconds
            const endTime = startTime + duration;

            const timer = setInterval(function() {
                const currentTime = new Date().getTime();
                const timeLeft = endTime - currentTime;

                if (timeLeft <= 0) {
                    // Reset countdown when it reaches 0
                    const newStartTime = new Date().getTime();
                    localStorage.setItem('flashSaleStartTime', newStartTime);
                    clearInterval(timer);
                    updateCountdown(); // Restart countdown
                    return;
                }

                const days = Math.floor(timeLeft / (1000 * 60 * 60 * 24));
                const hours = Math.floor((timeLeft % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                const minutes = Math.floor((timeLeft % (1000 * 60 * 60)) / (1000 * 60));
                const seconds = Math.floor((timeLeft % (1000 * 60)) / 1000);

                // Update main countdown
                const daysEl = document.getElementById("days");
                const hoursEl = document.getElementById("hours");
                const minutesEl = document.getElementById("minutes");
                const secondsEl = document.getElementById("seconds");

                if (daysEl) daysEl.innerHTML = days.toString().padStart(2, '0');
                if (hoursEl) hoursEl.innerHTML = hours.toString().padStart(2, '0');
                if (minutesEl) minutesEl.innerHTML = minutes.toString().padStart(2, '0');
                if (secondsEl) secondsEl.innerHTML = seconds.toString().padStart(2, '0');

                // Update flash countdown for products
                updateFlashCountdown(hours, minutes, seconds);
            }, 1000);
        }

        // Flash sale countdown for individual products (synchronized)
        

        // Cart and favorite functions (same as in shop.jsp)
        function addToCart(productId) {
            if (!IS_LOGGED_IN) {
                alert('Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng!');
                window.location.href = '${pageContext.request.contextPath}/login';
                return;
            }
            
            fetch('${pageContext.request.contextPath}/api/cart/add', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                credentials: 'include',
                body: JSON.stringify({ productId: productId, quantity: 1 })
            })
            .then(response => {
                if (response.ok) return response.json();
                else if (response.status === 401 || response.status === 403) throw new Error('Unauthorized');
                else throw new Error('Có lỗi xảy ra');
            })
            .then(data => {
                alert('🎉 Đã thêm sản phẩm vào giỏ hàng với giá ưu đãi!');
                if (typeof updateGlobalCartCount === 'function') updateGlobalCartCount();
            })
            .catch(error => {
                if (error.message === 'Unauthorized') {
                    alert('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại!');
                    window.location.href = '${pageContext.request.contextPath}/login';
                } else {
                    alert('Có lỗi: ' + error.message);
                }
            });
        }

        function toggleFavorite(productId, button) {
            if (!IS_LOGGED_IN) {
                alert('Vui lòng đăng nhập để thêm vào danh sách yêu thích!');
                window.location.href = '${pageContext.request.contextPath}/login';
                return;
            }
            
            var icon = button.querySelector('i');
            var isFavorited = icon.classList.contains('fa-heart');
            var url = isFavorited ? '${pageContext.request.contextPath}/api/favorite/remove/' + productId : '${pageContext.request.contextPath}/api/favorite/add';
            var method = isFavorited ? 'DELETE' : 'POST';
            var body = isFavorited ? null : JSON.stringify({ productId: productId });

            fetch(url, {
                method: method,
                credentials: 'include',
                headers: { 'Content-Type': 'application/json' },
                body: body
            })
            .then(response => {
                if (response.ok) return response.json();
                else if (response.status === 401 || response.status === 403) throw new Error('Unauthorized');
                else throw new Error('Có lỗi xảy ra');
            })
            .then(data => {
                if (isFavorited) {
                    icon.classList.remove('fa-heart');
                    icon.classList.add('fa-heart-o');
                    button.style.color = '';
                } else {
                    icon.classList.remove('fa-heart-o');
                    icon.classList.add('fa-heart');
                    button.style.color = '#d70018';
                }
                if (typeof updateGlobalWishlistCount === 'function') updateGlobalWishlistCount();
            })
            .catch(error => {
                if (error.message === 'Unauthorized') {
                    window.location.href = '${pageContext.request.contextPath}/login';
                } else {
                    alert('Có lỗi: ' + error.message);
                }
            });
        }

        // Load favorite states
        function loadFavoriteStates() {
            if (!IS_LOGGED_IN) return;
            
            fetch('${pageContext.request.contextPath}/api/favorite', {
                method: 'GET',
                credentials: 'include',
                headers: { 'Content-Type': 'application/json' }
            })
            .then(response => response.ok ? response.json() : [])
            .then(favorites => {
                favorites.forEach(function (favorite) {
                    var buttons = document.querySelectorAll('.add-to-wishlist[data-product-id="' + favorite.productId + '"]');
                    buttons.forEach(function (button) {
                        var icon = button.querySelector('i');
                        icon.classList.remove('fa-heart-o');
                        icon.classList.add('fa-heart');
                        button.style.color = '#d70018';
                    });
                });
            })
            .catch(error => console.error('Lỗi khi tải trạng thái yêu thích:', error));
        }

        // Hover effects for products
        function addHoverEffects() {
            const products = document.querySelectorAll('.product');
            products.forEach(product => {
                product.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-5px)';
                    this.style.boxShadow = '0 10px 25px rgba(215,0,24,0.2)';
                });
                
                product.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                    this.style.boxShadow = '0 5px 15px rgba(0,0,0,0.1)';
                });
            });
        }

        // Initialize everything when page loads
        document.addEventListener('DOMContentLoaded', function() {
            updateCountdown(); // Countdown sẽ tự động gọi updateFlashCountdown với tham số đúng
            addHoverEffects();
            if (IS_LOGGED_IN) loadFavoriteStates();
            loadAllProductRatings(); // Load ratings cho tất cả sản phẩm
        });

        // Filter products by category/brand (brand matching uses startsWith on normalized first token)
        function filterDealsByCategory(categoryName) {
            const target = (categoryName || '').trim().toLowerCase();
            const products = document.querySelectorAll('.product-item');
            let visibleCount = 0;

            products.forEach(product => {
                const productCategory = (product.getAttribute('data-category') || '').trim().toLowerCase();
                const productBrand = (product.getAttribute('data-brand') || '').trim().toLowerCase();

                // Normalize productBrand by taking its first token so "Nokia 2" -> "nokia"
                const productBrandFirst = productBrand.split(/\s+/)[0];

                // Show if category matches exactly OR brand first token startsWith target
                if (productCategory === target || productBrandFirst.startsWith(target)) {
                    product.style.display = 'block';
                    visibleCount++;
                } else {
                    product.style.display = 'none';
                }
            });

            // Update section title
            const title = document.getElementById('deals-section-title');
            if (title) {
                title.innerHTML = '🎯 ' + categoryName + ' Hot Deals';
            }

            // Scroll to products section
            document.getElementById('deals-products').scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
        
        function showAllDeals() {
            const products = document.querySelectorAll('.product-item');
            products.forEach(product => {
                product.style.display = 'block';
            });
            
            // Reset section title
            const title = document.getElementById('deals-section-title');
            if (title) {
                title.innerHTML = '⚡ Flash Sale - Giá sốc mỗi giờ';
            }
        }

        // ========== RATING FUNCTIONS ==========

        // Load rating cho tất cả sản phẩm hiển thị trên trang
        function loadAllProductRatings() {
            // Lấy tất cả product IDs từ các thẻ rating
            const ratingElements = document.querySelectorAll('[id^="rating-deal-"]');
            
            ratingElements.forEach(element => {
                // Extract productId from pattern: rating-deal-{index}-{productId}
                const parts = element.id.split('-');
                const productId = parts[parts.length - 1]; // Lấy phần cuối cùng là productId
                loadProductRating(productId, element.id);
            });
        }

        // Load rating cho một sản phẩm cụ thể
        async function loadProductRating(productId, elementId) {
            try {
                const response = await fetch('${pageContext.request.contextPath}/api/reviews/product/' + productId + '/stats');
                
                if (!response.ok) {
                    return; // Không có rating, giữ nguyên 5 sao rỗng
                }

                const stats = await response.json();
                
                // Update rating stars cho sản phẩm này
                displayProductStars(elementId, stats.averageRating);
            } catch (error) {
                // Không có rating, giữ nguyên 5 sao rỗng
            }
        }

        // Hiển thị stars dựa trên rating value
        function displayProductStars(elementId, rating) {
            const starsContainer = document.getElementById(elementId);
            if (!starsContainer) {
                return;
            }

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
    </script>

    <style>
        /* Additional styles for deals page */
        .product {
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
        }
        
        .product:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        }
        
        .product-img {
            position: relative;
            overflow: hidden;
        }
        
        .product-img img {
            transition: transform 0.6s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        .product:hover .product-img img {
            transform: scale(1.08);
        }
        
        .hot-deal h2 {
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        
        
        .product-label span {
            animation: pulse 2s infinite;
            color: #fff !important;
            font-weight: 700;
            padding: 4px 6px;
            border-radius: 4px;
            box-shadow: 0 1px 0 rgba(0,0,0,0.08);
            border: none;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        
        .cta-btn:hover {
            transform: scale(1.05);
            transition: all 0.3s ease;
        }
        
        .category-filter-btn {
            border: 2px solid #d70018 !important;
            color: #d70018 !important;
            background: white !important;
            transition: all 0.3s ease;
        }
        
        .category-filter-btn:hover {
            background: #d70018 !important;
            color: white !important;
        }
        
        @media (max-width: 768px) {
            .hot-deal-countdown {
                justify-content: center;
            }
            
            .hot-deal-countdown li {
                margin: 0 10px;
            }
        }
    </style>

</body>