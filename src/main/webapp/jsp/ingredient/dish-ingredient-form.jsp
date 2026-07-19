<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
    /jsp/ingredient/dish-ingredient-form.jsp
    Khớp với DishIngredientServlet:
      GET  /dish-ingredient/form            -> tạo mới (request.dishOptionList, request.ingredientList)
      GET  /dish-ingredient/form?id=..      -> sửa định lượng (request.dishIngredient)
      GET  /dish-ingredient/form?dishId=..  -> tạo mới, tự chọn sẵn món
      POST /dish-ingredient                 -> dishId, ingredientId, quantityPerStudent
      POST /dish-ingredient (action=update) -> dishIngredientId, quantityPerStudent
--%>
<%
    request.setAttribute("pageTitle", "Công thức món");
    request.setAttribute("pageSub", "Thêm hoặc sửa nguyên liệu trong công thức");
%>
<jsp:include page="/views/common/header.jsp" />

<div class="page-head">
    <div>
        <div class="page-head__eyebrow">Bếp &middot; Công thức món ăn</div>
        <h1>${empty dishIngredient ? "Thêm nguyên liệu vào công thức" : "Sửa định lượng"}</h1>
        <p class="page-head__desc">Định lượng là lượng nguyên liệu cần cho 1 học sinh. Hệ thống sẽ nhân với số suất ăn thực tế mỗi ngày để tính tổng cần dùng.</p>
    </div>
    <a class="btn btn-ghost" href="${pageContext.request.contextPath}/dish-ingredient/list">&larr; Danh sách công thức</a>
</div>

<div class="receipt-card" style="max-width:600px;">
    <div class="receipt-card__header">
        <div>
            <h2>${empty dishIngredient ? "Công thức mới" : "Sửa công thức"}</h2>
            <p>Chọn món &amp; nguyên liệu, nhập định lượng cho 1 học sinh</p>
        </div>
        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" style="opacity:.7;"><path d="M4 19V5a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v14l-3-2-3 2-3-2-3 2-3-2Z"/></svg>
    </div>
    <div class="receipt-tear"></div>

    <div class="receipt-card__body">
        <c:choose>
            <c:when test="${empty dishIngredient}">
                <%-- ===== TẠO MỚI ===== --%>
                <c:if test="${empty dishOptionList}">
                    <div class="alert alert-warn">Chưa có món ăn nào trong hệ thống (module Thực đơn). Hãy tạo món trước khi thêm công thức.</div>
                </c:if>
                <c:if test="${empty ingredientList}">
                    <div class="alert alert-warn">Chưa có nguyên liệu nào trong hệ thống. Hãy thêm nguyên liệu trước.</div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/dish-ingredient">
                    <div class="form-group">
                        <label class="form-label">Món ăn <span class="req">*</span></label>
                        <select name="dishId" class="form-control" required>
                            <option value="" disabled ${empty param.dishId ? "selected" : ""}>-- Chọn món ăn --</option>
                            <c:forEach var="d" items="${dishOptionList}">
                                <option value="${d.dishId}" ${param.dishId == d.dishId ? "selected" : ""}>${d.dishName}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Nguyên liệu <span class="req">*</span></label>
                        <select name="ingredientId" class="form-control" required>
                            <option value="" disabled selected>-- Chọn nguyên liệu --</option>
                            <c:forEach var="ing" items="${ingredientList}">
                                <option value="${ing.ingredientId}">${ing.ingredientName} (${ing.unit})</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Định lượng / học sinh <span class="req">*</span></label>
                        <input type="number" name="quantityPerStudent" class="form-control"
                               step="0.001" min="0.001" required placeholder="VD: 0.05 (kg/học sinh)">
                        <div class="form-hint">Nhân với số suất ăn thực tế trong ngày để ra tổng lượng cần dùng.</div>
                    </div>

                    <div class="flex gap-12" style="margin-top:22px;">
                        <button type="submit" class="btn btn-success">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3"><path d="m20 6-11 11-5-5"/></svg>
                            Lưu công thức
                        </button>
                        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/dish-ingredient/list">Huỷ</a>
                    </div>
                </form>
            </c:when>
            <c:otherwise>
                <%-- ===== SỬA ĐỊNH LƯỢNG ===== --%>
                <div class="alert alert-warn" style="margin-bottom:16px;">
                    Món: <strong>${dishIngredient.dishName}</strong> &middot; Nguyên liệu: <strong>${dishIngredient.ingredientName}</strong>
                    <div class="form-hint">Muốn đổi món hoặc nguyên liệu, hãy xoá dòng này và thêm mới.</div>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/dish-ingredient">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="dishIngredientId" value="${dishIngredient.dishIngredientId}">

                    <div class="form-group">
                        <label class="form-label">Định lượng / học sinh (${dishIngredient.unit}) <span class="req">*</span></label>
                        <input type="number" name="quantityPerStudent" class="form-control"
                               step="0.001" min="0.001" required value="${dishIngredient.quantityPerStudent}">
                    </div>

                    <div class="flex gap-12" style="margin-top:22px;">
                        <button type="submit" class="btn btn-success">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3"><path d="m20 6-11 11-5-5"/></svg>
                            Cập nhật
                        </button>
                        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/dish-ingredient/list">Huỷ</a>
                    </div>
                </form>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="/views/common/footer.jsp" />
