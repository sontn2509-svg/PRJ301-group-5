<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ taglib prefix="c" uri="jakarta.tags.core" %><%
    String currentUri = request.getRequestURI();
    String ctx = request.getContextPath();
%>
<aside class="sidebar">
<div class="sidebar-header">
<div class="sidebar-logo"><i class="fas fa-user-friends"></i></div>
<h3 class="sidebar-title">KindergartenKitchen</h3>
<span class="sidebar-subtitle">Phụ huynh</span>
</div>
<nav class="sidebar-nav">
<div class="nav-section-label">Chính</div>
<div class="nav-item"><a href="<%= ctx %>/parent/dashboard" class="<%= currentUri.contains("dashboard") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-home"></i></span><span>Tổng quan</span></a></div>
<div class="nav-item"><a href="<%= ctx %>/parent/my-children" class="<%= currentUri.contains("my-children") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-child"></i></span><span>Con em</span></a></div>
<div class="nav-item"><a href="<%= ctx %>/parent/absences" class="<%= currentUri.contains("absences") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-user-slash"></i></span><span>Xin nghỉ ăn</span></a></div>
<div class="nav-item"><a href="<%= ctx %>/parent/history" class="<%= currentUri.contains("history") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-history"></i></span><span>Lịch sử ăn</span></a></div>
<div class="nav-item"><a href="<%= ctx %>/parent/menu" class="<%= currentUri.contains("/parent/menu") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-calendar-week"></i></span><span>Thực đơn của con</span></a></div>
<div class="nav-item"><a href="<%= ctx %>/parent/transparency" class="<%= currentUri.contains("transparency") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-box-open"></i></span><span>Nguyên liệu tuần này</span></a></div>
<div class="nav-section-label">Tài khoản</div>
<div class="nav-item"><a href="<%= ctx %>/parent/change-password" class="<%= currentUri.contains("change-password") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-key"></i></span><span>Đổi mật khẩu</span></a></div>
</nav>
<div class="sidebar-footer">
<form method="post" action="<%= ctx %>/logout" style="margin:0">
<button type="submit" class="logout-btn"><span class="nav-icon"><i class="fas fa-sign-out-alt"></i></span><span>Đăng xuất</span></button>
</form>
</div>
</aside>
