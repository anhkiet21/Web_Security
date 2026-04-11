<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>${document != null ? "Chỉnh sửa tài liệu" : "Tạo tài liệu mới"}</title>
            <meta name="viewport" content="width=device-width,initial-scale=1" />
            <link rel="stylesheet" href="<c:url value='/css/admin-dashboard.css'/>" />
            <link rel="stylesheet" href="<c:url value='/css/documents_admin.css'/>" />
            <link rel="stylesheet" href="<c:url value='/css/document_form.css'/>" />
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />

            <style>
                .editor-toolbar input[type="color"] {
                    width: 40px;
                    height: 28px;
                    padding: 2px;
                    vertical-align: middle;
                    border: 1px solid #ccc;
                    border-radius: 4px;
                    margin-bottom: 5px;
                }

                .btn {
                    padding: 8px 16px;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                    display: inline-flex;
                    align-items: center;
                    gap: 6px;
                    font-size: 14px;
                    font-weight: 500;
                    text-decoration: none;
                    transition: all 0.2s;
                }

                .btn-save {
                    background-color: #43a047;
                    color: white;
                }

                .btn-save:hover {
                    background-color: #388e3c;
                    transform: translateY(-1px);
                    box-shadow: 0 2px 8px rgba(67, 160, 71, 0.3);
                }

                .btn-cancel {
                    background-color: #e53935;
                    color: white;
                }

                .btn-cancel:hover {
                    background-color: #d32f2f;
                    transform: translateY(-1px);
                    box-shadow: 0 2px 8px rgba(229, 57, 53, 0.3);
                }

                .img-preview img {
                    max-width: 150px;
                    max-height: 150px;
                    margin: 5px;
                    border-radius: 4px;
                    object-fit: cover;
                }

                .img-wrapper,
                .table-wrapper {
                    display: block;
                    position: relative;
                    max-width: 100%;
                    margin: 15px auto;
                    overflow: auto;
                }

                .img-wrapper img {
                    display: block;
                    width: 100%;
                    max-width: 100%;
                }

                .table-wrapper {
                    overflow-x: auto;
                }

                .table-wrapper table {
                    width: 100%;
                    border-collapse: collapse;
                    background: white;
                }

                #editor table {
                    border-collapse: collapse;
                    width: 100%;
                    margin: 15px 0;
                    background: white;
                    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                    table-layout: fixed;
                    position: relative;
                }

                #editor table td,
                #editor table th {
                    border: 1px solid #ddd;
                    padding: 10px 12px;
                    text-align: left;
                    vertical-align: top;
                    min-width: 50px;
                    position: relative;
                    overflow: hidden;
                    word-wrap: break-word;
                }

                #editor table th {
                    background-color: #f5f5f5;
                    font-weight: 600;
                    color: #333;
                }

                #editor table tr:hover {
                    background-color: #f9f9f9;
                }

                #editor table th::after,
                #editor table td::after {
                    content: '';
                    position: absolute;
                    top: 0;
                    right: -3px;
                    width: 6px;
                    height: 100%;
                    cursor: col-resize;
                    z-index: 10;
                }

                #editor table th:hover::after,
                #editor table td:hover::after {
                    background: rgba(25, 118, 210, 0.3);
                }

                #editor table th.resizing::after,
                #editor table td.resizing::after {
                    background: #1976d2;
                }

                .img-wrapper:hover,
                .table-wrapper:hover,
                .img-wrapper.resizing,
                .table-wrapper.resizing {
                    outline: 2px dashed #1976d2;
                }

                .resize-handle {
                    position: absolute;
                    bottom: 0;
                    right: 0;
                    width: 16px;
                    height: 16px;
                    background: #1976d2;
                    border: 2px solid white;
                    border-radius: 50%;
                    cursor: nwse-resize;
                    opacity: 0;
                    transition: opacity 0.2s;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    color: white;
                    font-size: 10px;
                }

                .img-wrapper:hover .resize-handle,
                .table-wrapper:hover .resize-handle,
                .img-wrapper.resizing .resize-handle,
                .table-wrapper.resizing .resize-handle {
                    opacity: 1;
                }

                /* === KHUNG NHẬP BẢNG ĐẸP === */
                #tableBoxOverlay {
                    display: none;
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background: rgba(0, 0, 0, 0.4);
                    z-index: 9998;
                    justify-content: center;
                    align-items: center;
                }

                #tableBox {
                    background: white;
                    padding: 25px;
                    border-radius: 12px;
                    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
                    width: 90%;
                    max-width: 340px;
                    text-align: center;
                    font-family: sans-serif;
                    z-index: 9999;
                }

                #tableBox h4 {
                    margin: 0 0 18px;
                    color: #333;
                    font-size: 18px;
                }

                #tableBox input {
                    width: 100%;
                    padding: 11px;
                    margin: 8px 0;
                    border: 1px solid #ccc;
                    border-radius: 8px;
                    font-size: 16px;
                    box-sizing: border-box;
                }

                #tableBox .btn-group {
                    margin-top: 15px;
                    display: flex;
                    gap: 10px;
                    justify-content: center;
                }

                #tableBox button {
                    flex: 1;
                    padding: 10px;
                    border: none;
                    border-radius: 8px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: 0.2s;
                }

                #tableBox .btn-create {
                    background: #28a745;
                    color: white;
                }

                #tableBox .btn-create:hover {
                    background: #218838;
                }

                #tableBox .btn-cancel {
                    background: #dc3545;
                    color: white;
                }

                #tableBox .btn-cancel:hover {
                    background: #c82333;
                }
            </style>
        </head>

        <body>
            <div class="app-layout">
                <div class="quixnav sidebar" id="sidebar">
                    <div class="quixnav-scroll">
                        <button id="navToggle" class="nav-toggle-btn" title="Toggle sidebar">Menu</button>
                        <ul class="metismenu" id="menu">
                            <li><a href="${pageContext.request.contextPath}/admin"><i class="icon icon-home"></i><span
                                        class="nav-text">Dashboard</span></a></li>
                            <li><a href="${pageContext.request.contextPath}/admin/users"><i
                                        class="fas fa-users"></i><span class="nav-text">Users</span></a></li>
                            <li><a href="${pageContext.request.contextPath}/admin/products"><i
                                        class="fas fa-box"></i><span class="nav-text">Products</span></a></li>
                            <li><a href="${pageContext.request.contextPath}/admin/categories"><i
                                        class="fas fa-tag"></i><span class="nav-text">Categories</span></a></li>
                            <li class="active"><a href="${pageContext.request.contextPath}/admin/document"><i
                                        class="fas fa-file-alt"></i><span class="nav-text">Documents</span></a></li>
                            <li><a href="${pageContext.request.contextPath}/admin/chat" style="position: relative;">
                                    <i class="fas fa-comments"></i><span class="nav-text">Chat</span>
                                    <span id="chat-notification-badge"
                                        style="display:none; position:absolute; top:8px; right:12px; background:#e53935; color:white; border-radius:50%; padding:2px 6px; font-size:10px; min-width:18px; text-align:center;"></span>
                                </a></li>
                        </ul>
                    </div>
                </div>

                <div class="main-content">
                    <div class="container">
                        <div class="page-title">
                            <h2>${document != null ? "Chỉnh sửa tài liệu" : "Tạo tài liệu mới"}</h2>
                            <a href="${pageContext.request.contextPath}/admin/document" class="btn btn-outline">
                                <i class="fas fa-arrow-left"></i> Quay lại danh sách
                            </a>
                        </div>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>
                        <c:if test="${not empty success}">
                            <div class="alert alert-success">${success}</div>
                        </c:if>

                        <c:set var="formAction"
                            value="${document != null ? pageContext.request.contextPath.concat('/admin/document/update/').concat(document.id) : pageContext.request.contextPath.concat('/admin/document/create')}" />

                        <form action="${formAction}" method="post" enctype="multipart/form-data"
                            onsubmit="syncEditor()">
                            <div class="form-group">
                                <label>Title:</label>
                                <input type="text" name="title" value="${document != null ? document.title : ''}"
                                    required />
                            </div>
                            <div class="form-group">
                                <label>Product:</label>
                                <select name="productId" required
                                    style="width:100%; padding:10px; border:1px solid #ddd; border-radius:4px;">
                                    <option value="">-- Chọn sản phẩm --</option>
                                    <c:forEach items="${products}" var="product">
                                        <option value="${product.id}" ${document !=null &&
                                            document.productId==product.id ? 'selected' : '' }>
                                            ${product.name} (ID: ${product.id})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="form-group editor-toolbar">
                                <button type="button" onclick="formatDoc('formatBlock', 'p')">P</button>
                                <button type="button" onclick="formatDoc('formatBlock', 'h1')">H1</button>
                                <button type="button" onclick="formatDoc('formatBlock', 'h2')">H2</button>
                                <button type="button" onclick="formatDoc('formatBlock', 'h3')">H3</button>
                                <button type="button" onclick="formatDoc('insertUnorderedList')">UL</button>
                                <button type="button" onclick="formatDoc('insertOrderedList')">OL</button>
                                <button type="button" onclick="insertLink()">Link</button>
                                <button type="button" onclick="triggerImageUpload()">Image</button>
                                <button type="button" onclick="showTableBox()">Table</button>
                                <span style="margin: 0 5px;">|</span>
                                <button type="button" onclick="alignContent('left')" title="Căn trái">Left</button>
                                <button type="button" onclick="alignContent('center')" title="Căn giữa">Center</button>
                                <button type="button" onclick="alignContent('right')" title="Căn phải">Right</button>
                                <button type="button" onclick="formatDoc('justifyFull')"
                                    title="Căn đều">Justify</button>
                                <label for="editorColorPicker">Color:</label>
                                <input type="color" id="editorColorPicker" onchange="formatDoc('foreColor', this.value)"
                                    title="Text Color">
                            </div>

                            <div id="editor" contenteditable="true">
                                <c:if test="${document != null}">
                                    <c:out value="${document.description}" escapeXml="false" />
                                </c:if>
                            </div>

                            <input type="file" id="editorImageInput" accept="image/*" style="display: none;"
                                onchange="uploadImage(this)">
                            <input type="hidden" name="description" id="description">

                            <div class="form-group">
                                <button type="submit" class="btn btn-save">${document != null ? 'Cập nhật' :
                                    'Tạo'}</button>
                                <a href="${pageContext.request.contextPath}/admin/document"
                                    class="btn btn-cancel">Hủy</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- KHUNG NHẬP BẢNG -->
            <div id="tableBoxOverlay" onclick="hideTableBox()">
                <div id="tableBox" onclick="event.stopPropagation()">
                    <h4>Tạo bảng mới</h4>
                    <input type="number" id="tableRows" placeholder="Số hàng" min="1" value="3">
                    <input type="number" id="tableCols" placeholder="Số cột" min="1" value="3">
                    <div class="btn-group">
                        <button class="btn-create" onclick="createTableFromBox()">Tạo</button>
                        <button class="btn-cancel" onclick="hideTableBox()">Hủy</button>
                    </div>
                </div>
            </div>

            <script>
                const editor = document.getElementById('editor');

                // === MỞ / ĐÓNG KHUNG BẢNG ===
                function showTableBox() {
                    document.getElementById('tableBoxOverlay').style.display = 'flex';
                    document.getElementById('tableRows').focus();
                }
                function hideTableBox() {
                    document.getElementById('tableBoxOverlay').style.display = 'none';
                }
                function createTableFromBox() {
                    const rows = parseInt(document.getElementById('tableRows').value);
                    const cols = parseInt(document.getElementById('tableCols').value);
                    if (rows < 1 || cols < 1 || isNaN(rows) || isNaN(cols)) {
                        alert("Vui lòng nhập số hợp lệ!");
                        return;
                    }
                    hideTableBox();
                    insertTable(rows, cols);
                }

                // === TẠO BẢNG ===
                function insertTable(numRows, numCols) {
                    const table = document.createElement('table');
                    table.style.borderCollapse = 'collapse';
                    table.style.width = '100%';
                    table.style.margin = '15px 0';
                    table.style.background = 'white';
                    table.style.boxShadow = '0 1px 3px rgba(0,0,0,0.1)';

                    const tbody = document.createElement('tbody');
                    for (let i = 0; i < numRows; i++) {
                        const tr = document.createElement('tr');
                        for (let j = 0; j < numCols; j++) {
                            const cell = document.createElement(i === 0 ? 'th' : 'td');
                            cell.style.border = '1px solid #ddd';
                            cell.style.padding = '10px 12px';
                            cell.style.textAlign = 'left';
                            cell.style.minWidth = '80px';
                            if (i === 0) {
                                cell.style.backgroundColor = '#f5f5f5';
                                cell.style.fontWeight = '600';
                                cell.innerHTML = `Header ${j + 1}`;
                            } else {
                                cell.innerHTML = '&nbsp;';
                            }
                            tr.appendChild(cell);
                        }
                        tbody.appendChild(tr);
                    }
                    table.appendChild(tbody);

                    const selection = window.getSelection();
                    if (selection.rangeCount > 0) {
                        const range = selection.getRangeAt(0);
                        range.deleteContents();
                        range.insertNode(table);
                        const br = document.createElement('br');
                        table.after(br);
                        range.setStartAfter(br);
                        selection.removeAllRanges();
                        selection.addRange(range);
                    } else {
                        editor.appendChild(table);
                    }

                    setTimeout(() => {
                        if (!table.parentElement.classList.contains('table-wrapper')) makeResizable(table);
                        makeTableColumnsResizable(table);
                    }, 100);
                    editor.focus();
                }

                // === UPLOAD ẢNH – GIỮ NGUYÊN NHƯ CŨ, CHỈ SỬA 1 DÒNG ===
                function uploadImage(input) {
                    if (input.files && input.files[0]) {
                        const file = input.files[0];
                        const formData = new FormData();
                        formData.append('image', file);

                        const uploadUrl = "${pageContext.request.contextPath}/admin/document/upload-image";

                        fetch(uploadUrl, {
                            method: 'POST',
                            body: formData
                        })
                            .then(response => {
                                if (!response.ok) throw new Error('Network error');
                                return response.json();
                            })
                            .then(data => {
                                if (data && data.imageUrl) {
                                    const imageUrl = "${pageContext.request.contextPath}" + data.imageUrl;
                                    const img = document.createElement('img');
                                    img.src = imageUrl;
                                    img.style.maxWidth = '100%';
                                    img.style.height = 'auto';
                                    img.style.display = 'block';
                                    img.style.margin = '15px auto';

                                    const selection = window.getSelection();
                                    if (selection.rangeCount > 0) {
                                        const range = selection.getRangeAt(0);
                                        range.deleteContents();
                                        range.insertNode(img);
                                        range.setStartAfter(img);
                                        selection.removeAllRanges();
                                        selection.addRange(range);
                                    } else {
                                        editor.appendChild(img);
                                    }

                                    setTimeout(() => {
                                        if (!img.parentElement.classList.contains('img-wrapper')) {
                                            makeResizable(img);
                                        }
                                    }, 100);
                                    editor.focus();
                                } else {
                                    throw new Error('No imageUrl in response');
                                }
                            })
                            .catch(error => {
                                console.error('Upload error:', error);
                                alert('Lỗi upload ảnh. Vui lòng thử lại.');
                            });
                        input.value = null;
                    }
                }

                function triggerImageUpload() { document.getElementById('editorImageInput').click(); }

                // === CÁC HÀM CÒN LẠI (giữ nguyên) ===
                function formatDoc(cmd, val = null) { document.execCommand(cmd, false, val); editor.focus(); }
                function insertLink() { const url = prompt("Nhập URL:"); if (url) document.execCommand('createLink', false, url); editor.focus(); }
                function syncEditor() {
                    const clone = editor.cloneNode(true);
                    clone.querySelectorAll('.resize-handle').forEach(h => h.remove());
                    clone.querySelectorAll('.img-wrapper').forEach(w => w.replaceWith(w.querySelector('img')));
                    clone.querySelectorAll('.table-wrapper').forEach(w => w.replaceWith(w.querySelector('table')));
                    document.getElementById('description').value = clone.innerHTML;
                }

                // === RESIZE, COLUMN RESIZE, DELETE (giữ nguyên như cũ) ===
                // ... (toàn bộ code makeResizable, makeTableColumnsResizable, delete, sidebar toggle...)

                // Sidebar toggle
                (function () {
                    const sidebar = document.getElementById('sidebar');
                    const toggle = document.getElementById('navToggle');
                    if (!sidebar || !toggle) return;
                    function isCollapsed() { return localStorage.getItem('admin_sidebar_collapsed') === '1'; }
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
                    apply();
                    toggle.addEventListener('click', () => {
                        localStorage.setItem('admin_sidebar_collapsed', isCollapsed() ? '0' : '1');
                        apply();
                    });
                    window.addEventListener('resize', apply);
                })();
            </script>
        </body>

        </html>