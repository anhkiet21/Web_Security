<%@ page contentType="text/html;charset=UTF-8" language="java" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
			<!DOCTYPE html>
			<html lang="vi">

			<head>
				<meta charset="utf-8">
				<meta http-equiv="X-UA-Compatible" content="IE=edge">
				<meta name="viewport" content="width=device-width, initial-scale=1">
				<title>Sản phẩm - CellPhoneStore</title>

				<style>
					/* Hover animation cho product cards */
					.product {
						transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
						position: relative;
						cursor: pointer;
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
									<li class="active">Sản phẩm</li>
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
							<!-- ASIDE -->
							<div id="aside" class="col-md-3">
								<!-- Series Widget (thay thế Categories) -->
								<div class="aside">
									<h3 class="aside-title">Danh mục</h3>
									<div class="checkbox-filter">
										<c:choose>
											<c:when test="${empty series}">
												<!-- Chưa chọn thương hiệu -->
												<p style="color: #999; font-style: italic; padding: 10px 0;">
													<i class="fa fa-info-circle"></i>
													Vui lòng chọn thương hiệu bên dưới để xem danh mục sản phẩm
												</p>
											</c:when>
											<c:otherwise>
												<!-- Đã chọn thương hiệu - hiển thị series -->
												<c:forEach items="${series}" var="s">
													<div class="input-checkbox">
														<input type="checkbox" id="series-${s.seriesName}"
															class="series-filter" value="${s.seriesName}"
															${selectedSeries.contains(s.seriesName) ? 'checked' : '' }>
														<label for="series-${s.seriesName}">
															<span></span>
															${s.seriesName} <small
																style="color: #999;">(${s.productCount})</small>
														</label>
													</div>
												</c:forEach>
											</c:otherwise>
										</c:choose>
									</div>
								</div>
								<!-- /Series Widget -->

								<!-- Brand Widget -->
								<div class="aside">
									<h3 class="aside-title">Thương hiệu</h3>
									<div class="checkbox-filter">
										<c:forEach items="${brands}" var="brand" varStatus="status">
											<div class="input-checkbox">
												<input type="checkbox" id="brand-${status.index}" class="brand-filter"
													value="${brand}" ${selectedBrands.contains(brand) ? 'checked' : ''
													}>
												<label for="brand-${status.index}">
													<span></span>
													${brand}
												</label>
											</div>
										</c:forEach>
									</div>
								</div>
								<!-- /Brand Widget -->
							</div>
							<!-- /ASIDE -->

							<!-- STORE -->
							<div id="store" class="col-md-9">
								<!-- Search result info -->
								<c:if test="${not empty searchName}">
									<div class="alert alert-info" style="margin-bottom: 20px;">
										<i class="fa fa-search"></i>
										Kết quả tìm kiếm cho: <strong>"${searchName}"</strong>
										<c:if test="${totalProducts == 0}">
											- Không tìm thấy sản phẩm nào
										</c:if>
										<c:if test="${totalProducts > 0}">
											- Tìm thấy ${totalProducts} sản phẩm
										</c:if>
									</div>
								</c:if>
								<!-- /Search result info -->

								<!-- store top filter -->
								<div class="store-filter clearfix">
									<div class="store-sort">
										<label>
											Sắp xếp theo:
											<select class="input-select" id="sort-select">
												<option value="popular" ${selectedSort=='popular' ? 'selected' : '' }>
													Tất cả</option>
												<option value="price-asc" ${selectedSort=='price-asc' ? 'selected' : ''
													}>Giá thấp đến cao</option>
												<option value="price-desc" ${selectedSort=='price-desc' ? 'selected'
													: '' }>Giá cao đến thấp</option>
											</select>
										</label>

										<label>
											Hiển thị:
											<select class="input-select" id="limit-select">
												<option value="12" ${selectedLimit==12 ? 'selected' : '' }>12</option>
												<option value="20" ${selectedLimit==20 ? 'selected' : '' }>20</option>
												<option value="50" ${selectedLimit==50 ? 'selected' : '' }>50</option>
											</select>
										</label>
									</div>
									<ul class="store-grid">
										<li class="active"><i class="fa fa-th"></i></li>
									</ul>
								</div>
								<!-- /store top filter -->

								<!-- store products -->
								<div class="row">
									<c:forEach items="${products}" var="product">
										<!-- product -->
										<div class="col-md-4 col-xs-6">
											<div class="product">
												<div class="product-img">
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
																	<fmt:formatNumber value="${savedAmount}"
																		pattern="#,###" maxFractionDigits="0" /> đ
																</span>
															</c:when>
															<c:otherwise>
																<fmt:formatNumber value="${product.price}"
																	type="currency" currencySymbol="₫"
																	maxFractionDigits="0" />
															</c:otherwise>
														</c:choose>
													</h4>
													<div class="product-rating" id="rating-${product.id}">
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
										<!-- /product -->
									</c:forEach>
								</div>
								<!-- /store products -->

								<!-- store bottom filter -->
								<div class="store-filter clearfix">
									<span class="store-qty">Hiển thị ${startIndex}-${endIndex} trong tổng số
										${totalProducts} sản phẩm</span>
									<ul class="store-pagination">
										<c:if test="${currentPage > 1}">
											<li><a href="#" onclick="goToPage(${currentPage - 1}); return false;"><i
														class="fa fa-angle-left"></i></a></li>
										</c:if>

										<c:forEach begin="1" end="${totalPages}" var="pageNum">
											<c:choose>
												<c:when test="${pageNum == currentPage}">
													<li class="active">${pageNum}</li>
												</c:when>
												<c:when
													test="${pageNum == 1 || pageNum == totalPages || (pageNum >= currentPage - 1 && pageNum <= currentPage + 1)}">
													<li><a href="#"
															onclick="goToPage(${pageNum}); return false;">${pageNum}</a>
													</li>
												</c:when>
												<c:when
													test="${pageNum == currentPage - 2 || pageNum == currentPage + 2}">
													<li class="disabled"><span>...</span></li>
												</c:when>
											</c:choose>
										</c:forEach>

										<c:if test="${currentPage < totalPages}">
											<li><a href="#" onclick="goToPage(${currentPage + 1}); return false;"><i
														class="fa fa-angle-right"></i></a></li>
										</c:if>
									</ul>
								</div>
								<!-- /store bottom filter -->
							</div>
							<!-- /STORE -->
						</div>
					</div>
				</div>
				<!-- /SECTION -->

				<!-- NEWSLETTER -->
				<div id="newsletter" class="section">
					<div class="container">
						<div class="row">
							<div class="col-md-12">
								<div class="newsletter">
									<p>Đăng ký nhận <strong>TIN TỨC MỚI</strong></p>
									<form>
										<input class="input" type="email" placeholder="Nhập email của bạn">
										<button class="newsletter-btn"><i class="fa fa-envelope"></i> Đăng ký</button>
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
					</div>
				</div>
				<!-- /NEWSLETTER -->

				<script>
// Kiểm tra đăng nhập từ server-side
<%
						org.springframework.security.core.Authentication auth = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
    boolean isAuthenticated = auth != null && auth.isAuthenticated() && !(auth instanceof org.springframework.security.authentication.AnonymousAuthenticationToken);
%>
var IS_LOGGED_IN = <%= isAuthenticated %>;

					// ========== FILTER & PAGINATION FUNCTIONS ==========

					// Hàm để build URL với các filter hiện tại
					function buildFilterUrl(newPage) {
						var url = '${pageContext.request.contextPath}/shop?';
						var params = [];

						// Thêm search name nếu có
						var searchName = '${searchName}';
						if (searchName && searchName.trim() !== '') {
							params.push('name=' + encodeURIComponent(searchName));
						}

						// Thêm brands được chọn
						var brandCheckboxes = document.querySelectorAll('.brand-filter:checked');
						brandCheckboxes.forEach(function (checkbox) {
							params.push('brand=' + encodeURIComponent(checkbox.value));
						});

						// Thêm series được chọn (thay vì categories)
						var seriesCheckboxes = document.querySelectorAll('.series-filter:checked');
						seriesCheckboxes.forEach(function (checkbox) {
							params.push('series=' + encodeURIComponent(checkbox.value));
						});

						// Thêm sort
						var sortSelect = document.getElementById('sort-select');
						if (sortSelect && sortSelect.value) {
							params.push('sort=' + sortSelect.value);
						}

						// Thêm limit
						var limitSelect = document.getElementById('limit-select');
						if (limitSelect && limitSelect.value) {
							params.push('limit=' + limitSelect.value);
						}

						// Thêm page
						if (newPage) {
							params.push('page=' + newPage);
						}

						return url + params.join('&');
					}

					// Hàm apply filters (khi chọn/bỏ chọn checkbox hoặc thay đổi dropdown)
					function applyFilters() {
						var url = buildFilterUrl(1); // Reset về trang 1 khi thay đổi filter
						window.location.href = url;
					}

					// Hàm chuyển trang
					function goToPage(page) {
						var url = buildFilterUrl(page);
						window.location.href = url;
					}

					// Gắn event listeners khi DOM loaded
					document.addEventListener('DOMContentLoaded', function () {
						// Event listeners cho series checkboxes (thay vì category)
						var seriesCheckboxes = document.querySelectorAll('.series-filter');
						seriesCheckboxes.forEach(function (checkbox) {
							checkbox.addEventListener('change', applyFilters);
						});

						var brandCheckboxes = document.querySelectorAll('.brand-filter');
						brandCheckboxes.forEach(function (checkbox) {
							checkbox.addEventListener('change', function () {
								// Khi thay đổi brand, xóa tất cả series selections (vì series sẽ thay đổi)
								var seriesCheckboxes = document.querySelectorAll('.series-filter:checked');
								seriesCheckboxes.forEach(function (cb) {
									cb.checked = false;
								});
								applyFilters();
							});
						});

						// Event listeners cho dropdowns
						var sortSelect = document.getElementById('sort-select');
						if (sortSelect) {
							sortSelect.addEventListener('change', applyFilters);
						}

						var limitSelect = document.getElementById('limit-select');
						if (limitSelect) {
							limitSelect.addEventListener('change', applyFilters);
						}
					});

					// ========== CART & WISHLIST FUNCTIONS ==========

					function addToCart(productId) {
						if (!IS_LOGGED_IN) {
							// Chưa đăng nhập, chuyển về trang login
							window.location.href = '${pageContext.request.contextPath}/login';
							return;
						}

						// Đã đăng nhập, gọi API thêm vào giỏ hàng
						fetch('${pageContext.request.contextPath}/api/cart/add', {
							method: 'POST',
							headers: {
								'Content-Type': 'application/json'
							},
							credentials: 'include', // Tự động gửi cookies (JWT token)
							body: JSON.stringify({
								productId: productId,
								quantity: 1
							})
						})
							.then(response => {
								if (response.ok) {
									return response.json();
								} else if (response.status === 401 || response.status === 403) {
									throw new Error('Unauthorized');
								} else {
									throw new Error('Có lỗi xảy ra');
								}
							})
							.then(data => {
								// Cập nhật số lượng giỏ hàng trong header
								if (typeof updateGlobalCartCount === 'function') {
									updateGlobalCartCount();
								}
							})
							.catch(error => {
								if (error.message === 'Unauthorized') {
									window.location.href = '${pageContext.request.contextPath}/login';
								} else {
									alert('Có lỗi: ' + error.message);
								}
							});
					}

					// Function cập nhật số lượng giỏ hàng
					function updateCartCount() {
						fetch('${pageContext.request.contextPath}/api/cart', {
							method: 'GET',
							headers: {
								'Content-Type': 'application/json'
							},
							credentials: 'include' // Tự động gửi cookies
						})
							.then(response => {
								if (response.ok) {
									return response.json();
								}
								return null;
							})
							.then(data => {
								if (data && data.items) {
									const totalItems = data.items.reduce((sum, item) => sum + item.quantity, 0);
									const qtyElement = document.getElementById('cart-qty');
									if (qtyElement) {
										qtyElement.textContent = totalItems;
									}
								}
							})
							.catch(error => {
								console.error('Lỗi khi cập nhật số lượng giỏ hàng:', error);
							});
					}

					// Load số lượng giỏ hàng khi trang được tải
					if (IS_LOGGED_IN) {
						window.addEventListener('DOMContentLoaded', function () {
							updateCartCount();
							loadFavoriteStates(); // Load trạng thái yêu thích
						});
					}
					// ========== RATING FUNCTIONS ==========

					// Load rating cho tất cả sản phẩm hiển thị trên trang
					function loadAllProductRatings() {
						// Lấy tất cả product IDs từ các thẻ rating
						const ratingElements = document.querySelectorAll('[id^="rating-"]');

						ratingElements.forEach(element => {
							const productId = element.id.replace('rating-', '');
							loadProductRating(productId);
						});
					}

					// Load rating cho một sản phẩm cụ thể
					async function loadProductRating(productId) {
						try {
							const response = await fetch('${pageContext.request.contextPath}/api/reviews/product/' + productId + '/stats');

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

					// Load ratings khi trang được tải
					window.addEventListener('DOMContentLoaded', function () {
						loadAllProductRatings();
					});


					// Toggle favorite (thêm/xóa yêu thích)
					function toggleFavorite(productId, button) {
						if (!IS_LOGGED_IN) {
							window.location.href = '${pageContext.request.contextPath}/login';
							return;
						}

						var icon = button.querySelector('i');
						var isFavorited = icon.classList.contains('fa-heart');

						if (isFavorited) {
							// Xóa khỏi yêu thích
							fetch('${pageContext.request.contextPath}/api/favorite/remove/' + productId, {
								method: 'DELETE',
								credentials: 'include',
								headers: {
									'Content-Type': 'application/json'
								}
							})
								.then(response => {
									if (response.ok) {
										return response.json();
									} else if (response.status === 401 || response.status === 403) {
										throw new Error('Unauthorized');
									} else {
										throw new Error('Có lỗi xảy ra');
									}
								})
								.then(data => {
									icon.classList.remove('fa-heart');
									icon.classList.add('fa-heart-o');
									button.style.color = '';
									// Cập nhật số lượng wishlist trong header
									if (typeof updateGlobalWishlistCount === 'function') {
										updateGlobalWishlistCount();
									}
								})
								.catch(error => {
									if (error.message === 'Unauthorized') {
										window.location.href = '${pageContext.request.contextPath}/login';
									} else {
										alert('Có lỗi: ' + error.message);
									}
								});
						} else {
							// Thêm vào yêu thích
							fetch('${pageContext.request.contextPath}/api/favorite/add', {
								method: 'POST',
								credentials: 'include',
								headers: {
									'Content-Type': 'application/json'
								},
								body: JSON.stringify({
									productId: productId
								})
							})
								.then(response => {
									if (response.ok) {
										return response.json();
									} else if (response.status === 401 || response.status === 403) {
										throw new Error('Unauthorized');
									} else {
										throw new Error('Có lỗi xảy ra');
									}
								})
								.then(data => {
									icon.classList.remove('fa-heart-o');
									icon.classList.add('fa-heart');
									button.style.color = '#d70018';
									// Cập nhật số lượng wishlist trong header
									if (typeof updateGlobalWishlistCount === 'function') {
										updateGlobalWishlistCount();
									}
								})
								.catch(error => {
									if (error.message === 'Unauthorized') {
										window.location.href = '${pageContext.request.contextPath}/login';
									} else {
										alert('Có lỗi: ' + error.message);
									}
								});
						}
					}

					// Load trạng thái yêu thích cho tất cả sản phẩm
					function loadFavoriteStates() {
						fetch('${pageContext.request.contextPath}/api/favorite', {
							method: 'GET',
							credentials: 'include',
							headers: {
								'Content-Type': 'application/json'
							}
						})
							.then(response => {
								if (response.ok) {
									return response.json();
								}
								return [];
							})
							.then(favorites => {
								// Đánh dấu các sản phẩm đã yêu thích
								favorites.forEach(function (favorite) {
									var button = document.querySelector('.add-to-wishlist[data-product-id="' + favorite.productId + '"]');
									if (button) {
										var icon = button.querySelector('i');
										icon.classList.remove('fa-heart-o');
										icon.classList.add('fa-heart');
										button.style.color = '#d70018';
									}
								});
							})
							.catch(error => {
								console.error('Lỗi khi tải trạng thái yêu thích:', error);
							});
					}
				</script>

			</body>

			</html>