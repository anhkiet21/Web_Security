<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="/css/chat-user.css" />
    <title>Chat Application</title>
  </head>
  <body>
    <div class="chat-container hidden" id="chat-page">
      <div class="users-list" style="display: none">
        <!--///////////-->
        <div class="users-list-container">
          <h2>Admin</h2>
          <ul id="connectedUsers"></ul>
        </div>
        <div>
          <p id="connected-user-fullname"></p>
          <a class="logout" href="javascript:void(0)" id="logout"></a>
        </div>
      </div>

      <div class="chat-area">
        <div class="chat-area" id="chat-messages"></div>
        <div style="margin: 8px 0">
          <label for="recipientDisplay">To:</label>
          <span id="recipientDisplay"></span>
        </div>

        <form id="messageForm" name="messageForm" class="hidden">
          <div class="message-input">
            <input
              autocomplete="off"
              type="text"
              id="message"
              placeholder="Type your message..."
            />
            <input type="file" id="fileInput" accept="image/*,video/*" />
            <button>Send</button>
          </div>
        </form>
      </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <script src="/js/chat-user.js"></script>

    <script>
      // Hiển thị khung chat khi trang đã tải xong
      document.addEventListener("DOMContentLoaded", function () {
        const chatPage = document.getElementById("chat-page");
        if (chatPage && chatPage.classList.contains("hidden")) {
          setTimeout(function () {
            chatPage.classList.remove("hidden");
          }, 100);
        }
      });

      // Update badge in header when user leaves chat page
      window.addEventListener("beforeunload", function () {
        // Notify parent window/other pages to refresh badge
        if (typeof updateGlobalChatCount === "function") {
          updateGlobalChatCount();
        }
      });

      // Also update when page becomes hidden (user navigates away)
      document.addEventListener("visibilitychange", function () {
        if (document.hidden) {
          // User is leaving the chat page, mark for badge refresh
          sessionStorage.setItem("chatBadgeNeedsRefresh", "true");
        }
      });
    </script>

    <div id="mediaModal" class="hidden media-modal" onclick="closeMediaModal()">
      <div
        class="media-modal-inner"
        id="mediaModalContent"
        onclick="event.stopPropagation()"
      ></div>
    </div>
  </body>
</html>
