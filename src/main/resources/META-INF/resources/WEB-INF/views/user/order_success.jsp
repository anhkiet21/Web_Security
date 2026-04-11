<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Đặt hàng thành công - CellPhoneStore</title>
            <style>
                /* Success Page Styles */
                .success-section {
                    padding: 40px 0 80px;
                }

                .success-container {
                    background: white;
                    border-radius: 12px;
                    padding: 50px 40px;
                    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
                    max-width: 700px;
                    margin: 0 auto;
                    text-align: center;
                    animation: slideUp 0.6s ease-out;
                }

                @keyframes slideUp {
                    from {
                        opacity: 0;
                        transform: translateY(30px);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }

                .success-icon {
                    width: 100px;
                    height: 100px;
                    margin: 0 auto 25px;
                    background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    animation: scaleIn 0.5s ease-out 0.2s both;
                    box-shadow: 0 8px 25px rgba(16, 185, 129, 0.25);
                }

                @keyframes scaleIn {
                    from {
                        transform: scale(0);
                        opacity: 0;
                    }

                    to {
                        transform: scale(1);
                        opacity: 1;
                    }
                }

                .success-icon i {
                    font-size: 50px;
                    color: white;
                }

                .success-title {
                    font-size: 28px;
                    font-weight: bold;
                    color: #10b981;
                    margin-bottom: 15px;
                    animation: fadeIn 0.6s ease 0.3s both;
                }

                @keyframes fadeIn {
                    from {
                        opacity: 0;
                    }

                    to {
                        opacity: 1;
                    }
                }

                .success-message {
                    font-size: 15px;
                    color: #666;
                    line-height: 1.6;
                    margin-bottom: 12px;
                    animation: fadeIn 0.6s ease 0.4s both;
                }

                .order-id-box {
                    background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 100%);
                    border: 2px solid #10b981;
                    border-radius: 10px;
                    padding: 18px;
                    margin: 25px 0;
                    animation: fadeIn 0.6s ease 0.5s both;
                }

                .order-id-label {
                    font-size: 13px;
                    color: #059669;
                    margin-bottom: 6px;
                    font-weight: 600;
                }

                .order-id-value {
                    font-size: 24px;
                    font-weight: bold;
                    color: #10b981;
                    letter-spacing: 1px;
                }

                .success-info {
                    background: #f8f9fa;
                    border-radius: 10px;
                    padding: 20px;
                    margin: 20px 0;
                    animation: fadeIn 0.6s ease 0.6s both;
                }

                .info-item {
                    display: flex;
                    align-items: flex-start;
                    gap: 12px;
                    padding: 10px 0;
                    color: #555;
                    font-size: 14px;
                    text-align: left;
                }

                .info-item i {
                    color: #10b981;
                    font-size: 18px;
                    margin-top: 2px;
                    min-width: 18px;
                }

                .success-actions {
                    display: flex;
                    gap: 12px;
                    margin-top: 30px;
                    animation: fadeIn 0.6s ease 0.7s both;
                    flex-wrap: wrap;
                }

                .btn-success-action {
                    flex: 1;
                    min-width: 180px;
                    padding: 14px 28px;
                    font-size: 15px;
                    font-weight: 600;
                    border: none;
                    border-radius: 8px;
                    cursor: pointer;
                    transition: all 0.3s;
                    text-decoration: none;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    gap: 8px;
                }

                .btn-primary-action {
                    background: linear-gradient(135deg, #d70018 0%, #f05423 100%);
                    color: white;
                }

                .btn-primary-action:hover {
                    transform: translateY(-3px);
                    box-shadow: 0 8px 20px rgba(215, 0, 24, 0.3);
                    color: white;
                }

                .btn-secondary-action {
                    background: white;
                    color: #d70018;
                    border: 2px solid #d70018;
                }

                .btn-secondary-action:hover {
                    background: #d70018;
                    color: white;
                    transform: translateY(-3px);
                    box-shadow: 0 8px 20px rgba(215, 0, 24, 0.2);
                }

                .btn-outline-action {
                    background: white;
                    color: #10b981;
                    border: 2px solid #10b981;
                }

                .btn-outline-action:hover {
                    background: #10b981;
                    color: white;
                    transform: translateY(-3px);
                    box-shadow: 0 8px 20px rgba(16, 185, 129, 0.2);
                }

                .divider {
                    height: 1px;
                    background: linear-gradient(to right, transparent, #e0e0e0, transparent);
                    margin: 25px 0;
                }

                @media (max-width: 768px) {
                    .success-container {
                        padding: 35px 25px;
                    }

                    .success-title {
                        font-size: 24px;
                    }

                    .order-id-value {
                        font-size: 20px;
                    }

                    .success-actions {
                        flex-direction: column;
                    }

                    .btn-success-action {
                        width: 100%;
                        min-width: 100%;
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
                                <li><a href="${pageContext.request.contextPath}/order">Đơn hàng</a></li>
                                <li class="active">Đặt hàng thành công</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /BREADCRUMB -->

            <!-- SUCCESS SECTION -->
            <div class="success-section">
                <div class="container">
                    <div class="success-container">
                        <!-- Success Icon with Checkmark -->
                        <div class="success-icon">
                            <i class="fa fa-check"></i>
                        </div>

                        <!-- Success Title -->
                        <h1 class="success-title">
                            Đặt hàng thành công!
                        </h1>

                        <!-- Success Message -->
                        <p class="success-message">
                            Cảm ơn bạn đã tin tưởng và mua sắm tại <strong>CellPhoneStore</strong>
                        </p>

                        <!-- Order ID Box -->
                        <c:if test="${not empty orderId}">
                            <div class="order-id-box">
                                <div class="order-id-label">Mã đơn hàng của bạn</div>
                                <div class="order-id-value">#${orderId}</div>
                            </div>
                        </c:if>

                        <!-- Additional Info -->
                        <div class="success-info">
                            <div class="info-item">
                                <i class="fa fa-check-circle"></i>
                                <span>Đơn hàng của bạnđang được xử lý</span>
                            </div>
                            <div class="info-item">
                                <i class="fa fa-truck"></i>
                                <span>Đơn hàng sẽ được giao đến địa chỉ: <strong>${order.shippingAddress}</strong> trong
                                    2-3 ngày làm việc</span>
                            </div>
                            <div class="info-item">
                                <i class="fa fa-phone"></i>
                                <span>Chúng tôi sẽ liên hệ qua số điện thoại <strong>${user.phone}</strong> để xác
                                    nhận đơn hàng</span>
                            </div>
                        </div>

                        <div class="divider"></div>

                        <!-- Action Buttons -->
                        <div class="success-actions">
                            <c:if test="${not empty orderId}">
                                <a href="${pageContext.request.contextPath}/order/${orderId}"
                                    class="btn-success-action btn-primary-action">
                                    <i class="fa fa-eye"></i>
                                    Xem chi tiết đơn hàng
                                </a>
                            </c:if>

                            <a href="${pageContext.request.contextPath}/shop"
                                class="btn-success-action btn-secondary-action">
                                <i class="fa fa-shopping-cart"></i>
                                Tiếp tục mua sắm
                            </a>
                        </div>

                        <div style="margin-top: 15px;">
                            <a href="${pageContext.request.contextPath}/profile#orders"
                                class="btn-success-action btn-outline-action" style="max-width: 400px;">
                                <i class="fa fa-list"></i>
                                Danh sách đơn hàng
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /SUCCESS SECTION -->

        </body>

        </html>