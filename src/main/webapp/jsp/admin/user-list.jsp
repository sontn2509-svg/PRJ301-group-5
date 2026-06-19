<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý người dùng - KindergartenKitchen</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; font-size: 14px; line-height: 1.6; color: #e4e4e7; background: #09090b; }
        .app-container { display: flex; min-height: 100vh; }
        .sidebar { width: 260px; background: rgba(15, 15, 20, 0.98); border-right: 1px solid rgba(255,255,255,0.06); position: fixed; height: 100vh; overflow-y: auto; z-index: 100; display: flex; flex-direction: column; }
        .sidebar-header { padding: 28px 24px; text-align: center; border-bottom: 1px solid rgba(255,255,255,0.06); }
        .sidebar-logo { width: 60px; height: 60px; background: linear-gradient(135deg, rgba(139,92,246,0.2), rgba(167,139,250,0.1)); border: 1px solid rgba(139,92,246,0.3); border-radius: 16px; display: flex; align-items: center; justify-content: center; margin: 0 auto 14px; font-size: 26px; color: #a78bfa; box-shadow: 0 0 30px rgba(139,92,246,0.2); }
        .sidebar-title { font-size: 15px; font-weight: 700; margin-bottom: 2px; color: #fafafa; }
        .sidebar-subtitle { font-size: 11px; color: #71717a; }
        .sidebar-nav { padding: 16px 12px; flex: 1; }
        .nav-section-label { font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: 1.2px; color: #52525b; padding: 12px 12px 6px; margin-top: 8px; }
        .nav-item { margin-bottom: 4px; }
        .nav-item a { display: flex; align-items: center; gap: 12px; padding: 11px 14px; color: #71717a; text-decoration: none; border-radius: 10px; font-weight: 600; font-size: 14px; transition: all 0.2s; border: 1px solid transparent; }
        .nav-item a:hover { background: rgba(255,255,255,0.03); color: #e4e4e7; }
        .nav-item a.active { background: rgba(139,92,246,0.1); color: #a78bfa; border-color: rgba(139,92,246,0.2); }
        .nav-icon { width: 34px; height: 34px; background: rgba(255,255,255,0.03); border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 14px; }
        .nav-item a.active .nav-icon { background: rgba(139,92,246,0.2); }
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
        .alert-card { border-radius: 12px; padding: 14px 18px; margin-bottom: 24px; display: flex; align-items: center; gap: 12px; font-size: 13px; border: 1px solid; }
        .alert-card.success { background: rgba(34,197,94,0.1); border-color: rgba(34,197,94,0.2); color: #86efac; }
        .alert-icon { font-size: 18px; }
        .panel { background: rgba(15,15,20,0.8); border: 1px solid rgba(255,255,255,0.06); border-radius: 14px; overflow: hidden; margin-bottom: 24px; }
        .panel-header { padding: 16px 22px; border-bottom: 1px solid rgba(255,255,255,0.06); display: flex; align-items: center; justify-content: space-between; }
        .panel-title { display: flex; align-items: center; gap: 10px; font-size: 14px; font-weight: 700; color: #fafafa; }
        .panel-title .icon { width: 34px; height: 34px; background: rgba(139,92,246,0.15); border: 1px solid rgba(139,92,246,0.2); border-radius: 8px; display: flex; align-items: center; justify-content: center; color: #a78bfa; font-size: 14px; }
        .panel-body { padding: 22px; }
        .form-group { margin-bottom: 18px; }
        .form-label { display: block; font-weight: 700; font-size: 12px; margin-bottom: 8px; color: #a1a1aa; }
        .form-control { width: 100%; padding: 11px 14px; border: 1px solid rgba(255,255,255,0.08); border-radius: 10px; font-family: inherit; font-size: 14px; color: #fafafa; background: rgba(255,255,255,0.03); transition: all 0.3s; outline: none; }
        .form-control::placeholder { color: #52525b; }
        .form-control:focus { border-color: rgba(139,92,246,0.6); box-shadow: 0 0 0 3px rgba(139,92,246,0.1); }
        .form-select { appearance: none; background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='%2371717a' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14L2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E"); background-repeat: no-repeat; background-position: right 12px center; padding-right: 38px; cursor: pointer; }
        .table-container { overflow-x: auto; }
        table { width: 100%; border-collapse: separate; border-spacing: 0; }
        thead th { background: rgba(255,255,255,0.02); color: #71717a; font-weight: 700; font-size: 10px; text-transform: uppercase; letter-spacing: 0.8px; padding: 12px 14px; text-align: left; border-bottom: 1px solid rgba(255,255,255,0.06); }
        tbody tr { transition: all 0.15s; background: transparent; border-bottom: 1px solid rgba(255,255,255,0.04); }
        tbody tr:nth-child(even) { background: rgba(255,255,255,0.01); }
        tbody tr:last-child { border-bottom: none; }
        tbody tr:hover { background: rgba(139,92,246,0.05); }
        tbody td { padding: 12px 14px; vertical-align: middle; font-size: 13px; color: #a1a1aa; }
        .badge { display: inline-flex; align-items: center; gap: 4px; padding: 3px 9px; border-radius: 999px; font-size: 11px; font-weight: 700; border: 1px solid; }
        .badge-success { background: rgba(34,197,94,0.1); border-color: rgba(34,197,94,0.2); color: #4ade80; }
        .badge-warning { background: rgba(245,158,11,0.1); border-color: rgba(245,158,11,0.2); color: #fbbf24; }
        .badge-danger { background: rgba(239,68,68,0.1); border-color: rgba(239,68,68,0.2); color: #f87171; }
        .badge-info { background: rgba(59,130,246,0.1); border-color: rgba(59,130,246,0.2); color: #60a5fa; }
        .badge-purple { background: rgba(139,92,246,0.1); border-color: rgba(139,92,246,0.2); color: #a78bfa; }
        .btn { display: inline-flex; align-items: center; justify-content: center; gap: 6px; padding: 9px 16px; border-radius: 8px; font-family: inherit; font-weight: 700; font-size: 12px; cursor: pointer; transition: all 0.2s; border: 1px solid; text-decoration: none; }
        .btn-primary { background: linear-gradient(135deg, #8b5cf6, #a78bfa); color: white; border-color: rgba(139,92,246,0.3); box-shadow: 0 4px 14px rgba(139,92,246,0.2); }
        .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 6px 20px rgba(139,92,246,0.3); filter: brightness(1.1); }
        .btn-accent { background: linear-gradient(135deg, #f59e0b, #fbbf24); color: white; border-color: rgba(245,158,11,0.3); box-shadow: 0 4px 14px rgba(245,158,11,0.2); }
        .btn-accent:hover { transform: translateY(-1px); }
        .btn-danger { background: linear-gradient(135deg, #ef4444, #f87171); color: white; border-color: rgba(239,68,68,0.3); box-shadow: 0 4px 14px rgba(239,68,68,0.2); }
        .btn-danger:hover { transform: translateY(-1px); }
        .btn-ghost { background: transparent; color: #71717a; border-color: rgba(255,255,255,0.08); }
        .btn-ghost:hover { background: rgba(255,255,255,0.05); color: #e4e4e7; }
        .btn-sm { padding: 6px 12px; font-size: 11px; }
        .btn-icon { width: 32px; height: 32px; padding: 0; }
        .avatar-sm { width: 30px; height: 30px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 11px; font-weight: 800; color: white; background: linear-gradient(135deg, #8b5cf6, #a78bfa); }
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
                <div class="nav-item"><a href="${pageContext.request.contextPath}/admin/users" class="active"><span class="nav-icon"><i class="fas fa-users"></i></span><span>Người dùng</span></a></div>
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
                <div class="header-greeting"><h2>Quản lý người dùng</h2><span>Tạo tài khoản, phân quyền và quản lý người dùng</span></div>
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
                        <div class="page-header-icon"><i class="fas fa-users"></i></div>
                        <div><h1>Quản lý người dùng</h1><p>Tạo tài khoản, phân quyền, khóa hoặc mở khóa người dùng</p></div>
                    </div>
                </div>
                <c:if test="${not empty flash}">
                    <div class="alert-card success"><span class="alert-icon"><i class="fas fa-check-circle"></i></span><span><c:out value="${flash}"/></span></div>
                </c:if>
                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title"><span class="icon"><i class="fas fa-filter"></i></span>Bộ lọc & Tìm kiếm</div>
                        <a href="${pageContext.request.contextPath}/admin/users/create" class="btn btn-primary btn-sm"><i class="fas fa-plus"></i> Tạo tài khoản</a>
                    </div>
                    <div class="panel-body">
                        <form method="get" action="${pageContext.request.contextPath}/admin/users">
                            <div style="display: grid; grid-template-columns: 2fr 1fr 1fr auto; gap: 14px; align-items: end;">
                                <div class="form-group" style="margin-bottom: 0;">
                                    <label class="form-label">Tìm kiếm</label>
                                    <input type="search" name="keyword" class="form-control" placeholder="Tìm username, họ tên, email..." value="${keyword}">
                                </div>
                                <div class="form-group" style="margin-bottom: 0;">
                                    <label class="form-label">Vai trò</label>
                                    <select name="roleId" class="form-control form-select">
                                        <option value="">Tất cả vai trò</option>
                                        <c:forEach var="role" items="${roles}"><option value="${role.roleId}" ${selectedRoleId == role.roleId ? 'selected' : ''}><c:out value="${role.roleName}"/></option></c:forEach>
                                    </select>
                                </div>
                                <div class="form-group" style="margin-bottom: 0;">
                                    <label class="form-label">Trạng thái</label>
                                    <select name="status" class="form-control form-select">
                                        <option value="">Tất cả</option>
                                        <option value="1" ${selectedStatus == 1 ? 'selected' : ''}>Hoạt động</option>
                                        <option value="0" ${selectedStatus == 0 ? 'selected' : ''}>Chờ duyệt</option>
                                        <option value="2" ${selectedStatus == 2 ? 'selected' : ''}>Bị khóa</option>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-primary"><i class="fas fa-magnifying-glass"></i> Lọc</button>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title"><span class="icon"><i class="fas fa-users"></i></span>Danh sách người dùng</div>
                        <span style="color: #71717a; font-size: 13px;">Tổng: <strong style="color: #a78bfa;"><c:out value="${users.size()}"/></strong> tài khoản</span>
                    </div>
                    <div class="panel-body" style="padding: 0;">
                        <div class="table-container">
                            <table>
                                <thead><tr><th style="width: 50px;">ID</th><th>Tài khoản</th><th>Họ tên</th><th>Liên hệ</th><th>Vai trò</th><th>Trạng thái</th><th style="width: 140px;">Thao tác</th></tr></thead>
                                <tbody>
                                    <c:forEach var="user" items="${users}">
                                        <tr>
                                            <td><span style="font-weight: 700; color: #52525b; font-size: 11px;">#${user.userId}</span></td>
                                            <td><strong style="font-weight: 700; color: #a78bfa;"><c:out value="${user.username}"/></strong></td>
                                            <td><div style="display: flex; align-items: center; gap: 8px;"><div class="avatar-sm">${user.fullName.substring(user.fullName.lastIndexOf(' ') >= 0 ? user.fullName.lastIndexOf(' ') + 1 : 0, user.fullName.length()).substring(0,1)}</div><span style="font-weight: 600;"><c:out value="${user.fullName}"/></span></div></td>
                                            <td><div style="display: flex; flex-direction: column; gap: 3px; font-size: 11px;"><span><i class="fas fa-envelope" style="color: #a78bfa; width: 14px; margin-right: 4px;"></i><c:out value="${user.email}"/></span><span style="color: #71717a;"><i class="fas fa-phone" style="color: #f59e0b; width: 14px; margin-right: 4px;"></i><c:out value="${user.phone}"/></span></div></td>
                                            <td><span class="badge badge-info"><i class="fas fa-shield-halved" style="font-size: 9px;"></i> <c:out value="${user.roleName}"/></span></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${user.status == 1}"><span class="badge badge-success"><i class="fas fa-circle" style="font-size: 6px;"></i> Hoạt động</span></c:when>
                                                    <c:when test="${user.status == 0}"><span class="badge badge-warning"><i class="fas fa-clock" style="font-size: 9px;"></i> Chờ duyệt</span></c:when>
                                                    <c:otherwise><span class="badge badge-danger"><i class="fas fa-lock" style="font-size: 9px;"></i> Bị khóa</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div style="display: flex; gap: 6px;">
                                                    <a href="${pageContext.request.contextPath}/admin/users/edit?id=${user.userId}" class="btn btn-ghost btn-sm btn-icon" title="Sửa"><i class="fas fa-pen"></i></a>
                                                    <c:if test="${user.roleId != 1}"><a href="${pageContext.request.contextPath}/admin/users/toggle?id=${user.userId}" class="btn btn-sm ${user.status == 1 ? 'btn-accent' : 'btn-primary'}" title="${user.status == 1 ? 'Khóa' : 'Mở khóa'}"><i class="fas ${user.status == 1 ? 'fa-lock' : 'fa-unlock'}"></i></a></c:if>
                                                    <c:if test="${user.roleId != 1}"><button type="button" class="btn btn-danger btn-sm" onclick="confirmDelete('${user.username}', '${user.userId}')" title="Xóa"><i class="fas fa-trash"></i></button></c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty users}"><tr><td colspan="7"><div class="empty-state"><div class="icon">🔍</div><h4>Không tìm thấy</h4><p>Không có tài khoản nào phù hợp.</p></div></td></tr></c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
    <script>
        const dateEl = document.getElementById('currentDate');
        const today = new Date();
        const options = { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' };
        dateEl.textContent = today.toLocaleDateString('vi-VN', options);
        function confirmDelete(username, userId) { if (confirm('Xóa tài khoản "' + username + '"?')) { window.location.href = '${pageContext.request.contextPath}/admin/users/delete?id=' + userId; } }
    </script>
</body>
</html>
