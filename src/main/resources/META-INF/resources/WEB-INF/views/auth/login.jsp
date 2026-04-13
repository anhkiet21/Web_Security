<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ page
contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Đăng nhập - CellPhoneStore</title>

    <!-- Montserrat font (self-hosted) -->
    <link rel="stylesheet" href="<c:url value='/css/montserrat.css'/>" />

    <!-- Font Awesome -->
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"
      integrity="sha512-SfTiTlX6kk+qitfevl/7LibUOeJWlt9rbyDn92a1DqWOw9vWG2MFoays0sgObmWazO5BQPiFucnnEAjpAB+/Sw=="
      crossorigin="anonymous"
    />

    <!-- Bootstrap -->
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
      rel="stylesheet"
      integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN"
      crossorigin="anonymous"
    />

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
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
  </body>
</html>
