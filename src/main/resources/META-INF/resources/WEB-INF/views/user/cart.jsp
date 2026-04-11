<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>Giỏ hàng - CellPhoneStore</title>
      <style>
        .cart-item-card {
          background: white;
          border: 1px solid #e0e0e0;
          border-radius: 8px;
          margin-bottom: 15px;
          padding: 20px;
          transition: box-shadow 0.3s;
        }

        .cart-item-card:hover {
          box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .cart-item-checkbox {
          width: 20px;
          height: 20px;
          cursor: pointer;
        }

        .cart-item-image {
          max-width: 120px;
          max-height: 120px;
          object-fit: contain;
        }

        .quantity-controls {
          display: inline-flex;
          align-items: center;
          border: 1px solid #ddd;
          border-radius: 4px;
          overflow: hidden;
        }

        .quantity-btn {
          width: 35px;
          height: 35px;
          border: none;
          background: #f5f5f5;
          cursor: pointer;
          font-size: 18px;
          transition: background 0.2s;
        }

        .quantity-btn:hover {
          background: #e0e0e0;
        }

        .quantity-input {
          width: 60px;
          height: 35px;
          text-align: center;
          border: none;
          border-left: 1px solid #ddd;
          border-right: 1px solid #ddd;
        }

        .cart-summary-box {
          background: white;
          border: 2px solid #d10024;
          border-radius: 8px;
          padding: 25px;
          position: sticky;
          top: 20px;
        }

        .summary-row {
          display: flex;
          justify-content: space-between;
          margin-bottom: 15px;
          padding-bottom: 15px;
          border-bottom: 1px solid #f0f0f0;
        }

        .summary-row:last-child {
          border-bottom: none;
        }

        .summary-total {
          font-size: 20px;
          font-weight: bold;
          color: #d10024;
          border-top: 2px solid #d10024;
          padding-top: 20px;
          margin-top: 10px;
        }

        .select-all-box {
          background: #fff3cd;
          border: 1px solid #ffc107;
          border-radius: 8px;
          padding: 15px;
          margin-bottom: 20px;
        }

        .empty-cart-box {
          text-align: center;
          padding: 80px 20px;
          background: #f9f9f9;
          border-radius: 8px;
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
                <li>
                  <a href="${pageContext.request.contextPath}/">Trang chủ</a>
                </li>
                <li class="active">Giỏ hàng</li>
              </ul>
            </div>
          </div>
        </div>
      </div>
      <!-- /BREADCRUMB -->

      <!-- SECTION -->
      <div class="section">
        <div class="container">
          <div class="row">
            <div class="col-md-12">
              <div class="section-title">
                <h3 class="title">
                  <i class="fa fa-shopping-cart"></i> Giỏ hàng của bạn
                </h3>
              </div>
            </div>
          </div>

          <!-- Message Container -->
          <div id="messageContainer"></div>

          <div class="row">
            <!-- Cart Items Column -->
            <div class="col-md-8">
              <!-- Select All Box -->
              <div id="selectAllContainer" class="select-all-box" style="display: none">
                <div style="
                  display: flex;
                  justify-content: space-between;
                  align-items: center;
                ">
                  <label style="
                    margin: 0;
                    cursor: pointer;
                    font-weight: 500;
                    color: #856404;
                  ">
                    <input type="checkbox" id="selectAllCheckbox" class="cart-item-checkbox"
                      style="margin-right: 10px" />
                    Chọn tất cả sản phẩm
                  </label>
                  <button id="btnDeleteAll" class="primary-btn"
                    style="background: #dc3545; padding: 8px 20px; display: none" onclick="deleteAllSelected()">
                    <i class="fa fa-trash"></i> Xóa tất cả
                  </button>
                </div>
              </div>

              <!-- Cart Items -->
              <div id="cartItemsContainer">
                <!-- Items will be loaded here -->
              </div>
            </div>

            <!-- Cart Summary Column -->
            <div class="col-md-4">
              <div class="cart-summary-box" id="cartSummary" style="display: none">
                <h4 style="
                  margin-bottom: 20px;
                  padding-bottom: 15px;
                  border-bottom: 2px solid #d10024;
                ">
                  <i class="fa fa-file-text-o"></i> Thông tin đơn hàng
                </h4>

                <div class="summary-row">
                  <span>Tổng số sản phẩm:</span>
                  <strong id="totalItems">0</strong>
                </div>

                <div class="summary-row">
                  <span>Sản phẩm đã chọn:</span>
                  <strong id="selectedCount">0</strong>
                </div>

                <div class="summary-row summary-total">
                  <span>Tổng cộng:</span>
                  <span id="totalPrice">0 ₫</span>
                </div>

                <button class="primary-btn" style="
                  width: 100%;
                  margin-top: 20px;
                  padding: 15px;
                  font-size: 16px;
                " id="btnCheckout" onclick="proceedToOrder()">
                  <i class="fa fa-check"></i> Mua hàng (<span id="checkoutCount">0</span>)
                </button>

                <p style="
                  margin-top: 15px;
                  font-size: 13px;
                  color: #666;
                  text-align: center;
                ">
                  <i class="fa fa-info-circle"></i> Bạn sẽ điền thông tin giao
                  hàng ở bước tiếp theo
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- /SECTION -->

      <script>
        let cart = [];

        function loadCart() {
          fetch("${pageContext.request.contextPath}/api/cart", {
            method: "GET",
            credentials: "include",
          })
            .then(function (response) {
              if (!response.ok) {
                if (response.status === 401 || response.status === 403) {
                  window.location.href =
                    "${pageContext.request.contextPath}/login";
                  throw new Error("Chưa đăng nhập");
                }
                throw new Error("Không thể tải giỏ hàng");
              }
              return response.json();
            })
            .then(function (data) {
              cart = (data.items || []).map(function (item) {
                return {
                  id: item.cartItemId,
                  productId: item.productId,
                  name: item.productName,
                  price: item.productPrice,
                  quantity: item.quantity,
                  imageUrl: item.productImageUrl,
                  stock: item.productStock || 0, // Lấy stock từ API
                  onDeal: item.productOnDeal || false, // Lấy onDeal
                  dealPercentage: item.productDealPercentage || 0, // Lấy dealPercentage
                  isActive:
                    typeof item.productIsActive !== "undefined"
                      ? item.productIsActive
                      : true, // Lấy trạng thái hoạt động
                  selected: false,
                };
              });
              renderCart();
            })
            .catch(function (error) {
              console.error("Error:", error);
              if (!error.message.includes("Chua dang nhap")) {
                showMessage("Loi khi tai gio hang: " + error.message, "error");
              }
            });
        }

        function renderCart() {
          var container = document.getElementById("cartItemsContainer");
          var selectAllContainer = document.getElementById("selectAllContainer");
          var summaryDiv = document.getElementById("cartSummary");

          if (cart.length === 0) {
            container.innerHTML =
              '<div class="empty-cart-box">' +
              '<i class="fa fa-shopping-cart" style="font-size: 80px; color: #ddd; margin-bottom: 20px;"></i>' +
              '<h3 style="color: #666; margin-bottom: 10px;">Giỏ hàng trống</h3>' +
              '<p style="color: #999; margin-bottom: 30px;">Hãy thêm sản phẩm vào giỏ hàng để tiếp tục!</p>' +
              '<a href="${pageContext.request.contextPath}/shop" class="primary-btn">Khám phá sản phẩm</a>' +
              "</div>";
            selectAllContainer.style.display = "none";
            summaryDiv.style.display = "none";
            return;
          }

          selectAllContainer.style.display = "block";
          summaryDiv.style.display = "block";

          var html = "";
          cart.forEach(function (item) {
            var imgSrc =
              item.imageUrl && item.imageUrl.trim() !== ""
                ? "${pageContext.request.contextPath}" + item.imageUrl
                : "${pageContext.request.contextPath}/images/no-image.png";

            html +=
              '<div class="cart-item-card">' +
              '<div class="row">' +
              '<div class="col-md-1 col-xs-2" style="display: flex; align-items: center;">' +
              '<input type="checkbox" class="cart-item-checkbox" id="item-' +
              item.id +
              '" ' +
              (item.selected ? "checked" : "") +
              ' onchange="toggleSelection(' +
              item.id +
              ')">' +
              "</div>" +
              '<div class="col-md-2 col-xs-4">' +
              '<img src="' +
              imgSrc +
              '" alt="' +
              item.name +
              '" class="cart-item-image img-responsive">' +
              "</div>" +
              '<div class="col-md-6 col-xs-12">' +
              '<h4 style="margin-top: 0; margin-bottom: 10px;">' +
              '<a href="${pageContext.request.contextPath}/product/' +
              item.productId +
              '" style="color: #333;">' +
              item.name +
              "</a>" +
              "</h4>" +
              (function () {
                if (item.onDeal && item.dealPercentage > 0) {
                  var discountedPrice =
                    (item.price * (100 - item.dealPercentage)) / 100;
                  var savedAmount = item.price - discountedPrice;
                  return (
                    '<div style="margin-bottom: 15px;">' +
                    '<span style="font-size: 18px; color: #D10024; font-weight: bold;">' +
                    formatPrice(discountedPrice) +
                    "</span> " +
                    '<span style="font-size: 14px; color: #999; text-decoration: line-through;">' +
                    formatPrice(item.price) +
                    "</span> " +
                    '<span style="display: inline-block; background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%); color: white; padding: 2px 8px; border-radius: 3px; font-size: 12px; font-weight: bold; margin-left: 5px;">-' +
                    item.dealPercentage +
                    "%</span> " +
                    '<span style="display: inline-block; background: linear-gradient(135deg, #26d97f 0%, #1abc9c 100%); color: white; padding: 2px 8px; border-radius: 3px; font-size: 12px; font-weight: bold; margin-left: 5px;">Tiết kiệm ' +
                    formatPrice(savedAmount) +
                    "</span>" +
                    "</div>"
                  );
                } else {
                  return (
                    '<p style="font-size: 18px; color: #D10024; font-weight: bold; margin-bottom: 15px;">' +
                    formatPrice(item.price) +
                    "</p>"
                  );
                }
              })() +
              '<div class="quantity-controls">' +
              '<button class="quantity-btn" onclick="updateQuantity(' +
              item.id +
              ', -1)">−</button>' +
              '<input type="number" class="quantity-input" value="' +
              item.quantity +
              '" ' +
              'min="1" max="' +
              item.stock +
              '" id="qty-' +
              item.id +
              '" ' +
              'onchange="setQuantity(' +
              item.id +
              ', this.value)">' +
              '<button class="quantity-btn" onclick="updateQuantity(' +
              item.id +
              ', 1)">+</button>' +
              "</div>" +
              '<p style="margin-top: 10px; color: #666;">Thành tiền: <strong>' +
              formatPrice(
                (item.onDeal && item.dealPercentage > 0
                  ? (item.price * (100 - item.dealPercentage)) / 100
                  : item.price) * item.quantity
              ) +
              "</strong></p>" +
              "</div>" +
              '<div class="col-md-3 col-xs-12" style="text-align: right; display: flex; flex-direction: column; justify-content: center;">' +
              '<button class="primary-btn" style="background: #dc3545; margin-bottom: 0;" onclick="removeItem(' +
              item.id +
              ')">' +
              '<i class="fa fa-trash"></i> Xóa' +
              "</button>" +
              "</div>" +
              "</div>" +
              "</div>";
          });

          container.innerHTML = html;
          updateSummary();
        }

        function toggleSelection(itemId) {
          var item = cart.find(function (i) {
            return i.id === itemId;
          });
          if (item) {
            item.selected = !item.selected;
            updateSummary();
            updateSelectAllCheckbox();
          }
        }

        document.addEventListener("DOMContentLoaded", function () {
          var selectAllCheckbox = document.getElementById("selectAllCheckbox");
          if (selectAllCheckbox) {
            selectAllCheckbox.addEventListener("change", function () {
              var isChecked = this.checked;
              cart.forEach(function (item) {
                item.selected = isChecked;
                var checkbox = document.getElementById("item-" + item.id);
                if (checkbox) checkbox.checked = isChecked;
              });
              updateSummary();
            });
          }

          loadCart();
        });

        function updateSelectAllCheckbox() {
          var selectAllCheckbox = document.getElementById("selectAllCheckbox");
          if (selectAllCheckbox && cart.length > 0) {
            var allSelected = cart.every(function (item) {
              return item.selected;
            });
            selectAllCheckbox.checked = allSelected;
          }
        }

        function updateSummary() {
          var selectedItems = cart.filter(function (item) {
            return item.selected;
          });

          // Tổng số sản phẩm = tổng quantity của tất cả item
          var totalItems = cart.reduce(function (sum, item) {
            return sum + item.quantity;
          }, 0);

          // Sản phẩm đã chọn = tổng quantity của các item được chọn
          var selectedCount = selectedItems.reduce(function (sum, item) {
            return sum + item.quantity;
          }, 0);

          // Tổng tiền = tổng (price * quantity) của item được chọn, sử dụng giá khuyến mãi nếu có
          var subtotal = selectedItems.reduce(function (sum, item) {
            var itemPrice =
              item.onDeal && item.dealPercentage > 0
                ? (item.price * (100 - item.dealPercentage)) / 100
                : item.price;
            return sum + itemPrice * item.quantity;
          }, 0);

          document.getElementById("totalItems").textContent = totalItems;
          document.getElementById("selectedCount").textContent = selectedCount;
          document.getElementById("totalPrice").textContent =
            formatPrice(subtotal);
          document.getElementById("checkoutCount").textContent = selectedCount;

          var btnCheckout = document.getElementById("btnCheckout");
          btnCheckout.disabled = selectedCount === 0;
          if (selectedCount === 0) {
            btnCheckout.style.background = "#ccc";
            btnCheckout.style.cursor = "not-allowed";
          } else {
            btnCheckout.style.background = "#D10024";
            btnCheckout.style.cursor = "pointer";
          }

          // Show/hide delete all button based on selection
          var btnDeleteAll = document.getElementById("btnDeleteAll");
          if (btnDeleteAll) {
            btnDeleteAll.style.display =
              selectedItems.length > 0 ? "inline-block" : "none";
          }
        }

        function updateQuantity(itemId, delta) {
          var item = cart.find(function (i) {
            return i.id === itemId;
          });
          if (!item) return;

          var newQty = item.quantity + delta;
          if (newQty < 1 || newQty > item.stock) {
            if (newQty > item.stock) {
              showMessage(
                'Sản phẩm "' +
                item.name +
                '" chỉ còn ' +
                item.stock +
                " trong kho!",
                "error"
              );
            }
            return;
          }

          updateCartItem(itemId, newQty);
        }

        function setQuantity(itemId, value) {
          var item = cart.find(function (i) {
            return i.id === itemId;
          });
          if (!item) return;

          var newQty = parseInt(value);
          if (isNaN(newQty) || newQty < 1) {
            newQty = 1;
          } else if (newQty > item.stock) {
            newQty = item.stock;
            showMessage(
              'Sản phẩm "' +
              item.name +
              '" chỉ còn ' +
              item.stock +
              " trong kho!",
              "error"
            );
          }

          document.getElementById("qty-" + itemId).value = newQty;
          updateCartItem(itemId, newQty);
        }

        function updateCartItem(itemId, quantity) {
          fetch("${pageContext.request.contextPath}/api/cart/update/" + itemId, {
            method: "PUT",
            headers: {
              "Content-Type": "application/json",
            },
            credentials: "include",
            body: JSON.stringify({ quantity: quantity }),
          })
            .then(function (response) {
              if (!response.ok) throw new Error("Không thể cập nhật");
              return response.json();
            })
            .then(function () {
              var item = cart.find(function (i) {
                return i.id === itemId;
              });
              if (item) {
                item.quantity = quantity;
                renderCart();
                // Update global cart count
                if (typeof updateGlobalCartCount === "function") {
                  updateGlobalCartCount();
                }
              }
            })
            .catch(function (error) {
              console.error("Error:", error);
              showMessage("Loi khi cap nhat so luong", "error");
              loadCart();
            });
        }

        function removeItem(itemId) {
          // Tìm item trong cart để lấy productId
          var item = cart.find(function (i) {
            return i.id === itemId;
          });
          if (!item) {
            showMessage("Không tìm thấy sản phẩm", "error");
            return;
          }

          fetch(
            "${pageContext.request.contextPath}/api/cart/remove/" +
            item.productId,
            {
              method: "DELETE",
              credentials: "include",
              headers: {
                "Content-Type": "application/json",
              },
            }
          )
            .then(function (response) {
              if (!response.ok) throw new Error("Không thể xóa");
              return response.json();
            })
            .then(function (data) {
              showMessage("Đã xóa sản phẩm khỏi giỏ hàng", "success");
              // Update global cart count
              if (typeof updateGlobalCartCount === "function") {
                updateGlobalCartCount();
              }
              loadCart(); // Reload lại giỏ hàng
            })
            .catch(function (error) {
              console.error("Error:", error);
              showMessage("Lỗi khi xóa sản phẩm: " + error.message, "error");
            });
        }

        function deleteAllSelected() {
          var selectedItems = cart.filter(function (item) {
            return item.selected;
          });

          if (selectedItems.length === 0) {
            showMessage("Vui lòng chọn sản phẩm để xóa", "info");
            return;
          }


          var deletePromises = selectedItems.map(function (item) {
            return fetch(
              "${pageContext.request.contextPath}/api/cart/remove/" +
              item.productId,
              {
                method: "DELETE",
                credentials: "include",
                headers: {
                  "Content-Type": "application/json",
                },
              }
            );
          });

          Promise.all(deletePromises)
            .then(function (responses) {
              var allSuccess = responses.every(function (response) {
                return response.ok;
              });
              if (allSuccess) {
                showMessage(
                  "Đã xóa " + selectedItems.length + " sản phẩm khỏi giỏ hàng",
                  "success"
                );
                // Update global cart count
                if (typeof updateGlobalCartCount === "function") {
                  updateGlobalCartCount();
                }
                loadCart();
              } else {
                throw new Error("Không thể xóa một số sản phẩm");
              }
            })
            .catch(function (error) {
              console.error("Error:", error);
              showMessage("Lỗi khi xóa sản phẩm: " + error.message, "error");
              loadCart(); // Reload để cập nhật trạng thái
            });
        }

        // HÀM NÀY NẰM Ở TRANG GIỎ HÀNG (CART)
        function proceedToOrder() {
          var selectedItems = cart.filter(function (item) {
            return item.selected;
          });
          console.log("Sản phẩm đã chọn để đặt hàng:", selectedItems);
          if (selectedItems.length === 0) {
            showMessage("Vui lòng chọn ít nhất 1 sản phẩm để tiếp tục", "info");
            return;
          }

          // Kiểm tra trạng thái ngừng kinh doanh và stock cho từng sản phẩm đã chọn
          for (var i = 0; i < selectedItems.length; i++) {
            var item = selectedItems[i];
            if (item.isActive === false) {
              showMessage(
                'Sản phẩm "' +
                item.name +
                '" đã ngừng kinh doanh. Vui lòng xem sản phẩm khác!',
                "error"
              );
              return;
            }
            if (item.quantity > item.stock) {
              showMessage(
                'Sản phẩm "' +
                item.name +
                '" chỉ còn ' +
                item.stock +
                " sản phẩm trong kho. Vui lòng giảm số lượng!",
                "error"
              );
              return;
            }
          }

          // Tạo payload với giá deal
          var orderRequest = {
            totalAmount: selectedItems.reduce(function (sum, item) {
              var itemPrice =
                item.onDeal && item.dealPercentage > 0
                  ? (item.price * (100 - item.dealPercentage)) / 100
                  : item.price;
              return sum + itemPrice * item.quantity;
            }, 0),
            shippingAddress: "",
            orderItems: selectedItems.map(function (item) {
              // Tính giá deal nếu có
              var finalPrice =
                item.onDeal && item.dealPercentage > 0
                  ? (item.price * (100 - item.dealPercentage)) / 100
                  : item.price;

              return {
                productId: item.productId,
                productName: item.name,
                quantity: item.quantity,
                price: finalPrice, // Sử dụng giá sau khi giảm
                originalPrice: item.price, // Giữ lại giá gốc để hiển thị
                onDeal: item.onDeal || false,
                dealPercentage: item.dealPercentage || 0,
              };
            }),
          };

          // Lưu vào session và chuyển trang
          sessionStorage.setItem("pendingOrder", JSON.stringify(orderRequest));
          window.location.href =
            "${pageContext.request.contextPath}/order/create";
        }

        function formatPrice(price) {
          if (!price) return "0 ₫";
          return new Intl.NumberFormat("vi-VN").format(price) + " ₫";
        }

        function showMessage(message, type) {
          var container = document.getElementById("messageContainer");
          var msgDiv = document.createElement("div");
          msgDiv.className =
            "alert alert-" +
            (type === "error"
              ? "danger"
              : type === "success"
                ? "success"
                : "info");
          msgDiv.style.marginBottom = "20px";
          msgDiv.innerHTML =
            '<i class="fa fa-' +
            (type === "error"
              ? "exclamation-circle"
              : type === "success"
                ? "check-circle"
                : "info-circle") +
            '"></i> ' +
            message;

          container.appendChild(msgDiv);

          setTimeout(function () {
            msgDiv.remove();
          }, 5000);
        }
      </script>
    </body>

    </html>