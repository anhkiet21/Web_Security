<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ page
contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <title>Thêm / Sửa danh mục</title>
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <link rel="stylesheet" href="<c:url value='/css/admin-dashboard.css'/>" />
    <link rel="stylesheet" href="<c:url value='/css/categories_admin.css'/>" />
    <link rel="stylesheet" href="<c:url value='/css/category_form.css'/>" />
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
            <li class="active">
              <a href="${pageContext.request.contextPath}/admin/categories"
                ><i class="fas fa-tag"></i
                ><span class="nav-text">Categories</span></a
              >
            </li>
            <li>
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
            <h2><span id="formTitle">Thêm danh mục mới</span></h2>
            <a
              href="${pageContext.request.contextPath}/admin/categories"
              class="btn btn-outline"
            >
              <i class="fas fa-arrow-left"></i> Quay lại
            </a>
          </div>

          <div class="card">
            <div class="card-header">
              <div class="card-title">Thông tin danh mục</div>
            </div>
            <div class="card-body">
              <form id="categoryForm">
                <input type="hidden" id="id" name="id" />

                <div style="margin-bottom: 15px">
                  <label
                    for="name"
                    style="display: block; margin-bottom: 5px; font-weight: 500"
                    >Tên danh mục *</label
                  >
                  <input
                    type="text"
                    id="name"
                    name="name"
                    placeholder="Tên danh mục"
                    required
                    style="
                      width: 100%;
                      padding: 8px 12px;
                      border: 1px solid #ced4da;
                      border-radius: 4px;
                      font-size: 14px;
                    "
                  />
                </div>

                <div style="margin-bottom: 15px">
                  <label
                    for="description"
                    style="display: block; margin-bottom: 5px; font-weight: 500"
                    >Mô tả (không bắt buộc)</label
                  >
                  <textarea
                    id="description"
                    name="description"
                    placeholder="Mô tả chi tiết về danh mục"
                    style="
                      width: 100%;
                      padding: 8px 12px;
                      border: 1px solid #ced4da;
                      border-radius: 4px;
                      font-size: 14px;
                      height: 120px;
                    "
                  ></textarea>
                </div>

                <div style="margin-bottom: 15px">
                  <label
                    for="parentId"
                    style="display: block; margin-bottom: 5px; font-weight: 500"
                    >Danh mục cha (không bắt buộc)</label
                  >
                  <select
                    id="parentId"
                    name="parentId"
                    style="
                      width: 100%;
                      padding: 8px 12px;
                      border: 1px solid #ced4da;
                      border-radius: 4px;
                      font-size: 14px;
                    "
                  >
                    <option value="">-- Không có (Danh mục gốc) --</option>
                  </select>
                </div>

                <div style="margin-top: 20px; display: flex; gap: 10px">
                  <button
                    type="button"
                    class="btn btn-outline"
                    onclick="history.back()"
                  >
                    <i class="fas fa-times"></i> Hủy
                  </button>
                  <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Lưu
                  </button>
                </div>
              </form>
            </div>
          </div>

          <div
            id="status"
            style="
              display: none;
              padding: 12px;
              margin-top: 15px;
              border-radius: 4px;
            "
          ></div>
        </div>
      </div>
    </div>

    <script>
      const ctx = "<%=request.getContextPath()%>";
      const api = ctx + "/api/categories";
      const form = document.getElementById("categoryForm");
      const status = document.getElementById("status");

      // Load all categories for parent dropdown
      function loadCategories() {
        fetch(api)
          .then((r) => (r.ok ? r.json() : []))
          .then((categories) => {
            const parentSelect = document.getElementById("parentId");
            categories.forEach((cat) => {
              const option = document.createElement("option");
              option.value = cat.id;
              option.textContent = cat.name;
              parentSelect.appendChild(option);
            });
          })
          .catch((e) => {
            console.error("Error loading categories:", e);
          });
      }

      // Load categories on page load
      loadCategories();

      // If URL contains /edit/{id} we will fetch existing
      const path = location.pathname;
      const editMatch = path.match(/\/admin\/categories\/edit\/(\d+)/);
      const isEdit = !!editMatch;

      // Update title for edit mode
      if (isEdit) {
        document.getElementById("formTitle").textContent = "Chỉnh sửa danh mục";
        document.title = "Chỉnh sửa danh mục";

        const id = editMatch[1];
        fetch(api + "/" + id)
          .then((r) => {
            if (!r.ok) throw new Error("HTTP " + r.status);
            return r.json();
          })
          .then((c) => {
            document.getElementById("id").value = c.id || "";
            document.getElementById("name").value = c.name || "";
            document.getElementById("description").value = c.description || "";
            if (c.parentId) {
              document.getElementById("parentId").value = c.parentId;
            }
          })
          .catch((e) => {
            console.error(e);
            showError(
              "Không thể tải thông tin danh mục. Vui lòng thử lại sau."
            );
          });
      }

      form.addEventListener("submit", async (ev) => {
        ev.preventDefault();

        const id = document.getElementById("id").value;
        const parentIdValue = document.getElementById("parentId").value;
        const payload = {
          name: document.getElementById("name").value.trim(),
          description: document.getElementById("description").value.trim(),
          parentId: parentIdValue ? parseInt(parentIdValue) : null,
        };

        // Validate
        if (payload.name.length < 2) {
          showError("Tên danh mục phải có ít nhất 2 ký tự");
          return;
        }

        // Prevent setting self as parent
        if (id && payload.parentId && parseInt(id) === payload.parentId) {
          showError("Không thể chọn chính danh mục này làm danh mục cha");
          return;
        }

        try {
          showStatus("Đang lưu...", "info");
          const method = id ? "PUT" : "POST";
          const url = id ? api + "/" + id : api;
          const res = await fetch(url, {
            method,
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(payload),
          });

          if (res.ok) {
            showStatus("Đã lưu thành công!", "success");
            setTimeout(() => (location.href = ctx + "/admin/categories"), 800);
          } else {
            const error = await res.text();
            showError("Lỗi khi lưu: " + error);
          }
        } catch (e) {
          console.error(e);
          showError("Lỗi khi lưu danh mục. Vui lòng thử lại sau.");
        }
      });

      function showStatus(message, type) {
        status.style.display = "block";
        if (type === "info") {
          status.style.backgroundColor = "#d1ecf1";
          status.style.color = "#0c5460";
          status.style.border = "1px solid #bee5eb";
        } else if (type === "success") {
          status.style.backgroundColor = "#d4edda";
          status.style.color = "#155724";
          status.style.border = "1px solid #c3e6cb";
        } else if (type === "error") {
          status.style.backgroundColor = "#f8d7da";
          status.style.color = "#721c24";
          status.style.border = "1px solid #f5c6cb";
        }
        status.innerHTML = '<i class="fas fa-info-circle"></i> ' + message;
      }

      function showError(message) {
        showStatus(message, "error");
      }
    </script>

    <!-- Script để toggle sidebar -->
    <script>
      (function () {
        const sidebar = document.getElementById("sidebar");
        const toggle = document.getElementById("navToggle");
        if (!sidebar || !toggle) return;

        function isCollapsed() {
          return localStorage.getItem("admin_sidebar_collapsed") === "1";
        }

        function apply() {
          const collapsed = isCollapsed();
          if (window.innerWidth <= 800) {
            sidebar.classList.toggle("open", collapsed);
            sidebar.classList.remove("collapsed");
          } else {
            sidebar.classList.toggle("collapsed", collapsed);
            sidebar.classList.remove("open");
          }
        }

        apply();
        toggle.addEventListener("click", function () {
          const current = isCollapsed();
          localStorage.setItem("admin_sidebar_collapsed", current ? "0" : "1");
          apply();
        });
        window.addEventListener("resize", apply);
      })();
    </script>

    <!-- Admin chat notification script -->
    <script src="${pageContext.request.contextPath}/js/admin-chat-notifications.js"></script>
  </body>
</html>
