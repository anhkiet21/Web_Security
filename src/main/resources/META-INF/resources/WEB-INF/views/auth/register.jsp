<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
  <%@ page contentType="text/html;charset=UTF-8" %>
    <!doctype html>
    <html lang="vi">

    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1" />
      <title>Đăng ký thành viên - CellPhoneStore</title>

      <!-- Google Fonts -->
      <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800&display=swap"
        rel="stylesheet" />

      <!-- Font Awesome -->
      <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />

      <c:url value="/css/register.css" var="registerCss" />
      <link rel="stylesheet" href="${registerCss}" />
    </head>

    <body class="register-page">
      <jsp:include page="/common/header.jsp" />
      <div class="register-container">
        <h1>Đăng ký tài khoản</h1>
        <p class="subtitle">Tạo tài khoản mới để trải nghiệm dịch vụ của chúng tôi</p>

        <c:if test="${not empty error}">
          <div class="auth-error">
            <i class="fa fa-exclamation-circle"></i> ${error}
          </div>
        </c:if>

        <c:if test="${not empty message}">
          <div class="auth-message">
            <i class="fa fa-check-circle"></i> ${message}
          </div>
        </c:if>

        <!-- Inline validation messages -->
        <div id="validationMessage" class="auth-error" style="display: none;">
          <i class="fa fa-exclamation-circle"></i> <span id="validationText"></span>
        </div>

        <form id="registerForm" action="${pageContext.request.contextPath}/doregister" method="post">
          <h2 class="section-title">
            <i class="fa fa-user"></i> Thông tin cá nhân
          </h2>

          <div class="form-row">
            <div class="form-col-full">
              <label class="form-label">
                <i class="fa fa-id-card"></i> Họ và tên
              </label>
              <input type="text" class="form-control" name="fullName" placeholder="Nhập họ và tên đầy đủ" required
                value="${not empty fullName ? fullName : ''}" />
            </div>
          </div>

          <div class="form-row">
            <div class="form-col">
              <label class="form-label">
                <i class="fa fa-phone"></i> Số điện thoại
              </label>
              <input type="text" class="form-control" id="phone" name="phone" placeholder="Nhập số điện thoại (10 số)"
                required pattern="[0-9]{10}" maxlength="10" value="${not empty phone ? phone : ''}" />
              <small class="text-muted">
                <i class="fa fa-info-circle"></i> Số điện thoại phải có đúng 10 chữ số
              </small>
            </div>
            <div class="form-col">
              <label class="form-label">
                <i class="fa fa-envelope"></i> Email
              </label>
              <input type="email" class="form-control" id="email" name="email" placeholder="Nhập địa chỉ email" required
                pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$" value="${not empty email ? email : ''}" />
              <small class="text-muted">
                <i class="fa fa-info-circle"></i> Ví dụ: example@gmail.com
              </small>
            </div>
          </div>

          <div class="divider"></div>

          <h2 class="section-title">
            <i class="fa fa-lock"></i> Tạo mật khẩu
          </h2>

          <div class="form-row">
            <div class="form-col">
              <label class="form-label">
                <i class="fa fa-key"></i> Mật khẩu
              </label>
              <input type="password" class="form-control" name="password" placeholder="Nhập mật khẩu" required />
              <small class="text-muted">
                <i class="fa fa-info-circle"></i> Mật khẩu tối thiểu 6 ký tự, có ít nhất 1 chữ cái và 1 số
              </small>
            </div>
            <div class="form-col">
              <label class="form-label">
                <i class="fa fa-key"></i> Nhập lại mật khẩu
              </label>
              <input type="password" class="form-control" name="confirmPassword" placeholder="Xác nhận mật khẩu"
                required />
            </div>
          </div>
        </form>
      </div>

      <div class="footer-fixed">
        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-secondary">
          <i class="fa fa-arrow-left"></i> Quay lại đăng nhập
        </a>
        <button type="submit" form="registerForm" class="btn btn-primary-custom">
          <i class="fa fa-user-plus"></i> Hoàn tất đăng ký
        </button>
      </div>

      <script>
        // Hàm hiển thị thông báo lỗi inline
        function showValidationError(message, inputElement) {
          const validationMessage = document.getElementById('validationMessage');
          const validationText = document.getElementById('validationText');

          validationText.textContent = message;
          validationMessage.style.display = 'block';

          // Scroll đến thông báo
          validationMessage.scrollIntoView({ behavior: 'smooth', block: 'center' });

          // Focus vào input lỗi
          if (inputElement) {
            inputElement.focus();
            inputElement.classList.add('error-input');
          }

          // Ẩn thông báo sau 5 giây
          setTimeout(() => {
            validationMessage.style.display = 'none';
            if (inputElement) {
              inputElement.classList.remove('error-input');
            }
          }, 5000);
        }

        // Validation cho form đăng ký
        document.getElementById('registerForm').addEventListener('submit', function (e) {
          const phone = document.getElementById('phone').value;
          const email = document.getElementById('email').value;
          const password = document.querySelector('input[name="password"]').value;
          const confirmPassword = document.querySelector('input[name="confirmPassword"]').value;

          // Ẩn thông báo cũ
          document.getElementById('validationMessage').style.display = 'none';

          // Kiểm tra số điện thoại (đúng 10 số)
          const phoneRegex = /^[0-9]{10}$/;
          if (!phoneRegex.test(phone)) {
            e.preventDefault();
            showValidationError('Số điện thoại phải có đúng 10 chữ số!', document.getElementById('phone'));
            return false;
          }

          // Kiểm tra email hợp lệ
          const emailRegex = /^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$/i;
          if (!emailRegex.test(email)) {
            e.preventDefault();
            showValidationError('Email không hợp lệ! Vui lòng nhập đúng định dạng email.', document.getElementById('email'));
            return false;
          }

          // Kiểm tra mật khẩu (tối thiểu 6 ký tự, có chữ và số)
          const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$/;
          if (!passwordRegex.test(password)) {
            e.preventDefault();
            showValidationError('Mật khẩu phải có ít nhất 6 ký tự, bao gồm cả chữ cái và số!', document.querySelector('input[name="password"]'));
            return false;
          }

          // Kiểm tra mật khẩu khớp
          if (password !== confirmPassword) {
            e.preventDefault();
            showValidationError('Mật khẩu xác nhận không khớp!', document.querySelector('input[name="confirmPassword"]'));
            return false;
          }

          return true;
        });

        // Chỉ cho phép nhập số vào ô điện thoại
        document.getElementById('phone').addEventListener('input', function (e) {
          this.value = this.value.replace(/[^0-9]/g, '');
          if (this.value.length > 10) {
            this.value = this.value.slice(0, 10);
          }
        });

        // Chuyển email về chữ thường
        document.getElementById('email').addEventListener('input', function (e) {
          this.value = this.value.toLowerCase();
        });

        // Xóa error khi user bắt đầu nhập lại
        document.querySelectorAll('.form-control').forEach(input => {
          input.addEventListener('input', function () {
            this.classList.remove('error-input');
            document.getElementById('validationMessage').style.display = 'none';
          });
        });
      </script>
    </body>

    </html>