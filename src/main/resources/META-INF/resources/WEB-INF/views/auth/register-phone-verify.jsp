<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <!doctype html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            <title>Xác thực số điện thoại - CellPhoneStore</title>

            <!-- Google Fonts -->
            <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800&display=swap"
                rel="stylesheet" />

            <!-- Font Awesome -->
            <link rel="stylesheet"
                href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />

            <!-- Bootstrap -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />

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
                    <div class="text-center mb-3">
                        <i class="fa fa-check-circle" style="font-size: 60px; color: #4CAF50;"></i>
                    </div>

                    <h2>Đăng ký thành công!</h2>
                    <p class="subtitle">Tài khoản của bạn đã được tạo. Vui lòng xác thực số điện thoại để hoàn tất.</p>

                    <c:if test="${not empty message}">
                        <div class="alert alert-success">
                            <i class="fa fa-check-circle"></i> ${message}
                        </div>
                    </c:if>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">
                            <i class="fa fa-exclamation-circle"></i> ${error}
                        </div>
                    </c:if>

                    <div class="mb-4 p-3 text-center"
                        style="background: #f8f9fa; border-radius: 8px; border-left: 4px solid #D10024;">
                        <div style="color: #8D99AE; font-size: 13px; font-weight: 600; margin-bottom: 5px;">SỐ ĐIỆN
                            THOẠI</div>
                        <div style="color: #D10024; font-size: 20px; font-weight: 700; letter-spacing: 1px;">${phone}
                        </div>
                    </div>

                    <div class="mb-4 p-3" style="background: #f8f9fa; border-radius: 8px;">
                        <div
                            style="color: #2B2D42; font-weight: 600; font-size: 14px; margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                            <i class="fa fa-shield" style="color: #D10024;"></i>
                            Lợi ích khi xác thực
                        </div>
                        <ul style="list-style: none; padding: 0; margin: 0; font-size: 13px; color: #5D6775;">
                            <li style="padding: 6px 0; display: flex; align-items: center; gap: 8px;">
                                <i class="fa fa-check" style="color: #4CAF50; font-size: 11px;"></i>
                                Bảo vệ tài khoản khỏi truy cập trái phép
                            </li>
                            <li style="padding: 6px 0; display: flex; align-items: center; gap: 8px;">
                                <i class="fa fa-check" style="color: #4CAF50; font-size: 11px;"></i>
                                Khôi phục mật khẩu dễ dàng qua SMS
                            </li>
                            <li style="padding: 6px 0; display: flex; align-items: center; gap: 8px;">
                                <i class="fa fa-check" style="color: #4CAF50; font-size: 11px;"></i>
                                Tăng mức độ tin cậy với người bán
                            </li>
                        </ul>
                    </div>

                    <div class="mb-4 p-3"
                        style="background: #FFF3CD; border-radius: 8px; border-left: 4px solid #FFC107;">
                        <p style="margin: 0; font-size: 13px; color: #856404; line-height: 1.6;">
                            <i class="fa fa-info-circle" style="color: #FFC107; margin-right: 6px;"></i>
                            <strong>Lưu ý:</strong> Bạn đã được đăng nhập tự động sau khi đăng ký.
                            Vui lòng xác thực số điện thoại để bảo vệ tài khoản tốt hơn.
                        </p>
                    </div>

                    <!-- OTP Section (always visible after registration) -->
                    <div id="otpSection">
                        <div class="mb-3">
                            <label for="otp" class="form-label">
                                <i class="fa fa-lock"></i> Nhập mã OTP (6 chữ số)
                            </label>
                            <input type="text" class="form-control" id="otp" name="otp" maxlength="6"
                                placeholder="000000" pattern="[0-9]{6}" inputmode="numeric" autocomplete="off" />
                        </div>

                        <button type="button" onclick="sendOTP()" class="btn btn-google w-100 mb-2" id="sendOtpBtn">
                            <i class="fa fa-paper-plane"></i> Gửi mã OTP
                        </button>

                        <button type="button" onclick="verifyOTP()" class="btn btn-login w-100 text-white mb-3"
                            id="verifyOtpBtn" disabled>
                            <i class="fa fa-check"></i> Xác nhận OTP
                        </button>
                    </div>

                    <hr />

                    <form method="post" action="${pageContext.request.contextPath}/register-phone-skip"
                        style="margin: 0;">
                        <button type="submit" class="btn btn-google w-100">
                            <i class="fa fa-clock-o"></i> Để sau (Xác thực trong cài đặt)
                        </button>
                    </form>
                </div>
            </div>

            <!-- Bootstrap JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

            <style>
                /* Inline alert animations */
                #dynamicAlert {
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

                .form-control.error-input {
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

                .alert {
                    animation: slideDown 0.3s ease-out;
                }
            </style>

            <script>
                const ctx = '${pageContext.request.contextPath}';

                // Auto hide alerts after 5 seconds
                setTimeout(() => {
                    const alerts = document.querySelectorAll('.alert');
                    alerts.forEach(alert => {
                        alert.style.display = 'none';
                    });
                }, 5000);

                function showAlert(message, type) {
                    const alertsContainer = document.querySelector('.login-card');

                    // Remove existing dynamic alert
                    const existingAlert = document.getElementById('dynamicAlert');
                    if (existingAlert) {
                        existingAlert.remove();
                    }

                    // Create new alert
                    const alertDiv = document.createElement('div');
                    alertDiv.id = 'dynamicAlert';
                    alertDiv.className = 'alert alert-' + type;
                    alertDiv.innerHTML = '<i class="fa fa-' + (type === 'success' ? 'check' : 'exclamation') + '-circle"></i> ' + message;

                    // Insert after subtitle
                    const subtitle = alertsContainer.querySelector('.subtitle');
                    subtitle.after(alertDiv);

                    setTimeout(() => {
                        alertDiv.style.display = 'none';
                    }, 5000);
                }

                function sendOTP() {
                    const sendBtn = document.getElementById('sendOtpBtn');
                    const originalHTML = sendBtn.innerHTML;
                    sendBtn.disabled = true;
                    sendBtn.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Đang gửi...';

                    fetch(ctx + '/api/send-otp?type=phone', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        }
                    })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                showAlert(data.message, 'success');
                                enableVerifyButton();

                                // Cooldown 60 seconds
                                let countdown = 60;
                                const interval = setInterval(() => {
                                    countdown--;
                                    sendBtn.innerHTML = '<i class="fa fa-clock-o"></i> Gửi lại sau ' + countdown + 's';

                                    if (countdown <= 0) {
                                        clearInterval(interval);
                                        sendBtn.disabled = false;
                                        sendBtn.innerHTML = '<i class="fa fa-paper-plane"></i> Gửi lại mã OTP';
                                    }
                                }, 1000);
                            } else {
                                showAlert(data.message, 'danger');
                                sendBtn.disabled = false;
                                sendBtn.innerHTML = originalHTML;
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            showAlert('Lỗi kết nối. Vui lòng thử lại.', 'danger');
                            sendBtn.disabled = false;
                            sendBtn.innerHTML = originalHTML;
                        });
                }

                function enableVerifyButton() {
                    document.getElementById('verifyOtpBtn').disabled = false;
                }

                function verifyOTP() {
                    const otpInput = document.getElementById('otp');
                    const otpValue = otpInput.value.trim();

                    if (otpValue.length !== 6) {
                        showAlert('Vui lòng nhập đủ 6 chữ số OTP', 'danger');
                        otpInput.classList.add('error-input');
                        otpInput.focus();

                        // Remove error class after animation
                        setTimeout(() => {
                            otpInput.classList.remove('error-input');
                        }, 500);
                        return;
                    }

                    const verifyBtn = document.getElementById('verifyOtpBtn');
                    const originalHTML = verifyBtn.innerHTML;

                    otpInput.disabled = true;
                    verifyBtn.disabled = true;
                    verifyBtn.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Đang xác thực...';

                    fetch(ctx + '/api/verify-otp', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        },
                        body: 'otp=' + encodeURIComponent(otpValue)
                    })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                showAlert(data.message + ' Đang chuyển hướng...', 'success');

                                setTimeout(() => {
                                    window.location.href = ctx + '/';
                                }, 1500);
                            } else {
                                showAlert(data.message, 'danger');
                                otpInput.classList.add('error-input');
                                otpInput.disabled = false;
                                otpInput.value = '';
                                otpInput.focus();
                                verifyBtn.disabled = false;
                                verifyBtn.innerHTML = originalHTML;

                                // Remove error class after animation
                                setTimeout(() => {
                                    otpInput.classList.remove('error-input');
                                }, 500);
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            showAlert('Lỗi kết nối. Vui lòng thử lại.', 'danger');
                            otpInput.disabled = false;
                            verifyBtn.disabled = false;
                            verifyBtn.innerHTML = originalHTML;
                        });
                }

                // Auto-format OTP input (only numbers)
                document.getElementById('otp').addEventListener('input', function (e) {
                    this.value = this.value.replace(/[^0-9]/g, '');
                    this.classList.remove('error-input');
                });
            </script>
        </body>

        </html>