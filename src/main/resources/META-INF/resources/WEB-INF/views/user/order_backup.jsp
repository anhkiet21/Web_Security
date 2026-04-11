<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đặt Hàng - CellPhoneStore</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f5f5f5;
            }

            .header {
                background: linear-gradient(135deg, #d70018 0%, #f05423 100%);
                color: white;
                padding: 15px 20px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            }

            .header-container {
                max-width: 1200px;
                margin: 0 auto;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .header-logo {
                font-size: 24px;
                font-weight: bold;
                text-decoration: none;
                color: white;
            }

            .btn-back {
                background: rgba(255, 255, 255, 0.2);
                border: none;
                padding: 10px 20px;
                border-radius: 8px;
                color: white;
                cursor: pointer;
                text-decoration: none;
            }

            .btn-back:hover {
                background: rgba(255, 255, 255, 0.3);
            }

            .container {
                max-width: 1200px;
                margin: 30px auto;
                padding: 0 20px;
            }

            h1 {
                color: #333;
                margin-bottom: 30px;
            }

            .order-content {
                display: grid;
                grid-template-columns: 1fr 400px;
                gap: 20px;
            }

            .order-form-section {
                background: white;
                border-radius: 8px;
                padding: 30px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            .form-section-title {
                font-size: 20px;
                font-weight: bold;
                margin-bottom: 20px;
                padding-bottom: 15px;
                border-bottom: 2px solid #e0e0e0;
                color: #333;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
                color: #555;
            }

            .form-label.required::after {
                content: " *";
                color: #d70018;
            }

            .form-input {
                width: 100%;
                padding: 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 15px;
                transition: border-color 0.3s;
            }

            .form-input:focus {
                outline: none;
                border-color: #d70018;
            }

            .form-input.error {
                border-color: #dc3545;
            }

            .error-message {
                color: #dc3545;
                font-size: 13px;
                margin-top: 5px;
            }

            textarea.form-input {
                resize: vertical;
                min-height: 80px;
            }

            .order-summary {
                background: white;
                border-radius: 8px;
                padding: 20px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                position: sticky;
                top: 20px;
                height: fit-content;
            }

            .summary-title {
                font-size: 20px;
                font-weight: bold;
                margin-bottom: 20px;
                padding-bottom: 15px;
                border-bottom: 2px solid #e0e0e0;
            }

            .order-item {
                display: flex;
                padding: 15px 0;
                border-bottom: 1px solid #f0f0f0;
            }

            .order-item-image {
                width: 60px;
                height: 60px;
                object-fit: cover;
                border-radius: 4px;
                margin-right: 12px;
                background: #f0f0f0;
            }

            .order-item-info {
                flex: 1;
            }

            .order-item-name {
                font-size: 14px;
                color: #333;
                margin-bottom: 5px;
            }

            .order-item-qty {
                font-size: 13px;
                color: #666;
            }

            .order-item-price {
                font-size: 15px;
                color: #d70018;
                font-weight: bold;
            }

            .summary-row {
                display: flex;
                justify-content: space-between;
                margin: 15px 0;
                font-size: 15px;
            }

            .summary-row.total {
                font-size: 20px;
                font-weight: bold;
                color: #d70018;
                padding-top: 15px;
                border-top: 2px solid #e0e0e0;
                margin-top: 20px;
            }

            .btn-place-order {
                width: 100%;
                padding: 15px;
                background: #d70018;
                color: white;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: bold;
                cursor: pointer;
                margin-top: 20px;
                transition: all 0.3s;
            }

            .btn-place-order:hover {
                background: #b8001a;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(215, 0, 24, 0.3);
            }

            .btn-place-order:disabled {
                background: #ccc;
                cursor: not-allowed;
                transform: none;
            }

            .message {
                padding: 15px;
                margin-bottom: 20px;
                border-radius: 8px;
                text-align: center;
            }

            .message.success {
                background: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }

            .message.error {
                background: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }

            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
            }

            .modal-content {
                background-color: white;
                margin: 10% auto;
                padding: 40px;
                border-radius: 12px;
                width: 90%;
                max-width: 500px;
                text-align: center;
            }

            .modal-icon {
                font-size: 80px;
                margin-bottom: 20px;
            }

            .modal-title {
                font-size: 24px;
                color: #4CAF50;
                margin-bottom: 20px;
                font-weight: bold;
            }

            .modal-body {
                margin-bottom: 30px;
                color: #666;
                font-size: 15px;
            }

            .modal-buttons {
                display: flex;
                gap: 15px;
                justify-content: center;
            }

            .btn-modal {
                padding: 12px 30px;
                border: none;
                border-radius: 8px;
                font-size: 15px;
                font-weight: bold;
                cursor: pointer;
                transition: all 0.3s;
            }

            .btn-primary {
                background: #d70018;
                color: white;
            }

            .btn-primary:hover {
                background: #b8001a;
            }

            .btn-secondary {
                background: #6c757d;
                color: white;
            }

            .btn-secondary:hover {
                background: #5a6268;
            }

            @media (max-width: 768px) {
                .order-content {
                    grid-template-columns: 1fr;
                }

                .order-summary {
                    position: static;
                }
            }
        </style>
    </head>

    <body>
        <div class="header">
            <div class="header-container">
                <a href="/shop" class="header-logo"> CellPhoneStore</a>
                <a href="/cart" class="btn-back"> Quay lại giỏ hàng</a>
            </div>
        </div>

        <div class="container">
            <h1> Thông Tin Đặt Hàng</h1>

            <div id="messageContainer"></div>

            <div class="order-content">
                <div class="order-form-section">
                    <div class="form-section-title">Thông tin giao hàng</div>

                    <form id="orderForm">
                        <div class="form-group">
                            <label class="form-label required">Họ và tên</label>
                            <input type="text" class="form-input" id="fullName" name="fullName"
                                placeholder="Nhập họ và tên">
                            <div class="error-message" id="fullNameError"></div>
                        </div>

                        <div class="form-group">
                            <label class="form-label required">Số điện thoại</label>
                            <input type="tel" class="form-input" id="phone" name="phone"
                                placeholder="Nhập số điện thoại">
                            <div class="error-message" id="phoneError"></div>
                        </div>

                        <div class="form-group">
                            <label class="form-label required">Địa chỉ giao hàng</label>
                            <textarea class="form-input" id="address" name="address"
                                placeholder="Số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành phố"></textarea>
                            <div class="error-message" id="addressError"></div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Ghi chú</label>
                            <textarea class="form-input" id="notes" name="notes"
                                placeholder="Ghi chú thêm (không bắt buộc)"></textarea>
                        </div>
                    </form>
                </div>

                <div class="order-summary">
                    <div class="summary-title">Đơn hàng của bạn</div>

                    <div id="orderItemsList"></div>

                    <div class="summary-row">
                        <span>Tạm tính:</span>
                        <span id="subtotal">0 </span>
                    </div>

                    <div class="summary-row">
                        <span>Phí vận chuyển:</span>
                        <span id="shippingFee">Miễn phí</span>
                    </div>

                    <div class="summary-row total">
                        <span>Tổng cộng:</span>
                        <span id="totalPrice">0 </span>
                    </div>

                    <button class="btn-place-order" onclick="placeOrder()">
                        Đặt hàng
                    </button>
                </div>
            </div>
        </div>

        <div id="successModal" class="modal">
            <div class="modal-content">
                <div class="modal-icon"></div>
                <h2 class="modal-title">Đặt hàng thành công!</h2>
                <div class="modal-body" id="modalBody"></div>
                <div class="modal-buttons">
                    <button class="btn-modal btn-primary" onclick="goToShop()">Tiếp tục mua sắm</button>
                    <button class="btn-modal btn-secondary" onclick="viewOrder()">Xem đơn hàng</button>
                </div>
            </div>
        </div>

        <script>
            var selectedItems = [];
            var orderId = null;

            document.addEventListener('DOMContentLoaded', function () {
                var itemsData = sessionStorage.getItem('selectedCartItems');
                if (!itemsData) {
                    showMessage('Khong co san pham nao duoc chon', 'error');
                    setTimeout(function () {
                        window.location.href = '/cart';
                    }, 2000);
                    return;
                }

                selectedItems = JSON.parse(itemsData);
                renderOrderItems();
            });

            function renderOrderItems() {
                var container = document.getElementById('orderItemsList');
                container.innerHTML = '';
                var fragment = document.createDocumentFragment();
                var subtotal = 0;

                selectedItems.forEach(function (item) {
                    var itemDiv = document.createElement('div');
                    itemDiv.className = 'order-item';
                    var imgSrc = item.imageUrl && item.imageUrl.trim() !== '' ? item.imageUrl : 'data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%2260%22 height=%2260%22%3E%3Crect fill=%22%23f0f0f0%22 width=%2260%22 height=%2260%22/%3E%3Ctext x=%2250%25%22 y=%2250%25%22 dominant-baseline=%22middle%22 text-anchor=%22middle%22 font-family=%22Arial%22 font-size=%2210%22 fill=%22%23999%22%3ENo Image%3C/text%3E%3C/svg%3E';

                    itemDiv.innerHTML =
                        '<img class="order-item-image" src="' + imgSrc + '" alt="' + item.name + '">' +
                        '<div class="order-item-info">' +
                        '<div class="order-item-name">' + item.name + '</div>' +
                        '<div class="order-item-qty">So luong: ' + item.quantity + '</div>' +
                        '</div>' +
                        '<div class="order-item-price">' + formatPrice(item.price * item.quantity) + '</div>';

                    fragment.appendChild(itemDiv);
                    subtotal += item.price * item.quantity;
                });

                container.appendChild(fragment);
                document.getElementById('subtotal').textContent = formatPrice(subtotal);
                document.getElementById('totalPrice').textContent = formatPrice(subtotal);
            }

            function validateForm() {
                var isValid = true;
                var fullName = document.getElementById('fullName').value.trim();
                var phone = document.getElementById('phone').value.trim();
                var address = document.getElementById('address').value.trim();

                document.querySelectorAll('.error-message').forEach(function (el) {
                    el.textContent = '';
                });
                document.querySelectorAll('.form-input').forEach(function (el) {
                    el.classList.remove('error');
                });

                if (!fullName) {
                    document.getElementById('fullNameError').textContent = 'Vui long nhap ho va ten';
                    document.getElementById('fullName').classList.add('error');
                    isValid = false;
                }

                if (!phone) {
                    document.getElementById('phoneError').textContent = 'Vui long nhap so dien thoai';
                    document.getElementById('phone').classList.add('error');
                    isValid = false;
                } else if (!/^[0-9]{10,11}$/.test(phone)) {
                    document.getElementById('phoneError').textContent = 'So dien thoai khong hop le';
                    document.getElementById('phone').classList.add('error');
                    isValid = false;
                }

                if (!address) {
                    document.getElementById('addressError').textContent = 'Vui long nhap dia chi';
                    document.getElementById('address').classList.add('error');
                    isValid = false;
                }

                return isValid;
            }

            function placeOrder() {
                if (!validateForm()) {
                    showMessage('Vui long dien day du thong tin', 'error');
                    return;
                }

                var fullName = document.getElementById('fullName').value.trim();
                var phone = document.getElementById('phone').value.trim();
                var address = document.getElementById('address').value.trim();
                var notes = document.getElementById('notes').value.trim();

                var orderItems = selectedItems.map(function (item) {
                    return {
                        productId: item.productId,
                        quantity: item.quantity,
                        price: item.price
                    };
                });

                var totalAmount = selectedItems.reduce(function (sum, item) {
                    return sum + (item.price * item.quantity);
                }, 0);

                var orderData = {
                    orderItems: orderItems,
                    totalAmount: totalAmount,
                    shippingAddress: address,
                    fullName: fullName,
                    phone: phone,
                    notes: notes
                };

                fetch('/api/orders/create', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    credentials: 'include',
                    body: JSON.stringify(orderData)
                })
                    .then(function (response) {
                        if (!response.ok) {
                            if (response.status === 401 || response.status === 403) {
                                showMessage('Vui long dang nhap de dat hang', 'error');
                                setTimeout(function () {
                                    window.location.href = '/login';
                                }, 1500);
                                throw new Error('Chua dang nhap');
                            }
                            throw new Error('Khong the tao don hang');
                        }
                        return response.json();
                    })
                    .then(function (order) {
                        orderId = order.orderId;

                        var modalBody = document.getElementById('modalBody');
                        modalBody.innerHTML =
                            '<p style="margin-bottom: 10px;"><strong>Ma don hang:</strong> #' + order.orderId + '</p>' +
                            '<p style="margin-bottom: 10px;"><strong>Tong tien:</strong> ' + formatPrice(totalAmount) + '</p>' +
                            '<p style="color: #4CAF50; margin-top: 15px;">Don hang cua ban dang duoc xu ly!</p>';

                        document.getElementById('successModal').style.display = 'block';

                        var removePromises = selectedItems.map(function (item) {
                            return fetch('/api/cart/remove/' + item.productId, {
                                method: 'DELETE',
                                credentials: 'include'
                            });
                        });

                        Promise.all(removePromises).then(function () {
                            sessionStorage.removeItem('selectedCartItems');
                        });
                    })
                    .catch(function (error) {
                        console.error('Error:', error);
                        if (!error.message.includes('Chua dang nhap')) {
                            showMessage('Loi: ' + error.message, 'error');
                        }
                    });
            }

            function goToShop() {
                window.location.href = '/shop';
            }

            function viewOrder() {
                window.location.href = '/home';
            }

            function formatPrice(price) {
                return new Intl.NumberFormat('vi-VN', {
                    style: 'currency',
                    currency: 'VND'
                }).format(price);
            }

            function showMessage(message, type) {
                var container = document.getElementById('messageContainer');
                var msgDiv = document.createElement('div');
                msgDiv.className = 'message ' + type;
                msgDiv.textContent = message;

                container.appendChild(msgDiv);

                setTimeout(function () {
                    msgDiv.remove();
                }, 5000);
            }
        </script>
    </body>

    </html>