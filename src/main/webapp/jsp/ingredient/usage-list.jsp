<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%--
    /jsp/ingredient/usage-list.jsp
    Khớp với IngredientUsageServlet GET /ingredient-usage/today -> request.usageList
--%>
<%
    request.setAttribute("pageTitle", "Sử dụng hôm nay");
    request.setAttribute("pageSub", "Nguyên liệu bếp đã dùng trong ngày");
%>
<jsp:include page="/views/common/header.jsp" />

<div class="page-head">
    <div>
        <div class="page-head__eyebrow">Bếp &middot; Nhật ký dùng nguyên liệu</div>
        <h1>Sử dụng nguyên liệu hôm nay</h1>
        <p class="page-head__desc">Mỗi lần ghi nhận sẽ tự trừ vào tồn kho. So sánh với cần dùng thực tế để kiểm soát hao hụt.</p>
    </div>
    <a class="btn btn-primary" href="${pageContext.request.contextPath}/ingredient-usage/form">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3"><path d="M12 5v14M5 12h14"/></svg>
        Ghi nhận sử dụng
    </a>
</div>

<c:if test="${not empty errorMessage}">
    <div class="alert alert-error">${errorMessage}</div>
</c:if>

<div class="card" style="max-width:760px;">
    <div class="card__head">
        <h3>Nhật ký hôm nay</h3>
        <span class="badge badge-mute"><fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy" /></span>
    </div>
    <div class="card__body">
        <c:choose>
            <c:when test="${empty usageList}">
                <div class="empty-state">
                    <svg class="empty-state__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M6 2v6.5L3 14a2 2 0 0 0 1.8 3h14.4a2 2 0 0 0 1.8-3l-3-5.5V2M6 2h12M9 16h6"/></svg>
                    <h3>Chưa có ghi nhận nào hôm nay</h3>
                    <p>Bấm "Ghi nhận sử dụng" sau mỗi bữa nấu để theo dõi hao hụt nguyên liệu chính xác.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="kitchen-timeline">
                    <c:forEach var="u" items="${usageList}">
                        <div class="timeline-item is-usage">
                            <div class="timeline-item__head">
                                <span class="timeline-item__title">${u.ingredientName}</span>
                                <span class="timeline-item__time">
                                    <fmt:formatDate value="${u.usageDate}" pattern="dd/MM/yyyy" />
                                </span>
                            </div>
                            <div class="timeline-item__meta">
                                Đã dùng <strong><fmt:formatNumber value="${u.quantityUsed}" maxFractionDigits="2" /> ${u.unit}</strong>
                                &middot; ghi nhận bởi ${u.updatedByName}
                                <c:if test="${not empty u.note}"> &middot; ${u.note}</c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="/views/common/footer.jsp" />
