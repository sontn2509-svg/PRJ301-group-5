<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%--
    /jsp/ingredient/import-list.jsp
    Khớp với IngredientImportServlet GET /ingredient-import/list -> request.importList
--%>
<%
    request.setAttribute("pageTitle", "Nhập kho");
    request.setAttribute("pageSub", "Lịch sử các phiếu nhập nguyên liệu");
%>
<jsp:include page="/views/common/header.jsp" />

<div class="page-head">
    <div>
        <div class="page-head__eyebrow">Kho &middot; Nhập hàng</div>
        <h1>Phiếu nhập kho</h1>
        <p class="page-head__desc">Mỗi lần nhập sẽ tự cộng dồn số lượng vào tồn kho của nguyên liệu tương ứng.</p>
    </div>
    <a class="btn btn-primary" href="${pageContext.request.contextPath}/ingredient-import/form">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3"><path d="M12 5v14M5 12h14"/></svg>
        Tạo phiếu nhập
    </a>
</div>

<c:if test="${not empty errorMessage}">
    <div class="alert alert-error">${errorMessage}</div>
</c:if>

<c:set var="totalCost" value="0" />
<c:forEach var="imp" items="${importList}">
    <c:set var="totalCost" value="${totalCost + imp.totalPrice}" />
</c:forEach>

<div class="stat-grid">
    <div class="stat-tile" style="--accent: var(--basil);">
        <div class="stat-tile__label">Tổng số phiếu</div>
        <div class="stat-tile__value"><c:out value="${fn:length(importList)}" /></div>
    </div>
    <div class="stat-tile" style="--accent: var(--turmeric);">
        <div class="stat-tile__label">Tổng chi phí nhập</div>
        <div class="stat-tile__value"><fmt:formatNumber value="${totalCost}" pattern="#,##0" /> <span>đ</span></div>
    </div>
</div>

<c:choose>
    <c:when test="${empty importList}">
        <div class="card">
            <div class="empty-state">
                <svg class="empty-state__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M12 3v12m0 0 4-4m-4 4-4-4M4 17v2a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-2"/></svg>
                <h3>Chưa có phiếu nhập nào</h3>
                <p>Tạo phiếu nhập kho đầu tiên để bổ sung nguyên liệu cho bếp.</p>
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
                        <th>Người nhập</th>
                        <th>Ghi chú</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="imp" items="${importList}">
                        <tr>
                            <td class="num"><fmt:formatDate value="${imp.importDate}" pattern="dd/MM/yyyy" /></td>
                            <td><strong>${imp.ingredientName}</strong></td>
                            <td class="num"><fmt:formatNumber value="${imp.quantity}" maxFractionDigits="2" /> ${imp.unit}</td>
                            <td class="num"><fmt:formatNumber value="${imp.unitPrice}" pattern="#,##0" /> đ</td>
                            <td class="num"><strong><fmt:formatNumber value="${imp.totalPrice}" pattern="#,##0" /> đ</strong></td>
                            <td>${imp.supplierName}</td>
                            <td class="text-soft">${imp.createdByName}</td>
                            <td class="text-soft">
                                <c:choose>
                                    <c:when test="${not empty imp.note}">${imp.note}</c:when>
                                    <c:otherwise>&mdash;</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:otherwise>
</c:choose>

<jsp:include page="/views/common/footer.jsp" />
