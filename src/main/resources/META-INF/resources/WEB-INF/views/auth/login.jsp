<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ page
contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Đăng nhập - CellPhoneStore</title>

	<!-- Google Fonts (local) -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/montserrat-local.css" />

	<!-- Font Awesome -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" integrity="sha512-1PKOgIY59xJ8Co8+NE6Fhw5jv4l1r1rVZlK6Y1E6k1b6U5zTh+V/uGNzcRCjSc5vNmi1zC2f13p6Jb6aVx3Kfg==" crossorigin="anonymous" />

	<!-- Bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-VgpO+QdMZkR0pQfM9vDOMkMt2rt7NmBGG99nmHn7+PBkO5RAwOB1p5MNDoAuCEVs" crossorigin="anonymous" />

    <!-- CSS -->
    <c:url value="/css/header.css" var="headerCss" />
    <c:url value="/css/login.css" var="loginCss" />
    <link rel="stylesheet" href="${headerCss}" />
    <link rel="stylesheet" href="${loginCss}" />
  </head>

  <body class="login-page">
    <jsp:include page="/common/header.jsp" />

    <div class="login-container">
      <div class="login-card">
        <h2>Đăng nhập</h2>
        <p class="subtitle">
          Chào mừng bạn trở lại! Vui lòng đăng nhập để tiếp tục.
        </p>

        <form action="<c:url value='/dologin' />" method="post">
          <%-- ✅ CSRF Token: Ngăn Login CSRF Attack từ trang giả mạo --%>
          <input
            type="hidden"
            name="${_csrf.parameterName}"
            value="${_csrf.token}"
          />
          <c:if test="${not empty error}">
            <div class="alert alert-danger">
              <i class="fa fa-exclamation-circle"></i>
              <c:out value="${error}" />
            </div>
          </c:if>
          <c:if test="${not empty message}">
            <div class="alert alert-success">
              <i class="fa fa-check-circle"></i> <c:out value="${message}" />
            </div>
          </c:if>

          <div class="mb-3">
            <label for="phone" class="form-label">
              <i class="fa fa-phone"></i> Số điện thoại
            </label>
            <input
              type="text"
              class="form-control"
              id="phone"
              name="phone"
              placeholder="Nhập số điện thoại"
              required
            />
          </div>

          <div class="mb-3">
            <label for="password" class="form-label">
              <i class="fa fa-lock"></i> Mật khẩu
            </label>
            <input
              type="password"
              class="form-control"
              id="password"
              name="password"
              placeholder="Nhập mật khẩu"
              required
            />
          </div>

          <div class="d-flex justify-content-between align-items-center mb-3">
            <div class="form-check">
              <input
                class="form-check-input"
                type="checkbox"
                id="rememberMe"
                name="rememberMe"
              />
              <label class="form-check-label" for="rememberMe"
                >Ghi nhớ đăng nhập</label
              >
            </div>
            <a href="<c:url value='/resetPassword' />" class="text-link"
              >Quên mật khẩu?</a
            >
          </div>

          <button type="submit" class="btn btn-login w-100 text-white">
            <i class="fa fa-sign-in"></i> Đăng nhập
          </button>
        </form>

        <hr />

        <div class="text-center mb-3">
          <a
            class="btn btn-google w-100 d-flex align-items-center justify-content-center gap-2"
            href="<c:url value='/oauth2/authorization/google' />"
          >
            <img
              src="https://developers.google.com/identity/images/g-logo.png"
              alt="Google"
            />
            Đăng nhập bằng Google
          </a>
        </div>

        <p class="text-center mb-0">
          Chưa có tài khoản?
          <a href="<c:url value='/register' />" class="text-link"
            >Đăng ký ngay</a
          >
        </p>
      </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoA6VKHrj9W0nPEzvF6lZl6pnh36t+sx4CkXWvZ2R5h7N6E" crossorigin="anonymous"></script>
  </body>
</html>
