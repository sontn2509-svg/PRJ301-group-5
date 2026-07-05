<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%--
    /jsp/ingredient/transparency.jsp
    Khớp với IngredientImportServlet GET /ingredient-import/transparency
      -> request.importList, totalCost, weekStart, weekEnd, prevWeekStart, nextWeekStart
    Dành cho Phụ huynh xem minh bạch nguyên liệu nhập kho trong tuần.
--%>
<%
    request.setAttribute("pageTitle", "Minh bạch nguyên liệu");
    request.setAttribute("pageSub", "Nguyên liệu nhập kho trong tuần &middot; công khai cho phụ huynh");
%>
<jsp:include page="/views/common/header.jsp" />

<div class="page-head">
    <div>
        <div class="page-head__eyebrow">Phụ huynh &middot; Minh bạch nguyên liệu</div>
        <h1>Nguyên liệu nhập kho trong tuần</h1>
        <p class="page-head__desc">Danh sách nguyên liệu bếp đã nhập kho, kèm nhà cung cấp và chi phí, để phụ huynh theo dõi minh bạch bữa ăn của các con.</p>
    </div>
</div>

<c:if test="${not empty errorMessage}">
    <div class="alert alert-error">${errorMessage}</div>
</c:if>

<div class="toolbar">
    <div class="toolbar__filters">
        <a class="chip" href="${pageContext.request.contextPath}/ingredient-import/transparency?fromDate=${prevWeekStart}">
            &larr; Tuần trước
        </a>
        <span class="chip is-active">
            <fmt:parseDate var="ws" value="${weekStart}" pattern="yyyy-MM-dd" />
            <fmt:parseDate var="we" value="${weekEnd}" pattern="yyyy-MM-dd" />
            <fmt:formatDate value="${ws}" pattern="dd/MM" /> &ndash; <fmt:formatDate value="${we}" pattern="dd/MM/yyyy" />
        </span>
        <a class="chip" href="${pageContext.request.contextPath}/ingredient-import/transparency?fromDate=${nextWeekStart}">
            Tuần sau &rarr;
        </a>
    </div>
</div>

<div class="stat-grid">
    <div class="stat-tile" style="--accent: var(--basil);">
        <div class="stat-tile__label">Số phiếu nhập trong tuần</div>
        <div class="stat-tile__value"><c:out value="${fn:length(importList)}" /></div>
    </div>
    <div class="stat-tile" style="--accent: var(--turmeric);">
        <div class="stat-tile__label">Tổng chi phí nguyên liệu tuần này</div>
        <div class="stat-tile__value"><fmt:formatNumber value="${totalCost}" pattern="#,##0" /> <span>đ</span></div>
    </div>
</div>

<c:choose>
    <c:when test="${empty importList}">
        <div class="card">
            <div class="empty-state">
                <svg class="empty-state__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M12 3v12m0 0 4-4m-4 4-4-4M4 17v2a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-2"/></svg>
                <h3>Chưa có phiếu nhập nào trong tuần này</h3>
                <p>Nhà bếp chưa ghi nhận nguyên liệu nhập kho nào trong khoảng thời gian này.</p>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="table-wrap">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Ngày nhập</th>
                        <th>Nguyên liệu</th>
                        <th>Số lượng</th>
                        <th>Đơn giá</th>
                        <th>Thành tiền</th>
                        <th>Nhà cung cấp</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="imp" items="${importList}">
                        <tr>
                            <td class="num"><fmt:formatDate value="${imp.importDate}" pattern="dd/MM/yyyy" /></td>
                            <td>${imp.ingredientName}</td>
                            <td class="num"><fmt:formatNumber value="${imp.quantity}" maxFractionDigits="2" /> ${imp.unit}</td>
                            <td class="num"><fmt:formatNumber value="${imp.unitPrice}" pattern="#,##0" /> đ</td>
                            <td class="num"><strong><fmt:formatNumber value="${imp.totalPrice}" pattern="#,##0" /> đ</strong></td>
                            <td>${imp.supplierName}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:otherwise>
</c:choose>

<jsp:include page="/views/common/footer.jsp" />
