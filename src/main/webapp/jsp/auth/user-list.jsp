<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý người dùng - KindergartenKitchen</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="app-container">
        <jsp:include page="/jsp/layout/sidebar.jsp"/>
        
        <div class="main-content">
            <header class="header">
                <div class="header-left">
                    <div class="header-greeting">
                        <h2>Quản lý người dùng</h2>
                        <span>Tạo tài khoản, phân quyền và quản lý người dùng</span>
                    </div>
                </div>
                <div class="header-right">
                    <div class="header-date">
                        <i class="far fa-calendar-alt"></i>
                        <span id="currentDate"></span>
                    </div>
                    <div class="header-user">
                        <div class="user-avatar">
                            ${sessionScope.authUser.roleName == 'Admin' ? 'A' : sessionScope.authUser.roleName == 'Manager' ? 'M' : 'K'}
                        </div>
                        <div class="user-info">
                            <span class="user-name"><c:out value="${sessionScope.authUser.fullName}"/></span>
                            <span class="user-role"><c:out value="${sessionScope.authUser.roleName}"/></span>
                        </div>
                    </div>
                </div>
            </header>

            <main class="page-content">
                <div class="page-title">
                    <h1>
                        <span class="emoji">👥</span>
                        Quản lý người dùng
                    </h1>
                    <p>Tạo tài khoản, phân quyền, khóa hoặc mở khóa người dùng</p>
                </div>

                <c:if test="${not empty flash}">
                    <div class="alert-card success">
                        <span class="alert-icon">✅</span>
                        <div class="alert-content">
                            <p><c:out value="${flash}"/></p>
                        </div>
                    </div>
                </c:if>

                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title">
                            <span class="icon"><i class="fas fa-filter"></i></span>
                            Bộ lọc
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/users/create" class="btn btn-primary btn-sm">
                            <i class="fas fa-plus"></i> Tạo tài khoản
                        </a>
                    </div>
                    <div class="panel-body">
                        <form method="get" action="${pageContext.request.contextPath}/admin/users">
                            <div style="display: grid; grid-template-columns: 2fr 1fr 1fr auto; gap: 15px; align-items: end;">
                                <div class="form-group" style="margin-bottom: 0;">
                                    <label class="form-label">Tìm kiếm</label>
                                    <input type="search" name="keyword" class="form-control" 
                                           placeholder="Tìm username, họ tên, email..." value="${keyword}">
                                </div>
                                <div class="form-group" style="margin-bottom: 0;">
                                    <label class="form-label">Vai trò</label>
                                    <select name="roleId" class="form-control form-select">
                                        <option value="">Tất cả vai trò</option>
                                        <c:forEach var="role" items="${roles}">
                                            <option value="${role.roleId}" ${selectedRoleId == role.roleId ? 'selected' : ''}>
                                                <c:out value="${role.roleName}"/>
                                            </option>
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
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-search"></i> Lọc
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title">
                            <span class="icon"><i class="fas fa-users"></i></span>
                            Danh sách người dùng
                        </div>
                        <span style="color: var(--text-light); font-size: 14px;">
                            Tổng cộng: <strong style="color: var(--primary-color);"><c:out value="${users.size()}"/></strong> tài khoản
                        </span>
                    </div>
                    <div class="panel-body">
                        <div class="table-container">
                            <table>
                                <thead>
                                    <tr>
                                        <th style="width: 60px;">ID</th>
                                        <th>Tài khoản</th>
                                        <th>Họ tên</th>
                                        <th>Liên hệ</th>
                                        <th>Vai trò</th>
                                        <th>Trạng thái</th>
                                        <th style="width: 150px;">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="user" items="${users}">
                                        <tr>
                                            <td><c:out value="${user.userId}"/></td>
                                            <td>
                                                <strong><c:out value="${user.username}"/></strong>
                                            </td>
                                            <td><c:out value="${user.fullName}"/></td>
                                            <td>
                                                <div style="display: flex; flex-direction: column; gap: 2px;">
                                                    <span><i class="fas fa-envelope" style="color: var(--primary-color); width: 20px;"></i> <c:out value="${user.email}"/></span>
                                                    <span style="color: var(--text-light);"><i class="fas fa-phone" style="width: 20px; color: var(--accent-color);"></i> <c:out value="${user.phone}"/></span>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="badge badge-info">
                                                    <c:out value="${user.roleName}"/>
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${user.status == 1}">
                                                        <span class="badge badge-success">Hoạt động</span>
                                                    </c:when>
                                                    <c:when test="${user.status == 0}">
                                                        <span class="badge badge-warning">Chờ duyệt</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-danger">Bị khóa</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div style="display: flex; gap: 8px;">
                                                    <a href="${pageContext.request.contextPath}/admin/users/edit?id=${user.userId}" 
                                                       class="btn btn-outline btn-sm" title="Sửa">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <c:if test="${user.roleId != 1}">
                                                        <a href="${pageContext.request.contextPath}/admin/users/toggle?id=${user.userId}" 
                                                           class="btn btn-sm ${user.status == 1 ? 'btn-accent' : 'btn-primary'}" 
                                                           title="${user.status == 1 ? 'Khóa' : 'Mở khóa'}">
                                                            <i class="fas ${user.status == 1 ? 'fa-lock' : 'fa-unlock'}"></i>
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty users}">
                                        <tr>
                                            <td colspan="7">
                                                <div class="empty-state">
                                                    <div class="icon">🔍</div>
                                                    <h4>Không tìm thấy</h4>
                                                    <p>Không có tài khoản nào phù hợp với điều kiện lọc.</p>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script>
        const dateElement = document.getElementById('currentDate');
        const today = new Date();
        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        dateElement.textContent = today.toLocaleDateString('vi-VN', options);
    </script>
</body>
</html>
