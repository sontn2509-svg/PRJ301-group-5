<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý người dùng - KindergartenKitchen</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
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
