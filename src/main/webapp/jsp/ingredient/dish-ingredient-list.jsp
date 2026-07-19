<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%--
    /jsp/ingredient/dish-ingredient-list.jsp
    Khớp với DishIngredientServlet GET /dish-ingredient/list -> request.dishIngredientList
    Danh sách đã được DAO ORDER BY DishName, IngredientName nên chỉ cần
    duyệt tuần tự và mở nhóm mới mỗi khi DishID đổi (không cần group-by JSTL).
--%>
<%
    request.setAttribute("pageTitle", "Công thức món");
    request.setAttribute("pageSub", "Nguyên liệu cho từng món &amp; định lượng/học sinh");
%>
<jsp:include page="/views/common/header.jsp" />

<div class="page-head">
    <div>
        <div class="page-head__eyebrow">Bếp &middot; Công thức món ăn</div>
        <h1>Công thức món ăn</h1>
        <p class="page-head__desc">Mỗi món cần khai báo nguyên liệu &amp; định lượng cho 1 học sinh. Đây là cơ sở để hệ thống tự tính nguyên liệu cần dùng theo số suất ăn thực tế mỗi ngày.</p>
    </div>
    <c:if test="${sessionScope.authUser.roleName == 'Manager'}">
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/dish-ingredient/form">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3"><path d="M12 5v14M5 12h14"/></svg>
            Thêm nguyên liệu vào công thức
        </a>
    </c:if>
</div>

<c:if test="${sessionScope.authUser.roleName != 'Manager'}">
    <div class="alert" style="background:#eff6ff; color:#1e40af; border:1px solid #bfdbfe;">
        Bạn đang xem ở chế độ chỉ đọc — chỉ Quản lý mới có thể chỉnh sửa công thức món.
    </div>
</c:if>

<c:if test="${not empty errorMessage}">
    <div class="alert alert-error">${errorMessage}</div>
</c:if>
<c:if test="${param.success == 'true'}">
    <div class="alert alert-success">Đã lưu công thức thành công.</div>
</c:if>
<c:if test="${param.success == 'false'}">
    <div class="alert alert-error">Lưu thất bại — có thể nguyên liệu này đã có trong công thức của món, hoặc định lượng không hợp lệ.</div>
</c:if>
<c:if test="${param.deleted == 'true'}">
    <div class="alert alert-warn">Đã xoá nguyên liệu khỏi công thức.</div>
</c:if>

<c:choose>
    <c:when test="${empty dishIngredientList}">
        <div class="card">
            <div class="empty-state">
                <svg class="empty-state__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M4 19V5a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v14l-3-2-3 2-3-2-3 2-3-2Z"/></svg>
                <h3>Chưa có công thức món nào</h3>
                <p>Thêm nguyên liệu vào từng món để hệ thống tính được lượng cần dùng theo số suất ăn.</p>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <c:set var="lastDishId" value="-1" />
        <c:forEach var="di" items="${dishIngredientList}" varStatus="status">
            <c:if test="${di.dishId != lastDishId}">
                <c:if test="${status.index > 0}">
                </tbody>
            </table>
        </div>
    </div>
</c:if>
<div class="card" style="margin-bottom:16px;">
    <div class="card__head">
        <h3>${di.dishName}</h3>
        <c:if test="${sessionScope.authUser.roleName == 'Manager'}">
            <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/dish-ingredient/form?dishId=${di.dishId}">
                + Thêm nguyên liệu
            </a>
        </c:if>
    </div>
    <div class="table-wrap">
        <table class="data-table">
            <thead>
                <tr>
                    <th>Nguyên liệu</th>
                    <th>Định lượng / học sinh</th>
                    <th class="actions-cell">${sessionScope.authUser.roleName == 'Manager' ? 'Thao tác' : ''}</th>
                </tr>
            </thead>
            <tbody>
                <c:set var="lastDishId" value="${di.dishId}" />
            </c:if>
            <tr>
                <td>${di.ingredientName}</td>
                <td class="num">${di.quantityDisplay}</td>
                <td class="actions-cell">
                    <c:if test="${sessionScope.authUser.roleName == 'Manager'}">
                        <a class="icon-btn" title="Sửa" href="${pageContext.request.contextPath}/dish-ingredient/form?id=${di.dishIngredientId}">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9M16.5 3.5a2.1 2.1 0 0 1 3 3L7 19l-4 1 1-4Z"/></svg>
                        </a>
                        <form method="post" action="${pageContext.request.contextPath}/dish-ingredient" style="display:inline;"
                              onsubmit="return confirm('Xoá nguyên liệu này khỏi công thức món &quot;${di.dishName}&quot;?');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="dishIngredientId" value="${di.dishIngredientId}">
                            <button type="submit" class="icon-btn danger" title="Xoá">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2m3 0-1 14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2L4 6"/></svg>
                            </button>
                        </form>
                    </c:if>
                    <c:if test="${sessionScope.authUser.roleName != 'Manager'}">
                        <span style="color:#94a3b8; font-size:12px;">—</span>
                    </c:if>
                </td>
            </tr>
            <c:if test="${status.last}">
            </tbody>
        </table>
    </div>
</div>
</c:if>
</c:forEach>
</c:otherwise>
</c:choose>

<jsp:include page="/views/common/footer.jsp" />