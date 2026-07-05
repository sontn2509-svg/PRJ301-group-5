<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%--
    /jsp/ingredient/notification-list.jsp
    Khớp với NotificationServlet:
      GET  /notification -> request.notificationList (List<UserNotification>), unreadCount
      POST /notification -> userNotificationId (đánh dấu đã đọc)
    Dùng chung cho mọi role.
--%>
<%
    request.setAttribute("pageTitle", "Thông báo");
    request.setAttribute("pageSub", "Cập nhật mới nhất liên quan đến công việc của bạn");
%>
<jsp:include page="/views/common/header.jsp" />

<div class="page-head">
    <div>
        <div class="page-head__eyebrow">Thông báo</div>
        <h1>Bảng tin của bạn</h1>
        <p class="page-head__desc">
            <c:choose>
                <c:when test="${unreadCount > 0}">Bạn có <strong>${unreadCount}</strong> thông báo chưa đọc.</c:when>
                <c:otherwise>Bạn đã đọc hết thông báo. Tuyệt vời!</c:otherwise>
            </c:choose>
        </p>
    </div>
    <%-- Nút "Đọc tất cả" chỉ hiện khi còn thông báo chưa đọc --%>
    <c:if test="${unreadCount > 0}">
        <button class="btn btn-ghost" onclick="markAllRead()">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3"><path d="m20 6-11 11-5-5"/></svg>
            Đánh dấu tất cả đã đọc
        </button>
    </c:if>
</div>

<%-- Form ẩn: submit từng cái bằng JS nếu muốn batch; tạm thời reload từng item --%>
<div id="markAllForms" style="display:none;">
    <c:forEach var="n" items="${notificationList}">
        <c:if test="${!n.read}">
            <form method="post" action="${pageContext.request.contextPath}/notification"
                  class="markReadForm">
                <input type="hidden" name="userNotificationId" value="${n.userNotificationId}">
            </form>
        </c:if>
    </c:forEach>
</div>

<c:if test="${not empty errorMessage}">
    <div class="alert alert-error">${errorMessage}</div>
</c:if>

<c:choose>
    <c:when test="${empty notificationList}">
        <div class="card">
            <div class="empty-state">
                <svg class="empty-state__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M18 8a6 6 0 0 0-12 0c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.7 21a2 2 0 0 1-3.4 0"/></svg>
                <h3>Chưa có thông báo nào</h3>
                <p>Khi có cập nhật về nhập kho, sử dụng nguyên liệu hay thực đơn, thông báo sẽ xuất hiện ở đây.</p>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="notif-list">
            <c:forEach var="n" items="${notificationList}">
                <c:set var="iconClass" value="type-system" />
                <c:if test="${n.notificationType == 'INGREDIENT_IMPORT'}"><c:set var="iconClass" value="type-import" /></c:if>
                <c:if test="${n.notificationType == 'INGREDIENT_USAGE'}"><c:set var="iconClass" value="type-usage" /></c:if>

                <div class="notif-item ${!n.read ? 'is-unread' : ''}">
                    <div class="notif-item__icon ${iconClass}">
                        <c:choose>
                            <c:when test="${n.notificationType == 'INGREDIENT_IMPORT'}">
                                <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 3v12m0 0 4-4m-4 4-4-4M4 17v2a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-2"/></svg>
                            </c:when>
                            <c:when test="${n.notificationType == 'INGREDIENT_USAGE'}">
                                <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2v6.5L3 14a2 2 0 0 0 1.8 3h14.4a2 2 0 0 0 1.8-3l-3-5.5V2M6 2h12M9 16h6"/></svg>
                            </c:when>
                            <c:otherwise>
                                <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 8a6 6 0 0 0-12 0c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.7 21a2 2 0 0 1-3.4 0"/></svg>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="notif-item__body">
                        <div class="notif-item__title">${n.title}</div>
                        <div class="notif-item__msg">${n.message}</div>
                        <div class="notif-item__time">
                            <c:choose>
                                <c:when test="${not empty n.createdAt}">
                                    <fmt:formatDate value="${n.createdAt}" type="both" pattern="dd/MM/yyyy HH:mm" />
                                </c:when>
                                <c:otherwise>&mdash;</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <c:if test="${!n.read}">
                        <form method="post" action="${pageContext.request.contextPath}/notification" class="notif-item__mark">
                            <input type="hidden" name="userNotificationId" value="${n.userNotificationId}">
                            <button type="submit" class="btn btn-ghost btn-sm">Đánh dấu đã đọc</button>
                        </form>
                    </c:if>
                </div>
            </c:forEach>
        </div>
    </c:otherwise>
</c:choose>


<c:if test="${param.marked == 'true'}">
    <div class="toast toast-success" id="notifToast" style="position:fixed;bottom:28px;right:28px;z-index:9999;display:flex;align-items:center;gap:10px;padding:13px 18px;border-radius:10px;font-size:13.5px;font-weight:500;box-shadow:0 4px 20px rgba(0,0,0,.13);background:#e9faf3;color:#0d6e4e;border:1px solid #a8e6ce;max-width:360px;animation:slideUp .3s ease;">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="m20 6-11 11-5-5"/></svg>
        Đã đánh dấu đã đọc.
        <button onclick="document.getElementById('notifToast').style.display='none'" style="margin-left:auto;background:none;border:none;font-size:18px;cursor:pointer;opacity:.6;">&times;</button>
    </div>
    <style>@keyframes slideUp{from{transform:translateY(20px);opacity:0}to{transform:translateY(0);opacity:1}}</style>
    <script>(function(){var t=document.getElementById('notifToast');if(t)setTimeout(function(){t.style.display='none'},4000);})()</script>
</c:if>

<script>
function markAllRead() {
    var forms = document.querySelectorAll('.markReadForm');
    if (forms.length === 0) return;
    /* Submit tuần tự: chỉ submit form cuối cùng thật sự,
       các form còn lại gửi bằng fetch để không reload nhiều lần */
    var fetches = [];
    for (var i = 0; i < forms.length - 1; i++) {
        var fd = new FormData(forms[i]);
        fetches.push(fetch(forms[i].action, { method: 'POST', body: fd }));
    }
    Promise.all(fetches).then(function() {
        /* Submit form cuối → redirect về trang với param marked=true */
        var last = forms[forms.length - 1];
        var input = document.createElement('input');
        input.type = 'hidden'; input.name = 'markAll'; input.value = 'true';
        last.appendChild(input);
        last.submit();
    });
}
</script>

<jsp:include page="/views/common/footer.jsp" />
