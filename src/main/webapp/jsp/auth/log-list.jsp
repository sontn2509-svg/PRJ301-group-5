<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nhật ký hệ thống - KindergartenKitchen</title>
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
                        <h2>Nhật ký hệ thống</h2>
                        <span>Theo dõi hành động và hoạt động</span>
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
                        <span class="emoji">📋</span>
                        Nhật ký hệ thống
                    </h1>
                    <p>Theo dõi hành động đăng nhập, tạo/sửa tài khoản và các hoạt động khác</p>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title">
                            <span class="icon"><i class="fas fa-filter"></i></span>
                            Bộ lọc
                        </div>
                    </div>
                    <div class="panel-body">
                        <form method="get" action="${pageContext.request.contextPath}/admin/logs">
                            <div style="display: grid; grid-template-columns: 2fr auto; gap: 15px; align-items: end;">
                                <div class="form-group" style="margin-bottom: 0;">
                                    <label class="form-label">Tìm kiếm</label>
                                    <input type="search" name="keyword" class="form-control" 
                                           placeholder="Tìm kiếm hành động hoặc mô tả..." value="${keyword}">
                                </div>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-search"></i> Tìm kiếm
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title">
                            <span class="icon"><i class="fas fa-history"></i></span>
                            Lịch sử hoạt động
                        </div>
                        <span style="color: var(--text-light); font-size: 14px;">
                            Tổng cộng: <strong style="color: var(--primary-color);"><c:out value="${logs.size()}"/></strong> bản ghi
                        </span>
                    </div>
                    <div class="panel-body">
                        <div class="table-container">
                            <table>
                                <thead>
                                    <tr>
                                        <th style="width: 60px;">ID</th>
                                        <th style="width: 160px;">Thời gian</th>
                                        <th>Người dùng</th>
                                        <th style="width: 120px;">Hành động</th>
                                        <th style="width: 100px;">Bảng</th>
                                        <th style="width: 80px;">Record</th>
                                        <th>Mô tả</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="log" items="${logs}">
                                        <tr>
                                            <td><c:out value="${log.logId}"/></td>
                                            <td>
                                                <i class="far fa-clock" style="color: var(--text-light); margin-right: 5px;"></i>
                                                <c:out value="${log.createdAt}"/>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty log.username}">
                                                        <span style="font-weight: 600;">
                                                            <i class="fas fa-user" style="color: var(--primary-color); margin-right: 5px;"></i>
                                                            <c:out value="${log.username}"/>
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: var(--text-light);">
                                                            <i class="fas fa-cog"></i> System
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="badge badge-info">
                                                    <c:out value="${log.action}"/>
                                                </span>
                                            </td>
                                            <td><c:out value="${log.tableName}"/></td>
                                            <td><c:out value="${log.recordId}"/></td>
                                            <td><c:out value="${log.description}"/></td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty logs}">
                                        <tr>
                                            <td colspan="7">
                                                <div class="empty-state">
                                                    <div class="icon">📭</div>
                                                    <h4>Chưa có nhật ký</h4>
                                                    <p>Không có hoạt động nào được ghi nhận.</p>
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
