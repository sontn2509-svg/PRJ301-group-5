<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ taglib prefix="c" uri="jakarta.tags.core" %><%
    String currentUri = request.getRequestURI();
    String ctx = request.getContextPath();
%>
<style>
.sidebar{width:260px;background:#1e293b;color:#fff;position:fixed;top:0;left:0;height:100vh;overflow-y:auto;z-index:100;display:flex;flex-direction:column}
.sidebar-header{padding:24px 20px;text-align:center;border-bottom:1px solid rgba(255,255,255,0.1);background:linear-gradient(180deg,rgba(249,115,22,0.15) 0%,transparent 100%)}
.sidebar-logo{width:60px;height:60px;background:linear-gradient(135deg,#f97316,#fb923c);border-radius:16px;display:flex;align-items:center;justify-content:center;margin:0 auto 12px;font-size:28px;color:#fff;box-shadow:0 4px 16px rgba(249,115,22,0.3)}
.sidebar-title{font-size:16px;font-weight:700;margin-bottom:4px}
.sidebar-subtitle{font-size:12px;color:#94a3b8}
.sidebar-nav{padding:16px 12px;flex:1}
.nav-section-label{font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:1.5px;color:#64748b;padding:16px 12px 8px}
.nav-item{margin-bottom:4px}
.nav-item a{display:flex;align-items:center;gap:12px;padding:12px 14px;color:#94a3b8;text-decoration:none;border-radius:10px;font-weight:600;font-size:14px;transition:all 0.2s}
.nav-item a:hover{background:rgba(255,255,255,0.08);color:#fff}
.nav-item a.active{background:rgba(249,115,22,0.2);color:#fb923c}
.nav-icon{width:36px;height:36px;background:rgba(255,255,255,0.05);border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:16px;flex-shrink:0}
.nav-item a.active .nav-icon{background:linear-gradient(135deg,#f97316,#fb923c)}
.sidebar-footer{padding:16px 12px;border-top:1px solid rgba(255,255,255,0.08)}
.logout-btn{display:flex;align-items:center;gap:12px;padding:12px 14px;color:#94a3b8;border-radius:10px;font-weight:600;font-size:14px;width:100%;cursor:pointer;border:none;background:none;font-family:inherit;transition:all 0.2s}
.logout-btn:hover{background:rgba(239,68,68,0.15);color:#f87171}
.logout-btn .nav-icon{background:rgba(239,68,68,0.15)}
</style>
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
