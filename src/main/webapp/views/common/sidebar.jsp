<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    views/common/sidebar.jsp
    ------------------------------------------------------------------
    LAYOUT TẠM THỜI — chờ P1 (Auth/Admin/Hệ thống) bàn giao bản chính thức.
    Đây là "hợp đồng" giao diện: nếu P1 nộp file cùng tên/cùng vị trí,
    chỉ cần thay thế file này, các trang JSP của P4 KHÔNG cần sửa gì
    (miễn giữ class .app-sidebar, .app-sidebar__link, .is-active).

    Biến mong đợi có sẵn trong request/session khi P1 hoàn thiện:
      session: userId (Integer), username (String), role (String)
      role một trong: ADMIN, MANAGER, TEACHER, PARENT, KITCHEN_STAFF
    Tạm thời dùng giá trị mặc định nếu chưa có để demo độc lập được.
--%>
<%
    String role = (String) session.getAttribute("role");
    if (role == null) role = "KITCHEN_STAFF"; // mặc định demo cho module bếp
    String currentPath = request.getRequestURI();
%>
<aside class="app-sidebar" id="appSidebar">
    <div class="app-sidebar__brand">
        <div class="app-sidebar__brand-mark">KK</div>
        <div class="app-sidebar__brand-text">
            Kindergarten Kitchen
            <span>Quản lý bếp ăn bán trú</span>
        </div>
    </div>

    <nav>
        <div class="app-sidebar__group">
            <div class="app-sidebar__group-label">Tổng quan</div>
            <a class="app-sidebar__link" href="${pageContext.request.contextPath}/dashboard">
                <span class="app-sidebar__link-icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9.5 12 3l9 6.5V20a1 1 0 0 1-1 1h-5v-7H9v7H4a1 1 0 0 1-1-1Z"/></svg>
                </span>
                Trang chủ
            </a>
        </div>

        <% if ("ADMIN".equals(role) || "MANAGER".equals(role)) { %>
        <div class="app-sidebar__group">
            <div class="app-sidebar__group-label">Hệ thống &amp; Thực đơn</div>
            <a class="app-sidebar__link" href="${pageContext.request.contextPath}/user">
                <span class="app-sidebar__link-icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="4"/><path d="M4 21v-1a8 8 0 0 1 16 0v1"/></svg>
                </span>
                Người dùng
            </a>
            <a class="app-sidebar__link" href="${pageContext.request.contextPath}/menu">
                <span class="app-sidebar__link-icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 6h16M4 12h16M4 18h10"/></svg>
                </span>
                Thực đơn
            </a>
        </div>
        <% } %>

        <% if ("TEACHER".equals(role) || "ADMIN".equals(role) || "MANAGER".equals(role)) { %>
        <div class="app-sidebar__group">
            <div class="app-sidebar__group-label">Học sinh &amp; Điểm danh</div>
            <a class="app-sidebar__link" href="${pageContext.request.contextPath}/student">
                <span class="app-sidebar__link-icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19V5a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v14l-3-2-3 2-3-2-3 2-3-2Z"/></svg>
                </span>
                Học sinh / Lớp
            </a>
            <a class="app-sidebar__link" href="${pageContext.request.contextPath}/attendance">
                <span class="app-sidebar__link-icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 12 2 2 4-4M5 4h14a1 1 0 0 1 1 1v14a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1V5a1 1 0 0 1 1-1Z"/></svg>
                </span>
                Điểm danh
            </a>
        </div>
        <% } %>

        <% if ("PARENT".equals(role)) { %>
        <div class="app-sidebar__group">
            <div class="app-sidebar__group-label">Minh bạch bữa ăn</div>
            <a class="app-sidebar__link ${currentPath.contains('/transparency') ? 'is-active' : ''}"
               href="${pageContext.request.contextPath}/ingredient-import/transparency">
                <span class="app-sidebar__link-icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 3v12m0 0 4-4m-4 4-4-4M4 17v2a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-2"/></svg>
                </span>
                Nguyên liệu tuần này
            </a>
        </div>
        <% } %>

        <div class="app-sidebar__group">
            <div class="app-sidebar__group-label">Bếp &amp; Kho nguyên liệu</div>
            <a class="app-sidebar__link ${currentPath.contains('/ingredient/') ? 'is-active' : ''}"
               href="${pageContext.request.contextPath}/ingredient/list">
                <span class="app-sidebar__link-icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 3v18M3 8h4M3 13h4M14 3a4 4 0 0 1 4 4v2a4 4 0 0 1-4 4M18 21V13"/></svg>
                </span>
                Nguyên liệu
            </a>
            <% if ("ADMIN".equals(role) || "MANAGER".equals(role)) { %>
            <a class="app-sidebar__link ${currentPath.contains('/dish-ingredient') ? 'is-active' : ''}"
               href="${pageContext.request.contextPath}/dish-ingredient/list">
                <span class="app-sidebar__link-icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19V5a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v14l-3-2-3 2-3-2-3 2-3-2Z"/></svg>
                </span>
                Công thức món
            </a>
            <% } %>
            <a class="app-sidebar__link ${currentPath.contains('ingredient-import') ? 'is-active' : ''}"
               href="${pageContext.request.contextPath}/ingredient-import/list">
                <span class="app-sidebar__link-icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 3v12m0 0 4-4m-4 4-4-4M4 17v2a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-2"/></svg>
                </span>
                Nhập kho
            </a>
            <a class="app-sidebar__link ${currentPath.contains('ingredient-usage') ? 'is-active' : ''}"
               href="${pageContext.request.contextPath}/ingredient-usage/today">
                <span class="app-sidebar__link-icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2v6.5L3 14a2 2 0 0 0 1.8 3h14.4a2 2 0 0 0 1.8-3l-3-5.5V2M6 2h12M9 16h6"/></svg>
                </span>
                Sử dụng hôm nay
            </a>
            <a class="app-sidebar__link ${currentPath.contains('/notification') ? 'is-active' : ''}"
               href="${pageContext.request.contextPath}/notification">
                <span class="app-sidebar__link-icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 8a6 6 0 0 0-12 0c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.7 21a2 2 0 0 1-3.4 0"/></svg>
                </span>
                Thông báo
                <c:if test="${unreadCount != null && unreadCount > 0}">
                    <span class="app-sidebar__badge">${unreadCount}</span>
                </c:if>
            </a>
        </div>
    </nav>

    <div class="app-sidebar__footer">
        GitHub Flow · 4 thành viên<br>NetBeans 17 · Tomcat 10.5
    </div>
</aside>
