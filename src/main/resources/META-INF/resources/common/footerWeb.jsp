<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- FOOTER -->
<footer id="footer">
  <!-- top footer -->
  <div class="section">
    <div class="container">
      <div class="row">
        <div class="col-md-3 col-xs-6">
          <div class="footer">
            <h3 class="footer-title">Về chúng tôi</h3>
            <p>
              Cửa hàng điện thoại uy tín, chuyên cung cấp các sản phẩm điện
              thoại chính hãng với giá cả cạnh tranh nhất thị trường.
            </p>
            <ul class="footer-links">
              <li>
                <a
                  href="https://www.google.com/maps/place/Tr%C6%B0%E1%BB%9Dng+%C4%90%E1%BA%A1i+h%E1%BB%8Dc+S%C6%B0+ph%E1%BA%A1m+K%E1%BB%B9+thu%E1%BA%ADt+Th%C3%A0nh+ph%E1%BB%91+H%E1%BB%93+Ch%C3%AD+Minh/@10.8505683,106.7717721,17z/data=!4m6!3m5!1s0x31752763f23816ab:0x282f711441b6916f!8m2!3d10.8506324!4d106.7719131!16s%2Fm%2F02pz17z?entry=ttu&g_ep=EgoyMDI1MTAxNC4wIKXMDSoASAFQAw%3D%3D"
                  target="_blank"
                  ><i class="fa fa-map-marker"></i>Trường ĐH Sư Phạm Kỹ Thuật -
                  1 Võ Văn Ngân, Linh Chiểu, Thủ Đức, TP.HCM</a
                >
              </li>
              <li>
                <a href="https://zalo.me/0889251007" target="_blank"
                  ><i class="fa fa-phone"></i>+84 889-251-007</a
                >
              </li>
              <li>
                <a href="mailto:kietccc21@gmail.com"
                  ><i class="fa fa-envelope-o"></i>kietccc21@gmail.com</a
                >
              </li>
            </ul>
          </div>
        </div>

        <div class="col-md-3 col-xs-6">
          <div class="footer">
            <h3 class="footer-title">Danh mục</h3>
            <ul class="footer-links">
              <li>
                <a href="${pageContext.request.contextPath}/">Trang chủ</a>
              </li>
              <li>
                <a href="${pageContext.request.contextPath}/shop">Sản phẩm</a>
              </li>
              <li>
                <a href="${pageContext.request.contextPath}/deals"
                  >Khuyến mãi</a
                >
              </li>
              <li>
                <a href="${pageContext.request.contextPath}/about"
                  >Giới thiệu</a
                >
              </li>
              <li>
                <a href="${pageContext.request.contextPath}/contact">Liên hệ</a>
              </li>
            </ul>
          </div>
        </div>

        <div class="clearfix visible-xs"></div>

        <div class="col-md-3 col-xs-6">
          <div class="footer">
            <h3 class="footer-title">Hỗ trợ khách hàng</h3>
            <ul class="footer-links">
              <li>
                <a href="${pageContext.request.contextPath}/faq"
                  >Câu hỏi thường gặp</a
                >
              </li>
              <li>
                <a href="${pageContext.request.contextPath}/warranty"
                  >Chính sách bảo hành</a
                >
              </li>
              <li>
                <a href="${pageContext.request.contextPath}/return"
                  >Đổi trả hàng</a
                >
              </li>
              <li>
                <a href="${pageContext.request.contextPath}/payment"
                  >Hướng dẫn thanh toán</a
                >
              </li>
              <li>
                <a href="${pageContext.request.contextPath}/shipping"
                  >Vận chuyển</a
                >
              </li>
            </ul>
          </div>
        </div>

        <div class="col-md-3 col-xs-6">
          <div class="footer">
            <h3 class="footer-title">Tài khoản</h3>
            <ul class="footer-links">
              <li>
                <a href="${pageContext.request.contextPath}/profile"
                  >Thông tin tài khoản</a
                >
              </li>
              <li>
                <a href="${pageContext.request.contextPath}/cart">Giỏ hàng</a>
              </li>
              <li>
                <a href="${pageContext.request.contextPath}/wishlist"
                  >Yêu thích</a
                >
              </li>
              <li>
                <a href="${pageContext.request.contextPath}/profile#orders"
                  >Đơn hàng của tôi</a
                >
              </li>
              <li>
                <a href="${pageContext.request.contextPath}/user/chat"
                  >Trợ giúp</a
                >
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </div>
  <!-- /top footer -->

  <!-- bottom footer -->
  <div id="bottom-footer" class="section">
    <div class="container">
      <div class="row">
        <div class="col-md-12 text-center">
          <ul class="footer-payments">
            <li>
              <a href="#"><i class="fa fa-cc-visa"></i></a>
            </li>
            <li>
              <a href="#"><i class="fa fa-credit-card"></i></a>
            </li>
            <li>
              <a href="#"><i class="fa fa-cc-paypal"></i></a>
            </li>
            <li>
              <a href="#"><i class="fa fa-cc-mastercard"></i></a>
            </li>
          </ul>
          <span class="copyright">
            Copyright &copy;
            <script>
              document.write(new Date().getFullYear());
            </script>
            CellPhoneStore - Dự án Web bán điện thoại
          </span>
        </div>
      </div>
    </div>
  </div>
  <!-- /bottom footer -->
</footer>
<!-- /FOOTER -->

<!-- Floating Contact Button -->
<%@ page
import="org.springframework.security.core.context.SecurityContextHolder" %> <%@
page import="org.springframework.security.core.Authentication" %> <%@ page
import="org.springframework.security.authentication.AnonymousAuthenticationToken"
%> <%@ page import="org.springframework.security.core.GrantedAuthority" %> <%
Authentication floatingAuth =
SecurityContextHolder.getContext().getAuthentication(); boolean
isFloatingAuthenticated = floatingAuth != null && floatingAuth.isAuthenticated()
&& !(floatingAuth instanceof AnonymousAuthenticationToken);
request.setAttribute("isFloatingAuthenticated", isFloatingAuthenticated);
boolean isFloatingAdmin = false; if (isFloatingAuthenticated) { for
(GrantedAuthority authority : floatingAuth.getAuthorities()) { if
("ROLE_ADMIN".equals(authority.getAuthority())) { isFloatingAdmin = true; break;
} } } request.setAttribute("isFloatingAdmin", isFloatingAdmin); %>

<c:if test="${isFloatingAuthenticated}">
  <div class="floating-contact-btn" id="floatingContactBtn">
    <c:choose>
      <c:when test="${isFloatingAdmin}">
        <a
          href="${pageContext.request.contextPath}/admin/chat"
          class="chat-btn-link"
        >
          <i class="fa fa-comments"></i>
          <span class="floating-badge" id="floating-chat-qty">0</span>
        </a>
      </c:when>
      <c:otherwise>
        <a
          href="${pageContext.request.contextPath}/user/chat"
          class="chat-btn-link"
        >
          <i class="fa fa-comments"></i>
          <span class="floating-badge" id="floating-chat-qty">0</span>
        </a>
      </c:otherwise>
    </c:choose>
    <div class="contact-tooltip">Liên hệ</div>
  </div>
</c:if>

<style>
  .floating-contact-btn {
    position: fixed;
    bottom: 30px;
    right: 30px;
    z-index: 9999;
    animation: slideInUp 0.5s ease-out;
  }

  .floating-contact-btn .chat-btn-link {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 60px;
    height: 60px;
    background: linear-gradient(135deg, #d10024 0%, #ff1744 100%);
    color: white;
    border-radius: 50%;
    box-shadow: 0 4px 12px rgba(209, 0, 36, 0.4);
    text-decoration: none;
    transition: all 0.3s ease;
    position: relative;
  }

  .floating-contact-btn .chat-btn-link:hover {
    transform: translateY(-5px);
    box-shadow: 0 6px 20px rgba(209, 0, 36, 0.6);
    background: linear-gradient(135deg, #ff1744 0%, #d10024 100%);
  }

  .floating-contact-btn .chat-btn-link i {
    font-size: 28px;
    margin: 0;
  }

  .floating-contact-btn .floating-badge {
    position: absolute;
    top: -5px;
    right: -5px;
    background: #fff;
    color: #d10024;
    border-radius: 50%;
    width: 24px;
    height: 24px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 11px;
    font-weight: bold;
    border: 2px solid #d10024;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
  }

  .floating-contact-btn .contact-tooltip {
    position: absolute;
    right: 70px;
    top: 50%;
    transform: translateY(-50%);
    background: #333;
    color: white;
    padding: 8px 15px;
    border-radius: 4px;
    font-size: 14px;
    white-space: nowrap;
    opacity: 0;
    visibility: hidden;
    transition: all 0.3s ease;
    pointer-events: none;
  }

  .floating-contact-btn .contact-tooltip::after {
    content: "";
    position: absolute;
    right: -6px;
    top: 50%;
    transform: translateY(-50%);
    width: 0;
    height: 0;
    border-left: 6px solid #333;
    border-top: 6px solid transparent;
    border-bottom: 6px solid transparent;
  }

  .floating-contact-btn:hover .contact-tooltip {
    opacity: 1;
    visibility: visible;
    right: 75px;
  }

  @keyframes slideInUp {
    from {
      opacity: 0;
      transform: translateY(30px);
    }

    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  /* Pulsing animation for badge when there are unread messages */
  .floating-contact-btn .floating-badge.has-unread {
    animation: pulse 2s infinite;
  }

  @keyframes pulse {
    0% {
      box-shadow: 0 0 0 0 rgba(209, 0, 36, 0.7);
    }

    70% {
      box-shadow: 0 0 0 10px rgba(209, 0, 36, 0);
    }

    100% {
      box-shadow: 0 0 0 0 rgba(209, 0, 36, 0);
    }
  }

  /* Mobile responsive */
  @media (max-width: 768px) {
    .floating-contact-btn {
      bottom: 20px;
      right: 20px;
    }

    .floating-contact-btn .chat-btn-link {
      width: 50px;
      height: 50px;
    }

    .floating-contact-btn .chat-btn-link i {
      font-size: 24px;
    }

    .floating-contact-btn .contact-tooltip {
      display: none;
    }
  }
</style>

<script>
  // Update floating chat badge
  function updateFloatingChatBadge() {
      var isLoggedIn = ${ isFloatingAuthenticated };
      if (!isLoggedIn) return;

      console.log('[Floating Chat] Updating badge...');
      fetch('${pageContext.request.contextPath}/api/chat/unread-count', {
          method: 'GET',
          credentials: 'include',
          headers: {
              'Content-Type': 'application/json'
          }
      })
          .then(function (response) {
              if (response.ok) {
                  return response.json();
              }
              return null;
          })
          .then(function (data) {
              if (data && data.unreadCount !== undefined) {
                  var floatingBadge = document.getElementById('floating-chat-qty');
                  if (floatingBadge) {
                      floatingBadge.textContent = data.unreadCount;
                      console.log('[Floating Chat] Badge updated to:', data.unreadCount);
                      // Add pulsing animation if there are unread messages
                      if (data.unreadCount > 0) {
                          floatingBadge.classList.add('has-unread');
                      } else {
                          floatingBadge.classList.remove('has-unread');
                      }
                  }
              }
          })
          .catch(function (error) {
              console.error('[Floating Chat] Error updating badge:', error);
          });
  }

  // Initialize on page load
  if (typeof window !== 'undefined') {
      window.addEventListener('DOMContentLoaded', function () {
          updateFloatingChatBadge();
      });

      // Update when page becomes visible (user switches tab back)
      document.addEventListener('visibilitychange', function () {
          if (!document.hidden) {
              console.log('[Floating Chat] Page visible, refreshing...');
              updateFloatingChatBadge();
          }
      });

      // Update when page gains focus (user comes back to window)
      window.addEventListener('focus', function () {
          console.log('[Floating Chat] Window focused, refreshing...');
          updateFloatingChatBadge();
      });

      // Update when page is shown from cache (back/forward navigation)
      window.addEventListener('pageshow', function (event) {
          if (event.persisted) {
              console.log('[Floating Chat] Page shown from cache, refreshing...');
              updateFloatingChatBadge();
          }
      });

      // Check for manual refresh request from chat page
      setInterval(function () {
          if (sessionStorage.getItem('chatBadgeNeedsRefresh') === 'true') {
              console.log('[Floating Chat] Manual refresh requested');
              sessionStorage.removeItem('chatBadgeNeedsRefresh');
              updateFloatingChatBadge();
          }
      }, 500);

      // Periodic update every 15 seconds to catch new messages
      setInterval(updateFloatingChatBadge, 15000);
  }
</script>
