<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Danh sách sản phẩm</title>
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <link rel="stylesheet" href="<c:url value='/css/admin-dashboard.css'/>" />
  <link rel="stylesheet" href="<c:url value='/css/products_admin.css'/>" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
  <style>
    table {
      width: 100%;
      border-collapse: collapse;
    }

    table th,
    table td {
      padding: 8px;
      border: 1px solid #ddd;
    }

    .thumb {
      max-width: 70px;
      max-height: 70px;
      object-fit: contain;
    }

    .btn {
      margin-right: 5px;
      display: inline-block;
      padding: 6px 12px;
      text-decoration: none;
      border-radius: 4px;
      border: none;
      cursor: pointer;
      font-size: 14px;
    }

    .btn-view {
      background-color: #17a2b8;
      color: white;
    }

    .btn-edit {
      background-color: #ffc107;
      color: #000;
    }

    .btn-delete {
      background-color: #dc3545;
      color: white;
    }

    .btn-success {
      background-color: #28a745;
      color: white;
    }
    
    .btn-warning {
      background-color: #ffc107;
      color: #000;
    }
    
    .btn-info {
      background-color: #17a2b8;
      color: white;
    }

    /* Deal Modal Styles */
    .deal-modal {
      display: none;
      position: fixed;
      z-index: 10000;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0, 0, 0, 0.5);
      align-items: center;
      justify-content: center;
    }

    .deal-modal-content {
      background: white;
      border-radius: 16px;
      width: 90%;
      max-width: 500px;
      box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
    }

    .deal-modal-header {
      background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
      color: white;
      padding: 20px 25px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-radius: 16px 16px 0 0;
    }

    .deal-modal-header h3 {
      margin: 0;
      font-size: 22px;
      font-weight: 600;
    }

    .deal-modal-close {
      background: none;
      border: none;
      color: white;
      font-size: 32px;
      cursor: pointer;
      line-height: 1;
      padding: 0;
      width: 32px;
      height: 32px;
      transition: opacity 0.2s;
    }

    .deal-modal-close:hover {
      opacity: 0.8;
    }

    .deal-modal-body {
      padding: 30px 25px;
    }

    .percentage-input-group {
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 25px;
      gap: 10px;
    }

    .percentage-input {
      width: 120px;
      font-size: 48px;
      font-weight: bold;
      text-align: center;
      border: 3px solid #28a745;
      border-radius: 12px;
      padding: 15px;
      color: #28a745;
      outline: none;
    }

    .percentage-input:focus {
      border-color: #20c997;
      box-shadow: 0 0 0 4px rgba(40, 167, 69, 0.1);
    }

    .percentage-symbol {
      font-size: 36px;
      font-weight: bold;
      color: #28a745;
    }

    .percentage-presets {
      display: flex;
      gap: 10px;
      justify-content: center;
      margin-bottom: 25px;
      flex-wrap: wrap;
    }

    .preset-btn {
      padding: 10px 20px;
      border: 2px solid #e0e0e0;
      background: white;
      border-radius: 8px;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s;
      color: #666;
    }

    .preset-btn:hover {
      border-color: #28a745;
      color: #28a745;
      background: #f0fff4;
      transform: translateY(-2px);
    }

    .percentage-slider {
      margin-top: 20px;
    }

    .slider-input {
      width: 100%;
      height: 8px;
      border-radius: 4px;
      outline: none;
      -webkit-appearance: none;
      background: linear-gradient(to right, #28a745 0%, #20c997 100%);
      cursor: pointer;
    }

    .slider-input::-webkit-slider-thumb {
      -webkit-appearance: none;
      width: 24px;
      height: 24px;
      border-radius: 50%;
      background: white;
      border: 3px solid #28a745;
      cursor: pointer;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
    }

    .slider-input::-moz-range-thumb {
      width: 24px;
      height: 24px;
      border-radius: 50%;
      background: white;
      border: 3px solid #28a745;
      cursor: pointer;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
    }

    .slider-labels {
      display: flex;
      justify-content: space-between;
      margin-top: 8px;
      font-size: 12px;
      color: #999;
    }

    .deal-modal-footer {
      padding: 20px 25px;
      background: #f8f9fa;
      display: flex;
      gap: 12px;
      justify-content: flex-end;
      border-radius: 0 0 16px 16px;
    }

    .btn-cancel,
    .btn-confirm {
      padding: 12px 30px;
      border: none;
      border-radius: 8px;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s;
    }

    .btn-cancel {
      background: #e0e0e0;
      color: #666;
    }

    .btn-cancel:hover {
      background: #d0d0d0;
    }

    .btn-confirm {
      background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
      color: white;
      box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
    }

    .btn-confirm:hover {
      box-shadow: 0 6px 16px rgba(40, 167, 69, 0.4);
      transform: translateY(-2px);
    }
  </style>
</head>

<body>
  <div class="app-layout">
    <!-- Sidebar -->
    <div class="quixnav sidebar" id="sidebar">
      <div class="quixnav-scroll">
        <button id="navToggle" class="nav-toggle-btn" title="Toggle sidebar">☰</button>
        <ul class="metismenu" id="menu">
          <li>
            <a href="${pageContext.request.contextPath}/admin"><i class="icon icon-home"></i><span class="nav-text">Dashboard</span></a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-users"></i><span class="nav-text">Users</span></a>
          </li>
          <li class="active">
            <a href="${pageContext.request.contextPath}/admin/products"><i class="fas fa-box"></i><span class="nav-text">Products</span></a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/admin/categories"><i class="fas fa-tag"></i><span class="nav-text">Categories</span></a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/admin/document"><i class="fas fa-file-alt"></i><span class="nav-text">Documents</span></a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/admin/chat" style="position: relative;">
              <i class="fas fa-comments"></i>
              <span class="nav-text">Chat</span>
              <span id="chat-notification-badge" style="display:none; position:absolute; top:8px; right:12px; background:#e53935; color:white; border-radius:50%; padding:2px 6px; font-size:10px; min-width:18px; text-align:center;"></span>
            </a>
          </li>
        </ul>
      </div>
    </div>

    <div class="main-content">
      <div class="container">
        <div class="page-title">
          <h2>Quản lý sản phẩm</h2>
          <div>
            <a href="${pageContext.request.contextPath}/admin/products/new" class="btn btn-primary">
              <i class="fas fa-plus"></i> Thêm sản phẩm
            </a>
           
          </div>
        </div>

        <!-- Bộ lọc -->
        <div class="filter-container">
          <div class="filter-group">
            <label>Hãng</label>
            <input id="brand" class="filter-input" placeholder="Tìm theo hãng" type="text" value="${filterBrand}">
          </div>
          <div class="filter-group">
            <label>Tên sản phẩm</label>
            <input id="name" class="filter-input" placeholder="Tìm theo tên" type="text" value="${filterName}">
          </div>
          <div class="filter-group">
            <label>Giá từ</label>
            <input id="minPrice" class="filter-input" placeholder="Giá từ" type="number" value="${filterMinPrice}">
          </div>
          <div class="filter-group">
            <label>Giá đến</label>
            <input id="maxPrice" class="filter-input" placeholder="Giá đến" type="number" value="${filterMaxPrice}">
          </div>
          <div class="filter-group">
            <label>Sắp xếp</label>
            <select id="sort" class="filter-input">
              <option value="id,asc" ${filterSort == 'id,asc' ? 'selected' : ''}>ID: Thấp → Cao</option>
              <option value="id,desc" ${filterSort == 'id,desc' ? 'selected' : ''}>ID: Cao → Thấp</option>
              <option value="price,asc" ${filterSort == 'price,asc' ? 'selected' : ''}>Giá: Thấp → Cao</option>
              <option value="price,desc" ${filterSort == 'price,desc' ? 'selected' : ''}>Giá: Cao → Thấp</option>
            </select>
          </div>
          <div class="filter-group" style="justify-content: flex-end;">
            <button id="searchBtn" class="btn btn-primary" style="margin-top: auto;" onclick="applyFilters()">
              <i class="fas fa-search"></i> Tìm kiếm
            </button>
          </div>
        </div>

        <!-- Bảng sản phẩm -->
        <div class="card">
          <div class="card-header">
            <div class="card-title">Danh sách sản phẩm</div>
          </div>
          <div class="card-body">
            <table class="table table-striped">
              <thead>
                <tr>
                  <th style="width:80px;">Ảnh</th>
                  <th>Tên</th>
                  <th>Hãng</th>
                  <th>Giá</th>
                  <th>Tồn</th>
                  <th style="width:100px;">Trạng thái</th>
                  <th style="width:120px;">Khuyến mãi</th>
                  <th style="width:280px;">Thao tác</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="product" items="${products.content}">
                  <tr>
                    <td class="text-center">
                      <c:choose>
                        <c:when test="${not empty product.images}">
                          <img src="${pageContext.request.contextPath}${product.images[0].url}" class="thumb" alt="${product.name}">
                        </c:when>
                        <c:when test="${not empty product.imageUrls}">
                          <img src="${pageContext.request.contextPath}${product.imageUrls[0]}" class="thumb" alt="${product.name}">
                        </c:when>
                        <c:otherwise>
                          <img src="${pageContext.request.contextPath}${product.imageUrl}" class="thumb" alt="${product.name}">
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>${product.name}</td>
                    <td>${product.brand}</td>
                    <!-- <td class="text-end"><span class="product-price" data-price="${product.price}"></span><span class="product-price">₫</span></td> -->
<td class="text-end price-cell" data-price="${product.price}" data-deal="${product.onDeal}" data-percent="${product.dealPercentage != null ? product.dealPercentage : 0}"></td>
                    <td class="text-center">${product.stock}</td>
                    <td class="text-center">
                      <c:choose>
                        <c:when test="${not empty product.isActive and product.isActive == false}">
                          <span class="badge" style="background-color: #dc3545; color: white; padding: 4px 8px; border-radius: 4px;">
                            Ngừng bán
                          </span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge" style="background-color: #28a745; color: white; padding: 4px 8px; border-radius: 4px;">
                            Đang bán
                          </span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td class="text-center">
                      <c:choose>
                        <c:when test="${product.onDeal}">
                          <span class="badge" style="background-color: #28a745; color: white; padding: 4px 8px; border-radius: 4px;">
                            -${product.dealPercentage}%
                          </span>
                        </c:when>
                        <c:otherwise>
                          <span class="text-muted">Không</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <a href="${pageContext.request.contextPath}/product/${product.id}" class="btn btn-view" title="Xem"><i class="fas fa-eye"></i></a>
                      <a href="${pageContext.request.contextPath}/admin/products/edit/${product.id}" class="btn btn-edit" title="Sửa"><i class="fas fa-edit"></i></a>
                      <button type="button" class="btn btn-success" onclick="openDealModal('${product.id}')" title="Khuyến mãi"><i class="fas fa-percent"></i></button>
                      <c:choose>
                        <c:when test="${not empty product.isActive and product.isActive == false}">
                          <button type="button" class="btn btn-info" onclick="toggleActiveStatus('${product.id}', false)" title="Mở lại kinh doanh">
                            <i class="fas fa-play"></i>
                          </button>
                        </c:when>
                        <c:otherwise>
                          <button type="button" class="btn btn-warning" onclick="toggleActiveStatus('${product.id}', true)" title="Ngừng kinh doanh">
                            <i class="fas fa-pause"></i>
                          </button>
                        </c:otherwise>
                      </c:choose>
                      <!-- <form action="${pageContext.request.contextPath}/admin/products/${product.id}/delete" method="post" style="display:inline;" >
                        <button type="submit" class="btn btn-delete" title="Xóa"><i class="fas fa-trash"></i></button>
                      </form> -->
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
            
            <!-- Pagination -->
            <c:set var="page" value="${products}" scope="request"/>
            <c:set var="additionalParams" value="${filterBrand != null ? '&brand='.concat(filterBrand) : ''}${filterName != null ? '&name='.concat(filterName) : ''}${filterMinPrice != null ? '&minPrice='.concat(filterMinPrice) : ''}${filterMaxPrice != null ? '&maxPrice='.concat(filterMaxPrice) : ''}${filterSort != null ? '&sort='.concat(filterSort) : ''}" scope="request"/>
            <jsp:include page="/common/pagination.jsp"/>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Deal Percentage Modal -->
  <div id="dealModal" class="deal-modal" style="display: none;">
    <div class="deal-modal-content">
      <div class="deal-modal-header">
        <h3>⚡ Thiết lập khuyến mãi</h3>
        <button class="deal-modal-close" onclick="closeDealModal()">&times;</button>
      </div>
      <div class="deal-modal-body">
        <p style="margin-bottom: 20px; color: #666;">Nhập phần trăm giảm giá cho sản phẩm này:</p>
        <div class="percentage-input-group">
          <input type="number" id="dealPercentageInput" min="0" max="100" value="10" class="percentage-input"
            oninput="document.getElementById('dealPercentageSlider').value = this.value" />
          <span class="percentage-symbol">%</span>
        </div>
        <div class="percentage-presets">
          <button onclick="setPercentage(10)" class="preset-btn">10%</button>
          <button onclick="setPercentage(20)" class="preset-btn">20%</button>
          <button onclick="setPercentage(30)" class="preset-btn">30%</button>
          <button onclick="setPercentage(50)" class="preset-btn">50%</button>
        </div>
        <div class="percentage-slider">
          <input type="range" id="dealPercentageSlider" min="0" max="100" value="10"
            oninput="document.getElementById('dealPercentageInput').value = this.value" class="slider-input" />
          <div class="slider-labels">
            <span>0%</span>
            <span>50%</span>
            <span>100%</span>
          </div>
        </div>
      </div>
      <div class="deal-modal-footer">
        <button onclick="closeDealModal()" class="btn-cancel">Hủy</button>
        <button onclick="confirmDeal()" class="btn-confirm">✓ Xác nhận</button>
      </div>
    </div>
  </div>

  <!-- WebSocket libraries for chat notifications -->
  <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1.5.0/dist/sockjs.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
  <script src="<c:url value='/js/admin-chat-notifications.js'/>"></script>

  <script>
    // Deal Modal functions
    let currentProductId = null;

    function openDealModal(productId) {
      currentProductId = productId;
      document.getElementById('dealModal').style.display = 'flex';
      document.getElementById('dealPercentageInput').value = 10;
      document.getElementById('dealPercentageSlider').value = 10;
    }

    function closeDealModal() {
      document.getElementById('dealModal').style.display = 'none';
      currentProductId = null;
    }

    function setPercentage(value) {
      document.getElementById('dealPercentageInput').value = value;
      document.getElementById('dealPercentageSlider').value = value;
    }

    function confirmDeal() {
      const percentage = document.getElementById('dealPercentageInput').value;
      
      if (!currentProductId) {
        alert('Lỗi: Không tìm thấy sản phẩm!');
        return;
      }

      if (percentage < 0 || percentage > 100) {
        alert('Vui lòng nhập phần trăm từ 0 đến 100!');
        return;
      }

      // Gửi request đến server để cập nhật deal percentage
      fetch('${pageContext.request.contextPath}/admin/products/' + currentProductId + '/deal-toggle', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          onDeal: percentage > 0,
          dealPercentage: parseInt(percentage)
        })
      })
      .then(response => {
        if (response.ok) {
         
          closeDealModal();
          window.location.reload();
        } else {
          alert('Lỗi khi thiết lập khuyến mãi!');
        }
      })
      .catch(error => {
        console.error('Error:', error);
        alert('Lỗi khi thiết lập khuyến mãi!');
      });
    }

    // Toggle Active Status
    function toggleActiveStatus(productId, currentStatus) {
      const action = currentStatus ? 'ngừng kinh doanh' : 'mở lại kinh doanh';
      const newStatus = !currentStatus;
      

      fetch('${pageContext.request.contextPath}/admin/products/' + productId + '/active-toggle', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        }
      })
      .then(response => {
        if (response.ok) {
         
          window.location.reload();
        } else {
          alert('Lỗi khi cập nhật trạng thái sản phẩm!');
        }
      })
      .catch(error => {
        console.error('Error:', error);
        alert('Lỗi khi cập nhật trạng thái sản phẩm!');
      });
    }

    // Close modal when clicking outside
    document.addEventListener('click', function(event) {
      const modal = document.getElementById('dealModal');
      if (event.target === modal) {
        closeDealModal();
      }
    });

    // Toggle sidebar
    const navToggle = document.getElementById("navToggle");
    const sidebar = document.getElementById("sidebar");

    if (navToggle) {
      navToggle.addEventListener("click", function () {
        sidebar.classList.toggle("collapsed");
      });
    }

    // Filter functionality
    function applyFilters() {
      const brand = document.getElementById('brand').value.trim();
      const name = document.getElementById('name').value.trim();
      const minPrice = document.getElementById('minPrice').value.trim();
      const maxPrice = document.getElementById('maxPrice').value.trim();
      const sort = document.getElementById('sort').value;
      
      const url = new URL(window.location);
      url.searchParams.set('page', '0'); // Reset to first page
      url.searchParams.set('size', url.searchParams.get('size') || '10');
      
      if (brand) url.searchParams.set('brand', brand);
      else url.searchParams.delete('brand');
      
      if (name) url.searchParams.set('name', name);
      else url.searchParams.delete('name');
      
      if (minPrice) url.searchParams.set('minPrice', minPrice);
      else url.searchParams.delete('minPrice');
      
      if (maxPrice) url.searchParams.set('maxPrice', maxPrice);
      else url.searchParams.delete('maxPrice');
      
      url.searchParams.set('sort', sort);
      
      window.location.href = url.toString();
    }
    
    // Enter key to search
    ['brand', 'name', 'minPrice', 'maxPrice'].forEach(id => {
      const el = document.getElementById(id);
      if (el) {
        el.addEventListener('keypress', function(e) {
          if (e.key === 'Enter') {
            applyFilters();
          }
        });
      }
    });
  // Format all product prices to 6.437.700 style
document.addEventListener('DOMContentLoaded', function() {
  document.querySelectorAll('.price-cell').forEach(function(cell) {
    var price = parseInt(cell.dataset.price);
    var deal = cell.dataset.deal === 'true';
    var percent = parseInt(cell.dataset.percent) || 0;

    if (deal && percent > 0) {
      var discounted = Math.floor(price * (100 - percent) / 100); // Giá sau giảm
      cell.innerHTML = '<span style="color: #d70018; font-weight: bold;">' + 
                       new Intl.NumberFormat('vi-VN').format(discounted) + 
                       '₫</span> <del style="color: #999;">' + 
                       new Intl.NumberFormat('vi-VN').format(price) + '₫</del>';
    } else {
      cell.innerHTML = '<span style="color: #d70018; font-weight: bold;">' + 
                       new Intl.NumberFormat('vi-VN').format(price) + '₫</span>';
    }
  });
});
  </script>
</body>
</html>
