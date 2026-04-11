<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Xác nhận đơn hàng - CellPhoneStore</title>
                <style>
                    /* Order Page Styles */
                    .order-title {
                        color: #333;
                        margin-bottom: 30px;
                        font-size: 28px;
                        font-weight: bold;
                        text-align: center;
                    }

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
                        font-weight: 600;
                        color: #555;
                        margin-bottom: 8px;
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
                        transition: all 0.3s;
                        font-family: inherit;
                    }

                    .form-input:focus,
                    .form-textarea:focus {
                        outline: none;
                        border-color: #d70018;
                        box-shadow: 0 0 0 3px rgba(215, 0, 24, 0.1);
                    }

                    .form-input.error {
                        border-color: #ff4444;
                        background-color: #fff5f5;
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

                    .order-item {
                        display: flex;
                        gap: 15px;
                        padding: 15px 0;
                        border-bottom: 1px solid #f0f0f0;
                        align-items: center;
                    }

                    .order-item:last-child {
                        border-bottom: none;
                    }

                    .item-details {
                        flex: 1;
                    }

                    .item-name {
                        font-weight: 600;
                        color: #333;
                        margin: 0;
                    }

                    .item-info {
                        font-size: 0.9em;
                        color: #666;
                        margin: 4px 0 0;
                    }

                    .item-price {
                        font-weight: bold;
                        color: #d70018;
                        white-space: nowrap;
                    }

                    .total-summary {
                        margin-top: 20px;
                        border-top: 2px solid #e0e0e0;
                        padding-top: 15px;
                        font-size: 18px;
                        font-weight: bold;
                        color: #d70018;
                        text-align: right;
                    }

                    .btn-place-order {
                        width: 100%;
                        padding: 15px;
                        margin-top: 20px;
                        background: linear-gradient(135deg, #d70018 0%, #f05423 100%);
                        color: white;
                        border: none;
                        border-radius: 8px;
                        font-size: 16px;
                        font-weight: bold;
                        cursor: pointer;
                        transition: all 0.3s;
                    }

                    .btn-place-order:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 4px 12px rgba(215, 0, 24, 0.3);
                    }

                    .btn-place-order:disabled {
                        background: #aaa;
                        cursor: not-allowed;
                        transform: none;
                        opacity: 0.6;
                    }

                    #message-container {
                        text-align: center;
                        padding: 15px;
                        margin-bottom: 20px;
                        font-weight: bold;
                        border-radius: 6px;
                        display: none;
                    }

                    .msg-success {
                        background: #d4edda;
                        color: #155724;
                        border: 1px solid #c3e6cb;
                    }

                    .msg-error {
                        background: #f8d7da;
                        color: #721c24;
                        border: 1px solid #f5c6cb;
                    }

                    .msg-info {
                        background: #d1ecf1;
                        color: #0c5460;
                        border: 1px solid #bee5eb;
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
                                    <li class="active">Xác nhận đơn hàng</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- /BREADCRUMB -->

                <!-- ORDER PAGE -->
                <div class="section">
                    <div class="container">
                        <h1 class="order-title"><i class="fa fa-shopping-bag"></i> Xác nhận đơn hàng</h1>

                        <div id="message-container"></div>

                        <div class="row">
                            <!-- Order Form - User Info -->
                            <div class="col-md-8">
                                <div class="order-form-section">
                                    <div class="form-section-title"><i class="fa fa-truck"></i> Thông tin giao hàng
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label required" for="fullName">Họ và tên người nhận</label>
                                        <input type="text" id="fullName" class="form-input"
                                            placeholder="Nhập họ và tên đầy đủ" value="${user.fullName}">
                                        <span class="error-message" id="fullNameError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label required" for="phone">Số điện thoại</label>
                                        <input type="tel" id="phone" class="form-input" placeholder="Nhập số điện thoại"
                                            value="${user.phone}">
                                        <span class="error-message" id="phoneError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label required">Tỉnh/Thành phố</label>
                                        <select id="city" class="form-input">
                                            <option value="">-- Chọn Tỉnh/Thành phố --</option>
                                        </select>
                                        <span class="error-message" id="cityError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label required">Quận/Huyện</label>
                                        <select id="district" class="form-input" disabled>
                                            <option value="">-- Chọn Quận/Huyện --</option>
                                        </select>
                                        <span class="error-message" id="districtError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label required">Phường/Xã</label>
                                        <select id="ward" class="form-input" disabled>
                                            <option value="">-- Chọn Phường/Xã --</option>
                                        </select>
                                        <span class="error-message" id="wardError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label required" for="streetAddress">Số nhà, tên đường</label>
                                        <input type="text" id="streetAddress" class="form-input"
                                            placeholder="Ví dụ: 123 Đường Lê Văn Việt" value="${user.address}">
                                        <span class="error-message" id="streetError"></span>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label" for="notes">Ghi chú đơn hàng</label>
                                        <textarea id="notes" class="form-textarea"
                                            placeholder="Ghi chú thêm về đơn hàng (ví dụ: Giao hàng giờ hành chính, gọi trước khi giao...)"></textarea>
                                    </div>
                                </div>
                            </div>

                            <!-- Order Summary -->
                            <div class="col-md-4">
                                <div class="order-summary">
                                    <div class="order-summary-title"><i class="fa fa-list-alt"></i> Tóm tắt đơn hàng
                                    </div>

                                    <div id="order-items-list"></div>
                                    <div id="total" class="total-summary"></div>

                                    <button id="confirm-btn" class="btn-place-order" onclick="confirmAndCreateOrder()">
                                        <i class="fa fa-check-circle"></i> Xác nhận và Tạo đơn hàng
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- /ORDER PAGE -->

                <script>
                    var pendingOrderData;
                    const confirmBtn = document.getElementById('confirm-btn');
                    const messageContainer = document.getElementById('message-container');

                    // 1. Lấy các thẻ DIV quan trọng
                    const itemsListDiv = document.getElementById('order-items-list');
                    const totalDiv = document.getElementById('total');

                    // 2. Chạy khi trang tải xong
                    document.addEventListener('DOMContentLoaded', function () {

                        console.log("Trang order_create.jsp đã tải xong.");

                        // 3. Kiểm tra xem có tìm thấy các thẻ DIV không?
                        if (!itemsListDiv || !totalDiv) {
                            console.error("LỖI NGHIÊM TRỌNG: Không tìm thấy div 'order-items-list' hoặc 'total'.");
                            return;
                        }
                        console.log("Đã tìm thấy các DIV 'order-items-list' và 'total'.");

                        // 4. Lấy dữ liệu từ sessionStorage
                        const dataString = sessionStorage.getItem('pendingOrder');
                        if (!dataString) {
                            // Redirect immediately to cart if no pending order data
                            window.location.replace('${pageContext.request.contextPath}/cart');
                            return;
                        }
                        console.log('Đã lấy được dataString từ sessionStorage:', dataString);

                        try {
                            // 5. Thử parse JSON (chuyển chuỗi thành đối tượng)
                            pendingOrderData = JSON.parse(dataString);
                            console.log('Parse JSON thành công:', pendingOrderData);

                            // 6. Gọi hàm render
                            renderOrderSummary(pendingOrderData);

                        } catch (e) {
                            console.error("LỖI NGHIÊM TRỌNG KHI PARSE JSON:", e);
                            showMessage('Lỗi đọc dữ liệu đơn hàng. Vui lòng quay lại giỏ hàng.', 'msg-error');
                        }
                    });

                    // HÀM RENDER ORDER SUMMARY
                    function renderOrderSummary(data) {
                        console.log('Đang chạy hàm renderOrderSummary...');

                        if (!data || !Array.isArray(data.orderItems)) {
                            console.error("LỖI: data.orderItems không tồn tại hoặc không phải là mảng.", data);
                            return;
                        }

                        console.log('Tìm thấy ' + data.orderItems.length + ' sản phẩm để render.');

                        itemsListDiv.innerHTML = ''; // Xóa nội dung cũ

                        data.orderItems.forEach(function (item, index) {
                            console.log('Đang render sản phẩm ' + index + ':', item);

                            var itemDiv = document.createElement('div');
                            itemDiv.className = 'order-item';

                            var productName = item.productName || 'Sản phẩm (ID: ' + item.productId + ')';
                            var itemTotal = (item.price * item.quantity).toLocaleString('vi-VN');

                            // Tạo HTML cho giá sản phẩm
                            var priceHTML = '';
                            if (item.onDeal && item.dealPercentage > 0) {
                                // Có deal - hiển thị giá giảm + giá gốc gạch ngang + badge
                                var originalTotal = (item.originalPrice * item.quantity).toLocaleString('vi-VN');
                                var savedAmount = ((item.originalPrice - item.price) * item.quantity).toLocaleString('vi-VN');
                                
                                priceHTML = 
                                    '<div class="item-price" style="text-align: right;">' +
                                        '<div style="font-size: 16px; font-weight: bold; color: #d70018; margin-bottom: 3px;">' + itemTotal + ' ₫</div>' +
                                        '<div style="font-size: 13px; color: #999; text-decoration: line-through;">' + originalTotal + ' ₫</div>' +
                                        '<div style="margin-top: 5px;">' +
                                            '<span style="display: inline-block; background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%); color: white; padding: 2px 6px; border-radius: 3px; font-size: 11px; font-weight: bold; margin-right: 3px;">-' + item.dealPercentage + '%</span>' +
                                            '<span style="display: inline-block; background: linear-gradient(135deg, #26d97f 0%, #1abc9c 100%); color: white; padding: 2px 6px; border-radius: 3px; font-size: 11px; font-weight: bold;">Tiết kiệm ' + savedAmount + ' ₫</span>' +
                                        '</div>' +
                                    '</div>';
                            } else {
                                // Không có deal - hiển thị giá thông thường
                                priceHTML = '<div class="item-price">' + itemTotal + ' ₫</div>';
                            }

                            // Dùng dấu '+' để nối chuỗi (an toàn hơn)
                            itemDiv.innerHTML =
                                '<div class="item-details">' +
                                '<p class="item-name">' + productName + '</p>' +
                                '<p class="item-info">Số lượng: ' + item.quantity + '</p>' +
                                '</div>' +
                                priceHTML;

                            itemsListDiv.appendChild(itemDiv);
                        });

                        console.log('Render tổng tiền...');
                        // Dùng dấu '+' để nối chuỗi
                        totalDiv.innerHTML = 'Tổng cộng: ' + data.totalAmount.toLocaleString('vi-VN') + ' ₫';
                        console.log('RENDER HOÀN TẤT!');
                    }

                    // ============ ĐỊA CHỈ VIỆT NAM API ============
                    let addressData = {
                        cities: [],
                        districts: {},
                        wards: {}
                    };

                    // Load danh sách tỉnh/thành phố khi trang load
                    async function loadCities() {
                        try {
                            const response = await fetch('https://provinces.open-api.vn/api/p/');
                            const cities = await response.json();

                            addressData.cities = cities;

                            const citySelect = document.getElementById('city');
                            citySelect.innerHTML = '<option value="">-- Chọn Tỉnh/Thành phố --</option>';

                            cities.forEach(city => {
                                const option = document.createElement('option');
                                option.value = city.code;
                                option.textContent = city.name;
                                citySelect.appendChild(option);
                            });
                        } catch (error) {
                            console.error('Lỗi khi load danh sách tỉnh/thành phố:', error);
                        }
                    }

                    // Load danh sách quận/huyện khi chọn tỉnh/thành phố
                    async function loadDistricts(cityCode) {
                        try {
                            const response = await fetch('https://provinces.open-api.vn/api/p/' + cityCode + '?depth=2');
                            const cityData = await response.json();

                            addressData.districts[cityCode] = cityData.districts;

                            const districtSelect = document.getElementById('district');
                            const wardSelect = document.getElementById('ward');

                            districtSelect.innerHTML = '<option value="">-- Chọn Quận/Huyện --</option>';
                            wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';

                            cityData.districts.forEach(district => {
                                const option = document.createElement('option');
                                option.value = district.code;
                                option.textContent = district.name;
                                districtSelect.appendChild(option);
                            });

                            districtSelect.disabled = false;
                            wardSelect.disabled = true;
                        } catch (error) {
                            console.error('Lỗi khi load danh sách quận/huyện:', error);
                        }
                    }

                    // Load danh sách phường/xã khi chọn quận/huyện
                    async function loadWards(districtCode) {
                        try {
                            const response = await fetch('https://provinces.open-api.vn/api/d/' + districtCode + '?depth=2');
                            const districtData = await response.json();

                            addressData.wards[districtCode] = districtData.wards;

                            const wardSelect = document.getElementById('ward');
                            wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';

                            districtData.wards.forEach(ward => {
                                const option = document.createElement('option');
                                option.value = ward.code;
                                option.textContent = ward.name;
                                wardSelect.appendChild(option);
                            });

                            wardSelect.disabled = false;
                        } catch (error) {
                            console.error('Lỗi khi load danh sách phường/xã:', error);
                        }
                    }

                    // Xử lý sự kiện khi chọn tỉnh/thành phố
                    document.getElementById('city').addEventListener('change', function () {
                        const cityCode = this.value;
                        document.getElementById('district').value = '';
                        document.getElementById('ward').value = '';
                        document.getElementById('ward').disabled = true;

                        if (cityCode) {
                            loadDistricts(cityCode);
                        } else {
                            document.getElementById('district').disabled = true;
                            document.getElementById('district').innerHTML = '<option value="">-- Chọn Quận/Huyện --</option>';
                            document.getElementById('ward').innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
                        }
                    });

                    // Xử lý sự kiện khi chọn quận/huyện
                    document.getElementById('district').addEventListener('change', function () {
                        const districtCode = this.value;
                        document.getElementById('ward').value = '';

                        if (districtCode) {
                            loadWards(districtCode);
                        } else {
                            document.getElementById('ward').disabled = true;
                            document.getElementById('ward').innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
                        }
                    });

                    // Load cities khi trang load
                    loadCities();
                    // ============ HẾT PHẦN ĐỊA CHỈ ============

                    // HÀM XÁC NHẬN VÀ TẠO ĐƠN HÀNG
                    function confirmAndCreateOrder() {
                        if (!pendingOrderData) {
                            showMessage('Lỗi: Dữ liệu đơn hàng không tồn tại.', 'msg-error');
                            return;
                        }

                        // Validate form
                        if (!validateForm()) {
                            showMessage('Vui lòng điền đầy đủ thông tin giao hàng.', 'msg-error');
                            return;
                        }

                        const fullName = document.getElementById('fullName').value.trim();
                        const phone = document.getElementById('phone').value.trim();
                        const streetAddress = document.getElementById('streetAddress').value.trim();
                        const notes = document.getElementById('notes').value.trim();

                        // Lấy text của các dropdown đã chọn
                        const citySelect = document.getElementById('city');
                        const districtSelect = document.getElementById('district');
                        const wardSelect = document.getElementById('ward');

                        const cityName = citySelect.options[citySelect.selectedIndex].text;
                        const districtName = districtSelect.options[districtSelect.selectedIndex].text;
                        const wardName = wardSelect.options[wardSelect.selectedIndex].text;

                        // Ghép địa chỉ đầy đủ
                        const shippingAddress = streetAddress + ', ' + wardName + ', ' + districtName + ', ' + cityName;

                        confirmBtn.disabled = true;
                        confirmBtn.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Đang xử lý...';
                        showMessage('Đang tạo đơn hàng...', 'msg-info');

                        // Tạo orderRequest với đầy đủ thông tin
                        var orderRequest = {
                            orderItems: pendingOrderData.orderItems,
                            totalAmount: pendingOrderData.totalAmount,
                            shippingAddress: shippingAddress,
                            fullName: fullName,
                            phone: phone,
                            notes: notes
                        };

                        console.log('Sending orderRequest:', orderRequest);

                        fetch('${pageContext.request.contextPath}/api/orders/create', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            credentials: 'include',
                            body: JSON.stringify(orderRequest)
                        })
                            .then(function (response) {
                                if (response.status === 401 || response.status === 403) {
                                    window.location.href = '${pageContext.request.contextPath}/login';
                                    throw new Error('Chưa đăng nhập hoặc không có quyền.');
                                }
                                if (!response.ok) {
                                    return response.text().then(function (text) {
                                        console.error('Server error response:', text);
                                        throw new Error('Lỗi khi tạo đơn hàng. Mã lỗi: ' + response.status);
                                    });
                                }
                                return response.json();
                            })
                            .then(function (order) {
                                showMessage('Tạo đơn hàng thành công! Mã đơn: ' + order.orderId, 'msg-success');
                                sessionStorage.removeItem('pendingOrder');

                                // Update cart count
                                if (typeof updateGlobalCartCount === 'function') {
                                    updateGlobalCartCount();
                                }

                                setTimeout(function () {
                                    // Use replace instead of href to prevent back button from returning to order_create
                                    window.location.replace('${pageContext.request.contextPath}/order/' + order.orderId);
                                }, 1500);
                            })
                            .catch(function (error) {
                                console.error('Error:', error);
                                showMessage('Lỗi khi tạo đơn hàng: ' + error.message, 'msg-error');
                                confirmBtn.disabled = false;
                                confirmBtn.innerHTML = '<i class="fa fa-check-circle"></i> Xác nhận và Tạo đơn hàng';
                            });
                    }

                    function validateForm() {
                        var isValid = true;

                        // Clear previous errors
                        document.querySelectorAll('.error-message').forEach(function (el) {
                            el.textContent = '';
                        });
                        document.querySelectorAll('.form-input').forEach(function (el) {
                            el.classList.remove('error');
                        });

                        // Validate fullName
                        const fullName = document.getElementById('fullName').value.trim();
                        if (!fullName) {
                            document.getElementById('fullNameError').textContent = 'Vui lòng nhập họ và tên';
                            document.getElementById('fullName').classList.add('error');
                            isValid = false;
                        } else if (fullName.length < 3) {
                            document.getElementById('fullNameError').textContent = 'Họ tên phải có ít nhất 3 ký tự';
                            document.getElementById('fullName').classList.add('error');
                            isValid = false;
                        }

                        // Validate phone
                        const phone = document.getElementById('phone').value.trim();
                        if (!phone) {
                            document.getElementById('phoneError').textContent = 'Vui lòng nhập số điện thoại';
                            document.getElementById('phone').classList.add('error');
                            isValid = false;
                        } else if (!/^[0-9]{10,11}$/.test(phone)) {
                            document.getElementById('phoneError').textContent = 'Số điện thoại không hợp lệ (10-11 số)';
                            document.getElementById('phone').classList.add('error');
                            isValid = false;
                        }

                        // Validate city
                        const city = document.getElementById('city').value;
                        if (!city) {
                            document.getElementById('cityError').textContent = 'Vui lòng chọn Tỉnh/Thành phố';
                            document.getElementById('city').classList.add('error');
                            isValid = false;
                        }

                        // Validate district
                        const district = document.getElementById('district').value;
                        if (!district) {
                            document.getElementById('districtError').textContent = 'Vui lòng chọn Quận/Huyện';
                            document.getElementById('district').classList.add('error');
                            isValid = false;
                        }

                        // Validate ward
                        const ward = document.getElementById('ward').value;
                        if (!ward) {
                            document.getElementById('wardError').textContent = 'Vui lòng chọn Phường/Xã';
                            document.getElementById('ward').classList.add('error');
                            isValid = false;
                        }

                        // Validate street address
                        const streetAddress = document.getElementById('streetAddress').value.trim();
                        if (!streetAddress) {
                            document.getElementById('streetError').textContent = 'Vui lòng nhập số nhà, tên đường';
                            document.getElementById('streetAddress').classList.add('error');
                            isValid = false;
                        } else if (streetAddress.length < 5) {
                            document.getElementById('streetError').textContent = 'Địa chỉ quá ngắn, vui lòng nhập đầy đủ';
                            document.getElementById('streetAddress').classList.add('error');
                            isValid = false;
                        }

                        return isValid;
                    }

                    function showMessage(message, type) {
                        messageContainer.textContent = message;
                        messageContainer.className = type;
                        messageContainer.style.display = 'block';
                    }
                </script>

            </body>

            </html>