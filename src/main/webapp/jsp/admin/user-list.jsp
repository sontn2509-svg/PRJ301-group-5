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
body { font-family: 'Segoe UI', Tahoma, sans-serif; background: #f5f7fa; color: #1e293b; line-height: 1.6; }
a { text-decoration: none; color: inherit; }
.app-container { display: flex; min-height: 100vh; }
.main-content { flex: 1; margin-left: 260px; display: flex; flex-direction: column; min-height: 100vh; }
.page-content { flex: 1; padding: 24px 32px; }

.page-header-card { background: linear-gradient(135deg, #ea580c 0%, #f97316 50%, #fb923c 100%); border-radius: 16px; padding: 28px 32px; margin-bottom: 24px; color: #fff; }
.page-header-content { display: flex; align-items: center; gap: 20px; }
.page-header-icon { width: 60px; height: 60px; background: rgba(255,255,255,0.2); border: 2px solid rgba(255,255,255,0.3); border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 28px; flex-shrink: 0; }
.page-header-card h1 { font-size: 24px; font-weight: 800; margin-bottom: 4px; }
.page-header-card p { opacity: 0.9; font-size: 14px; }

.panel { background: #fff; border-radius: 16px; box-shadow: 0 2px 8px rgba(0,0,0,0.04); border: 1px solid #e2e8f0; margin-bottom: 20px; overflow: hidden; }
.panel-header { padding: 18px 24px; border-bottom: 1px solid #e2e8f0; display: flex; align-items: center; justify-content: space-between; }
.panel-title { display: flex; align-items: center; gap: 10px; font-size: 16px; font-weight: 700; color: #1e293b; }
.panel-title .icon { width: 32px; height: 32px; background: rgba(249,115,22,0.1); border-radius: 8px; display: flex; align-items: center; justify-content: center; color: #f97316; font-size: 14px; }
.panel-body { padding: 24px; }

table { width: 100%; border-collapse: collapse; }
table thead { background: #f5f7fa; }
table th { padding: 14px 16px; text-align: left; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; color: #94a3b8; border-bottom: 1px solid #e2e8f0; }
table td { padding: 16px; border-bottom: 1px solid #e2e8f0; font-size: 14px; color: #475569; }
table tbody tr:hover { background: #f5f7fa; }
table tbody tr:last-child td { border-bottom: none; }

.form-group { margin-bottom: 18px; }
.form-label { display: block; font-size: 13px; font-weight: 700; color: #1e293b; margin-bottom: 8px; }
.form-control { width: 100%; padding: 12px 16px; border: 2px solid #e2e8f0; border-radius: 10px; font-size: 14px; font-family: inherit; color: #1e293b; background: #fff; transition: all 0.2s; }
.form-control:focus { outline: none; border-color: #f97316; box-shadow: 0 0 0 4px rgba(249,115,22,0.1); }
.form-select { cursor: pointer; }

.btn { display: inline-flex; align-items: center; justify-content: center; gap: 8px; padding: 10px 18px; border-radius: 10px; font-size: 14px; font-weight: 600; border: none; cursor: pointer; transition: all 0.2s; font-family: inherit; }
.btn-sm { padding: 8px 12px; font-size: 13px; }
.btn-primary { background: linear-gradient(135deg, #f97316, #fb923c); color: #fff; box-shadow: 0 4px 12px rgba(249,115,22,0.3); }
.btn-ghost { background: transparent; color: #475569; }
.btn-ghost:hover { background: #f5f7fa; color: #1e293b; }
.btn-danger { background: rgba(239,68,68,0.1); color: #ef4444; }
.btn-danger:hover { background: #ef4444; color: #fff; }
.btn-success { background: rgba(16,185,129,0.1); color: #10b981; }
.btn-success:hover { background: #10b981; color: #fff; }

.badge { display: inline-flex; align-items: center; gap: 6px; padding: 4px 10px; border-radius: 6px; font-size: 12px; font-weight: 600; }
.badge-success { background: rgba(16,185,129,0.1); color: #10b981; }
.badge-warning { background: rgba(245,158,11,0.1); color: #f59e0b; }
.badge-danger { background: rgba(239,68,68,0.1); color: #ef4444; }
.badge-info { background: rgba(59,130,246,0.1); color: #3b82f6; }

.alert-card { border-radius: 12px; padding: 16px 20px; margin-bottom: 20px; display: flex; align-items: center; gap: 14px; }
.alert-card.success { background: rgba(16,185,129,0.1); border: 1px solid rgba(16,185,129,0.3); color: #10b981; }
.alert-icon { font-size: 20px; }

.avatar-sm { width: 36px; height: 36px; background: linear-gradient(135deg, #f97316, #fb923c); border-radius: 10px; display: inline-flex; align-items: center; justify-content: center; color: #fff; font-weight: 700; font-size: 14px; }

@media (max-width: 768px) { .main-content { margin-left: 80px; } .page-content { padding: 16px; } }
    </style>
</head>
<body>
    <div class="app-container">
        <jsp:include page="/jsp/layout/sidebar-admin.jsp"/>
        <div class="main-content">
            <jsp:include page="/jsp/layout/header.jsp"/>
            <main class="page-content">
                <div class="page-header-card">
                    <div class="page-header-content">
                        <div class="page-header-icon"><i class="fas fa-users"></i></div>
                        <div>
                            <h1>Quản lý người dùng</h1>
                            <p>Tạo tài khoản, phân quyền, khóa hoặc mở khóa người dùng</p>
                        </div>
                    </div>
                </div>

                <c:if test="${not empty flash}">
                    <div class="alert-card success">
                        <i class="fas fa-check-circle alert-icon"></i>
                        <span>${flash}</span>
                    </div>
                </c:if>

                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title"><span class="icon"><i class="fas fa-filter"></i></span>Bộ lọc & Tìm kiếm</div>
                        <a href="${pageContext.request.contextPath}/admin/users/create" class="btn btn-primary btn-sm"><i class="fas fa-plus"></i> Tạo tài khoản</a>
                    </div>
                    <div class="panel-body">
                        <form method="get" action="${pageContext.request.contextPath}/admin/users">
                            <div style="display: grid; grid-template-columns: 2fr 1fr 1fr auto; gap: 16px; align-items: end;">
                                <div class="form-group" style="margin-bottom: 0;">
                                    <label class="form-label">Tìm kiếm</label>
                                    <input type="search" name="keyword" class="form-control" placeholder="Tìm username, họ tên, email..." value="${keyword}">
                                </div>
                                <div class="form-group" style="margin-bottom: 0;">
                                    <label class="form-label">Vai trò</label>
                                    <select name="roleId" class="form-control form-select">
                                        <option value="">Tất cả vai trò</option>
                                        <c:forEach var="role" items="${roles}">
                                            <option value="${role.roleId}" ${selectedRoleId == role.roleId ? 'selected' : ''}>${role.roleName}</option>
                                        </c:forEach>
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
                                <button type="submit" class="btn btn-primary"><i class="fas fa-search"></i> Lọc</button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title"><span class="icon"><i class="fas fa-users"></i></span>Danh sách người dùng</div>
                        <span style="color: #64748b;">Tổng: <strong style="color: #f97316;">${users.size()}</strong> tài khoản</span>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tài khoản</th>
                                <th>Họ tên</th>
                                <th>Liên hệ</th>
                                <th>Vai trò</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="user" items="${users}">
                                <tr>
                                    <td><strong style="color: #f97316;">#${user.userId}</strong></td>
                                    <td><strong>${user.username}</strong></td>
                                    <td><div style="display: flex; align-items: center; gap: 10px;"><span class="avatar-sm">${user.fullName.substring(0,1)}</span>${user.fullName}</div></td>
                                    <td>
                                        <div style="font-size: 12px;">
                                            <div><i class="fas fa-envelope" style="width: 14px; color: #94a3b8;"></i> ${user.email}</div>
                                            <div style="color: #94a3b8;"><i class="fas fa-phone" style="width: 14px;"></i> ${user.phone}</div>
                                        </div>
                                    </td>
                                    <td><span class="badge badge-info">${user.roleName}</span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${user.status == 1}"><span class="badge badge-success"><i class="fas fa-circle" style="font-size: 6px;"></i> Hoạt động</span></c:when>
                                            <c:when test="${user.status == 0}"><span class="badge badge-warning"><i class="fas fa-clock" style="font-size: 9px;"></i> Chờ duyệt</span></c:when>
                                            <c:otherwise><span class="badge badge-danger"><i class="fas fa-lock" style="font-size: 9px;"></i> Bị khóa</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div style="display: flex; gap: 6px;">
                                            <a href="${pageContext.request.contextPath}/admin/users/edit?id=${user.userId}" class="btn btn-ghost btn-sm" title="Sửa"><i class="fas fa-pen"></i></a>
                                            <c:if test="${user.roleId != 1}">
                                                <a href="${pageContext.request.contextPath}/admin/users/toggle?id=${user.userId}" class="btn btn-sm ${user.status == 1 ? 'btn-success' : 'btn-primary'}" title="${user.status == 1 ? 'Khóa' : 'Mở khóa'}"><i class="fas ${user.status == 1 ? 'fa-lock' : 'fa-unlock'}"></i></a>
                                                <button type="button" class="btn btn-danger btn-sm" onclick="confirmDelete('${user.username}', '${user.userId}')" title="Xóa"><i class="fas fa-trash"></i></button>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty users}">
                                <tr><td colspan="7" style="text-align: center; padding: 32px; color: #94a3b8;">Không có tài khoản nào phù hợp.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>
    </div>
    <script>
        function confirmDelete(username, userId) {
            if (confirm('Xóa tài khoản "' + username + '"?')) {
                window.location.href = '${pageContext.request.contextPath}/admin/users/delete?id=' + userId;
            }
        }
    </script>
</body>
</html>