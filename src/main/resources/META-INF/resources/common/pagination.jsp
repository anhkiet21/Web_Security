<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- 
    Common Pagination Component
    
    Parameters:
    - page: Spring Page object
    - baseUrl: Base URL for pagination links (e.g., "/admin/users")
    - additionalParams: Additional URL parameters (optional)
    
    Usage:
    <jsp:include page="/common/pagination.jsp">
        <jsp:param name="baseUrl" value="/admin/users"/>
    </jsp:include>
--%>

<div class="pagination-container" style="display: flex; justify-content: space-between; align-items: center; margin-top: 20px; padding: 15px 0;">
    <!-- Left side: Total count -->
    <div style="min-width: 150px;">
        <span style="color: #666; font-size: 14px;">
            Tổng: <strong>${page.totalElements}</strong> bản ghi
        </span>
    </div>
    
    <!-- Center: Pagination buttons -->
    <div style="display: flex; justify-content: center;">
        <ul class="pagination" style="display: flex; list-style: none; padding: 0; margin: 0; gap: 4px;">
            <!-- First and Previous buttons -->
            <c:choose>
                <c:when test="${page.first}">
                    <li>
                        <span class="page-link disabled" style="padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; color: #aaa; cursor: not-allowed; background: #f8f9fa;">
                            <i class="fas fa-angle-double-left"></i>
                        </span>
                    </li>
                    <li>
                        <span class="page-link disabled" style="padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; color: #aaa; cursor: not-allowed; background: #f8f9fa;">
                            <i class="fas fa-angle-left"></i>
                        </span>
                    </li>
                </c:when>
                <c:otherwise>
                    <li>
                        <a href="?page=0&size=${page.size}${param.additionalParams}" 
                           class="page-link" 
                           style="padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; text-decoration: none; color: #333; background: white;"
                           title="Trang đầu">
                            <i class="fas fa-angle-double-left"></i>
                        </a>
                    </li>
                    <li>
                        <a href="?page=${page.number - 1}&size=${page.size}${param.additionalParams}" 
                           class="page-link" 
                           style="padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; text-decoration: none; color: #333; background: white;"
                           title="Trang trước">
                            <i class="fas fa-angle-left"></i>
                        </a>
                    </li>
                </c:otherwise>
            </c:choose>
            
            <!-- Page numbers -->
            <c:forEach begin="${page.number - 2 < 0 ? 0 : page.number - 2}"
                      end="${page.totalPages == 0 ? 0 : (page.number + 2 >= page.totalPages ? (page.totalPages - 1 < 0 ? 0 : page.totalPages - 1) : page.number + 2)}"
                      var="i">
                <c:choose>
                    <c:when test="${i == page.number}">
                        <li>
                            <span class="page-link active" 
                                  style="padding: 8px 12px; border: 1px solid #007bff; border-radius: 4px; background-color: #007bff; color: white; font-weight: 600;">
                                ${i + 1}
                            </span>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li>
                            <a href="?page=${i}&size=${page.size}${param.additionalParams}" 
                               class="page-link" 
                               style="padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; text-decoration: none; color: #333; background: white;">
                                ${i + 1}
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            
            <!-- Next and Last buttons -->
            <c:choose>
                <c:when test="${page.last}">
                    <li>
                        <span class="page-link disabled" style="padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; color: #aaa; cursor: not-allowed; background: #f8f9fa;">
                            <i class="fas fa-angle-right"></i>
                        </span>
                    </li>
                    <li>
                        <span class="page-link disabled" style="padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; color: #aaa; cursor: not-allowed; background: #f8f9fa;">
                            <i class="fas fa-angle-double-right"></i>
                        </span>
                    </li>
                </c:when>
                <c:otherwise>
                    <li>
                        <a href="?page=${page.number + 1}&size=${page.size}${param.additionalParams}" 
                           class="page-link" 
                           style="padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; text-decoration: none; color: #333; background: white;"
                           title="Trang sau">
                            <i class="fas fa-angle-right"></i>
                        </a>
                    </li>
                    <li>
                        <a href="?page=${page.totalPages - 1}&size=${page.size}${param.additionalParams}" 
                           class="page-link" 
                           style="padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; text-decoration: none; color: #333; background: white;"
                           title="Trang cuối">
                            <i class="fas fa-angle-double-right"></i>
                        </a>
                    </li>
                </c:otherwise>
            </c:choose>
        </ul>
    </div>
    
    <!-- Right side: Page size selector -->
    <div>
        <select id="pageSizeSelector" 
                onchange="window.location.href='?page=0&size=' + this.value + '${param.additionalParams}'" 
                style="padding: 8px 12px; border-radius: 4px; border: 1px solid #ddd; cursor: pointer; background: white;">
            <option value="5" ${page.size == 5 ? 'selected' : ''}>5 dòng</option>
            <option value="10" ${page.size == 10 ? 'selected' : ''}>10 dòng</option>
            <option value="20" ${page.size == 20 ? 'selected' : ''}>20 dòng</option>
            <option value="50" ${page.size == 50 ? 'selected' : ''}>50 dòng</option>
            <option value="100" ${page.size == 100 ? 'selected' : ''}>100 dòng</option>
        </select>
    </div>
</div>

<style>
    .pagination-container .page-link:hover:not(.disabled):not(.active) {
        background-color: #e9ecef !important;
        border-color: #dee2e6 !important;
    }
    
    .pagination-container .page-link.active {
        cursor: default;
    }
</style>
