<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <title>Danh sách đơn hàng của Seller - CellPhoneStore</title>

            <style>
                .seller-orders-container {
                    max-width: 1200px;
                    margin: 40px auto;
                    padding: 20px;
                    background: #fff;
                    border-radius: 8px;
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                }

                .seller-orders-container h1 {
                    color: #d70018;
                    margin-bottom: 20px;
                    font-size: 28px;
                    font-weight: bold;
                }

                .order-card {
                    border: 1px solid #ddd;
                    border-radius: 8px;
                    margin-bottom: 20px;
                    padding: 15px;
                    background: #fafafa;
                }

                .order-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 10px;
                    flex-wrap: wrap;
                }

                .order-info div {
                    margin-bottom: 5px;
                    color: #333;
                }

                .order-table {
                    width: 100%;
                    border-collapse: collapse;
                    margin-top: 10px;
                }

                .order-table th,
                .order-table td {
                    border: 1px solid #ddd;
                    padding: 8px;
                    text-align: center;
                }

                .order-table th {
                    background-color: #f2f2f2;
                    font-weight: bold;
                }

                .product-img {
                    width: 80px;
                    height: 80px;
                    object-fit: cover;
                    border-radius: 4px;
                }

                .btn-accept {
                    background: #28a745;
                    color: #fff;
                    padding: 8px 15px;
                    border-radius: 5px;
                    font-weight: bold;
                    cursor: pointer;
                    border: none;
                }

                .btn-accept:hover {
                    background: #218838;
                }

                .btn-cancel {
                    background: #dc3545;
                    color: #fff;
                    padding: 8px 15px;
                    border-radius: 5px;
                    font-weight: bold;
                    cursor: pointer;
                    border: none;
                    margin-left: 10px;
                }

                .btn-cancel:hover {
                    background: #c82333;
                }

                .btn-disabled {
                    background: #aaa;
                    color: #fff;
                    cursor: not-allowed;
                    padding: 8px 15px;
                    border-radius: 5px;
                }

                .btn-back {
                    background: #d70018;
                    color: #fff;
                    text-decoration: none;
                    padding: 10px 20px;
                    border-radius: 5px;
                    display: inline-block;
                    margin-bottom: 20px;
                }

                .btn-back:hover {
                    background: #b30014;
                    color: #fff;
                }

                .status-badge {
                    padding: 4px 12px;
                    border-radius: 4px;
                    font-size: 12px;
                    font-weight: bold;
                    color: #fff;
                }

                .status-pending,
                .status-paid {
                    background: #ffc107;
                    color: #000;
                }

                .status-accepted {
                    background: #17a2b8;
                }

                .status-shipping {
                    background: #007bff;
                }

                .status-delivered {
                    background: #28a745;
                }

                .status-cancelled {
                    background: #dc3545;
                }

                .payment-badge {
                    padding: 4px 12px;
                    border-radius: 4px;
                    font-size: 12px;
                    font-weight: bold;
                }

                .payment-success {
                    background: #28a745;
                    color: #fff;
                }

                .payment-pending {
                    background: #ffc107;
                    color: #000;
                }

                .payment-cod {
                    background: #6c757d;
                    color: #fff;
                }

                .info-section {
                    background: #f9f9f9;
                    padding: 15px;
                    border-radius: 8px;
                    margin-bottom: 20px;
                }

                .info-section .fa {
                    color: #d70018;
                    margin-right: 8px;
                }

                .action-buttons {
                    margin-top: 15px;
                    padding-top: 15px;
                    border-top: 1px solid #ddd;
                    text-align: right;
                }

                /* Cancel Form Styles */
                .cancel-form {
                    margin-top: 15px;
                    padding: 20px;
                    background: #fff3cd;
                    border: 2px solid #ffc107;
                    border-radius: 8px;
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

                .cancel-form h4 {
                    color: #856404;
                    margin: 0 0 15px 0;
                    font-size: 18px;
                }

                .cancel-form label {
                    display: block;
                    font-weight: bold;
                    margin-bottom: 8px;
                    color: #333;
                }

                .cancel-form textarea {
                    width: 100%;
                    padding: 10px;
                    border: 1px solid #ddd;
                    border-radius: 4px;
                    resize: vertical;
                    min-height: 100px;
                    font-family: inherit;
                }

                .cancel-form .form-buttons {
                    display: flex;
                    gap: 10px;
                    justify-content: flex-end;
                    margin-top: 15px;
                }

                .cancel-form .btn-submit {
                    padding: 10px 20px;
                    background: #dc3545;
                    color: white;
                    border: none;
                    border-radius: 5px;
                    cursor: pointer;
                    font-weight: bold;
                }

                .cancel-form .btn-submit:hover {
                    background: #c82333;
                }

                .cancel-form .btn-close {
                    padding: 10px 20px;
                    background: #6c757d;
                    color: white;
                    border: none;
                    border-radius: 5px;
                    cursor: pointer;
                    font-weight: bold;
                }

                .cancel-form .btn-close:hover {
                    background: #5a6268;
                }
            </style>

            <!-- BREADCRUMB -->
            <div id="breadcrumb" class="section">
                <div class="container">
                    <div class="row">
                        <div class="col-md-12">
                            <ul class="breadcrumb-tree">
                                <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                                <li class="active">Xác nhận đơn hàng</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /BREADCRUMB -->

            <!-- SECTION -->
            <div class="section">
                <div class="container">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="seller-orders-container">
                                <h1>Đơn hàng chờ xác nhận</h1>
                                <p style="color: #666; margin-bottom: 20px;">
                                    <i class="fa fa-shopping-bag"></i> Danh sách đơn hàng đã thanh toán và chờ bạn xác
                                    nhận.
                                    <br>
                                    <span style="color: #28a745;"><i class="fa fa-check-circle"></i> Chỉ các đơn hàng đã
                                        thanh toán (SUCCESS) hoặc COD mới có thể xác nhận.</span>
                                </p>
                                <a href="${pageContext.request.contextPath}/" class="btn-back">
                                    <i class="fa fa-arrow-left"></i> Quay về trang chính
                                </a>

                                <!-- Search and Filter Section -->
                                <div
                                    style="margin-bottom: 20px; padding: 20px; background: #f9f9f9; border-radius: 8px;">
                                    <div style="display: flex; gap: 15px; flex-wrap: wrap; align-items: end;">
                                        <!-- Search by Order ID -->
                                        <div style="flex: 1; min-width: 250px;">
                                            <label style="font-weight: bold; display: block; margin-bottom: 5px;">
                                                <i class="fa fa-search"></i> Tìm kiếm theo mã đơn hàng:
                                            </label>
                                            <input type="text" id="searchOrderId" placeholder="Nhập mã đơn hàng..."
                                                value="${param.orderId != null ? param.orderId : ''}"
                                                style="width: 100%; padding: 8px 15px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px;">
                                        </div>

                                        <!-- Action Buttons -->
                                        <div style="display: flex; gap: 10px;">
                                            <button onclick="applyFilter()"
                                                style="padding: 8px 20px; background: #d70018; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold;">
                                                <i class="fa fa-search"></i> Tìm kiếm
                                            </button>
                                            <button onclick="clearFilter()"
                                                style="padding: 8px 20px; background: #6c757d; color: white; border: none; border-radius: 4px; cursor: pointer;">
                                                <i class="fa fa-refresh"></i> Xóa bộ lọc
                                            </button>
                                        </div>
                                    </div>
                                </div>

                                <script>
                                    function applyFilter() {
                                        const orderId = document.getElementById('searchOrderId').value.trim();
                                        const url = new URL(window.location.href);

                                        // Remove old params
                                        url.searchParams.delete('orderId');

                                        // Add new params
                                        if (orderId) {
                                            url.searchParams.set('orderId', orderId);
                                        }
                                        url.searchParams.set('page', '1');

                                        window.location.href = url.toString();
                                    }

                                    function clearFilter() {
                                        const url = new URL(window.location.href);
                                        url.searchParams.delete('orderId');
                                        url.searchParams.set('page', '1');
                                        window.location.href = url.toString();
                                    }

                                    // Enter key support
                                    document.getElementById('searchOrderId').addEventListener('keypress', function (e) {
                                        if (e.key === 'Enter') {
                                            applyFilter();
                                        }
                                    });
                                </script>

                                <c:forEach var="order" items="${orders}">
                                    <div class="order-card">
                                        <div class="order-header">
                                            <div>
                                                <strong>Mã Đơn Hàng:</strong> #${order.orderId}
                                                &nbsp;|&nbsp;
                                                <strong>Trạng Thái:</strong>
                                                <span
                                                    class="status-badge status-${order.status.toLowerCase()}">${order.status}</span>
                                                &nbsp;|&nbsp;
                                                <strong>Thanh Toán:</strong>
                                                <span
                                                    class="payment-badge ${order.paymentStatus == 'SUCCESS' ? 'payment-success' : (order.paymentMethod == 'COD' ? 'payment-cod' : 'payment-pending')}">
                                                    ${order.paymentMethod}
                                                    <c:if
                                                        test="${order.paymentStatus != null && order.paymentStatus != ''}">
                                                        - ${order.paymentStatus}
                                                    </c:if>
                                                </span>
                                            </div>
                                            <div>
                                                <strong style="font-size: 18px; color: #d70018;">
                                                    <fmt:formatNumber value="${order.totalAmount}" type="currency"
                                                        currencySymbol="₫" />
                                                </strong>
                                            </div>
                                        </div>

                                        <div class="order-info">
                                            <div>
                                                <i class="fa fa-map-marker"></i>
                                                <strong>Địa chỉ giao hàng:</strong> ${order.shippingAddress}
                                            </div>
                                            <div>
                                                <i class="fa fa-calendar"></i>
                                                <strong>Ngày Tạo:</strong> ${order.createdAt}
                                            </div>
                                            <c:if test="${order.userId != null}">
                                                <div>
                                                    <i class="fa fa-user"></i>
                                                    <strong>Mã Khách Hàng:</strong> ${order.userId}
                                                </div>
                                            </c:if>
                                        </div>

                                        <h4
                                            style="margin-top: 15px; color: #333; border-bottom: 2px solid #d70018; padding-bottom: 8px;">
                                            <i class="fa fa-shopping-cart"></i> Sản phẩm trong đơn hàng
                                        </h4>
                                        <table class="order-table">
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
                                                                        alt="${item.productName}"
                                                                        onerror="this.src='${pageContext.request.contextPath}/images/no-image.png'" />
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <img class="product-img"
                                                                        src="${pageContext.request.contextPath}/images/no-image.png"
                                                                        alt="No Image" />
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td style="text-align: left; padding-left: 15px;">
                                                            <strong>${item.productName}</strong>
                                                            <c:if test="${item.productId != null}">
                                                                <br>
                                                                <small style="color: #999;">ID:
                                                                    ${item.productId}</small>
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <fmt:formatNumber value="${item.price}" type="currency"
                                                                currencySymbol="₫" />
                                                        </td>
                                                        <td>
                                                            <strong style="color: #d70018;">x${item.quantity}</strong>
                                                        </td>
                                                        <td>
                                                            <strong style="color: #28a745;">
                                                                <fmt:formatNumber value="${item.price * item.quantity}"
                                                                    type="currency" currencySymbol="₫" />
                                                            </strong>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                            <tfoot>
                                                <tr style="background: #f9f9f9; font-weight: bold;">
                                                    <td colspan="4" style="text-align: right; padding-right: 15px;">
                                                        <i class="fa fa-calculator"></i> Tổng Cộng:
                                                    </td>
                                                    <td>
                                                        <strong style="color: #d70018; font-size: 16px;">
                                                            <fmt:formatNumber value="${order.totalAmount}"
                                                                type="currency" currencySymbol="₫" />
                                                        </strong>
                                                    </td>
                                                </tr>
                                            </tfoot>
                                        </table>

                                        <!-- Action Buttons -->
                                        <c:if
                                            test="${order.status == 'PAID' && (order.paymentStatus == 'SUCCESS' || order.paymentMethod == 'COD')}">
                                            <div class="action-buttons">
                                                <form
                                                    action="${pageContext.request.contextPath}/seller/accept-order/${order.orderId}"
                                                    method="post" style="display:inline;">
                                                    <button type="submit" class="btn-accept">
                                                        <i class="fa fa-check"></i> Xác Nhận Đơn Hàng
                                                    </button>
                                                </form>
                                                <button type="button" class="btn-cancel"
                                                    data-order-id="${order.orderId}"
                                                    onclick="toggleCancelForm(${order.orderId})">
                                                    <i class="fa fa-times"></i> Hủy Đơn Hàng
                                                </button>
                                                <a href="${pageContext.request.contextPath}/seller/order/${order.orderId}"
                                                    class="btn-view"
                                                    style="padding: 10px 20px; background: #6c757d; color: #fff; text-decoration: none; border-radius: 5px; font-weight: bold; display: inline-block; margin-left: 10px;">
                                                    <i class="fa fa-eye"></i> Xem chi tiết
                                                </a>
                                            </div>
                                        </c:if>

                                        <!-- Action Buttons for ACCEPTED orders -->
                                        <c:if test="${order.status == 'ACCEPTED'}">
                                            <div class="action-buttons">
                                                <button type="button" class="btn-cancel"
                                                    data-order-id="${order.orderId}"
                                                    onclick="toggleCancelForm(${order.orderId})">
                                                    <i class="fa fa-times"></i> Hủy Đơn Hàng
                                                </button>
                                                <a href="${pageContext.request.contextPath}/seller/order/${order.orderId}"
                                                    class="btn-view"
                                                    style="padding: 10px 20px; background: #6c757d; color: #fff; text-decoration: none; border-radius: 5px; font-weight: bold; display: inline-block; margin-left: 10px;">
                                                    <i class="fa fa-eye"></i> Xem chi tiết
                                                </a>
                                            </div>
                                        </c:if>

                                        <!-- Inline Cancel Order Form -->
                                        <div id="cancelOrderForm-${order.orderId}" class="cancel-form"
                                            style="display: none;">
                                            <h4><i class="fa fa-times-circle"></i> Hủy Đơn Hàng #${order.orderId}</h4>

                                            <div id="refundNotice-${order.orderId}"
                                                style="display: none; background: #f8d7da; border-left: 4px solid #dc3545; padding: 12px; margin-bottom: 15px; border-radius: 4px;">
                                                <strong style="color: #721c24;">
                                                    <i class="fa fa-exclamation-triangle"></i> Lưu ý hoàn tiền:
                                                </strong>
                                                <p style="color: #721c24; margin: 5px 0 0 0; font-size: 13px;">
                                                    Đơn hàng này đã thanh toán qua VNPay. Hệ thống sẽ <strong>TỰ ĐỘNG
                                                        HOÀN
                                                        TIỀN</strong> cho khách hàng trong vòng 5-7 ngày làm việc.
                                                </p>
                                            </div>

                                            <form
                                                action="${pageContext.request.contextPath}/seller/cancel-order/${order.orderId}"
                                                method="post" onsubmit="return validateCancelForm(${order.orderId});">
                                                <label for="cancelNote-${order.orderId}">
                                                    <i class="fa fa-comment"></i> Lý do hủy đơn: <span
                                                        style="color: red;">*</span>
                                                </label>
                                                <textarea id="cancelNote-${order.orderId}" name="cancelNote"
                                                    placeholder="Ví dụ: Sản phẩm hết hàng, Không thể giao đến địa chỉ của bạn..."
                                                    required></textarea>
                                                <small style="color: #666; display: block; margin-top: 5px;">
                                                    <i class="fa fa-info-circle"></i> Tối thiểu 10 ký tự
                                                </small>

                                                <div class="form-buttons">
                                                    <button type="button" class="btn-close"
                                                        onclick="toggleCancelForm(${order.orderId})">
                                                        <i class="fa fa-times"></i> Đóng
                                                    </button>
                                                    <button type="submit" class="btn-submit">
                                                        <i class="fa fa-check"></i> Xác Nhận Hủy
                                                    </button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </c:forEach>

                                <c:if test="${empty orders}">
                                    <div style="text-align: center; padding: 40px; color: #999;">
                                        <i class="fa fa-inbox" style="font-size: 48px; margin-bottom: 10px;"></i>
                                        <p style="font-size: 18px;">Không có đơn hàng nào.</p>
                                    </div>
                                </c:if>

                                <!-- Pagination -->
                                <c:if test="${not empty orders && totalPages > 1}">
                                    <div style="text-align: center; margin-top: 30px;">
                                        <div class="store-pagination">
                                            <!-- Previous Button -->
                                            <c:if test="${currentPage > 1}">
                                                <a href="${pageContext.request.contextPath}/seller/orders?page=${currentPage - 1}&size=${pageSize}"
                                                    class="btn btn-default">
                                                    <i class="fa fa-angle-left"></i> Trước
                                                </a>
                                            </c:if>

                                            <!-- Page Numbers -->
                                            <c:forEach begin="${currentPage - 2 < 1 ? 1 : currentPage - 2}"
                                                end="${currentPage + 2 > totalPages ? totalPages : currentPage + 2}"
                                                var="pageNum">
                                                <c:choose>
                                                    <c:when test="${pageNum == currentPage}">
                                                        <span class="btn btn-primary">${pageNum}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="${pageContext.request.contextPath}/seller/orders?page=${pageNum}&size=${pageSize}"
                                                            class="btn btn-default">${pageNum}</a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>

                                            <!-- Next Button -->
                                            <c:if test="${currentPage < totalPages}">
                                                <a href="${pageContext.request.contextPath}/seller/orders?page=${currentPage + 1}&size=${pageSize}"
                                                    class="btn btn-default">
                                                    Sau <i class="fa fa-angle-right"></i>
                                                </a>
                                            </c:if>
                                        </div>

                                        <!-- Page Info -->
                                        <div style="margin-top: 15px; color: #666;">
                                            Hiển thị ${startIndex} - ${endIndex} trong tổng số ${totalOrders} đơn hàng
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /SECTION -->

            <script>
                function toggleCancelForm(orderId) {
                    const form = document.getElementById('cancelOrderForm-' + orderId);
                    const refundNotice = document.getElementById('refundNotice-' + orderId);

                    if (form.style.display === 'none') {
                        // Show form
                        form.style.display = 'block';

                        // Check if order needs refund
                        try {
                            const cancelBtn = document.querySelector(`button.btn-cancel[data-order-id="${orderId}"]`);
                            if (cancelBtn) {
                                const orderCard = cancelBtn.closest('.order-card');
                                if (orderCard) {
                                    const paymentBadge = orderCard.querySelector('.payment-badge');
                                    const paymentText = paymentBadge ? paymentBadge.textContent.trim() : '';

                                    if (paymentText.includes('VNPAY') && paymentText.includes('SUCCESS')) {
                                        refundNotice.style.display = 'block';
                                    } else {
                                        refundNotice.style.display = 'none';
                                    }
                                }
                            }
                        } catch (e) {
                            console.error('Could not detect payment method:', e);
                            refundNotice.style.display = 'none';
                        }

                        // Scroll to form
                        form.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
                    } else {
                        // Hide form
                        form.style.display = 'none';
                        document.getElementById('cancelNote-' + orderId).value = '';
                    }
                }

                function validateCancelForm(orderId) {
                    const note = document.getElementById('cancelNote-' + orderId).value.trim();

                    if (!note) {
                        alert('Vui lòng nhập lý do hủy đơn hàng!');
                        return false;
                    }

                    if (note.length < 10) {
                        alert('Lý do hủy đơn phải có ít nhất 10 ký tự!');
                        return false;
                    }

                    return true;
                }
            </script>
            <!-- ``` <p style="color: #666; margin-bottom: 15px;">
                Vui lòng nhập lý do hủy đơn hàng. Thông tin này sẽ được gửi đến khách hàng.
            </p>
            <div id="refundNotice"
                style="display: none; background: #fff3cd; border-left: 4px solid #ffc107; padding: 12px; margin-bottom: 15px; border-radius: 4px;">
                <strong style="color: #856404;">
                    <i class="fa fa-exclamation-triangle"></i> Lưu ý:
                </strong>
                <p style="color: #856404; margin: 5px 0 0 0; font-size: 13px;">
                    Đơn hàng này đã thanh toán qua VNPay. Hệ thống sẽ <strong>TỰ ĐỘNG HOÀN TIỀN</strong> cho
                    khách hàng trong vòng 5-7 ngày làm việc.
                </p>
            </div>
            <label for="cancelNote">
                <i class="fa fa-comment"></i> Lý do hủy đơn: <span style="color: red;">*</span>
            </label>
            <textarea id="cancelNote" placeholder="Ví dụ: Sản phẩm hết hàng, Không thể giao đến địa chỉ của bạn..."
                required></textarea>
            <small style="color: #999; display: block; margin-top: 5px;">
                <i class="fa fa-info-circle"></i> Tối thiểu 10 ký tự
            </small>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-modal-cancel" onclick="closeCancelModal()">
                    <i class="fa fa-times"></i> Đóng
                </button>
                <button type="button" class="btn-modal-confirm" onclick="submitCancelOrder()">
                    <i class="fa fa-check"></i> Xác Nhận Hủy
                </button>
            </div>
            </div>
            </div> -->

            <script>
                let selectedOrderId = null;

                function openCancelModal(orderId) {
                    selectedOrderId = orderId;
                    document.getElementById('cancelNote').value = '';

                    // Kiểm tra xem đơn hàng có cần hoàn tiền không
                    try {
                        const cancelBtn = document.querySelector(`button.btn-cancel[data-order-id="${orderId}"]`);
                        if (cancelBtn) {
                            const orderCard = cancelBtn.closest('.order-card');
                            if (orderCard) {
                                const paymentBadge = orderCard.querySelector('.payment-badge');
                                const paymentText = paymentBadge ? paymentBadge.textContent.trim() : '';

                                const refundNotice = document.getElementById('refundNotice');
                                if (paymentText.includes('VNPAY') && paymentText.includes('SUCCESS')) {
                                    refundNotice.style.display = 'block';
                                } else {
                                    refundNotice.style.display = 'none';
                                }
                            }
                        }
                    } catch (e) {
                        console.error('Could not detect payment method:', e);
                        document.getElementById('refundNotice').style.display = 'none';
                    }

                    document.getElementById('cancelOrderModal').classList.add('active');
                }

                function closeCancelModal() {
                    selectedOrderId = null;
                    document.getElementById('cancelOrderModal').classList.remove('active');
                }

                function submitCancelOrder() {
                    const note = document.getElementById('cancelNote').value.trim();

                    if (!note) {
                        alert('Vui lòng nhập lý do hủy đơn hàng!');
                        return;
                    }

                    if (note.length < 10) {
                        alert('Lý do hủy đơn phải có ít nhất 10 ký tự!');
                        return;
                    }

                    if (!selectedOrderId) {
                        alert('Lỗi: Không tìm thấy mã đơn hàng!');
                        return;
                    }

                    // Kiểm tra xem đơn hàng có cần hoàn tiền không
                    let confirmMessage = 'Bạn có chắc chắn muốn HỦY đơn hàng #' + selectedOrderId + '?';

                    try {
                        const cancelBtn = document.querySelector(`button.btn-cancel[data-order-id="${selectedOrderId}"]`);
                        if (cancelBtn) {
                            const orderCard = cancelBtn.closest('.order-card');
                            if (orderCard) {
                                const paymentBadge = orderCard.querySelector('.payment-badge');
                                const paymentText = paymentBadge ? paymentBadge.textContent.trim() : '';

                                if (paymentText.includes('VNPAY') && paymentText.includes('SUCCESS')) {
                                    confirmMessage = 'Đơn hàng này đã thanh toán qua VNPay.\n' +
                                        'Hệ thống sẽ TỰ ĐỘNG HOÀN TIỀN cho khách hàng.\n\n' +
                                        'Bạn có chắc chắn muốn HỦY VÀ HOÀN TIỀN đơn hàng #' + selectedOrderId + '?';
                                }
                            }
                        }
                    } catch (e) {
                        console.error('Could not detect payment method:', e);
                    }

                    if (!confirm(confirmMessage)) {
                        return;
                    }

                    // Submit form
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '${pageContext.request.contextPath}/seller/cancel-order/' + selectedOrderId;

                    const noteInput = document.createElement('input');
                    noteInput.type = 'hidden';
                    noteInput.name = 'cancelNote';
                    noteInput.value = note;
                    form.appendChild(noteInput);

                    document.body.appendChild(form);
                    form.submit();
                }

                // Close modal when clicking outside
                document.getElementById('cancelOrderModal').addEventListener('click', function (e) {
                    if (e.target === this) {
                        closeCancelModal();
                    }
                });

                // Close modal with ESC key
                document.addEventListener('keydown', function (e) {
                    if (e.key === 'Escape') {
                        closeCancelModal();
                    }
                });
            </script>