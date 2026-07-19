<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ taglib prefix="c" uri="jakarta.tags.core" %><%
    String currentUri = request.getRequestURI();
    String ctx = request.getContextPath();
%>
<aside class="sidebar">
<div class="sidebar-header">
<div class="sidebar-logo"><i class="fas fa-clipboard-list"></i></div>
<h3 class="sidebar-title">KindergartenKitchen</h3>
<span class="sidebar-subtitle">Quản lý bếp ăn</span>
</div>
<nav class="sidebar-nav">
<div class="nav-section-label">Chính</div>
<div class="nav-item"><a href="<%= ctx %>/manager/dashboard" class="<%= currentUri.contains("dashboard") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-home"></i></span><span>Tổng quan</span></a></div>
<div class="nav-item"><a href="<%= ctx %>/manager/classes" class="<%= currentUri.contains("classes") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-chalkboard"></i></span><span>Lớp học</span></a></div>
<div class="nav-item"><a href="<%= ctx %>/manager/students" class="<%= currentUri.contains("students") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-user-graduate"></i></span><span>Học sinh</span></a></div>
<div class="nav-item"><a href="<%= ctx %>/manager/attendance" class="<%= currentUri.contains("attendance") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-calendar-check"></i></span><span>Điểm danh</span></a></div>
<div class="nav-section-label">Thực đơn &amp; Món ăn</div>
<div class="nav-item"><a href="<%= ctx %>/menu/list" class="<%= currentUri.contains("/menu/") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-calendar-week"></i></span><span>Thực đơn tuần</span></a></div>
<div class="nav-item"><a href="<%= ctx %>/dish/list" class="<%= currentUri.contains("/dish/") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-utensils"></i></span><span>Món ăn</span></a></div>
<div class="nav-section-label">Bếp ăn</div>
<div class="nav-item"><a href="<%= ctx %>/manager/ingredients" class="<%= currentUri.contains("ingredients") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-carrot"></i></span><span>Nguyên liệu</span></a></div>
<div class="nav-item"><a href="<%= ctx %>/manager/meals" class="<%= currentUri.contains("meals") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-utensils"></i></span><span>Lịch sử bếp</span></a></div>
<div class="nav-section-label">Tài khoản</div>
<div class="nav-item"><a href="<%= ctx %>/manager/change-password" class="<%= currentUri.contains("change-password") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-key"></i></span><span>Đổi mật khẩu</span></a></div>
</nav>
<div class="sidebar-footer">
<form method="post" action="<%= ctx %>/logout" style="margin:0">
<button type="submit" class="logout-btn"><span class="nav-icon"><i class="fas fa-sign-out-alt"></i></span><span>Đăng xuất</span></button>
</form>
</div>
</aside>
