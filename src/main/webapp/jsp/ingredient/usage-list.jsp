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

<div class="card" style="max-width:760px; margin-bottom:20px;">
    <div class="card__head">
        <h3>So sánh cần dùng vs thực tế đã dùng</h3>
        <span class="badge badge-mute">Theo thực đơn hôm nay</span>
    </div>
    <div class="card__body">
        <c:if test="${comparisonUnavailable}">
            <div class="alert alert-warn">Chưa thể tính nhu cầu theo thực đơn hôm nay (chưa có thực đơn hoặc điểm danh cho ngày hôm nay).</div>
        </c:if>
        <c:if test="${not comparisonUnavailable}">
            <c:choose>
                <c:when test="${empty comparisonMap}">
                    <div class="empty-state">
                        <svg class="empty-state__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M9 12 11 14 15 10M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"/></svg>
                        <h3>Không có món nào trong thực đơn hôm nay</h3>
                        <p>Khi thực đơn hôm nay được thiết lập, hệ thống sẽ tự tính lượng cần dùng để so sánh với thực tế.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-wrap">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Nguyên liệu</th>
                                    <th>Chênh lệch (cần dùng &minus; thực tế)</th>
                                    <th>Tình trạng</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="entry" items="${comparisonMap}">
                                    <tr>
                                        <td>${entry.key}</td>
                                        <td class="num">
                                            <fmt:formatNumber value="${entry.value}" maxFractionDigits="2" />
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${entry.value > 0.01}">
                                                    <span class="badge badge-warn">Ghi nhận ít hơn công thức</span>
                                                </c:when>
                                                <c:when test="${entry.value < -0.01}">
                                                    <span class="badge badge-danger">Dùng nhiều hơn công thức</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-ok">Khớp công thức</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </c:if>
    </div>
</div>

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
