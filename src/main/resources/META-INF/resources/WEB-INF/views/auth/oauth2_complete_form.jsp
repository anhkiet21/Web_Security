<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            <title>Hoàn tất đăng ký - CellPhoneStore</title>

            <!-- Google Fonts -->
            <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800&display=swap"
                rel="stylesheet" />

            <!-- Font Awesome -->
            <link rel="stylesheet"
                href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />

            <!-- Bootstrap -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />

            <!-- CSS same as login -->
            <c:url value="/css/header.css" var="headerCss" />
            <c:url value="/css/login.css" var="loginCss" />
            <link rel="stylesheet" href="${headerCss}" />
            <link rel="stylesheet" href="${loginCss}" />
        </head>

        <body class="login-page">
            <jsp:include page="/common/header.jsp" />

            <div class="login-container">
                <div class="login-card">
                    <h2>Hoàn tất thông tin</h2>
                    <p class="subtitle">Vui lòng cung cấp thêm một số thông tin để hoàn tất đăng ký</p>

                    <form action="${pageContext.request.contextPath}/oauth2/complete" method="post">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">
                                <i class="fa fa-exclamation-circle"></i> ${error}
                            </div>
                        </c:if>
                        <c:if test="${not empty message}">
                            <div class="alert alert-success">
                                <i class="fa fa-check-circle"></i> ${message}
                            </div>
                        </c:if>

                        <!-- Inline validation message -->
                        <div id="validationMessage" class="alert alert-danger" style="display: none;">
                            <i class="fa fa-exclamation-circle"></i> <span id="validationText"></span>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">
                                <i class="fa fa-envelope"></i> Email
                                <span style="color:#28a745; font-size:12px; font-weight:500; margin-left:8px;">
                                    <i class="fa fa-check-circle"></i> Đã xác thực
                                </span>
                            </label>
                            <input type="email" name="email" class="form-control" value="${email}" readonly
                                style="background:#F8F9FA; cursor:not-allowed;" />
                            <small style="color:#8D99AE; font-size:12px; display:block; margin-top:5px;">
                                <i class="fa fa-info-circle"></i> Email từ tài khoản Google không thể thay đổi
                            </small>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">
                                <i class="fa fa-user"></i> Họ và tên
                            </label>
                            <input type="text" name="fullName" class="form-control"
                                value="${not empty fullName ? fullName : name}" placeholder="Nhập họ và tên đầy đủ"
                                required />
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">
                                    <i class="fa fa-phone"></i> Số điện thoại
                                </label>
                                <input type="text" name="phone" class="form-control"
                                    value="${not empty phone ? phone : ''}" placeholder="Nhập số điện thoại" required />
                            </div>

                            <div class="col-md-6 mb-3">
                                <label class="form-label">
                                    <i class="fa fa-map-marker"></i> Địa chỉ
                                    <span style="color:#8D99AE; font-size:12px; font-weight:400;">(không bắt
                                        buộc)</span>
                                </label>
                                <input type="text" name="address" class="form-control"
                                    value="${not empty address ? address : ''}" placeholder="Nhập địa chỉ" />
                            </div>
                        </div>

                        <div style="display:flex; gap:15px; margin-top:20px;">
                            <a class="btn btn-google" href="${pageContext.request.contextPath}/login"
                                style="flex:1; text-align:center; text-decoration:none; display:flex; align-items:center; justify-content:center; gap:8px;">
                                <i class="fa fa-arrow-left"></i> Quay lại
                            </a>
                            <button type="submit" class="btn btn-login" style="flex:2;">
                                <i class="fa fa-check"></i> Hoàn tất và tiếp tục
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

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
                        inputElement.style.borderColor = '#D10024';
                        inputElement.style.boxShadow = '0 0 0 3px rgba(209, 0, 36, 0.1)';
                    }

                    // Ẩn thông báo sau 5 giây
                    setTimeout(() => {
                        validationMessage.style.display = 'none';
                        if (inputElement) {
                            inputElement.style.borderColor = '';
                            inputElement.style.boxShadow = '';
                        }
                    }, 5000);
                }

                // Validation form
                document.querySelector('form').addEventListener('submit', function (e) {
                    const fullName = document.querySelector('input[name="fullName"]');
                    const phone = document.querySelector('input[name="phone"]');

                    // Ẩn thông báo cũ
                    document.getElementById('validationMessage').style.display = 'none';

                    // Kiểm tra họ tên
                    if (!fullName.value.trim()) {
                        e.preventDefault();
                        showValidationError('Vui lòng nhập họ và tên!', fullName);
                        return false;
                    }

                    if (fullName.value.trim().length < 3) {
                        e.preventDefault();
                        showValidationError('Họ và tên phải có ít nhất 3 ký tự!', fullName);
                        return false;
                    }

                    // Kiểm tra số điện thoại
                    const phoneValue = phone.value.trim();
                    if (!phoneValue) {
                        e.preventDefault();
                        showValidationError('Vui lòng nhập số điện thoại!', phone);
                        return false;
                    }

                    const phoneRegex = /^[0-9]{10}$/;
                    if (!phoneRegex.test(phoneValue)) {
                        e.preventDefault();
                        showValidationError('Số điện thoại phải có đúng 10 chữ số!', phone);
                        return false;
                    }

                    return true;
                });

                // Chỉ cho phép nhập số vào ô điện thoại
                const phoneInput = document.querySelector('input[name="phone"]');
                if (phoneInput) {
                    phoneInput.addEventListener('input', function (e) {
                        this.value = this.value.replace(/[^0-9]/g, '');
                        if (this.value.length > 10) {
                            this.value = this.value.slice(0, 10);
                        }
                        // Xóa error khi bắt đầu sửa
                        this.style.borderColor = '';
                        this.style.boxShadow = '';
                        document.getElementById('validationMessage').style.display = 'none';
                    });
                }

                // Xóa error khi user bắt đầu nhập lại
                document.querySelectorAll('.form-control').forEach(input => {
                    input.addEventListener('input', function () {
                        this.style.borderColor = '';
                        this.style.boxShadow = '';
                        document.getElementById('validationMessage').style.display = 'none';
                    });
                });

                // Auto-hide alert messages
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(alert => {
                    if (!alert.id || alert.id !== 'validationMessage') {
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