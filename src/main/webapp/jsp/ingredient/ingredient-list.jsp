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
<%-- Toast thông báo: dùng query param thay vì setAttribute (bị mất sau redirect) --%>
<c:if test="${param.success == 'true'}">
    <div class="toast toast-success" id="toastMsg">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="m20 6-11 11-5-5"/></svg>
        Đã lưu nguyên liệu thành công.
        <button class="toast-close" onclick="document.getElementById('toastMsg').style.display='none'">&times;</button>
    </div>
</c:if>
<c:if test="${param.success == 'false'}">
    <div class="toast toast-error" id="toastMsg">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M18 6 6 18M6 6l12 12"/></svg>
        Lưu thất bại — vui lòng kiểm tra lại dữ liệu.
        <button class="toast-close" onclick="document.getElementById('toastMsg').style.display='none'">&times;</button>
    </div>
</c:if>
<c:if test="${param.deleted == 'true'}">
    <div class="toast toast-warn" id="toastMsg">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2m3 0-1 14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2L4 6"/></svg>
        Đã ngừng sử dụng nguyên liệu này.
        <button class="toast-close" onclick="document.getElementById('toastMsg').style.display='none'">&times;</button>
    </div>
</c:if>
<c:if test="${param.deleted == 'false'}">
    <div class="toast toast-error" id="toastMsg">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M18 6 6 18M6 6l12 12"/></svg>
        Không thể ngừng sử dụng — đã xảy ra lỗi.
        <button class="toast-close" onclick="document.getElementById('toastMsg').style.display='none'">&times;</button>
    </div>
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
                            <button type="button" class="icon-btn danger" title="Ngừng dùng"
                                        onclick="openDeactivateModal('${ing.ingredientId}', '${ing.ingredientName}')">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2m3 0-1 14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2L4 6"/></svg>
                                </button>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:otherwise>
</c:choose>


<%-- ═══════════════════════════════════════════════════
     MODAL XÁC NHẬN NGỪNG SỬ DỤNG (thay window.confirm)
     ═══════════════════════════════════════════════════ --%>
<div class="ing-modal-overlay" id="deactivateOverlay" onclick="closeDeactivateModal()" style="display:none;"></div>
<div class="ing-modal" id="deactivateModal" style="display:none;" role="dialog" aria-modal="true">
    <div class="ing-modal__icon">
        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#ee5253" stroke-width="2"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2m3 0-1 14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2L4 6M10 11v6M14 11v6"/></svg>
    </div>
    <h3 class="ing-modal__title">Ngừng sử dụng nguyên liệu?</h3>
    <p class="ing-modal__msg">Nguyên liệu <strong id="modalIngredientName"></strong> sẽ bị ẩn khỏi danh sách. Bạn có thể kích hoạt lại sau nếu cần.</p>
    <div class="ing-modal__actions">
        <button class="btn btn-secondary" onclick="closeDeactivateModal()">Huỷ</button>
        <form method="post" action="${pageContext.request.contextPath}/ingredient" id="deactivateForm" style="display:inline;">
            <input type="hidden" name="action" value="deactivate">
            <input type="hidden" name="ingredientId" id="modalIngredientId" value="">
            <button type="submit" class="btn btn-danger">Xác nhận ngừng dùng</button>
        </form>
    </div>
</div>

<style>
/* ── Toast ─────────────────────────────────── */
.toast {
    display: flex; align-items: center; gap: 10px;
    position: fixed; bottom: 28px; right: 28px; z-index: 9999;
    padding: 13px 18px; border-radius: 10px;
    font-size: 13.5px; font-weight: 500;
    box-shadow: 0 4px 20px rgba(0,0,0,.13);
    animation: slideUp .3s ease;
    max-width: 360px;
}
.toast-success { background: #e9faf3; color: #0d6e4e; border: 1px solid #a8e6ce; }
.toast-warn    { background: #fff8ec; color: #8a5700; border: 1px solid #ffd98a; }
.toast-error   { background: #fff0f0; color: #b91c1c; border: 1px solid #fca5a5; }
.toast-close   { margin-left: auto; background: none; border: none; font-size: 18px; cursor: pointer; opacity: .6; line-height: 1; }
.toast-close:hover { opacity: 1; }
@keyframes slideUp { from { transform: translateY(20px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }

/* ── Modal overlay ──────────────────────────── */
.ing-modal-overlay {
    position: fixed; inset: 0; background: rgba(0,0,0,.38);
    z-index: 8888; backdrop-filter: blur(2px);
    animation: fadeIn .15s ease;
}
.ing-modal {
    position: fixed; top: 50%; left: 50%;
    transform: translate(-50%, -50%);
    z-index: 8889;
    background: #fff; border-radius: 16px;
    padding: 32px 28px 24px;
    width: 100%; max-width: 400px;
    text-align: center;
    box-shadow: 0 20px 60px rgba(0,0,0,.18);
    animation: popIn .2s ease;
}
.ing-modal__icon  { margin-bottom: 14px; }
.ing-modal__title { margin: 0 0 10px; font-size: 17px; color: #1a1a1a; }
.ing-modal__msg   { font-size: 13.5px; color: #555; margin: 0 0 22px; line-height: 1.6; }
.ing-modal__actions { display: flex; gap: 10px; justify-content: center; }
.btn-danger { background: #ee5253; color: #fff; border: none; padding: 9px 20px; border-radius: 8px; font-weight: 600; cursor: pointer; font-size: 13.5px; }
.btn-danger:hover { background: #d93535; }
@keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
@keyframes popIn  { from { transform: translate(-50%,-50%) scale(.92); opacity: 0; } to { transform: translate(-50%,-50%) scale(1); opacity: 1; } }
</style>

<script>
/* ── Modal deactivate ───────────────────────── */
function openDeactivateModal(id, name) {
    document.getElementById('modalIngredientId').value = id;
    document.getElementById('modalIngredientName').textContent = name;
    document.getElementById('deactivateOverlay').style.display = 'block';
    document.getElementById('deactivateModal').style.display   = 'block';
}
function closeDeactivateModal() {
    document.getElementById('deactivateOverlay').style.display = 'none';
    document.getElementById('deactivateModal').style.display   = 'none';
}
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') closeDeactivateModal();
});

/* ── Toast tự ẩn sau 4 giây ────────────────── */
(function() {
    var t = document.getElementById('toastMsg');
    if (t) setTimeout(function() { t.style.display = 'none'; }, 4000);
})();
</script>

<jsp:include page="/views/common/footer.jsp" />
