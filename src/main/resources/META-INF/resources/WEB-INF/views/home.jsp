<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="utf-8">
                    <meta http-equiv="X-UA-Compatible" content="IE=edge">
                    <meta name="viewport" content="width=device-width, initial-scale=1">
                    <title>CellPhoneStore - Trang chủ</title>

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

                        .hot-deal-countdown li>div {
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            border-radius: 15px;
                            padding: 25px 20px;
                            width: 100px;
                            height: 100px;
                            display: flex;
                            flex-direction: column;
                            justify-content: center;
                            align-items: center;
                            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
                            position: relative;
                            overflow: hidden;
                            animation: pulse 2s ease-in-out infinite;
                        }

                        .hot-deal-countdown li>div::before {
                            content: '';
                            position: absolute;
                            top: -50%;
                            left: -50%;
                            width: 200%;
                            height: 200%;
                            background: linear-gradient(45deg,
                                    transparent,
                                    rgba(255, 255, 255, 0.1),
                                    transparent);
                            transform: rotate(45deg);
                            animation: shine 3s infinite;
                        }

                        .hot-deal-countdown h3 {
                            font-size: 42px;
                            font-weight: 700;
                            color: #fff;
                            margin: 0;
                            line-height: 1;
                            text-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
                            font-family: 'Arial Black', sans-serif;
                            position: relative;
                            z-index: 1;
                        }

                        .hot-deal-countdown span {
                            display: block;
                            color: rgba(255, 255, 255, 0.9);
                            font-size: 12px;
                            text-transform: uppercase;
                            letter-spacing: 1px;
                            margin-top: 5px;
                            font-weight: 600;
                            position: relative;
                            z-index: 1;
                        }

                        /* Modern Product Section Animations */
                        .section-title {
                            position: relative;
                            overflow: hidden;
                        }

                        .section-title .title {
                            animation: fadeInDown 0.8s ease-out;
                        }

                        .section-tab-nav {
                            animation: fadeIn 1s ease-out 0.3s both;
                        }

                        .section-tab-nav li {
                            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                            position: relative;
                        }

                        .section-tab-nav li a {
                            transition: all 0.3s ease;
                            position: relative;
                            overflow: hidden;
                        }

                        .section-tab-nav li a::before {
                            content: '';
                            position: absolute;
                            bottom: 0;
                            left: 50%;
                            width: 0;
                            height: 2px;
                            background: #D10024;
                            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
                            transform: translateX(-50%);
                        }

                        .section-tab-nav li.active a::before,
                        .section-tab-nav li:hover a::before {
                            width: 100%;
                        }

                        .section-tab-nav li.active a {
                            color: #D10024;
                            font-weight: 600;
                        }

                        /* Tab Pane Animations */
                        .tab-pane {
                            opacity: 0;
                            transform: translateY(20px);
                            transition: none;
                            display: none;
                        }

                        .tab-pane.active {
                            display: block;
                            animation: fadeInUp 0.6s cubic-bezier(0.4, 0, 0.2, 1) forwards;
                        }

                        .tab-pane.fade-out {
                            animation: fadeOutDown 0.4s cubic-bezier(0.4, 0, 0.2, 1) forwards;
                        }

                        /* Product Card Hover Effects */
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

                        /* Stagger Animation for Products */
                        .tab-pane.active .product {
                            opacity: 0;
                            animation: staggerFadeIn 0.5s cubic-bezier(0.4, 0, 0.2, 1) forwards;
                        }

                        .tab-pane.active .product:nth-child(1) {
                            animation-delay: 0.1s;
                        }

                        .tab-pane.active .product:nth-child(2) {
                            animation-delay: 0.15s;
                        }

                        .tab-pane.active .product:nth-child(3) {
                            animation-delay: 0.2s;
                        }

                        .tab-pane.active .product:nth-child(4) {
                            animation-delay: 0.25s;
                        }

                        .tab-pane.active .product:nth-child(5) {
                            animation-delay: 0.3s;
                        }

                        .tab-pane.active .product:nth-child(6) {
                            animation-delay: 0.35s;
                        }

                        /* Auto-rotate Progress Indicator */
                        .section-tab-nav li.active::after {
                            content: '';
                            position: absolute;
                            bottom: -2px;
                            left: 0;
                            width: 0;
                            height: 2px;
                            background: linear-gradient(90deg, #D10024, #FF4757);
                            animation: progressBar 5s linear forwards;
                        }

                        /* Animations */
                        @keyframes pulse {

                            0%,
                            100% {
                                transform: scale(1);
                                box-shadow: 0 10px 30px rgba(255, 68, 68, 0.4);
                            }

                            50% {
                                transform: scale(1.05);
                                box-shadow: 0 15px 40px rgba(255, 68, 68, 0.6);
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

                        @keyframes fadeInDown {
                            from {
                                opacity: 0;
                                transform: translateY(-20px);
                            }

                            to {
                                opacity: 1;
                                transform: translateY(0);
                            }
                        }

                        @keyframes fadeIn {
                            from {
                                opacity: 0;
                            }

                            to {
                                opacity: 1;
                            }
                        }

                        @keyframes fadeOutDown {
                            from {
                                opacity: 1;
                                transform: translateY(0);
                            }

                            to {
                                opacity: 0;
                                transform: translateY(-20px);
                            }
                        }

                        @keyframes staggerFadeIn {
                            from {
                                opacity: 0;
                                transform: translateY(30px) scale(0.95);
                            }

                            to {
                                opacity: 1;
                                transform: translateY(0) scale(1);
                            }
                        }

                        @keyframes progressBar {
                            from {
                                width: 0;
                            }

                            to {
                                width: 100%;
                            }
                        }

                        /* Flash Sale Section */
                        .hot-deal {
                            text-align: center;
                            padding: 60px 30px;
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            border-radius: 20px;
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
                            background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
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
                            color: #ffffff;
                            font-size: 42px;
                            font-weight: 900;
                            text-shadow: 0 3px 10px rgba(0, 0, 0, 0.5), 0 0 20px rgba(255, 255, 255, 0.3);
                            margin: 30px 0 20px 0;
                            position: relative;
                            z-index: 1;
                            animation: fadeInUp 1s ease-out 0.2s both;
                            letter-spacing: 2px;
                        }

                        .hot-deal p {
                            color: #ffffff;
                            font-size: 24px;
                            font-weight: 700;
                            margin: 20px 0 30px;
                            position: relative;
                            z-index: 1;
                            animation: fadeInUp 1s ease-out 0.4s both;
                        }

                        .hot-deal .primary-btn {
                            position: relative;
                            z-index: 1;
                            background: #fff;
                            color: #667eea;
                            padding: 18px 45px;
                            font-size: 18px;
                            font-weight: 700;
                            border-radius: 50px;
                            transition: all 0.3s ease;
                            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
                            animation: fadeInUp 1s ease-out 0.6s both;
                        }

                        .hot-deal .primary-btn:hover {
                            transform: translateY(-5px);
                            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.3);
                            background: #f8f9fa;
                        }

                        /* Responsive */
                        @media (max-width: 768px) {
                            .hot-deal-countdown {
                                gap: 10px;
                            }

                            .hot-deal-countdown li>div {
                                padding: 15px;
                                min-width: 70px;
                            }

                            .hot-deal-countdown h3 {
                                font-size: 32px;
                            }

                            .hot-deal h2 {
                                font-size: 28px;
                            }

                            .hot-deal p {
                                font-size: 18px;
                            }
                        }
                    </style>
                </head>

                <body>
                    <!-- SECTION -->
                    <div class="section">
                        <!-- container -->
                        <div class="container">
                            <!-- row -->
                            <div class="row">
                                <c:forEach var="brandName" items="${fn:split('Apple,Samsung,Xiaomi', ',')}"
                                    varStatus="status">
                                    <!-- shop -->
                                    <div class="col-md-4 col-xs-6">
                                        <div class="shop">
                                            <c:url var="shopLink" value="/shop">
                                                <c:param name="brand" value="${brandName}" />
                                            </c:url>
                                            <div class="shop-img">
                                                <img src="${pageContext.request.contextPath}/uploads/products/baner${fn:toLowerCase(brandName)}.jpg"
                                                    alt="${brandName}"
                                                    style="width: 100%; height: 300px; object-fit: cover;">
                                            </div>
                                            <div class="shop-body">
                                                <h3>${brandName}<br>Collection</h3>
                                                <a href="${shopLink}" class="cta-btn">Xem ngay <i
                                                        class="fa fa-arrow-circle-right"></i></a>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- /shop -->
                                </c:forEach>
                            </div>
                            <!-- /row -->
                        </div>
                        <!-- /container -->
                    </div>
                    <!-- /SECTION -->

                    <!-- SECTION -->
                    <div class="section">
                        <!-- container -->
                        <div class="container">
                            <!-- row -->
                            <div class="row">

                                <!-- section title -->
                                <div class="col-md-12">
                                    <div class="section-title">
                                        <h3 class="title">Sản phẩm mới</h3>
                                        <div class="section-nav">
                                            <ul class="section-tab-nav tab-nav">
                                                <c:forEach items="${brands}" var="brand" varStatus="status">
                                                    <li <c:if test="${status.first}">class="active"</c:if>>
                                                        <a data-toggle="tab"
                                                            href="#tab-brand-${status.index}">${brand}</a>
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                                <!-- /section title -->

                                <!-- Products tab & slick -->
                                <div class="col-md-12">
                                    <div class="row">
                                        <div class="products-tabs">
                                            <c:forEach items="${brands}" var="brand" varStatus="status">
                                                <!-- tab -->
                                                <div id="tab-brand-${status.index}"
                                                    class="tab-pane <c:if test='${status.first}'>active</c:if>">
                                                    <div class="products-slick"
                                                        data-nav="#slick-nav-brand-${status.index}">
                                                        <c:forEach items="${products}" var="product">
                                                            <c:if test="${product.brand == brand}">
                                                                <!-- product -->
                                                                <div class="product">
                                                                    <div class="product-img">
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${not empty product.imageUrls}">
                                                                                <c:set var="foundImage" value="false" />
                                                                                <c:forEach items="${product.imageUrls}"
                                                                                    var="imgUrl" varStatus="status">
                                                                                    <c:if
                                                                                        test="${not empty imgUrl && !foundImage}">
                                                                                        <img src="${pageContext.request.contextPath}${imgUrl}"
                                                                                            alt="${product.name}"
                                                                                            style="max-height: 250px; object-fit: contain;">
                                                                                        <c:set var="foundImage"
                                                                                            value="true" />
                                                                                    </c:if>
                                                                                </c:forEach>
                                                                                <c:if test="${!foundImage}">
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${not empty product.imageUrl}">
                                                                                            <img src="${pageContext.request.contextPath}${product.imageUrl}"
                                                                                                alt="${product.name}"
                                                                                                style="max-height: 250px; object-fit: contain;">
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <img src="${pageContext.request.contextPath}/img/product-placeholder.png"
                                                                                                alt="${product.name}"
                                                                                                style="max-height: 250px; object-fit: contain;">
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                </c:if>
                                                                            </c:when>
                                                                            <c:when
                                                                                test="${not empty product.imageUrl}">
                                                                                <img src="${pageContext.request.contextPath}${product.imageUrl}"
                                                                                    alt="${product.name}"
                                                                                    style="max-height: 250px; object-fit: contain;">
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <img src="${pageContext.request.contextPath}/img/product-placeholder.png"
                                                                                    alt="${product.name}"
                                                                                    style="max-height: 250px; object-fit: contain;">
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                        <!-- Deal labels styled like deals.jsp -->
                                                                        <div class="product-label"
                                                                            style="position:absolute;top:10px;right:10px;z-index:2;">
                                                                            <c:if
                                                                                test="${product.dealPercentage != null && product.dealPercentage > 0}">
                                                                                <span class="sale"
                                                                                    style="background:#c50b12;color:#fff;padding:4px 6px;border-radius:4px;font-weight:700;box-shadow:0 1px 0 rgba(0,0,0,0.08);border:none;animation:pulse 2s infinite;">-${product.dealPercentage}%</span>
                                                                                <span class="new"
                                                                                    style="background:#ff3b5c;color:#fff;padding:4px 6px;border-radius:4px;font-weight:700;box-shadow:0 1px 0 rgba(0,0,0,0.08);border:none;animation:pulse 2s infinite;margin-left:6px;">HOT</span>
                                                                            </c:if>
                                                                        </div>
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${not empty product.isActive and product.isActive == false}">
                                                                                <div class="product-label">
                                                                                    <span class="sale"
                                                                                        style="background:#ff3b5c;color:#fff;padding:4px 6px;border-radius:4px;border:1px solid rgba(0,0,0,0.06);margin-left:6px;">NGỪNG
                                                                                        KINH DOANH</span>
                                                                                </div>
                                                                            </c:when>
                                                                            <c:when test="${product.stock == 0}">
                                                                                <div class="product-label">
                                                                                    <span class="sale"
                                                                                        style="background:#ff3b5c;color:#fff;padding:4px 6px;border-radius:4px;border:1px solid rgba(0,0,0,0.06);margin-left:6px;">HẾT
                                                                                        HÀNG</span>
                                                                                </div>
                                                                            </c:when>
                                                                        </c:choose>
                                                                    </div>
                                                                    <div class="product-body">
                                                                        <!-- Deal labels moved to product-img -->
                                                                        <p class="product-category">${product.brand}
                                                                        </p>
                                                                        <h3 class="product-name">
                                                                            <a
                                                                                href="${pageContext.request.contextPath}/product/${product.id}">${product.name}</a>
                                                                        </h3>
                                                                        <h4 class="product-price">
                                                                            <c:choose>
                                                                                <c:when
                                                                                    test="${product.onDeal == true && product.dealPercentage != null && product.dealPercentage > 0}">
                                                                                    <c:set var="discountedPrice"
                                                                                        value="${product.price * (100 - product.dealPercentage) / 100}" />
                                                                                    <c:set var="savedAmount"
                                                                                        value="${product.price - discountedPrice}" />
                                                                                    <span
                                                                                        style="color: #d70018; font-size: 18px; font-weight: bold;">
                                                                                        <fmt:formatNumber
                                                                                            value="${discountedPrice}"
                                                                                            type="currency"
                                                                                            currencySymbol="₫"
                                                                                            maxFractionDigits="0" />
                                                                                    </span>
                                                                                    <br>
                                                                                    <del
                                                                                        style="color: #999; font-size: 14px;">
                                                                                        <fmt:formatNumber
                                                                                            value="${product.price}"
                                                                                            type="currency"
                                                                                            currencySymbol="₫"
                                                                                            maxFractionDigits="0" />
                                                                                    </del>
                                                                                    <span
                                                                                        style="color: #ff4444; font-size: 12px; margin-left: 5px; font-weight: bold; background: #ffe8e8; padding: 1px 5px; border-radius: 3px;">
                                                                                        -${product.dealPercentage}%
                                                                                    </span>
                                                                                    <br>
                                                                                    <span
                                                                                        style="color: #28a745; font-size: 12px; font-weight: bold; background: #e8f5e8; padding: 1px 5px; border-radius: 3px;">
                                                                                        Tiết kiệm
                                                                                        <fmt:formatNumber
                                                                                            value="${savedAmount}"
                                                                                            type="currency"
                                                                                            currencySymbol="₫"
                                                                                            maxFractionDigits="0" />
                                                                                    </span>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <fmt:formatNumber
                                                                                        value="${product.price}"
                                                                                        type="currency"
                                                                                        currencySymbol="₫"
                                                                                        maxFractionDigits="0" />
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </h4>
                                                                        <div class="product-rating"
                                                                            id="rating-new-${product.id}">
                                                                            <i class="fa fa-star-o"></i>
                                                                            <i class="fa fa-star-o"></i>
                                                                            <i class="fa fa-star-o"></i>
                                                                            <i class="fa fa-star-o"></i>
                                                                            <i class="fa fa-star-o"></i>
                                                                        </div>
                                                                        <div class="product-btns">
                                                                            <button class="add-to-wishlist"
                                                                                data-product-id="${product.id}"
                                                                                onclick="toggleFavorite(${product.id}, this)">
                                                                                <i class="fa fa-heart-o"></i>
                                                                                <span class="tooltipp">Yêu thích</span>
                                                                            </button>
                                                                            <a href="${pageContext.request.contextPath}/product/${product.id}"
                                                                                class="quick-view">
                                                                                <i class="fa fa-eye"></i>
                                                                                <span class="tooltipp">Xem chi
                                                                                    tiết</span>
                                                                            </a>
                                                                        </div>
                                                                    </div>
                                                                    <div class="add-to-cart">
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${not empty product.isActive and product.isActive == false}">
                                                                                <button class="add-to-cart-btn" disabled
                                                                                    style="background: #999;">
                                                                                    <i class="fa fa-ban"></i> Ngừng kinh
                                                                                    doanh
                                                                                </button>
                                                                            </c:when>
                                                                            <c:when test="${product.stock > 0}">
                                                                                <button class="add-to-cart-btn"
                                                                                    onclick="addToCart(${product.id})">
                                                                                    <i class="fa fa-shopping-cart"></i>
                                                                                    Thêm
                                                                                    vào giỏ
                                                                                </button>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <button class="add-to-cart-btn" disabled
                                                                                    style="background: #999;">
                                                                                    <i class="fa fa-ban"></i> Hết hàng
                                                                                </button>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                </div>
                                                                <!-- /product -->
                                                            </c:if>
                                                        </c:forEach>
                                                    </div>
                                                    <div id="slick-nav-brand-${status.index}"
                                                        class="products-slick-nav">
                                                    </div>
                                                </div>
                                                <!-- /tab -->
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>
                                <!-- Products tab & slick -->
                            </div>
                            <!-- /row -->
                        </div>
                        <!-- /container -->
                    </div>
                    <!-- /SECTION -->

                    <!-- HOT DEAL SECTION -->
                    <div id="hot-deal" class="section">
                        <!-- container -->
                        <div class="container">
                            <!-- row -->
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="hot-deal">

                                        <h2 class="text-uppercase">Flash Sale hôm nay</h2>
                                        <p>Giảm giá lên đến 50%</p>
                                        <a class="primary-btn cta-btn"
                                            href="${pageContext.request.contextPath}/deals">Mua
                                            ngay</a>
                                    </div>
                                </div>
                            </div>
                            <!-- /row -->
                        </div>
                        <!-- /container -->
                    </div>
                    <!-- /HOT DEAL SECTION -->

                    <!-- SECTION -->
                    <div class="section">
                        <!-- container -->
                        <div class="container">
                            <!-- row -->
                            <div class="row">

                                <!-- section title -->
                                <div class="col-md-12">
                                    <div class="section-title">
                                        <h3 class="title">Sản phẩm bán chạy</h3>
                                    </div>
                                </div>
                                <!-- /section title -->

                                <!-- Products single -->
                                <c:forEach items="${products}" var="product" begin="0" end="11">
                                    <div class="col-md-3 col-xs-6">
                                        <div class="product">
                                            <div class="product-img">
                                                <c:choose>
                                                    <c:when test="${not empty product.imageUrls}">
                                                        <c:set var="foundImage" value="false" />
                                                        <c:forEach items="${product.imageUrls}" var="imgUrl"
                                                            varStatus="status">
                                                            <c:if test="${not empty imgUrl && !foundImage}">
                                                                <img src="${pageContext.request.contextPath}${imgUrl}"
                                                                    alt="${product.name}"
                                                                    style="max-height: 250px; object-fit: contain;">
                                                                <c:set var="foundImage" value="true" />
                                                            </c:if>
                                                        </c:forEach>
                                                        <c:if test="${!foundImage}">
                                                            <c:choose>
                                                                <c:when test="${not empty product.imageUrl}">
                                                                    <img src="${pageContext.request.contextPath}${product.imageUrl}"
                                                                        alt="${product.name}"
                                                                        style="max-height: 250px; object-fit: contain;">
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <img src="${pageContext.request.contextPath}/img/product-placeholder.png"
                                                                        alt="${product.name}"
                                                                        style="max-height: 250px; object-fit: contain;">
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:if>
                                                    </c:when>
                                                    <c:when test="${not empty product.imageUrl}">
                                                        <img src="${pageContext.request.contextPath}${product.imageUrl}"
                                                            alt="${product.name}"
                                                            style="max-height: 250px; object-fit: contain;">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${pageContext.request.contextPath}/img/product-placeholder.png"
                                                            alt="${product.name}"
                                                            style="max-height: 250px; object-fit: contain;">
                                                    </c:otherwise>
                                                </c:choose>
                                                <!-- Deal labels styled like deals.jsp -->
                                                <div class="product-label"
                                                    style="position:absolute;top:10px;right:10px;z-index:2;">
                                                    <c:if
                                                        test="${product.dealPercentage != null && product.dealPercentage > 0}">
                                                        <span class="sale"
                                                            style="background:#c50b12;color:#fff;padding:4px 6px;border-radius:4px;font-weight:700;box-shadow:0 1px 0 rgba(0,0,0,0.08);border:none;animation:pulse 2s infinite;">-${product.dealPercentage}%</span>
                                                        <span class="new"
                                                            style="background:#ff3b5c;color:#fff;padding:4px 6px;border-radius:4px;font-weight:700;box-shadow:0 1px 0 rgba(0,0,0,0.08);border:none;animation:pulse 2s infinite;margin-left:6px;">HOT</span>
                                                    </c:if>
                                                </div>
                                                <c:choose>
                                                    <c:when
                                                        test="${not empty product.isActive and product.isActive == false}">
                                                        <div class="product-label">
                                                            <span class="sale"
                                                                style="background:#ff3b5c;color:#fff;padding:4px 6px;border-radius:4px;border:1px solid rgba(0,0,0,0.06);margin-left:6px;">NGỪNG
                                                                KINH DOANH</span>
                                                        </div>
                                                    </c:when>
                                                    <c:when test="${product.stock == 0}">
                                                        <div class="product-label">
                                                            <span class="sale"
                                                                style="background:#ff3b5c;color:#fff;padding:4px 6px;border-radius:4px;border:1px solid rgba(0,0,0,0.06);margin-left:6px;">HẾT
                                                                HÀNG</span>
                                                        </div>
                                                    </c:when>
                                                </c:choose>
                                            </div>
                                            <div class="product-body">
                                                <p class="product-category">${product.brand}</p>
                                                <h3 class="product-name">
                                                    <a
                                                        href="${pageContext.request.contextPath}/product/${product.id}">${product.name}</a>
                                                </h3>
                                                <h4 class="product-price">
                                                    <c:choose>
                                                        <c:when
                                                            test="${product.onDeal == true && product.dealPercentage != null && product.dealPercentage > 0}">
                                                            <c:set var="discountedPrice"
                                                                value="${product.price * (100 - product.dealPercentage) / 100}" />
                                                            <c:set var="savedAmount"
                                                                value="${product.price - discountedPrice}" />
                                                            <span
                                                                style="color: #d70018; font-size: 18px; font-weight: bold;">
                                                                <fmt:formatNumber value="${discountedPrice}"
                                                                    type="currency" currencySymbol="₫"
                                                                    maxFractionDigits="0" />
                                                            </span>
                                                            <br>
                                                            <del style="color: #999; font-size: 14px;">
                                                                <fmt:formatNumber value="${product.price}"
                                                                    type="currency" currencySymbol="₫"
                                                                    maxFractionDigits="0" />
                                                            </del>
                                                            <span
                                                                style="color: #ff4444; font-size: 12px; margin-left: 5px; font-weight: bold; background: #ffe8e8; padding: 1px 5px; border-radius: 3px;">
                                                                -${product.dealPercentage}%
                                                            </span>
                                                            <br>
                                                            <span
                                                                style="color: #28a745; font-size: 12px; font-weight: bold; background: #e8f5e8; padding: 1px 5px; border-radius: 3px;">
                                                                Tiết kiệm
                                                                <fmt:formatNumber value="${savedAmount}" type="currency"
                                                                    currencySymbol="₫" maxFractionDigits="0" />
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <fmt:formatNumber value="${product.price}" type="currency"
                                                                currencySymbol="₫" maxFractionDigits="0" />
                                                        </c:otherwise>
                                                    </c:choose>
                                                </h4>
                                                <div class="product-rating" id="rating-hot-${product.id}">
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
                                                    <c:when
                                                        test="${not empty product.isActive and product.isActive == false}">
                                                        <button class="add-to-cart-btn" disabled
                                                            style="background: #999;">
                                                            <i class="fa fa-ban"></i> Ngừng kinh doanh
                                                        </button>
                                                    </c:when>
                                                    <c:when test="${product.stock > 0}">
                                                        <button class="add-to-cart-btn"
                                                            onclick="addToCart(${product.id})">
                                                            <i class="fa fa-shopping-cart"></i> Thêm vào giỏ
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button class="add-to-cart-btn" disabled
                                                            style="background: #999;">
                                                            <i class="fa fa-ban"></i> Hết hàng
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                                <!-- /Products single -->

                            </div>
                            <!-- /row -->
                        </div>
                        <!-- /container -->
                    </div>
                    <!-- /SECTION -->

                    <!-- NEWSLETTER -->
                    <div id="newsletter" class="section">
                        <!-- container -->
                        <div class="container">
                            <!-- row -->
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="newsletter">
                                        <p>Đăng ký nhận <strong>TIN TỨC MỚI</strong></p>
                                        <form>
                                            <input class="input" type="email" placeholder="Nhập email của bạn">
                                            <button class="newsletter-btn"><i class="fa fa-envelope"></i> Đăng
                                                ký</button>
                                        </form>
                                        <ul class="newsletter-follow">
                                            <li><a href="https://www.facebook.com/nhan.le.24813" target="_blank"><i
                                                        class="fa fa-facebook"></i></a></li>
                                            <li><a href="https://x.com/Apple" target="_blank"><i
                                                        class="fa fa-twitter"></i></a></li>
                                            <li><a href="https://www.instagram.com/apple/" target="_blank"><i
                                                        class="fa fa-instagram"></i></a></li>
                                            <li><a href="https://www.pinterest.com/apple/" target="_blank"><i
                                                        class="fa fa-pinterest"></i></a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <!-- /row -->
                        </div>
                        <!-- /container -->
                    </div>
                    <!-- /NEWSLETTER -->

                    <script>
    <%
                            org.springframework.security.core.Authentication auth = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
        boolean isAuthenticated = auth != null && auth.isAuthenticated() && !(auth instanceof org.springframework.security.authentication.AnonymousAuthenticationToken);
    %>
    var IS_LOGGED_IN = <%= isAuthenticated %>;

                        function addToCart(productId) {
                            if (!IS_LOGGED_IN) {
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
                                    if (typeof updateGlobalCartCount === 'function') updateGlobalCartCount();
                                })
                                .catch(error => {
                                    if (error.message === 'Unauthorized') {
                                        window.location.href = '${pageContext.request.contextPath}/login';
                                    } else {
                                        alert('Có lỗi: ' + error.message);
                                    }
                                });
                        }

                        function toggleFavorite(productId, button) {
                            if (!IS_LOGGED_IN) {
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

                        function loadFavoriteStates() {
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

                        if (IS_LOGGED_IN) {
                            window.addEventListener('DOMContentLoaded', function () {
                                loadFavoriteStates();
                            });
                        }
                        // ========== RATING FUNCTIONS ==========

                        // Load rating cho tất cả sản phẩm hiển thị trên trang
                        function loadAllProductRatings() {
                            // Lấy tất cả product IDs từ các thẻ rating (cả new và hot products)
                            const ratingElements = document.querySelectorAll('[id^="rating-"]');

                            ratingElements.forEach(element => {
                                const productId = element.id.replace('rating-new-', '').replace('rating-hot-', '');
                                loadProductRating(productId, element.id);
                            });
                        }

                        // Load rating cho một sản phẩm cụ thể
                        async function loadProductRating(productId, elementId) {
                            try {
                                const response = await fetch('${pageContext.request.contextPath}/api/reviews/product/' + productId + '/stats');

                                if (!response.ok) {
                                    console.error('Failed to load rating for product ' + productId);
                                    return;
                                }

                                const stats = await response.json();

                                // Update rating stars cho sản phẩm này
                                displayProductStars(elementId, stats.averageRating);
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
                        // ========== RATING FUNCTIONS ==========

                        // Synchronized 24-hour countdown for home page (same as deals page)
                        function updateHomeCountdown() {
                            // Get or create countdown start time (shared with deals page)
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

                            const timer = setInterval(function () {
                                const currentTime = new Date().getTime();
                                const timeLeft = endTime - currentTime;

                                if (timeLeft <= 0) {
                                    // Reset countdown when it reaches 0
                                    const newStartTime = new Date().getTime();
                                    localStorage.setItem('flashSaleStartTime', newStartTime);
                                    clearInterval(timer);
                                    updateHomeCountdown(); // Restart countdown
                                    return;
                                }

                                const days = Math.floor(timeLeft / (1000 * 60 * 60 * 24));
                                const hours = Math.floor((timeLeft % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                                const minutes = Math.floor((timeLeft % (1000 * 60 * 60)) / (1000 * 60));
                                const seconds = Math.floor((timeLeft % (1000 * 60)) / 1000);

                                // Update countdown display
                                const daysEl = document.getElementById("home-days");
                                const hoursEl = document.getElementById("home-hours");
                                const minutesEl = document.getElementById("home-minutes");
                                const secondsEl = document.getElementById("home-seconds");

                                if (daysEl) daysEl.textContent = days.toString().padStart(2, '0');
                                if (hoursEl) hoursEl.textContent = hours.toString().padStart(2, '0');
                                if (minutesEl) minutesEl.textContent = minutes.toString().padStart(2, '0');
                                if (secondsEl) secondsEl.textContent = seconds.toString().padStart(2, '0');
                            }, 1000);
                        }

                        // Start countdown when page loads
                        window.addEventListener('DOMContentLoaded', function () {
                            updateHomeCountdown();
                            initProductTabsAutoRotate();
                            loadAllProductRatings(); // Load ratings for all products
                        });

                        // Auto-rotate product tabs with smooth animation
                        function initProductTabsAutoRotate() {
                            const tabNavItems = document.querySelectorAll('.section-tab-nav li');
                            const tabPanes = document.querySelectorAll('.tab-pane');

                            if (tabNavItems.length === 0 || tabPanes.length === 0) return;

                            let currentIndex = 0;
                            let autoRotateInterval;
                            let isUserInteracting = false;

                            // Function to switch to a specific tab
                            function switchToTab(index) {
                                if (index === currentIndex) return;

                                // Remove active class and add fade-out animation to current tab
                                tabPanes.forEach(pane => {
                                    if (pane.classList.contains('active')) {
                                        pane.classList.add('fade-out');
                                        setTimeout(() => {
                                            pane.classList.remove('active', 'fade-out');
                                        }, 400);
                                    }
                                });

                                // Update nav items
                                tabNavItems.forEach(item => item.classList.remove('active'));
                                tabNavItems[index].classList.add('active');

                                // Show new tab with animation
                                setTimeout(() => {
                                    tabPanes[index].classList.add('active');
                                }, 400);

                                currentIndex = index;
                            }

                            // Auto-rotate every 5 seconds
                            function startAutoRotate() {
                                autoRotateInterval = setInterval(() => {
                                    if (!isUserInteracting) {
                                        const nextIndex = (currentIndex + 1) % tabNavItems.length;
                                        switchToTab(nextIndex);
                                    }
                                }, 5000); // 5 seconds per tab
                            }

                            // Stop auto-rotate temporarily when user interacts
                            function pauseAutoRotate() {
                                isUserInteracting = true;
                                setTimeout(() => {
                                    isUserInteracting = false;
                                }, 10000); // Resume after 10 seconds of no interaction
                            }

                            // Add click handlers to tabs
                            tabNavItems.forEach((item, index) => {
                                item.addEventListener('click', (e) => {
                                    e.preventDefault();
                                    pauseAutoRotate();
                                    switchToTab(index);
                                });
                            });

                            // Start auto-rotation
                            startAutoRotate();

                            // Pause on hover
                            const productsSection = document.querySelector('.products-tabs');
                            if (productsSection) {
                                productsSection.addEventListener('mouseenter', () => {
                                    isUserInteracting = true;
                                });

                                productsSection.addEventListener('mouseleave', () => {
                                    isUserInteracting = false;
                                });
                            }
                        }
                    </script>
                </body>

                </html>