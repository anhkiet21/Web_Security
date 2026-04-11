<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <title>Danh sách tài liệu</title>
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <link rel="stylesheet" href="<c:url value='/css/admin-dashboard.css'/>" />
    <link rel="stylesheet" href="<c:url value='/css/documents_admin.css'/>" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"
    />
  </head>

  <body>
    <!-- app layout with collapsible sidebar -->
    <div class="app-layout">
      <!-- Metismenu-style sidebar -->
      <div class="quixnav sidebar" id="sidebar">
        <div class="quixnav-scroll">
          <button id="navToggle" class="nav-toggle-btn" title="Toggle sidebar">
            ☰
          </button>
          <ul class="metismenu" id="menu">
            <li>
              <a href="${pageContext.request.contextPath}/admin"
                ><i class="icon icon-home"></i
                ><span class="nav-text">Dashboard</span></a
              >
            </li>
            <li>
              <a href="${pageContext.request.contextPath}/admin/users"
                ><i class="fas fa-users"></i
                ><span class="nav-text">Users</span></a
              >
            </li>
            <li>
              <a href="${pageContext.request.contextPath}/admin/products"
                ><i class="fas fa-box"></i
                ><span class="nav-text">Products</span></a
              >
            </li>
            <li>
              <a href="${pageContext.request.contextPath}/admin/categories"
                ><i class="fas fa-tag"></i
                ><span class="nav-text">Categories</span></a
              >
            </li>
            <li class="active">
              <a href="${pageContext.request.contextPath}/admin/document"
                ><i class="fas fa-file-alt"></i
                ><span class="nav-text">Documents</span></a
              >
            </li>
            <li>
              <a
                href="${pageContext.request.contextPath}/admin/chat"
                style="position: relative"
              >
                <i class="fas fa-comments"></i>
                <span class="nav-text">Chat</span>
                <span
                  id="chat-notification-badge"
                  style="
                    display: none;
                    position: absolute;
                    top: 8px;
                    right: 12px;
                    background: #e53935;
                    color: white;
                    border-radius: 50%;
                    padding: 2px 6px;
                    font-size: 10px;
                    min-width: 18px;
                    text-align: center;
                  "
                ></span>
              </a>
            </li>
          </ul>
        </div>
      </div>

      <div class="main-content">
        <div class="container">
          <div class="page-title">
            <h2>Quản lý tài liệu</h2>
            <div>
              <a
                href="${pageContext.request.contextPath}/admin/document/new"
                class="btn btn-primary"
              >
                <i class="fas fa-plus"></i> Thêm tài liệu
              </a>
             
            </div>
          </div>

          <!-- Bộ lọc -->
          <div class="filter-container">
            <div class="filter-group">
              <label>Tiêu đề</label>
              <input
                id="title"
                class="filter-input"
                placeholder="Tìm theo tiêu đề"
                type="text"
                autocomplete="off"
                value="${filterTitle}"
              />
            </div>
            <div class="filter-group">
              <label>Sắp xếp</label>
              <select id="sort" class="filter-input">
                <option value="id,asc" ${filterSort == 'id,asc' ? 'selected' : ''}>ID: Thấp → Cao</option>
                <option value="id,desc" ${filterSort == 'id,desc' ? 'selected' : ''}>ID: Cao → Thấp</option>
                <option value="title,asc" ${filterSort == 'title,asc' ? 'selected' : ''}>Tiêu đề: A → Z</option>
                <option value="title,desc" ${filterSort == 'title,desc' ? 'selected' : ''}>Tiêu đề: Z → A</option>
              </select>
            </div>
            <div class="filter-group" style="justify-content: flex-end;">
              <button id="searchBtn" class="btn btn-primary" style="margin-top: auto;" onclick="applyFilters()">
                <i class="fas fa-search"></i> Tìm kiếm
              </button>
            </div>
          </div>

          <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
          </c:if>
          <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
          </c:if>

          <!-- Debug: Kiểm tra biến null -->
          <c:if test="${empty documents}"><div style="color:red">documents is null</div></c:if>
          <c:if test="${empty products}"><div style="color:red">products is null</div></c:if>
          <div class="card">
            <div class="card-header">
              <div class="card-title">Danh sách tài liệu</div>
            </div>
            <div class="card-body">
              <table>
                <thead>
                  <tr>
                    <th style="width: 60px">ID</th>
                    <th>Tiêu đề</th>
                    <th>Sản phẩm</th>
                    <th style="width: 200px">Thao tác</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="doc" items="${documents.content}">
                    <tr>
                      <td>${doc.id}</td>
                      <td>${doc.title}</td>
                      <td>
                        <c:forEach var="product" items="${products}">
                          <c:if test="${product.id == doc.productId}">
                            ${product.name} (ID: ${doc.productId})
                          </c:if>
                        </c:forEach>
                      </td>
                      <td>
                        <a
                          href="${pageContext.request.contextPath}/admin/document/edit/${doc.id}"
                          class="btn btn-edit"
                          title="Sửa"
                        >
                          <i class="fas fa-edit"></i>
                        </a>
                        <a
                          href="${pageContext.request.contextPath}/admin/document/delete/${doc.id}"
                          class="btn btn-delete"
                         
                          title="Xóa"
                        >
                          <i class="fas fa-trash"></i>
                        </a>
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
              
              <!-- Pagination -->
              <c:set var="page" value="${documents}" scope="request"/>
              <c:set var="additionalParams" value="${filterTitle != null ? '&title='.concat(filterTitle) : ''}${filterSort != null ? '&sort='.concat(filterSort) : ''}" scope="request"/>
              <jsp:include page="/common/pagination.jsp"/>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- WebSocket libraries for chat notifications -->
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1.5.0/dist/sockjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
    <script src="<c:url value='/js/admin-chat-notifications.js'/>"></script>
    
    <script>
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
        const title = document.getElementById('title').value.trim();
        const sort = document.getElementById('sort').value;
        
        const url = new URL(window.location);
        url.searchParams.set('page', '0'); // Reset to first page
        url.searchParams.set('size', url.searchParams.get('size') || '10');
        
        if (title) {
          url.searchParams.set('title', title);
        } else {
          url.searchParams.delete('title');
        }
        
        url.searchParams.set('sort', sort);
        
        window.location.href = url.toString();
      }

      // Show all button
      const showAllBtn = document.getElementById("showAllBtn");
      if (showAllBtn) {
        showAllBtn.addEventListener("click", function () {
          window.location.href = '${pageContext.request.contextPath}/admin/document?page=0&size=10&sort=id,asc';
        });
      }
      
      // Enter key to search
      document.getElementById('title').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
          applyFilters();
        }
      });
    </script>
  </body>
</html>
