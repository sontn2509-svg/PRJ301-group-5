<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ taglib prefix="c" uri="jakarta.tags.core" %><%
    String currentUri = request.getRequestURI();
    String ctx = request.getContextPath();
%>
<aside class="sidebar">
<div class="sidebar-header">
<div class="sidebar-logo"><i class="fas fa-shield-halved"></i></div>
<h3 class="sidebar-title">KindergartenKitchen</h3>
<span class="sidebar-subtitle">Quản trị viên</span>
</div>
<nav class="sidebar-nav">
<div class="nav-section-label">Chính</div>
<div class="nav-item"><a href="<%= ctx %>/admin/dashboard" class="<%= currentUri.contains("dashboard") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-home"></i></span><span>Tổng quan</span></a></div>
<div class="nav-item"><a href="<%= ctx %>/admin/users" class="<%= currentUri.contains("users") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-users"></i></span><span>Người dùng</span></a></div>
<div class="nav-item"><a href="<%= ctx %>/admin/logs" class="<%= currentUri.contains("logs") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-history"></i></span><span>Nhật ký hệ thống</span></a></div>
<div class="nav-section-label">Tài khoản</div>
<div class="nav-item"><a href="<%= ctx %>/admin/change-password" class="<%= currentUri.contains("change-password") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-key"></i></span><span>Đổi mật khẩu</span></a></div>
</nav>
<div class="sidebar-footer">
<form method="post" action="<%= ctx %>/logout">
<button type="submit" class="logout-btn"><span class="nav-icon"><i class="fas fa-sign-out-alt"></i></span><span>Đăng xuất</span></button>
</form>
</div>
</aside>
