<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <%@ page contentType="text/html;charset=UTF-8" language="java" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Danh sách đơn hàng - CellPhoneStore</title>
                    <style>
                        /* Order List Page Styles */
                        .order-list-title {
                            color: #333;
                            margin-bottom: 30px;
                            font-size: 28px;
                            font-weight: bold;
                            text-align: center;
                            border-bottom: 3px solid #d10024;
                            padding-bottom: 15px;
                        }

                        .order-card {
                            background: white;
                            border-radius: 12px;
                            padding: 20px;
                            margin-bottom: 20px;
                            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                            transition: box-shadow 0.3s ease;
                        }

                        .order-card:hover {
                            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.15);
                        }

                        .order-header {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            padding-bottom: 15px;
                            border-bottom: 2px solid #f0f0f0;
                            margin-bottom: 15px;
                            flex-wrap: wrap;
                            gap: 10px;
                        }

                        .order-id {
                            font-size: 18px;
                            font-weight: bold;
                            color: #333;
                        }

                        .order-date {
                            color: #666;
                            font-size: 14px;
                        }

                        .order-status-badge {
                            display: inline-block;
                            padding: 6px 15px;
                            border-radius: 20px;
                            font-weight: 600;
                            font-size: 13px;
                            text-transform: uppercase;
                        }

                        .status-PENDING {
                            background: #fff3cd;
                            color: #856404;
                        }

                        .status-PROCESSING {
                            background: #cfe2ff;
                            color: #084298;
                        }

                        .status-SHIPPED {
                            background: #d1ecf1;
                            color: #0c5460;
                        }

                        .status-DELIVERED {
                            background: #d4edda;
                            color: #155724;
                        }

                        .status-CANCELLED {
                            background: #f8d7da;
                            color: #721c24;
                        }

                        .order-body {
                            padding: 15px 0;
                        }

                        .order-items {
                            display: flex;
                            gap: 10px;
                            margin-bottom: 15px;
                            flex-wrap: wrap;
                        }

                        .order-item-image {
                            width: 80px;
                            height: 80px;
                            object-fit: contain;
                            border: 1px solid #e0e0e0;
                            border-radius: 8px;
                            padding: 5px;
                            background: #f8f9fa;
                        }

                        .order-total {
                            font-size: 20px;
                            font-weight: bold;
                            color: #d70018;
                            margin-top: 15px;
                        }

                        .order-footer {
                            display: flex;
                            gap: 10px;
                            padding-top: 15px;
                            border-top: 2px solid #f0f0f0;
                            margin-top: 15px;
                            flex-wrap: wrap;
                        }

                        .btn-order {
                            padding: 10px 20px;
                            border: none;
                            border-radius: 6px;
                            font-weight: 600;
                            cursor: pointer;
                            transition: all 0.3s;
                            text-decoration: none;
                            display: inline-block;
                            font-size: 14px;
                        }

                        .btn-view {
                            background: linear-gradient(135deg, #d70018 0%, #f05423 100%);
                            color: white;
                        }

                        .btn-view:hover {
                            transform: translateY(-2px);
                            box-shadow: 0 4px 12px rgba(215, 0, 24, 0.3);
                            color: white;
                        }

                        .btn-cancel {
                            background: #6c757d;
                            color: white;
                        }

                        .btn-cancel:hover {
                            background: #5a6268;
                        }

                        .btn-cancel:disabled {
                            background: #ccc;
                            cursor: not-allowed;
                        }

                        .empty-state {
                            text-align: center;
                            padding: 60px 20px;
                            background: white;
                            border-radius: 8px;
                            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                        }

                        .empty-state i {
                            font-size: 80px;
                            color: #ccc;
                            margin-bottom: 20px;
                        }

                        .empty-state h3 {
                            color: #666;
                            margin-bottom: 15px;
                        }

                        .empty-state a {
                            display: inline-block;
                            margin-top: 20px;
                            padding: 12px 30px;
                            background: linear-gradient(135deg, #d70018 0%, #f05423 100%);
                            color: white;
                            text-decoration: none;
                            border-radius: 6px;
                            font-weight: 600;
                            transition: all 0.3s;
                        }

                        .empty-state a:hover {
                            transform: translateY(-2px);
                            box-shadow: 0 4px 12px rgba(215, 0, 24, 0.3);
                        }

                        .alert-message {
                            padding: 15px 20px;
                            border-radius: 8px;
                            margin-bottom: 20px;
                            font-weight: 600;
                            display: none;
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

                        /* Responsive adjustments */
                        @media (max-width: 768px) {
                            .order-header {
                                flex-direction: column;
                                align-items: flex-start;
                            }

                            .order-items {
                                justify-content: center;
                            }

                            .order-footer {
                                flex-direction: column;
                            }

                            .btn-order {
                                width: 100%;
                                text-align: center;
                            }
                        }

                        /* Confirm Modal */
                        .confirm-overlay {
                            display: none;
                            position: fixed;
                            top: 0;
                            left: 0;
                            width: 100%;
                            height: 100%;
                            background: rgba(0, 0, 0, 0.5);
                            z-index: 9999;
                            align-items: center;
                            justify-content: center;
                        }

                        .confirm-modal {
                            background: white;
                            border-radius: 12px;
                            padding: 30px;
                            max-width: 450px;
                            width: 90%;
                            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
                            animation: slideDown 0.3s ease-out;
                        }

                        .confirm-modal h4 {
                            margin: 0 0 20px 0;
                            color: #d10024;
                            font-weight: 700;
                            font-size: 20px;
                        }

                        .confirm-modal p {
                            color: #666;
                            margin-bottom: 25px;
                            line-height: 1.6;
                        }

                        .confirm-buttons {
                            display: flex;
                            gap: 15px;
                            justify-content: flex-end;
                        }

                        .confirm-buttons button {
                            padding: 10px 25px;
                            border: none;
                            border-radius: 6px;
                            font-weight: 600;
                            cursor: pointer;
                            transition: all 0.3s;
                        }

                        .confirm-btn-cancel {
                            background: #6c757d;
                            color: white;
                        }

                        .confirm-btn-cancel:hover {
                            background: #5a6268;
                        }

                        .confirm-btn-confirm {
                            background: #d10024;
                            color: white;
                        }

                        .confirm-btn-confirm:hover {
                            background: #a30019;
                        }

                        @keyframes slideDown {
                            from {
                                opacity: 0;
                                transform: translateY(-30px);
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
                                        <li class="active">Đơn hàng của tôi</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- /BREADCRUMB -->

                    <!-- ORDER LIST SECTION -->
                    <div class="section">
                        <div class="container">
                            <h1 class="order-list-title">
                                <i class="fa fa-list-alt"></i> Danh sách đơn hàng
                            </h1>

                            <div id="messageContainer" class="alert-message"></div>

                            <!-- Orders List -->
                            <c:choose>
                                <c:when test="${empty orders}">
                                    <!-- Empty State -->
                                    <div class="empty-state">
                                        <i class="fa fa-shopping-bag"></i>
                                        <h3>Bạn chưa có đơn hàng nào</h3>
                                        <p>Hãy khám phá các sản phẩm của chúng tôi và đặt hàng ngay!</p>
                                        <a href="${pageContext.request.contextPath}/shop">
                                            <i class="fa fa-shopping-cart"></i> Mua sắm ngay
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <!-- Orders count -->
                                    <div class="orders-count"
                                        style="text-align: center; margin-bottom: 20px; font-size: 16px; color: #666; font-weight: 600;">
                                        <i class="fa fa-check-circle" style="color: #28a745;"></i>
                                        Tổng số: <span id="totalOrdersCount">${orders.size()}</span> đơn hàng
                                        <span style="margin: 0 10px;">|</span>
                                        Đang hiển thị: <span id="displayCount">${fn:length(orders) gt 5 ? 5 :
                                            fn:length(orders)}</span> đơn hàng
                                    </div>

                                    <!-- Order Cards -->
                                    <div id="orders-container">
                                        <c:forEach var="order" items="${orders}" varStatus="loop">
                                            <div class="order-card" id="order-row-${order.orderId}"
                                                data-order-index="${loop.index}">
                                                <!-- Order Header -->
                                                <div class="order-header">
                                                    <div>
                                                        <div class="order-id">
                                                            <i class="fa fa-shopping-bag"></i> Đơn hàng
                                                            #${order.orderId}
                                                        </div>
                                                        <div class="order-date">
                                                            <i class="fa fa-calendar"></i> ${order.createdAt}
                                                        </div>
                                                    </div>
                                                    <div>
                                                        <span class="order-status-badge status-${order.status}"
                                                            id="status-${order.orderId}">
                                                            ${order.status}
                                                        </span>
                                                    </div>
                                                </div>

                                                <!-- Order Body -->
                                                <div class="order-body">
                                                    <!-- Product Images -->
                                                    <div class="order-items">
                                                        <c:forEach var="item" items="${order.items}" varStatus="status">
                                                            <c:if test="${status.index < 6}">
                                                                <c:choose>
                                                                    <c:when
                                                                        test="${fn:startsWith(item.productImageUrl, '/uploads/')}">
                                                                        <img src="${pageContext.request.contextPath}${item.productImageUrl}"
                                                                            alt="${item.productName}"
                                                                            class="order-item-image"
                                                                            title="${item.productName}" />
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <img src="${pageContext.request.contextPath}/uploads/products/${item.productImageUrl}"
                                                                            alt="${item.productName}"
                                                                            class="order-item-image"
                                                                            title="${item.productName}" />
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:if>
                                                        </c:forEach>
                                                        <c:if test="${fn:length(order.items) > 6}">
                                                            <div class="order-item-image"
                                                                style="display: flex; align-items: center; justify-content: center; background: #e9ecef; font-weight: bold; color: #666;">
                                                                +${fn:length(order.items) - 6}
                                                            </div>
                                                        </c:if>
                                                    </div>

                                                    <!-- Total Amount -->
                                                    <div class="order-total">
                                                        <i class="fa fa-money"></i> Tổng tiền:
                                                        <fmt:formatNumber value="${order.totalAmount}"
                                                            pattern="#,###" /> ₫
                                                    </div>
                                                </div>

                                                <!-- Order Footer -->
                                                <div class="order-footer">
                                                    <a class="btn-order btn-view"
                                                        href="${pageContext.request.contextPath}/order/${order.orderId}">
                                                        <i class="fa fa-eye"></i> Xem chi tiết
                                                    </a>
                                                    <c:if test="${order.status == 'PENDING'}">
                                                        <button class="btn-order btn-cancel"
                                                            data-order-id="${order.orderId}">
                                                            <i class="fa fa-times-circle"></i> Hủy đơn hàng
                                                        </button>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>

                                    <!-- Pagination -->
                                    <div id="pagination"
                                        style="display: flex; justify-content: center; align-items: center; gap: 10px; margin-top: 30px; flex-wrap: wrap;">
                                        <button id="prevBtn" onclick="changePage(-1)"
                                            style="padding: 10px 20px; background: #d70018; color: white; border: none; border-radius: 5px; cursor: pointer; font-weight: 600;">
                                            <i class="fa fa-chevron-left"></i> Trước
                                        </button>
                                        <span id="pageInfo"
                                            style="font-weight: 600; color: #333; font-size: 16px;"></span>
                                        <button id="nextBtn" onclick="changePage(1)"
                                            style="padding: 10px 20px; background: #d70018; color: white; border: none; border-radius: 5px; cursor: pointer; font-weight: 600;">
                                            Sau <i class="fa fa-chevron-right"></i>
                                        </button>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <!-- /ORDER LIST SECTION -->

                    <script>
                        // Simple pagination and cancel logic (cleaned)
                        const ORDERS_PER_PAGE = 5;
                        let currentPage = 1;

                        document.addEventListener('DOMContentLoaded', function () {
                            const orderCards = Array.from(document.querySelectorAll('.order-card'));
                            const totalOrders = orderCards.length;

                            const totalSpan = document.getElementById('totalOrdersCount');
                            if (totalSpan) totalSpan.textContent = totalOrders;

                            if (totalOrders > 0) showPage(1);
                            else {
                                const displayCountElement = document.getElementById('displayCount');
                                if (displayCountElement) displayCountElement.textContent = '0';
                                const pageInfo = document.getElementById('pageInfo');
                                if (pageInfo) pageInfo.textContent = 'Trang 0 / 0';
                                const prevBtn = document.getElementById('prevBtn');
                                const nextBtn = document.getElementById('nextBtn');
                                if (prevBtn) prevBtn.disabled = true;
                                if (nextBtn) nextBtn.disabled = true;
                            }

                            // Attach cancel handlers
                            document.querySelectorAll('.btn-cancel').forEach(function (btn) {
                                btn.addEventListener('click', function () {
                                    const id = this.getAttribute('data-order-id');
                                    if (id) cancelOrder(id);
                                });
                            });
                        });

                        function showPage(page) {
                            const orderCards = document.querySelectorAll('.order-card');
                            const totalOrders = orderCards.length;
                            const totalPages = Math.max(1, Math.ceil(totalOrders / ORDERS_PER_PAGE));

                            if (page < 1) page = 1;
                            if (page > totalPages) page = totalPages;
                            currentPage = page;

                            orderCards.forEach(card => card.style.display = 'none');

                            const start = (page - 1) * ORDERS_PER_PAGE;
                            const end = start + ORDERS_PER_PAGE;
                            let displayed = 0;
                            for (let i = start; i < end && i < orderCards.length; i++) {
                                orderCards[i].style.display = 'block';
                                displayed++;
                            }

                            const displayCountElement = document.getElementById('displayCount');
                            if (displayCountElement) displayCountElement.textContent = displayed;

                            const pageInfoEl = document.getElementById('pageInfo');
                            if (pageInfoEl) pageInfoEl.textContent = 'Trang ' + currentPage + ' / ' + totalPages;

                            const prevBtn = document.getElementById('prevBtn');
                            const nextBtn = document.getElementById('nextBtn');
                            if (prevBtn) prevBtn.disabled = currentPage === 1;
                            if (nextBtn) nextBtn.disabled = currentPage === totalPages;
                        }

                        function changePage(direction) {
                            showPage(currentPage + direction);
                        }

                        let pendingOrderId = null;

                        function cancelOrder(orderId) {
                            // Store orderId and show confirm modal
                            pendingOrderId = orderId;
                            document.getElementById('confirmOverlay').style.display = 'flex';
                        }

                        function closeConfirm() {
                            document.getElementById('confirmOverlay').style.display = 'none';
                            pendingOrderId = null;
                        }

                        function confirmAction() {
                            if (!pendingOrderId) return;

                            const orderId = pendingOrderId;
                            closeConfirm();

                            fetch('/api/orders/' + orderId + '/cancel', {
                                method: 'PUT',
                                credentials: 'include'
                            })
                                .then(response => {
                                    if (!response.ok) throw new Error('Không thể hủy đơn hàng');
                                    return response.json();
                                })
                                .then(data => {
                                    showMessage(data.message || 'Đã hủy đơn hàng', 'success');
                                    const statusEl = document.getElementById('status-' + orderId);
                                    if (statusEl) {
                                        statusEl.textContent = 'CANCELLED';
                                        statusEl.className = 'order-status-badge status-CANCELLED';
                                    }
                                    const btn = document.querySelector('#order-row-' + orderId + ' .btn-cancel');
                                    if (btn) btn.style.display = 'none';
                                })
                                .catch(() => showMessage('Lỗi khi hủy đơn hàng!', 'error'));
                        }

                        function showMessage(message, type) {
                            const container = document.getElementById('messageContainer');
                            if (!container) return;
                            container.textContent = message;
                            container.className = 'alert-message alert-' + type;
                            container.style.display = 'block';
                            container.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
                            setTimeout(() => container.style.display = 'none', 5000);
                        }
                    </script>

                    <!-- Confirm Modal -->
                    <div id="confirmOverlay" class="confirm-overlay">
                        <div class="confirm-modal">
                            <h4><i class="fa fa-exclamation-circle"></i> Xác nhận hủy đơn hàng</h4>
                            <p id="confirmMessage">Bạn có chắc muốn hủy đơn hàng này?</p>
                            <div class="confirm-buttons">
                                <button class="confirm-btn-cancel" onclick="closeConfirm()">
                                    <i class="fa fa-times"></i> Hủy
                                </button>
                                <button class="confirm-btn-confirm" onclick="confirmAction()">
                                    <i class="fa fa-check"></i> Xác nhận
                                </button>
                            </div>
                        </div>
                    </div>

                </body>

                </html>