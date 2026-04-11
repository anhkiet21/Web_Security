<%@ page contentType="text/html;charset=UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <!DOCTYPE html>
    <html>

    <head>
      <meta charset="UTF-8" />
      <title>Thêm sản phẩm mới</title>
      <meta name="viewport" content="width=device-width,initial-scale=1" />
      <link rel="stylesheet" href="<c:url value='/css/admin-dashboard.css'/>" />
      <link rel="stylesheet" href="<c:url value='/css/products_admin.css'/>" />
      <link rel="stylesheet" href="<c:url value='/css/product_form.css'/>" />
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
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
                <a href="${pageContext.request.contextPath}/admin"><i class="icon icon-home"></i><span
                    class="nav-text">Dashboard</span></a>
              </li>
              <li>
                <a href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-users"></i><span
                    class="nav-text">Users</span></a>
              </li>
              <li class="active">
                <a href="${pageContext.request.contextPath}/admin/products"><i class="fas fa-box"></i><span
                    class="nav-text">Products</span></a>
              </li>
              <li>
                <a href="${pageContext.request.contextPath}/admin/categories"><i class="fas fa-tag"></i><span
                    class="nav-text">Categories</span></a>
              </li>
              <li>
                <a href="${pageContext.request.contextPath}/admin/document"><i class="fas fa-file-alt"></i><span
                    class="nav-text">Documents</span></a>
              </li>
              <li>
                <a href="${pageContext.request.contextPath}/admin/chat" style="position: relative">
                  <i class="fas fa-comments"></i>
                  <span class="nav-text">Chat</span>
                  <span id="chat-notification-badge" style="
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
                  "></span>
                </a>
              </li>
            </ul>
          </div>
        </div>

        <div class="main-content">
          <div class="container">
            <div class="page-title">
              <h2><i class="fas fa-plus-circle me-2"></i>Thêm sản phẩm mới</h2>
              <div>
                <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline">
                  <i class="fas fa-arrow-left"></i> Quay lại danh sách
                </a>
              </div>
            </div>

            <div class="card">
              <div class="card-header">
                <div class="card-title">Thông tin sản phẩm</div>
              </div>
              <div class="card-body">
                <form id="createForm">
                  <div class="row">
                    <div class="col-md-6">
                      <div class="form-group">
                        <label>Tên sản phẩm*</label>
                        <input name="name" class="form-control" required />
                      </div>
                    </div>

                    <div class="col-md-6">
                      <div class="form-group">
                        <label>Hãng*</label>
                        <select name="brandCategoryId" id="brandCategorySelect" class="form-select" required>
                          <option value="">-- Chọn hãng --</option>
                        </select>
                        <input type="hidden" name="brand" id="brandHidden" value="" />
                      </div>
                    </div>

                    <div class="col-md-4">
                      <div class="form-group">
                        <label>Giá*</label>
                        <input name="price" type="number" step="0.01" class="form-control" required />
                      </div>
                    </div>

                    <div class="col-md-4">
                      <div class="form-group">
                        <label>Tồn kho*</label>
                        <input name="stock" type="number" class="form-control" required />
                      </div>
                    </div>

                    <div class="col-md-4">
                      <div class="form-group">
                        <label>Dòng sản phẩm*</label>
                        <select name="categoryId" id="productSeriesSelect" class="form-select" required disabled>
                          <option value="">-- Chọn hãng trước --</option>
                        </select>
                      </div>
                    </div>

                    <div class="col-md-4">
                      <div class="form-group">
                        <label>Áp dụng khuyến mãi (Deal)</label>
                        <div class="form-check">
                          <input type="checkbox" name="onDeal" id="onDealCheckbox" class="form-check-input" />
                          <label class="form-check-label" for="onDealCheckbox">
                            Sản phẩm đang giảm giá
                          </label>
                        </div>
                      </div>
                    </div>

                    <div class="col-md-4">
                      <div class="form-group">
                        <label>Phần trăm giảm giá (%)</label>
                        <input type="number" name="dealPercentage" class="form-control" min="0" max="100" value="0" />
                      </div>
                    </div>
                  </div>

                  <div class="card mt-4">
                    <div class="card-header">
                      <div class="card-title">Thông số kỹ thuật (tùy chọn)</div>
                    </div>
                    <div class="card-body">
                      <div class="row">
                        <div class="col-md-6">
                          <div class="form-group">
                            <label>Screen size</label>
                            <input name="screenSize" class="form-control" />
                          </div>
                        </div>
                        <div class="col-md-6">
                          <div class="form-group">
                            <label>Display tech</label>
                            <input name="displayTech" class="form-control" />
                          </div>
                        </div>
                        <div class="col-md-6">
                          <div class="form-group">
                            <label>Resolution</label>
                            <input name="resolution" class="form-control" />
                          </div>
                        </div>
                        <div class="col-md-6">
                          <div class="form-group">
                            <label>Display features</label>
                            <input name="displayFeatures" class="form-control" />
                          </div>
                        </div>
                        <div class="col-md-6">
                          <div class="form-group">
                            <label>Rear camera</label>
                            <input name="rearCamera" class="form-control" />
                          </div>
                        </div>
                        <div class="col-md-6">
                          <div class="form-group">
                            <label>Front camera</label>
                            <input name="frontCamera" class="form-control" />
                          </div>
                        </div>
                        <div class="col-md-6">
                          <div class="form-group">
                            <label>Chipset</label>
                            <input name="chipset" class="form-control" />
                          </div>
                        </div>
                        <div class="col-md-6">
                          <div class="form-group">
                            <label>CPU specs</label>
                            <input name="cpuSpecs" class="form-control" />
                          </div>
                        </div>
                        <div class="col-md-6">
                          <div class="form-group">
                            <label>RAM</label>
                            <input name="ram" class="form-control" />
                          </div>
                        </div>
                        <div class="col-md-6">
                          <div class="form-group">
                            <label>Storage</label>
                            <input name="storage" class="form-control" />
                          </div>
                        </div>
                        <div class="col-md-6">
                          <div class="form-group">
                            <label>Battery</label>
                            <input name="battery" class="form-control" />
                          </div>
                        </div>
                        <div class="col-md-6">
                          <div class="form-group">
                            <label>SIM type</label>
                            <input name="simType" class="form-control" />
                          </div>
                        </div>
                        <div class="col-md-6">
                          <div class="form-group">
                            <label>OS</label>
                            <input name="os" class="form-control" />
                          </div>
                        </div>
                        <div class="col-md-6">
                          <div class="form-group">
                            <label>NFC support</label>
                            <input name="nfcSupport" class="form-control" />
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>

                  <div class="card mt-4">
                    <div class="card-header">
                      <div class="card-title">Quản lý hình ảnh</div>
                    </div>
                    <div class="card-body">
                      <div class="form-group">
                        <label>Ảnh sản phẩm (có thể chọn nhiều ảnh)</label>
                        <input type="file" id="imagesInputCreate" name="image" class="form-control" accept="image/*"
                          multiple />
                      </div>

                      <!-- Preview images -->
                      <div class="form-group mt-4">
                        <label>Ảnh đã chọn</label>
                        <div id="previewImages" class="mt-2"></div>
                      </div>
                    </div>
                  </div>

                  <div class="row mt-4">
                    <div class="col-12">
                      <button class="btn btn-primary" type="submit">
                        <i class="fas fa-save"></i> Lưu sản phẩm
                      </button>
                      <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline-secondary"><i
                          class="fas fa-times"></i> Hủy</a>
                    </div>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      </div>

      <script>
        const ctx = "${pageContext.request.contextPath}";

        // Load danh mục cha (Hãng: Apple, Samsung, Xiaomi...)
        (async () => {
          const brandSelect = document.getElementById("brandCategorySelect");
          const seriesSelect = document.getElementById("productSeriesSelect");

          // Load parent categories (Hãng)
          const res = await fetch(ctx + "/api/categories/parents");
          const parentCategories = await res.json();

          parentCategories.forEach((c) => {
            const opt = document.createElement("option");
            opt.value = c.id;
            opt.textContent = c.name;
            brandSelect.append(opt);
          });
        })();

        // Function để load dòng sản phẩm khi chọn hãng
        async function loadProductSeries(parentId) {
          const seriesSelect = document.getElementById("productSeriesSelect");
          const brandSelect = document.getElementById("brandCategorySelect");
          const brandHidden = document.getElementById("brandHidden");

          // Clear old options
          seriesSelect.innerHTML =
            '<option value="">-- Chọn dòng sản phẩm --</option>';

          if (!parentId) {
            seriesSelect.disabled = true;
            return;
          }

          // Load child categories (Dòng sản phẩm)
          const res = await fetch(ctx + "/api/categories/children/" + parentId);
          const childCategories = await res.json();

          childCategories.forEach((c) => {
            const opt = document.createElement("option");
            opt.value = c.id;
            opt.textContent = c.name;
            seriesSelect.append(opt);
          });

          seriesSelect.disabled = false;

          // Update hidden brand field với tên hãng đã chọn
          const selectedBrandOption =
            brandSelect.options[brandSelect.selectedIndex];
          if (selectedBrandOption && selectedBrandOption.value) {
            brandHidden.value = selectedBrandOption.textContent;
          }
        }

        // Event listener cho khi chọn hãng
        document
          .getElementById("brandCategorySelect")
          .addEventListener("change", function () {
            loadProductSeries(this.value);
          });

        // Preview images khi chọn file
        let selectedFiles = [];
        const imageInput = document.getElementById("imagesInputCreate");
        const previewContainer = document.getElementById("previewImages");

        imageInput.addEventListener("change", function (e) {
          const files = Array.from(e.target.files);
          selectedFiles = files;
          renderPreviewImages();
        });

        function renderPreviewImages() {
          previewContainer.innerHTML = "";

          if (selectedFiles.length === 0) {
            previewContainer.innerHTML = '<div class="text-muted">Chưa chọn ảnh nào</div>';
            return;
          }

          const imageGrid = document.createElement("div");
          imageGrid.className = "image-preview";

          selectedFiles.forEach((file, index) => {
            const wrap = document.createElement("div");
            wrap.className = "image-item";

            const img = document.createElement("img");
            img.style.objectFit = "cover";
            img.style.width = "100%";
            img.style.height = "100%";

            // Read file and show preview
            const reader = new FileReader();
            reader.onload = function (e) {
              img.src = e.target.result;
            };
            reader.readAsDataURL(file);

            wrap.appendChild(img);

            // Add delete button
            const del = document.createElement("button");
            del.type = "button";
            del.className = "delete-img";
            del.innerHTML = '<i class="fas fa-trash"></i>';
            del.title = "Xóa ảnh";

            del.addEventListener("click", function (ev) {
              ev.stopPropagation();
              // Remove file from array
              selectedFiles.splice(index, 1);

              // Update file input
              const dt = new DataTransfer();
              selectedFiles.forEach(f => dt.items.add(f));
              imageInput.files = dt.files;

              // Re-render preview
              renderPreviewImages();
            });

            wrap.appendChild(del);
            imageGrid.appendChild(wrap);
          });

          previewContainer.appendChild(imageGrid);
        }

        document
          .getElementById("createForm")
          .addEventListener("submit", async (e) => {
            e.preventDefault();
            const f = e.target;
            const data = {
              name: f.name.value,
              brand: f.brand.value,
              price: parseFloat(f.price.value),
              stock: parseInt(f.stock.value),
              categoryId: parseInt(f.categoryId.value),
              onDeal: f.onDeal?.checked || false,
              dealPercentage: f.onDeal?.checked
                ? parseInt(f.dealPercentage?.value) || 0
                : null,
              // specs fields
              screenSize: f.screenSize?.value || null,
              displayTech: f.displayTech?.value || null,
              resolution: f.resolution?.value || null,
              displayFeatures: f.displayFeatures?.value || null,
              rearCamera: f.rearCamera?.value || null,
              frontCamera: f.frontCamera?.value || null,
              chipset: f.chipset?.value || null,
              cpuSpecs: f.cpuSpecs?.value || null,
              ram: f.ram?.value || null,
              storage: f.storage?.value || null,
              battery: f.battery?.value || null,
              simType: f.simType?.value || null,
              os: f.os?.value || null,
              nfcSupport: f.nfcSupport?.value || null,
            };
            const res = await fetch(ctx + "/api/products", {
              method: "POST",
              headers: { "Content-Type": "application/json" },
              body: JSON.stringify(data),
            });
            if (!res.ok) return alert("Lỗi tạo sản phẩm!");
            const p = await res.json();

            const imgs = document.getElementById("imagesInputCreate").files;
            if (imgs && imgs.length > 0) {
              const fd = new FormData();
              for (let i = 0; i < imgs.length; i++) fd.append("images", imgs[i]);
              await fetch(ctx + "/api/products/" + p.id + "/images", {
                method: "POST",
                body: fd,
              });
            }
            alert("Thêm sản phẩm thành công!");
            location.href = ctx + "/admin/products";
          });
      </script>

      <script>
        // Sidebar toggle
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
    </body>

    </html>