<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tổng quan - KindergartenKitchen</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, sans-serif; font-size: 14px; line-height: 1.6; color: #7c2d12; background: #fffbf5; min-height: 100vh; }
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
        
        /* ===== PAGE HEADER CARD with Food Images ===== */
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
        
        /* Food image decorations */
        .page-header-card::before {
            content: '';
            position: absolute;
            inset: 0;
            background: 
                url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='60' height='60' viewBox='0 0 24 24' fill='none' stroke='%23fb923c' stroke-width='0.5' opacity='0.1'%3E%3Cpath d='M18 8h1a4 4 0 0 1 0 8h-1'/%3E%3Cpath d='M2 8h16v9a4 4 0 0 1-4 4H6a4 4 0 0 1-4-4V8z'/%3E%3Cline x1='6' y1='1' x2='6' y2='4'/%3E%3Cline x1='10' y1='1' x2='10' y2='4'/%3E%3Cline x1='14' y1='1' x2='14' y2='4'/%3E%3C/svg%3E") no-repeat top right,
                url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='50' height='50' viewBox='0 0 24 24' fill='none' stroke='%23ea580c' stroke-width='0.5' opacity='0.08'%3E%3Cpath d='M12 2L2 7l10 5 10-5-10-5z'/%3E%3Cpath d='M2 17l10 5 10-5'/%3E%3Cpath d='M2 12l10 5 10-5'/%3E%3C/svg%3E") no-repeat bottom left,
                url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='40' height='40' viewBox='0 0 24 24' fill='none' stroke='%23fb923c' stroke-width='0.5' opacity='0.06'%3E%3Cpath d='M12 3v18'/%3E%3Cpath d='M3 12h18'/%3E%3Ccircle cx='12' cy='12' r='9'/%3E%3C/svg%3E") no-repeat top left;
            pointer-events: none;
        }
        
        .page-header-card::after {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 100%;
            height: 100%;
            background: radial-gradient(ellipse at center, rgba(251, 146, 60, 0.1) 0%, transparent 70%);
            pointer-events: none;
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
        
        .stat-content h3 { font-size: 28px; font-weight: 800; color: #9a3412; line-height: 1; margin-bottom: 4px; }
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
        
        .btn-ghost {
            background: transparent;
            color: #9a3412;
            border-color: rgba(249, 115, 22, 0.2);
        }
        
        .btn-ghost:hover { background: rgba(249, 115, 22, 0.08); color: #ea580c; border-color: rgba(249, 115, 22, 0.3); }
        
        .btn-sm { padding: 6px 12px; font-size: 11px; }
        
        /* ===== EMPTY STATE ===== */
        .empty-state { text-align: center; padding: 40px 24px; }
        .empty-state .icon { font-size: 42px; margin-bottom: 14px; opacity: 0.4; color: #ea580c; }
        .empty-state h4 { font-size: 15px; font-weight: 700; color: #9a3412; margin-bottom: 5px; }
        .empty-state p { font-size: 12px; color: #c2410c; }
        
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(16px); } to { opacity: 1; transform: translateY(0); } }
        .page-header-card, .panel, .stat-card { animation: fadeInUp 0.4s ease forwards; }
        .page-header-card { animation-delay: 0s; }
        .stat-card:nth-child(1) { animation-delay: 0.05s; }
        .stat-card:nth-child(2) { animation-delay: 0.1s; }
        .stat-card:nth-child(3) { animation-delay: 0.15s; }
        .stat-card:nth-child(4) { animation-delay: 0.2s; }
        
        @media (max-width: 1024px) { .stats-grid { grid-template-columns: repeat(2, 1fr); } }
        @media (max-width: 768px) { .sidebar { transform: translateX(-100%); } .main-content { margin-left: 0; } .page-content { padding: 20px 16px; } .header { padding: 0 16px; } }
    </style>
</head>
<body>
    <div class="app-container">
        <aside class="sidebar">
            <div class="sidebar-header">
                <div class="sidebar-logo"><i class="fas fa-utensils"></i></div>
                <h3 class="sidebar-title">KindergartenKitchen</h3>
                <span class="sidebar-subtitle">Quản lý bếp ăn</span>
            </div>
            <nav class="sidebar-nav">
                <div class="nav-section-label">Chính</div>
                <div class="nav-item"><a href="${pageContext.request.contextPath}/admin/dashboard" class="active"><span class="nav-icon"><i class="fas fa-home"></i></span><span>Tổng quan</span></a></div>
                <div class="nav-item"><a href="${pageContext.request.contextPath}/admin/users"><span class="nav-icon"><i class="fas fa-users"></i></span><span>Người dùng</span></a></div>
                <div class="nav-item"><a href="${pageContext.request.contextPath}/admin/logs"><span class="nav-icon"><i class="fas fa-history"></i></span><span>Nhật ký hệ thống</span></a></div>
                <div class="nav-section-label">Tài khoản</div>
                <div class="nav-item"><a href="${pageContext.request.contextPath}/admin/change-password"><span class="nav-icon"><i class="fas fa-key"></i></span><span>Đổi mật khẩu</span></a></div>
            </nav>
            <div class="sidebar-footer">
                <form method="post" action="${pageContext.request.contextPath}/logout" style="margin: 0;"><button type="submit" class="logout-btn"><span class="nav-icon"><i class="fas fa-sign-out-alt"></i></span><span>Đăng xuất</span></button></form>
            </div>
        </aside>
        <div class="main-content">
            <header class="header">
                <div class="header-greeting"><h2>Xin chào, ${sessionScope.authUser.fullName}!</h2><span>Chào mừng đến với hệ thống quản lý bếp ăn</span></div>
                <div class="header-right">
                    <div class="header-date"><i class="far fa-calendar-alt"></i><span id="currentDate"></span></div>
                    <div class="header-user">
                        <div class="user-avatar">${sessionScope.authUser.roleName == 'Admin' ? 'A' : sessionScope.authUser.roleName == 'Manager' ? 'M' : sessionScope.authUser.roleName == 'Teacher' ? 'T' : sessionScope.authUser.roleName == 'Parent' ? 'P' : 'U'}</div>
                        <div class="user-info"><span class="user-name"><c:out value="${sessionScope.authUser.fullName}"/></span><span class="user-role"><c:out value="${sessionScope.authUser.roleName}"/></span></div>
                    </div>
                </div>
            </header>
            <main class="page-content">
                <div class="page-header-card">
                    <div class="page-header-content">
                        <div class="page-header-icon"><i class="fas fa-chart-pie"></i></div>
                        <div><h1>Tổng quan hệ thống</h1><p>Quản lý tài khoản, phân quyền và theo dõi nhật ký hoạt động</p></div>
                    </div>
                </div>
                <c:if test="${not empty alertMessage}">
                    <div class="alert-card ${alertType == 'danger' ? 'danger' : alertType == 'success' ? 'success' : 'info'}">
                        <span class="alert-icon"><c:choose><c:when test="${alertType == 'danger'}"><i class="fas fa-exclamation-circle"></i></c:when><c:when test="${alertType == 'success'}"><i class="fas fa-check-circle"></i></c:when><c:otherwise><i class="fas fa-info-circle"></i></c:otherwise></c:choose></span>
                        <div><strong style="font-size: 14px;">${alertTitle}</strong><p style="margin-top: 4px;">${alertMessage}</p></div>
                    </div>
                </c:if>
                <div class="stats-grid">
                    <div class="stat-card green"><div class="stat-icon"><i class="fas fa-users"></i></div><div class="stat-content"><h3><c:out value="${totalUsers}"/></h3><p>Tổng tài khoản</p></div></div>
                    <div class="stat-card blue"><div class="stat-icon"><i class="fas fa-user-check"></i></div><div class="stat-content"><h3><c:out value="${activeUsers}"/></h3><p>Đang hoạt động</p></div></div>
                    <div class="stat-card orange"><div class="stat-icon"><i class="fas fa-user-clock"></i></div><div class="stat-content"><h3><c:out value="${pendingUsers}"/></h3><p>Đang chờ duyệt</p></div></div>
                    <div class="stat-card red"><div class="stat-icon"><i class="fas fa-user-slash"></i></div><div class="stat-content"><h3><c:out value="${blockedUsers}"/></h3><p>Tài khoản bị khóa</p></div></div>
                </div>
                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title"><span class="icon"><i class="fas fa-history"></i></span>Nhật ký hoạt động gần đây</div>
                        <a href="${pageContext.request.contextPath}/admin/logs" class="btn btn-outline btn-sm">Xem tất cả <i class="fas fa-arrow-right"></i></a>
                    </div>
                    <div class="panel-body" style="padding: 0;">
                        <div class="table-container">
                            <table>
                                <thead><tr><th>Thời gian</th><th>Người dùng</th><th>Hành động</th><th>Mô tả</th></tr></thead>
                                <tbody>
                                    <c:forEach var="log" items="${latestLogs}">
                                        <tr><td><span style="color: #c2410c; font-size: 11px; opacity: 0.7;"><i class="far fa-clock" style="margin-right: 5px;"></i><c:out value="${log.createdAt}"/></span></td><td><strong style="font-weight: 600; color: #ea580c;"><i class="fas fa-user" style="margin-right: 6px; font-size: 10px;"></i><c:out value="${log.username}"/></strong></td><td><span class="badge badge-orange"><i class="fas fa-bolt" style="font-size: 9px;"></i> <c:out value="${log.action}"/></span></td><td style="color: #c2410c; font-size: 12px;"><c:out value="${log.description}"/></td></tr>
                                    </c:forEach>
                                    <c:if test="${empty latestLogs}"><tr><td colspan="4"><div class="empty-state"><div class="icon"><i class="fas fa-clipboard-list"></i></div><h4>Chưa có nhật ký</h4><p>Không có hoạt động nào được ghi nhận gần đây.</p></div></td></tr></c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px;">
                    <div class="panel">
                        <div class="panel-header"><div class="panel-title"><span class="icon"><i class="fas fa-bolt"></i></span>Thao tác nhanh</div></div>
                        <div class="panel-body">
                            <div style="display: flex; flex-direction: column; gap: 10px;">
                                <a href="${pageContext.request.contextPath}/admin/users/create" class="btn btn-primary" style="justify-content: flex-start;"><i class="fas fa-user-plus"></i> Tạo tài khoản mới</a>
                                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-ghost" style="justify-content: flex-start;"><i class="fas fa-users-cog"></i> Quản lý người dùng</a>
                                <a href="${pageContext.request.contextPath}/admin/change-password" class="btn btn-ghost" style="justify-content: flex-start;"><i class="fas fa-key"></i> Đổi mật khẩu</a>
                            </div>
                        </div>
                    </div>
                    <div class="panel">
                        <div class="panel-header"><div class="panel-title"><span class="icon"><i class="fas fa-server"></i></span>Thông tin hệ thống</div></div>
                        <div class="panel-body">
                            <div style="display: flex; flex-direction: column; gap: 12px;">
                                <div style="display: flex; justify-content: space-between; align-items: center; padding-bottom: 12px; border-bottom: 1px solid rgba(249, 115, 22, 0.1);"><span style="color: #c2410c; font-size: 12px; font-weight: 600;">Phiên bản</span><span style="font-weight: 700; color: #9a3412; font-size: 13px;">v1.0.0</span></div>
                                <div style="display: flex; justify-content: space-between; align-items: center; padding-bottom: 12px; border-bottom: 1px solid rgba(249, 115, 22, 0.1);"><span style="color: #c2410c; font-size: 12px; font-weight: 600;">Ngày cập nhật</span><span style="font-weight: 700; color: #9a3412; font-size: 13px;">18/06/2026</span></div>
                                <div style="display: flex; justify-content: space-between; align-items: center;"><span style="color: #c2410c; font-size: 12px; font-weight: 600;">Trạng thái</span><span class="badge badge-success"><i class="fas fa-circle" style="font-size: 6px;"></i> Hoạt động</span></div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
    <script>const dateEl = document.getElementById('currentDate'); const today = new Date(); const options = { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' }; dateEl.textContent = today.toLocaleDateString('vi-VN', options);</script>
</body>
</html>
