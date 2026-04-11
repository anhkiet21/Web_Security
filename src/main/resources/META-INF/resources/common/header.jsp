<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib
prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:url value="/css/header.css" var="headerCss" />
<link rel="stylesheet" href="${headerCss}" />

<header class="site-header">
  <div class="site-header-inner">
    <a href="${pageContext.request.contextPath}/" class="brand">
      <span class="brand-text" style="color: #d10024; margin: 0 0"
        >CellPhone Store</span
      >
      <!-- <span class="brand-text" style="color: #d10024; margin: 15px 0">CellPhone Store</span> -->
    </a>
  </div>
</header>

<script>
  // Add shadow to header when scrolling
  window.addEventListener("scroll", function () {
    const header = document.querySelector(".site-header");
    if (window.scrollY > 10) {
      header.classList.add("scrolled");
    } else {
      header.classList.remove("scrolled");
    }
  });
</script>
