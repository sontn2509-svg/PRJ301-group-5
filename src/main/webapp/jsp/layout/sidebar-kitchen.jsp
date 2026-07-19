<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ taglib prefix="c" uri="jakarta.tags.core" %><%
    String currentUri = request.getRequestURI();
    String ctx = request.getContextPath();
%>
<aside class="sidebar">
<div class="sidebar-header">
<div class="sidebar-logo"><i class="fas fa-utensils"></i></div>
<h3 class="sidebar-title">KindergartenKitchen</h3>
<span class="sidebar-subtitle">Nhân viên bếp</span>
</div>
<nav class="sidebar-nav">
<div class="nav-section-label">Chính</div>
<div class="nav-item"><a href="<%= ctx %>/kitchen/dashboard" class="<%= currentUri.contains("dashboard") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-home"></i></span><span>Tổng quan</span></a></div>
<div class="nav-item"><a href="<%= ctx %>/kitchen/meal-count" class="<%= currentUri.contains("meal-count") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-calculator"></i></span><span>Đếm suất ăn</span></a></div>
<div class="nav-item"><a href="<%= ctx %>/kitchen/meal-history" class="<%= currentUri.contains("meal-history") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-history"></i></span><span>Lịch sử bếp</span></a></div>
<div class="nav-section-label">Quản lý</div>
<div class="nav-item"><a href="<%= ctx %>/kitchen/ingredients" class="<%= currentUri.contains("ingredients") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-carrot"></i></span><span>Nguyên liệu & Kho</span></a></div>
<div class="nav-section-label">Tài khoản</div>
<div class="nav-item"><a href="<%= ctx %>/kitchen/change-password" class="<%= currentUri.contains("change-password") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-key"></i></span><span>Đổi mật khẩu</span></a></div>
</nav>
<div class="sidebar-footer">
<form method="post" action="<%= ctx %>/logout" style="margin:0">
<button type="submit" class="logout-btn"><span class="nav-icon"><i class="fas fa-sign-out-alt"></i></span><span>Đăng xuất</span></button>
</form>
</div>
</aside>
