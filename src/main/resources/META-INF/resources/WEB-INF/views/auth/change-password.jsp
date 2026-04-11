<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>Đổi mật khẩu</title>
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        margin: 20px;
                    }

                    .container {
                        max-width: 400px;
                        margin: auto;
                    }

                    .form-group {
                        margin-bottom: 15px;
                    }

                    label {
                        display: block;
                        margin-bottom: 5px;
                    }

                    input {
                        width: 100%;
                        padding: 8px;
                    }

                    button {
                        padding: 8px 16px;
                    }

                    .success {
                        color: green;
                        margin-top: 10px;
                    }

                    .error {
                        color: red;
                        margin-top: 10px;
                    }

                    /* Inline validation styles */
                    .error-input {
                        border-color: #dc3545 !important;
                        box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.1) !important;
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

                    .success-input {
                        border-color: #28a745 !important;
                        box-shadow: 0 0 0 3px rgba(40, 167, 69, 0.1) !important;
                    }

                    #pwHelp {
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

                    .alert {
                        animation: slideDown 0.3s ease-out;
                    }
                </style>
            </head>

            <body>
                <div id="profile-content">
                    <div class="container py-3">
                        <div class="card shadow-sm mx-auto" style="max-width:720px;">
                            <div class="card-body">
                                <h4 class="card-title mb-3">Đổi mật khẩu</h4>

                                <!-- Hiển thị thông báo -->
                                <c:if test="${not empty message}">
                                    <div class="alert ${message eq 'Đổi mật khẩu thành công!' ? 'alert-success' : 'alert-danger'}"
                                        role="alert">
                                        ${message}
                                    </div>
                                </c:if>

                                <!-- Form đổi mật khẩu -->
                                <form:form method="post"
                                    action="${pageContext.request.contextPath}/profile/change-password"
                                    modelAttribute="changePassRequest" id="changePasswordForm">
                                    <div class="mb-3">
                                        <label for="password" class="form-label">Mật khẩu cũ</label>
                                        <form:password path="password" id="password" cssClass="form-control"
                                            required="true" />
                                    </div>

                                    <div class="mb-3">
                                        <label for="newPassword" class="form-label">Mật khẩu mới</label>
                                        <form:password path="newPassword" id="newPassword" cssClass="form-control"
                                            required="true" />
                                    </div>

                                    <div class="mb-3">
                                        <label for="confirmNewPassword" class="form-label">Xác nhận mật khẩu mới</label>
                                        <form:password path="confirmNewPassword" id="confirmNewPassword"
                                            cssClass="form-control" required="true" />
                                        <div id="pwHelp" class="form-text text-danger mt-1" style="display:none">Mật
                                            khẩu xác nhận chưa khớp.</div>
                                    </div>

                                    <div class="d-flex gap-2">
                                        <button type="submit" id="changePassBtn" class="btn btn-primary">Đổi mật
                                            khẩu</button>
                                        <button type="button" class="btn btn-outline-secondary"
                                            onclick="history.back()">Hủy</button>
                                    </div>
                                </form:form>
                            </div>
                        </div>
                    </div>
                </div>

                <script>
                    (function () {
                        const newPw = document.getElementById('newPassword');
                        const confirmPw = document.getElementById('confirmNewPassword');
                        const help = document.getElementById('pwHelp');
                        const submitBtn = document.getElementById('changePassBtn');

                        function validateMatch() {
                            const a = newPw && newPw.value ? newPw.value : '';
                            const b = confirmPw && confirmPw.value ? confirmPw.value : '';

                            // Remove previous error classes
                            newPw.classList.remove('error-input', 'success-input');
                            confirmPw.classList.remove('error-input', 'success-input');

                            if (!a && !b) {
                                help.style.display = 'none';
                                submitBtn.disabled = false;
                                return;
                            }

                            if (a !== b) {
                                help.style.display = 'block';
                                submitBtn.disabled = true;
                                // Add error styling to both fields
                                if (a) newPw.classList.add('error-input');
                                if (b) confirmPw.classList.add('error-input');
                            } else {
                                help.style.display = 'none';
                                submitBtn.disabled = false;
                                // Add success styling when matched
                                if (a && b) {
                                    newPw.classList.add('success-input');
                                    confirmPw.classList.add('success-input');
                                }
                            }
                        }

                        if (newPw) newPw.addEventListener('input', validateMatch);
                        if (confirmPw) confirmPw.addEventListener('input', validateMatch);

                        // ensure validation runs when form injected
                        document.addEventListener('DOMContentLoaded', validateMatch);

                        // Auto-hide alert messages after 5 seconds
                        const alerts = document.querySelectorAll('.alert');
                        alerts.forEach(alert => {
                            setTimeout(() => {
                                alert.style.transition = 'opacity 0.5s ease-out';
                                alert.style.opacity = '0';
                                setTimeout(() => alert.remove(), 500);
                            }, 5000);
                        });
                    })();
                </script>
            </body>

            </html>