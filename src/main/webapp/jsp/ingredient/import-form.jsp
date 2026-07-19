<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
    /jsp/ingredient/import-form.jsp
    Khớp với IngredientImportServlet:
      GET  /ingredient-import/form -> request.ingredientList
      POST /ingredient-import      -> ingredientId, quantity, unitPrice, supplierName, note
    (importDate do servlet tự gán = ngày hôm nay, không cần input)
--%>
<%
    request.setAttribute("pageTitle", "Tạo phiếu nhập kho");
    request.setAttribute("pageSub", "Bổ sung nguyên liệu vào kho bếp");
%>
<jsp:include page="/views/common/header.jsp" />

<div class="page-head">
    <div>
        <div class="page-head__eyebrow">Kho &middot; Nhập hàng</div>
        <h1>Tạo phiếu nhập kho</h1>
        <p class="page-head__desc">Số lượng nhập sẽ được cộng dồn ngay vào tồn kho của nguyên liệu sau khi lưu.</p>
    </div>
    <a class="btn btn-ghost" href="${pageContext.request.contextPath}/ingredient-import/list">&larr; Lịch sử nhập kho</a>
</div>

<div class="receipt-card" style="max-width:600px;">
    <div class="receipt-card__header">
        <div>
            <h2>Phiếu nhập kho</h2>
            <p>Ngày nhập: hôm nay (tự động)</p>
        </div>
        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" style="opacity:.7;"><path d="M12 3v12m0 0 4-4m-4 4-4-4M4 17v2a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-2"/></svg>
    </div>
    <div class="receipt-tear"></div>

    <div class="receipt-card__body">
        <c:if test="${empty ingredientList}">
            <div class="alert alert-warn">Chưa có nguyên liệu nào trong hệ thống. Hãy thêm nguyên liệu trước.</div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/ingredient-import">
            <div class="form-group">
                <label class="form-label">Nguyên liệu <span class="req">*</span></label>
                <div class="ingredient-picker">
                    <select name="ingredientId" id="ingredientSelect" class="form-control" required onchange="updatePreview()">
                        <option value="" disabled selected>-- Chọn nguyên liệu --</option>
                        <c:forEach var="ing" items="${ingredientList}">
                            <option value="${ing.ingredientId}" data-unit="${ing.unit}" data-stock="${ing.quantityInStock}">
                                ${ing.ingredientName}
                            </option>
                        </c:forEach>
                    </select>
                    <div class="ingredient-picker__preview" id="stockPreview">
                        Tồn kho hiện tại: <strong>&mdash;</strong>
                    </div>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Số lượng nhập <span class="req">*</span></label>
                    <input type="number" name="quantity" id="quantityInput" class="form-control"
                           step="0.01" min="0.01" required placeholder="0.00">
                </div>
                <div class="form-group">
                    <label class="form-label">Đơn giá (đ / đơn vị) <span class="req">*</span></label>
                    <input type="number" name="unitPrice" class="form-control"
                           step="100" min="0" required placeholder="0">
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">Nhà cung cấp</label>
                <input type="text" name="supplierName" class="form-control" maxlength="150"
                       placeholder="VD: Công ty TNHH Thực phẩm An Tâm">
            </div>

            <div class="form-group">
                <label class="form-label">Ghi chú</label>
                <textarea name="note" class="form-control" rows="2" placeholder="Ghi chú thêm (nếu có)"></textarea>
            </div>

            <div class="flex gap-12" style="margin-top:22px;">
                <button type="submit" class="btn btn-success">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3"><path d="m20 6-11 11-5-5"/></svg>
                    Xác nhận nhập kho
                </button>
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/ingredient-import/list">Huỷ</a>
            </div>
        </form>
    </div>
</div>

<script>
function updatePreview() {
    var select = document.getElementById('ingredientSelect');
    var opt = select.options[select.selectedIndex];
    var preview = document.getElementById('stockPreview');
    if (!opt || !opt.value) {
        preview.innerHTML = 'Tồn kho hiện tại: <strong>&mdash;</strong>';
        return;
    }
    var stock = opt.getAttribute('data-stock');
    var unit = opt.getAttribute('data-unit');
    preview.innerHTML = 'Tồn kho hiện tại: <strong>' + stock + ' ' + unit + '</strong>';
}
</script>

<jsp:include page="/views/common/footer.jsp" />
