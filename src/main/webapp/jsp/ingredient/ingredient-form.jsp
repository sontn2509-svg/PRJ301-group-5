<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
    /jsp/ingredient/ingredient-form.jsp
    Khớp với IngredientServlet:
      GET  /ingredient/form?id={id}  -> request.ingredient (null nếu thêm mới)
      POST /ingredient  action=update (kèm ingredientId) hoặc rỗng (= tạo mới)
--%>
<%
    boolean isEdit = (request.getAttribute("ingredient") != null);
    request.setAttribute("pageTitle", isEdit ? "Sửa nguyên liệu" : "Thêm nguyên liệu");
    request.setAttribute("pageSub", "Khai báo tên, đơn vị tính và tồn kho ban đầu");
%>
<jsp:include page="/views/common/header.jsp" />

<div class="page-head">
    <div>
        <div class="page-head__eyebrow">Kho &middot; Nguyên liệu</div>
        <h1><c:choose><c:when test="${not empty ingredient}">Sửa nguyên liệu</c:when><c:otherwise>Thêm nguyên liệu mới</c:otherwise></c:choose></h1>
        <p class="page-head__desc">Thông tin này sẽ dùng để tính công thức món ăn và theo dõi tồn kho mỗi ngày.</p>
    </div>
    <a class="btn btn-ghost" href="${pageContext.request.contextPath}/ingredient/list">&larr; Quay lại danh sách</a>
</div>

<div class="card" style="max-width:560px;">
    <div class="card__body">
        <form method="post" action="${pageContext.request.contextPath}/ingredient">
            <c:if test="${not empty ingredient}">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="ingredientId" value="${ingredient.ingredientId}">
            </c:if>

            <div class="form-group">
                <label class="form-label">Tên nguyên liệu <span class="req">*</span></label>
                <input type="text" name="ingredientName" class="form-control" required
                       maxlength="150" placeholder="VD: Thịt heo, Gạo tẻ, Cà rốt..."
                       value="${ingredient.ingredientName}">
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Đơn vị tính <span class="req">*</span></label>
                    <input type="text" name="unit" class="form-control" required
                           maxlength="20" placeholder="kg, lít, quả..."
                           value="${ingredient.unit}">
                </div>
                <div class="form-group">
                    <label class="form-label">
                        <c:choose>
                            <c:when test="${not empty ingredient}">Tồn kho hiện tại</c:when>
                            <c:otherwise>Tồn kho ban đầu</c:otherwise>
                        </c:choose>
                    </label>
                    <input type="number" name="quantityInStock" class="form-control"
                           step="0.01" min="0" placeholder="0.00"
                           value="${ingredient.quantityInStock}">
                    <p class="form-hint">Số lượng nhập/xuất sau này sẽ tự cộng trừ vào đây.</p>
                </div>
            </div>

            <div class="flex gap-12" style="margin-top:22px;">
                <button type="submit" class="btn btn-primary">
                    <c:choose>
                        <c:when test="${not empty ingredient}">Lưu thay đổi</c:when>
                        <c:otherwise>Thêm nguyên liệu</c:otherwise>
                    </c:choose>
                </button>
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/ingredient/list">Huỷ</a>
            </div>
        </form>
    </div>
</div>

<jsp:include page="/views/common/footer.jsp" />
