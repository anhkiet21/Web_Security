<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="utf-8">
                <meta http-equiv="X-UA-Compatible" content="IE=edge">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <title>Trang Cá Nhân - CellPhoneStore</title>

                <style>
                    /* Modern Profile Design - Matches Site Layout */
                    .profile-wrapper {
                        padding: 30px 15px;
                        font-family: 'Montserrat', sans-serif;
                        background: #fff;
                        min-height: 80vh;
                    }

                    .profile-wrapper .container {
                        max-width: 1170px;
                        margin: 0 auto;
                    }

                    .profile-top {
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        gap: 20px;
                        margin-bottom: 30px;
                        padding: 24px;
                        background: #fff;
                        border-radius: 3px;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
                        border-top: 3px solid #D10024;
                        transition: all 0.3s ease;
                    }

                    .profile-top:hover {
                        box-shadow: 0 4px 16px rgba(209, 0, 36, 0.12);
                    }

                    .profile-avatar {
                        width: 90px;
                        height: 90px;
                        border-radius: 50%;
                        overflow: hidden;
                        background: #f8f9fa;
                        border: 3px solid #D10024;
                        box-shadow: 0 2px 8px rgba(209, 0, 36, 0.2);
                        transition: all 0.3s ease;
                    }

                    .profile-avatar:hover {
                        transform: scale(1.05);
                        box-shadow: 0 4px 12px rgba(209, 0, 36, 0.3);
                    }

                    .profile-avatar img {
                        width: 100%;
                        height: 100%;
                        object-fit: cover;
                        display: block;
                    }

                    .profile-name {
                        font-size: 22px;
                        font-weight: 700;
                        margin: 0;
                        color: #2B2D42;
                    }

                    .profile-email {
                        color: #8D99AE;
                        font-size: 14px;
                        margin-top: 6px;
                        display: flex;
                        align-items: center;
                        gap: 6px;
                    }

                    .profile-email::before {
                        content: '\f0e0';
                        font-family: 'FontAwesome';
                        font-size: 14px;
                        color: #D10024;
                    }

                    /* Tab Navigation */
                    .profile-tabs {
                        display: flex;
                        gap: 0;
                        background: #fff;
                        border-radius: 3px;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
                        border-top: 3px solid #D10024;
                        overflow: hidden;
                        margin-bottom: 30px;
                    }

                    .profile-tab {
                        flex: 1;
                        padding: 16px 20px;
                        text-align: center;
                        border: none;
                        background: #fff !important;
                        color: #2B2D42 !important;
                        font-size: 14px;
                        font-weight: 500;
                        cursor: pointer;
                        transition: all 0.3s ease;
                        border-right: 1px solid #E4E7ED;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        gap: 8px;
                    }

                    .profile-tab:last-child {
                        border-right: none;
                    }

                    .profile-tab:hover {
                        background: #FFF5F5 !important;
                        color: #D10024 !important;
                    }

                    .profile-tab.active {
                        background: #D10024 !important;
                        color: #fff !important;
                        font-weight: 600;
                    }

                    .profile-tab i {
                        font-size: 16px;
                    }

                    /* Tab Content */
                    .tab-content-item {
                        display: none;
                    }

                    .tab-content-item.active {
                        display: block;
                        animation: fadeIn 0.3s ease;
                    }

                    @keyframes fadeIn {
                        from {
                            opacity: 0;
                            transform: translateY(10px);
                        }

                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }

                    /* Sidebar matches site style */
                    .left-sidebar {
                        min-width: 240px;
                        background: #fff;
                        border-radius: 3px;
                        padding: 0;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
                        border-top: 3px solid #D10024;
                        position: sticky;
                        top: 20px;
                        overflow: hidden;
                    }

                    .left-sidebar .list-group {
                        border-radius: 0;
                        background: transparent;
                    }

                    .list-group-item {
                        padding: 14px 20px;
                        font-size: 14px;
                        font-weight: 500;
                        border: none;
                        border-bottom: 1px solid #E4E7ED;
                        background: transparent;
                        color: #2B2D42;
                        transition: all 0.3s ease;
                        display: flex;
                        align-items: center;
                        gap: 10px;
                    }

                    .list-group-item:last-child {
                        border-bottom: none;
                    }

                    .list-group-item:hover {
                        background: #FFF5F5;
                        color: #D10024;
                        padding-left: 25px;
                    }

                    .list-group-item.active {
                        background: #D10024;
                        color: #fff;
                        font-weight: 600;
                        padding-left: 25px;
                    }

                    .list-group-item.active::before {
                        content: '▶';
                        font-size: 10px;
                        margin-right: -5px;
                    }

                    /* Info rows with better spacing */
                    .card-compact {
                        border-radius: 3px;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
                        padding: 24px;
                        background: #fff;
                        border-top: 3px solid #D10024;
                        transition: all 0.3s ease;
                        margin-bottom: 20px;
                    }

                    .card-compact:hover {
                        box-shadow: 0 4px 16px rgba(209, 0, 36, 0.12);
                    }

                    /* Info rows with better spacing */
                    .info-row {
                        display: flex;
                        align-items: center;
                        padding: 14px 0;
                        border-bottom: 1px solid rgba(0, 0, 0, 0.05);
                        transition: all 0.2s ease;
                    }

                    .info-row:hover {
                        background: #FFF5F5;
                        padding-left: 10px;
                        margin-left: -10px;
                        margin-right: -10px;
                        padding-right: 10px;
                        border-radius: 3px;
                    }

                    .info-row:last-child {
                        border-bottom: none;
                    }

                    .info-label {
                        width: 140px;
                        color: #8D99AE;
                        font-size: 14px;
                        font-weight: 600;
                        display: flex;
                        align-items: center;
                        gap: 8px;
                    }

                    .info-label::before {
                        color: #D10024;
                    }

                    .info-value {
                        flex: 1;
                        font-size: 15px;
                        color: #2B2D42;
                        font-weight: 500;
                    }

                    /* Stats badge with site colors */
                    .stats-badge {
                        background: #D10024;
                        color: white;
                        padding: 12px 20px;
                        border-radius: 3px;
                        text-align: center;
                        box-shadow: 0 2px 8px rgba(209, 0, 36, 0.3);
                        transition: all 0.3s ease;
                    }

                    .stats-badge:hover {
                        background: #B8001F;
                        box-shadow: 0 4px 12px rgba(209, 0, 36, 0.4);
                    }

                    .stats-badge .stats-number {
                        font-weight: 800;
                        font-size: 24px;
                        line-height: 1;
                    }

                    .stats-badge .stats-label {
                        font-size: 12px;
                        opacity: 0.9;
                        margin-top: 4px;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                    }

                    /* Modern buttons matching site */
                    .btn-sm {
                        padding: 10px 20px;
                        font-size: 14px;
                        font-weight: 600;
                        border-radius: 3px;
                        transition: all 0.3s ease;
                        border: 2px solid;
                        text-transform: uppercase;
                    }

                    .btn-outline-secondary {
                        color: #D10024;
                        border-color: #D10024;
                        background: transparent;
                    }

                    .btn-outline-secondary:hover {
                        background: #D10024;
                        border-color: #D10024;
                        color: white;
                        box-shadow: 0 2px 8px rgba(209, 0, 36, 0.3);
                    }

                    /* Order items with clean design */
                    .order-item {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        padding: 16px;
                        margin: 8px 0;
                        background: #FAFAFA;
                        border-radius: 3px;
                        border-left: 3px solid #D10024;
                        transition: all 0.3s ease;
                    }

                    .order-item:hover {
                        background: #FFF5F5;
                        box-shadow: 0 2px 8px rgba(209, 0, 36, 0.1);
                        border-left-width: 5px;
                    }

                    .order-status {
                        background: #10B981;
                        color: white;
                        padding: 6px 14px;
                        border-radius: 20px;
                        font-size: 12px;
                        font-weight: 600;
                        text-transform: uppercase;
                    }

                    .order-price {
                        font-weight: 700;
                        color: #D10024;
                        font-size: 16px;
                    }

                    /* Alert styles */
                    .alert {
                        border-radius: 3px;
                        border: none;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                    }

                    .alert-success {
                        background: #D1FAE5;
                        color: #065F46;
                        border-left: 3px solid #10B981;
                    }

                    .alert-danger {
                        background: #FEE2E2;
                        color: #991B1B;
                        border-left: 3px solid #DC2626;
                    }

                    /* Form styles */
                    .form-group {
                        margin-bottom: 20px;
                    }

                    .form-label {
                        font-weight: 600;
                        color: #2B2D42;
                        margin-bottom: 8px;
                        display: flex;
                        align-items: center;
                        gap: 8px;
                        font-size: 14px;
                    }

                    .form-control {
                        width: 100%;
                        padding: 10px 15px;
                        border: 1px solid #E4E7ED;
                        border-radius: 3px;
                        font-size: 14px;
                        transition: all 0.3s ease;
                    }

                    .form-control:focus {
                        outline: none;
                        border-color: #D10024;
                        box-shadow: 0 0 0 3px rgba(209, 0, 36, 0.1);
                    }

                    .btn-primary {
                        background: #D10024;
                        color: white;
                        border: none;
                        padding: 12px 30px;
                        font-size: 14px;
                        font-weight: 600;
                        border-radius: 3px;
                        text-transform: uppercase;
                        cursor: pointer;
                        transition: all 0.3s ease;
                    }

                    .btn-primary:hover {
                        background: #B8001F;
                        box-shadow: 0 2px 8px rgba(209, 0, 36, 0.3);
                    }

                    /* Offers/Promotions */
                    .offer-item {
                        padding: 20px;
                        background: linear-gradient(135deg, #FFF5F5 0%, #FFEBEB 100%);
                        border-left: 4px solid #D10024;
                        border-radius: 3px;
                        margin-bottom: 15px;
                        transition: all 0.3s ease;
                    }

                    .offer-item:hover {
                        box-shadow: 0 4px 12px rgba(209, 0, 36, 0.15);
                        transform: translateX(5px);
                    }

                    .offer-title {
                        font-size: 16px;
                        font-weight: 700;
                        color: #D10024;
                        margin-bottom: 8px;
                    }

                    .offer-desc {
                        color: #2B2D42;
                        font-size: 14px;
                        margin-bottom: 10px;
                    }

                    .offer-code {
                        display: inline-block;
                        background: #D10024;
                        color: white;
                        padding: 6px 12px;
                        border-radius: 3px;
                        font-weight: 600;
                        font-size: 13px;
                        letter-spacing: 1px;
                    }

                    .offer-expiry {
                        font-size: 12px;
                        color: #8D99AE;
                        margin-top: 8px;
                    }

                    /* Responsive */
                    @media (max-width: 767px) {
                        .profile-wrapper {
                            padding: 15px 0;
                        }

                        .profile-top {
                            flex-direction: column;
                            align-items: flex-start;
                            gap: 16px;
                            padding: 20px;
                        }

                        .profile-name {
                            font-size: 20px;
                        }

                        .info-label {
                            width: 110px;
                            font-size: 13px;
                        }

                        .left-sidebar {
                            display: none;
                        }

                        .card-compact {
                            padding: 16px;
                        }

                        .order-item {
                            flex-direction: column;
                            gap: 10px;
                            align-items: flex-start;
                        }
                    }

                    /* Smooth scrolling */
                    * {
                        scroll-behavior: smooth;
                    }
                </style>
            </head>

            <body>
                <div class="profile-wrapper">
                    <div class="container">
                        <!-- header -->
                        <div class="profile-top">
                            <div style="display:flex;gap:12px;align-items:center">
                                <div class="profile-avatar">
                                    <c:choose>
                                        <c:when test="${not empty user.avatarUrl}">
                                            <img src="${pageContext.request.contextPath}${user.avatarUrl}"
                                                alt="avatar" />
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/uploads/avatars/defautl_avt.png"
                                                alt="avatar" />
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div>
                                    <p class="profile-name">${user.fullname}</p>
                                    <div class="profile-email">${user.email}</div>
                                </div>
                            </div>

                            <div style="display:flex;gap:12px;align-items:center">
                                <div class="stats-badge">
                                    <div class="stats-number">${totalOrders}</div>
                                    <div class="stats-label">Đơn hàng</div>
                                </div>
                                <div class="stats-badge"
                                    style="background:linear-gradient(135deg, #28a745 0%, #20c997 100%);">
                                    <div class="stats-number">
                                        <fmt:formatNumber value="${totalSpent}" type="currency" currencySymbol=""
                                            maxFractionDigits="0" />đ
                                    </div>
                                    <div class="stats-label">Tổng chi tiêu</div>
                                </div>
                            </div>
                        </div>

                        <!-- Tab Navigation -->
                        <div class="profile-tabs"
                            style="display:flex;gap:0;background:#fff;border-radius:3px;box-shadow:0 2px 8px rgba(0,0,0,0.08);border-top:3px solid #D10024;overflow:hidden;margin-bottom:30px;">
                            <button class="profile-tab active" onclick="switchTab('overview')"
                                style="flex:1;padding:16px 20px;text-align:center;border:none;background:#D10024;color:#fff;font-size:14px;font-weight:600;cursor:pointer;transition:all 0.3s;border-right:1px solid #E4E7ED;">
                                <i class="fa fa-dashboard"></i> Tổng quan
                            </button>
                            <button class="profile-tab" onclick="switchTab('orders')"
                                style="flex:1;padding:16px 20px;text-align:center;border:none;background:transparent;color:#2B2D42;font-size:14px;font-weight:500;cursor:pointer;transition:all 0.3s;border-right:1px solid #E4E7ED;">
                                <i class="fa fa-shopping-bag"></i> Đơn hàng
                            </button>
                            <button class="profile-tab" onclick="switchTab('offers')"
                                style="flex:1;padding:16px 20px;text-align:center;border:none;background:transparent;color:#2B2D42;font-size:14px;font-weight:500;cursor:pointer;transition:all 0.3s;border-right:1px solid #E4E7ED;">
                                <i class="fa fa-gift"></i> Ưu đãi
                            </button>
                            <button class="profile-tab" onclick="switchTab('account')"
                                style="flex:1;padding:16px 20px;text-align:center;border:none;background:transparent;color:#2B2D42;font-size:14px;font-weight:500;cursor:pointer;transition:all 0.3s;">
                                <i class="fa fa-cog"></i> Tài khoản
                            </button>
                        </div>

                        <style>
                            .profile-tab:hover {
                                background: #FFF5F5 !important;
                                color: #D10024 !important;
                            }

                            .profile-tab.active {
                                background: #D10024 !important;
                                color: #fff !important;
                                font-weight: 600 !important;
                            }

                            .tab-content-section {
                                display: none;
                            }

                            .tab-content-section.active {
                                display: block;
                                animation: fadeIn 0.3s;
                            }

                            @keyframes fadeIn {
                                from {
                                    opacity: 0;
                                    transform: translateY(10px);
                                }

                                to {
                                    opacity: 1;
                                    transform: translateY(0);
                                }
                            }
                        </style>

                        <!-- Tab Content -->
                        <div>
                            <c:if test="${not empty success}">
                                <div class="alert alert-success">${success}</div>
                            </c:if>
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger">${error}</div>
                            </c:if>

                            <!-- Tab 1: Tổng quan -->
                            <div id="tab-overview" class="tab-content-section active">
                                <div class="card-compact mb-3">
                                    <div
                                        style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
                                        <h6
                                            style="margin:0; font-size:16px; font-weight:700; color:#2B2D42; border-bottom:2px solid #D10024; padding-bottom:10px; display:inline-block;">
                                            <i class="fa fa-user" style="color:#D10024; margin-right:8px;"></i>Thông tin
                                            cá
                                            nhân
                                        </h6>
                                        <button onclick="switchTab('account')"
                                            style="padding:8px 20px; background:#D10024; color:white; border:none; border-radius:3px; font-size:13px; font-weight:600; cursor:pointer; transition:all 0.3s;">
                                            <i class="fa fa-edit"></i> Chỉnh sửa
                                        </button>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label"><i class="fa fa-user-o"></i> Họ và tên</div>
                                        <div class="info-value">${user.fullname}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label"><i class="fa fa-envelope-o"></i> Email</div>
                                        <div class="info-value"
                                            style="display:flex; align-items:center; gap:10px; flex-wrap:wrap;">
                                            <span>${user.email}</span>
                                            <c:choose>
                                                <c:when test="${verifyEmail}">
                                                    <span
                                                        style="padding:4px 10px; background:#d4edda; color:#155724; border-radius:12px; font-size:11px; font-weight:600;">
                                                        <i class="fa fa-check-circle"></i> Đã xác thực
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span
                                                        style="padding:4px 10px; background:#fff3cd; color:#856404; border-radius:12px; font-size:11px; font-weight:600;">
                                                        <i class="fa fa-exclamation-circle"></i> Chưa xác thực
                                                    </span>
                                                    <button onclick="showVerifyEmailForm()"
                                                        style="padding:4px 12px; background:#007bff; color:white; border:none; border-radius:3px; font-size:11px; font-weight:600; cursor:pointer;">
                                                        <i class="fa fa-shield"></i> Xác thực ngay
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label"><i class="fa fa-phone"></i> Số điện thoại</div>
                                        <div class="info-value"
                                            style="display:flex; align-items:center; gap:10px; flex-wrap:wrap;">
                                            <span>
                                                <c:out value="${user.phone}" />
                                            </span>
                                            <c:choose>
                                                <c:when test="${verifyPhone}">
                                                    <span
                                                        style="padding:4px 10px; background:#d4edda; color:#155724; border-radius:12px; font-size:11px; font-weight:600;">
                                                        <i class="fa fa-check-circle"></i> Đã xác thực
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span
                                                        style="padding:4px 10px; background:#fff3cd; color:#856404; border-radius:12px; font-size:11px; font-weight:600;">
                                                        <i class="fa fa-exclamation-circle"></i> Chưa xác thực
                                                    </span>
                                                    <button onclick="showVerifyPhoneForm()"
                                                        style="padding:4px 12px; background:#007bff; color:white; border:none; border-radius:3px; font-size:11px; font-weight:600; cursor:pointer;">
                                                        <i class="fa fa-shield"></i> Xác thực ngay
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label"><i class="fa fa-map-marker"></i> Địa chỉ</div>
                                        <div class="info-value">
                                            <c:out value="${user.address != null ? user.address : '-'}" />
                                        </div>
                                    </div>
                                </div>

                                <div class="card-compact">
                                    <h6
                                        style="margin:0 0 20px 0; font-size:16px; font-weight:700; color:#2B2D42; border-bottom:2px solid #D10024; padding-bottom:10px; display:inline-block;">
                                        <i class="fa fa-shopping-cart" style="color:#D10024; margin-right:8px;"></i>Đơn
                                        hàng
                                        gần đây
                                    </h6>
                                    <c:choose>
                                        <c:when test="${empty recentOrders}">
                                            <div class="text-muted"
                                                style="text-align:center; padding:30px; background:#FAFAFA; border-radius:3px;">
                                                <i class="fa fa-inbox"
                                                    style="font-size:48px; opacity:0.3; color:#8D99AE;"></i>
                                                <div style="margin-top:15px; color:#8D99AE; font-size:14px;">Bạn chưa có
                                                    đơn
                                                    hàng nào.</div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach items="${recentOrders}" var="o">
                                                <div class="order-item">
                                                    <div>
                                                        <div style="font-size:14px; color:#2B2D42; font-weight:600;">
                                                            <i class="fa fa-hashtag"
                                                                style="font-size:12px; color:#D10024;"></i> ${o.orderId}
                                                        </div>
                                                        <div style="font-size:13px; color:#8D99AE; margin-top:4px;">
                                                            <i class="fa fa-calendar-o"></i> ${o.createdAt}
                                                        </div>
                                                    </div>
                                                    <div style="text-align:right;">
                                                        <div class="order-price">
                                                            <fmt:formatNumber value="${o.totalAmount}" type="currency"
                                                                currencySymbol="₫" maxFractionDigits="0" />
                                                        </div>
                                                        <div style="margin-top:6px;">
                                                            <span class="order-status">${o.status}</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- Tab 2: Tất cả đơn hàng -->
                            <div id="tab-orders" class="tab-content-section">
                                <div class="card-compact">
                                    <h6
                                        style="margin:0 0 20px 0; font-size:16px; font-weight:700; color:#2B2D42; border-bottom:2px solid #D10024; padding-bottom:10px; display:inline-block;">
                                        <i class="fa fa-list-alt" style="color:#D10024; margin-right:8px;"></i>Tất cả
                                        đơn
                                        hàng
                                    </h6>
                                    <c:choose>
                                        <c:when test="${empty orders}">
                                            <div class="text-muted"
                                                style="text-align:center; padding:40px; background:#FAFAFA; border-radius:3px;">
                                                <i class="fa fa-shopping-bag"
                                                    style="font-size:60px; opacity:0.3; color:#8D99AE;"></i>
                                                <div
                                                    style="margin-top:15px; color:#2B2D42; font-size:16px; font-weight:600;">
                                                    Bạn chưa có đơn hàng nào</div>
                                                <div style="margin-top:8px; color:#8D99AE; font-size:14px;">Hãy khám phá
                                                    các
                                                    sản phẩm của chúng tôi!</div>
                                                <a href="${pageContext.request.contextPath}/shop"
                                                    style="display:inline-block; margin-top:20px; padding:12px 30px; background:#D10024; color:white; text-decoration:none; border-radius:3px; font-weight:600;">
                                                    <i class="fa fa-shopping-cart"></i> Mua sắm ngay
                                                </a>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach items="${orders}" var="order">
                                                <div
                                                    style="background:#FAFAFA; border-radius:3px; border-left:3px solid #D10024; padding:20px; margin-bottom:15px;">
                                                    <div
                                                        style="display:flex; justify-content:space-between; padding-bottom:15px; border-bottom:1px solid #E4E7ED; margin-bottom:15px; flex-wrap:wrap; gap:10px;">
                                                        <div>
                                                            <div
                                                                style="font-size:16px; font-weight:700; color:#2B2D42;">
                                                                <i class="fa fa-shopping-bag"
                                                                    style="color:#D10024;"></i>
                                                                Đơn hàng #${order.orderId}
                                                            </div>
                                                            <div style="font-size:13px; color:#8D99AE; margin-top:5px;">
                                                                <i class="fa fa-calendar"></i> ${order.createdAt}
                                                            </div>
                                                        </div>
                                                        <div>
                                                            <span class="order-status"
                                                                style="padding:6px 14px; border-radius:20px; font-size:12px; font-weight:600; text-transform:uppercase;">${order.status}</span>
                                                        </div>
                                                    </div>
                                                    <div
                                                        style="font-size:18px; font-weight:700; color:#D10024; margin-top:12px;">
                                                        <i class="fa fa-money"></i> Tổng tiền:
                                                        <fmt:formatNumber value="${order.totalAmount}" type="currency"
                                                            currencySymbol="₫" maxFractionDigits="0" />
                                                    </div>
                                                    <div
                                                        style="margin-top:15px; padding-top:15px; border-top:1px solid #E4E7ED;">
                                                        <a href="${pageContext.request.contextPath}/order/${order.orderId}"
                                                            style="padding:10px 20px; background:#D10024; color:white; border:none; border-radius:3px; font-weight:600; text-decoration:none; font-size:14px; display:inline-block;">
                                                            <i class="fa fa-eye"></i> Xem chi tiết
                                                        </a>
                                                        <c:if
                                                            test="${order.status == 'PENDING' || order.status == 'PAID'}">
                                                            <button onclick="toggleCancelForm(${order.orderId})"
                                                                style="padding:10px 20px; background:#dc3545; color:white; border:none; border-radius:3px; font-weight:600; font-size:14px; display:inline-block; margin-left:10px; cursor:pointer;">
                                                                <i class="fa fa-times-circle"></i> Hủy đơn hàng
                                                            </button>

                                                            <!-- Inline Cancel Order Form -->
                                                            <div id="cancelForm-${order.orderId}"
                                                                style="display:none; margin-top:15px; padding:15px; background:#fff3cd; border-left:4px solid #ffc107; border-radius:5px;">
                                                                <h6 style="color:#856404; margin:0 0 10px 0;"><i
                                                                        class="fa fa-exclamation-triangle"></i> Xác nhận
                                                                    hủy đơn hàng #${order.orderId}</h6>
                                                                <p
                                                                    style="color:#856404; font-size:13px; margin-bottom:15px;">
                                                                    Bạn có chắc chắn muốn hủy đơn hàng này không?</p>
                                                                <div style="display:flex; gap:10px;">
                                                                    <button onclick="toggleCancelForm(${order.orderId})"
                                                                        style="padding:8px 15px; background:#6c757d; color:white; border:none; border-radius:3px; cursor:pointer;">
                                                                        <i class="fa fa-times"></i> Đóng
                                                                    </button>
                                                                    <button
                                                                        onclick="confirmCancelOrder(${order.orderId})"
                                                                        style="padding:8px 15px; background:#dc3545; color:white; border:none; border-radius:3px; cursor:pointer;">
                                                                        <i class="fa fa-check"></i> Xác nhận hủy
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        </c:if>
                                                        <c:if test="${order.status == 'DELIVERED'}">
                                                            <button onclick="toggleRefundForm(${order.orderId})"
                                                                style="padding:10px 20px; background:#ffc107; color:#000; border:none; border-radius:3px; font-weight:600; font-size:14px; display:inline-block; margin-left:10px; cursor:pointer;">
                                                                <i class="fa fa-undo"></i> Yêu cầu hoàn tiền
                                                            </button>

                                                            <!-- Inline Refund Request Form -->
                                                            <div id="refundForm-${order.orderId}"
                                                                style="display:none; margin-top:15px; padding:15px; background:#d1ecf1; border-left:4px solid #17a2b8; border-radius:5px;">
                                                                <h6 style="color:#0c5460; margin:0 0 10px 0;"><i
                                                                        class="fa fa-undo"></i> Yêu cầu hoàn tiền cho
                                                                    đơn hàng #${order.orderId}</h6>
                                                                <p
                                                                    style="color:#0c5460; font-size:13px; margin-bottom:15px;">
                                                                    Yêu cầu hoàn tiền sẽ được gửi đến người bán để xem
                                                                    xét và xử lý.</p>
                                                                <div style="display:flex; gap:10px;">
                                                                    <button onclick="toggleRefundForm(${order.orderId})"
                                                                        style="padding:8px 15px; background:#6c757d; color:white; border:none; border-radius:3px; cursor:pointer;">
                                                                        <i class="fa fa-times"></i> Đóng
                                                                    </button>
                                                                    <button
                                                                        onclick="confirmRequestRefund(${order.orderId})"
                                                                        style="padding:8px 15px; background:#17a2b8; color:white; border:none; border-radius:3px; cursor:pointer;">
                                                                        <i class="fa fa-check"></i> Xác nhận yêu cầu
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- Tab 3: Ưu đãi -->
                            <div id="tab-offers" class="tab-content-section">
                                <div class="card-compact">
                                    <h6
                                        style="margin:0 0 20px 0; font-size:16px; font-weight:700; color:#2B2D42; border-bottom:2px solid #D10024; padding-bottom:10px; display:inline-block;">
                                        <i class="fa fa-gift" style="color:#D10024; margin-right:8px;"></i>Ưu đãi dành
                                        cho bạn
                                    </h6>

                                    <!-- Promotion Banner -->
                                    <div
                                        style="text-align:center; padding:60px 40px; background:linear-gradient(135deg, #FFF5F5 0%, #FFEBEB 100%); border-radius:8px; border:2px solid #D10024;">
                                        <i class="fa fa-gift"
                                            style="font-size:64px; color:#D10024; margin-bottom:20px; opacity:0.8;"></i>
                                        <h3 style="font-size:24px; font-weight:700; color:#2B2D42; margin-bottom:15px;">
                                            Khám Phá Các Chương Trình Khuyến Mãi
                                        </h3>
                                        <p
                                            style="font-size:16px; color:#6c757d; margin-bottom:30px; max-width:600px; margin-left:auto; margin-right:auto;">
                                            Hàng trăm ưu đãi hấp dẫn đang chờ bạn! Giảm giá lên đến 50%, miễn phí vận
                                            chuyển, quà tặng độc quyền và nhiều hơn nữa.
                                        </p>
                                        <a href="${pageContext.request.contextPath}/deals"
                                            style="display:inline-block; padding:15px 40px; background:#D10024; color:white; text-decoration:none; border-radius:3px; font-weight:600; font-size:16px; transition:all 0.3s; box-shadow:0 4px 12px rgba(209, 0, 36, 0.3);">
                                            <i class="fa fa-tags"></i> Xem Tất Cả Khuyến Mãi
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <!-- Tab 4: Thông tin tài khoản -->
                            <div id="tab-account" class="tab-content-section">
                                <div class="card-compact">
                                    <!-- Alert Container for Account Tab -->
                                    <div id="accountAlertContainer"></div>

                                    <h6
                                        style="margin:0 0 20px 0; font-size:16px; font-weight:700; color:#2B2D42; border-bottom:2px solid #D10024; padding-bottom:10px; display:inline-block;">
                                        <i class="fa fa-edit" style="color:#D10024; margin-right:8px;"></i>Cập nhật
                                        thông
                                        tin
                                    </h6>

                                    <form action="${pageContext.request.contextPath}/profile-update" method="post"
                                        enctype="multipart/form-data">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div style="margin-bottom:20px;">
                                                    <label
                                                        style="font-weight:600; color:#2B2D42; margin-bottom:8px; display:flex; align-items:center; gap:8px; font-size:14px;">
                                                        <i class="fa fa-user-o"></i> Họ và tên
                                                    </label>
                                                    <input type="text" name="fullname"
                                                        style="width:100%; padding:10px 15px; border:1px solid #E4E7ED; border-radius:3px; font-size:14px;"
                                                        value="${user.fullname}" required>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div style="margin-bottom:20px;">
                                                    <label
                                                        style="font-weight:600; color:#2B2D42; margin-bottom:8px; display:flex; align-items:center; gap:8px; font-size:14px;">
                                                        <i class="fa fa-envelope-o"></i> Email
                                                        <c:if test="${verifyEmail}">
                                                            <span
                                                                style="color:#28a745; font-size:12px; font-weight:500;">
                                                                <i class="fa fa-check-circle"></i> Đã xác thực
                                                            </span>
                                                        </c:if>
                                                    </label>
                                                    <input type="email" name="email"
                                                        style="width:100%; padding:10px 15px; border:1px solid #E4E7ED; border-radius:3px; font-size:14px; ${verifyEmail ? 'background:#F8F9FA; cursor:not-allowed;' : ''}"
                                                        value="${user.email}" ${verifyEmail ? 'readonly' : 'required' }>
                                                    <c:if test="${verifyEmail}">
                                                        <small
                                                            style="color:#8D99AE; font-size:12px; display:block; margin-top:5px;">
                                                            <i class="fa fa-info-circle"></i> Email đã xác thực không
                                                            thể
                                                            thay đổi
                                                        </small>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <div style="margin-bottom:20px;">
                                                    <label
                                                        style="font-weight:600; color:#2B2D42; margin-bottom:8px; display:flex; align-items:center; gap:8px; font-size:14px;">
                                                        <i class="fa fa-phone"></i> Số điện thoại
                                                        <c:if test="${verifyPhone}">
                                                            <span
                                                                style="color:#28a745; font-size:12px; font-weight:500;">
                                                                <i class="fa fa-check-circle"></i> Đã xác thực
                                                            </span>
                                                        </c:if>
                                                    </label>
                                                    <input type="text" name="phone"
                                                        style="width:100%; padding:10px 15px; border:1px solid #E4E7ED; border-radius:3px; font-size:14px; background:#F8F9FA; cursor:not-allowed;"
                                                        value="${user.phone}" readonly>
                                                    <small
                                                        style="color:#8D99AE; font-size:12px; display:block; margin-top:5px;">
                                                        <i class="fa fa-info-circle"></i> Số điện thoại không thể thay
                                                        đổi
                                                    </small>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div style="margin-bottom:20px;">
                                                    <label
                                                        style="font-weight:600; color:#2B2D42; margin-bottom:8px; display:flex; align-items:center; gap:8px; font-size:14px;">
                                                        <i class="fa fa-map-marker"></i> Địa chỉ
                                                    </label>
                                                    <textarea name="address"
                                                        style="width:100%; padding:10px 15px; border:1px solid #E4E7ED; border-radius:3px; font-size:14px;"
                                                        rows="3">${user.address}</textarea>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-12">
                                                <div style="margin-bottom:20px;">
                                                    <label
                                                        style="font-weight:600; color:#2B2D42; margin-bottom:8px; display:flex; align-items:center; gap:8px; font-size:14px;">
                                                        <i class="fa fa-image"></i> Ảnh đại diện
                                                    </label>

                                                    <!-- Avatar Preview -->
                                                    <div style="margin-bottom:15px; text-align:center;">
                                                        <img id="avatarPreview"
                                                            src="${user.avatarUrl != null ? pageContext.request.contextPath.concat(user.avatarUrl) : pageContext.request.contextPath.concat('/uploads/avatars/defautl_avt.png')}"
                                                            alt="Avatar Preview"
                                                            style="width:150px; height:150px; object-fit:cover; border-radius:50%; border:3px solid #D10024; box-shadow:0 2px 8px rgba(0,0,0,0.1);">
                                                    </div>

                                                    <!-- Custom File Upload Button -->
                                                    <div style="position:relative; max-width:300px; margin:0 auto;">
                                                        <input type="file" name="avt" id="avatarInput"
                                                            style="display:none;" accept="image/*"
                                                            onchange="previewAvatar(event)">
                                                        <button type="button"
                                                            onclick="document.getElementById('avatarInput').click()"
                                                            style="width:100%; padding:10px 15px; background:#F8F9FA; border:2px dashed #D10024; border-radius:3px; font-size:14px; color:#D10024; font-weight:600; cursor:pointer; transition:all 0.3s;">
                                                            <i class="fa fa-upload"></i> Chọn ảnh
                                                        </button>
                                                    </div>
                                                    <div id="fileName"
                                                        style="margin-top:8px; font-size:12px; color:#8D99AE; text-align:center;">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div style="text-align:right; margin-top:20px;">
                                            <button type="submit"
                                                style="background:#D10024; color:white; border:none; padding:12px 30px; font-size:14px; font-weight:600; border-radius:3px; text-transform:uppercase; cursor:pointer;">
                                                <i class="fa fa-save"></i> Lưu thay đổi
                                            </button>
                                        </div>
                                    </form>
                                </div>

                                <div class="card-compact" style="margin-top:20px;">
                                    <h6
                                        style="margin:0 0 20px 0; font-size:16px; font-weight:700; color:#2B2D42; border-bottom:2px solid #D10024; padding-bottom:10px; display:inline-block;">
                                        <i class="fa fa-lock" style="color:#D10024; margin-right:8px;"></i>Đổi mật khẩu
                                    </h6>

                                    <!-- Password Change Message -->
                                    <c:if test="${not empty passwordChangeMessage}">
                                        <div style="padding:15px 20px; border-radius:8px; margin-bottom:20px; font-weight:600; 
                                        background:${passwordChangeSuccess ? '#d4edda' : '#f8d7da'}; 
                                        color:${passwordChangeSuccess ? '#155724' : '#721c24'}; 
                                        border:1px solid ${passwordChangeSuccess ? '#c3e6cb' : '#f5c6cb'};">
                                            <i
                                                class="fa ${passwordChangeSuccess ? 'fa-check-circle' : 'fa-exclamation-circle'}"></i>
                                            ${passwordChangeMessage}
                                        </div>
                                    </c:if>

                                    <form action="${pageContext.request.contextPath}/change-password" method="post">
                                        <div style="margin-bottom:20px;">
                                            <label
                                                style="font-weight:600; color:#2B2D42; margin-bottom:8px; display:flex; align-items:center; gap:8px; font-size:14px;">
                                                <i class="fa fa-key"></i> Mật khẩu hiện tại
                                            </label>
                                            <input type="password" name="password"
                                                style="width:100%; padding:10px 15px; border:1px solid #E4E7ED; border-radius:3px; font-size:14px;"
                                                required>
                                        </div>

                                        <div style="margin-bottom:20px;">
                                            <label
                                                style="font-weight:600; color:#2B2D42; margin-bottom:8px; display:flex; align-items:center; gap:8px; font-size:14px;">
                                                <i class="fa fa-key"></i> Mật khẩu mới
                                            </label>
                                            <input type="password" name="newPassword"
                                                style="width:100%; padding:10px 15px; border:1px solid #E4E7ED; border-radius:3px; font-size:14px;"
                                                required>
                                        </div>

                                        <div style="margin-bottom:20px;">
                                            <label
                                                style="font-weight:600; color:#2B2D42; margin-bottom:8px; display:flex; align-items:center; gap:8px; font-size:14px;">
                                                <i class="fa fa-key"></i> Xác nhận mật khẩu mới
                                            </label>
                                            <input type="password" name="confirmNewPassword"
                                                style="width:100%; padding:10px 15px; border:1px solid #E4E7ED; border-radius:3px; font-size:14px;"
                                                required>
                                        </div>

                                        <div style="text-align:right; margin-top:20px;">
                                            <button type="submit"
                                                style="background:#D10024; color:white; border:none; padding:12px 30px; font-size:14px; font-weight:600; border-radius:3px; text-transform:uppercase; cursor:pointer;">
                                                <i class="fa fa-lock"></i> Đổi mật khẩu
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Modal: Verify Email -->
                        <div id="verifyEmailModal"
                            style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:9999; align-items:center; justify-content:center;">
                            <div
                                style="background:white; border-radius:8px; padding:30px; max-width:500px; width:90%; box-shadow:0 4px 20px rgba(0,0,0,0.3);">
                                <h5 style="margin:0 0 20px 0; color:#2B2D42; font-weight:700;">
                                    <i class="fa fa-envelope"></i> Xác thực Email
                                </h5>
                                <div id="emailVerifyStep1">
                                    <p style="color:#666; margin-bottom:20px;">Nhấn nút bên dưới để gửi mã OTP đến
                                        email:
                                        <strong>${user.email}</strong>
                                    </p>
                                    <div style="text-align:center;">
                                        <button id="sendEmailOtpBtn" onclick="sendEmailOTP()"
                                            style="padding:12px 30px; background:#007bff; color:white; border:none; border-radius:3px; font-weight:600; cursor:pointer; margin-right:10px;">
                                            <i class="fa fa-paper-plane"></i> Gửi mã OTP
                                        </button>
                                        <button onclick="closeVerifyEmailModal()"
                                            style="padding:12px 30px; background:#6c757d; color:white; border:none; border-radius:3px; font-weight:600; cursor:pointer;">
                                            Hủy
                                        </button>
                                    </div>
                                </div>
                                <div id="emailVerifyStep2" style="display:none;">
                                    <p style="color:#28a745; margin-bottom:20px;"><i class="fa fa-check"></i> Mã OTP đã
                                        được
                                        gửi đến email của bạn!</p>
                                    <input type="text" id="emailOtpInput" placeholder="Nhập mã OTP (6 số)" maxlength="6"
                                        style="width:100%; padding:12px; border:1px solid #E4E7ED; border-radius:3px; margin-bottom:20px; font-size:16px; text-align:center; letter-spacing:5px;">
                                    <div style="text-align:center;">
                                        <button onclick="verifyEmailOTP()"
                                            style="padding:12px 30px; background:#28a745; color:white; border:none; border-radius:3px; font-weight:600; cursor:pointer; margin-right:10px;">
                                            <i class="fa fa-check-circle"></i> Xác thực
                                        </button>
                                        <button onclick="closeVerifyEmailModal()"
                                            style="padding:12px 30px; background:#6c757d; color:white; border:none; border-radius:3px; font-weight:600; cursor:pointer;">
                                            Hủy
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Modal: Verify Phone -->
                        <div id="verifyPhoneModal"
                            style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:9999; align-items:center; justify-content:center;">
                            <div
                                style="background:white; border-radius:8px; padding:30px; max-width:500px; width:90%; box-shadow:0 4px 20px rgba(0,0,0,0.3);">
                                <h5 style="margin:0 0 20px 0; color:#2B2D42; font-weight:700;">
                                    <i class="fa fa-phone"></i> Xác thực Số điện thoại
                                </h5>
                                <div id="phoneVerifyStep1">
                                    <p style="color:#666; margin-bottom:20px;">Nhấn nút bên dưới để gửi mã OTP đến số:
                                        <strong>${user.phone}</strong>
                                    </p>
                                    <div style="text-align:center;">
                                        <button id="sendPhoneOtpBtn" onclick="sendPhoneOTP()"
                                            style="padding:12px 30px; background:#007bff; color:white; border:none; border-radius:3px; font-weight:600; cursor:pointer; margin-right:10px;">
                                            <i class="fa fa-paper-plane"></i> Gửi mã OTP
                                        </button>
                                        <button onclick="closeVerifyPhoneModal()"
                                            style="padding:12px 30px; background:#6c757d; color:white; border:none; border-radius:3px; font-weight:600; cursor:pointer;">
                                            Hủy
                                        </button>
                                    </div>
                                </div>
                                <div id="phoneVerifyStep2" style="display:none;">
                                    <p style="color:#28a745; margin-bottom:20px;"><i class="fa fa-check"></i> Mã OTP đã
                                        được
                                        gửi đến số điện thoại của bạn!</p>
                                    <input type="text" id="phoneOtpInput" placeholder="Nhập mã OTP (6 số)" maxlength="6"
                                        style="width:100%; padding:12px; border:1px solid #E4E7ED; border-radius:3px; margin-bottom:20px; font-size:16px; text-align:center; letter-spacing:5px;">
                                    <div style="text-align:center;">
                                        <button onclick="verifyPhoneOTP()"
                                            style="padding:12px 30px; background:#28a745; color:white; border:none; border-radius:3px; font-weight:600; cursor:pointer; margin-right:10px;">
                                            <i class="fa fa-check-circle"></i> Xác thực
                                        </button>
                                        <button onclick="closeVerifyPhoneModal()"
                                            style="padding:12px 30px; background:#6c757d; color:white; border:none; border-radius:3px; font-weight:600; cursor:pointer;">
                                            Hủy
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <script>
                            function switchTab(tabName) {
                                document.querySelectorAll('.tab-content-section').forEach(tab => tab.classList.remove('active'));
                                document.querySelectorAll('.profile-tab').forEach(btn => btn.classList.remove('active'));
                                document.getElementById('tab-' + tabName).classList.add('active');

                                // Update active button
                                const targetBtn = Array.from(document.querySelectorAll('.profile-tab'))
                                    .find(btn => btn.textContent.includes(getTabTitle(tabName)));
                                if (targetBtn) targetBtn.classList.add('active');

                                window.scrollTo({ top: 0, behavior: 'smooth' });
                            }

                            function getTabTitle(tabName) {
                                const titles = {
                                    'overview': 'Tổng quan',
                                    'orders': 'Đơn hàng',
                                    'offers': 'Ưu đãi',
                                    'account': 'Tài khoản'
                                };
                                return titles[tabName] || '';
                            }

                            // Auto switch to account tab if there's a password change message
                            document.addEventListener('DOMContentLoaded', function () {
                                <c:if test="${not empty passwordChangeMessage}">
                                    switchTab('account');
                                </c:if>

                                // Check if URL has hash for tab navigation (e.g., #orders)
                                const hash = window.location.hash.substring(1); // Remove the '#' character
                                if (hash && ['overview', 'orders', 'offers', 'account'].includes(hash)) {
                                    switchTab(hash);
                                }
                            });

                            // Preview avatar when file is selected
                            function previewAvatar(event) {
                                const file = event.target.files[0];
                                const preview = document.getElementById('avatarPreview');
                                const fileNameDiv = document.getElementById('fileName');

                                if (file) {
                                    // Check file size (max 5MB)
                                    if (file.size > 5 * 1024 * 1024) {
                                        showInlineAlert('Kích thước ảnh không được vượt quá 5MB!', 'warning');
                                        event.target.value = '';
                                        return;
                                    }

                                    // Check file type
                                    if (!file.type.startsWith('image/')) {
                                        showInlineAlert('Vui lòng chọn file ảnh!', 'warning');
                                        event.target.value = '';
                                        return;
                                    }

                                    // Show preview
                                    const reader = new FileReader();
                                    reader.onload = function (e) {
                                        preview.src = e.target.result;
                                    };
                                    reader.readAsDataURL(file);

                                    // Show file name
                                    fileNameDiv.textContent = '📁 ' + file.name;
                                    fileNameDiv.style.color = '#28a745';
                                }
                            }

                            // Email Verification Functions
                            function showVerifyEmailForm() {
                                document.getElementById('verifyEmailModal').style.display = 'flex';
                                document.getElementById('emailVerifyStep1').style.display = 'block';
                                document.getElementById('emailVerifyStep2').style.display = 'none';
                            }

                            function closeVerifyEmailModal() {
                                document.getElementById('verifyEmailModal').style.display = 'none';
                            }

                            function sendEmailOTP() {
                                const btn = document.getElementById('sendEmailOtpBtn');
                                const originalHtml = btn.innerHTML;

                                // Disable button và hiển thị loading
                                btn.disabled = true;
                                btn.style.opacity = '0.7';
                                btn.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Đang gửi...';

                                fetch('${pageContext.request.contextPath}/api/send-otp?type=email', {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/json' }
                                })
                                    .then(response => response.json())
                                    .then(data => {
                                        if (data.success) {
                                            // Hiển thị thông báo thành công
                                            btn.innerHTML = '<i class="fa fa-check"></i> Đã gửi!';
                                            btn.style.background = '#28a745';

                                            // Chuyển sang bước 2 sau 1 giây
                                            setTimeout(() => {
                                                document.getElementById('emailVerifyStep1').style.display = 'none';
                                                document.getElementById('emailVerifyStep2').style.display = 'block';

                                                // Reset button về trạng thái ban đầu
                                                btn.innerHTML = originalHtml;
                                                btn.style.background = '#007bff';
                                                btn.style.opacity = '1';
                                                btn.disabled = false;
                                            }, 1000);
                                        } else {
                                            // Hiển thị lỗi và reset button
                                            btn.innerHTML = originalHtml;
                                            btn.style.opacity = '1';
                                            btn.disabled = false;
                                            showInlineAlert('Lỗi: ' + (data.message || 'Không thể gửi OTP'), 'danger');
                                        }
                                    })
                                    .catch(error => {
                                        // Reset button khi có lỗi
                                        btn.innerHTML = originalHtml;
                                        btn.style.opacity = '1';
                                        btn.disabled = false;
                                        showInlineAlert('Lỗi khi gửi OTP: ' + error, 'danger');
                                    });
                            }

                            function verifyEmailOTP() {
                                const otp = document.getElementById('emailOtpInput').value;
                                if (!otp || otp.length !== 6) {
                                    showInlineAlert('Vui lòng nhập mã OTP 6 số!', 'warning');
                                    return;
                                }

                                fetch('${pageContext.request.contextPath}/api/verify-otp?type=email&otp=' + otp, {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/json' }
                                })
                                    .then(response => response.json())
                                    .then(data => {
                                        if (data.success) {
                                            showInlineAlert('Xác thực email thành công!', 'success');
                                            setTimeout(() => location.reload(), 1500);
                                        } else {
                                            showInlineAlert('Mã OTP không đúng hoặc đã hết hạn!', 'danger');
                                        }
                                    })
                                    .catch(error => {
                                        showInlineAlert('Lỗi khi xác thực: ' + error, 'danger');
                                    });
                            }

                            // Phone Verification Functions
                            function showVerifyPhoneForm() {
                                document.getElementById('verifyPhoneModal').style.display = 'flex';
                                document.getElementById('phoneVerifyStep1').style.display = 'block';
                                document.getElementById('phoneVerifyStep2').style.display = 'none';
                            }

                            function closeVerifyPhoneModal() {
                                document.getElementById('verifyPhoneModal').style.display = 'none';
                            }

                            function sendPhoneOTP() {
                                const btn = document.getElementById('sendPhoneOtpBtn');
                                const originalHtml = btn.innerHTML;

                                // Disable button và hiển thị loading
                                btn.disabled = true;
                                btn.style.opacity = '0.7';
                                btn.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Đang gửi...';

                                fetch('${pageContext.request.contextPath}/api/send-otp?type=phone', {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/json' }
                                })
                                    .then(response => response.json())
                                    .then(data => {
                                        if (data.success) {
                                            // Hiển thị thông báo thành công
                                            btn.innerHTML = '<i class="fa fa-check"></i> Đã gửi!';
                                            btn.style.background = '#28a745';

                                            // Chuyển sang bước 2 sau 1 giây
                                            setTimeout(() => {
                                                document.getElementById('phoneVerifyStep1').style.display = 'none';
                                                document.getElementById('phoneVerifyStep2').style.display = 'block';

                                                // Reset button về trạng thái ban đầu
                                                btn.innerHTML = originalHtml;
                                                btn.style.background = '#007bff';
                                                btn.style.opacity = '1';
                                                btn.disabled = false;
                                            }, 1000);
                                        } else {
                                            // Hiển thị lỗi và reset button
                                            btn.innerHTML = originalHtml;
                                            btn.style.opacity = '1';
                                            btn.disabled = false;
                                            showInlineAlert('Lỗi: ' + (data.message || 'Không thể gửi OTP'), 'danger');
                                        }
                                    })
                                    .catch(error => {
                                        // Reset button khi có lỗi
                                        btn.innerHTML = originalHtml;
                                        btn.style.opacity = '1';
                                        btn.disabled = false;
                                        showInlineAlert('Lỗi khi gửi OTP: ' + error, 'danger');
                                    });
                            }

                            function verifyPhoneOTP() {
                                const otp = document.getElementById('phoneOtpInput').value;
                                if (!otp || otp.length !== 6) {
                                    showInlineAlert('Vui lòng nhập mã OTP 6 số!', 'warning');
                                    return;
                                }

                                fetch('${pageContext.request.contextPath}/api/verify-otp?type=phone&otp=' + otp, {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/json' }
                                })
                                    .then(response => response.json())
                                    .then(data => {
                                        if (data.success) {
                                            showInlineAlert('Xác thực số điện thoại thành công!', 'success');
                                            setTimeout(() => location.reload(), 1500);
                                        } else {
                                            showInlineAlert('Mã OTP không đúng hoặc đã hết hạn!', 'danger');
                                        }
                                    })
                                    .catch(error => {
                                        showInlineAlert('Lỗi khi xác thực: ' + error, 'danger');
                                    });
                            }

                            // Toggle Cancel Form
                            function toggleCancelForm(orderId) {
                                const form = document.getElementById('cancelForm-' + orderId);
                                if (form.style.display === 'none') {
                                    form.style.display = 'block';
                                } else {
                                    form.style.display = 'none';
                                }
                            }

                            // Toggle Refund Form
                            function toggleRefundForm(orderId) {
                                const form = document.getElementById('refundForm-' + orderId);
                                if (form.style.display === 'none') {
                                    form.style.display = 'block';
                                } else {
                                    form.style.display = 'none';
                                }
                            }

                            // Confirm Cancel Order (called from form)
                            function confirmCancelOrder(orderId) {
                                fetch('${pageContext.request.contextPath}/api/orders/' + orderId + '/cancel', {
                                    method: 'PUT',
                                    credentials: 'include',
                                    headers: {
                                        'Content-Type': 'application/json'
                                    }
                                })
                                    .then(response => {
                                        // Lưu status code để xử lý
                                        const statusCode = response.status;
                                        return response.json().then(data => ({ statusCode, data }));
                                    })
                                    .then(({ statusCode, data }) => {
                                        // Reload trang để hiển thị thông báo
                                        window.location.href = '${pageContext.request.contextPath}/profile#orders';
                                        location.reload();
                                    })
                                    .catch(error => {
                                        console.error('Error:', error);
                                        window.location.href = '${pageContext.request.contextPath}/profile#orders';
                                        location.reload();
                                    });
                            }

                            // Confirm Request Refund (called from form)
                            function confirmRequestRefund(orderId) {
                                fetch('${pageContext.request.contextPath}/api/orders/' + orderId + '/refund', {
                                    method: 'PUT',
                                    credentials: 'include',
                                    headers: {
                                        'Content-Type': 'application/json'
                                    }
                                })
                                    .then(response => {
                                        if (!response.ok) {
                                            return response.json().then(err => {
                                                throw new Error(err.message || 'Không thể gửi yêu cầu hoàn tiền');
                                            });
                                        }
                                        return response.json();
                                    })
                                    .then(data => {
                                        // Reload trang để hiển thị thông báo
                                        window.location.href = '${pageContext.request.contextPath}/profile#orders';
                                        location.reload();
                                    })
                                    .catch(error => {
                                        console.error(error);
                                        window.location.href = '${pageContext.request.contextPath}/profile#orders';
                                        location.reload();
                                    });
                            }

                            // ===== INLINE ALERT SYSTEM =====
                            function showInlineAlert(message, type = 'danger') {
                                // Remove existing alerts
                                document.querySelectorAll('.inline-alert').forEach(alert => alert.remove());

                                // Create alert element
                                const alertDiv = document.createElement('div');
                                alertDiv.className = 'inline-alert inline-alert-' + type;
                                alertDiv.innerHTML = '<i class="fa fa-' + (type === 'success' ? 'check-circle' : type === 'warning' ? 'exclamation-triangle' : 'exclamation-circle') + '"></i> <span>' + message + '</span>';

                                // Priority order for container selection:
                                // 1. Specific alert container in account tab (if visible)
                                // 2. Modal that's currently visible
                                // 3. Active tab's card-compact
                                // 4. Profile wrapper as fallback
                                let container = null;

                                // Check for account alert container (highest priority)
                                const accountContainer = document.getElementById('accountAlertContainer');
                                const accountTab = document.getElementById('tab-account');
                                if (accountContainer && accountTab && accountTab.classList.contains('active')) {
                                    container = accountContainer;
                                }

                                // Check for visible modal
                                if (!container) {
                                    const visibleModal = document.querySelector('#verifyEmailModal[style*="display: flex"], #verifyPhoneModal[style*="display: flex"]');
                                    if (visibleModal) {
                                        container = visibleModal.querySelector('div[style*="background:white"]');
                                    }
                                }

                                // Use active tab's card-compact
                                if (!container) {
                                    const activeTab = document.querySelector('.tab-content-section.active');
                                    if (activeTab) {
                                        const cardCompact = activeTab.querySelector('.card-compact');
                                        container = cardCompact || activeTab;
                                    }
                                }

                                // Fallback to profile wrapper
                                if (!container) {
                                    container = document.querySelector('.profile-wrapper');
                                }

                                if (container) {
                                    // If container is accountAlertContainer, just append
                                    // Otherwise, insertBefore first child
                                    if (container.id === 'accountAlertContainer') {
                                        container.appendChild(alertDiv);
                                    } else {
                                        container.insertBefore(alertDiv, container.firstChild);
                                    }

                                    // Scroll to alert
                                    alertDiv.scrollIntoView({ behavior: 'smooth', block: 'nearest' });

                                    // Auto-hide after 5 seconds
                                    setTimeout(() => {
                                        alertDiv.style.opacity = '0';
                                        setTimeout(() => alertDiv.remove(), 500);
                                    }, 5000);
                                }
                            }
                        </script>

                        <style>
                            .inline-alert {
                                padding: 15px 20px;
                                margin: 0 0 20px 0;
                                border-radius: 6px;
                                font-size: 14px;
                                font-weight: 500;
                                display: flex;
                                align-items: center;
                                gap: 12px;
                                animation: slideDown 0.3s ease-out;
                                transition: opacity 0.5s ease-out;
                            }

                            .inline-alert i {
                                font-size: 18px;
                            }

                            .inline-alert-danger {
                                background: #f8d7da;
                                color: #721c24;
                                border: 1px solid #f5c6cb;
                            }

                            .inline-alert-success {
                                background: #d4edda;
                                color: #155724;
                                border: 1px solid #c3e6cb;
                            }

                            .inline-alert-warning {
                                background: #fff3cd;
                                color: #856404;
                                border: 1px solid #ffeeba;
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
                    </div>
                </div>
            </body>

            </html>