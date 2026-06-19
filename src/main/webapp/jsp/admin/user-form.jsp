<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${editMode ? 'Sửa tài khoản' : 'Tạo tài khoản'} - KindergartenKitchen</title>
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
        .alert-card { border-radius: 12px; padding: 14px 18px; margin-bottom: 24px; display: flex; align-items: flex-start; gap: 12px; font-size: 13px; border: 1px solid; background: rgba(239,68,68,0.1); border-color: rgba(239,68,68,0.2); color: #fca5a5; }
        .alert-icon { font-size: 18px; margin-top: 2px; }
        .panel { background: rgba(15,15,20,0.8); border: 1px solid rgba(255,255,255,0.06); border-radius: 14px; overflow: hidden; margin-bottom: 24px; max-width: 720px; }
        .panel-header { padding: 16px 22px; border-bottom: 1px solid rgba(255,255,255,0.06); display: flex; align-items: center; gap: 12px; }
        .panel-title { font-size: 14px; font-weight: 700; color: #fafafa; }
        .panel-title .icon { width: 34px; height: 34px; background: rgba(139,92,246,0.15); border: 1px solid rgba(139,92,246,0.2); border-radius: 8px; display: flex; align-items: center; justify-content: center; color: #a78bfa; font-size: 14px; }
        .panel-body { padding: 24px; }
        .form-group { margin-bottom: 18px; }
        .form-label { display: block; font-weight: 700; font-size: 12px; margin-bottom: 8px; color: #a1a1aa; }
        .form-control { width: 100%; padding: 11px 14px; border: 1px solid rgba(255,255,255,0.08); border-radius: 10px; font-family: inherit; font-size: 14px; color: #fafafa; background: rgba(255,255,255,0.03); transition: all 0.3s; outline: none; }
        .form-control::placeholder { color: #52525b; }
        .form-control:focus { border-color: rgba(139,92,246,0.6); box-shadow: 0 0 0 3px rgba(139,92,246,0.1); }
        .form-control:disabled { background: rgba(255,255,255,0.02); color: #71717a; cursor: not-allowed; }
        .form-select { appearance: none; background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='%2371717a' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14L2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E"); background-repeat: no-repeat; background-position: right 12px center; padding-right: 38px; cursor: pointer; }
        .btn { display: inline-flex; align-items: center; justify-content: center; gap: 6px; padding: 9px 16px; border-radius: 8px; font-family: inherit; font-weight: 700; font-size: 12px; cursor: pointer; transition: all 0.2s; border: 1px solid; text-decoration: none; }
        .btn-primary { background: linear-gradient(135deg, #8b5cf6, #a78bfa); color: white; border-color: rgba(139,92,246,0.3); box-shadow: 0 4px 14px rgba(139,92,246,0.2); }
        .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 6px 20px rgba(139,92,246,0.3); filter: brightness(1.1); }
        .btn-ghost { background: transparent; color: #71717a; border-color: rgba(255,255,255,0.08); }
        .btn-ghost:hover { background: rgba(255,255,255,0.05); color: #e4e4e7; }
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
                <div class="header-greeting"><h2>${editMode ? 'Sửa tài khoản' : 'Tạo tài khoản'}</h2><span>Quản lý thông tin người dùng</span></div>
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
                        <div class="page-header-icon"><i class="fas fa-user-circle"></i></div>
                        <div><h1>${editMode ? 'Sửa tài khoản' : 'Tạo tài khoản mới'}</h1><p>Điền thông tin bên dưới để ${editMode ? 'cập nhật' : 'tạo mới'} tài khoản</p></div>
                    </div>
                </div>
                <c:if test="${not empty errors}">
                    <div class="alert-card">
                        <span class="alert-icon"><i class="fas fa-exclamation-circle"></i></span>
                        <div><strong>Vui lòng kiểm tra lại thông tin</strong><ul style="margin: 8px 0 0 0; padding-left: 20px;"><c:forEach var="error" items="${errors}"><li><c:out value="${error}"/></li></c:forEach></ul></div>
                    </div>
                </c:if>
                <div class="panel">
                    <div class="panel-header"><span class="icon"><i class="fas fa-user-circle"></i></span><span class="panel-title">Thông tin tài khoản</span></div>
                    <div class="panel-body">
                        <form method="post" action="${formAction}">
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 18px;">
                                <div class="form-group">
                                    <label class="form-label"><i class="fas fa-user"></i> Tên đăng nhập</label>
                                    <c:choose>
                                        <c:when test="${editMode}"><input type="text" class="form-control" value="${userForm.username}" disabled></c:when>
                                        <c:otherwise><input type="text" name="username" class="form-control" value="${userForm.username}" required placeholder="Nhập tên đăng nhập"></c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="form-group">
                                    <label class="form-label"><i class="fas fa-lock"></i> Mật khẩu<c:if test="${editMode}"><span style="font-weight: 400; color: #71717a; font-size: 11px;"> (để trống nếu không đổi)</span></c:if></label>
                                    <input type="password" name="password" class="form-control" ${editMode ? '' : 'required'} placeholder="${editMode ? 'Nhập mật khẩu mới' : 'Nhập mật khẩu'}">
                                </div>
                                <div class="form-group"><label class="form-label"><i class="fas fa-id-card"></i> Họ và tên</label><input type="text" name="fullName" class="form-control" value="${userForm.fullName}" required placeholder="Nhập họ và tên đầy đủ"></div>
                                <div class="form-group"><label class="form-label"><i class="fas fa-envelope"></i> Email</label><input type="email" name="email" class="form-control" value="${userForm.email}" placeholder="Nhập địa chỉ email"></div>
                                <div class="form-group"><label class="form-label"><i class="fas fa-phone"></i> Số điện thoại</label><input type="text" name="phone" class="form-control" value="${userForm.phone}" placeholder="Nhập số điện thoại"></div>
                                <div class="form-group">
                                    <label class="form-label"><i class="fas fa-shield-halved"></i> Vai trò</label>
                                    <select name="roleId" class="form-control form-select" required>
                                        <option value="">-- Chọn vai trò --</option>
                                        <c:forEach var="role" items="${roles}"><c:if test="${editMode || role.roleId != 1}"><option value="${role.roleId}" ${userForm.roleId == role.roleId ? 'selected' : ''}><c:out value="${role.roleName}"/></option></c:if></c:forEach>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label class="form-label"><i class="fas fa-toggle-on"></i> Trạng thái</label>
                                    <select name="status" class="form-control form-select">
                                        <option value="1" ${userForm.status == 1 ? 'selected' : ''}>Hoạt động</option>
                                        <option value="0" ${userForm.status == 0 ? 'selected' : ''}>Chờ duyệt</option>
                                        <option value="2" ${userForm.status == 2 ? 'selected' : ''}>Bị khóa</option>
                                    </select>
                                </div>
                            </div>
                            <div style="display: flex; gap: 12px; margin-top: 28px; padding-top: 22px; border-top: 1px dashed rgba(255,255,255,0.1);">
                                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> ${editMode ? 'Lưu thay đổi' : 'Tạo tài khoản'}</button>
                                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-ghost"><i class="fas fa-arrow-left"></i> Quay lại</a>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>
    <script>const dateEl = document.getElementById('currentDate'); const today = new Date(); const options = { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' }; dateEl.textContent = today.toLocaleDateString('vi-VN', options);</script>
</body>
</html>
