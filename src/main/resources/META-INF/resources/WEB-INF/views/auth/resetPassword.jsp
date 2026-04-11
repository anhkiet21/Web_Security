<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ page contentType="text/html;charset=UTF-8" %>
        <!doctype html>
        <html lang="vi">

        <head>
            <meta charset="utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            <title>Đặt lại mật khẩu - CellPhone Store</title>

            <!-- Google Fonts -->
            <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800&display=swap"
                rel="stylesheet" />

            <!-- Font Awesome -->
            <link rel="stylesheet"
                href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />

            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

            <!-- CSS riêng -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reset.css" />
        </head>

        <body class="reset-page">
            <jsp:include page="/common/header.jsp" />

            <!-- MAIN CONTENT -->
            <div class="login-two-col">
                <!-- LEFT -->
                <div class="promo-col">
                    <div class="promo-inner">
                        <h1 class="promo-title">
                            <i class="fa fa-lock"></i> Lấy lại mật khẩu
                        </h1>
                        <p class="promo-sub">
                            Nhập email hoặc số điện thoại liên kết với tài khoản của bạn.
                            Chúng tôi sẽ gửi hướng dẫn để đặt lại mật khẩu.
                        </p>
                        <ul class="promo-benefits">
                            <li>An toàn và nhanh chóng</li>
                            <li>Hướng dẫn bằng email hoặc SMS</li>
                            <li>Hỗ trợ 24/7</li>
                        </ul>
                    </div>
                </div>

                <!-- RIGHT -->
                <div class="form-col">
                    <div class="form-wrap">
                        <h2 class="form-title">Đặt lại mật khẩu</h2>
                        <p class="form-subtitle">Nhập thông tin tài khoản của bạn để tiếp tục</p>

                        <c:if test="${not empty error}">
                            <div class="auth-error">
                                <i class="fa fa-exclamation-circle"></i> ${error}
                            </div>
                        </c:if>

                        <!-- Inline validation message -->
                        <div id="validationMessage" class="auth-error" style="display: none;">
                            <i class="fa fa-exclamation-circle"></i> <span id="validationText"></span>
                        </div>

                        <form id="resetForm" action="${pageContext.request.contextPath}/doResetPassword" method="post">
                            <div class="form-group mb-3">
                                <label for="input">
                                    <i class="fa fa-envelope"></i> Email hoặc số điện thoại
                                </label>
                                <input id="input" name="input" class="form-control"
                                    placeholder="Nhập email hoặc số điện thoại" required
                                    value="${not empty input ? input : ''}" />
                            </div>

                            <button class="btn-login" type="submit">
                                <i class="fa fa-paper-plane"></i> Gửi yêu cầu
                            </button>
                        </form>

                        <div class="divider">Hoặc</div>
                        <div class="register-link">
                            <a href="${pageContext.request.contextPath}/login">
                                <i class="fa fa-arrow-left"></i> Trở về đăng nhập
                            </a>
                        </div>

                        <c:if test="${not empty message}">
                            <div class="auth-message">
                                <i class="fa fa-check-circle"></i> ${message}
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

            <style>
                /* Inline validation styles */
                .error-input {
                    border-color: #D10024 !important;
                    box-shadow: 0 0 0 3px rgba(209, 0, 36, 0.1) !important;
                    animation: shake 0.3s ease-in-out;
                }

                @keyframes shake {

                    0%,
                    100% {
                        transform: translateX(0);
                    }

                    25% {
                        transform: translateX(-5px);
                    }

                    75% {
                        transform: translateX(5px);
                    }
                }

                #validationMessage {
                    animation: slideDown 0.3s ease-out;
                }

                @keyframes slideDown {
                    from {
                        opacity: 0;
                        transform: translateY(-10px);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }

                .auth-error,
                .auth-message {
                    animation: slideDown 0.3s ease-out;
                }
            </style>

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

                // Validation form
                document.getElementById('resetForm').addEventListener('submit', function (e) {
                    const input = document.getElementById('input');
                    const inputValue = input.value.trim();

                    // Ẩn thông báo cũ
                    document.getElementById('validationMessage').style.display = 'none';

                    // Kiểm tra không để trống
                    if (!inputValue) {
                        e.preventDefault();
                        showValidationError('Vui lòng nhập email hoặc số điện thoại!', input);
                        return false;
                    }

                    // Kiểm tra định dạng (email hoặc phone)
                    const emailRegex = /^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$/i;
                    const phoneRegex = /^[0-9]{10}$/;

                    if (!emailRegex.test(inputValue) && !phoneRegex.test(inputValue)) {
                        e.preventDefault();
                        showValidationError('Vui lòng nhập email hợp lệ hoặc số điện thoại 10 chữ số!', input);
                        return false;
                    }

                    return true;
                });

                // Xóa error khi user bắt đầu nhập lại
                document.getElementById('input').addEventListener('input', function () {
                    this.classList.remove('error-input');
                    document.getElementById('validationMessage').style.display = 'none';
                });

                // Auto-hide server messages
                const alerts = document.querySelectorAll('.auth-error, .auth-message');
                alerts.forEach(alert => {
                    if (alert.id !== 'validationMessage') {
                        setTimeout(() => {
                            alert.style.transition = 'opacity 0.5s ease-out';
                            alert.style.opacity = '0';
                            setTimeout(() => alert.remove(), 500);
                        }, 5000);
                    }
                });
            </script>
        </body>

        </html>