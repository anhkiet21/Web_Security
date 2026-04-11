<%@ page contentType="text/html; charset=UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
      <%@ page import="org.springframework.security.core.Authentication" %>
        <%@ page import="org.springframework.security.authentication.AnonymousAuthenticationToken" %>
          <% Authentication auth=SecurityContextHolder.getContext().getAuthentication(); boolean isAuthenticated=auth
            !=null && auth.isAuthenticated() && !(auth instanceof AnonymousAuthenticationToken);
            request.setAttribute("isUserAuthenticated", isAuthenticated); %>
            <!DOCTYPE html>
            <html>

            <head>
              <meta charset="UTF-8" />
              <title>
                Chi tiết sản phẩm -
                <c:out value="${product.name}" default="Sản phẩm" />
              </title>

              <style>
                /* Hover animation cho product cards trong related/similar products */
                .product {
                  transition: all 0.3s ease;
                  cursor: pointer;
                }

                .product:hover {
                  transform: translateY(-10px);
                  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
                  z-index: 10;
                }

                .product-img {
                  overflow: hidden;
                  position: relative;
                }

                .product-img img {
                  transition: transform 0.3s ease;
                }

                .product:hover .product-img img {
                  transform: scale(1.05);
                }

                /* Vô hiệu hóa hover effect cho nút disabled */
                .add-to-cart-btn:disabled,
                .add-to-cart-btn:disabled:hover {
                  background-color: #999 !important;
                  cursor: not-allowed !important;
                  opacity: 0.6 !important;
                  transform: none !important;
                  box-shadow: none !important;
                  pointer-events: none;
                }

                /* Styling for document images in description */
                .description-content img {
                  max-width: 100%;
                  height: auto;
                  display: block;
                  margin: 15px auto;
                  border-radius: 4px;
                  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                }

                .description-content .img-wrapper {
                  max-width: 100%;
                  margin: 15px auto;
                  display: block;
                }

                .description-content .img-wrapper img {
                  width: 100%;
                  height: auto;
                  display: block;
                  margin: 0;
                }

                .description-content .table-wrapper {
                  max-width: 100%;
                  margin: 15px auto;
                  display: block;
                  overflow-x: auto;
                }

                .description-content .table-wrapper table {
                  width: 100%;
                  margin: 0;
                }

                .description-content table {
                  width: 100%;
                  border-collapse: collapse;
                  margin: 15px 0;
                }

                .description-content table td,
                .description-content table th {
                  border: 1px solid #ddd;
                  padding: 8px;
                  text-align: left;
                }

                .description-content table th {
                  background-color: #f2f2f2;
                  font-weight: bold;
                }

                .description-content h1,
                .description-content h2,
                .description-content h3 {
                  margin-top: 20px;
                  margin-bottom: 10px;
                  color: #333;
                }

                .description-content p {
                  margin: 10px 0;
                  line-height: 1.8;
                }

                .description-content ul,
                .description-content ol {
                  margin: 10px 0;
                  padding-left: 30px;
                }

                .description-content li {
                  margin: 5px 0;
                  line-height: 1.8;
                }

                /* Inline Alert System */
                .inline-alert {
                  padding: 15px 20px;
                  border-radius: 8px;
                  margin-bottom: 20px;
                  font-weight: 600;
                  display: flex;
                  align-items: center;
                  gap: 12px;
                  animation: slideDown 0.4s ease-out;
                  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                  transition: opacity 0.5s ease;
                  position: relative;
                  z-index: 1000;
                }

                .inline-alert i {
                  font-size: 20px;
                }

                .inline-alert-danger {
                  background: #f8d7da;
                  color: #721c24;
                  border: 1px solid #f5c6cb;
                }

                .inline-alert-warning {
                  background: #fff3cd;
                  color: #856404;
                  border: 1px solid #ffc107;
                }

                .inline-alert-success {
                  background: #d4edda;
                  color: #155724;
                  border: 1px solid #c3e6cb;
                }

                .inline-alert-info {
                  background: #d1ecf1;
                  color: #0c5460;
                  border: 1px solid #bee5eb;
                }

                @keyframes slideDown {
                  from {
                    opacity: 0;
                    transform: translateY(-20px);
                  }

                  to {
                    opacity: 1;
                    transform: translateY(0);
                  }
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
                        <li>
                          <a href="${pageContext.request.contextPath}/">Trang chủ</a>
                        </li>
                        <li>
                          <a href="${pageContext.request.contextPath}/shop">Sản phẩm</a>
                        </li>
                        <li class="active" id="breadcrumbName">Chi tiết sản phẩm</li>
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
                    <!-- Main Content (col-md-9) -->
                    <div class="col-md-9">
                      <div class="row">
                        <!-- Product main img -->
                        <div class="col-md-5 col-md-push-2">
                          <div id="product-main-img">
                            <!-- Main images will be inserted here -->
                            <c:if test="${product.dealPercentage != null && product.dealPercentage > 0}">
                              <div class="product-label" style="
                        position: absolute;
                        top: 10px;
                        right: 10px;
                        z-index: 2;
                      ">
                                <span class="sale" style="
                          background: #c50b12;
                          color: #fff;
                          padding: 4px 6px;
                          border-radius: 4px;
                          font-weight: 700;
                          box-shadow: 0 1px 0 rgba(0, 0, 0, 0.08);
                          border: none;
                          animation: pulse 2s infinite;
                        ">-${product.dealPercentage}%</span>
                                <span class="new" style="
                          background: #ff3b5c;
                          color: #fff;
                          padding: 4px 6px;
                          border-radius: 4px;
                          font-weight: 700;
                          box-shadow: 0 1px 0 rgba(0, 0, 0, 0.08);
                          border: none;
                          animation: pulse 2s infinite;
                          margin-left: 6px;
                        ">HOT</span>
                              </div>
                            </c:if>
                          </div>
                        </div>
                        <!-- /Product main img -->

                        <!-- Product thumb imgs -->
                        <div class="col-md-2 col-md-pull-5">
                          <div id="product-imgs">
                            <!-- Thumbnails will be inserted here -->
                          </div>
                        </div>
                        <!-- /Product thumb imgs -->

                        <!-- Product details -->
                        <div class="col-md-5">
                          <div class="product-details">
                            <h2 class="product-name" id="productName">Loading...</h2>
                            <div>
                              <div class="product-rating" id="productRating">
                                <i class="fa fa-star-o"></i>
                                <i class="fa fa-star-o"></i>
                                <i class="fa fa-star-o"></i>
                                <i class="fa fa-star-o"></i>
                                <i class="fa fa-star-o"></i>
                              </div>
                              <a class="review-link" id="reviewLink" href="#tab3">Đang tải...</a>
                            </div>
                            <div>
                              <h3 class="product-price" id="productPrice">$0.00</h3>
                              <span class="product-available" id="productStock">In Stock</span>
                            </div>
                            <p id="productDescription">Loading product description...</p>

                            <!-- Product Variants Section -->
                            <div class="product-variants" style="margin: 20px 0">
                              <!-- Storage Options -->
                              <div class="variant-group" id="storageVariants" style="margin-bottom: 15px">
                                <h4 style="
                          font-size: 16px;
                          font-weight: 600;
                          margin-bottom: 10px;
                        ">
                                  Phiên bản
                                </h4>
                                <div class="variant-options" style="display: flex; gap: 10px; flex-wrap: wrap">
                                  <!-- Storage buttons will be inserted here by JavaScript -->
                                </div>
                              </div>
                            </div>

                            <div class="add-to-cart">
                              <div class="qty-label">
                                <div class="input-number">
                                  <input type="number" id="quantity" value="1" min="1" />
                                  <span class="qty-up">+</span>
                                  <span class="qty-down">-</span>
                                </div>
                              </div>
                              <button class="add-to-cart-btn" id="addToCartBtn">
                                <i class="fa fa-shopping-cart"></i> Thêm Vào Giỏ
                              </button>
                            </div>

                            <ul class="product-btns">
                              <li>
                                <a href="#" id="addToWishlistBtn"><i class="fa fa-heart-o"></i> Yêu Thích</a>
                              </li>
                            </ul>

                            <ul class="product-links">
                              <li>Thương Hiệu:</li>
                              <li><a href="#" id="productBrand">Brand</a></li>
                            </ul>

                            <ul class="product-links">
                              <li>Chia Sẻ:</li>
                              <li>
                                <a href="#" id="shareFacebook" onclick="shareOnFacebook(); return false;"><i
                                    class="fa fa-facebook"></i></a>
                              </li>
                              <li>
                                <a href="#" id="shareTwitter" onclick="shareOnTwitter(); return false;"><i
                                    class="fa fa-twitter"></i></a>
                              </li>
                              <li>
                                <a href="#" id="shareGooglePlus" onclick="shareOnGooglePlus(); return false;"><i
                                    class="fa fa-google-plus"></i></a>
                              </li>
                              <li>
                                <a href="#" id="shareEmail" onclick="shareViaEmail(); return false;"><i
                                    class="fa fa-envelope"></i></a>
                              </li>
                            </ul>
                          </div>
                        </div>
                        <!-- /Product details -->
                      </div>
                    </div>
                    <!-- /Main Content -->

                    <!-- Sidebar (col-md-3) - Version Products -->
                    <div class="col-md-3">
                      <div class="aside">
                        <h3 class="aside-title">Sản phẩm tương tự</h3>
                        <div id="versionProducts" class="product-widget">
                          <!-- Version products will be inserted here -->
                        </div>
                      </div>
                    </div>
                    <!-- /Sidebar -->

                    <!-- Product tab -->
                    <div class="col-md-12">
                      <div id="product-tab">
                        <!-- product tab nav -->
                        <ul class="tab-nav">
                          <li class="active">
                            <a data-toggle="tab" href="#tab1">Mô tả</a>
                          </li>
                          <li><a data-toggle="tab" href="#tab2">Thông số kỹ thuật</a></li>
                          <li><a data-toggle="tab" href="#tab3">Đánh giá </a></li>
                        </ul>
                        <!-- /product tab nav -->

                        <!-- product tab content -->
                        <div class="tab-content">
                          <!-- tab1 -->
                          <div id="tab1" class="tab-pane fade in active">
                            <div class="row">
                              <div class="col-md-12">
                                <div id="tabDescription" class="description-content collapsed" style="
                          line-height: 1.8;
                          font-size: 14px;
                          max-height: 0;
                          overflow: hidden;
                          position: relative;
                          transition: max-height 0.5s ease;
                        ">
                                  <p>Đang tải thông tin sản phẩm...</p>
                                </div>
                                <div style="text-align: center; margin-top: 15px">
                                  <button id="toggleDescriptionBtn" class="primary-btn"
                                    style="padding: 10px 30px; display: none">
                                    <i class="fa fa-angle-down"></i> Xem mô tả chi tiết
                                  </button>
                                </div>
                              </div>
                            </div>
                          </div>
                          <!-- /tab1 -->

                          <!-- tab2 -->
                          <div id="tab2" class="tab-pane fade in">
                            <div class="row">
                              <div class="col-md-12">
                                <div id="specsContent">
                                  <p>Đang tải thông số kỹ thuật...</p>
                                </div>
                              </div>
                            </div>
                          </div>
                          <!-- /tab2 -->

                          <!-- tab3 -->
                          <div id="tab3" class="tab-pane fade in">
                            <div class="row">
                              <!-- Rating Summary -->
                              <div class="col-md-3">
                                <div id="rating">
                                  <div class="rating-avg">
                                    <span id="avgRating">0.0</span>
                                    <div class="rating-stars" id="avgRatingStars">
                                      <i class="fa fa-star-o"></i>
                                      <i class="fa fa-star-o"></i>
                                      <i class="fa fa-star-o"></i>
                                      <i class="fa fa-star-o"></i>
                                      <i class="fa fa-star-o"></i>
                                    </div>
                                    <span id="totalReviewsText" style="font-size: 14px; color: #666">0 đánh giá</span>
                                  </div>
                                  <ul class="rating" id="ratingDistribution">
                                    <!-- Rating distribution will be loaded here -->
                                  </ul>
                                </div>
                              </div>
                              <!-- /Rating Summary -->

                              <!-- Reviews List -->
                              <div class="col-md-6">
                                <div id="reviews">
                                  <ul class="reviews" id="reviewsList">
                                    <li style="text-align: center; color: #999">
                                      <p>Đang tải đánh giá...</p>
                                    </li>
                                  </ul>
                                  <!-- Pagination -->
                                  <div id="reviewsPagination" style="text-align: center; margin-top: 20px">
                                    <!-- Pagination buttons will be loaded here -->
                                  </div>
                                </div>
                              </div>
                              <!-- /Reviews List -->

                              <!-- Review Form -->
                              <div class="col-md-3">
                                <div id="review-form">
                                  <h4 style="margin-bottom: 15px">Viết đánh giá</h4>
                                  <form id="reviewForm" class="review-form">
                                    <div class="input-rating" style="margin-bottom: 15px">
                                      <span>Xếp hạng: </span>
                                      <div class="stars">
                                        <input id="star5" name="rating" value="5" type="radio" /><label
                                          for="star5"></label>
                                        <input id="star4" name="rating" value="4" type="radio" /><label
                                          for="star4"></label>
                                        <input id="star3" name="rating" value="3" type="radio" /><label
                                          for="star3"></label>
                                        <input id="star2" name="rating" value="2" type="radio" /><label
                                          for="star2"></label>
                                        <input id="star1" name="rating" value="1" type="radio" /><label
                                          for="star1"></label>
                                      </div>
                                    </div>
                                    <textarea id="reviewComment" class="input"
                                      placeholder="Nhận xét của bạn về sản phẩm" rows="5" required></textarea>
                                    <button type="submit" class="primary-btn" style="width: 100%; margin-top: 10px">
                                      Gửi đánh giá
                                    </button>
                                  </form>
                                </div>
                              </div>
                              <!-- /Review Form -->
                            </div>
                          </div>
                          <!-- /tab3 -->
                        </div>
                        <!-- /product tab content -->
                      </div>
                    </div>
                    <!-- /product tab -->
                  </div>
                </div>
              </div>
              <!-- /SECTION -->

              <!-- Section -->
              <div class="section">
                <div class="container">
                  <div class="row">
                    <div class="col-md-12">
                      <div class="section-title text-center">
                        <h3 class="title">Sản phẩm cùng hãng</h3>
                      </div>
                    </div>
                    <!-- Same brand products carousel -->
                    <div class="col-md-12">
                      <div id="sameProducts" class="product-slick-carousel">
                        <!-- Same brand products will be inserted here -->
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <!-- /Section -->

              <script>
                const ctx = "${pageContext.request.contextPath}";
                const isUserLoggedIn = ${ isUserAuthenticated };
                const isAdmin = <c:out value="${pageContext.request.isUserInRole('ADMIN')}" default="false" />;

                // Inline Alert System
                function showInlineAlert(message, type = 'danger') {
                  // Remove existing alerts
                  document.querySelectorAll('.inline-alert').forEach(alert => alert.remove());

                  // Create alert element
                  const alertDiv = document.createElement('div');
                  alertDiv.className = 'inline-alert inline-alert-' + type;
                  alertDiv.innerHTML = '<i class="fa fa-' + (type === 'success' ? 'check-circle' : type === 'warning' ? 'exclamation-triangle' : type === 'info' ? 'info-circle' : 'exclamation-circle') + '"></i> <span>' + message + '</span>';

                  // Insert at top of product section or reviews section based on context
                  const productSection = document.querySelector('.product-details') || document.querySelector('.section');
                  if (productSection) {
                    productSection.insertBefore(alertDiv, productSection.firstChild);

                    // Scroll to alert
                    alertDiv.scrollIntoView({ behavior: 'smooth', block: 'nearest' });

                    // Auto-hide after 5 seconds
                    setTimeout(() => {
                      alertDiv.style.opacity = '0';
                      setTimeout(() => alertDiv.remove(), 500);
                    }, 5000);
                  }
                }

        // Sử dụng data từ server thay vì fetch API
        <c:if test="${not empty product}">
        var productData = {
          id: <c:out value="${product.id}"/>,
          name: "<c:out value='${product.name}'/>",
          price: <c:out value="${product.price}" default="0"/>,
          stock: <c:out value="${product.stock}" default="0"/>,
          brand: "<c:out value='${product.brand}'/>",
          imageUrl: "<c:out value='${product.imageUrl}'/>",
          imageUrls: [
            <c:forEach items="${product.imageUrls}" var="imgUrl" varStatus="status">
              "<c:out value='${imgUrl}'/>"<c:if test="${!status.last}">,</c:if>
            </c:forEach>
          ],
          <c:choose>
          <c:when test="${not empty product.category}">
          category: {
            id: <c:out value="${product.category.id}"/>,
            name: "<c:out value='${product.category.name}'/>"
          },
          </c:when>
          <c:otherwise>
          category: null,
          </c:otherwise>
          </c:choose>
          screenSize: "<c:out value='${product.screenSize}'/>",
          displayTech: "<c:out value='${product.displayTech}'/>",
          resolution: "<c:out value='${product.resolution}'/>",
          displayFeatures: "<c:out value='${product.displayFeatures}'/>",
          rearCamera: "<c:out value='${product.rearCamera}'/>",
          frontCamera: "<c:out value='${product.frontCamera}'/>",
          chipset: "<c:out value='${product.chipset}'/>",
          cpuSpecs: "<c:out value='${product.cpuSpecs}'/>",
          ram: "<c:out value='${product.ram}'/>",
          storage: "<c:out value='${product.storage}'/>",
          battery: "<c:out value='${product.battery}'/>",
          simType: "<c:out value='${product.simType}'/>",
          os: "<c:out value='${product.os}'/>",
          nfcSupport: "<c:out value='${product.nfcSupport}'/>",
          onDeal: ${product.onDeal != null ? product.onDeal : false},
          dealPercentage: ${product.dealPercentage != null ? product.dealPercentage : 0},
          isActive: ${product.isActive != null ? product.isActive : true}
        };

        // Version products from server (cùng dòng series)
        const versionProductsData = [
          <c:forEach items="${versionProducts}" var="vp" varStatus="status">
          {
            id: ${vp.id},
            name: "<c:out value='${vp.name}'/>",
            price: ${vp.price},
            imageUrl: "<c:out value='${vp.imageUrl}'/>",
            imageUrls: [
              <c:forEach items="${vp.imageUrls}" var="imgUrl" varStatus="status">
                "<c:out value='${imgUrl}'/>"<c:if test="${!status.last}">,</c:if>
              </c:forEach>
            ],
            onDeal: ${vp.onDeal != null ? vp.onDeal : false},
            dealPercentage: ${vp.dealPercentage != null ? vp.dealPercentage : 0}
          }<c:if test="${!status.last}">,</c:if>
          </c:forEach>
        ];

        // Same brand products from server
        const sameProductsData = [
          <c:forEach items="${sameProducts}" var="sp" varStatus="status">
          {
            id: ${sp.id},
            name: "<c:out value='${sp.name}'/>",
            brand: "<c:out value='${sp.brand}'/>",
            price: ${sp.price},
            imageUrl: "<c:out value='${sp.imageUrl}'/>",
            imageUrls: [
              <c:forEach items="${sp.imageUrls}" var="imgUrl" varStatus="status">
                "<c:out value='${imgUrl}'/>"<c:if test="${!status.last}">,</c:if>
              </c:forEach>
            ],
            dealPercentage: ${sp.dealPercentage != null ? sp.dealPercentage : 0},
            category: {
              name: "<c:out value='${sp.category != null ? sp.category.name : "Chưa phân loại"}'/>"
            }
          }<c:if test="${!status.last}">,</c:if>
          </c:forEach>
        ];

        console.log('Product data from server:', productData);
        console.log('Version products:', versionProductsData);
        console.log('Same brand products:', sameProductsData);

              // Load product ngay lập tức
              displayProduct(productData);

              // Check if product is in wishlist
              checkWishlistStatus(productData.id);

        // Render version products (cùng dòng series) từ server data
        renderVersionProducts(versionProductsData);

        // Render same brand products từ server data
        renderSameProducts(sameProductsData);

        // Load and parse variants for storage and color options
        if (productData.category && productData.category.id) {
          loadAndParseVariants(productData.category.id, productData.id, productData.storage, productData.name);
        }
        // Load rating statistics and reviews
        loadRatingStatistics(productData.id);
        loadReviews(productData.id, 0);
        </c:if>

              <c:if test="${empty product}">
              showInlineAlert("Không tìm thấy sản phẩm", 'danger');
              setTimeout(() => window.location.href = ctx + '/shop', 2000);
              </c:if>

                function displayProduct(p) {
                  // Update breadcrumb
                  document.getElementById('breadcrumbName').textContent = p.name;

                  // Update product details
                  document.getElementById('productName').textContent = p.name;

                  // Hiển thị giá đã áp dụng deal
                  const priceEl = document.getElementById('productPrice');

                  if (p.onDeal === true && p.dealPercentage != null && p.dealPercentage > 0) {
                    // Tính giá sau khi giảm
                    const discountedPrice = p.price * (100 - p.dealPercentage) / 100;
                    const savedAmount = p.price - discountedPrice;

                    // Hiển thị giá đã giảm + giá gốc gạch ngang + badge giảm giá + tiền tiết kiệm
                    priceEl.innerHTML =
                      '<span style="color: #d70018; font-size: 28px; font-weight: bold;">' + formatPrice(discountedPrice) + '</span>' +
                      ' <del style="color: #999; font-size: 18px; margin-left: 10px;">' + formatPrice(p.price) + '</del>' +
                      ' <span style="color: #ff4444; font-size: 16px; margin-left: 10px; font-weight: bold; background: #ffe8e8; padding: 2px 8px; border-radius: 4px;">-' + p.dealPercentage + '%</span>' +
                      ' <span style="color: #28a745; font-size: 16px; margin-left: 10px; font-weight: bold; background: #e8f5e8; padding: 2px 8px; border-radius: 4px;">Tiết kiệm ' + formatPrice(savedAmount) + '</span>';

                    console.log('✅ Applied deal: ' + formatPrice(p.price) + ' → ' + formatPrice(discountedPrice) + ' (' + p.dealPercentage + '% off, save ' + formatPrice(savedAmount) + ')');
                  } else {
                    // Hiển thị giá gốc nếu không có deal
                    priceEl.innerHTML = '<span style="color: #d70018; font-size: 28px; font-weight: bold;">' + formatPrice(p.price) + '</span>';
                    console.log('No deal - showing original price: ' + formatPrice(p.price));
                  }

                  // Update stock status - check isActive first, then stock
                  if (p.isActive === false) {
                    // Ẩn phần stock status khi ngừng kinh doanh
                    document.getElementById('productStock').style.display = 'none';

                    // Thay đổi nút "Thêm vào giỏ hàng" thành "Ngừng kinh doanh" và vô hiệu hóa
                    const addToCartBtn = document.getElementById('addToCartBtn');
                    addToCartBtn.innerHTML = '<i class="fa fa-ban"></i> Ngừng kinh doanh';
                    addToCartBtn.disabled = true;
                    addToCartBtn.style.backgroundColor = '#999';
                    addToCartBtn.style.cursor = 'not-allowed';
                    addToCartBtn.style.opacity = '0.6';
                  } else {// Hiển thị lại stock status
                    document.getElementById('productStock').style.display = '';
                    document.getElementById('productStock').textContent = (p.stock > 0 ? 'Còn hàng' : 'Hết hàng');

                    const addToCartBtn = document.getElementById('addToCartBtn');

                    if (p.stock > 0) {
                      // Còn hàng → cho phép thêm
                      addToCartBtn.innerHTML = '<i class="fa fa-shopping-cart"></i> Thêm Vào Giỏ';
                      addToCartBtn.disabled = false;
                      addToCartBtn.style.backgroundColor = '';
                      addToCartBtn.style.cursor = 'pointer';
                      addToCartBtn.style.opacity = '1';
                    } else {
                      // Hết hàng → CHẶN hoàn toàn việc thêm vào giỏ
                      addToCartBtn.innerHTML = '<i class="fa fa-ban"></i> Hết hàng';
                      addToCartBtn.disabled = true;
                      addToCartBtn.style.backgroundColor = '#999';
                      addToCartBtn.style.cursor = 'not-allowed';
                      addToCartBtn.style.opacity = '0.6';

                      // Ngăn chặn hoàn toàn sự kiện click (phòng user dùng devtool bật lại nút)
                      addToCartBtn.onclick = function (e) {
                        e.preventDefault();
                        e.stopPropagation();
                        showInlineAlert('Sản phẩm đã hết hàng!', 'warning');
                        return false;
                      };
                    }
                  }

                  // Tạo short description từ specs cho phần product details
                  var shortDesc = '';

                  document.getElementById('productDescription').textContent = shortDesc;

                  // Load document description cho tab "Mô tả"
                  loadProductDocument(p.id);

                  // Update brand
                  if (p.brand) {
                    document.getElementById('productBrand').textContent = p.brand;
                  }

                  // Get all images
                  const imgs = p.imageUrls && p.imageUrls.length ? p.imageUrls : (p.imageUrl ? [p.imageUrl] : []);

                  // Update main images slider
                  const mainImgContainer = document.getElementById('product-main-img');
                  mainImgContainer.innerHTML = '';

                  if (imgs.length > 0) {
                    imgs.forEach((u) => {
                      const url = typeof u === 'string' ? u : u.url;
                      const mainDiv = document.createElement('div');
                      mainDiv.className = 'product-preview';
                      const mainImg = document.createElement('img');
                      mainImg.src = url.startsWith('/') ? ctx + url : url;
                      mainImg.alt = p.name;
                      mainDiv.appendChild(mainImg);
                      mainImgContainer.appendChild(mainDiv);
                    });
                  }

                  // Update thumbnails
                  const thumbsContainer = document.getElementById('product-imgs');
                  thumbsContainer.innerHTML = '';

                  if (imgs.length > 0) {
                    imgs.forEach((u, index) => {
                      const url = typeof u === 'string' ? u : u.url;
                      const thumbDiv = document.createElement('div');
                      thumbDiv.className = 'product-preview';
                      const thumbImg = document.createElement('img');
                      thumbImg.src = url.startsWith('/') ? ctx + url : url;
                      thumbImg.alt = p.name;
                      thumbImg.style.cursor = 'pointer';
                      thumbImg.dataset.index = index;
                      thumbDiv.appendChild(thumbImg);
                      thumbsContainer.appendChild(thumbDiv);
                    });
                  }

                  // Update specs in tab2
                  displaySpecs(p);

                  // Initialize slick carousel for product images
                  setTimeout(() => {
                    if (typeof $.fn.slick !== 'undefined') {
                      // Destroy existing slick instances if any
                      if ($('#product-main-img').hasClass('slick-initialized')) {
                        $('#product-main-img').slick('unslick');
                      }
                      if ($('#product-imgs').hasClass('slick-initialized')) {
                        $('#product-imgs').slick('unslick');
                      }

                      $('#product-main-img').slick({
                        infinite: true,
                        speed: 300,
                        slidesToShow: 1,
                        arrows: false,
                        fade: true,
                        asNavFor: '#product-imgs'
                      });

                      $('#product-imgs').slick({
                        slidesToShow: 3,
                        slidesToScroll: 1,
                        arrows: true,
                        vertical: true,
                        verticalSwiping: true,
                        focusOnSelect: true,
                        asNavFor: '#product-main-img',
                        responsive: [{
                          breakpoint: 991,
                          settings: {
                            vertical: false,
                            slidesToShow: 4
                          }
                        }]
                      });
                    }
                  }, 100);

                  // Setup add to cart button
                  document.getElementById('addToCartBtn').addEventListener('click', () => {
                    // Kiểm tra xem sản phẩm có đang ngừng kinh doanh không
                    if (p.isActive === false) {
                      showInlineAlert('Sản phẩm này hiện đang ngừng kinh doanh!', 'warning');
                      return;
                    }

                    const quantity = parseInt(document.getElementById('quantity').value) || 1;
                    addToCart(p.id, quantity);
                  });

                  // Setup add to wishlist button
                  document.getElementById('addToWishlistBtn').addEventListener('click', (e) => {
                    e.preventDefault();
                    addToWishlist(p.id);
                  });
                }

                function displaySpecs(p) {
                  const specsContainer = document.getElementById('specsContent');
                  const specs = [];

                  // Collect all specs
                  if (p.brand) specs.push({ key: 'Thương hiệu', value: p.brand });
                  if (p.screenSize) specs.push({ key: 'Kích thước màn hình', value: p.screenSize });
                  if (p.displayTech) specs.push({ key: 'Công nghệ màn hình', value: p.displayTech });
                  if (p.resolution) specs.push({ key: 'Độ phân giải', value: p.resolution });
                  if (p.displayFeatures) specs.push({ key: 'Tính năng màn hình', value: p.displayFeatures });
                  if (p.rearCamera) specs.push({ key: 'Camera sau', value: p.rearCamera });
                  if (p.frontCamera) specs.push({ key: 'Camera trước', value: p.frontCamera });
                  if (p.chipset) specs.push({ key: 'Chipset', value: p.chipset });
                  if (p.cpuSpecs) specs.push({ key: 'CPU', value: p.cpuSpecs });
                  if (p.ram) specs.push({ key: 'RAM', value: p.ram });
                  if (p.storage) specs.push({ key: 'Bộ nhớ trong', value: p.storage });
                  if (p.battery) specs.push({ key: 'Pin', value: p.battery });
                  if (p.simType) specs.push({ key: 'Loại SIM', value: p.simType });
                  if (p.os) specs.push({ key: 'Hệ điều hành', value: p.os });
                  if (p.nfcSupport) specs.push({ key: 'Hỗ trợ NFC', value: p.nfcSupport });

                  // Add custom specs
                  if (p.specs && Array.isArray(p.specs)) {
                    p.specs.forEach(s => {
                      if (s && s.key) specs.push({ key: s.key, value: s.value });
                    });
                  }

                  if (specs.length > 0) {
                    let html = '<table class="table table-striped">';
                    specs.forEach(spec => {
                      html += '<tr>';
                      html += '<td style="width: 40%; font-weight: 500;">' + spec.key + '</td>';
                      html += '<td>' + (spec.value || '') + '</td>';
                      html += '</tr>';
                    });
                    html += '</table>';
                    specsContainer.innerHTML = html;
                  } else {
                    specsContainer.innerHTML = '<p>Chưa có thông số kỹ thuật.</p>';
                  }
                }

                function formatPrice(price) {
                  if (!price) return '0 ₫';
                  return price.toLocaleString('vi-VN') + ' ₫';
                }

                async function addToCart(productId, quantity) {
                  // Check if user is logged in
                  if (!isUserLoggedIn) {
                    window.location.href = ctx + '/login';
                    return;
                  }

                  try {
                    const response = await fetch(ctx + '/api/cart/add', {
                      method: 'POST',
                      headers: {
                        'Content-Type': 'application/json'
                      },
                      credentials: 'include',
                      body: JSON.stringify({ productId: productId, quantity: quantity })
                    });

                    if (response.ok) {
                      // Update cart count in header
                      if (typeof updateGlobalCartCount === 'function') {
                        updateGlobalCartCount();
                      }
                    } else if (response.status === 401 || response.status === 403) {
                      window.location.href = ctx + '/login';
                    } else {
                      showInlineAlert('Có lỗi xảy ra. Vui lòng thử lại.', 'danger');
                    }
                  } catch (error) {
                    console.error('Error adding to cart:', error);
                    showInlineAlert('Có lỗi xảy ra. Vui lòng thử lại.', 'danger');
                  }
                }

                async function addToWishlist(productId) {
                  try {
                    var btn = document.getElementById('addToWishlistBtn');
                    var icon = btn.querySelector('i');
                    var isInWishlist = icon.classList.contains('fa-heart');

                    var url = isInWishlist
                      ? ctx + '/api/favorite/remove/' + productId
                      : ctx + '/api/favorite/add';
                    var method = isInWishlist ? 'DELETE' : 'POST';
                    var body = isInWishlist ? null : JSON.stringify({ productId: productId });

                    const response = await fetch(url, {
                      method: method,
                      headers: {
                        'Content-Type': 'application/json'
                      },
                      credentials: 'include',
                      body: body
                    });

                    if (response.ok) {
                      if (isInWishlist) {
                        // Remove from wishlist
                        icon.classList.remove('fa-heart');
                        icon.classList.add('fa-heart-o');
                        btn.style.color = '';
                      } else {
                        // Add to wishlist
                        icon.classList.remove('fa-heart-o');
                        icon.classList.add('fa-heart');
                        btn.style.color = '#d70018';
                      }
                      // Update wishlist count in header
                      if (typeof updateGlobalWishlistCount === 'function') {
                        updateGlobalWishlistCount();
                      }
                    } else if (response.status === 401 || response.status === 403) {
                      window.location.href = ctx + '/login';
                    } else {
                      showInlineAlert('Có lỗi xảy ra. Vui lòng thử lại.', 'danger');
                    }
                  } catch (error) {
                    console.error('Error toggling wishlist:', error);
                    showInlineAlert('Có lỗi xảy ra. Vui lòng thử lại.', 'danger');
                  }
                }

                function checkWishlistStatus(productId) {
                  // Check if this product is in wishlist
                  fetch(ctx + '/api/favorite', {
                    credentials: 'include'
                  })
                    .then(res => res.ok ? res.json() : [])
                    .then(favorites => {
                      const isInWishlist = favorites.some(fav => fav.productId == productId);
                      if (isInWishlist) {
                        var btn = document.getElementById('addToWishlistBtn');
                        if (btn) {
                          var icon = btn.querySelector('i');
                          icon.classList.remove('fa-heart-o');
                          icon.classList.add('fa-heart');
                          btn.style.color = '#d70018';
                        }
                      }
                    })
                    .catch(err => console.error('Error checking wishlist status:', err));
                }

                async function loadRelatedProducts(categoryId) {
                  if (!categoryId) {
                    console.log('No categoryId provided for related products');
                    return;
                  }

                  try {
                    console.log('Loading related products for category:', categoryId);
                    const response = await fetch(ctx + '/api/products?categoryId=' + categoryId + '&limit=4');

                    console.log('Response status:', response.status);

                    if (!response.ok) {
                      console.error('Failed to fetch related products:', response.status, response.statusText);
                      return;
                    }

                    const products = await response.json();
                    console.log('Related products loaded:', products);

                    const container = document.getElementById('relatedProducts');

                    if (!products || products.length === 0) {
                      console.log('No related products found');
                      container.innerHTML = '<div class="col-md-12"><p class="text-center">Không có sản phẩm liên quan</p></div>';
                      return;
                    }

                    container.innerHTML = '';
                    products.slice(0, 4).forEach(product => {
                      const categoryName = product.category ? product.category.name : 'Chưa phân loại';
                      const imgSrc = product.imageUrl ? ctx + product.imageUrl : ctx + '/images/no-image.png';
                      const discountLabel = (product.dealPercentage && product.dealPercentage > 0)
                        ? '<div class="product-label" style="position:absolute;top:10px;right:10px;z-index:2;">'
                        + '<span class="sale" style="background:#c50b12;color:#fff;padding:4px 6px;border-radius:4px;font-weight:700;box-shadow:0 1px 0 rgba(0,0,0,0.08);border:none;animation:pulse 2s infinite;">-' + product.dealPercentage + '%</span>'
                        + '<span class="new" style="background:#ff3b5c;color:#fff;padding:4px 6px;border-radius:4px;font-weight:700;box-shadow:0 1px 0 rgba(0,0,0,0.08);border:none;animation:pulse 2s infinite;margin-left:6px;">HOT</span>'
                        + '</div>'
                        : '';

                      const productHtml = '<div class="col-md-3 col-xs-6">' +
                        '<div class="product">' +
                        '<div class="product-img">' +
                        '<img src="' + imgSrc + '" alt="' + product.name + '">' +
                        discountLabel +
                        '</div>' +
                        '<div class="product-body">' +
                        '<p class="product-category">' + categoryName + '</p>' +
                        '<h3 class="product-name"><a href="' + ctx + '/product/' + product.id + '">' + product.name + '</a></h3>' +
                        '<h4 class="product-price">' + formatPrice(product.price) + '</h4>' +
                        '<div class="product-rating" id="rating-same-' + product.id + '">' +
                        '<i class="fa fa-star-o"></i>' +
                        '<i class="fa fa-star-o"></i>' +
                        '<i class="fa fa-star-o"></i>' +
                        '<i class="fa fa-star-o"></i>' +
                        '<i class="fa fa-star-o"></i>' +
                        '</div>' +
                        '<div class="product-btns">' +
                        '<button class="add-to-wishlist" data-product-id="' + product.id + '" onclick="toggleRelatedWishlist(' + product.id + ', this)"><i class="fa fa-heart-o"></i><span class="tooltipp">Yêu thích</span></button>' +
                        '<button class="quick-view" onclick="window.location.href=\'' + ctx + '/product/' + product.id + '\'"><i class="fa fa-eye"></i><span class="tooltipp">Xem chi tiết</span></button>' +
                        '</div>' +
                        '</div>' +
                        '<div class="add-to-cart">' +
                        '<button class="add-to-cart-btn" onclick="addToCart(' + product.id + ', 1)"><i class="fa fa-shopping-cart"></i> Thêm vào giỏ</button>' +
                        '</div>' +
                        '</div>' +
                        '</div>';

                      container.innerHTML += productHtml;
                    });

                    // Load wishlist status for related products only if user is logged in
                    if (isUserLoggedIn) {
                      loadRelatedWishlistStatus();
                    }
                  } catch (error) {
                    console.error('Error loading related products:', error);
                  }
                }

                // Render version products (cùng dòng series) từ dữ liệu server
                function renderVersionProducts(products) {
                  const container = document.getElementById('versionProducts');

                  if (!products || products.length === 0) {
                    container.innerHTML = '<p class="text-center" style="padding:20px;">Không có sản phẩm tương tự</p>';
                    return;
                  }

                  container.innerHTML = '';
                  products.slice(0, 5).forEach(product => {
                    let imgSrc = ctx + '/images/no-image.png';
                    if (product.imageUrls && product.imageUrls.length > 0 && product.imageUrls[0]) {
                      imgSrc = ctx + product.imageUrls[0];
                    } else if (product.imageUrl) {
                      imgSrc = ctx + product.imageUrl;
                    }

                    // Tính giá giảm và số tiền tiết kiệm
                    let priceHtml = '';
                    if (product.onDeal === true && product.dealPercentage && product.dealPercentage > 0) {
                      const discountedPrice = product.price * (100 - product.dealPercentage) / 100;
                      const savedAmount = product.price - discountedPrice;
                      priceHtml = '<h4 class="product-price" style="font-size: 14px; margin: 5px 0; line-height: 1.6;">' +
                        '<span style="color: #d70018; font-weight: bold; font-size: 15px; display: block; margin-bottom: 3px;">' + formatPrice(discountedPrice) + '</span>' +
                        '<span style="display: block; margin-bottom: 3px;">' +
                        '<del style="color: #999; font-size: 12px;">' + formatPrice(product.price) + '</del> ' +
                        '<span style="color: #ff4444; font-size: 11px; font-weight: bold; background: #ffe8e8; padding: 1px 4px; border-radius: 2px; margin-left: 3px;">-' + product.dealPercentage + '%</span>' +
                        '</span>' +
                        '<span style="color: #28a745; font-size: 11px; font-weight: bold; background: #e8f5e8; padding: 1px 4px; border-radius: 2px; display: inline-block;">Tiết kiệm ' + formatPrice(savedAmount) + '</span>' +
                        '</h4>';
                    } else {
                      priceHtml = '<h4 class="product-price" style="font-size: 15px; color: #d70018; font-weight: bold; margin: 5px 0;">' + formatPrice(product.price) + '</h4>';
                    }

                    const productHtml =
                      '<div class="product-widget" style="margin-bottom: 15px; position:relative;">' +
                      '<div class="product-img" style="width: 60px; float: left; margin-right: 15px; position:relative;">' +
                      '<img src="' + imgSrc + '" alt="' + product.name + '" style="width:100%; border-radius:4px;">' +
                      '</div>' +
                      '<div class="product-body">' +
                      '<h3 class="product-name" style="font-size: 14px; margin: 0 0 5px;"><a href="' + ctx + '/product/' + product.id + '">' + product.name + '</a></h3>' +
                      priceHtml +
                      '</div>' +
                      '<div style="clear:both;"></div>' +
                      '</div>';
                    container.innerHTML += productHtml;
                  });
                }

                // Render same brand products cho phần dưới từ dữ liệu server
                function renderSameProducts(products) {
                  const container = document.getElementById('sameProducts');

                  if (!products || products.length === 0) {
                    container.innerHTML = '<div class="col-md-12"><p class="text-center">Không có sản phẩm cùng hãng</p></div>';
                    return;
                  }

                  // Destroy existing slick if any
                  if (typeof jQuery !== 'undefined' && jQuery(container).hasClass('slick-initialized')) {
                    jQuery(container).slick('unslick');
                  }

                  container.innerHTML = '';

                  // Render ALL products (không giới hạn 4)
                  products.forEach(product => {
                    const brandName = product.brand || 'Chưa xác định';
                    let imgSrc = ctx + '/images/no-image.png';
                    if (product.imageUrls && product.imageUrls.length > 0 && product.imageUrls[0]) {
                      imgSrc = ctx + product.imageUrls[0];
                    } else if (product.imageUrl) {
                      imgSrc = ctx + product.imageUrl;
                    }
                    const discountLabel = (product.dealPercentage && product.dealPercentage > 0)
                      ? '<div class="product-label" style="position:absolute;top:10px;right:10px;z-index:2;">'
                      + '<span class="sale" style="background:#c50b12;color:#fff;padding:4px 6px;border-radius:4px;font-weight:700;box-shadow:0 1px 0 rgba(0,0,0,0.08);border:none;animation:pulse 2s infinite;">-' + product.dealPercentage + '%</span>'
                      + '<span class="new" style="background:#ff3b5c;color:#fff;padding:4px 6px;border-radius:4px;font-weight:700;box-shadow:0 1px 0 rgba(0,0,0,0.08);border:none;animation:pulse 2s infinite;margin-left:6px;">HOT</span>'
                      + '</div>'
                      : '';

                    // Tính giá giảm và số tiền tiết kiệm
                    let priceHtml = '';
                    if (product.dealPercentage && product.dealPercentage > 0) {
                      const discountedPrice = product.price * (100 - product.dealPercentage) / 100;
                      const savedAmount = product.price - discountedPrice;
                      priceHtml = '<h4 class="product-price">' +
                        '<div style="color: #d70018; font-size: 18px; font-weight: bold;">' + formatPrice(discountedPrice) + '</div>' +
                        '<div style="color: #999; font-size: 14px; margin: 3px 0;"><del>' + formatPrice(product.price) + '</del></div>' +
                        '<div style="margin: 2px 0;"><span style="color: #ff4444; font-size: 12px; font-weight: bold; background: #ffe8e8; padding: 1px 5px; border-radius: 3px;">-' + product.dealPercentage + '%</span></div>' +
                        '<div style="margin-top: 3px;"><span style="color: #28a745; font-size: 12px; font-weight: bold; background: #e8f5e8; padding: 1px 5px; border-radius: 3px;">Tiết kiệm ' + formatPrice(savedAmount) + '</span></div>' +
                        '</h4>';
                    } else {
                      priceHtml = '<h4 class="product-price">' + formatPrice(product.price) + '</h4>';
                    }

                    const productHtml = '<div>' + // Slick carousel item wrapper
                      '<div class="product">' +
                      '<div class="product-img">' +
                      '<img src="' + imgSrc + '" alt="' + product.name + '">' +
                      discountLabel +
                      '</div>' +
                      '<div class="product-body">' +
                      '<p class="product-category">' + brandName + '</p>' +
                      '<h3 class="product-name"><a href="' + ctx + '/product/' + product.id + '">' + product.name + '</a></h3>' +
                      priceHtml +
                      '<div class="product-rating" id="rating-same-' + product.id + '">' +
                      '<i class="fa fa-star-o"></i>' +
                      '<i class="fa fa-star-o"></i>' +
                      '<i class="fa fa-star-o"></i>' +
                      '<i class="fa fa-star-o"></i>' +
                      '<i class="fa fa-star-o"></i>' +
                      '</div>' +
                      '<div class="product-btns">' +
                      '<button class="add-to-wishlist" data-product-id="' + product.id + '" onclick="toggleRelatedWishlist(' + product.id + ', this)"><i class="fa fa-heart-o"></i><span class="tooltipp">Yêu thích</span></button>' +
                      '<button class="quick-view" onclick="window.location.href=\'' + ctx + '/product/' + product.id + '\'"><i class="fa fa-eye"></i><span class="tooltipp">Xem chi tiết</span></button>' +
                      '</div>' +
                      '</div>' +
                      '<div class="add-to-cart">' +
                      '<button class="add-to-cart-btn" onclick="addToCart(' + product.id + ', 1)"><i class="fa fa-shopping-cart"></i> Thêm vào giỏ</button>' +
                      '</div>' +
                      '</div>' +
                      '</div>'; // Close slick item wrapper

                    container.innerHTML += productHtml;
                  });

                  // Initialize Slick Carousel với autoplay
                  setTimeout(() => {
                    if (typeof jQuery !== 'undefined' && typeof jQuery.fn.slick !== 'undefined') {
                      jQuery(container).slick({
                        infinite: true,
                        speed: 500,
                        slidesToShow: 4,
                        slidesToScroll: 1,
                        autoplay: true,
                        autoplaySpeed: 3000,
                        pauseOnHover: true,
                        pauseOnFocus: true,
                        arrows: true,
                        dots: false,
                        responsive: [
                          {
                            breakpoint: 991,
                            settings: {
                              slidesToShow: 3,
                              slidesToScroll: 1
                            }
                          },
                          {
                            breakpoint: 767,
                            settings: {
                              slidesToShow: 2,
                              slidesToScroll: 1
                            }
                          },
                          {
                            breakpoint: 480,
                            settings: {
                              slidesToShow: 1,
                              slidesToScroll: 1
                            }
                          }
                        ]
                      });
                    } else {
                      console.error('jQuery or Slick carousel not loaded');
                    }
                  }, 500); // Tăng timeout lên 500ms để đảm bảo jQuery đã load

                  // Load wishlist status if user is logged in
                  if (isUserLoggedIn) {
                    loadRelatedWishlistStatus();
                  }

                  // Load rating cho các sản phẩm cùng hãng
                  loadSameProductsRatings(products);
                }

                // Load rating cho tất cả sản phẩm cùng hãng
                function loadSameProductsRatings(products) {
                  if (!products || products.length === 0) return;

                  products.forEach(product => {
                    loadProductRatingForSameProducts(product.id);
                  });
                }

                // Load rating cho một sản phẩm cụ thể trong phần sản phẩm cùng hãng
                async function loadProductRatingForSameProducts(productId) {
                  try {
                    const response = await fetch(ctx + '/api/reviews/product/' + productId + '/stats');

                    if (!response.ok) {
                      console.error('Failed to load rating for product ' + productId);
                      return;
                    }

                    const stats = await response.json();

                    // Update rating stars cho sản phẩm này
                    displayStarsForSameProduct('rating-same-' + productId, stats.averageRating);
                  } catch (error) {
                    console.error('Error loading rating for product ' + productId + ':', error);
                  }
                }

                // Hiển thị stars dựa trên rating value cho sản phẩm cùng hãng
                function displayStarsForSameProduct(elementId, rating) {
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

                // Toggle wishlist for related products
                async function toggleRelatedWishlist(productId, button) {
                  // Check if user is logged in
                  if (!isUserLoggedIn) {
                    window.location.href = ctx + '/login';
                    return;
                  }

                  try {
                    var icon = button.querySelector('i');
                    var isInWishlist = icon.classList.contains('fa-heart');

                    var url = isInWishlist
                      ? ctx + '/api/favorite/remove/' + productId
                      : ctx + '/api/favorite/add';
                    var method = isInWishlist ? 'DELETE' : 'POST';
                    var body = isInWishlist ? null : JSON.stringify({ productId: productId });

                    const response = await fetch(url, {
                      method: method,
                      headers: {
                        'Content-Type': 'application/json'
                      },
                      credentials: 'include',
                      body: body
                    });

                    if (response.ok) {
                      if (isInWishlist) {
                        // Remove from wishlist
                        icon.classList.remove('fa-heart');
                        icon.classList.add('fa-heart-o');
                        button.style.color = '';
                      } else {
                        // Add to wishlist
                        icon.classList.remove('fa-heart-o');
                        icon.classList.add('fa-heart');
                        button.style.color = '#d70018';
                      }
                      // Update wishlist count in header
                      if (typeof updateGlobalWishlistCount === 'function') {
                        updateGlobalWishlistCount();
                      }
                    } else if (response.status === 401 || response.status === 403) {
                      window.location.href = ctx + '/login';
                    } else {
                      showInlineAlert('Có lỗi xảy ra. Vui lòng thử lại.', 'danger');
                    }
                  } catch (error) {
                    console.error('Error toggling wishlist:', error);
                    showInlineAlert('Có lỗi xảy ra. Vui lòng thử lại.', 'danger');
                  }
                }

                // Load wishlist status for related products
                function loadRelatedWishlistStatus() {
                  fetch(ctx + '/api/favorite', {
                    credentials: 'include'
                  })
                    .then(res => res.ok ? res.json() : [])
                    .then(favorites => {
                      favorites.forEach(favorite => {
                        var buttons = document.querySelectorAll('.add-to-wishlist[data-product-id="' + favorite.productId + '"]');
                        buttons.forEach(button => {
                          var icon = button.querySelector('i');
                          if (icon) {
                            icon.classList.remove('fa-heart-o');
                            icon.classList.add('fa-heart');
                            button.style.color = '#d70018';
                          }
                        });
                      });
                    })
                    .catch(err => console.error('Error loading wishlist status:', err));
                }

                // ==================== VARIANT PARSING FUNCTIONS ====================

                /**
                 * Parse product variants from versionProducts
                 * Storage from product.storage field, Color parsed from product.name
                 */
                async function loadAndParseVariants(categoryId, currentProductId, currentProductStorage, currentProductName) {
                  if (!categoryId) return;

                  try {
                    const response = await fetch(ctx + '/api/products?categoryId=' + categoryId);
                    if (!response.ok) return;

                    const products = await response.json();

                    // Extract current product's model name
                    const currentModel = extractModelName(currentProductName);
                    console.log('Current product:', currentProductName, '→ Model:', currentModel);

                    // Filter: only products with SAME MODEL (not just same category)
                    const variants = products.filter(p => {
                      if (p.id == currentProductId) return false; // Exclude current product
                      const productModel = extractModelName(p.name);
                      console.log('  Checking:', p.name, '→ Model:', productModel, '→ Match:', productModel === currentModel);
                      return productModel === currentModel; // Only same model variants
                    });

                    console.log('Found variants:', variants.length);

                    if (variants.length === 0) {
                      // Hide variant sections if no variants
                      document.getElementById('storageVariants').style.display = 'none';
                      return;
                    }

                    // Extract storages only (no color variants)
                    const storageSet = new Set();
                    const variantMap = new Map(); // Map to store product details by storage

                    // Add current product first
                    if (currentProductStorage) storageSet.add(currentProductStorage);
                    variantMap.set(currentProductStorage, {
                      id: currentProductId,
                      name: currentProductName,
                      storage: currentProductStorage,
                      isCurrent: true
                    });

                    // Parse all variants (same model only)
                    variants.forEach(product => {
                      const storage = product.storage; // Use storage field directly

                      if (storage) storageSet.add(storage);

                      variantMap.set(storage, {
                        id: product.id,
                        name: product.name,
                        storage: storage,
                        price: product.price,
                        isCurrent: false
                      });
                    });

                    // Sort storages by capacity
                    const storages = Array.from(storageSet).sort((a, b) => {
                      const sizeA = parseInt(a);
                      const sizeB = parseInt(b);
                      return sizeA - sizeB;
                    });

                    // Render storage options only
                    renderStorageOptions(storages, currentProductStorage, variantMap);

                  } catch (error) {
                    console.error('Error loading variants:', error);
                  }
                }

                /**
                 * Extract model name from product name
                 * Returns the base model without storage/color (e.g., "iPhone 15 Pro Max")
                 */
                function extractModelName(productName) {
                  // Remove storage variants (128GB, 256GB, 512GB, 1TB, 2TB, etc.)
                  let modelName = productName.replace(/\s*\d+\s*(GB|TB)\s*/gi, '').trim();

                  // Remove color variants (common color words at the end)
                  const colorPatterns = [
                    /\s+(Đen|Trắng|Xanh|Đỏ|Vàng|Hồng|Tím|Xám|Bạc|Vang|Titan|Gold|Silver|Black|White|Blue|Red|Pink|Purple|Gray|Green|Midnight|Starlight|Sierra|Natural)(\s+\w+)?$/i,
                    /\s+\(.*\)$/  // Remove anything in parentheses at end
                  ];

                  colorPatterns.forEach(pattern => {
                    modelName = modelName.replace(pattern, '').trim();
                  });

                  return modelName;
                }

                /**
                 * Render storage option buttons
                 */
                function renderStorageOptions(storages, currentStorage, variantMap) {
                  const container = document.querySelector('#storageVariants .variant-options');
                  if (!storages || storages.length === 0) {
                    document.getElementById('storageVariants').style.display = 'none';
                    return;
                  }

                  container.innerHTML = '';
                  storages.forEach(storage => {
                    const variant = variantMap.get(storage);
                    const isSelected = storage === currentStorage;
                    const isAvailable = variant && !variant.isCurrent;

                    const button = document.createElement('button');
                    button.className = 'variant-btn' + (isSelected ? ' selected' : '');
                    button.textContent = storage;
                    button.style.cssText = `
                            padding: 10px 20px;
                            border: 2px solid \${isSelected ? '#d70018' : '#ddd'};
                            border-radius: 6px;
                            background: \${isSelected ? '#d70018' : 'white'};
                            color: \${isSelected ? 'white' : '#333'};
                            font-weight: \${isSelected ? 'bold' : 'normal'};
                            cursor: \${isAvailable ? 'pointer' : 'default'};
                            transition: all 0.3s;
                            opacity: \${isAvailable ? '1' : '0.6'};
                          `;

                    if (isAvailable) {
                      button.onclick = () => window.location.href = ctx + '/product/' + variant.id;
                      button.onmouseover = () => {
                        if (!isSelected) {
                          button.style.borderColor = '#d70018';
                          button.style.background = '#fff5f5';
                        }
                      };
                      button.onmouseout = () => {
                        if (!isSelected) {
                          button.style.borderColor = '#ddd';
                          button.style.background = 'white';
                        }
                      };
                    }

                    if (isSelected) {
                      const checkmark = document.createElement('i');
                      checkmark.className = 'fa fa-check';
                      checkmark.style.marginLeft = '5px';
                      button.appendChild(checkmark);
                    }

                    container.appendChild(button);
                  });
                }

                //====================== DOCUMENT FUNCTIONS ==========================================================================================================//
                async function loadProductDocument(productId) {
                  try {
                    const apiUrl = ctx + '/api/documents/product/' + productId;
                    console.log('=== LOADING DOCUMENT ===');
                    console.log('API URL:', apiUrl);
                    console.log('Product ID:', productId);

                    const response = await fetch(apiUrl);
                    console.log('Response status:', response.status);
                    console.log('Response OK:', response.ok);

                    if (!response.ok) {
                      console.warn('No document found - Status:', response.status);
                      document.getElementById('tabDescription').innerHTML =
                        '<p style="color: #999;">Chưa có mô tả chi tiết cho sản phẩm này. <br><small>Vui lòng tạo document cho sản phẩm này trong trang admin.</small></p>';
                      hideToggleButton();
                      return;
                    }

                    const docData = await response.json();
                    console.log('=== DOCUMENT DATA ===');
                    console.log('Document ID:', docData.id);
                    console.log('Document Title:', docData.title);
                    console.log('Document Product ID:', docData.productId);
                    console.log('Description exists:', !!docData.description);
                    console.log('Description length:', docData.description ? docData.description.length : 0);
                    console.log('Description preview:', docData.description ? docData.description.substring(0, 100) : 'N/A');

                    const tabDescElement = document.getElementById('tabDescription');
                    console.log('Tab element found:', !!tabDescElement);

                    // Hiển thị document description vào tab Mô tả
                    if (docData.description && docData.description.trim()) {
                      tabDescElement.innerHTML = docData.description;
                      console.log('=== HTML INJECTED ===');
                      console.log('Tab innerHTML length:', tabDescElement.innerHTML.length);
                      console.log('Tab visible:', tabDescElement.offsetHeight > 0);

                      // Fix all images to have proper styling and remove resize handles
                      setTimeout(() => {
                        // Remove all resize handles from img-wrapper and table-wrapper
                        const resizeHandles = tabDescElement.querySelectorAll('.resize-handle');
                        console.log('Found resize handles:', resizeHandles.length);
                        resizeHandles.forEach(handle => {
                          handle.remove();
                          console.log('Removed resize handle');
                        });

                        // Fix images
                        const images = tabDescElement.querySelectorAll('img');
                        console.log('Found images in description:', images.length);
                        images.forEach((img, index) => {
                          console.log('Image', index, '- Has style.maxWidth:', !!img.style.maxWidth);
                          console.log('Image', index, '- Current src:', img.src);

                          // Force max-width on all images
                          img.style.maxWidth = '100%';
                          img.style.height = 'auto';
                          img.style.display = 'block';
                          img.style.margin = '15px auto';
                          console.log('Applied styles to image', index);

                          // If image is in wrapper, unwrap it for better display
                          const wrapper = img.parentElement;
                          if (wrapper && wrapper.classList.contains('img-wrapper')) {
                            console.log('Image is in wrapper, keeping wrapper but removing resize handle');
                            // Wrapper is OK, just make sure it has proper styles
                            wrapper.style.maxWidth = '100%';
                            wrapper.style.width = '100%';
                            wrapper.style.display = 'block';
                            wrapper.style.margin = '15px auto';
                          }
                        });
                      }, 100);

                      // Setup toggle button AFTER images are processed
                      setTimeout(() => {
                        setupDescriptionToggle();
                      }, 300);
                    } else {
                      console.warn('Document exists but description is empty');
                      tabDescElement.innerHTML =
                        '<p style="color: #999;">Document tồn tại nhưng chưa có nội dung mô tả.</p>';
                      hideToggleButton();
                    }
                  } catch (error) {
                    console.error('=== ERROR ===');
                    console.error('Error:', error.message);
                    console.error('Stack:', error.stack);
                    document.getElementById('tabDescription').innerHTML =
                      '<p style="color: #999;">Lỗi khi tải mô tả: ' + error.message + '</p>';
                    hideToggleButton();
                  }
                }

                // Setup toggle button for description
                function setupDescriptionToggle() {
                  const descElement = document.getElementById('tabDescription');
                  const toggleBtn = document.getElementById('toggleDescriptionBtn');

                  if (!descElement || !toggleBtn) {
                    console.warn('Description element or toggle button not found');
                    return;
                  }

                  console.log('=== SETUP TOGGLE BUTTON ===');

                  // Force recalculate height after images load
                  const images = descElement.querySelectorAll('img');
                  const totalImages = images.length;

                  console.log('Total images to wait for:', totalImages);

                  // Setup button immediately, don't wait for images
                  setupToggleButton();

                  // Also recalculate after images load (for better accuracy)
                  if (totalImages > 0) {
                    let imagesLoaded = 0;

                    function checkImageLoaded() {
                      imagesLoaded++;
                      console.log(`Image loaded: ${imagesLoaded}/${totalImages}`);

                      if (imagesLoaded === totalImages) {
                        console.log('All images loaded, recalculating height');
                        // Recalculate height after all images loaded
                        const fullHeight = descElement.scrollHeight;
                        console.log('Updated full height:', fullHeight);
                      }
                    }

                    images.forEach((img, index) => {
                      if (img.complete) {
                        console.log(`Image ${index} already loaded`);
                        checkImageLoaded();
                      } else {
                        img.addEventListener('load', checkImageLoaded);
                        img.addEventListener('error', () => {
                          console.warn(`Image ${index} failed to load`);
                          checkImageLoaded();
                        });
                      }
                    });
                  }

                  function setupToggleButton() {
                    // Get full height of content
                    const fullHeight = descElement.scrollHeight;
                    console.log('Initial description full height:', fullHeight);

                    // Always show toggle button if there's content
                    if (fullHeight > 0) {
                      toggleBtn.style.display = 'inline-block';
                      console.log('Toggle button displayed');

                      // Add click event
                      toggleBtn.onclick = function () {
                        if (descElement.classList.contains('collapsed')) {
                          // Expand - show full content
                          descElement.classList.remove('collapsed');
                          // Use 'none' to remove max-height limit completely
                          descElement.style.maxHeight = 'none';
                          toggleBtn.innerHTML = '<i class="fa fa-angle-up"></i> Thu gọn mô tả';
                          console.log('Expanded description');
                        } else {
                          // Collapse - hide all content
                          descElement.classList.add('collapsed');
                          descElement.style.maxHeight = '135px';
                          toggleBtn.innerHTML = '<i class="fa fa-angle-down"></i> Xem mô tả chi tiết';
                          console.log('Collapsed description');

                          // Scroll to toggle button
                          toggleBtn.scrollIntoView({ behavior: 'smooth', block: 'center' });
                        }
                      };
                    } else {
                      // No content, hide button
                      console.warn('No content height, hiding button');
                      hideToggleButton();
                    }
                  }
                }

                // Hide toggle button
                function hideToggleButton() {
                  const toggleBtn = document.getElementById('toggleDescriptionBtn');
                  if (toggleBtn) {
                    toggleBtn.style.display = 'none';
                  }
                }

                // ==================== REVIEW AND RATING FUNCTIONS ====================

                let currentReviewPage = 0;
                const reviewsPerPage = 10;

                // Load rating statistics
                async function loadRatingStatistics(productId) {
                  try {
                    const response = await fetch(ctx + '/api/reviews/product/' + productId + '/stats');
                    if (!response.ok) {
                      console.error('Failed to load rating statistics');
                      return;
                    }

                    const stats = await response.json();

                    console.log('Rating statistics:', stats);

                    // Update average rating
                    document.getElementById('avgRating').textContent = stats.averageRating.toFixed(1);

                    // Update rating stars in tab3
                    displayStars('avgRatingStars', stats.averageRating);

                    // Update rating stars in product details (top section)
                    displayStars('productRating', stats.averageRating);

                    // Update total reviews text
                    document.getElementById('totalReviewsText').textContent = stats.totalReviews + ' đánh giá';

                    // Update review link in product details
                    const reviewLink = document.getElementById('reviewLink');
                    if (reviewLink) {
                      reviewLink.textContent = stats.totalReviews + ' đánh giá | Viết đánh giá';
                    }

                    // Update tab title with review count
                    const tab3Link = document.querySelector('a[href="#tab3"]');
                    if (tab3Link) {
                      tab3Link.textContent = 'Đánh giá (' + stats.totalReviews + ')';
                    }

                    // Update rating distribution
                    displayRatingDistribution(stats.ratingDistribution, stats.totalReviews);
                  } catch (error) {
                    console.error('Error loading rating statistics:', error);
                  }
                }

                // Display stars based on rating value
                function displayStars(elementId, rating) {
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

                // Display rating distribution
                function displayRatingDistribution(distribution, total) {
                  const container = document.getElementById('ratingDistribution');
                  if (!container) return;

                  let html = '';
                  for (let i = 5; i >= 1; i--) {
                    const count = distribution[i - 1];
                    const percentage = total > 0 ? (count / total * 100) : 0;

                    html += '<li>';
                    html += '<div class="rating-stars">';
                    for (let j = 0; j < 5; j++) {
                      html += j < i ? '<i class="fa fa-star"></i>' : '<i class="fa fa-star-o"></i>';
                    }
                    html += '</div>';
                    html += '<div class="rating-progress">';
                    html += '<div style="width: ' + percentage + '%"></div>';
                    html += '</div>';
                    html += '<span class="sum">' + count + '</span>';
                    html += '</li>';
                  }

                  container.innerHTML = html;
                }

                // Load reviews
                async function loadReviews(productId, page = 0, keepExpandedStates = false) {
                  // Save currently expanded review IDs before reload
                  let expandedReviewIds = [];
                  if (keepExpandedStates) {
                    document.querySelectorAll('[id^="childReviews-"]').forEach(container => {
                      if (container.style.display === 'block') {
                        const reviewId = container.id.replace('childReviews-', '');
                        expandedReviewIds.push(reviewId);
                      }
                    });
                  }

                  try {
                    const response = await fetch(ctx + '/api/reviews/product/' + productId + '?page=' + page + '&size=' + reviewsPerPage);
                    if (!response.ok) {
                      console.error('Failed to load reviews');
                      return;
                    }

                    const data = await response.json();
                    console.log('Reviews data:', data);

                    currentReviewPage = data.currentPage;
                    displayReviews(data.reviews);
                    displayReviewsPagination(data);

                    // Restore expanded states
                    if (keepExpandedStates && expandedReviewIds.length > 0) {
                      setTimeout(() => {
                        expandedReviewIds.forEach(reviewId => {
                          const container = document.getElementById('childReviews-' + reviewId);
                          const button = document.getElementById('toggleBtn-' + reviewId);
                          if (container && button) {
                            container.style.display = 'block';
                            const childCount = (container.innerHTML.match(/<div style="margin-bottom: 15px;">/g) || []).length;
                            button.innerHTML = '<i class="fa fa-angle-up"></i> Thu gọn phản hồi';
                          }
                        });
                      }, 100); // Small delay to ensure DOM is rendered
                    }
                  } catch (error) {
                    console.error('Error loading reviews:', error);
                    document.getElementById('reviewsList').innerHTML = '<li style="text-align: center; color: #999;"><p>Không thể tải đánh giá</p></li>';
                  }
                }

                // Display reviews
                function displayReviews(reviews) {
                  const container = document.getElementById('reviewsList');
                  if (!container) return;

                  if (!reviews || reviews.length === 0) {
                    container.innerHTML = '<li style="text-align: center; color: #999;"><p>Chưa có đánh giá nào</p></li>';
                    return;
                  }

                  let html = '';
                  reviews.forEach(review => {
                    html += '<li>';
                    html += '<div class="review-heading">';
                    html += '<h5 class="name">' + (review.userName || 'Ẩn danh') + '</h5>';
                    html += '<p class="date">' + formatDate(review.createdAt) + '</p>';

                    if (review.rating) {
                      html += '<div class="review-rating">';
                      for (let i = 0; i < 5; i++) {
                        html += i < review.rating ? '<i class="fa fa-star"></i>' : '<i class="fa fa-star-o empty"></i>';
                      }
                      html += '</div>';
                    }

                    html += '</div>';
                    html += '<div class="review-body">';
                    html += '<p>' + (review.comment || '') + '</p>';

                    // Reply button
                    html += '<button class="btn btn-sm btn-link" onclick="showReplyForm(' + review.reviewId + ')" style="padding: 5px 10px; font-size: 12px; color: #d10024;">';
                    html += '<i class="fa fa-reply"></i> Trả lời';
                    html += '</button>';

                    // Delete button (chỉ hiện cho admin)
                    if (isAdmin) {
                      html += '<button class="btn btn-sm btn-link" onclick="deleteReview(' + review.reviewId + ')" style="padding: 5px 10px; font-size: 12px; color: #dc3545;">';
                      html += '<i class="fa fa-trash"></i> Xóa';
                      html += '</button>';
                    }

                    // Display child reviews (replies) with collapse/expand functionality
                    if (review.childReviews && review.childReviews.length > 0) {
                      // Button to toggle child reviews visibility
                      html += '<button class="btn btn-sm btn-link" onclick="toggleChildReviews(' + review.reviewId + ')" ';
                      html += 'id="toggleBtn-' + review.reviewId + '" ';
                      html += 'style="padding: 2px 8px; font-size: 11px; color: #2874f0; margin-top: 5px;">';
                      html += '<i class="fa fa-angle-down"></i> Xem thêm ' + review.childReviews.length + ' phản hồi';
                      html += '</button>';

                      // Container for child reviews (hidden by default)
                      html += '<div id="childReviews-' + review.reviewId + '" style="display: none; margin-left: 20px; margin-top: 15px; padding-left: 15px; border-left: 2px solid #e4e7ed;">';

                      review.childReviews.forEach(child => {
                        html += '<div style="margin-bottom: 15px;">';
                        html += '<div>';
                        html += '<strong style="color: #d10024;">' + (child.userName || 'Ẩn danh') + '</strong> ';
                        html += '<span style="font-size: 12px; color: #999;">(' + formatDate(child.createdAt) + ')</span>';
                        html += '</div>';
                        html += '<p style="margin: 5px 0;">' + (child.comment || '') + '</p>';

                        // Reply button for each child review
                        html += '<button class="btn btn-sm btn-link" onclick="showReplyForm(' + review.reviewId + ')" style="padding: 2px 8px; font-size: 11px; color: #d10024;">';
                        html += '<i class="fa fa-reply"></i> Trả lời';
                        html += '</button>';

                        // Delete button for child review (chỉ hiện cho admin)
                        if (isAdmin) {
                          html += '<button class="btn btn-sm btn-link" onclick="deleteReview(' + child.reviewId + ')" style="padding: 2px 8px; font-size: 11px; color: #dc3545;">';
                          html += '<i class="fa fa-trash"></i> Xóa';
                          html += '</button>';
                        }

                        html += '</div>';
                      });

                      // Reply form at the bottom of child reviews (hidden by default)
                      html += '<div id="replyForm-' + review.reviewId + '" style="display: none; margin-top: 15px; padding: 10px; background: #f9f9f9; border-radius: 4px;">';
                      html += '<textarea id="replyComment-' + review.reviewId + '" class="form-control" placeholder="Nhập phản hồi của bạn..." rows="3" style="margin-bottom: 10px;"></textarea>';
                      html += '<button class="btn btn-primary btn-sm" onclick="submitReply(' + review.reviewId + ')">Gửi phản hồi</button> ';
                      html += '<button class="btn btn-default btn-sm" onclick="hideReplyForm(' + review.reviewId + ')">Hủy</button>';
                      html += '</div>';

                      html += '</div>'; // Close childReviews container
                    } else {
                      // If no child reviews yet, show form outside (it will become the first reply)
                      html += '<div id="replyForm-' + review.reviewId + '" style="display: none; margin-top: 10px; margin-left: 20px; padding: 10px; background: #f9f9f9; border-radius: 4px;">';
                      html += '<textarea id="replyComment-' + review.reviewId + '" class="form-control" placeholder="Nhập phản hồi của bạn..." rows="3" style="margin-bottom: 10px;"></textarea>';
                      html += '<button class="btn btn-primary btn-sm" onclick="submitReply(' + review.reviewId + ')">Gửi phản hồi</button> ';
                      html += '<button class="btn btn-default btn-sm" onclick="hideReplyForm(' + review.reviewId + ')">Hủy</button>';
                      html += '</div>';
                    }

                    html += '</div>';
                    html += '</li>';
                  });

                  container.innerHTML = html;
                }

                // Display pagination
                function displayReviewsPagination(data) {
                  const container = document.getElementById('reviewsPagination');
                  if (!container) return;

                  if (data.totalPages <= 1) {
                    container.innerHTML = '';
                    return;
                  }

                  let html = '<div class="btn-group">';

                  // Previous button
                  if (data.hasPrevious) {
                    html += '<button class="btn btn-default" onclick="loadReviews(' + productData.id + ', ' + (currentReviewPage - 1) + ')">« Trước</button>';
                  }

                  // Page numbers
                  const startPage = Math.max(0, currentReviewPage - 2);
                  const endPage = Math.min(data.totalPages - 1, currentReviewPage + 2);

                  for (let i = startPage; i <= endPage; i++) {
                    const activeClass = i === currentReviewPage ? 'btn-primary' : 'btn-default';
                    html += '<button class="btn ' + activeClass + '" onclick="loadReviews(' + productData.id + ', ' + i + ')">' + (i + 1) + '</button>';
                  }

                  // Next button
                  if (data.hasNext) {
                    html += '<button class="btn btn-default" onclick="loadReviews(' + productData.id + ', ' + (currentReviewPage + 1) + ')">Sau »</button>';
                  }

                  html += '</div>';
                  container.innerHTML = html;
                }

                // Format date
                function formatDate(dateString) {
                  if (!dateString) return '';
                  try {
                    const date = new Date(dateString);
                    if (isNaN(date.getTime())) return '';

                    const day = date.getDate().toString().padStart(2, '0');
                    const month = (date.getMonth() + 1).toString().padStart(2, '0');
                    const year = date.getFullYear();
                    const hours = date.getHours().toString().padStart(2, '0');
                    const minutes = date.getMinutes().toString().padStart(2, '0');
                    return day + '/' + month + '/' + year + ', ' + hours + ':' + minutes;
                  } catch (error) {
                    console.error('Error formatting date:', error);
                    return '';
                  }
                }

                // Handle review form submission
                document.addEventListener('DOMContentLoaded', function () {
                  const reviewForm = document.getElementById('reviewForm');
                  if (reviewForm) {
                    reviewForm.addEventListener('submit', async function (e) {
                      e.preventDefault();

                      // Check if user is logged in
                      if (!isUserLoggedIn) {
                        showInlineAlert('Vui lòng đăng nhập để đánh giá sản phẩm', 'warning');
                        setTimeout(() => window.location.href = ctx + '/login', 2000);
                        return;
                      }

                      // Get form data
                      const rating = document.querySelector('input[name="rating"]:checked');
                      const comment = document.getElementById('reviewComment').value.trim();

                      if (!rating) {
                        showInlineAlert('Vui lòng chọn số sao đánh giá', 'warning');
                        return;
                      }

                      if (!comment) {
                        showInlineAlert('Vui lòng nhập nhận xét của bạn', 'warning');
                        return;
                      }

                      // Create review object
                      const reviewData = {
                        productId: productData.id,
                        rating: parseInt(rating.value),
                        comment: comment
                      };

                      try {
                        const response = await fetch(ctx + '/api/reviews/product/' + productData.id, {
                          method: 'POST',
                          headers: {
                            'Content-Type': 'application/json'
                          },
                          credentials: 'include',
                          body: JSON.stringify(reviewData)
                        });

                        if (response.ok) {
                          // Reset form
                          reviewForm.reset();
                          // Reload reviews and statistics
                          loadRatingStatistics(productData.id);
                          loadReviews(productData.id, 0);
                        } else if (response.status === 401 || response.status === 403) {
                          showInlineAlert('Vui lòng đăng nhập để đánh giá sản phẩm', 'warning');
                          setTimeout(() => window.location.href = ctx + '/login', 2000);
                        } else {
                          const error = await response.json();
                          showInlineAlert(error.error || 'Có lỗi xảy ra. Vui lòng thử lại.', 'danger');
                        }
                      } catch (error) {
                        console.error('Error submitting review:', error);
                        showInlineAlert('Có lỗi xảy ra. Vui lòng thử lại.', 'danger');
                      }
                    });
                  }

                  // Load reviews and statistics when product is loaded
                  if (typeof productData !== 'undefined' && productData.id) {
                    loadRatingStatistics(productData.id);
                    loadReviews(productData.id, 0);
                    loadProductDocument(productData.id); // Load product description from document
                  }
                });

                // ==================== REPLY FUNCTIONS ====================

                // Toggle child reviews visibility
                function toggleChildReviews(reviewId) {
                  const container = document.getElementById('childReviews-' + reviewId);
                  const button = document.getElementById('toggleBtn-' + reviewId);

                  if (!container || !button) return;

                  if (container.style.display === 'none') {
                    // Show child reviews
                    container.style.display = 'block';
                    button.innerHTML = '<i class="fa fa-angle-up"></i> Thu gọn phản hồi';
                  } else {
                    // Hide child reviews
                    container.style.display = 'none';
                    const childCount = container.querySelectorAll('& > div').length ||
                      (container.innerHTML.match(/<div style="margin-bottom: 15px;">/g) || []).length;
                    button.innerHTML = '<i class="fa fa-angle-down"></i> Xem thêm ' + childCount + ' phản hồi';
                  }
                }

                // Show reply form
                function showReplyForm(reviewId) {
                  // Check if user is logged in
                  if (!isUserLoggedIn) {
                    showInlineAlert('Vui lòng đăng nhập để trả lời bình luận', 'warning');
                    setTimeout(() => window.location.href = ctx + '/login', 2000);
                    return;
                  }

                  // Hide all other reply forms
                  document.querySelectorAll('[id^="replyForm-"]').forEach(form => {
                    form.style.display = 'none';
                  });

                  // Auto-expand child reviews if collapsed (to show the reply form)
                  const childReviewsContainer = document.getElementById('childReviews-' + reviewId);
                  const toggleButton = document.getElementById('toggleBtn-' + reviewId);
                  if (childReviewsContainer && childReviewsContainer.style.display === 'none') {
                    // Expand child reviews
                    childReviewsContainer.style.display = 'block';
                    if (toggleButton) {
                      toggleButton.innerHTML = '<i class="fa fa-angle-up"></i> Thu gọn phản hồi';
                    }
                  }

                  // Show this reply form
                  const replyForm = document.getElementById('replyForm-' + reviewId);
                  if (replyForm) {
                    replyForm.style.display = 'block';
                    // Focus on textarea
                    const textarea = document.getElementById('replyComment-' + reviewId);
                    if (textarea) {
                      textarea.focus();
                    }
                  }
                }

                // Hide reply form
                function hideReplyForm(reviewId) {
                  const replyForm = document.getElementById('replyForm-' + reviewId);
                  if (replyForm) {
                    replyForm.style.display = 'none';
                    // Clear textarea
                    const textarea = document.getElementById('replyComment-' + reviewId);
                    if (textarea) {
                      textarea.value = '';
                    }
                  }
                }

                // Submit reply
                async function submitReply(parentReviewId) {
                  // Check if user is logged in
                  if (!isUserLoggedIn) {
                    showInlineAlert('Vui lòng đăng nhập để trả lời bình luận', 'warning');
                    setTimeout(() => window.location.href = ctx + '/login', 2000);
                    return;
                  }

                  // Get comment
                  const textarea = document.getElementById('replyComment-' + parentReviewId);
                  if (!textarea) return;

                  const comment = textarea.value.trim();
                  if (!comment) {
                    showInlineAlert('Vui lòng nhập nội dung phản hồi', 'warning');
                    return;
                  }

                  // Create reply object
                  const replyData = {
                    productId: productData.id,
                    parentReviewId: parentReviewId,
                    comment: comment,
                    rating: null // Reply không cần rating
                  };

                  try {
                    const response = await fetch(ctx + '/api/reviews/product/' + productData.id, {
                      method: 'POST',
                      headers: {
                        'Content-Type': 'application/json'
                      },
                      credentials: 'include',
                      body: JSON.stringify(replyData)
                    });

                    if (response.ok) {
                      // Hide and clear form
                      hideReplyForm(parentReviewId);
                      // Reload reviews (keep same page and keep expanded states)
                      loadReviews(productData.id, currentReviewPage, true);
                    } else if (response.status === 401 || response.status === 403) {
                      showInlineAlert('Vui lòng đăng nhập để trả lời bình luận', 'warning');
                      setTimeout(() => window.location.href = ctx + '/login', 2000);
                    } else {
                      const error = await response.json();
                      showInlineAlert(error.error || 'Có lỗi xảy ra. Vui lòng thử lại.', 'danger');
                    }
                  } catch (error) {
                    console.error('Error submitting reply:', error);
                    showInlineAlert('Có lỗi xảy ra. Vui lòng thử lại.', 'danger');
                  }
                }

                // Delete review (admin only)
                async function deleteReview(reviewId) {

                  try {
                    const response = await fetch(ctx + '/admin/api/reviews/' + reviewId, {
                      method: 'DELETE',
                      credentials: 'include'
                    });

                    if (response.ok) {
                      // Reload reviews and statistics
                      loadRatingStatistics(productData.id);
                      loadReviews(productData.id, currentReviewPage, true);
                    } else if (response.status === 401) {
                      showInlineAlert('Vui lòng đăng nhập để thực hiện thao tác này', 'warning');
                      setTimeout(() => window.location.href = ctx + '/login', 2000);
                    } else if (response.status === 403) {
                      const error = await response.json();
                      showInlineAlert(error.error || 'Bạn không có quyền xóa đánh giá', 'danger');
                    } else {
                      const error = await response.json();
                      showInlineAlert(error.error || 'Không thể xóa đánh giá. Vui lòng thử lại.', 'danger');
                    }
                  } catch (error) {
                    console.error('Error deleting review:', error);
                    showInlineAlert('Có lỗi xảy ra. Vui lòng thử lại.', 'danger');
                  }
                }

                // Share functions
                function shareOnFacebook() {
                  const url = encodeURIComponent(window.location.href);
                  const facebookUrl = 'https://www.facebook.com/sharer/sharer.php?u=' + url;
                  window.open(facebookUrl, 'facebook-share', 'width=600,height=400');
                }

                function shareOnTwitter() {
                  const url = encodeURIComponent(window.location.href);
                  const text = encodeURIComponent(productData.name + ' - CellPhoneStore');
                  const twitterUrl = 'https://twitter.com/intent/tweet?url=' + url + '&text=' + text;
                  window.open(twitterUrl, 'twitter-share', 'width=600,height=400');
                }

                function shareOnGooglePlus() {
                  const url = encodeURIComponent(window.location.href);
                  // Google+ đã đóng cửa, có thể dùng LinkedIn thay thế
                  const linkedinUrl = 'https://www.linkedin.com/sharing/share-offsite/?url=' + url;
                  window.open(linkedinUrl, 'linkedin-share', 'width=600,height=400');
                }

                function shareViaEmail() {
                  const subject = encodeURIComponent(productData.name + ' - CellPhoneStore');
                  const body = encodeURIComponent('Xem sản phẩm này: ' + productData.name + '\n\n' + window.location.href);
                  window.location.href = 'mailto:?subject=' + subject + '&body=' + body;
                }
              </script>
            </body>

            </html>