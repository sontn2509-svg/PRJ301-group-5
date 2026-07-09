<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
    views/common/header.jsp
    ------------------------------------------------------------------
    LAYOUT TẠM THỜI — chờ P1 bàn giao bản chính thức (giống sidebar.jsp).
    File này mở thẻ <html>, <head>, nạp CSS chung, và mở khung
    .app-shell + topbar. Mỗi trang JSP nội dung PHẢI đóng lại bằng
    views/common/footer.jsp ở cuối file.

    Biến mỗi trang JSP cần set TRƯỚC khi include file này:
      request.setAttribute("pageTitle", "Tiêu đề trang");
      request.setAttribute("pageSub", "Mô tả ngắn (tuỳ chọn)");
--%>
<%
    String pageTitle = (String) request.getAttribute("pageTitle");
    if (pageTitle == null) pageTitle = "Kindergarten Kitchen";
    String pageSub = (String) request.getAttribute("pageSub");

    com.mycompany.kindergartenkitchen.entity.User authUser =
    (com.mycompany.kindergartenkitchen.entity.User) session.getAttribute("authUser");
String username  = (authUser != null) ? authUser.getFullName() : "Người dùng";
String roleRaw   = (authUser != null && authUser.getRoleName() != null) 
                   ? authUser.getRoleName() : "";
String role;
switch (roleRaw) {
    case "Admin":       role = "ADMIN";         break;
    case "Manager":     role = "MANAGER";       break;
    case "Teacher":     role = "TEACHER";       break;
    case "Parent":      role = "PARENT";        break;
    case "KitchenStaff": role = "KITCHEN_STAFF"; break;
    default:            role = "KITCHEN_STAFF";
}

    String roleLabel;
    switch (role) {
        case "ADMIN": roleLabel = "Quản trị viên"; break;
        case "MANAGER": roleLabel = "Quản lý"; break;
        case "TEACHER": roleLabel = "Giáo viên"; break;
        case "PARENT": roleLabel = "Phụ huynh"; break;
        default: roleLabel = "Nhân viên bếp";
    }
    String initial = username.isEmpty() ? "?" : username.substring(0, 1).toUpperCase();
%><!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><%= pageTitle %> · Kindergarten Kitchen</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ingredient.css">
    </head>
    <body>
        <div class="app-shell">
            <jsp:include page="/views/common/sidebar.jsp" />

            <div class="app-main">
                <header class="app-topbar">
                    <div>
                        <div class="app-topbar__title"><%= pageTitle %></div>
                        <% if (pageSub != null) { %>
                        <div class="app-topbar__sub"><%= pageSub %></div>
                        <% } %>
                    </div>
                    <div class="app-topbar__right">
                        <a class="bell-btn" href="${pageContext.request.contextPath}/notification" title="Thông báo">
                            <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 8a6 6 0 0 0-12 0c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.7 21a2 2 0 0 1-3.4 0"/></svg>
                            <c:if test="${unreadCount != null && unreadCount > 0}">
                                <span class="bell-btn__dot"></span>
                            </c:if>
                        </a>
                        <div class="app-topbar__user">
                            <div class="app-topbar__user-avatar"><%= initial %></div>
                            <div>
                                <div class="app-topbar__user-name"><%= username %></div>
                                <div class="app-topbar__user-role"><%= roleLabel %></div>
                            </div>
                        </div>
                    </div>
                </header>

                <main class="app-content">
