<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

                <title>Chi tiết đơn hàng #${order.orderId} - CellPhoneStore</title>

                <style>
                    .order-detail-container {
                        max-width: 1200px;
                        margin: 40px auto;
                        padding: 20px;
                        background: #fff;
                        border-radius: 8px;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                    }

                    .header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-bottom: 30px;
                        padding-bottom: 20px;
                        border-bottom: 3px solid #d70018;
                    }

                    .header h1 {
                        color: #d70018;
                        font-size: 28px;
                    }

                    .header .order-id {
                        color: #333;
                        font-size: 24px;
                    }

                    .btn-back {
                        display: inline-block;
                        padding: 10px 20px;
                        background: #6c757d;
                        color: #fff;
                        text-decoration: none;
                        border-radius: 5px;
                        font-weight: bold;
                        transition: background 0.3s;
                    }

                    .btn-back:hover {
                        background: #5a6268;
                    }

                    .btn-back i {
                        margin-right: 5px;
                    }

                    .order-info-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                        gap: 20px;
                        margin-bottom: 30px;
                    }

                    .info-card {
                        background: #f9f9f9;
                        padding: 20px;
                        border-radius: 8px;
                        border-left: 4px solid #d70018;
                    }

                    .info-card h3 {
                        color: #d70018;
                        margin-bottom: 15px;
                        font-size: 18px;
                        display: flex;
                        align-items: center;
                        gap: 10px;
                    }

                    .info-row {
                        display: flex;
                        justify-content: space-between;
                        margin-bottom: 10px;
                        padding: 8px 0;
                        border-bottom: 1px solid #e0e0e0;
                    }

                    .info-row:last-child {
                        border-bottom: none;
                    }

                    .info-label {
                        color: #666;
                        font-weight: 500;
                    }

                    .info-value {
                        color: #333;
                        font-weight: 600;
                        text-align: right;
                    }

                    .status-badge {
                        padding: 6px 14px;
                        border-radius: 4px;
                        font-size: 13px;
                        font-weight: bold;
                        display: inline-block;
                    }

                    .status-pending,
                    .status-paid {
                        background: #ffc107;
                        color: #000;
                    }

                    .status-accepted {
                        background: #17a2b8;
                        color: #fff;
                    }

                    .status-shipping,
                    .status-shipped {
                        background: #007bff;
                        color: #fff;
                    }

                    .status-delivered {
                        background: #28a745;
                        color: #fff;
                    }

                    .status-cancelled {
                        background: #dc3545;
                        color: #fff;
                    }

                    .status-refunded {
                        background: #6c757d;
                        color: #fff;
                    }

                    .status-refund_requested,
                    .status-refunded_request {
                        background: #ffc107;
                        color: #000;
                    }

                    .payment-badge {
                        padding: 6px 14px;
                        border-radius: 4px;
                        font-size: 13px;
                        font-weight: bold;
                        display: inline-block;
                    }

                    .payment-success {
                        background: #28a745;
                        color: #fff;
                    }

                    .payment-cod {
                        background: #ffc107;
                        color: #000;
                    }

                    .payment-pending {
                        background: #6c757d;
                        color: #fff;
                    }

                    .products-section {
                        margin-top: 30px;
                    }

                    .products-section h3 {
                        color: #d70018;
                        margin-bottom: 20px;
                        font-size: 20px;
                        padding-bottom: 10px;
                        border-bottom: 2px solid #d70018;
                        display: flex;
                        align-items: center;
                        gap: 10px;
                    }

                    .product-table {
                        width: 100%;
                        border-collapse: collapse;
                        margin-top: 15px;
                    }

                    .product-table th,
                    .product-table td {
                        border: 1px solid #ddd;
                        padding: 12px;
                        text-align: center;
                    }

                    .product-table th {
                        background: #f2f2f2;
                        font-weight: bold;
                        color: #333;
                    }

                    .product-table tbody tr:hover {
                        background: #f9f9f9;
                    }

                    .product-img {
                        width: 80px;
                        height: 80px;
                        object-fit: cover;
                        border-radius: 4px;
                        border: 1px solid #ddd;
                    }

                    .product-table tfoot {
                        background: #f9f9f9;
                        font-weight: bold;
                    }

                    .product-table tfoot td {
                        font-size: 16px;
                    }

                    .total-amount {
                        color: #d70018;
                        font-size: 18px;
                    }

                    .actions-section {
                        margin-top: 30px;
                        padding: 20px;
                        background: #f9f9f9;
                        border-radius: 8px;
                        text-align: right;
                    }

                    .btn-action {
                        display: inline-block;
                        padding: 12px 24px;
                        margin-left: 10px;
                        border: none;
                        border-radius: 5px;
                        font-weight: bold;
                        font-size: 14px;
                        cursor: pointer;
                        text-decoration: none;
                        transition: all 0.3s;
                    }

                    .btn-accept {
                        background: #28a745;
                        color: #fff;
                    }

                    .btn-accept:hover {
                        background: #218838;
                    }

                    .btn-ship {
                        background: #007bff;
                        color: #fff;
                    }

                    .btn-ship:hover {
                        background: #0056b3;
                    }

                    .btn-deliver {
                        background: #17a2b8;
                        color: #fff;
                    }

                    .btn-deliver:hover {
                        background: #138496;
                    }

                    .btn-refund {
                        background: #ffc107;
                        color: #000;
                    }

                    .btn-refund:hover {
                        background: #e0a800;
                    }

                    .btn-cancel {
                        background: #dc3545;
                        color: #fff;
                    }

                    .btn-cancel:hover {
                        background: #c82333;
                    }

                    .alert {
                        padding: 15px;
                        border-radius: 5px;
                        margin-bottom: 20px;
                    }

                    .alert-success {
                        background: #d4edda;
                        color: #155724;
                        border: 1px solid #c3e6cb;
                    }

                    .alert-error {
                        background: #f8d7da;
                        color: #721c24;
                        border: 1px solid #f5c6cb;
                    }

                    .refund-controls {
                        margin-top: 15px;
                        padding: 15px;
                        background: #fff3cd;
                        border: 1px solid #ffc107;
                        border-radius: 5px;
                        border-left: 4px solid #ffc107;
                    }

                    .refund-controls h5 {
                        color: #856404;
                        margin-bottom: 15px;
                        font-size: 16px;
                    }

                    .refund-controls label {
                        font-weight: bold;
                        margin-right: 10px;
                        color: #333;
                    }

                    .refund-controls select {
                        padding: 8px 15px;
                        margin: 0 15px 10px 5px;
                        border-radius: 4px;
                        border: 1px solid #ddd;
                        font-size: 14px;
                    }

                    /* Cancel Form Styles */
                    .cancel-form {
                        margin-top: 20px;
                        padding: 20px;
                        background: #fff;
                        border: 2px solid #dc3545;
                        border-radius: 8px;
                        animation: slideDown 0.3s ease;
                    }

                    .cancel-form h4 {
                        color: #dc3545;
                        margin-bottom: 15px;
                        font-size: 18px;
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
                </style>

                <div class="order-detail-container">
                    <!-- Header -->
                    <div class="header">
                        <div>
                            <h1>Chi tiết đơn hàng</h1>
                            <span class="order-id">#${order.orderId}</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/seller/all-orders" class="btn-back">
                            <i class="fa fa-arrow-left"></i> Quay lại
                        </a>
                    </div>

                    <!-- Alerts -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success">
                            <i class="fa fa-check-circle"></i> ${success}
                        </div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-error">
                            <i class="fa fa-exclamation-circle"></i> ${error}
                        </div>
                    </c:if>

                    <!-- Order Information Grid -->
                    <div class="order-info-grid">
                        <!-- Trạng thái đơn hàng -->
                        <div class="info-card">
                            <h3><i class="fa fa-info-circle"></i> Trạng thái đơn hàng</h3>
                            <div class="info-row">
                                <span class="info-label">Trạng thái:</span>
                                <span class="info-value">
                                    <span class="status-badge status-${fn:toLowerCase(order.status)}">
                                        ${order.status}
                                    </span>
                                </span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Thanh toán:</span>
                                <span class="info-value">
                                    <span
                                        class="payment-badge payment-${order.paymentStatus == 'SUCCESS' ? 'success' : (order.paymentMethod == 'COD' ? 'cod' : 'pending')}">
                                        ${order.paymentMethod} - ${order.paymentStatus}
                                    </span>
                                </span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Ngày đặt:</span>
                                <span class="info-value">${order.createdAt}</span>
                            </div>
                        </div>

                        <!-- Thông tin khách hàng -->
                        <div class="info-card">
                            <h3><i class="fa fa-user"></i> Thông tin khách hàng</h3>
                            <div class="info-row">
                                <span class="info-label">Mã khách hàng:</span>
                                <span class="info-value">#${order.userId}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Địa chỉ giao hàng:</span>
                                <span class="info-value">${order.shippingAddress}</span>
                            </div>
                        </div>

                        <!-- Tổng giá trị -->
                        <div class="info-card">
                            <h3><i class="fa fa-calculator"></i> Tổng giá trị</h3>
                            <div class="info-row">
                                <span class="info-label">Tổng tiền:</span>
                                <span class="info-value total-amount">
                                    <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" />
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- Products Section -->
                    <div class="products-section">
                        <h3><i class="fa fa-shopping-cart"></i> Sản phẩm trong đơn hàng</h3>
                        <table class="product-table">
                            <thead>
                                <tr>
                                    <th>Ảnh</th>
                                    <th>Tên sản phẩm</th>
                                    <th>Đơn giá</th>
                                    <th>Số lượng</th>
                                    <th>Thành tiền</th>
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
                                                        alt="${item.productName}" />
                                                </c:when>
                                                <c:otherwise>
                                                    <img class="product-img"
                                                        src="${pageContext.request.contextPath}/images/no-image.png"
                                                        alt="No Image" />
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${item.productName}</td>
                                        <td>
                                            <fmt:formatNumber value="${item.price}" type="currency"
                                                currencySymbol="₫" />
                                        </td>
                                        <td>${item.quantity}</td>
                                        <td>
                                            <fmt:formatNumber value="${item.price * item.quantity}" type="currency"
                                                currencySymbol="₫" />
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="4" style="text-align: right;">
                                        <i class="fa fa-calculator"></i> Tổng Cộng:
                                    </td>
                                    <td class="total-amount">
                                        <fmt:formatNumber value="${order.totalAmount}" type="currency"
                                            currencySymbol="₫" />
                                    </td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>

                    <!-- Actions Section -->
                    <div class="actions-section">
                        <h3 style="text-align: left; margin-bottom: 15px; color: #333;">
                            <i class="fa fa-tasks"></i> Hành động
                        </h3>

                        <!-- Nút xác nhận đơn hàng (PAID) -->
                        <c:if test="${order.status == 'PAID'}">
                            <form action="${pageContext.request.contextPath}/seller/accept-order/${order.orderId}"
                                method="post" style="display: inline;">
                                <button type="submit" class="btn-action btn-accept">
                                    <i class="fa fa-check"></i> Xác nhận đơn hàng
                                </button>
                            </form>
                            <button type="button" class="btn-action btn-cancel" onclick="toggleCancelForm()">
                                <i class="fa fa-times"></i> Hủy đơn hàng
                            </button>
                        </c:if>

                        <!-- Nút hủy đơn hàng (ACCEPTED) -->
                        <c:if test="${order.status == 'ACCEPTED'}">
                            <button type="button" class="btn-action btn-cancel" onclick="toggleCancelForm()">
                                <i class="fa fa-times"></i> Hủy đơn hàng
                            </button>
                        </c:if>

                        <!-- Form hủy đơn hàng -->
                        <c:if test="${order.status == 'PAID' || order.status == 'ACCEPTED'}">
                            <div id="cancelOrderForm" class="cancel-form" style="display: none;">
                                <h4><i class="fa fa-times-circle"></i> Hủy Đơn Hàng #${order.orderId}</h4>
                                <p style="color: #666; margin-bottom: 15px;">
                                    Vui lòng nhập lý do hủy đơn hàng. Thông tin này sẽ được gửi đến khách hàng.
                                </p>

                                <c:if test="${order.paymentMethod == 'VNPAY' && order.paymentStatus == 'SUCCESS'}">
                                    <div
                                        style="background: #fff3cd; border-left: 4px solid #ffc107; padding: 12px; margin-bottom: 15px; border-radius: 4px;">
                                        <strong style="color: #856404;">
                                            <i class="fa fa-exclamation-triangle"></i> Lưu ý:
                                        </strong>
                                        <p style="color: #856404; margin: 5px 0 0 0; font-size: 13px;">
                                            Đơn hàng này đã thanh toán qua VNPay. Hệ thống sẽ <strong>TỰ ĐỘNG HOÀN
                                                TIỀN</strong>
                                            cho khách hàng trong vòng 5-7 ngày làm việc.
                                        </p>
                                    </div>
                                </c:if>

                                <form action="${pageContext.request.contextPath}/seller/cancel-order/${order.orderId}"
                                    method="post" onsubmit="return validateCancelForm()">
                                    <div style="margin-bottom: 15px;">
                                        <label for="cancelNote"
                                            style="display: block; font-weight: bold; margin-bottom: 8px; color: #333;">
                                            <i class="fa fa-comment"></i> Lý do hủy đơn: <span
                                                style="color: red;">*</span>
                                        </label>
                                        <textarea name="cancelNote" id="cancelNote"
                                            style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; resize: vertical; min-height: 100px; font-family: inherit;"
                                            placeholder="Ví dụ: Sản phẩm hết hàng, Không thể giao đến địa chỉ của bạn..."
                                            required></textarea>
                                        <small style="color: #999; display: block; margin-top: 5px;">
                                            <i class="fa fa-info-circle"></i> Tối thiểu 10 ký tự
                                        </small>
                                    </div>

                                    <div style="display: flex; gap: 10px; justify-content: flex-end;">
                                        <button type="button" class="btn-action"
                                            style="background: #6c757d; color: white;" onclick="toggleCancelForm()">
                                            <i class="fa fa-times"></i> Hủy bỏ
                                        </button>
                                        <button type="submit" class="btn-action btn-cancel">
                                            <i class="fa fa-check"></i> Xác Nhận Hủy Đơn
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </c:if>

                        <!-- Nút chuyển sang vận chuyển (ACCEPTED) -->
                        <c:if test="${order.status == 'ACCEPTED'}">
                            <form action="${pageContext.request.contextPath}/seller/ship-order/${order.orderId}"
                                method="post" style="display: inline;">
                                <button type="submit" class="btn-action btn-ship">
                                    <i class="fa fa-truck"></i> Chuyển sang vận chuyển
                                </button>
                            </form>
                        </c:if>

                        <!-- Nút đánh dấu đã giao (SHIPPING) -->
                        <c:if test="${order.status == 'SHIPPING'}">
                            <form action="${pageContext.request.contextPath}/seller/deliver-order/${order.orderId}"
                                method="post" style="display: inline;">
                                <button type="submit" class="btn-action btn-deliver">
                                    <i class="fa fa-check-circle"></i> Đánh dấu đã giao
                                </button>
                            </form>
                        </c:if>

                        <!-- Form hoàn tiền (DELIVERED, REFUND_REQUESTED, REFUNDED_REQUEST) -->
                        <c:if
                            test="${order.status == 'DELIVERED' || order.status == 'REFUND_REQUESTED' || order.status == 'REFUNDED_REQUESTED'}">
                            <div class="refund-controls">
                                <c:if
                                    test="${order.status == 'REFUND_REQUESTED' || order.status == 'REFUNDED_REQUEST'}">
                                    <h5><i class="fa fa-exclamation-circle"></i> Khách hàng yêu cầu hoàn tiền
                                    </h5>
                                </c:if>

                                <div style="margin-bottom: 15px;">
                                    <label for="trantype">Loại hoàn tiền:</label>
                                    <select id="trantype">
                                        <option value="02">Hoàn toàn</option>
                                        <option value="03">Hoàn một phần</option>
                                    </select>

                                    <label for="percent">Phần trăm:</label>
                                    <select id="percent">
                                        <option value="50">50%</option>
                                        <option value="100" selected>100%</option>
                                    </select>
                                </div>

                                <button class="btn-action btn-refund" onclick="processRefund()">
                                    <i class="fa fa-undo"></i> Chấp nhận hoàn tiền
                                </button>
                            </div>
                        </c:if>
                    </div>
                </div>

                <script>
                    function toggleCancelForm() {
                        const form = document.getElementById('cancelOrderForm');
                        if (form.style.display === 'none' || form.style.display === '') {
                            form.style.display = 'block';
                            // Clear form
                            document.getElementById('cancelNote').value = '';
                            // Scroll to form
                            form.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
                        } else {
                            form.style.display = 'none';
                        }
                    }

                    function validateCancelForm() {
                        const note = document.getElementById('cancelNote').value.trim();

                        if (!note) {
                            alert('Vui lòng nhập lý do hủy đơn hàng!');
                            return false;
                        }

                        if (note.length < 10) {
                            alert('Lý do hủy đơn phải có ít nhất 10 ký tự!');
                            return false;
                        }

                        const paymentBadge = document.querySelector('.payment-badge');
                        const paymentText = paymentBadge ? paymentBadge.textContent.trim() : '';

                        let confirmMessage = 'Bạn có chắc chắn muốn HỦY đơn hàng này?';

                        if (paymentText.includes('VNPAY') && paymentText.includes('SUCCESS')) {
                            confirmMessage = 'Đơn hàng này đã thanh toán qua VNPay.\n' +
                                'Hệ thống sẽ TỰ ĐỘNG HOÀN TIỀN cho khách hàng.\n\n' +
                                'Bạn có chắc chắn muốn HỦY VÀ HOÀN TIỀN đơn hàng này?';
                        }

                        return confirm(confirmMessage);
                    }

                    function processRefund() {
                        const trantype = document.getElementById('trantype').value;
                        const percent = parseInt(document.getElementById('percent').value);

                        if (!confirm('Bạn có chắc chắn muốn hoàn tiền cho đơn hàng này?')) {
                            return;
                        }

                        fetch('${pageContext.request.contextPath}/seller/orders-refund/${order.orderId}/process?trantype=' + trantype + '&percent=' + percent, {
                            method: 'POST'
                        })
                            .then(res => {
                                if (!res.ok) throw new Error("Hoàn tiền thất bại: " + res.status);
                                return res.text();
                            })
                            .then(message => {
                                alert(message);
                                window.location.reload();
                            })
                            .catch(err => {
                                alert("Lỗi: " + err.message);
                            });
                    }
                </script>
                </div>