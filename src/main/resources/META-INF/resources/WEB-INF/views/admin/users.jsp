<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <html>

        <head>
            <title>Quản lý người dùng</title>
            <meta name="viewport" content="width=device-width,initial-scale=1" />
            <link rel="stylesheet" href="<c:url value='/css/admin-dashboard.css'/>" />
            <link rel="stylesheet" href="<c:url value='/css/users_admin.css'/>" />
            <link rel="stylesheet" href="<c:url value='/css/user_forms.css'/>" />
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
        </head>

        <body>
            <!-- app layout with collapsible sidebar -->
            <div class="app-layout">
                <!-- Metismenu-style sidebar -->
                <div class="quixnav sidebar" id="sidebar">
                    <div class="quixnav-scroll">
                        <button id="navToggle" class="nav-toggle-btn" title="Toggle sidebar">☰</button>
                        <ul class="metismenu" id="menu">
                            <li>
                                <a href="${pageContext.request.contextPath}/admin"><i class="icon icon-home"></i><span
                                        class="nav-text">Dashboard</span></a>
                            </li>
                            <li class="active">
                                <a href="${pageContext.request.contextPath}/admin/users"><i
                                        class="fas fa-users"></i><span class="nav-text">Users</span></a>
                            </li>
                            <li>
                                <a href="${pageContext.request.contextPath}/admin/products"><i
                                        class="fas fa-box"></i><span class="nav-text">Products</span></a>
                            </li>
                            <li>
                                <a href="${pageContext.request.contextPath}/admin/categories"><i
                                        class="fas fa-tag"></i><span class="nav-text">Categories</span></a>
                            </li>
                            <li>
                                <a href="${pageContext.request.contextPath}/admin/document"><i
                                        class="fas fa-file-alt"></i><span class="nav-text">Documents</span></a>
                            </li>
                            <li>
                                <a href="${pageContext.request.contextPath}/admin/chat" style="position: relative;">
                                    <i class="fas fa-comments"></i>
                                    <span class="nav-text">Chat</span>
                                    <span id="chat-notification-badge"
                                        style="display:none; position:absolute; top:8px; right:12px; background:#e53935; color:white; border-radius:50%; padding:2px 6px; font-size:10px; min-width:18px; text-align:center;"></span>
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>

                <div class="main-content">
                    <div class="container">
                        <div class="page-title"
                            style="display: flex; justify-content: space-between; align-items: center;">
                            <h2>Quản lý người dùng</h2>
                            <button type="button" class="btn btn-success" onclick="showCreateForm()"
                                style="height: 38px; display: flex; align-items: center; gap: 8px; padding: 0 15px;">
                                <i class="fas fa-plus"></i> Tạo người dùng mới
                            </button>
                        </div>
                    </div>

                    <!-- Thông báo lỗi/thành công -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger"
                            style="padding: 12px; background: #ffebee; color: #c62828; margin-bottom: 15px; border-radius: 4px;">
                            <i class="fas fa-exclamation-circle"></i> ${error}
                        </div>
                    </c:if>

                    <c:if test="${not empty success}">
                        <div class="alert alert-success"
                            style="padding: 12px; background: #e8f5e9; color: #2e7d32; margin-bottom: 15px; border-radius: 4px;">
                            <i class="fas fa-check-circle"></i> ${success}
                        </div>
                    </c:if>

                    <!-- Form tạo user ẩn -->
                    <div id="createFormDiv"
                        style="display:none; background: white; border: 1px solid #ddd; padding: 20px; margin-bottom: 20px; border-radius: 5px;">
                        <h3 style="margin-top: 0;">Tạo người dùng mới</h3>
                        <form action="${pageContext.request.contextPath}/admin/createUser" method="post"
                            id="createUserForm">
                            <table style="width: 100%; border-collapse: separate; border-spacing: 0 10px;">
                                <tr>
                                    <td style="width: 120px;"><label>Số điện thoại:</label></td>
                                    <td>
                                        <input type="text" id="createPhone" name="phone"
                                            style="width: 100%; padding: 5px;" required pattern="[0-9]{10}"
                                            maxlength="10" placeholder="Nhập 10 chữ số" />
                                        <small style="color: #666; font-size: 12px;">Số điện thoại phải có đúng 10 chữ
                                            số</small>
                                    </td>
                                </tr>
                                <tr>
                                    <td><label>Họ và tên:</label></td>
                                    <td><input type="text" name="fullname" style="width: 100%; padding: 5px;"
                                            required /></td>
                                </tr>
                                <tr>
                                    <td><label>Email:</label></td>
                                    <td>
                                        <input type="email" id="createEmail" name="email"
                                            style="width: 100%; padding: 5px;" required
                                            pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$"
                                            placeholder="example@gmail.com" />
                                        <small style="color: #666; font-size: 12px;">Ví dụ: example@gmail.com</small>
                                    </td>
                                </tr>
                                <tr>
                                    <td><label>Vai trò:</label></td>
                                    <td>
                                        <select name="role" style="width: 100%; padding: 5px;" required>
                                            <option value="ADMIN">ADMIN</option>
                                            <option value="USER" selected>USER</option>
                                            <option value="SELLER">SELLER</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="text-align: right; padding-top: 10px;">
                                        <button type="button"
                                            onclick="document.getElementById('createFormDiv').style.display='none'"
                                            style="padding: 6px 12px; background-color: #f0f0f0; border: 1px solid #ddd; margin-right: 10px; cursor: pointer;">Hủy</button>
                                        <button type="submit"
                                            style="padding: 6px 12px; background-color: #4CAF50; color: white; border: none; cursor: pointer;">Tạo
                                            người dùng</button>
                                    </td>
                                </tr>
                            </table>
                        </form>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Danh sách người dùng</h3>
                        </div>
                        <div class="card-body">
                            <!-- Bộ lọc client-side -->
                            <div class="filter-container">
                                <div class="filter-group">
                                    <label>Số điện thoại:</label>
                                    <input type="text" id="filterPhone" class="filter-input" onkeyup="filterTable()">
                                </div>
                                <div class="filter-group">
                                    <label>Họ và tên:</label>
                                    <input type="text" id="filterFullname" class="filter-input" onkeyup="filterTable()">
                                </div>
                                <div class="filter-group">
                                    <label>Email:</label>
                                    <input type="text" id="filterEmail" class="filter-input" onkeyup="filterTable()">
                                </div>
                                <div class="filter-group">
                                    <label>Vai trò:</label>
                                    <select id="filterRole" onchange="filterTable()">
                                        <option value="">-- Tất cả --</option>
                                        <option value="ADMIN">ADMIN</option>
                                        <option value="USER">USER</option>
                                        <option value="SELLER">SELLER</option>
                                    </select>
                                </div>
                                <div class="filter-group">
                                    <label>Trạng thái:</label>
                                    <select id="filterActive" onchange="filterTable()">
                                        <option value="">-- Tất cả --</option>
                                        <option value="true">Đang hoạt động</option>
                                        <option value="false">Ngưng hoạt động</option>
                                    </select>
                                </div>
                            </div>

                            <table id="usersTable" style="width: 100%; border-collapse: collapse;">
                                <thead>
                                    <tr>
                                        <th
                                            style="padding: 8px; border-bottom: 1px solid #ddd; background-color: #f5f5f5;">
                                            ID</th>
                                        <th
                                            style="padding: 8px; border-bottom: 1px solid #ddd; background-color: #f5f5f5;">
                                            Avatar</th>
                                        <th
                                            style="padding: 8px; border-bottom: 1px solid #ddd; background-color: #f5f5f5;">
                                            Số điện thoại</th>
                                        <th
                                            style="padding: 8px; border-bottom: 1px solid #ddd; background-color: #f5f5f5;">
                                            Họ và tên</th>
                                        <th
                                            style="padding: 8px; border-bottom: 1px solid #ddd; background-color: #f5f5f5;">
                                            Email</th>
                                        <th
                                            style="padding: 8px; border-bottom: 1px solid #ddd; background-color: #f5f5f5;">
                                            Địa chỉ</th>
                                        <th
                                            style="padding: 8px; border-bottom: 1px solid #ddd; background-color: #f5f5f5;">
                                            Vai trò</th>
                                        <th
                                            style="padding: 8px; border-bottom: 1px solid #ddd; background-color: #f5f5f5;">
                                            Trạng thái</th>
                                        <th
                                            style="padding: 8px; border-bottom: 1px solid #ddd; background-color: #f5f5f5;">
                                            Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="user" items="${users.content}">
                                        <tr>
                                            <td>${user.id}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty user.avatarUrl}">
                                                        <img src="${pageContext.request.contextPath}${user.avatarUrl}"
                                                            class="avatar" alt="${user.fullname}" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div
                                                            style="width: 40px; height: 40px; border-radius: 50%; background: #e0e0e0; display: flex; align-items: center; justify-content: center; color: #757575;">
                                                            <i class="fas fa-user"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${user.phone}</td>
                                            <td><strong>${user.fullname}</strong></td>
                                            <td>${user.email}</td>
                                            <td>${user.address}</td>
                                            <td>
                                                <span
                                                    class="badge ${user.role == 'ADMIN' ? 'badge-danger' : 'badge-success'}">${user.role}</span>
                                            </td>
                                            <td>
                                                <span class="badge ${user.isActive ? 'badge-success' : 'badge-danger'}">
                                                    ${user.isActive ? 'Đang hoạt động' : 'Ngưng hoạt động'}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <button type="button" onclick="showEditForm('${user.id}')"
                                                        class="btn action-btn btn-edit">
                                                        <i class="fas fa-edit"></i> Sửa
                                                    </button>
                                                    <!-- <form action="${pageContext.request.contextPath}/admin/deleteUser/${user.id}" method="post"
                                        style="display:inline;">
                                        <button type="submit" class="btn action-btn btn-delete">
                                            <i class="fas fa-trash"></i> Xóa
                                        </button>
                                    </form> -->
                                                </div>
                                            </td>
                                        </tr>

                                        <!-- Form ẩn sửa user -->
                                        <tr id="editFormRow-${user.id}" class="edit-form-row" style="display:none;">
                                            <td colspan="9">
                                                <form
                                                    action="${pageContext.request.contextPath}/admin/updateUser/${user.id}"
                                                    method="post" class="editUserForm">
                                                    <table
                                                        style="width: 100%; border-collapse: separate; border-spacing: 0 10px;">
                                                        <tr>
                                                            <td style="width: 120px;"><label>Họ và tên:</label></td>
                                                            <td><input type="text" name="fullname"
                                                                    value="${user.fullname}"
                                                                    style="width: 100%; padding: 5px;" required /></td>
                                                        </tr>
                                                        <tr>
                                                            <td><label>Email:</label></td>
                                                            <td>
                                                                <input type="email" name="email" value="${user.email}"
                                                                    style="width: 100%; padding: 5px;" required
                                                                    pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$"
                                                                    placeholder="example@gmail.com" class="editEmail" />
                                                                <small style="color: #666; font-size: 12px;">Ví dụ:
                                                                    example@gmail.com</small>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td><label>Địa chỉ:</label></td>
                                                            <td><input type="text" name="address"
                                                                    value="${user.address}"
                                                                    style="width: 100%; padding: 5px;" /></td>
                                                        </tr>
                                                        <tr>
                                                            <td><label>Vai trò:</label></td>
                                                            <td>
                                                                <select name="role" style="width: 100%; padding: 5px;"
                                                                    required>
                                                                    <option value="ADMIN" ${user.role=='ADMIN'
                                                                        ? 'selected' : '' }>ADMIN</option>
                                                                    <option value="USER" ${user.role=='USER'
                                                                        ? 'selected' : '' }>USER</option>
                                                                    <option value="SELLER" ${user.role=='SELLER'
                                                                        ? 'selected' : '' }>SELLER</option>
                                                                </select>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td><label>Trạng thái:</label></td>
                                                            <td>
                                                                <select name="isActive"
                                                                    style="width: 100%; padding: 5px;" required>
                                                                    <option value="true" ${user.isActive ? 'selected'
                                                                        : '' }>Đang hoạt động</option>
                                                                    <option value="false" ${!user.isActive ? 'selected'
                                                                        : '' }>Ngưng hoạt động</option>
                                                                </select>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2"
                                                                style="text-align: right; padding-top: 10px;">
                                                                <button type="button"
                                                                    onclick="hideEditForm('${user.id}')"
                                                                    class="btn btn-outline"
                                                                    style="margin-right: 10px;">Hủy</button>
                                                                <button type="submit" class="btn btn-success">Lưu thay
                                                                    đổi</button>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>

                            <!-- Pagination -->
                            <c:set var="page" value="${users}" scope="request" />
                            <c:set var="additionalParams"
                                value="${filterPhone != null ? '&phone='.concat(filterPhone) : ''}${filterFullname != null ? '&fullname='.concat(filterFullname) : ''}${filterEmail != null ? '&email='.concat(filterEmail) : ''}${filterRole != null ? '&role='.concat(filterRole) : ''}${filterActive != null ? '&active='.concat(filterActive) : ''}"
                                scope="request" />
                            <jsp:include page="/common/pagination.jsp" />
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
                function filterTable() {
                    // Get filter values
                    let phone = document.getElementById('filterPhone').value.toLowerCase();
                    let fullname = document.getElementById('filterFullname').value.toLowerCase();
                    let email = document.getElementById('filterEmail').value.toLowerCase();
                    let role = document.getElementById('filterRole').value;
                    let active = document.getElementById('filterActive').value;

                    // Create URL with current search params
                    const url = new URL(window.location);

                    // Preserve pagination parameters
                    let page = url.searchParams.get('page') || '0';
                    let size = url.searchParams.get('size') || '10';

                    // Add filter parameters
                    if (phone) url.searchParams.set('phone', phone);
                    else url.searchParams.delete('phone');

                    if (fullname) url.searchParams.set('fullname', fullname);
                    else url.searchParams.delete('fullname');

                    if (email) url.searchParams.set('email', email);
                    else url.searchParams.delete('email');

                    if (role) url.searchParams.set('role', role);
                    else url.searchParams.delete('role');

                    if (active) url.searchParams.set('active', active);
                    else url.searchParams.delete('active');

                    // Preserve page size
                    url.searchParams.set('size', size);

                    // Reset to first page when filtering
                    url.searchParams.set('page', '0');

                    // Redirect to apply server-side filtering
                    window.location.href = url.toString();
                }

                // Mở form tạo mới
                function showCreateForm() {
                    document.getElementById('createFormDiv').style.display = 'block';
                }

                // Đóng form tạo mới
                function closeCreateForm() {
                    document.getElementById('createFormDiv').style.display = 'none';
                    document.getElementById('createUserForm').reset();
                }

                function showEditForm(userId) {
                    // Hide all other edit forms first
                    const allEditForms = document.querySelectorAll('.edit-form-row');
                    allEditForms.forEach(form => form.style.display = 'none');

                    // Show this form
                    const editRow = document.getElementById('editFormRow-' + userId);
                    editRow.style.display = '';

                    // Scroll to the form
                    editRow.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }

                function hideEditForm(userId) {
                    document.getElementById('editFormRow-' + userId).style.display = 'none';
                }

                // sidebar toggle: wire toggle button, live toggle and persist state
                (function () {
                    const sidebar = document.getElementById('sidebar');
                    const toggle = document.getElementById('navToggle');
                    if (!sidebar || !toggle) return;

                    function isCollapsed() {
                        return localStorage.getItem('admin_sidebar_collapsed') === '1';
                    }

                    function apply() {
                        const collapsed = isCollapsed();
                        if (window.innerWidth <= 800) {
                            sidebar.classList.toggle('open', collapsed);
                            sidebar.classList.remove('collapsed');
                        } else {
                            sidebar.classList.toggle('collapsed', collapsed);
                            sidebar.classList.remove('open');
                        }
                    }

                    // initial apply
                    apply();

                    // toggle on click
                    toggle.addEventListener('click', function () {
                        const current = isCollapsed();
                        localStorage.setItem('admin_sidebar_collapsed', current ? '0' : '1');
                        apply();
                    });

                    // update on resize
                    window.addEventListener('resize', apply);
                })();

                // Validation cho form tạo user
                document.getElementById('createUserForm').addEventListener('submit', function (e) {
                    const phone = document.getElementById('createPhone').value;
                    const email = document.getElementById('createEmail').value;

                    // Validate số điện thoại (đúng 10 số)
                    const phoneRegex = /^[0-9]{10}$/;
                    if (!phoneRegex.test(phone)) {
                        e.preventDefault();
                        alert('Số điện thoại phải có đúng 10 chữ số!');
                        document.getElementById('createPhone').focus();
                        return false;
                    }

                    // Validate email
                    const emailRegex = /^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$/i;
                    if (!emailRegex.test(email)) {
                        e.preventDefault();
                        alert('Email không hợp lệ! Vui lòng nhập đúng định dạng email.');
                        document.getElementById('createEmail').focus();
                        return false;
                    }

                    return true;
                });

                // Chỉ cho phép nhập số vào ô số điện thoại
                document.getElementById('createPhone').addEventListener('input', function (e) {
                    this.value = this.value.replace(/[^0-9]/g, '');
                    if (this.value.length > 10) {
                        this.value = this.value.slice(0, 10);
                    }
                });

                // Chuyển email về chữ thường
                document.getElementById('createEmail').addEventListener('input', function (e) {
                    this.value = this.value.toLowerCase();
                });

                // Validation cho các form sửa user
                document.querySelectorAll('.editUserForm').forEach(form => {
                    form.addEventListener('submit', function (e) {
                        const emailInput = this.querySelector('.editEmail');
                        const email = emailInput.value;

                        // Validate email
                        const emailRegex = /^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$/i;
                        if (!emailRegex.test(email)) {
                            e.preventDefault();
                            alert('Email không hợp lệ! Vui lòng nhập đúng định dạng email.');
                            emailInput.focus();
                            return false;
                        }

                        return true;
                    });
                });

                // Chuyển email về chữ thường trong form sửa
                document.querySelectorAll('.editEmail').forEach(input => {
                    input.addEventListener('input', function (e) {
                        this.value = this.value.toLowerCase();
                    });
                });
            </script>

        </body>

        </html>