<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<aside class="sidebar">
    <div class="sidebar-header">
        <div class="sidebar-logo">
            <i class="fas fa-utensils"></i>
        </div>
        <h3 class="sidebar-title">KindergartenKitchen</h3>
        <span class="sidebar-subtitle">Bếp ăn mầm non</span>
    </div>
    
    <nav class="sidebar-nav">
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="${fn:contains(pageContext.request.requestURI, 'dashboard') ? 'active' : ''}">
                <span class="nav-icon"><i class="fas fa-home"></i></span>
                <span>Tổng quan</span>
            </a>
        </div>
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/users" class="${fn:contains(pageContext.request.requestURI, 'users') ? 'active' : ''}">
                <span class="nav-icon"><i class="fas fa-users"></i></span>
                <span>Người dùng</span>
            </a>
        </div>
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/logs" class="${fn:contains(pageContext.request.requestURI, 'logs') ? 'active' : ''}">
                <span class="nav-icon"><i class="fas fa-history"></i></span>
                <span>Nhật ký hệ thống</span>
            </a>
        </div>
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/change-password" class="${fn:contains(pageContext.request.requestURI, 'change-password') ? 'active' : ''}">
                <span class="nav-icon"><i class="fas fa-key"></i></span>
                <span>Đổi mật khẩu</span>
            </a>
        </div>
    </nav>
    
    <div style="position: absolute; bottom: 0; left: 0; right: 0; padding: 20px; border-top: 1px solid rgba(255,255,255,0.2);">
        <a href="${pageContext.request.contextPath}/logout" style="display: flex; align-items: center; gap: 10px; color: white; text-decoration: none; padding: 12px; border-radius: 10px; transition: all 0.3s ease;" 
           onmouseover="this.style.background='rgba(255,255,255,0.2)'" 
           onmouseout="this.style.background='transparent'">
            <span style="width: 36px; height: 36px; background: rgba(255,255,255,0.2); border-radius: 10px; display: flex; align-items: center; justify-content: center;">
                <i class="fas fa-sign-out-alt"></i>
            </span>
            <span style="font-weight: 600;">Đăng xuất</span>
        </a>
    </div>
</aside>
