<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>
		<!DOCTYPE html>
		<html lang="vi">

		<head>
			<meta charset="utf-8">
			<meta http-equiv="X-UA-Compatible" content="IE=edge">
			<meta name="viewport" content="width=device-width, initial-scale=1">

			<title>
				<sitemesh:write property='title' />
			</title>
			<!-- <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"> -->

			<!-- Google font -->
			<link href="https://fonts.googleapis.com/css?family=Montserrat:400,500,700" rel="stylesheet">


			<!-- Bootstrap -->
			<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />

			<!-- Slick -->
			<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/slick.css" />
			<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/slick-theme.css" />

			<!-- nouislider -->
			<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/nouislider.min.css" />

			<!-- Font Awesome Icon -->
			<link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css">

			<!-- Custom stylesheet -->
			<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />

			<sitemesh:write property='head' />
		</head>

		<body>
			<%@ include file="/common/headerWeb.jsp" %>

				<sitemesh:write property='body' />

				<%@ include file="/common/footerWeb.jsp" %>

					<!-- jQuery Plugins -->
					<script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
					<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
					<script src="${pageContext.request.contextPath}/js/slick.min.js"></script>
					<script src="${pageContext.request.contextPath}/js/nouislider.min.js"></script>
					<script src="${pageContext.request.contextPath}/js/jquery.zoom.min.js"></script>
					<script src="${pageContext.request.contextPath}/js/main.js"></script>

					<!-- Global cart count update -->
					<script>
    <%
							org.springframework.security.core.Authentication globalAuth = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
        boolean isGlobalAuthenticated = globalAuth != null && globalAuth.isAuthenticated() && !(globalAuth instanceof org.springframework.security.authentication.AnonymousAuthenticationToken);
    %>

							// Function global để cập nhật số lượng giỏ hàng
							function updateGlobalCartCount() {
								fetch('${pageContext.request.contextPath}/api/cart', {
									method: 'GET',
									headers: { 'Content-Type': 'application/json' },
									credentials: 'include'
								})
									.then(response => response.ok ? response.json() : null)
									.then(data => {
										if (data && data.items) {
											const totalItems = data.items.reduce((sum, item) => sum + item.quantity, 0);
											const qtyElement = document.getElementById('cart-qty');
											if (qtyElement) {
												qtyElement.textContent = totalItems;
											}
										}
									})
									.catch(error => console.error('Lỗi cập nhật giỏ hàng:', error));
							}

							// Load số lượng giỏ hàng khi trang được tải (nếu đã đăng nhập)
							<% if (isGlobalAuthenticated) { %>
								document.addEventListener('DOMContentLoaded', function () {
									updateGlobalCartCount();
								});
    <% } %>
					</script>
		</body>

		</html>