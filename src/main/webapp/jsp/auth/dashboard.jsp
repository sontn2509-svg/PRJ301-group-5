<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tổng quan - KindergartenKitchen</title>
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
                        <h2>Xin chào, ${sessionScope.authUser.fullName}!</h2>
                        <span>Chào mừng đến với hệ thống quản lý bếp ăn</span>
                    </div>
                </div>
                <div class="header-right">
                    <div class="header-date">
                        <i class="far fa-calendar-alt"></i>
                        <span id="currentDate"></span>
                    </div>
                    <div class="header-user">
                        <div class="user-avatar">
                            ${sessionScope.authUser.roleName == 'Admin' ? 'A' : sessionScope.authUser.roleName == 'Manager' ? 'M' : sessionScope.authUser.roleName == 'Teacher' ? 'T' : sessionScope.authUser.roleName == 'Parent' ? 'P' : 'K'}
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
                        <span class="emoji">📊</span>
                        Tổng quan hệ thống
                    </h1>
                    <p>Quản lý tài khoản, phân quyền và theo dõi nhật ký hoạt động</p>
                </div>

                <c:if test="${not empty alertMessage}">
                    <div class="alert-card ${alertType == 'danger' ? 'danger' : alertType == 'success' ? 'success' : ''}">
                        <span class="alert-icon">
                            <c:choose>
                                <c:when test="${alertType == 'danger'}">⚠️</c:when>
                                <c:when test="${alertType == 'success'}">✅</c:when>
                                <c:otherwise>ℹ️</c:otherwise>
                            </c:choose>
                        </span>
                        <div class="alert-content">
                            <h4>${alertTitle}</h4>
                            <p>${alertMessage}</p>
                        </div>
                    </div>
                </c:if>

                <div class="stats-grid">
                    <div class="stat-card green">
                        <div class="stat-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-content">
                            <h3><c:out value="${totalUsers}"/></h3>
                            <p>Tổng tài khoản</p>
                        </div>
                    </div>
                    <div class="stat-card orange">
                        <div class="stat-icon">
                            <i class="fas fa-user-check"></i>
                        </div>
                        <div class="stat-content">
                            <h3><c:out value="${activeUsers}"/></h3>
                            <p>Đang hoạt động</p>
                        </div>
                    </div>
                    <div class="stat-card yellow">
                        <div class="stat-icon">
                            <i class="fas fa-user-clock"></i>
                        </div>
                        <div class="stat-content">
                            <h3><c:out value="${pendingUsers}"/></h3>
                            <p>Đang chờ duyệt</p>
                        </div>
                    </div>
                    <div class="stat-card red">
                        <div class="stat-icon">
                            <i class="fas fa-user-slash"></i>
                        </div>
                        <div class="stat-content">
                            <h3><c:out value="${blockedUsers}"/></h3>
                            <p>Tài khoản bị khóa</p>
                        </div>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title">
                            <span class="icon"><i class="fas fa-history"></i></span>
                            Nhật ký hoạt động gần đây
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/logs" class="btn btn-outline btn-sm">
                            Xem tất cả <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>
                    <div class="panel-body">
                        <div class="table-container">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Thời gian</th>
                                        <th>Người dùng</th>
                                        <th>Hành động</th>
                                        <th>Mô tả</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="log" items="${latestLogs}">
                                        <tr>
                                            <td><c:out value="${log.createdAt}"/></td>
                                            <td><c:out value="${log.username}"/></td>
                                            <td>
                                                <span class="badge badge-info">
                                                    <c:out value="${log.action}"/>
                                                </span>
                                            </td>
                                            <td><c:out value="${log.description}"/></td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty latestLogs}">
                                        <tr>
                                            <td colspan="4">
                                                <div class="empty-state">
                                                    <div class="icon">📋</div>
                                                    <h4>Chưa có nhật ký</h4>
                                                    <p>Không có hoạt động nào được ghi nhận gần đây.</p>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px;">
                    <div class="panel">
                        <div class="panel-header">
                            <div class="panel-title">
                                <span class="icon"><i class="fas fa-cog"></i></span>
                                Thao tác nhanh
                            </div>
                        </div>
                        <div class="panel-body">
                            <div style="display: flex; flex-direction: column; gap: 12px;">
                                <a href="${pageContext.request.contextPath}/admin/users/create" class="btn btn-primary">
                                    <i class="fas fa-user-plus"></i> Tạo tài khoản mới
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline">
                                    <i class="fas fa-users-cog"></i> Quản lý người dùng
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/change-password" class="btn btn-outline">
                                    <i class="fas fa-key"></i> Đổi mật khẩu
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="panel">
                        <div class="panel-header">
                            <div class="panel-title">
                                <span class="icon"><i class="fas fa-info-circle"></i></span>
                                Thông tin hệ thống
                            </div>
                        </div>
                        <div class="panel-body">
                            <div style="display: flex; flex-direction: column; gap: 15px;">
                                <div style="display: flex; justify-content: space-between; padding-bottom: 10px; border-bottom: 1px dashed #E8E2DB;">
                                    <span style="color: var(--text-light);">Phiên bản</span>
                                    <span style="font-weight: 700;">1.0.0</span>
                                </div>
                                <div style="display: flex; justify-content: space-between; padding-bottom: 10px; border-bottom: 1px dashed #E8E2DB;">
                                    <span style="color: var(--text-light);">Ngày cập nhật</span>
                                    <span style="font-weight: 700;">17/06/2026</span>
                                </div>
                                <div style="display: flex; justify-content: space-between;">
                                    <span style="color: var(--text-light);">Trạng thái</span>
                                    <span class="badge badge-success">Hoạt động</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script>
        // Hiển thị ngày hiện tại
        const dateElement = document.getElementById('currentDate');
        const today = new Date();
        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        dateElement.textContent = today.toLocaleDateString('vi-VN', options);
    </script>
</body>
</html>
