<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ taglib prefix="c" uri="jakarta.tags.core" %><%
    String currentUri = request.getRequestURI();
    String ctx = request.getContextPath();
%>
<aside class="sidebar">
<div class="sidebar-header">
<div class="sidebar-logo"><i class="fas fa-chalkboard-teacher"></i></div>
<h3 class="sidebar-title">KindergartenKitchen</h3>
<span class="sidebar-subtitle">Giáo viên</span>
</div>
<nav class="sidebar-nav">
<div class="nav-section-label">Chính</div>
<div class="nav-item"><a href="<%= ctx %>/teacher/dashboard" class="<%= currentUri.contains("dashboard") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-home"></i></span><span>Tổng quan</span></a></div>
<div class="nav-item"><a href="<%= ctx %>/teacher/my-class" class="<%= currentUri.contains("my-class") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-users"></i></span><span>Lớp học</span></a></div>
<div class="nav-item"><a href="<%= ctx %>/teacher/attendance" class="<%= currentUri.contains("attendance") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-calendar-check"></i></span><span>Điểm danh</span></a></div>
<div class="nav-item"><a href="<%= ctx %>/teacher/absences" class="<%= currentUri.contains("absences") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-user-slash"></i></span><span>Xin nghỉ ăn</span></a></div>
<div class="nav-section-label">Tài khoản</div>
<div class="nav-item"><a href="<%= ctx %>/teacher/change-password" class="<%= currentUri.contains("change-password") ? "active" : "" %>"><span class="nav-icon"><i class="fas fa-key"></i></span><span>Đổi mật khẩu</span></a></div>
</nav>
<div class="sidebar-footer">
<form method="post" action="<%= ctx %>/logout" style="margin:0">
<button type="submit" class="logout-btn"><span class="nav-icon"><i class="fas fa-sign-out-alt"></i></span><span>Đăng xuất</span></button>
</form>
</div>
</aside>
