<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Chi tiết đơn hàng - CellPhoneStore</title>
                <style nonce="${cspNonce}">
                    /* Order Detail Page Styles */
                    .order-detail-title {
                        color: #333;
                        margin-bottom: 30px;
                        font-size: 28px;
                        font-weight: bold;
                        text-align: center;
                    }

                    .order-status-badge {
                        display: inline-block;
                        padding: 8px 20px;
                        border-radius: 20px;
                        font-weight: 600;
                        font-size: 14px;
                        text-transform: uppercase;
                        white-space: nowrap;
                    }

                    .status-pending {
                        background: #fff3cd;
                        color: #856404;
                    }

                    .status-success {
                        background: #d4edda;
                        color: #155724;
                    }

                    .status-cancelled {
                        background: #f8d7da;
                        color: #721c24;
                    }

                    .info-card {
                        background: white;
                        border-radius: 8px;
                        padding: 25px;
                        margin-bottom: 20px;
                        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                    }

                    .info-card h3 {
                        color: #d70018;
                        font-size: 20px;
                        margin-bottom: 15px;
                        padding-bottom: 10px;
                        border-bottom: 2px solid #e0e0e0;
                    }

                    .info-row {
                        display: flex;
                        padding: 10px 0;
                        border-bottom: 1px solid #f5f5f5;
                        flex-wrap: wrap;
                        align-items: flex-start;
                    }

                    .info-row:last-child {
                        border-bottom: none;
                    }

                    .info-label {
                        font-weight: 600;
                        color: #555;
                        min-width: 100px;
                        flex-shrink: 0;
                    }

                    .info-value {
                        color: #333;
                        flex: 1;
                        word-wrap: break-word;
                        word-break: break-word;
                        overflow-wrap: break-word;
                        min-width: 0;
                    }

                    .product-table {
                        width: 100%;
                        border-collapse: collapse;
                        margin-top: 15px;
                    }

                    .product-table th {
                        background: #f8f9fa;
                        color: #333;
                        font-weight: 600;
                        padding: 15px;
                        text-align: left;
                        border-bottom: 2px solid #dee2e6;
                    }

                    .product-table td {
                        padding: 15px;
                        border-bottom: 1px solid #f0f0f0;
                        vertical-align: middle;
                    }

                    .product-img {
                        width: 80px;
                        height: 80px;
                        object-fit: contain;
                        border-radius: 8px;
                        border: 1px solid #e0e0e0;
                    }

                    .product-name {
                        font-weight: 600;
                        color: #333;
                    }

                    .product-price {
                        color: #d70018;
                        font-weight: 600;
                    }

                    .total-row {
                        background: #f8f9fa;
                        font-weight: 700;
                        font-size: 18px;
                        color: #d70018;
                    }

                    .payment-section {
                        background: white;
                        border-radius: 8px;
                        padding: 30px;
                        margin-top: 30px;
                        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                        text-align: center;
                    }

                    .payment-method-select {
                        width: 100%;
                        max-width: 400px;
                        padding: 12px 15px;
                        font-size: 16px;
                        border: 2px solid #ddd;
                        border-radius: 8px;
                        margin: 20px 0;
                        transition: border-color 0.3s;
                    }

                    .payment-method-select:focus {
                        outline: none;
                        border-color: #d70018;
                    }

                    .btn-action {
                        padding: 14px 30px;
                        font-size: 16px;
                        font-weight: 600;
                        border: none;
                        border-radius: 8px;
                        cursor: pointer;
                        transition: all 0.3s;
                        margin: 10px 5px;
                        text-decoration: none;
                        display: inline-block;
                    }

                    .btn-primary {
                        background: linear-gradient(135deg, #d70018 0%, #f05423 100%);
                        color: white;
                    }

                    .btn-primary:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 4px 12px rgba(215, 0, 24, 0.3);
                    }

                    .btn-primary:disabled {
                        background: #ccc;
                        cursor: not-allowed;
                        transform: none;
                    }

                    .btn-secondary {
                        background: #6c757d;
                        color: white;
                    }

                    .btn-secondary:hover {
                        background: #5a6268;
                    }

                    .btn-info {
                        background: #17a2b8;
                        color: white;
                    }

                    .btn-info:hover {
                        background: #138496;
                    }

                    .alert-message {
                        padding: 15px 20px;
                        border-radius: 8px;
                        margin: 20px 0;
                        font-weight: 600;
                    }

                    .alert-success {
                        background: #d4edda;
                        color: #155724;
                        border: 1px solid #c3e6cb;
                        padding: 18px 20px;
                        border-radius: 8px;
                        margin-bottom: 20px;
                        font-size: 15px;
                        display: flex;
                        align-items: center;
                        gap: 10px;
                    }

                    .alert-success i {
                        font-size: 20px;
                    }

                    .alert-warning {
                        background: #fff3cd;
                        color: #856404;
                        border: 1px solid #ffc107;
                        padding: 18px 20px;
                        border-radius: 8px;
                        margin-bottom: 20px;
                        font-size: 15px;
                        display: flex;
                        align-items: center;
                        gap: 10px;
                    }

                    .alert-warning i {
                        font-size: 20px;
                    }

                    .alert-info {
                        background: #d1ecf1;
                        color: #0c5460;
                        border: 1px solid #bee5eb;
                        padding: 18px 20px;
                        border-radius: 8px;
                        margin-bottom: 20px;
                        font-size: 15px;
                        display: flex;
                        align-items: center;
                        gap: 10px;
                    }

                    .alert-info i {
                        font-size: 20px;
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
                                    <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                                    <li class="active">Chi tiết đơn hàng #${order.orderId}</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- /BREADCRUMB -->

                <!-- ORDER DETAIL SECTION -->
                <div class="section">
                    <div class="container">
                        <h1 class="order-detail-title">
                            <i class="fa fa-file-text-o"></i> Chi tiết đơn hàng #${order.orderId}
                        </h1>

                        <div class="row">
                            <!-- Left Column - Order Info -->
                            <div class="col-md-8">
                                <!-- User Information -->
                                <div class="info-card">
                                    <h3><i class="fa fa-user"></i> Thông tin người nhận</h3>
                                    <div class="info-row">
                                        <span class="info-label">Họ tên:</span>
                                        <%-- [FIX Stored XSS] User PII in order info --%>
                                        <span class="info-value"><c:out value="${user.fullName}"/></span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Email:</span>
                                        <span class="info-value"><c:out value="${user.email}"/></span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Số điện thoại:</span>
                                        <span class="info-value"><c:out value="${user.phone}"/></span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Địa chỉ giao hàng:</span>
                                        <span class="info-value"><c:out value="${order.shippingAddress}"/></span>
                                    </div>
                                </div>

                                <!-- Products Table -->
                                <div class="info-card">
                                    <h3><i class="fa fa-shopping-bag"></i> Sản phẩm trong đơn hàng</h3>
                                    <table class="product-table">
                                        <thead>
                                            <tr>
                                                <th style="width: 100px;">Ảnh</th>
                                                <th>Tên sản phẩm</th>
                                                <th style="width: 120px; text-align: center;">Đơn giá</th>
                                                <th style="width: 80px; text-align: center;">SL</th>
                                                <th style="width: 140px; text-align: right;">Thành tiền</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${order.items}">
                                                <tr>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty item.productImageUrl}">
                                                                <img class="product-img"
                                                                    src="${pageContext.request.contextPath}${item.productImageUrl}"
                                                                    <%-- Stored XSS: product name in alt attribute - fix: c:out --%> alt="<c:out value='${item.productName}'/>" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <img class="product-img"
                                                                    src="${pageContext.request.contextPath}/images/no-image.png"
                                                                    alt="No Image" />
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="product-name"><c:out value="${item.productName}"/></div>
                                                    </td>
                                                    <td style="text-align: center;">
                                                        <span class="product-price">
                                                            <fmt:formatNumber value="${item.price}" type="number"
                                                                groupingUsed="true" />₫
                                                        </span>
                                                    </td>
                                                    <td style="text-align: center;">${item.quantity}</td>
                                                    <td style="text-align: right;">
                                                        <span class="product-price">
                                                            <fmt:formatNumber value="${item.price * item.quantity}"
                                                                type="number" groupingUsed="true" />₫
                                                        </span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <tr class="total-row">
                                                <td colspan="4" style="text-align: right; padding-right: 20px;">Tổng
                                                    cộng:</td>
                                                <td style="text-align: right;">
                                                    <fmt:formatNumber value="${order.totalAmount}" type="number"
                                                        groupingUsed="true" />₫
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!-- Right Column - Order Status & Payment -->
                            <div class="col-md-4">
                                <div class="info-card">
                                    <h3><i class="fa fa-info-circle"></i> Thông tin đơn hàng</h3>
                                    <div class="info-row">
                                        <span class="info-label">Mã đơn hàng:</span>
                                        <span class="info-value">#${order.orderId}</span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Trạng thái:</span>
                                        <span class="info-value">
                                            <span
                                                class="order-status-badge status-${order.status == 'SUCCESS' ? 'success' : 'pending'}">
                                                <c:out value="${order.status}"/>
                                            </span>
                                        </span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Ngày tạo:</span>
                                        <span class="info-value">${order.createdAt}</span>
                                    </div>

                                    <!-- Cancel Note -->
                                    <c:if test="${order.status == 'CANCELLED' && not empty order.cancelNote}">
                                        <div class="info-row" style="margin-top: 15px;">
                                            <div
                                                style="width: 100%; background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; border-radius: 4px;">
                                                <div style="display: flex; align-items: center; margin-bottom: 8px;">
                                                    <i class="fa fa-info-circle"
                                                        style="color: #856404; margin-right: 8px; font-size: 18px;"></i>
                                                    <strong style="color: #856404; font-size: 16px;">Lý do hủy
                                                        đơn:</strong>
                                                </div>
                                                <p
                                                    style="color: #856404; margin: 0; padding-left: 26px; line-height: 1.6;">
                                                    <c:out value="${order.cancelNote}"/>
                                                </p>
                                            </div>
                                        </div>
                                    </c:if>

                                    <div class="info-row"
                                        style="border-top: 2px solid #d70018; padding-top: 15px; margin-top: 15px;">
                                        <span class="info-label" style="font-size: 18px;">Tổng tiền:</span>
                                        <span class="info-value"
                                            style="font-size: 20px; color: #d70018; font-weight: 700;">
                                            <fmt:formatNumber value="${order.totalAmount}" type="number"
                                                groupingUsed="true" />₫
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>


                        <!-- Payment Section -->
                        <div class="row">
                            <div class="col-md-12">
                                <div class="info-card payment-section">
                                    <c:choose>
                                        <c:when test="${statusPayment.status == null}">
                                            <div class="alert-warning">
                                                <i class="fa fa-exclamation-circle"></i>
                                                Giao dịch chưa được tạo. Vui lòng chọn phương thức thanh toán và xác
                                                nhận.
                                            </div>

                                            <h3><i class="fa fa-credit-card"></i> Chọn phương thức thanh toán</h3>
                                            <div class="payment-method-select">
                                                <select id="payment-method" class="form-control">
                                                    <option value="COD">💵 Thanh toán khi nhận hàng (COD)</option>
                                                    <option value="VNPAY">💳 Thanh toán qua VNPAY</option>
                                                </select>
                                            </div>

                                            <div class="payment-actions">
                                                <a href="${pageContext.request.contextPath}/profile#orders"
                                                    class="btn btn-secondary">
                                                    <i class="fa fa-arrow-left"></i> Quay lại
                                                </a>
                                                <button id="confirm-purchase-btn" class="btn btn-primary"
                                                    onclick="confirmPurchase(${order.orderId})">
                                                    <i class="fa fa-check-circle"></i> Xác nhận mua hàng
                                                </button>
                                            </div>
                                        </c:when>

                                        <c:when
                                            test="${statusPayment.status == 'PENDING' && statusPayment.method == 'COD'}">
                                            <div class="alert-info">
                                                <i class="fa fa-info-circle"></i>
                                                Đơn hàng đã được đặt thành công với phương thức thanh toán khi nhận hàng
                                                (COD).
                                            </div>
                                            <div class="payment-actions">
                                                <a href="${pageContext.request.contextPath}/profile#orders"
                                                    class="btn btn-primary">
                                                    <i class="fa fa-list"></i> Quay lại danh sách đơn hàng
                                                </a>
                                            </div>
                                        </c:when>

                                        <c:when test="${statusPayment.status == 'PENDING'}">
                                            <div class="alert-warning">
                                                <i class="fa fa-clock-o"></i>
                                                Đơn hàng đang chờ thanh toán. Vui lòng hoàn tất thanh toán.
                                            </div>

                                            <h3><i class="fa fa-credit-card"></i> Chọn phương thức thanh toán</h3>
                                            <div class="payment-method-select">
                                                <select id="payment-method" class="form-control">
                                                    <option value="VNPAY">💳 Thanh toán qua VNPAY</option>
                                                </select>
                                            </div>

                                            <div class="payment-actions">
                                                <a href="${pageContext.request.contextPath}/profile#orders"
                                                    class="btn btn-secondary">
                                                    <i class="fa fa-arrow-left"></i> Quay lại
                                                </a>
                                                <button id="confirm-purchase-btn" class="btn btn-primary"
                                                    onclick="confirmPurchase(${order.orderId})">
                                                    <i class="fa fa-credit-card"></i> Tiếp tục thanh toán
                                                </button>
                                            </div>
                                        </c:when>

                                        <c:when test="${statusPayment.status == 'SUCCESS'}">
                                            <div class="alert-success">
                                                <i class="fa fa-check-circle"></i>
                                                Thanh toán đã hoàn tất! Cảm ơn bạn đã mua hàng.
                                            </div>
                                            <div class="payment-actions">
                                                <a href="${pageContext.request.contextPath}/profile#orders"
                                                    class="btn btn-primary">
                                                    <i class="fa fa-list"></i> Quay lại danh sách đơn hàng
                                                </a>
                                            </div>
                                        </c:when>
                                        <c:when test="${statusPayment.status == 'REFUNDING'}">
                                            <div class="alert-success">
                                                <i class="fa fa-check-circle"></i>
                                                Đơn hàng đã được hủy và hoàn tiền thành công. Tiền sẽ được hoàn lại vào
                                                tài khoản
                                                khách hàng trong 5-7 ngày làm việc.
                                            </div>
                                            <div class="payment-actions">
                                                <a href="${pageContext.request.contextPath}/profile#orders"
                                                    class="btn btn-primary">
                                                    <i class="fa fa-list"></i> Quay lại danh sách đơn hàng
                                                </a>
                                            </div>
                                        </c:when>

                                        <c:otherwise>
                                            <div class="alert-info">
                                                <i class="fa fa-info-circle"></i>
                                                Trạng thái giao dịch: <strong><c:out value="${statusPayment.status}"/></strong>
                                            </div>

                                            <h3><i class="fa fa-credit-card"></i> Chọn phương thức thanh toán</h3>
                                            <div class="payment-method-select">
                                                <select id="payment-method" class="form-control">
                                                    <option value="COD">💵 Thanh toán khi nhận hàng (COD)</option>
                                                    <option value="VNPAY">💳 Thanh toán qua VNPAY</option>
                                                </select>
                                            </div>

                                            <div class="payment-actions">
                                                <a href="${pageContext.request.contextPath}/profile#orders"
                                                    class="btn btn-secondary">
                                                    <i class="fa fa-arrow-left"></i> Quay lại
                                                </a>
                                                <button id="confirm-purchase-btn" class="btn btn-primary"
                                                    onclick="confirmPurchase(${order.orderId})">
                                                    <i class="fa fa-refresh"></i> Tạo lại giao dịch thanh toán
                                                </button>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>

                                    <div class="payment-actions"
                                        style="margin-top: 20px; border-top: 1px solid #e0e0e0; padding-top: 20px;">
                                        <button id="refresh-status-btn" class="btn btn-action"
                                            onclick="refreshTransactionStatus(${order.orderId})">
                                            <i class="fa fa-refresh"></i> Làm mới trạng thái giao dịch
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- /ORDER DETAIL SECTION -->

                <script nonce="${cspNonce}">
                    // Inline Alert System
                    function showInlineAlert(message, type = 'danger') {
                        // Remove existing alerts
                        document.querySelectorAll('.inline-alert').forEach(alert => alert.remove());

                        // Create alert element
                        const alertDiv = document.createElement('div');
                        alertDiv.className = 'inline-alert inline-alert-' + type;
                        alertDiv.innerHTML = '<i class="fa fa-' + (type === 'success' ? 'check-circle' : type === 'warning' ? 'exclamation-triangle' : 'exclamation-circle') + '"></i> <span>' + escapeHtml(message) + '</span>';

                        // Insert at top of payment section
                        const paymentSection = document.querySelector('.payment-section');
                        if (paymentSection) {
                            paymentSection.insertBefore(alertDiv, paymentSection.firstChild);
                        }

                        // Scroll to alert
                        alertDiv.scrollIntoView({ behavior: 'smooth', block: 'nearest' });

                        // Auto-hide after 5 seconds
                        setTimeout(() => {
                            alertDiv.style.opacity = '0';
                            setTimeout(() => alertDiv.remove(), 500);
                        }, 5000);
                    }

                    function refreshTransactionStatus(orderId) {
                        const btn = document.getElementById('refresh-status-btn');
                        btn.disabled = true;
                        btn.textContent = 'Đang làm mới...';
                        debugger;
                        fetch('/api/vnpay/payment/query', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                                'Authorization': 'Bearer ' + localStorage.getItem('accessToken') // nếu dùng JWT
                            },
                            body: `order_id=${orderId}`
                        })
                            .then(response => {
                                if (!response.ok) {
                                    throw new Error('Lỗi khi làm mới trạng thái: ' + response.status);
                                }
                                return response.text();
                            })
                            .then(result => {
                                console.log('Kết quả làm mới trạng thái:', result);
                                // Reload lại trang để cập nhật trạng thái mới
                                window.location.reload();
                            })
                            .catch(error => {
                                console.error(error);
                                showInlineAlert('Có lỗi xảy ra: ' + error.message, 'danger');
                                btn.disabled = false;
                                btn.textContent = 'Làm mới trạng thái giao dịch';
                            });
                    }
                    function confirmPurchase(orderId) {
                        const method = document.getElementById('payment-method').value;
                        const confirmBtn = document.getElementById('confirm-purchase-btn');

                        // Vô hiệu hóa nút để tránh nhấn đúp
                        confirmBtn.disabled = true;
                        confirmBtn.textContent = 'Đang xử lý...';
                        // Gọi API Controller duy nhất của bạn
                        // Sử dụng template literals (dấu `) để chèn biến vào URL


                        console.log(`/api/vnpay/payment/create_payment?orderId=${orderId}&method=${method}`);
                        if (method === "COD") {
                            fetch(`/api/vnpay/payment/create_payment?orderId=${orderId}&method=COD`, {
                                method: 'GET', // Phải khớp với @GetMapping
                                headers: {
                                    // QUAN TRỌNG: Nếu API của bạn được bảo vệ bằng Spring Security (JWT),
                                    // bạn phải gửi kèm Token
                                    'Authorization': 'Bearer ' + localStorage.getItem('accessToken')
                                }
                            })
                                .then(response => {
                                    if (!response.ok) {
                                        // Bắt lỗi 4xx, 5xx từ server
                                        throw new Error('Xử lý thanh toán thất bại. Lỗi: ' + response.status);
                                    }
                                    return response.json(); // Đọc response body dạng JSON
                                })
                                .then(data => {
                                    // Xử lý JSON (PaymentResDto) trả về
                                    // API của bạn luôn trả về một đối tượng có 'url'
                                    // - Nếu VNPAY: data.url là link của VNPAY
                                    // - Nếu COD: data.url là link trang thành công (vd: /order/success/123)
                                    if (data && data.url) {
                                        console.log('API thành công. Đang chuyển hướng đến:', data.url);
                                        window.location.href = data.url;
                                    } else {
                                        throw new Error('Response từ server không hợp lệ (không có url).');
                                    }
                                })
                                .catch(error => {
                                    // Xử lý nếu fetch bị lỗi mạng, hoặc lỗi logic ở trên
                                    console.error('Lỗi khi gọi API thanh toán:', error);
                                    showInlineAlert('Có lỗi xảy ra: ' + error.message, 'danger');

                                    // Kích hoạt lại nút để người dùng thử lại
                                    confirmBtn.disabled = false;
                                    confirmBtn.textContent = 'Xác nhận mua hàng';
                                });
                        } else {
                            fetch(`/api/vnpay/payment/create_payment?orderId=${orderId}&method=method=${method}`, {
                                method: 'GET', // Phải khớp với @GetMapping
                                headers: {
                                    // QUAN TRỌNG: Nếu API của bạn được bảo vệ bằng Spring Security (JWT),
                                    // bạn phải gửi kèm Token
                                    'Authorization': 'Bearer ' + localStorage.getItem('accessToken')
                                }
                            })
                                .then(response => {
                                    if (!response.ok) {
                                        // Bắt lỗi 4xx, 5xx từ server
                                        throw new Error('Xử lý thanh toán thất bại. Lỗi: ' + response.status);
                                    }
                                    return response.json(); // Đọc response body dạng JSON
                                })
                                .then(data => {
                                    // Xử lý JSON (PaymentResDto) trả về
                                    // API của bạn luôn trả về một đối tượng có 'url'
                                    // - Nếu VNPAY: data.url là link của VNPAY
                                    // - Nếu COD: data.url là link trang thành công (vd: /order/success/123)
                                    if (data && data.url) {
                                        console.log('API thành công. Đang chuyển hướng đến:', data.url);
                                        window.location.href = data.url;
                                    } else {
                                        throw new Error('Response từ server không hợp lệ (không có url).');
                                    }
                                })
                                .catch(error => {
                                    // Xử lý nếu fetch bị lỗi mạng, hoặc lỗi logic ở trên
                                    console.error('Lỗi khi gọi API thanh toán:', error);
                                    showInlineAlert('Có lỗi xảy ra: ' + error.message, 'danger');

                                    // Kích hoạt lại nút để người dùng thử lại
                                    confirmBtn.disabled = false;
                                    confirmBtn.textContent = 'Xác nhận mua hàng';
                                });
                        }
                    }
                </script>

                <!-- Disable sticky header for this page -->
            </body>

            </html>