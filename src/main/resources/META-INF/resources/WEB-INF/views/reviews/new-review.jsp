<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%@ taglib
uri="http://www.springframework.org/tags/form" prefix="form" %>
<html>
  <head>
    <title>New Review</title>
  </head>
  <body>
    <h1>
      <c:choose>
        <c:when test="${not empty reviewRequest.parentReviewId}">
          Reply to review #${reviewRequest.parentReviewId}
        </c:when>
        <c:otherwise>Write a review</c:otherwise>
      </c:choose>
    </h1>

    <form:form
      modelAttribute="reviewRequest"
      method="post"
      action="/products/${reviewRequest.productId}/reviews"
    >
      <form:hidden path="productId" />
      <form:hidden path="parentReviewId" />
      <c:if test="${not empty reviewRequest.parentReviewId}"> </c:if>

      <table>
        <c:if test="${empty reviewRequest.parentReviewId}">
          <tr>
            <td>Rating</td>
            <td>
              <input type="number" name="rating" min="1" max="5" required />
              <form:errors path="rating" cssClass="error" />
            </td>
          </tr>
        </c:if>
        <tr>
          <td>Comment</td>
          <td>
            <form:textarea path="comment" rows="6" cols="60" />
            <form:errors path="comment" cssClass="error" />
          </td>
        </tr>
        <tr>
          <td colspan="2"><input type="submit" value="Submit" /></td>
        </tr>
      </table>
    </form:form>
  </body>
</html>
