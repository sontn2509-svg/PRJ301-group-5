<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nhật ký hệ thống - KindergartenKitchen</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; font-size: 14px; line-height: 1.6; color: #e4e4e7; background: #09090b; }
        .app-container { display: flex; min-height: 100vh; }
        .sidebar { width: 260px; background: rgba(15,15,20,0.98); border-right: 1px solid rgba(255,255,255,0.06); position: fixed; height: 100vh; overflow-y: auto; z-index: 100; display: flex; flex-direction: column; }
        .sidebar-header { padding: 28px 24px; text-align: center; border-bottom: 1px solid rgba(255,255,255,0.06); }
        .sidebar-logo { width: 60px; height: 60px; background: linear-gradient(135deg, rgba(139,92,246,0.2), rgba(167,139,250,0.1)); border: 1px solid rgba(139,92,246,0.3); border-radius: 16px; display: flex; align-items: center; justify-content: center; margin: 0 auto 14px; font-size: 26px; color: #a78bfa; box-shadow: 0 0 30px rgba(139,92,246,0.2); }
        .sidebar-title { font-size: 15px; font-weight: 700; margin-bottom: 2px; color: #fafafa; }
        .sidebar-subtitle { font-size: 11px; color: #71717a; }
        .sidebar-nav { padding: 16px 12px; flex: 1; }
        .nav-section-label { font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: 1.2px; color: #52525b; padding: 12px 12px 6px; margin-top: 8px; }
        .nav-item { margin-bottom: 4px; }
        .nav-item a { display: flex; align-items: center; gap: 12px; padding: 11px 14px; color: #71717a; text-decoration: none; border-radius: 10px; font-weight: 600; font-size: 14px; transition: all 0.2s; border: 1px solid transparent; }
        .nav-item a:hover, .nav-item a.active { background: rgba(139,92,246,0.1); color: #a78bfa; border-color: rgba(139,92,246,0.2); }
        .nav-icon { width: 34px; height: 34px; background: rgba(255,255,255,0.03); border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 14px; }
        .sidebar-footer { padding: 16px 12px; border-top: 1px solid rgba(255,255,255,0.06); }
        .logout-btn { display: flex; align-items: center; gap: 12px; padding: 11px 14px; color: #71717a; border-radius: 10px; font-weight: 600; font-size: 14px; width: 100%; cursor: pointer; border: none; background: none; font-family: inherit; transition: all 0.2s; }
        .logout-btn:hover { background: rgba(239,68,68,0.1); color: #f87171; }
        .main-content { flex: 1; margin-left: 260px; min-height: 100vh; display: flex; flex-direction: column; }
        .header { background: rgba(15,15,20,0.95); height: 68px; padding: 0 32px; display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid rgba(255,255,255,0.06); position: sticky; top: 0; z-index: 50; backdrop-filter: blur(20px); }
        .header-greeting { display: flex; flex-direction: column; }
        .header-greeting h2 { font-size: 17px; font-weight: 700; color: #fafafa; }
        .header-greeting span { font-size: 12px; color: #71717a; }
        .header-right { display: flex; align-items: center; gap: 14px; }
        .header-date { display: flex; align-items: center; gap: 6px; padding: 6px 12px; background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.06); border-radius: 999px; font-size: 12px; font-weight: 600; color: #71717a; }
        .header-user { display: flex; align-items: center; gap: 10px; padding: 5px 12px 5px 5px; background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.06); border-radius: 999px; }
        .user-avatar { width: 34px; height: 34px; background: linear-gradient(135deg, #8b5cf6, #a78bfa); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: 800; font-size: 13px; box-shadow: 0 0 20px rgba(139,92,246,0.3); }
        .user-name { font-weight: 700; font-size: 12px; color: #fafafa; }
        .user-role { font-size: 10px; color: #a78bfa; font-weight: 600; }
        .page-content { padding: 28px 32px; flex: 1; }
        .page-header-card { background: linear-gradient(135deg, rgba(139,92,246,0.15) 0%, rgba(167,139,250,0.08) 100%); border: 1px solid rgba(139,92,246,0.2); border-radius: 16px; padding: 24px 28px; margin-bottom: 28px; box-shadow: 0 0 40px rgba(139,92,246,0.1); }
        .page-header-content { display: flex; align-items: center; gap: 18px; }
        .page-header-icon { width: 54px; height: 54px; background: linear-gradient(135deg, rgba(139,92,246,0.3), rgba(167,139,250,0.2)); border: 1px solid rgba(139,92,246,0.3); border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 22px; color: #a78bfa; box-shadow: 0 0 30px rgba(139,92,246,0.2); }
        .page-header-content h1 { font-size: 20px; font-weight: 800; color: #fafafa; margin-bottom: 3px; }
        .page-header-content p { color: #71717a; font-size: 13px; }
        .panel { background: rgba(15,15,20,0.8); border: 1px solid rgba(255,255,255,0.06); border-radius: 14px; overflow: hidden; margin-bottom: 24px; }
        .panel-header { padding: 16px 22px; border-bottom: 1px solid rgba(255,255,255,0.06); display: flex; align-items: center; justify-content: space-between; }
        .panel-title { display: flex; align-items: center; gap: 10px; font-size: 14px; font-weight: 700; color: #fafafa; }
        .panel-title .icon { width: 34px; height: 34px; background: rgba(139,92,246,0.15); border: 1px solid rgba(139,92,246,0.2); border-radius: 8px; display: flex; align-items: center; justify-content: center; color: #a78bfa; font-size: 14px; }
        .panel-body { padding: 22px; }
        .form-group { margin-bottom: 18px; }
        .form-group:last-child { margin-bottom: 0; }
        .form-label { display: block; font-weight: 700; font-size: 12px; margin-bottom: 8px; color: #a1a1aa; }
        .form-control { width: 100%; padding: 11px 14px; border: 1px solid rgba(255,255,255,0.08); border-radius: 10px; font-family: inherit; font-size: 14px; color: #fafafa; background: rgba(255,255,255,0.03); transition: all 0.3s; outline: none; }
        .form-control::placeholder { color: #52525b; }
        .form-control:focus { border-color: rgba(139,92,246,0.6); box-shadow: 0 0 0 3px rgba(139,92,246,0.1); }
        .table-container { overflow-x: auto; }
        table { width: 100%; border-collapse: separate; border-spacing: 0; }
        thead th { background: rgba(255,255,255,0.02); color: #71717a; font-weight: 700; font-size: 10px; text-transform: uppercase; letter-spacing: 0.8px; padding: 12px 14px; text-align: left; border-bottom: 1px solid rgba(255,255,255,0.06); }
        tbody tr { transition: all 0.15s; background: transparent; border-bottom: 1px solid rgba(255,255,255,0.04); }
        tbody tr:nth-child(even) { background: rgba(255,255,255,0.01); }
        tbody tr:last-child { border-bottom: none; }
        tbody tr:hover { background: rgba(139,92,246,0.05); }
        tbody td { padding: 12px 14px; vertical-align: middle; font-size: 13px; color: #a1a1aa; }
        .badge { display: inline-flex; align-items: center; gap: 4px; padding: 3px 9px; border-radius: 999px; font-size: 11px; font-weight: 700; border: 1px solid; }
        .badge-purple { background: rgba(139,92,246,0.1); border-color: rgba(139,92,246,0.2); color: #a78bfa; }
        .btn { display: inline-flex; align-items: center; justify-content: center; gap: 6px; padding: 9px 16px; border-radius: 8px; font-family: inherit; font-weight: 700; font-size: 12px; cursor: pointer; transition: all 0.2s; border: 1px solid; text-decoration: none; }
        .btn-primary { background: linear-gradient(135deg, #8b5cf6, #a78bfa); color: white; border-color: rgba(139,92,246,0.3); box-shadow: 0 4px 14px rgba(139,92,246,0.2); }
        .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 6px 20px rgba(139,92,246,0.3); }
        .avatar-sm { width: 28px; height: 28px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 10px; font-weight: 800; color: white; background: linear-gradient(135deg, #8b5cf6, #a78bfa); }
        .empty-state { text-align: center; padding: 40px 24px; }
        .empty-state .icon { font-size: 42px; margin-bottom: 14px; opacity: 0.4; }
        .empty-state h4 { font-size: 15px; font-weight: 700; color: #fafafa; margin-bottom: 5px; }
        .empty-state p { font-size: 12px; color: #71717a; }
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(16px); } to { opacity: 1; transform: translateY(0); } }
        .page-header-card, .panel { animation: fadeInUp 0.4s ease forwards; }
        @media (max-width: 768px) { .sidebar { transform: translateX(-100%); } .main-content { margin-left: 0; } .page-content { padding: 20px 16px; } }
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
                <div class="nav-item"><a href="${pageContext.request.contextPath}/admin/dashboard"><span class="nav-icon"><i class="fas fa-home"></i></span><span>Tổng quan</span></a></div>
                <div class="nav-item"><a href="${pageContext.request.contextPath}/admin/users"><span class="nav-icon"><i class="fas fa-users"></i></span><span>Người dùng</span></a></div>
                <div class="nav-item"><a href="${pageContext.request.contextPath}/admin/logs" class="active"><span class="nav-icon"><i class="fas fa-history"></i></span><span>Nhật ký hệ thống</span></a></div>
                <div class="nav-section-label">Tài khoản</div>
                <div class="nav-item"><a href="${pageContext.request.contextPath}/admin/change-password"><span class="nav-icon"><i class="fas fa-key"></i></span><span>Đổi mật khẩu</span></a></div>
            </nav>
            <div class="sidebar-footer">
                <form method="post" action="${pageContext.request.contextPath}/logout" style="margin: 0;"><button type="submit" class="logout-btn"><span class="nav-icon"><i class="fas fa-sign-out-alt"></i></span><span>Đăng xuất</span></button></form>
            </div>
        </aside>
        <div class="main-content">
            <header class="header">
                <div class="header-greeting"><h2>Nhật ký hệ thống</h2><span>Theo dõi hành động và hoạt động</span></div>
                <div class="header-right">
                    <div class="header-date"><i class="far fa-calendar-alt"></i><span id="currentDate"></span></div>
                    <div class="header-user">
                        <div class="user-avatar">${sessionScope.authUser.roleName == 'Admin' ? 'A' : sessionScope.authUser.roleName == 'Manager' ? 'M' : 'U'}</div>
                        <div class="user-info"><span class="user-name"><c:out value="${sessionScope.authUser.fullName}"/></span><span class="user-role"><c:out value="${sessionScope.authUser.roleName}"/></span></div>
                    </div>
                </div>
            </header>
            <main class="page-content">
                <div class="page-header-card">
                    <div class="page-header-content">
                        <div class="page-header-icon"><i class="fas fa-history"></i></div>
                        <div><h1>Nhật ký hệ thống</h1><p>Theo dõi hành động đăng nhập, tạo/sửa tài khoản và các hoạt động khác</p></div>
                    </div>
                </div>
                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title"><span class="icon"><i class="fas fa-filter"></i></span>Bộ lọc & Tìm kiếm</div>
                    </div>
                    <div class="panel-body">
                        <form method="get" action="${pageContext.request.contextPath}/admin/logs">
                            <div style="display: grid; grid-template-columns: 2fr auto; gap: 14px; align-items: end;">
                                <div class="form-group" style="margin-bottom: 0;">
                                    <label class="form-label">Tìm kiếm</label>
                                    <input type="search" name="keyword" class="form-control" placeholder="Tìm kiếm hành động hoặc mô tả..." value="${keyword}">
                                </div>
                                <button type="submit" class="btn btn-primary"><i class="fas fa-search"></i> Tìm kiếm</button>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title"><span class="icon"><i class="fas fa-clock-rotate-left"></i></span>Lịch sử hoạt động</div>
                        <span style="color: #71717a; font-size: 13px;">Tổng: <strong style="color: #a78bfa;"><c:out value="${logs.size()}"/></strong> bản ghi</span>
                    </div>
                    <div class="panel-body" style="padding: 0;">
                        <div class="table-container">
                            <table>
                                <thead><tr><th style="width: 50px;">ID</th><th style="width: 170px;">Thời gian</th><th>Người dùng</th><th style="width: 120px;">Hành động</th><th style="width: 90px;">Bảng</th><th>Mô tả</th></tr></thead>
                                <tbody>
                                    <c:forEach var="log" items="${logs}">
                                        <tr>
                                            <td><span style="font-weight: 700; color: #52525b; font-size: 11px;">#${log.logId}</span></td>
                                            <td><span style="color: #71717a; font-size: 11px;"><i class="far fa-clock" style="margin-right: 5px;"></i><c:out value="${log.createdAt}"/></span></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty log.username}">
                                                        <div style="display: flex; align-items: center; gap: 8px;">
                                                            <div class="avatar-sm">${log.username.substring(0,1)}</div>
                                                            <strong style="font-weight: 700; color: #a78bfa;"><c:out value="${log.username}"/></strong>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise><span style="color: #71717a;"><i class="fas fa-robot" style="margin-right: 5px;"></i> System</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><span class="badge badge-purple"><i class="fas fa-bolt" style="font-size: 9px;"></i> <c:out value="${log.action}"/></span></td>
                                            <td><span style="font-size: 12px; color: #71717a; font-weight: 600;"><c:out value="${log.tableName}"/></span></td>
                                            <td style="color: #71717a; font-size: 12px;"><c:out value="${log.description}"/></td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty logs}"><tr><td colspan="6"><div class="empty-state"><div class="icon">📭</div><h4>Chưa có nhật ký</h4><p>Không có hoạt động nào được ghi nhận.</p></div></td></tr></c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
    <script>const dateEl = document.getElementById('currentDate'); const today = new Date(); const options = { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' }; dateEl.textContent = today.toLocaleDateString('vi-VN', options);</script>
</body>
</html>
