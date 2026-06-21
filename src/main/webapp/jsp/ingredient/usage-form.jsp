<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
    /jsp/ingredient/usage-form.jsp
    Khớp với IngredientUsageServlet:
      GET  /ingredient-usage/form -> request.ingredientList
      POST /ingredient-usage      -> ingredientId, quantityUsed, note
    (usageDate do servlet tự gán = ngày hôm nay)
--%>
<%
    request.setAttribute("pageTitle", "Ghi nhận sử dụng");
    request.setAttribute("pageSub", "Trừ nguyên liệu thực tế đã dùng trong ngày");
%>
<jsp:include page="/views/common/header.jsp" />

<div class="page-head">
    <div>
        <div class="page-head__eyebrow">Bếp &middot; Nhật ký dùng nguyên liệu</div>
        <h1>Ghi nhận sử dụng nguyên liệu</h1>
        <p class="page-head__desc">Số lượng ghi nhận sẽ được trừ ngay khỏi tồn kho hiện tại.</p>
    </div>
    <a class="btn btn-ghost" href="${pageContext.request.contextPath}/ingredient-usage/today">&larr; Nhật ký hôm nay</a>
</div>

<div class="receipt-card" style="max-width:560px;">
    <div class="receipt-card__header">
        <div>
            <h2>Phiếu sử dụng nguyên liệu</h2>
            <p>Ngày dùng: hôm nay (tự động)</p>
        </div>
        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" style="opacity:.7;"><path d="M6 2v6.5L3 14a2 2 0 0 0 1.8 3h14.4a2 2 0 0 0 1.8-3l-3-5.5V2M6 2h12M9 16h6"/></svg>
    </div>
    <div class="receipt-tear"></div>

    <div class="receipt-card__body">
        <c:if test="${empty ingredientList}">
            <div class="alert alert-warn">Chưa có nguyên liệu nào trong hệ thống.</div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/ingredient-usage">
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

            <div class="form-group">
                <label class="form-label">Số lượng đã dùng <span class="req">*</span></label>
                <input type="number" name="quantityUsed" class="form-control"
                       step="0.01" min="0.01" required placeholder="0.00">
                <p class="form-hint">Hệ thống sẽ tự động trừ số này khỏi tồn kho hiện tại (không âm).</p>
            </div>

            <div class="form-group">
                <label class="form-label">Ghi chú</label>
                <textarea name="note" class="form-control" rows="2" placeholder="VD: dùng cho bữa trưa lớp Mầm, Chồi, Lá"></textarea>
            </div>

            <div class="flex gap-12" style="margin-top:22px;">
                <button type="submit" class="btn btn-primary">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3"><path d="m20 6-11 11-5-5"/></svg>
                    Ghi nhận sử dụng
                </button>
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/ingredient-usage/today">Huỷ</a>
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
