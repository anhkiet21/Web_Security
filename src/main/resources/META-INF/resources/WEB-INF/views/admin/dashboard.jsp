<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

    <html>

    <head>
      <title>Trang quản trị</title>
      <meta name="viewport" content="width=device-width,initial-scale=1" />
      <link rel="stylesheet" href="<c:url value='/css/admin-dashboard.css'/>" />
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
    </head>

    <body>
      <div class="top-grid">
        <div class="card small">
          <div class="stat-widget-two card-body">
            <div class="stat-content">
              <div>
                <div class="stat-text">Tổng người dùng</div>
                <div class="stat-digit" id="total-users">Đang tải...</div>
              </div>
              <div style="text-align: right; color: var(--muted); font-size: 12px">
                Tổng cộng
              </div>
            </div>
            <div class="progress">
              <span class="progress-bar progress-bar-success" style="width: 100%"></span>
            </div>
          </div>
        </div>

        <div class="card small">
          <div class="stat-widget-two card-body">
            <div class="stat-content">
              <div>
                <div class="stat-text">Tổng sản phẩm</div>
                <div class="stat-digit" id="total-products">Đang tải...</div>
              </div>
              <div style="text-align: right; color: var(--muted); font-size: 12px">
                Tổng cộng
              </div>
            </div>
            <div class="progress">
              <span class="progress-bar progress-bar-primary" style="width: 100%"></span>
            </div>
          </div>
        </div>

        <div class="card small">
          <div class="stat-widget-two card-body">
            <div class="stat-content">
              <div>
                <div class="stat-text">Tổng doanh thu</div>
                <div class="stat-digit" id="total-revenue">Đang tải...</div>
              </div>
              <div style="text-align: right; color: var(--muted); font-size: 12px">
                Tất cả
              </div>
            </div>
            <div class="progress">
              <span class="progress-bar progress-bar-warning" style="width: 100%"></span>
            </div>
          </div>
        </div>

        <div class="card small">
          <div class="stat-widget-two card-body">
            <div class="stat-content">
              <div>
                <div class="stat-text">Đơn hàng</div>
                <div class="stat-digit" id="total-orders">Đang tải...</div>
              </div>
              <div style="text-align: right; color: var(--muted); font-size: 12px">
                Tổng cộng
              </div>
            </div>
            <div class="progress">
              <span class="progress-bar progress-bar-danger" style="width: 100%"></span>
            </div>
          </div>
        </div>
      </div>

      <!-- app layout with collapsible sidebar -->
      <div class="app-layout">
        <!-- Metismenu-style sidebar -->
        <div class="quixnav sidebar" id="sidebar">
          <div class="quixnav-scroll">
            <button id="navToggle" class="nav-toggle-btn" title="Toggle sidebar">
              ☰
            </button>
            <ul class="metismenu" id="menu">
              <li class="active">
                <a href="${pageContext.request.contextPath}/admin"><i class="icon icon-home"></i><span
                    class="nav-text">Dashboard</span></a>
              </li>
              <li>
                <a href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-users"></i><span
                    class="nav-text">Users</span></a>
              </li>
              <li>
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
          <!-- Biểu đồ tròn và biểu đồ người dùng - Ngang hàng, full width -->
          <div class="section">
            <div class="card">
              <div class="controls" style="margin: 8px 0; display: flex; flex-wrap: wrap; gap: 16px">
                <div>
                  <label>Sản phẩm hàng đầu</label>
                  <select id="topLimitSelect">
                    <option value="5">5</option>
                    <option value="10" selected>10</option>
                    <option value="20">20</option>
                  </select>
                  <button id="reloadTopBtn" class="btn">Tải lại</button>
                </div>
                <div style="margin-left: auto">
                  <label>Thống kê người dùng</label>
                  <select id="userTimePeriodSelect">
                    <option value="week" selected>Theo tuần</option>
                    <option value="month">Theo tháng</option>
                    <option value="year">Theo năm</option>
                  </select>

                  <!-- Week Selector -->
                  <span id="userWeekSelector" style="display: inline;">
                    <label>Tuần:</label>
                    <input type="week" id="userWeekInput" />
                  </span>

                  <!-- Month Selector -->
                  <span id="userMonthSelector" style="display: none;">
                    <label>Tháng:</label>
                    <select id="userMonthInput">
                      <option value="1">Tháng 1</option>
                      <option value="2">Tháng 2</option>
                      <option value="3">Tháng 3</option>
                      <option value="4">Tháng 4</option>
                      <option value="5">Tháng 5</option>
                      <option value="6">Tháng 6</option>
                      <option value="7">Tháng 7</option>
                      <option value="8">Tháng 8</option>
                      <option value="9">Tháng 9</option>
                      <option value="10">Tháng 10</option>
                      <option value="11">Tháng 11</option>
                      <option value="12">Tháng 12</option>
                    </select>
                    <select id="userMonthYearInput"></select>
                  </span>

                  <!-- Year Selector -->
                  <span id="userYearSelector" style="display: none;">
                    <label>Năm:</label>
                    <select id="userYearInput"></select>
                  </span>

                  <button id="reloadUsersBtn" class="btn">Tải lại</button>
                  <span style="margin-left: 16px">
                    Tổng cộng: <strong id="usersTotal">0</strong>
                  </span>
                </div>
              </div>
              <div style="display: flex; gap: 20px; margin-top: 8px; flex-wrap: wrap">
                <div style="flex: 1; min-width: 400px; height: 450px">
                  <canvas id="topProductsChart"></canvas>
                </div>
                <div style="flex: 1; min-width: 400px; height: 450px">
                  <canvas id="usersByTimeChart"></canvas>
                </div>
              </div>
            </div>
          </div>

          <!-- Biểu đồ đơn hàng - Full width -->
          <div class="section">
            <div class="card">
              <div class="card-title">Thống kê đơn hàng</div>
              <div class="controls" style="margin: 8px 0">
                <label>Khoảng thời gian:</label>
                <select id="periodSelect">
                  <option value="week" selected>Theo tuần</option>
                  <option value="month">Theo tháng</option>
                  <option value="year">Theo năm</option>
                </select>

                <!-- Week Selector -->
                <span id="weekSelector" style="display: inline;">
                  <label>Tuần:</label>
                  <input type="week" id="weekInput" />
                </span>

                <!-- Month Selector -->
                <span id="monthSelector" style="display: none;">
                  <label>Tháng:</label>
                  <select id="monthInput">
                    <option value="1">Tháng 1</option>
                    <option value="2">Tháng 2</option>
                    <option value="3">Tháng 3</option>
                    <option value="4">Tháng 4</option>
                    <option value="5">Tháng 5</option>
                    <option value="6">Tháng 6</option>
                    <option value="7">Tháng 7</option>
                    <option value="8">Tháng 8</option>
                    <option value="9">Tháng 9</option>
                    <option value="10">Tháng 10</option>
                    <option value="11">Tháng 11</option>
                    <option value="12">Tháng 12</option>
                  </select>
                  <select id="monthYearInput"></select>
                </span>

                <!-- Year Selector -->
                <span id="yearSelector" style="display: none;">
                  <label>Năm:</label>
                  <select id="yearInput"></select>
                </span>

                <button id="reloadBtn" class="btn">Tải lại</button>
                <div style="margin-left: auto">
                  Tổng cộng: <strong id="ordersTotal">0</strong>
                </div>
              </div>
              <div style="background: transparent; padding-top: 6px">
                <canvas id="ordersChart" height="100"></canvas>
              </div>
            </div>
          </div>

          <!-- Biểu đồ doanh thu - Full width -->
          <div class="section">
            <div class="card revenue">
              <div class="card-title">Doanh thu</div>
              <div class="controls" style="margin: 8px 0">
                <select id="revPeriodSelect">
                  <option value="week" selected>Theo tuần</option>
                  <option value="month">Theo tháng</option>
                  <option value="year">Theo năm</option>
                </select>

                <!-- Week Selector -->
                <span id="revWeekSelector" style="display: inline;">
                  <label>Tuần:</label>
                  <input type="week" id="revWeekInput" />
                </span>

                <!-- Month Selector -->
                <span id="revMonthSelector" style="display: none;">
                  <label>Tháng:</label>
                  <select id="revMonthInput">
                    <option value="1">Tháng 1</option>
                    <option value="2">Tháng 2</option>
                    <option value="3">Tháng 3</option>
                    <option value="4">Tháng 4</option>
                    <option value="5">Tháng 5</option>
                    <option value="6">Tháng 6</option>
                    <option value="7">Tháng 7</option>
                    <option value="8">Tháng 8</option>
                    <option value="9">Tháng 9</option>
                    <option value="10">Tháng 10</option>
                    <option value="11">Tháng 11</option>
                    <option value="12">Tháng 12</option>
                  </select>
                  <select id="revMonthYearInput"></select>
                </span>

                <!-- Year Selector -->
                <span id="revYearSelector" style="display: none;">
                  <label>Năm:</label>
                  <select id="revYearInput"></select>
                </span>

                <button id="reloadRevBtn" class="btn">Tải lại</button>
                <div style="margin-left: auto">
                  Tổng doanh thu: <strong id="revTotal">0</strong>
                </div>
              </div>
              <canvas id="revenueChart" height="140"></canvas>
            </div>
          </div>
        </div>
        <!-- /main-content -->
      </div>
      <!-- /app-layout -->

      <!-- WebSocket libraries for chat notifications -->
      <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1.5.0/dist/sockjs.min.js"></script>
      <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
      <script src="<c:url value='/js/admin-chat-notifications.js'/>"></script>

      <!-- Chart.js -->
      <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
      <script>
        // compute theme colors once (read from CSS variables)
        const __cs_theme = getComputedStyle(document.documentElement);
        const THEME = {
          primary: (__cs_theme.getPropertyValue("--primary") || "#1976d2").trim(),
          accent: (__cs_theme.getPropertyValue("--accent") || "#43a047").trim(),
          danger: (__cs_theme.getPropertyValue("--danger") || "#e53935").trim(),
          warning: (__cs_theme.getPropertyValue("--warning") || "#ffb300").trim(),
        };

        const hexToRgba = (hex, alpha) => {
          if (!hex) return null;
          let h = hex.replace("#", "").trim();
          if (h.length === 3)
            h = h
              .split("")
              .map((c) => c + c)
              .join("");
          const r = parseInt(h.slice(0, 2), 16);
          const g = parseInt(h.slice(2, 4), 16);
          const b = parseInt(h.slice(4, 6), 16);
          return `rgba(${r},${g},${b},${alpha})`;
        };

        // Safe fetch functions that work with contextPath

        // Function to load overview stats
        async function loadOverviewStats() {
          try {
            const base = "${pageContext.request.contextPath}";
            const resp = await fetch(base + "/admin/api/stats/overview");
            if (!resp.ok) throw new Error("Failed to load overview stats");
            const data = await resp.json();

            // Update the stat cards with actual data
            document.getElementById("total-users").textContent =
              data.users.toLocaleString();
            document.getElementById("total-products").textContent =
              data.products.toLocaleString();
            document.getElementById("total-revenue").textContent =
              parseFloat(data.totalRevenue).toLocaleString("vi-VN") + "₫";
            document.getElementById("total-orders").textContent =
              data.orders.toLocaleString();
          } catch (e) {
            console.error("Error loading overview stats:", e);
            // Set error message if data couldn't be loaded
            document.getElementById("total-users").textContent = "Error";
            document.getElementById("total-products").textContent = "Error";
            document.getElementById("total-revenue").textContent = "Error";
            document.getElementById("total-orders").textContent = "Error";
          }
        }

        // Initialize charts and stats
        (async function () {
          try {
            // Initialize year dropdowns and week inputs
            initializeDateSelectors();

            // load overview stats
            await loadOverviewStats();

            // load orders chart default
            await loadOrdersChart("week");
            // load revenue chart default - using same period as orders
            await loadRevenueChart("week");
            // load top products
            await loadTopProducts(
              document.getElementById("topLimitSelect").value
            );
            // load users by time chart
            await loadUsersByTimeChart("week");
          } catch (e) {
            console.error(e);
          }
        })();

        // Function to initialize date selectors (year dropdowns and week inputs)
        function initializeDateSelectors() {
          const currentYear = new Date().getFullYear();
          const currentMonth = new Date().getMonth() + 1;
          const startYear = 2020; // Starting year for data

          // Initialize year dropdowns
          const yearSelectors = ['yearInput', 'revYearInput', 'userYearInput'];
          yearSelectors.forEach(id => {
            const select = document.getElementById(id);
            for (let year = currentYear; year >= startYear; year--) {
              const option = document.createElement('option');
              option.value = year;
              option.textContent = year;
              if (year === currentYear) option.selected = true;
              select.appendChild(option);
            }
          });

          // Initialize month year dropdowns
          const monthYearSelectors = ['monthYearInput', 'revMonthYearInput', 'userMonthYearInput'];
          monthYearSelectors.forEach(id => {
            const select = document.getElementById(id);
            for (let year = currentYear; year >= startYear; year--) {
              const option = document.createElement('option');
              option.value = year;
              option.textContent = 'Năm ' + year;
              if (year === currentYear) option.selected = true;
              select.appendChild(option);
            }
          });

          // Set current week for week inputs
          const weekInputs = ['weekInput', 'revWeekInput', 'userWeekInput'];
          const currentWeek = getCurrentWeek();
          weekInputs.forEach(id => {
            document.getElementById(id).value = currentWeek;
          });

          // Set current month for month inputs
          const monthInputs = ['monthInput', 'revMonthInput', 'userMonthInput'];
          monthInputs.forEach(id => {
            document.getElementById(id).value = currentMonth;
          });
        }

        // Get current week in YYYY-Www format
        function getCurrentWeek() {
          const now = new Date();
          const year = now.getFullYear();
          const firstDayOfYear = new Date(year, 0, 1);
          const pastDaysOfYear = (now - firstDayOfYear) / 86400000;
          const weekNumber = Math.ceil((pastDaysOfYear + firstDayOfYear.getDay() + 1) / 7);
          return year + '-W' + String(weekNumber).padStart(2, '0');
        }

        // Toggle selectors for Orders chart
        document.getElementById('periodSelect').addEventListener('change', function () {
          const period = this.value;
          document.getElementById('weekSelector').style.display = period === 'week' ? 'inline' : 'none';
          document.getElementById('monthSelector').style.display = period === 'month' ? 'inline' : 'none';
          document.getElementById('yearSelector').style.display = period === 'year' ? 'inline' : 'none';
        });

        // Toggle selectors for Revenue chart
        document.getElementById('revPeriodSelect').addEventListener('change', function () {
          const period = this.value;
          document.getElementById('revWeekSelector').style.display = period === 'week' ? 'inline' : 'none';
          document.getElementById('revMonthSelector').style.display = period === 'month' ? 'inline' : 'none';
          document.getElementById('revYearSelector').style.display = period === 'year' ? 'inline' : 'none';
        });

        // Toggle selectors for Users chart
        document.getElementById('userTimePeriodSelect').addEventListener('change', function () {
          const period = this.value;
          document.getElementById('userWeekSelector').style.display = period === 'week' ? 'inline' : 'none';
          document.getElementById('userMonthSelector').style.display = period === 'month' ? 'inline' : 'none';
          document.getElementById('userYearSelector').style.display = period === 'year' ? 'inline' : 'none';
        });

        async function fetchOrders(period) {
          const base = "${pageContext.request.contextPath}";
          let url = base + "/admin/api/stats/orders?period=" + period;

          // Add specific time parameters
          if (period === 'week') {
            const weekValue = document.getElementById('weekInput').value;
            if (weekValue) {
              url += '&week=' + encodeURIComponent(weekValue);
            }
          } else if (period === 'month') {
            const month = document.getElementById('monthInput').value;
            const year = document.getElementById('monthYearInput').value;
            url += '&month=' + month + '&year=' + year;
          } else if (period === 'year') {
            const year = document.getElementById('yearInput').value;
            url += '&year=' + year;
          }

          const resp = await fetch(url);
          if (!resp.ok) throw new Error("Failed to load orders stats");
          return resp.json();
        }

        let ordersChart = null;
        async function loadOrdersChart(period) {
          try {
            const data = await fetchOrders(period);
            const labels = Object.keys(data);
            const values = Object.values(data);
            const ctx = document.getElementById("ordersChart").getContext("2d");
            if (ordersChart) ordersChart.destroy();
            ordersChart = new Chart(ctx, {
              type: "line",
              data: {
                labels: labels,
                datasets: [
                  {
                    label: "Đơn hàng",
                    data: values,
                    fill: true,
                    backgroundColor: "rgba(67,160,71,0.08)",
                    borderColor: "#43a047",
                  },
                ],
              },
              options: {
                scales: {
                  y: {
                    beginAtZero: true,
                    title: {
                      display: true,
                      text: "Số lượng đơn hàng",
                    },
                  },
                  x: {
                    title: {
                      display: true,
                      text: period === "week" ? "Ngày" : period === "month" ? "Tháng" : "Năm",
                    },
                  },
                },
              },
            });
            // update total
            const total = values.reduce((acc, v) => acc + Number(v), 0);
            document.getElementById("ordersTotal").innerText = total;
          } catch (e) {
            console.error(e);
          }
        }

        document
          .getElementById("reloadBtn")
          .addEventListener("click", function () {
            const p = document.getElementById("periodSelect").value;
            loadOrdersChart(p);
          });

        // Export CSV functionality removed

        // Revenue
        async function fetchRevenue(period) {
          const base = "${pageContext.request.contextPath}";
          let url = base + "/admin/api/stats/revenue?period=" + period;

          // Add specific time parameters
          if (period === 'week') {
            const weekValue = document.getElementById('revWeekInput').value;
            if (weekValue) {
              url += '&week=' + encodeURIComponent(weekValue);
            }
          } else if (period === 'month') {
            const month = document.getElementById('revMonthInput').value;
            const year = document.getElementById('revMonthYearInput').value;
            url += '&month=' + month + '&year=' + year;
          } else if (period === 'year') {
            const year = document.getElementById('revYearInput').value;
            url += '&year=' + year;
          }

          const resp = await fetch(url);
          if (!resp.ok) throw new Error("Failed to load revenue stats");
          return resp.json();
        }

        let revenueChart = null;
        async function loadRevenueChart(period) {
          try {
            const data = await fetchRevenue(period);
            const labels = Object.keys(data);
            const values = Object.values(data).map((v) => Number(v));
            const ctx = document.getElementById("revenueChart").getContext("2d");
            if (revenueChart) revenueChart.destroy();
            revenueChart = new Chart(ctx, {
              type: "line",
              data: {
                labels,
                datasets: [
                  {
                    label: "Doanh thu",
                    data: values,
                    borderColor: "#43a047",
                    backgroundColor: "rgba(67,160,71,0.08)",
                    fill: true,
                  },
                ],
              },
              options: {
                scales: {
                  y: {
                    beginAtZero: true,
                    title: {
                      display: true,
                      text: "Doanh thu (VNĐ)",
                    },
                  },
                  x: {
                    title: {
                      display: true,
                      text: period === "week" ? "Ngày" : period === "month" ? "Tháng" : "Năm",
                    },
                  },
                },
              },
            });
            const total = values.reduce((a, b) => a + b, 0);
            document.getElementById("revTotal").innerText =
              total.toLocaleString("vi-VN") + "₫";
          } catch (e) {
            console.error(e);
          }
        }

        document
          .getElementById("reloadRevBtn")
          .addEventListener("click", function () {
            const p = document.getElementById("revPeriodSelect").value;
            loadRevenueChart(p);
          });

        // Export CSV functionality removed

        // Top products
        async function fetchTopProducts(limit) {
          const base = "${pageContext.request.contextPath}";
          const resp = await fetch(
            base + "/admin/api/stats/top-products?limit=" + limit
          );
          if (!resp.ok) throw new Error("Failed to load top products");
          return resp.json();
        }

        let topChart = null;
        async function loadTopProducts(limit) {
          try {
            const data = await fetchTopProducts(limit);
            const labels = data.map((d) => d.name);
            const values = data.map((d) => d.sold);
            const ctx = document
              .getElementById("topProductsChart")
              .getContext("2d");

            // Generate an array of colors for the pie slices
            const generateColors = (count) => {
              const baseColors = [
                "#4285F4",
                "#EA4335",
                "#FBBC05",
                "#34A853", // Google colors
                "#3b82f6",
                "#ec4899",
                "#8b5cf6",
                "#10b981",
                "#f97316", // Additional vibrant colors
                "#6366f1",
                "#14b8a6",
                "#ef4444",
                "#f59e0b",
                "#84cc16", // More colors if needed
              ];

              // If we need more colors than our base list, we'll create variations
              if (count <= baseColors.length) {
                return baseColors.slice(0, count);
              } else {
                const result = [...baseColors];
                for (let i = baseColors.length; i < count; i++) {
                  // Generate some variations of the base colors
                  const baseIndex = i % baseColors.length;
                  const opacity = 0.6 + (i / count) * 0.4; // Vary opacity between 0.6-1.0
                  result.push(
                    hexToRgba(baseColors[baseIndex], opacity) ||
                    baseColors[baseIndex]
                  );
                }
                return result;
              }
            };

            // Calculate total for percentages
            const totalSold = values.reduce((acc, val) => acc + val, 0);

            // Create labels with percentage
            const labelsWithPercentage = labels.map(function (label, i) {
              const percentage = ((values[i] / totalSold) * 100).toFixed(1);
              return label + ' (' + percentage + '%)';
            });

            if (topChart) topChart.destroy();
            topChart = new Chart(ctx, {
              type: "pie",
              data: {
                labels: labelsWithPercentage,
                datasets: [
                  {
                    data: values,
                    backgroundColor: generateColors(values.length),
                    borderWidth: 2,
                    borderColor: "#ffffff",
                  },
                ],
              },
              options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: {
                  legend: {
                    position: "right",
                    labels: {
                      font: {
                        size: 12,
                      },
                      padding: 10,
                      boxWidth: 15,
                      usePointStyle: false,
                    },
                  },
                  tooltip: {
                    callbacks: {
                      label: function (context) {
                        const value = context.raw || 0;
                        const percentage = ((value / totalSold) * 100).toFixed(1);
                        // Get original label without percentage
                        const originalLabel = labels[context.dataIndex];
                        return originalLabel + ': ' + value + ' sp (' + percentage + '%)';
                      },
                    },
                  },
                  title: {
                    display: true,
                    text: 'Top Sản Phẩm Bán Chạy',
                    font: {
                      size: 15,
                      weight: 'bold'
                    },
                  },
                  // Plugin to display percentage on chart
                  datalabels: false, // Disable if using chartjs-plugin-datalabels
                },
              },
              plugins: [{
                id: 'percentageLabels',
                afterDatasetsDraw: function (chart) {
                  const ctx = chart.ctx;
                  chart.data.datasets.forEach((dataset, datasetIndex) => {
                    const meta = chart.getDatasetMeta(datasetIndex);
                    if (!meta.hidden) {
                      meta.data.forEach((element, index) => {
                        const data = dataset.data[index];
                        const total = dataset.data.reduce((acc, val) => acc + val, 0);
                        const percentage = ((data / total) * 100).toFixed(1);

                        // Only show percentage if > 5% to avoid cluttering
                        if (parseFloat(percentage) > 5) {
                          ctx.fillStyle = '#fff';
                          ctx.font = 'bold 12px Arial';
                          ctx.textAlign = 'center';
                          ctx.textBaseline = 'middle';

                          const position = element.tooltipPosition();
                          ctx.fillText(percentage + '%', position.x, position.y);
                        }
                      });
                    }
                  });
                }
              }]
            });
          } catch (e) {
            console.error(e);
          }
        }

        document
          .getElementById("reloadTopBtn")
          .addEventListener("click", function () {
            const lim = document.getElementById("topLimitSelect").value;
            loadTopProducts(lim);
          });

        // Export CSV functionality removed

        // Users by time chart functions
        async function fetchUsersByTime(period) {
          const base = "${pageContext.request.contextPath}";
          let url = base + "/admin/api/stats/users-by-time?period=" + period;

          // Add specific time parameters
          if (period === 'week') {
            const weekValue = document.getElementById('userWeekInput').value;
            if (weekValue) {
              url += '&week=' + encodeURIComponent(weekValue);
            }
          } else if (period === 'month') {
            const month = document.getElementById('userMonthInput').value;
            const year = document.getElementById('userMonthYearInput').value;
            url += '&month=' + month + '&year=' + year;
          } else if (period === 'year') {
            const year = document.getElementById('userYearInput').value;
            url += '&year=' + year;
          }

          const resp = await fetch(url);
          if (!resp.ok) throw new Error("Failed to load user stats");
          return resp.json();
        }

        // Add event listener for user period selector
        document
          .getElementById("userTimePeriodSelect")
          .addEventListener("change", function () {
            const period = this.value;
            loadUsersByTimeChart(period);
          });

        document
          .getElementById("reloadUsersBtn")
          .addEventListener("click", function () {
            const period = document.getElementById("userTimePeriodSelect").value;
            loadUsersByTimeChart(period);
          });

        let usersByTimeChart = null;
        async function loadUsersByTimeChart(period = "week") {
          try {
            // Use the real API endpoint to get user data
            const data = await fetchUsersByTime(period);

            const labels = Object.keys(data);
            const values = Object.values(data);

            const ctx = document
              .getElementById("usersByTimeChart")
              .getContext("2d");
            if (usersByTimeChart) usersByTimeChart.destroy();

            usersByTimeChart = new Chart(ctx, {
              type: "line",
              data: {
                labels,
                datasets: [
                  {
                    label: "Đăng ký người dùng",
                    data: values,
                    fill: true,
                    borderColor: "#43a047",
                    backgroundColor: "rgba(67,160,71,0.08)",
                    tension: 0.1,
                    pointRadius: 3,
                    pointHoverRadius: 5,
                  },
                ],
              },
              options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                  y: {
                    beginAtZero: true,
                    ticks: {
                      stepSize: 1,
                    },
                    title: {
                      display: true,
                      text: "Số lượng đăng ký",
                    },
                  },
                  x: {
                    title: {
                      display: true,
                      text: period === "week" ? "Ngày" : period === "month" ? "Tháng" : "Năm",
                    },
                  },
                },
                plugins: {
                  title: {
                    display: true,
                    text: "Đăng ký người dùng",
                    font: {
                      size: 16,
                    },
                  },
                  tooltip: {
                    callbacks: {
                      label: function (context) {
                        return `Người dùng đã đăng ký: ${context.raw}`;
                      },
                    },
                  },
                },
              },
            });

            // Tính và hiển thị tổng số người dùng đăng ký
            const total = values.reduce((acc, v) => acc + Number(v), 0);
            document.getElementById("usersTotal").innerText = total;
          } catch (e) {
            console.error("Error loading users chart:", e);
          }
        }

        // No sample charts needed anymore

        // ensure main-content closes if layout inserted
        (function ensureLayoutClose() {
          const main = document.querySelector(".main-content");
          if (!main) return; // nothing to do
        })();

        // metismenu-like submenu toggles
        (function () {
          const menu = document.getElementById("menu");
          if (!menu) return;
          menu.querySelectorAll(".has-arrow").forEach((btn) => {
            btn.addEventListener("click", function (e) {
              e.preventDefault();
              const li = btn.parentElement;
              const sub = li.querySelector("ul");
              const expanded = btn.getAttribute("aria-expanded") === "true";
              // close other open siblings
              li.parentElement
                .querySelectorAll(":scope > li")
                .forEach((sibling) => {
                  if (sibling !== li) {
                    const a = sibling.querySelector(".has-arrow");
                    if (a) {
                      a.setAttribute("aria-expanded", "false");
                      const u = sibling.querySelector("ul");
                      if (u) u.style.display = "none";
                    }
                  }
                });
              // toggle this one
              if (sub) {
                btn.setAttribute("aria-expanded", expanded ? "false" : "true");
                sub.style.display = expanded ? "none" : "block";
              }
            });
            // initially hide nested uls
            const sib = btn.parentElement.querySelector("ul");
            if (sib) sib.style.display = "none";
          });
        })();

        // sidebar toggle: wire toggle button, live toggle and persist state
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

          // initial apply
          apply();

          // toggle on click
          toggle.addEventListener("click", function () {
            const current = isCollapsed();
            localStorage.setItem("admin_sidebar_collapsed", current ? "0" : "1");
            apply();
          });

          // update on resize
          window.addEventListener("resize", apply);
        })();
      </script>
    </body>

    </html>