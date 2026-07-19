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

<div class="stat-grid" style="margin-bottom:20px;">
    <div class="stat-tile" style="--accent: var(--basil);">
        <div class="stat-tile__label">Tổng số suất ăn hôm nay</div>
        <div class="stat-tile__value">${totalMealCount} <span>suất</span></div>
    </div>
    <c:forEach var="lv" items="${mealCountByLevel}">
        <div class="stat-tile" style="--accent: var(--turmeric);">
            <div class="stat-tile__label">${lv.levelName}</div>
            <div class="stat-tile__value">${lv.mealCount} <span>suất</span></div>
        </div>
    </c:forEach>
</div>

<c:if test="${not empty errorMessage}">
    <div class="alert alert-error">${errorMessage}</div>
</c:if>

<%-- Toast thông báo --%>
<c:if test="${param.deleted == 'true'}">
    <div class="toast toast-warn" id="toastMsg">
        Đã xoá bản ghi và hoàn lại tồn kho.
        <button onclick="document.getElementById('toastMsg').style.display = 'none'" style="margin-left:auto;background:none;border:none;cursor:pointer;font-size:16px;">&times;</button>
    </div>
</c:if>
<c:if test="${param.updated == 'true'}">
    <div class="toast toast-success" id="toastMsg">
        Đã cập nhật ghi nhận thành công.
        <button onclick="document.getElementById('toastMsg').style.display = 'none'" style="margin-left:auto;background:none;border:none;cursor:pointer;font-size:16px;">&times;</button>
    </div>
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
                <c:when test="${empty comparisonList}">
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
                                    <th>Cần dùng</th>
                                    <th>Thực tế đã dùng</th>
                                    <th>Chênh lệch</th>
                                    <th>Tình trạng</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="row" items="${comparisonList}">
                                    <tr>
                                        <td>${row.ingredientName}</td>
                                        <td class="num">${row.neededDisplay}</td>
                                        <td class="num">${row.actualUsedDisplay}</td>
                                        <td class="num">${row.diffDisplay}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${row.diff > 0.01}">
                                                    <span class="badge badge-warn">Ghi nhận ít hơn công thức</span>
                                                </c:when>
                                                <c:when test="${row.diff < -0.01}">
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
                                <%-- Nút Sửa + Xoá --%>
                                <div style="display:flex;align-items:center;gap:6px;">
                                    <span class="timeline-item__time">
                                        <fmt:formatDate value="${u.usageDate}" pattern="dd/MM/yyyy" />
                                    </span>
                                    <%-- Nút Sửa --%>
                                    <button type="button"
                                            class="icon-btn"
                                            title="Sửa"
                                            onclick="openEditModal(
                                                            '${u.usageId}',
                                                            '${u.ingredientName}',
                                                            '${u.quantityUsed}',
                                                            '${u.unit}',
                                                            '${u.note}')">
                                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M12 20h9M16.5 3.5a2.1 2.1 0 0 1 3 3L7 19l-4 1 1-4Z"/>
                                        </svg>
                                    </button>
                                    <%-- Nút Xoá --%>
                                    <button type="button" class="icon-btn danger" title="Xoá"
                                            onclick="openDeleteModal('${u.usageId}', '${u.ingredientName}')">
                                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2m3 0-1 14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2L4 6"/>
                                        </svg>
                                    </button>
                                </div>
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

<%-- ══ MODAL XOÁ ══ --%>
<div id="deleteOverlay" onclick="closeDeleteModal()"
     style="display:none;position:fixed;inset:0;background:rgba(0,0,0,.4);
     z-index:8888;backdrop-filter:blur(2px);animation:fadeIn .15s ease;"></div>
<div id="deleteModal" role="dialog" aria-modal="true"
     style="display:none;position:fixed;top:50%;left:50%;
     transform:translate(-50%,-50%);z-index:8889;
     background:#fff;border-radius:16px;padding:32px 28px 24px;
     width:calc(100% - 40px);max-width:400px;
     box-shadow:0 20px 60px rgba(0,0,0,.2);text-align:center;
     animation:popIn .2s ease;">
    <div style="margin-bottom:14px;">
        <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#ee5253" stroke-width="2">
        <path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2m3 0-1 14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2L4 6M10 11v6M14 11v6"/>
        </svg>
    </div>
    <h3 style="margin:0 0 8px;font-size:17px;color:#1a1a1a;">Xoá ghi nhận?</h3>
    <p id="deleteModalMsg" style="margin:0 0 22px;font-size:13.5px;color:#555;line-height:1.6;"></p>
    <div style="display:flex;gap:10px;justify-content:center;">
        <button type="button" onclick="closeDeleteModal()"
                style="padding:9px 20px;border:1.5px solid #e2e8f0;border-radius:8px;
                background:#fff;cursor:pointer;font-size:13.5px;font-weight:500;">
            Huỷ
        </button>
        <form id="deleteForm" method="post"
              action="${pageContext.request.contextPath}/ingredient-usage/do"
              style="display:inline;">
            <input type="hidden" name="action"  value="delete">
            <input type="hidden" id="deleteId"  name="usageId" value="">
            <button type="submit"
                    style="padding:9px 20px;border:none;border-radius:8px;
                    background:#ee5253;color:#fff;font-weight:600;
                    cursor:pointer;font-size:13.5px;">
                Xác nhận xoá
            </button>
        </form>
    </div>
</div>

<%-- ══ MODAL SỬA ══ --%>
<div id="editOverlay" onclick="closeEditModal()"
     style="display:none;position:fixed;inset:0;background:rgba(0,0,0,.4);
     z-index:8888;backdrop-filter:blur(2px);animation:fadeIn .15s ease;"></div>

<div id="editModal" role="dialog" aria-modal="true"
     style="display:none;position:fixed;top:50%;left:50%;
     transform:translate(-50%,-50%);z-index:8889;
     background:#fff;border-radius:16px;padding:28px 24px 20px;
     width:calc(100% - 40px);max-width:380px;
     box-shadow:0 20px 60px rgba(0,0,0,.2);
     animation:popIn .2s ease;">

    <h3 style="margin:0 0 4px;font-size:16px;color:#1a1a1a;">Sửa ghi nhận</h3>
    <p id="editIngName" style="margin:0 0 18px;font-size:13px;color:#64748b;font-weight:500;"></p>

    <form method="post" action="${pageContext.request.contextPath}/ingredient-usage/do">
        <input type="hidden" name="action"  value="update">
        <input type="hidden" id="editId"    name="usageId" value="">

        <div style="margin-bottom:14px;">
            <label style="font-size:13px;font-weight:500;display:block;margin-bottom:5px;">
                Số lượng đã dùng (<span id="editUnit" style="color:#b45309;"></span>)
            </label>
            <input type="number" id="editQty" name="quantityUsed"
                   step="0.01" min="0.01" required autocomplete="off"
                   style="width:100%;padding:9px 11px;border:1.5px solid #e2e8f0;
                   border-radius:8px;font-size:14px;outline:none;
                   transition:border-color .15s;"
                   onfocus="this.style.borderColor = '#b45309'"
                   onblur="this.style.borderColor = '#e2e8f0'">
        </div>

        <div style="margin-bottom:20px;">
            <label style="font-size:13px;font-weight:500;display:block;margin-bottom:5px;">Ghi chú</label>
            <input type="text" id="editNote" name="note"
                   autocomplete="off" placeholder="Không bắt buộc"
                   style="width:100%;padding:9px 11px;border:1.5px solid #e2e8f0;
                   border-radius:8px;font-size:14px;outline:none;
                   transition:border-color .15s;"
                   onfocus="this.style.borderColor = '#b45309'"
                   onblur="this.style.borderColor = '#e2e8f0'">
        </div>

        <div style="display:flex;gap:10px;justify-content:flex-end;">
            <button type="button" onclick="closeEditModal()"
                    style="padding:9px 18px;border:1.5px solid #e2e8f0;border-radius:8px;
                    background:#fff;cursor:pointer;font-size:13.5px;font-weight:500;">
                Huỷ
            </button>
            <button type="submit"
                    style="padding:9px 18px;border:none;border-radius:8px;
                    background:#b45309;color:#fff;font-weight:600;
                    cursor:pointer;font-size:13.5px;">
                Lưu thay đổi
            </button>
        </div>
    </form>
</div>

<style>
    @keyframes fadeIn {
        from{
            opacity:0
        }
        to{
            opacity:1
        }
    }
    @keyframes popIn  {
        from{
            transform:translate(-50%,-50%) scale(.93);
            opacity:0
        }
        to  {
            transform:translate(-50%,-50%) scale(1);
            opacity:1
        }
    }
    .toast {
        display:flex;
        align-items:center;
        gap:10px;
        position:fixed;
        bottom:28px;
        right:28px;
        z-index:9999;
        padding:13px 18px;
        border-radius:10px;
        font-size:13.5px;
        font-weight:500;
        box-shadow:0 4px 20px rgba(0,0,0,.13);
        animation:slideUp .3s ease;
        max-width:360px;
    }
    .toast-success{
        background:#e9faf3;
        color:#0d6e4e;
        border:1px solid #a8e6ce;
    }
    .toast-warn   {
        background:#fff8ec;
        color:#8a5700;
        border:1px solid #ffd98a;
    }
    @keyframes slideUp{
        from{
            transform:translateY(20px);
            opacity:0
        }
        to{
            transform:translateY(0);
            opacity:1
        }
    }
</style>

<script>
    function openDeleteModal(id, name) {
        document.getElementById('deleteId').value = id;
        document.getElementById('deleteModalMsg').textContent =
                'Bản ghi "' + name + '" sẽ bị xoá và tồn kho được hoàn lại. Không thể hoàn tác.';
        document.getElementById('deleteOverlay').style.display = 'block';
        document.getElementById('deleteModal').style.display = 'block';
    }
    function closeDeleteModal() {
        document.getElementById('deleteOverlay').style.display = 'none';
        document.getElementById('deleteModal').style.display = 'none';
    }
    function openEditModal(id, name, qty, unit, note) {
        document.getElementById('editId').value = id;
        document.getElementById('editIngName').textContent = name;
        document.getElementById('editQty').value = qty;
        document.getElementById('editUnit').textContent = unit;
        document.getElementById('editNote').value = (!note || note === 'null') ? '' : note;
        document.getElementById('editOverlay').style.display = 'block';
        document.getElementById('editModal').style.display = 'block';
        setTimeout(function () {
            document.getElementById('editQty').select();
        }, 80);
    }
    function closeEditModal() {
        document.getElementById('editOverlay').style.display = 'none';
        document.getElementById('editModal').style.display = 'none';
    }
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') {
            closeEditModal();
            closeDeleteModal();
        }
    });
    /* Toast tự ẩn sau 4s */
    (function () {
        var t = document.getElementById('toastMsg');
        if (t)
            setTimeout(function () {
                t.style.opacity = '0';
                setTimeout(function () {
                    t.remove();
                }, 300);
            }, 4000);
    })();
</script>

<jsp:include page="/views/common/footer.jsp" />
