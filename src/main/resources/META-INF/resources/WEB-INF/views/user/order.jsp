<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Hàng - CellPhoneStore</title>
    <style>
/* Order Page Styles */
.order-title {
    color: #333;
    margin-bottom: 30px;
    font-size: 28px;
    font-weight: bold;
    text-align: center;
}

/* Form Section */
.order-form-section {
    background: white;
    border-radius: 8px;
    padding: 30px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    margin-bottom: 20px;
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
    content: ' *';
    color: #d70018;
}

.form-input,
.form-textarea {
    width: 100%;
    padding: 12px 15px;
    border: 1px solid #ddd;
    border-radius: 6px;
    font-size: 14px;
    transition: border-color 0.3s;
}

.form-input:focus,
.form-textarea:focus {
    outline: none;
    border-color: #d70018;
}

.form-input.error {
    border-color: #ff4444;
}

.form-textarea {
    resize: vertical;
    min-height: 100px;
}

.error-message {
    color: #ff4444;
    font-size: 13px;
    margin-top: 5px;
    display: block;
}

/* Order Summary */
.order-summary {
    background: white;
    border-radius: 8px;
    padding: 25px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    position: sticky;
    top: 20px;
}

.order-summary-title {
    font-size: 20px;
    font-weight: bold;
    margin-bottom: 20px;
    padding-bottom: 15px;
    border-bottom: 2px solid #e0e0e0;
    color: #333;
}

.order-items-list {
    max-height: 300px;
    overflow-y: auto;
    margin-bottom: 20px;
}

.order-item {
    display: flex;
    gap: 15px;
    padding: 15px 0;
    border-bottom: 1px solid #f0f0f0;
}

.order-item:last-child {
    border-bottom: none;
}

.order-item-image {
    width: 60px;
    height: 60px;
    object-fit: cover;
    border-radius: 6px;
    border: 1px solid #eee;
}

.order-item-info {
    flex: 1;
}

.order-item-name {
    font-weight: 600;
    color: #333;
    margin-bottom: 5px;
}

.order-item-qty {
    color: #666;
    font-size: 13px;
}

.order-item-price {
    font-weight: bold;
    color: #d70018;
    white-space: nowrap;
}

/* Price Summary */
.price-summary {
    border-top: 2px solid #e0e0e0;
    padding-top: 15px;
}

.price-row {
    display: flex;
    justify-content: space-between;
    margin-bottom: 12px;
    font-size: 15px;
}

.price-row.total {
    margin-top: 15px;
    padding-top: 15px;
    border-top: 2px solid #e0e0e0;
    font-size: 18px;
    font-weight: bold;
    color: #d70018;
}

/* Place Order Button */
.btn-place-order {
    width: 100%;
    padding: 15px;
    background: linear-gradient(135deg, #d70018 0%, #f05423 100%);
    color: white;
    border: none;
    border-radius: 8px;
    font-size: 16px;
    font-weight: bold;
    cursor: pointer;
    transition: transform 0.2s;
}

.btn-place-order:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(215, 0, 24, 0.3);
}

/* Messages */
#messageContainer {
    position: fixed;
    top: 80px;
    right: 20px;
    z-index: 10000;
    max-width: 400px;
}

.message {
    padding: 15px 20px;
    margin-bottom: 10px;
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    animation: slideIn 0.3s ease-out;
}

@keyframes slideIn {
    from {
        transform: translateX(100%);
        opacity: 0;
    }
    to {
        transform: translateX(0);
        opacity: 1;
    }
}

.message.success {
    background: #4CAF50;
    color: white;
}

.message.error {
    background: #ff4444;
    color: white;
}

/* Modal */
.modal {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.6);
    z-index: 10001;
    align-items: center;
    justify-content: center;
}

.modal-content {
    background: white;
    border-radius: 12px;
    padding: 40px;
    max-width: 500px;
    width: 90%;
    text-align: center;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
}

.modal-icon {
    width: 80px;
    height: 80px;
    margin: 0 auto 20px;
    background: #4CAF50;
    border-radius: 50%;
    position: relative;
}

.modal-icon::after {
    content: '✓';
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    color: white;
    font-size: 50px;
    font-weight: bold;
}

.modal-title {
    font-size: 24px;
    font-weight: bold;
    color: #333;
    margin-bottom: 15px;
}

.modal-body {
    color: #666;
    margin-bottom: 25px;
    line-height: 1.6;
}

.modal-buttons {
    display: flex;
    gap: 15px;
    justify-content: center;
}

.btn-modal {
    padding: 12px 30px;
    border: none;
    border-radius: 6px;
    font-size: 15px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s;
}

.btn-modal.btn-primary {
    background: #d70018;
    color: white;
}

.btn-modal.btn-primary:hover {
    background: #b50015;
}

.btn-modal.btn-secondary {
    background: #f0f0f0;
    color: #333;
}

.btn-modal.btn-secondary:hover {
    background: #e0e0e0;
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
                    <li><a href="${pageContext.request.contextPath}/cart">Giỏ hàng</a></li>
                    <li class="active">Đặt hàng</li>
                </ul>
            </div>
        </div>
    </div>
</div>
<!-- /BREADCRUMB -->

<!-- ORDER PAGE -->
<div class="section">
    <div class="container">
        <h1 class="order-title"><i class="fa fa-shopping-bag"></i> Thông Tin Đặt Hàng</h1>

        <div id="messageContainer"></div>

        <div class="row">
            <!-- Order Form -->
            <div class="col-md-8">
                <div class="order-form-section">
                    <div class="form-section-title"><i class="fa fa-truck"></i> Thông tin giao hàng</div>

                    <div class="form-group">
                        <label class="form-label required" for="fullName">Họ và tên</label>
                        <input type="text" id="fullName" class="form-input" placeholder="Nhập họ và tên đầy đủ">
                        <span class="error-message" id="fullNameError"></span>
                    </div>

                    <div class="form-group">
                        <label class="form-label required" for="phone">Số điện thoại</label>
                        <input type="tel" id="phone" class="form-input" placeholder="Nhập số điện thoại">
                        <span class="error-message" id="phoneError"></span>
                    </div>

                    <div class="form-group">
                        <label class="form-label required" for="address">Địa chỉ giao hàng</label>
                        <input type="text" id="address" class="form-input" placeholder="Nhập địa chỉ chi tiết">
                        <span class="error-message" id="addressError"></span>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="notes">Ghi chú</label>
                        <textarea id="notes" class="form-textarea" placeholder="Ghi chú thêm về đơn hàng (tùy chọn)"></textarea>
                    </div>
                </div>
            </div>

            <!-- Order Summary -->
            <div class="col-md-4">
                <div class="order-summary">
                    <div class="order-summary-title"><i class="fa fa-list-alt"></i> Đơn hàng của bạn</div>

                    <div class="order-items-list" id="orderItemsList">
                        <!-- Items will be rendered by JavaScript -->
                    </div>

                    <div class="price-summary">
                        <div class="price-row">
                            <span>Tạm tính:</span>
                            <span id="subtotal">0đ</span>
                        </div>
                        <div class="price-row">
                            <span>Phí vận chuyển:</span>
                            <span>Miễn phí</span>
                        </div>
                        <div class="price-row total">
                            <span>Tổng cộng:</span>
                            <span id="totalPrice">0đ</span>
                        </div>
                    </div>

                    <button class="btn-place-order" onclick="placeOrder()">
                        <i class="fa fa-check-circle"></i> Đặt hàng
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- /ORDER PAGE -->

<!-- Success Modal -->
<div id="successModal" class="modal">
    <div class="modal-content">
        <div class="modal-icon"></div>
        <h2 class="modal-title">Đặt hàng thành công!</h2>
        <div class="modal-body" id="modalBody"></div>
        <div class="modal-buttons">
            <button class="btn-modal btn-primary" onclick="goToShop()">
                <i class="fa fa-shopping-cart"></i> Tiếp tục mua sắm
            </button>
            <button class="btn-modal btn-secondary" onclick="viewOrder()">
                <i class="fa fa-list"></i> Về trang chủ
            </button>
        </div>
    </div>
</div>

<script>
var selectedItems = [];
var orderId = null;

document.addEventListener('DOMContentLoaded', function () {
    var itemsData = sessionStorage.getItem('selectedCartItems');
    if (!itemsData) {
        showMessage('Không có sản phẩm nào được chọn', 'error');
        setTimeout(function () {
            window.location.href = '${pageContext.request.contextPath}/cart';
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
        var imgSrc = item.imageUrl && item.imageUrl.trim() !== '' 
            ? '${pageContext.request.contextPath}' + item.imageUrl 
            : '${pageContext.request.contextPath}/images/no-image.png';

        itemDiv.innerHTML =
            '<img class="order-item-image" src="' + imgSrc + '" alt="' + item.name + '">' +
            '<div class="order-item-info">' +
            '<div class="order-item-name">' + item.name + '</div>' +
            '<div class="order-item-qty">Số lượng: ' + item.quantity + '</div>' +
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
        document.getElementById('fullNameError').textContent = 'Vui lòng nhập họ và tên';
        document.getElementById('fullName').classList.add('error');
        isValid = false;
    }

    if (!phone) {
        document.getElementById('phoneError').textContent = 'Vui lòng nhập số điện thoại';
        document.getElementById('phone').classList.add('error');
        isValid = false;
    } else if (!/^[0-9]{10,11}$/.test(phone)) {
        document.getElementById('phoneError').textContent = 'Số điện thoại không hợp lệ';
        document.getElementById('phone').classList.add('error');
        isValid = false;
    }

    if (!address) {
        document.getElementById('addressError').textContent = 'Vui lòng nhập địa chỉ';
        document.getElementById('address').classList.add('error');
        isValid = false;
    }

    return isValid;
}

function placeOrder() {
    if (!validateForm()) {
        showMessage('Vui lòng điền đầy đủ thông tin', 'error');
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

    fetch('${pageContext.request.contextPath}/api/orders/create', {
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
                    showMessage('Vui lòng đăng nhập để đặt hàng', 'error');
                    setTimeout(function () {
                        window.location.href = '${pageContext.request.contextPath}/login';
                    }, 1500);
                    throw new Error('Chưa đăng nhập');
                }
                throw new Error('Không thể tạo đơn hàng');
            }
            return response.json();
        })
        .then(function (order) {
            orderId = order.orderId;

            var modalBody = document.getElementById('modalBody');
            modalBody.innerHTML =
                '<p style="margin-bottom: 10px;"><strong>Mã đơn hàng:</strong> #' + order.orderId + '</p>' +
                '<p style="margin-bottom: 10px;"><strong>Tổng tiền:</strong> ' + formatPrice(totalAmount) + '</p>' +
                '<p style="color: #4CAF50; margin-top: 15px;">Đơn hàng của bạn đang được xử lý!</p>';

            document.getElementById('successModal').style.display = 'flex';

            var removePromises = selectedItems.map(function (item) {
                return fetch('${pageContext.request.contextPath}/api/cart/remove/' + item.productId, {
                    method: 'DELETE',
                    credentials: 'include'
                });
            });

            Promise.all(removePromises).then(function () {
                sessionStorage.removeItem('selectedCartItems');
                // Update cart count
                if (typeof updateGlobalCartCount === 'function') {
                    updateGlobalCartCount();
                }
            });
        })
        .catch(function (error) {
            console.error('Error:', error);
            if (!error.message.includes('Chưa đăng nhập')) {
                showMessage('Lỗi: ' + error.message, 'error');
            }
        });
}

function goToShop() {
    window.location.href = '${pageContext.request.contextPath}/shop';
}

function viewOrder() {
    window.location.href = '${pageContext.request.contextPath}/';
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
