<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <title>Tất cả đơn hàng - CellPhoneStore</title>

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

                .status-shipping {
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
            </style>

            <!-- BREADCRUMB -->
            <div id="breadcrumb" class="section">
                <div class="container">
                    <div class="row">
                        <div class="col-md-12">
                            <ul class="breadcrumb-tree">
                                <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                                <li class="active">Tất cả đơn hàng</li>
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
                                <h1>Tất cả đơn hàng trong hệ thống</h1>
                                <p style="color: #666; margin-bottom: 20px;">
                                    <i class="fa fa-info-circle"></i> Trang này hiển thị tất cả đơn hàng từ tất cả
                                    seller trong hệ thống.
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
                                            <%-- Reflected XSS: param.orderId query parameter in input value attribute — fix: c:out --%>
                                            <input type="text" id="searchOrderId" placeholder="Nhập mã đơn hàng..."
                                                value="<c:out value='${param.orderId}'/>"
                                                style="width: 100%; padding: 8px 15px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px;">
                                        </div>

                                        <!-- Filter by Status -->
                                        <div style="flex: 0 0 200px;">
                                            <label style="font-weight: bold; display: block; margin-bottom: 5px;">
                                                <i class="fa fa-filter"></i> Lọc theo trạng thái:
                                            </label>
                                            <select id="statusFilter"
                                                style="width: 100%; padding: 8px 15px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px;">
                                                <option value="ALL" ${selectedStatus=='ALL' || selectedStatus==null
                                                    ? 'selected' : '' }>
                                                    Tất cả
                                                </option>
                                                <option value="PENDING" ${selectedStatus=='PENDING' ? 'selected' : '' }>
                                                    Chờ xác nhận
                                                </option>
                                                <option value="PAID" ${selectedStatus=='PAID' ? 'selected' : '' }>
                                                    Đã thanh toán
                                                </option>
                                                <option value="ACCEPTED" ${selectedStatus=='ACCEPTED' ? 'selected' : ''
                                                    }>
                                                    Đã chấp nhận
                                                </option>
                                                <option value="SHIPPING" ${selectedStatus=='SHIPPING' ? 'selected' : ''
                                                    }>
                                                    Đang vận chuyển
                                                </option>
                                                <option value="DELIVERED" ${selectedStatus=='DELIVERED' ? 'selected'
                                                    : '' }>
                                                    Đã giao hàng
                                                </option>
                                                <option value="CANCELLED" ${selectedStatus=='CANCELLED' ? 'selected'
                                                    : '' }>
                                                    Đã hủy
                                                </option>
                                            </select>
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
                                        const status = document.getElementById('statusFilter').value;
                                        const url = new URL(window.location.href);

                                        // Remove old params
                                        url.searchParams.delete('orderId');
                                        url.searchParams.delete('status');

                                        // Add new params
                                        if (orderId) {
                                            url.searchParams.set('orderId', orderId);
                                        }
                                        if (status && status !== 'ALL') {
                                            url.searchParams.set('status', status);
                                        }
                                        url.searchParams.set('page', '1');

                                        window.location.href = url.toString();
                                    }

                                    function clearFilter() {
                                        const url = new URL(window.location.href);
                                        url.searchParams.delete('orderId');
                                        url.searchParams.delete('status');
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
                                                    class="status-badge status-<c:out value='${order.status.toLowerCase()}'/>"><c:out value="${order.status}"/></span>
                                                &nbsp;|&nbsp;
                                                <strong>Thanh Toán:</strong>
                                                <span
                                                    class="payment-badge ${order.paymentStatus == 'SUCCESS' ? 'payment-success' : (order.paymentMethod == 'COD' ? 'payment-cod' : 'payment-pending')}">
                                                    <c:out value="${order.paymentMethod}"/>
                                                    <c:if
                                                        test="${order.paymentStatus != null && order.paymentStatus != ''}">
                                                        - <c:out value="${order.paymentStatus}"/>
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
                                                <strong>Địa chỉ giao hàng:</strong> <c:out value="${order.shippingAddress}"/>
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
                                                                        <%-- Stored XSS: product name in alt attribute - fix: c:out --%> alt="<c:out value='${item.productName}'/>"
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
                                                            <strong><c:out value="${item.productName}"/></strong>
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
                                        <div
                                            style="text-align: right; margin-top: 15px; padding-top: 15px; border-top: 1px solid #e0e0e0;">
                                            <a href="${pageContext.request.contextPath}/seller/order/${order.orderId}"
                                                class="btn"
                                                style="padding: 10px 20px; background: #d70018; color: #fff; text-decoration: none; border-radius: 5px; font-weight: bold; display: inline-block;">
                                                <i class="fa fa-eye"></i> Xem chi tiết
                                            </a>
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
                                                <a href="${pageContext.request.contextPath}/seller/all-orders?page=${currentPage - 1}&size=${pageSize}"
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
                                                        <a href="${pageContext.request.contextPath}/seller/all-orders?page=${pageNum}&size=${pageSize}"
                                                            class="btn btn-default">${pageNum}</a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>

                                            <!-- Next Button -->
                                            <c:if test="${currentPage < totalPages}">
                                                <a href="${pageContext.request.contextPath}/seller/all-orders?page=${currentPage + 1}&size=${pageSize}"
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