<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

                <title>Đơn hàng hoàn tiền - CellPhoneStore</title>

                <style>
                    .refund-orders-container {
                        max-width: 1200px;
                        margin: 40px auto;
                        padding: 20px;
                        background: #fff;
                        border-radius: 8px;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                    }

                    .refund-orders-container h1 {
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

                    .order-info {
                        margin-bottom: 15px;
                    }

                    .order-info div {
                        margin-bottom: 5px;
                        color: #333;
                    }

                    .order-info i {
                        color: #d70018;
                        margin-right: 5px;
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

                    .payment-cod {
                        background: #ffc107;
                        color: #000;
                    }

                    .payment-pending {
                        background: #6c757d;
                        color: #fff;
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

                    .refund-controls {
                        margin-top: 15px;
                        padding: 10px;
                        background: #fff;
                        border: 1px solid #ddd;
                        border-radius: 4px;
                    }

                    .refund-controls label {
                        font-weight: bold;
                        margin-right: 5px;
                    }

                    .refund-controls select {
                        padding: 5px 10px;
                        margin: 0 10px 0 5px;
                        border-radius: 4px;
                        border: 1px solid #ddd;
                    }

                    .btn-refund {
                        background-color: #28a745;
                        color: #fff;
                        border: none;
                        cursor: pointer;
                        padding: 8px 15px;
                        border-radius: 5px;
                        font-weight: bold;
                    }

                    .btn-refund:hover {
                        background-color: #218838;
                    }

                    .btn-refund:disabled {
                        background-color: #aaa;
                        cursor: not-allowed;
                    }

                    .btn-back {
                        background-color: #d70018;
                        color: #fff;
                        text-decoration: none;
                        padding: 10px 20px;
                        border-radius: 5px;
                        display: inline-block;
                        margin-bottom: 20px;
                    }

                    .btn-back:hover {
                        background-color: #b30014;
                        color: #fff;
                    }

                    .message {
                        margin-top: 15px;
                        padding: 10px;
                        border-radius: 5px;
                        display: none;
                    }

                    .success {
                        background-color: #d4edda;
                        color: #155724;
                        border: 1px solid #c3e6cb;
                    }

                    .error {
                        background-color: #f8d7da;
                        color: #721c24;
                        border: 1px solid #f5c6cb;
                    }

                    .status-badge {
                        padding: 4px 12px;
                        border-radius: 4px;
                        font-size: 12px;
                        font-weight: bold;
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

                    .btn-accept-refund {
                        background-color: #28a745;
                        color: #fff;
                        border: none;
                        cursor: pointer;
                        padding: 10px 20px;
                        border-radius: 5px;
                        font-weight: bold;
                        margin-right: 10px;
                    }

                    .btn-accept-refund:hover {
                        background-color: #218838;
                    }

                    .btn-reject-refund {
                        background-color: #dc3545;
                        color: #fff;
                        border: none;
                        cursor: pointer;
                        padding: 10px 20px;
                        border-radius: 5px;
                        font-weight: bold;
                    }

                    .btn-reject-refund:hover {
                        background-color: #c82333;
                    }

                    .refund-request-actions {
                        margin-top: 15px;
                        padding: 15px;
                        background: #fff3cd;
                        border: 1px solid #ffc107;
                        border-radius: 4px;
                        border-left: 4px solid #ffc107;
                    }

                    .refund-request-actions h5 {
                        color: #856404;
                        margin: 0 0 10px 0;
                        font-size: 14px;
                        font-weight: bold;
                    }
                </style>

                <!-- BREADCRUMB -->
                <div id="breadcrumb" class="section">
                    <div class="container">
                        <div class="row">
                            <div class="col-md-12">
                                <ul class="breadcrumb-tree">
                                    <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                                    <li class="active">Hoàn tiền đơn hàng</li>
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
                                <div class="refund-orders-container">
                                    <h1>Danh sách đơn hàng hoàn tiền</h1>
                                    <a href="${pageContext.request.contextPath}/" class="btn-back">
                                        <i class="fa fa-arrow-left"></i> Quay về trang chính
                                    </a>

                                    <div id="messageContainer" class="message"></div>

                                    <c:forEach var="order" items="${orders}">
                                        <div class="order-card" id="order-card-${order.orderId}">
                                            <div class="order-header">
                                                <div>
                                                    <strong>Mã Đơn Hàng:</strong> #${order.orderId}
                                                    <strong style="margin-left: 15px;">Trạng Thái:</strong>
                                                    <span class="status-badge status-${fn:toLowerCase(order.status)}"
                                                        id="status-${order.orderId}">
                                                        ${order.status}
                                                    </span>
                                                    <strong style="margin-left: 15px;">Thanh Toán:</strong>
                                                    <span
                                                        class="payment-badge payment-${order.paymentStatus == 'SUCCESS' ? 'success' : (order.paymentMethod == 'COD' ? 'cod' : 'pending')}">
                                                        ${order.paymentMethod} - ${order.paymentStatus}
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
                                                <div><i class="fa fa-map-marker"></i> <strong>Địa chỉ:</strong>
                                                    ${order.shippingAddress}</div>
                                                <div><i class="fa fa-calendar"></i> <strong>Ngày đặt:</strong>
                                                    ${order.createdAt}</div>
                                                <div><i class="fa fa-user"></i> <strong>Mã KH:</strong> ${order.userId}
                                                </div>
                                            </div>

                                            <h4
                                                style="border-bottom: 2px solid #d70018; padding-bottom: 10px; margin-top: 15px;">
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
                                                                <fmt:formatNumber value="${item.price * item.quantity}"
                                                                    type="currency" currencySymbol="₫" />
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                                <tfoot>
                                                    <tr style="background: #f9f9f9; font-weight: bold;">
                                                        <td colspan="4" style="text-align: right;">
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

                                            <%-- Chỉ cho phép hoàn tiền với đơn hàng đã giao (DELIVERED), yêu cầu hoàn
                                                tiền (REFUND_REQUESTED) hoặc đã yêu cầu hoàn tiền (REFUNDED_REQUEST)
                                                --%>
                                                <c:if
                                                    test="${order.status == 'DELIVERED' || order.status == 'REFUND_REQUESTED' || order.status == 'REFUNDED_REQUESTED'}">
                                                    <div class="refund-request-actions">
                                                        <c:if
                                                            test="${order.status == 'REFUND_REQUESTED' || order.status == 'REFUNDED_REQUEST'}">
                                                            <h5><i class="fa fa-exclamation-circle"></i> Khách hàng yêu
                                                                cầu hoàn tiền</h5>
                                                        </c:if>

                                                        <label for="trantype-${order.orderId}">Loại hoàn tiền:</label>
                                                        <select id="trantype-${order.orderId}">
                                                            <option value="02">Hoàn toàn</option>
                                                            <option value="03">Hoàn một phần</option>
                                                        </select>

                                                        <label for="percent-${order.orderId}">Phần trăm:</label>
                                                        <select id="percent-${order.orderId}">
                                                            <option value="50">50%</option>
                                                            <option value="100" selected>100%</option>
                                                        </select>

                                                        <div style="margin-top: 10px;">
                                                            <button class="btn-accept-refund"
                                                                id="refund-btn-${order.orderId}"
                                                                onclick="processRefund(${order.orderId})">
                                                                <i class="fa fa-check"></i> Chấp nhận hoàn tiền
                                                            </button>
                                                            <a href="${pageContext.request.contextPath}/seller/order/${order.orderId}"
                                                                class="btn-view"
                                                                style="padding: 10px 20px; background: #6c757d; color: #fff; text-decoration: none; border-radius: 5px; font-weight: bold; display: inline-block; margin-left: 10px;">
                                                                <i class="fa fa-eye"></i> Xem chi tiết
                                                            </a>
                                                        </div>
                                                    </div>
                                                </c:if>
                                        </div>
                                    </c:forEach>

                                    <c:if test="${empty orders}">
                                        <div style="text-align: center; padding: 40px; color: #999;">
                                            <i class="fa fa-inbox" style="font-size: 48px; margin-bottom: 10px;"></i>
                                            <p style="font-size: 18px;">Không có đơn hàng hoàn tiền nào.</p>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- /SECTION -->

                <script>
                    function processRefund(orderId) {
                        const btn = document.getElementById('refund-btn-' + orderId);
                        const trantypeEl = document.getElementById('trantype-' + orderId);
                        const percentEl = document.getElementById('percent-' + orderId);

                        console.log("Processing refund for orderId:", orderId);
                        console.log("Trantype element:", trantypeEl);
                        console.log("Percent element:", percentEl);

                        if (!trantypeEl || !percentEl) {
                            alert("Không tìm thấy các trường trantype/percent cho đơn hàng này.");
                            return;
                        }

                        const trantype = trantypeEl.value;
                        const percent = parseInt(percentEl.value);

                        btn.disabled = true;
                        btn.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Đang xử lý...';

                        fetch('${pageContext.request.contextPath}/seller/orders-refund/' + orderId + '/process?trantype=' + trantype + '&percent=' + percent, {
                            method: 'POST'
                        })
                            .then(res => {
                                if (!res.ok) throw new Error("Hoàn tiền thất bại: " + res.status);
                                return res.text();
                            })
                            .then(msg => {
                                showMessage(msg, 'success');
                                const statusBadge = document.getElementById('status-' + orderId);
                                statusBadge.textContent = "REFUNDED";
                                statusBadge.className = "status-badge status-refunded";
                                btn.style.display = 'none';

                                // Hide refund controls
                                const controls = btn.parentElement;
                                if (controls) {
                                    controls.style.display = 'none';
                                }
                            })
                            .catch(err => {
                                console.error(err);
                                showMessage(err.message, 'error');
                                btn.disabled = false;
                                btn.innerHTML = '<i class="fa fa-money"></i> Hoàn tiền';
                            });
                    }

                    function showMessage(message, type) {
                        const container = document.getElementById('messageContainer');
                        container.textContent = message;
                        container.className = 'message ' + type;
                        container.style.display = 'block';
                        setTimeout(() => {
                            container.style.display = 'none';
                        }, 5000);
                    }
                </script>