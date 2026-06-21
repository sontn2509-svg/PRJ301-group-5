<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%--
    /jsp/ingredient/ingredient-list.jsp
    Khớp với IngredientServlet:
      GET /ingredient/list      -> request.ingredientList
      GET /ingredient/low-stock -> request.ingredientList + isLowStockView=true
    POST /ingredient (action=deactivate) -> vô hiệu hoá nguyên liệu
--%>
<%
    request.setAttribute("pageTitle", "Nguyên liệu");
    request.setAttribute("pageSub", "Danh sách nguyên liệu &amp; định lượng/học sinh");
%>
<jsp:include page="/views/common/header.jsp" />

<div class="kitchen-band">
    <div class="kitchen-band__text">
        <div class="page-head__eyebrow">Kho &middot; Nguyên liệu</div>
        <h1>Tủ nguyên liệu bếp</h1>
        <p>Theo dõi tồn kho theo từng nguyên liệu, phát hiện sớm món sắp hết để báo nhập kho kịp thời.</p>
    </div>
    <a class="btn btn-primary" href="${pageContext.request.contextPath}/ingredient/form">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3"><path d="M12 5v14M5 12h14"/></svg>
        Thêm nguyên liệu
    </a>
</div>

<c:if test="${not empty errorMessage}">
    <div class="alert alert-error">${errorMessage}</div>
</c:if>
<c:if test="${not empty param.success && param.success == 'true'}">
    <div class="alert alert-success">Đã lưu nguyên liệu thành công.</div>
</c:if>

<div class="toolbar">
    <div class="toolbar__filters">
        <a class="chip ${empty isLowStockView ? 'is-active' : ''}"
           href="${pageContext.request.contextPath}/ingredient/list">Tất cả</a>
        <a class="chip ${isLowStockView ? 'is-active' : ''}"
           href="${pageContext.request.contextPath}/ingredient/low-stock">Sắp hết hàng</a>
    </div>
    <span class="text-soft" style="font-size:12.5px;">
        <c:out value="${fn:length(ingredientList)}" />
        <c:choose>
            <c:when test="${isLowStockView}">nguyên liệu dưới ngưỡng tồn kho</c:when>
            <c:otherwise>nguyên liệu đang hoạt động</c:otherwise>
        </c:choose>
    </span>
</div>

<c:choose>
    <c:when test="${empty ingredientList}">
        <div class="card">
            <div class="empty-state">
                <svg class="empty-state__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M3 3v18M3 8h4M3 13h4M14 3a4 4 0 0 1 4 4v2a4 4 0 0 1-4 4M18 21V13"/></svg>
                <h3>Chưa có nguyên liệu nào</h3>
                <p>Thêm nguyên liệu đầu tiên để bắt đầu theo dõi tồn kho bếp.</p>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="stock-grid">
            <c:forEach var="ing" items="${ingredientList}">
                <%-- Ngưỡng cảnh báo demo phía giao diện: <=5 đỏ, <=15 vàng, còn lại xanh.
                     Ngưỡng nghiệp vụ thật (low-stock) đã được xử lý ở DAO (<=5). --%>
                <c:set var="qty" value="${ing.quantityInStock}" />
                <c:choose>
                    <c:when test="${qty <= 5}"><c:set var="levelClass" value="is-low" /></c:when>
                    <c:when test="${qty <= 15}"><c:set var="levelClass" value="is-mid" /></c:when>
                    <c:otherwise><c:set var="levelClass" value="" /></c:otherwise>
                </c:choose>
                <c:set var="meterPct" value="${qty <= 0 ? 2 : (qty > 40 ? 100 : (qty * 100 / 40))}" />

                <div class="stock-tag ${levelClass}">
                    <div class="stock-tag__top">
                        <div>
                            <div class="stock-tag__name">${ing.ingredientName}</div>
                            <div class="stock-tag__unit">Đơn vị: ${ing.unit}</div>
                        </div>
                        <c:choose>
                            <c:when test="${qty <= 5}"><span class="badge badge-danger">Sắp hết</span></c:when>
                            <c:when test="${qty <= 15}"><span class="badge badge-warn">Còn ít</span></c:when>
                            <c:otherwise><span class="badge badge-ok">Đủ dùng</span></c:otherwise>
                        </c:choose>
                    </div>

                    <div class="stock-tag__qty">
                        <span class="stock-tag__qty-num"><fmt:formatNumber value="${qty}" maxFractionDigits="2" /></span>
                        <span class="stock-tag__qty-unit">${ing.unit} trong kho</span>
                    </div>

                    <div class="stock-meter">
                        <div class="stock-meter__fill ${levelClass}" style="width: ${meterPct}%;"></div>
                    </div>

                    <div class="stock-tag__foot">
                        <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/ingredient-import/form">Nhập kho</a>
                        <div class="stock-tag__actions">
                            <a class="icon-btn" title="Sửa" href="${pageContext.request.contextPath}/ingredient/form?id=${ing.ingredientId}">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9M16.5 3.5a2.1 2.1 0 0 1 3 3L7 19l-4 1 1-4Z"/></svg>
                            </a>
                            <form method="post" action="${pageContext.request.contextPath}/ingredient"
                                  onsubmit="return confirm('Ngừng sử dụng nguyên liệu này?');" style="display:inline;">
                                <input type="hidden" name="action" value="deactivate">
                                <input type="hidden" name="ingredientId" value="${ing.ingredientId}">
                                <button type="submit" class="icon-btn danger" title="Ngừng dùng">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2m3 0-1 14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2L4 6"/></svg>
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:otherwise>
</c:choose>

<jsp:include page="/views/common/footer.jsp" />
