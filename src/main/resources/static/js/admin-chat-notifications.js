/**
 * Admin Chat Notifications - Global WebSocket Listener
 * File này load trong tất cả admin pages để nhận thông báo tin nhắn mới
 */

(function () {
  "use strict";

  // Lấy context path từ meta tag hoặc từ pathname
  function getContextPath() {
    const metaTag = document.querySelector('meta[name="context-path"]');
    if (metaTag) {
      return metaTag.getAttribute("content");
    }
    // Fallback: lấy từ pathname (giả sử format là /contextPath/admin/...)
    const path = window.location.pathname;
    const match = path.match(/^(\/[^\/]+)?\/admin/);
    return match ? match[1] || "" : "";
  }

  const ctx = getContextPath();
  let stompClient = null;
  let isConnected = false;

  // Khởi tạo WebSocket connection
  function connectWebSocket() {
    const wsUrl = ctx + "/ws";
    console.log("[Admin Chat Notifications] Connecting to WebSocket:", wsUrl);

    const socket = new SockJS(wsUrl);
    stompClient = Stomp.over(socket);

    // Tắt debug logs
    stompClient.debug = null;

    stompClient.connect(
      {},
      function (frame) {
        isConnected = true;
        console.log("[Admin Chat Notifications] Connected to WebSocket");

        // Lắng nghe tin nhắn mới
        stompClient.subscribe("/user/queue/messages", function (message) {
          const notification = JSON.parse(message.body);
          console.log(
            "[Admin Chat Notifications] New message received:",
            notification
          );

          // Cập nhật badge
          updateChatBadge();

          // Trigger custom event để các trang khác có thể listen
          const event = new CustomEvent("admin-chat-new-message", {
            detail: notification,
          });
          document.dispatchEvent(event);
        });

        // Load initial unread count
        loadUnreadCount();
      },
      function (error) {
        isConnected = false;
        console.error("[Admin Chat Notifications] WebSocket error:", error);
        // Retry after 5 seconds
        setTimeout(connectWebSocket, 5000);
      }
    );
  }

  // Load số lượng tin nhắn chưa đọc
  function loadUnreadCount() {
    const url = ctx + "/admin/api/chat/unread-stats";
    console.log("[Admin Chat Notifications] Loading unread count from:", url);

    fetch(url, {
      credentials: "include",
    })
      .then((response) => {
        console.log(
          "[Admin Chat Notifications] Response status:",
          response.status
        );
        if (!response.ok) {
          throw new Error("HTTP " + response.status);
        }
        return response.json();
      })
      .then((data) => {
        console.log("[Admin Chat Notifications] Unread data:", data);
        updateBadgeUI(data.totalUnread);

        // Store userCounts cho trang chat sử dụng
        sessionStorage.setItem(
          "chatUnreadCounts",
          JSON.stringify(data.userCounts || {})
        );
      })
      .catch((error) => {
        console.error(
          "[Admin Chat Notifications] Error loading unread count:",
          error
        );
      });
  }

  // Cập nhật badge khi có tin nhắn mới
  function updateChatBadge() {
    loadUnreadCount();
  }

  // Cập nhật UI badge
  function updateBadgeUI(count) {
    const badge = document.getElementById("chat-notification-badge");
    if (!badge) {
      console.warn(
        '[Admin Chat Notifications] Badge element not found! Looking for id="chat-notification-badge"'
      );
      return;
    }

    console.log(
      "[Admin Chat Notifications] Updating badge UI with count:",
      count
    );
    if (count > 0) {
      badge.textContent = count > 99 ? "99+" : count;
      badge.style.display = "inline-block";
    } else {
      badge.style.display = "none";
    }
  }

  // Public API
  window.AdminChatNotifications = {
    connect: connectWebSocket,
    updateBadge: updateChatBadge,
    isConnected: function () {
      return isConnected;
    },
  };

  // Auto-connect khi page load
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", connectWebSocket);
  } else {
    connectWebSocket();
  }

  // Refresh badge mỗi 30 giây (fallback nếu WebSocket miss message)
  setInterval(loadUnreadCount, 30000);
})();
