<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%@ taglib
uri="http://www.springframework.org/tags/form" prefix="form" %>
<html>
  <head>
    <title>Reviews for product ${productId}</title>
  </head>
  <body>
    <h1>Reviews for product ${productId}</h1>

    <c:if test="${not empty error}">
      <div style="color: red">${error}</div>
    </c:if>

    <c:forEach var="review" items="${reviewsPage.content}">
      <div style="border: 1px solid #ccc; padding: 8px; margin: 8px 0">
        <div><strong>By:</strong> ${review.userName}</div>
        <div><strong>Rating:</strong> ${review.rating}</div>
        <div><strong>Comment:</strong> ${review.comment}</div>
        <div>
          <a
            href="/products/${productId}/reviews/new?parentReviewId=${review.reviewId}"
            >Reply</a
          >
        </div>
        <div style="margin-top: 6px">
          <button
            type="button"
            id="toggle-btn-${review.reviewId}"
            onclick="toggleReplies('${review.reviewId}')"
          >
            Thu gọn phản hồi
          </button>
        </div>

        <c:if test="${not empty review.childReviews}">
          <div
            id="child-list-${review.reviewId}"
            style="margin-left: 24px; margin-top: 8px"
          >
            <c:forEach var="child" items="${review.childReviews}">
              <div
                style="border-left: 2px solid #ddd; padding: 6px; margin: 6px 0"
              >
                <div><strong>By:</strong> ${child.userName}</div>
                <div><strong>Comment:</strong> ${child.comment}</div>
                <div>
                  <!-- always reply to the top-level review so replies stay on the same level -->
                  <a
                    href="/products/${productId}/reviews/new?parentReviewId=${review.reviewId}"
                    >Reply</a
                  >
                </div>
              </div>
            </c:forEach>
          </div>
        </c:if>
      </div>
    </c:forEach>

    <div>
      <c:if test="${reviewsPage.totalPages > 1}">
        <c:forEach var="i" begin="0" end="${reviewsPage.totalPages - 1}">
          <a href="?page=${i}&size=${pageSize}">${i + 1}</a>
        </c:forEach>
      </c:if>
    </div>

    <div>
      <a href="/products/${productId}/reviews/new">Add review</a>
    </div>
    <script>
      function toggleReplies(reviewId) {
        var list = document.getElementById("child-list-" + reviewId);
        var btn = document.getElementById("toggle-btn-" + reviewId);
        if (!list) return;
        if (list.style.display === "none") {
          list.style.display = "";
          btn.textContent = "Thu gọn phản hồi";
        } else {
          list.style.display = "none";
          btn.textContent = "Hiện phản hồi";
        }
      }
    </script>
  </body>
</html>
