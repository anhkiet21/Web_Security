"use strict";

const chatPage = document.querySelector("#chat-page");
const messageForm = document.querySelector("#messageForm");
const messageInput = document.querySelector("#message");
const fileInput = document.querySelector("#fileInput");
const chatArea = document.querySelector("#chat-messages");
const logout = document.querySelector("#logout");

let stompClient = null;
let nickname = null;
let fullname = null;
let selectedUserId = null;
let currentRole = "USER";

// ------------------------- Auth & connect -------------------------
async function initAuth() {
  try {
    const resp = await fetch("/api/me");
    if (!resp.ok) return showAuthError();
    const info = await resp.json();
    if (info && info.authenticated) {
      nickname = info.phone || info.email || "user" + info.id;
      fullname = info.fullName || nickname;
      currentRole = (info.role || "USER").toUpperCase();

      if (chatPage) chatPage.classList.remove("hidden");
      const connectedFullname = document.querySelector(
        "#connected-user-fullname"
      );
      if (connectedFullname) connectedFullname.textContent = fullname;

      const socket = new SockJS("/ws");
      stompClient = Stomp.over(socket);
      stompClient.connect({}, onConnected, onError);
      return;
    }
  } catch (err) {
    console.debug("initAuth: /api/me failed", err);
  }
  showAuthError();
}

function showAuthError() {
  // create a small banner to inform the user that authentication is required
  const existing = document.getElementById("auth-error-banner");
  if (existing) return;
  const banner = document.createElement("div");
  banner.id = "auth-error-banner";
  banner.style.background = "#ffdddd";
  banner.style.color = "#800";
  banner.style.padding = "12px";
  banner.style.margin = "8px";
  banner.style.border = "1px solid #f5c2c2";
  banner.textContent = "Authentication failed. Please login to use chat.";
  document.body.insertBefore(banner, document.body.firstChild);
}

function onConnected() {
  stompClient.subscribe(`/user/${nickname}/queue/messages`, onMessageReceived);
  stompClient.subscribe(`/user/public`, onMessageReceived);
  stompClient.send(
    "/app/user.addUser",
    {},
    JSON.stringify({
      nickName: nickname,
      fullName: fullname,
      status: "ONLINE",
      role: currentRole,
    })
  );

  document.querySelector("#connected-user-fullname").textContent = fullname;
  findAndDisplayConnectedUsers().then(() => {
    if (currentRole === "ADMIN") {
      loadAdminConversations().catch((e) =>
        console.debug("loadAdminConversations failed", e)
      );
    }
    if (currentRole !== "ADMIN") {
      const adminElem = Array.from(
        document.querySelectorAll(".user-item")
      ).find((el) => (el.dataset.role || "").toUpperCase() === "ADMIN");
      if (adminElem) adminElem.click();
    }
  });
}

function onError() {
  console.error("Could not connect to WebSocket server.");
}

// ------------------------- Users list -------------------------
async function findAndDisplayConnectedUsers() {
  const connectedUsersResponse = await fetch("/users");
  let connectedUsers = await connectedUsersResponse.json();

  // Load unread counts from sessionStorage (set by admin-chat-notifications.js)
  const unreadCounts = JSON.parse(
    sessionStorage.getItem("chatUnreadCounts") || "{}"
  );

  connectedUsers = connectedUsers.filter((user) => user.nickName !== nickname);

  if (currentRole !== "ADMIN") {
    connectedUsers = connectedUsers.filter(
      (user) => (user.role || "").toUpperCase() === "ADMIN"
    );

    try {
      const adminsResp = await fetch("/users/admins");
      if (adminsResp.ok) {
        const admins = await adminsResp.json();
        admins.forEach((a) => {
          const adminObj = normalizeUserRaw(a);

          if (!connectedUsers.find((u) => u.nickName === adminObj.nickName)) {
            adminObj.status = "OFFLINE";
            connectedUsers.push(adminObj);
          }
        });
      }
    } catch (e) {
      console.debug("Could not fetch /users/admins", e);
    }
  }

  const connectedUsersList = document.getElementById("connectedUsers");
  connectedUsersList.innerHTML = "";

  connectedUsers.forEach((user, idx) => {
    appendUserElement(user, connectedUsersList);
    if (idx < connectedUsers.length - 1) {
      const separator = document.createElement("li");
      separator.classList.add("separator");
      connectedUsersList.appendChild(separator);
    }
  });
}

function appendUserElement(user, connectedUsersList) {
  const listItem = document.createElement("li");
  listItem.classList.add("user-item");
  listItem.id = user.nickName;

  listItem.dataset.role = (user.role || "USER").toUpperCase();

  const userImage = document.createElement("img");
  // use avatarUrl when available, otherwise fall back to default icon
  userImage.src = user.avatarUrl || user.avatar || "../img/user_icon.png";

  userImage.alt = user.fullName + (user.nickName ? ` (${user.nickName})` : "");

  const usernameSpan = document.createElement("span");

  if ((currentRole || "").toUpperCase() === "ADMIN") {
    usernameSpan.textContent = user.fullName || "";

    if (user.nickName && user.nickName !== user.fullName) {
      const phoneSpan = document.createElement("small");
      phoneSpan.classList.add("user-phone");
      phoneSpan.textContent = ` (${user.nickName})`;
      usernameSpan.appendChild(phoneSpan);
    }
  } else {
    usernameSpan.textContent = user.fullName || user.nickName || "";
  }

  const receivedMsgs = document.createElement("span");
  receivedMsgs.textContent = "0";
  receivedMsgs.classList.add("nbr-msg", "hidden");

  // Check unread count from sessionStorage
  const unreadCounts = JSON.parse(
    sessionStorage.getItem("chatUnreadCounts") || "{}"
  );
  const unreadCount = unreadCounts[user.nickName] || 0;
  if (unreadCount > 0) {
    receivedMsgs.textContent = unreadCount;
    receivedMsgs.classList.remove("hidden");
  }

  listItem.appendChild(userImage);
  listItem.appendChild(usernameSpan);
  listItem.appendChild(receivedMsgs);

  listItem.addEventListener("click", userItemClick);

  connectedUsersList.appendChild(listItem);
}

function userItemClick(event) {
  document.querySelectorAll(".user-item").forEach((item) => {
    item.classList.remove("active");
  });
  messageForm.classList.remove("hidden");

  const clickedUser = event.currentTarget;
  clickedUser.classList.add("active");

  selectedUserId = clickedUser.getAttribute("id");

  fetchAndDisplayUserChat().then();

  const nbrMsg = clickedUser.querySelector(".nbr-msg");
  if (nbrMsg) {
    nbrMsg.classList.add("hidden");
    nbrMsg.textContent = "0";
  }

  // Mark all messages from this user as read
  if ((currentRole || "").toUpperCase() === "ADMIN" && selectedUserId) {
    fetch(
      `/admin/api/chat/mark-all-read/${encodeURIComponent(selectedUserId)}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
      }
    )
      .then((response) => response.json())
      .then((data) => {
        if (data.success) {
          // Update sessionStorage
          const unreadCounts = JSON.parse(
            sessionStorage.getItem("chatUnreadCounts") || "{}"
          );
          delete unreadCounts[selectedUserId];
          sessionStorage.setItem(
            "chatUnreadCounts",
            JSON.stringify(unreadCounts)
          );

          // Update global badge via admin-chat-notifications.js
          if (
            window.AdminChatNotifications &&
            window.AdminChatNotifications.updateBadge
          ) {
            const totalUnread = Object.values(unreadCounts).reduce(
              (sum, count) => sum + count,
              0
            );
            window.AdminChatNotifications.updateBadge(totalUnread);
          }
        }
      })
      .catch((err) => console.error("Failed to mark messages as read:", err));
  }
}

async function loadAdminConversations() {
  if (!nickname) return;
  try {
    const resp = await fetch(`/conversations/${nickname}`);
    if (!resp.ok) return;
    const senders = await resp.json();
    for (const sender of senders) {
      await ensureUserItem(sender);
    }
  } catch (e) {
    console.debug("loadAdminConversations error", e);
  }
}

async function ensureUserItem(nick) {
  if (!nick) return;

  if (document.getElementById(nick)) return;

  try {
    const resp = await fetch(`/users/${encodeURIComponent(nick)}`);
    if (!resp.ok) {
      appendUserElement(
        { nickName: nick, fullName: nick, role: "USER", status: "OFFLINE" },
        document.getElementById("connectedUsers")
      );
      return;
    }
    const u = await resp.json();

    const obj = normalizeUserRaw(u);
    obj.status = "OFFLINE";
    appendUserElement(obj, document.getElementById("connectedUsers"));
  } catch (e) {
    console.debug("ensureUserItem failed", e);
    appendUserElement(
      { nickName: nick, fullName: nick, role: "USER", status: "OFFLINE" },
      document.getElementById("connectedUsers")
    );
  }
}

function normalizeUserRaw(raw) {
  if (!raw)
    return { nickName: "", fullName: "", role: "USER", status: "OFFLINE" };
  const nick =
    raw.nickName || raw.phone || raw.email || (raw.id ? "user" + raw.id : "");
  const full = raw.fullName || raw.fullname || raw.name || nick || "";
  return {
    nickName: nick,
    fullName: full,
    avatarUrl: raw.avatarUrl || raw.avatar || raw.imageUrl || null,
    role: (raw.role || "USER").toUpperCase(),
    status: raw.status || "OFFLINE",
  };
}

// ------------------------- Message rendering -------------------------
function displayMessage(senderId, content, timestamp) {
  const messageContainer = document.createElement("div");
  messageContainer.classList.add("message");
  if (senderId === nickname) {
    messageContainer.classList.add("sender");
  } else {
    messageContainer.classList.add("receiver");
  }
  const message = document.createElement("p");
  message.textContent = content;
  messageContainer.appendChild(message);
  const ts = document.createElement("div");
  ts.classList.add("msg-ts");
  ts.style.fontSize = "0.8rem";
  ts.style.color = "#666";
  ts.style.marginTop = "4px";
  ts.textContent = "";
  messageContainer.appendChild(ts);
  chatArea.appendChild(messageContainer);
  if (timestamp) ts.textContent = formatTimestamp(timestamp);
  return messageContainer;
}

function displayMediaMessage(senderId, mediaPath, mediaType) {
  const container = document.createElement("div");
  container.classList.add("message");
  if (senderId === nickname) container.classList.add("sender");
  else container.classList.add("receiver");

  if ((mediaType || "").startsWith("image/")) {
    const img = document.createElement("img");
    img.src = `/media/${encodeURIComponent(mediaPath)}`;
    img.alt = "image";
    img.style.maxWidth = "320px";
    img.style.cursor = "pointer";
    img.addEventListener("click", () => openMediaModal(mediaPath, mediaType));
    container.appendChild(img);
  } else if ((mediaType || "").startsWith("video/")) {
    const video = document.createElement("video");
    video.src = `/media/${encodeURIComponent(mediaPath)}`;
    video.controls = true;
    video.style.maxWidth = "480px";
    video.style.cursor = "pointer";
    video.addEventListener("click", () => openMediaModal(mediaPath, mediaType));
    container.appendChild(video);
  } else {
    const link = document.createElement("a");
    link.href = `/media/${encodeURIComponent(mediaPath)}`;
    link.textContent = "Download file";
    container.appendChild(link);
  }

  const ts = document.createElement("div");
  ts.classList.add("msg-ts");
  ts.style.fontSize = "0.8rem";
  ts.style.color = "#666";
  ts.style.marginTop = "4px";
  ts.textContent = "";
  container.appendChild(ts);

  chatArea.appendChild(container);
  return container;
}

function formatTimestamp(dateStrOrMillis) {
  if (!dateStrOrMillis) return "";
  const d =
    typeof dateStrOrMillis === "number"
      ? new Date(dateStrOrMillis)
      : new Date(dateStrOrMillis);

  const now = new Date();
  const sameDay = d.toDateString() === now.toDateString();
  if (sameDay) {
    return d.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" });
  }
  return d.toLocaleString([], {
    year: "numeric",
    month: "short",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
}

function openMediaModal(mediaPath, mediaType) {
  let modal = document.getElementById("mediaModal");
  let modalContent = document.getElementById("mediaModalContent");
  if (!modal || !modalContent) return;
  modalContent.innerHTML = "";
  if ((mediaType || "").startsWith("image/")) {
    const img = document.createElement("img");
    img.src = `/media/${encodeURIComponent(mediaPath)}`;
    img.style.maxWidth = "90vw";
    img.style.maxHeight = "90vh";
    modalContent.appendChild(img);
  } else if ((mediaType || "").startsWith("video/")) {
    const video = document.createElement("video");
    video.src = `/media/${encodeURIComponent(mediaPath)}`;
    video.controls = true;
    video.autoplay = true;
    video.style.maxWidth = "90vw";
    video.style.maxHeight = "90vh";
    modalContent.appendChild(video);
  } else {
    const link = document.createElement("a");
    link.href = `/media/${encodeURIComponent(mediaPath)}`;
    link.textContent = "Download file";
    modalContent.appendChild(link);
  }
  modal.classList.remove("hidden");
}

function closeMediaModal() {
  const modal = document.getElementById("mediaModal");
  const modalContent = document.getElementById("mediaModalContent");
  if (!modal) return;
  modal.classList.add("hidden");
  if (modalContent) modalContent.innerHTML = "";
}

async function fetchAndDisplayUserChat() {
  const userChatResponse = await fetch(
    `/messages/${nickname}/${selectedUserId}`
  );
  const userChat = await userChatResponse.json();
  chatArea.innerHTML = "";
  userChat.forEach((chat) => {
    if (chat.mediaPath) {
      const el = displayMediaMessage(
        chat.senderId,
        chat.mediaPath,
        chat.mediaType
      );
      if (el) {
        const ts = el.querySelector(".msg-ts");
        if (ts) ts.textContent = formatTimestamp(chat.timestamp);
      }
    } else {
      const el = displayMessage(chat.senderId, chat.content, chat.timestamp);
      if (el) {
      }
    }
  });
  chatArea.scrollTop = chatArea.scrollHeight;
}

// ------------------------- Send message / upload -------------------------
async function sendMessage(event) {
  event.preventDefault();

  if (!stompClient || !selectedUserId) return;

  const messageContent = messageInput.value.trim();
  const file = fileInput ? fileInput.files[0] : null;
  if (file) {
    const form = new FormData();
    form.append("file", file);
    try {
      const resp = await fetch("/api/media/upload", {
        method: "POST",
        body: form,
      });
      if (resp.ok) {
        const media = await resp.json();
        const chatMessage = {
          senderId: nickname,
          recipientId: selectedUserId,
          content: messageContent || "",
          mediaPath: media.path,
          mediaType: media.contentType,
          timestamp: new Date().toISOString(),
        };
        stompClient.send("/app/chat", {}, JSON.stringify(chatMessage));

        if (chatMessage.mediaPath)
          displayMediaMessage(
            nickname,
            chatMessage.mediaPath,
            chatMessage.mediaType
          );
        messageInput.value = "";
        if (fileInput) fileInput.value = null;
      } else {
        console.warn("media upload failed");
      }
    } catch (err) {
      console.error("upload error", err);
    }
    chatArea.scrollTop = chatArea.scrollHeight;
    return;
  }

  if (messageContent) {
    const chatMessage = {
      senderId: nickname,
      recipientId: selectedUserId,
      content: messageContent,
      timestamp: new Date().toISOString(),
    };
    stompClient.send("/app/chat", {}, JSON.stringify(chatMessage));
    const el = displayMessage(nickname, messageContent);
    if (el) {
      const tsEl = el.querySelector(".msg-ts");
      if (tsEl) tsEl.textContent = formatTimestamp(new Date());
    }
    messageInput.value = "";
    chatArea.scrollTop = chatArea.scrollHeight;
  }
}

// ------------------------- On message receive -------------------------
async function onMessageReceived(payload) {
  console.debug("Message received", payload);

  const message = JSON.parse(payload.body);
  const senderId = message.senderId;
  const senderElem = document.getElementById(senderId);

  if (selectedUserId && selectedUserId === senderId) {
    if (message.mediaPath) {
      const el = displayMediaMessage(
        senderId,
        message.mediaPath,
        message.mediaType
      );
      if (el) {
        const ts = el.querySelector(".msg-ts");
        if (ts) ts.textContent = formatTimestamp(message.timestamp);
      }
    } else if (message.content) {
      const el = displayMessage(senderId, message.content, message.timestamp);
      if (el) {
      }
    }

    chatArea.scrollTop = chatArea.scrollHeight;

    if (senderElem) {
      const nbr = senderElem.querySelector(".nbr-msg");
      if (nbr) {
        nbr.classList.add("hidden");
        nbr.textContent = "0";
      }
    }

    return;
  }

  if (senderElem) {
    const nbrMsg = senderElem.querySelector(".nbr-msg");
    if (nbrMsg) {
      let count = parseInt(nbrMsg.textContent) || 0;
      nbrMsg.textContent = count + 1;
      nbrMsg.classList.remove("hidden");
    }
  }

  // Update sessionStorage for global badge sync
  if ((currentRole || "").toUpperCase() === "ADMIN") {
    const unreadCounts = JSON.parse(
      sessionStorage.getItem("chatUnreadCounts") || "{}"
    );
    unreadCounts[senderId] = (unreadCounts[senderId] || 0) + 1;
    sessionStorage.setItem("chatUnreadCounts", JSON.stringify(unreadCounts));

    // Update global badge
    if (
      window.AdminChatNotifications &&
      window.AdminChatNotifications.updateBadge
    ) {
      const totalUnread = Object.values(unreadCounts).reduce(
        (sum, count) => sum + count,
        0
      );
      window.AdminChatNotifications.updateBadge(totalUnread);
    }
  }
}

function onLogout() {
  stompClient.send(
    "/app/user.disconnectUser",
    {},
    JSON.stringify({
      nickName: nickname,
      fullName: fullname,
      status: "OFFLINE",
    })
  );
  window.location.reload();
}
messageForm.addEventListener("submit", sendMessage);
logout.addEventListener("click", onLogout);
window.onbeforeunload = () => onLogout();

initAuth();
