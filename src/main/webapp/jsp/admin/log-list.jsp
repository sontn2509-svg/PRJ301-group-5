<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nhật ký hệ thống - KindergartenKitchen</title>
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
                        <div class="page-header-icon"><i class="fas fa-history"></i></div>
                        <div>
                            <h1>Nhật ký hệ thống</h1>
                            <p>Theo dõi hành động đăng nhập, tạo/sửa tài khoản và các hoạt động khác</p>
                        </div>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title"><span class="icon"><i class="fas fa-filter"></i></span>Bộ lọc & Tìm kiếm</div>
                    </div>
                    <div class="panel-body">
                        <form method="get" action="${pageContext.request.contextPath}/admin/logs">
                            <div style="display: grid; grid-template-columns: 2fr auto; gap: 16px; align-items: end;">
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
                        <span style="color: #64748b;">Tổng: <strong style="color: #f97316;">${logs.size()}</strong> bản ghi</span>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Thời gian</th>
                                <th>Người dùng</th>
                                <th>Hành động</th>
                                <th>Mô tả</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="log" items="${logs}">
                                <tr>
                                    <td><strong style="color: #f97316;">#${log.logId}</strong></td>
                                    <td><i class="far fa-clock" style="margin-right: 6px; color: #94a3b8;"></i>${log.createdAt}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty log.username}">
                                                <div style="display: flex; align-items: center; gap: 8px;">
                                                    <span class="avatar-sm">${log.username.substring(0,1)}</span>
                                                    <strong>${log.username}</strong>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #94a3b8;"><i class="fas fa-robot" style="margin-right: 6px;"></i>System</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><span class="badge badge-orange">${log.action}</span></td>
                                    <td>${log.description}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty logs}">
                                <tr><td colspan="5" style="text-align: center; padding: 32px; color: #94a3b8;">Chưa có nhật ký hoạt động.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>
    </div>
</body>
</html>
