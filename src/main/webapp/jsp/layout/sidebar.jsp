<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    
    body {
        font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, sans-serif;
        font-size: 14px;
        line-height: 1.6;
        color: #7c2d12;
        background: #fffbf5;
        min-height: 100vh;
    }
    
    .app-container { display: flex; min-height: 100vh; }
    
    /* ===== SIDEBAR - Light with Orange Accent ===== */
    .sidebar {
        width: 260px;
        background: #ffffff;
        border-right: 1px solid rgba(249, 115, 22, 0.1);
        color: #7c2d12;
        position: fixed;
        height: 100vh;
        overflow-y: auto;
        z-index: 100;
        display: flex;
        flex-direction: column;
        box-shadow: 4px 0 20px rgba(249, 115, 22, 0.05);
    }
    
    .sidebar::after {
        content: '';
        position: absolute;
        top: 0;
        right: 0;
        width: 1px;
        height: 100%;
        background: linear-gradient(180deg, rgba(249, 115, 22, 0.3) 0%, transparent 50%);
        pointer-events: none;
    }
    
    .sidebar-header {
        padding: 28px 24px;
        text-align: center;
        border-bottom: 1px solid rgba(249, 115, 22, 0.1);
        background: linear-gradient(180deg, rgba(251, 146, 60, 0.08) 0%, transparent 100%);
    }
    
    .sidebar-logo {
        width: 60px;
        height: 60px;
        background: linear-gradient(135deg, rgba(249, 115, 22, 0.2), rgba(251, 146, 60, 0.1));
        border: 1px solid rgba(249, 115, 22, 0.3);
        border-radius: 16px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 14px;
        font-size: 26px;
        color: #ea580c;
        box-shadow: 0 0 30px rgba(249, 115, 22, 0.15);
    }
    
    .sidebar-title { font-size: 15px; font-weight: 700; margin-bottom: 2px; color: #9a3412; letter-spacing: -0.3px; }
    .sidebar-subtitle { font-size: 11px; color: #c2410c; font-weight: 500; }
    
    .sidebar-nav { padding: 16px 12px; flex: 1; }
    
    .nav-section-label {
        font-size: 10px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 1.2px;
        color: #c2410c;
        padding: 12px 12px 6px;
        margin-top: 8px;
        opacity: 0.7;
    }
    
    .nav-item { margin-bottom: 4px; }
    
    .nav-item a {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 11px 14px;
        color: #9a3412;
        text-decoration: none;
        border-radius: 10px;
        font-weight: 600;
        font-size: 14px;
        transition: all 0.2s ease;
        border: 1px solid transparent;
    }
    
    .nav-item a:hover {
        background: rgba(249, 115, 22, 0.08);
        color: #ea580c;
        border-color: rgba(249, 115, 22, 0.1);
    }
    
    .nav-item a.active {
        background: rgba(249, 115, 22, 0.15);
        color: #ea580c;
        border-color: rgba(249, 115, 22, 0.2);
    }
    
    .nav-icon {
        width: 34px;
        height: 34px;
        background: rgba(249, 115, 22, 0.08);
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 14px;
        transition: all 0.2s ease;
        color: #ea580c;
    }
    
    .nav-item a:hover .nav-icon { background: rgba(249, 115, 22, 0.15); }
    .nav-item a.active .nav-icon { background: rgba(249, 115, 22, 0.25); }
    
    .sidebar-footer { padding: 16px 12px; border-top: 1px solid rgba(249, 115, 22, 0.1); }
    
    .logout-btn {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 11px 14px;
        color: #9a3412;
        border-radius: 10px;
        font-weight: 600;
        font-size: 14px;
        width: 100%;
        cursor: pointer;
        border: none;
        background: none;
        font-family: inherit;
        transition: all 0.2s ease;
    }
    
    .logout-btn:hover {
        background: rgba(239, 68, 68, 0.1);
        color: #dc2626;
    }
    
    /* ===== MAIN CONTENT ===== */
    .main-content {
        flex: 1;
        margin-left: 260px;
        min-height: 100vh;
        display: flex;
        flex-direction: column;
        background: #fffbf5;
    }
    
    /* ===== HEADER ===== */
    .header {
        background: #ffffff;
        height: 68px;
        padding: 0 32px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        border-bottom: 1px solid rgba(249, 115, 22, 0.1);
        position: sticky;
        top: 0;
        z-index: 50;
        box-shadow: 0 2px 10px rgba(249, 115, 22, 0.05);
    }
    
    .header-left { display: flex; align-items: center; gap: 16px; }
    .header-greeting { display: flex; flex-direction: column; }
    .header-greeting h2 { font-size: 17px; font-weight: 700; color: #9a3412; line-height: 1.3; }
    .header-greeting span { font-size: 12px; color: #c2410c; font-weight: 500; }
    
    .header-right { display: flex; align-items: center; gap: 14px; }
    
    .header-date {
        display: flex;
        align-items: center;
        gap: 6px;
        padding: 6px 12px;
        background: rgba(249, 115, 22, 0.08);
        border: 1px solid rgba(249, 115, 22, 0.1);
        border-radius: 999px;
        font-size: 12px;
        font-weight: 600;
        color: #ea580c;
    }
    
    .header-user {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 5px 12px 5px 5px;
        background: rgba(249, 115, 22, 0.08);
        border: 1px solid rgba(249, 115, 22, 0.1);
        border-radius: 999px;
        cursor: pointer;
        transition: all 0.2s ease;
    }
    
    .header-user:hover { border-color: rgba(249, 115, 22, 0.2); }
    
    .user-avatar {
        width: 34px;
        height: 34px;
        background: linear-gradient(135deg, #ea580c, #fb923c);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: 800;
        font-size: 13px;
        box-shadow: 0 0 20px rgba(234, 88, 12, 0.3);
    }
    
    .user-info { display: flex; flex-direction: column; }
    .user-name { font-weight: 700; font-size: 12px; color: #9a3412; line-height: 1.2; }
    .user-role { font-size: 10px; color: #ea580c; font-weight: 600; }
    
    /* ===== PAGE CONTENT ===== */
    .page-content { padding: 28px 32px; flex: 1; }
    
    /* ===== PAGE HEADER CARD ===== */
    .page-header-card {
        background: linear-gradient(135deg, rgba(251, 146, 60, 0.2) 0%, rgba(253, 186, 116, 0.1) 100%);
        border: 1px solid rgba(249, 115, 22, 0.2);
        border-radius: 16px;
        padding: 24px 28px;
        margin-bottom: 28px;
        position: relative;
        overflow: hidden;
        box-shadow: 0 0 40px rgba(249, 115, 22, 0.1);
    }
    
    .page-header-card::before {
        content: '';
        position: absolute;
        inset: 0;
        background: radial-gradient(ellipse at 90% 50%, rgba(251, 146, 60, 0.15) 0%, transparent 60%);
    }
    
    .page-header-content {
        display: flex;
        align-items: center;
        gap: 18px;
        position: relative;
        z-index: 1;
    }
    
    .page-header-icon {
        width: 54px;
        height: 54px;
        background: linear-gradient(135deg, rgba(249, 115, 22, 0.3), rgba(251, 146, 60, 0.2));
        border: 1px solid rgba(249, 115, 22, 0.3);
        border-radius: 14px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 22px;
        color: #ea580c;
        box-shadow: 0 0 30px rgba(249, 115, 22, 0.2);
    }
    
    .page-header-content h1 { font-size: 20px; font-weight: 800; color: #9a3412; letter-spacing: -0.3px; margin-bottom: 3px; }
    .page-header-content p { color: #c2410c; font-size: 13px; font-weight: 500; }
    
    /* ===== ALERT ===== */
    .alert-card {
        border-radius: 12px;
        padding: 14px 18px;
        margin-bottom: 24px;
        display: flex;
        align-items: flex-start;
        gap: 12px;
        font-size: 13px;
        font-weight: 500;
        border: 1px solid;
    }
    
    .alert-card.danger { background: rgba(239, 68, 68, 0.1); border-color: rgba(239, 68, 68, 0.3); color: #dc2626; }
    .alert-card.success { background: rgba(34, 197, 94, 0.1); border-color: rgba(34, 197, 94, 0.3); color: #16a34a; }
    .alert-card.info { background: rgba(251, 146, 60, 0.1); border-color: rgba(251, 146, 60, 0.3); color: #ea580c; }
    .alert-icon { font-size: 18px; margin-top: 1px; }
    
    /* ===== STATS GRID ===== */
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 18px;
        margin-bottom: 28px;
    }
    
    .stat-card {
        background: #ffffff;
        border: 1px solid rgba(249, 115, 22, 0.1);
        border-radius: 14px;
        padding: 20px;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 16px;
        position: relative;
        overflow: hidden;
        box-shadow: 0 2px 10px rgba(249, 115, 22, 0.05);
    }
    
    .stat-card:hover {
        transform: translateY(-3px);
        border-color: rgba(249, 115, 22, 0.2);
        box-shadow: 0 8px 24px rgba(249, 115, 22, 0.1);
    }
    
    .stat-card.green { border-left: 3px solid #22c55e; }
    .stat-card.blue { border-left: 3px solid #3b82f6; }
    .stat-card.orange { border-left: 3px solid #ea580c; }
    .stat-card.red { border-left: 3px solid #ef4444; }
    
    .stat-icon {
        width: 48px;
        height: 48px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 20px;
        flex-shrink: 0;
    }
    
    .stat-card.green .stat-icon { background: rgba(34, 197, 94, 0.15); color: #22c55e; }
    .stat-card.blue .stat-icon { background: rgba(59, 130, 246, 0.15); color: #3b82f6; }
    .stat-card.orange .stat-icon { background: rgba(249, 115, 22, 0.15); color: #ea580c; }
    .stat-card.red .stat-icon { background: rgba(239, 68, 68, 0.15); color: #ef4444; }
    
    .stat-content h3 {
        font-size: 28px;
        font-weight: 800;
        color: #9a3412;
        line-height: 1;
        margin-bottom: 4px;
    }
    
    .stat-content p { color: #c2410c; font-size: 12px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }
    
    /* ===== PANEL ===== */
    .panel {
        background: #ffffff;
        border: 1px solid rgba(249, 115, 22, 0.1);
        border-radius: 14px;
        overflow: hidden;
        margin-bottom: 24px;
        transition: all 0.25s ease;
        box-shadow: 0 2px 10px rgba(249, 115, 22, 0.05);
    }
    
    .panel:hover { border-color: rgba(249, 115, 22, 0.15); }
    
    .panel-header {
        padding: 16px 22px;
        border-bottom: 1px solid rgba(249, 115, 22, 0.1);
        display: flex;
        align-items: center;
        justify-content: space-between;
        background: rgba(249, 115, 22, 0.02);
    }
    
    .panel-title {
        display: flex;
        align-items: center;
        gap: 10px;
        font-size: 14px;
        font-weight: 700;
        color: #9a3412;
    }
    
    .panel-title .icon {
        width: 34px;
        height: 34px;
        background: rgba(249, 115, 22, 0.15);
        border: 1px solid rgba(249, 115, 22, 0.2);
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #ea580c;
        font-size: 14px;
    }
    
    .panel-body { padding: 22px; }
    
    /* ===== FORM ===== */
    .form-group { margin-bottom: 18px; }
    .form-group:last-child { margin-bottom: 0; }
    
    .form-label {
        display: block;
        font-weight: 700;
        font-size: 12px;
        margin-bottom: 8px;
        color: #9a3412;
    }
    
    .form-control {
        width: 100%;
        padding: 11px 14px;
        border: 1px solid rgba(249, 115, 22, 0.2);
        border-radius: 10px;
        font-family: inherit;
        font-size: 14px;
        color: #7c2d12;
        background: #fffbf5;
        transition: all 0.3s ease;
        outline: none;
    }
    
    .form-control::placeholder { color: #c2410c; opacity: 0.5; }
    
    .form-control:focus {
        border-color: rgba(249, 115, 22, 0.6);
        background: #ffffff;
        box-shadow: 0 0 0 3px rgba(249, 115, 22, 0.1);
    }
    
    .form-control:disabled { background: rgba(249, 115, 22, 0.05); color: #c2410c; cursor: not-allowed; }
    
    .form-select {
        appearance: none;
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='%23ea580c' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14L2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
        background-repeat: no-repeat;
        background-position: right 12px center;
        background-color: #fffbf5;
        padding-right: 38px;
        cursor: pointer;
        height: 44px;
    }
    
    .form-select:focus {
        border-color: rgba(249, 115, 22, 0.6);
        background-color: #ffffff;
        box-shadow: 0 0 0 3px rgba(249, 115, 22, 0.1);
    }
    
    select option { background: #fffbf5; color: #7c2d12; padding: 10px; }
    select option:hover { background: rgba(249, 115, 22, 0.15); }
    
    /* ===== TABLE ===== */
    .table-container { overflow-x: auto; }
    table { width: 100%; border-collapse: separate; border-spacing: 0; }
    
    thead th {
        background: rgba(249, 115, 22, 0.05);
        color: #c2410c;
        font-weight: 700;
        font-size: 10px;
        text-transform: uppercase;
        letter-spacing: 0.8px;
        padding: 12px 14px;
        text-align: left;
        border-bottom: 1px solid rgba(249, 115, 22, 0.1);
    }
    
    tbody tr { 
        transition: all 0.15s ease; 
        background: transparent;
        border-bottom: 1px solid rgba(249, 115, 22, 0.05);
    }
    
    tbody tr:nth-child(even) { background: rgba(249, 115, 22, 0.02); }
    tbody tr:last-child { border-bottom: none; }
    tbody tr:hover { background: rgba(249, 115, 22, 0.05); }
    tbody td { padding: 12px 14px; vertical-align: middle; font-size: 13px; color: #9a3412; }
    
    /* ===== BADGES ===== */
    .badge {
        display: inline-flex;
        align-items: center;
        gap: 4px;
        padding: 3px 9px;
        border-radius: 999px;
        font-size: 11px;
        font-weight: 700;
        white-space: nowrap;
        border: 1px solid;
    }
    
    .badge-success { background: rgba(34, 197, 94, 0.15); border-color: rgba(34, 197, 94, 0.3); color: #16a34a; }
    .badge-warning { background: rgba(251, 146, 60, 0.15); border-color: rgba(251, 146, 60, 0.3); color: #ea580c; }
    .badge-danger { background: rgba(239, 68, 68, 0.15); border-color: rgba(239, 68, 68, 0.3); color: #dc2626; }
    .badge-info { background: rgba(59, 130, 246, 0.15); border-color: rgba(59, 130, 246, 0.3); color: #2563eb; }
    .badge-orange { background: rgba(249, 115, 22, 0.15); border-color: rgba(249, 115, 22, 0.3); color: #ea580c; }
    
    /* ===== BUTTONS ===== */
    .btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 6px;
        padding: 9px 16px;
        border-radius: 8px;
        font-family: inherit;
        font-weight: 700;
        font-size: 12px;
        cursor: pointer;
        transition: all 0.2s ease;
        border: 1px solid;
        text-decoration: none;
        white-space: nowrap;
    }
    
    .btn-primary {
        background: linear-gradient(135deg, #ea580c, #fb923c);
        color: white;
        border-color: rgba(249, 115, 22, 0.3);
        box-shadow: 0 4px 14px rgba(234, 88, 12, 0.2);
    }
    
    .btn-primary:hover {
        transform: translateY(-1px);
        box-shadow: 0 6px 20px rgba(234, 88, 12, 0.3);
        filter: brightness(1.05);
    }
    
    .btn-outline {
        background: transparent;
        border-color: rgba(249, 115, 22, 0.4);
        color: #ea580c;
    }
    
    .btn-outline:hover { background: rgba(249, 115, 22, 0.1); color: #c2410c; }
    
    .btn-accent {
        background: linear-gradient(135deg, #ea580c, #fb923c);
        color: white;
        border-color: rgba(249, 115, 22, 0.3);
        box-shadow: 0 4px 14px rgba(234, 88, 12, 0.2);
    }
    
    .btn-accent:hover { transform: translateY(-1px); box-shadow: 0 6px 20px rgba(234, 88, 12, 0.3); }
    
    .btn-danger {
        background: linear-gradient(135deg, #ef4444, #f87171);
        color: white;
        border-color: rgba(239, 68, 68, 0.3);
        box-shadow: 0 4px 14px rgba(239, 68, 68, 0.2);
    }
    
    .btn-danger:hover { transform: translateY(-1px); box-shadow: 0 6px 20px rgba(239, 68, 68, 0.3); }
    
    .btn-ghost {
        background: transparent;
        color: #9a3412;
        border-color: rgba(249, 115, 22, 0.2);
    }
    
    .btn-ghost:hover { background: rgba(249, 115, 22, 0.08); color: #ea580c; border-color: rgba(249, 115, 22, 0.3); }
    
    .btn-sm { padding: 6px 12px; font-size: 11px; }
    .btn-icon { width: 32px; height: 32px; padding: 0; }
    
    /* ===== AVATAR ===== */
    .avatar-sm {
        width: 30px;
        height: 30px;
        border-radius: 50%;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        font-size: 11px;
        font-weight: 800;
        color: white;
        background: linear-gradient(135deg, #ea580c, #fb923c);
        flex-shrink: 0;
    }
    
    /* ===== EMPTY STATE ===== */
    .empty-state { text-align: center; padding: 40px 24px; }
    .empty-state .icon { font-size: 42px; margin-bottom: 14px; opacity: 0.4; color: #ea580c; }
    .empty-state h4 { font-size: 15px; font-weight: 700; color: #9a3412; margin-bottom: 5px; }
    .empty-state p { font-size: 12px; color: #c2410c; }
    
    /* ===== ANIMATIONS ===== */
    @keyframes fadeInUp {
        from { opacity: 0; transform: translateY(16px); }
        to { opacity: 1; transform: translateY(0); }
    }
    
    .page-header-card, .panel, .stat-card { animation: fadeInUp 0.4s ease forwards; }
    .page-header-card { animation-delay: 0s; }
    .stat-card:nth-child(1) { animation-delay: 0.05s; }
    .stat-card:nth-child(2) { animation-delay: 0.1s; }
    .stat-card:nth-child(3) { animation-delay: 0.15s; }
    .stat-card:nth-child(4) { animation-delay: 0.2s; }
    
    /* ===== RESPONSIVE ===== */
    @media (max-width: 1024px) { .stats-grid { grid-template-columns: repeat(2, 1fr); } }
    @media (max-width: 768px) {
        .sidebar { transform: translateX(-100%); }
        .main-content { margin-left: 0; }
        .page-content { padding: 20px 16px; }
        .header { padding: 0 16px; }
    }
</style>

<aside class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <div class="sidebar-logo"><i class="fas fa-utensils"></i></div>
        <h3 class="sidebar-title">KindergartenKitchen</h3>
        <span class="sidebar-subtitle">Quản lý bếp ăn</span>
    </div>

    <nav class="sidebar-nav">
        <div class="nav-section-label">Chính</div>
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/dashboard"
               class="${fn:contains(pageContext.request.requestURI, 'dashboard') ? 'active' : ''}">
                <span class="nav-icon"><i class="fas fa-home"></i></span>
                <span>Tổng quan</span>
            </a>
        </div>
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/users"
               class="${fn:contains(pageContext.request.requestURI, 'users') ? 'active' : ''}">
                <span class="nav-icon"><i class="fas fa-users"></i></span>
                <span>Người dùng</span>
            </a>
        </div>
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/logs"
               class="${fn:contains(pageContext.request.requestURI, 'logs') ? 'active' : ''}">
                <span class="nav-icon"><i class="fas fa-history"></i></span>
                <span>Nhật ký hệ thống</span>
            </a>
        </div>

        <div class="nav-section-label">Tài khoản</div>
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/change-password"
               class="${fn:contains(pageContext.request.requestURI, 'change-password') ? 'active' : ''}">
                <span class="nav-icon"><i class="fas fa-key"></i></span>
                <span>Đổi mật khẩu</span>
            </a>
        </div>
    </nav>

    <div class="sidebar-footer">
        <form method="post" action="${pageContext.request.contextPath}/logout" style="margin: 0;">
            <button type="submit" class="logout-btn">
                <span class="nav-icon"><i class="fas fa-sign-out-alt"></i></span>
                <span>Đăng xuất</span>
            </button>
        </form>
    </div>
</aside>
