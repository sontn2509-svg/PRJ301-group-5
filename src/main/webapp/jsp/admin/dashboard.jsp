<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ taglib prefix="c" uri="jakarta.tags.core" %><%
    if (session.getAttribute("authUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    com.mycompany.kindergartenkitchen.entity.User authUser = (com.mycompany.kindergartenkitchen.entity.User) session.getAttribute("authUser");
    if (!"Admin".equalsIgnoreCase(authUser.getRoleName())) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }
%><!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tổng quan - KindergartenKitchen</title>
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
<div class="page-header-icon"><i class="fas fa-chart-pie"></i></div>
<div><h1>Tổng quan hệ thống</h1><p>Quản lý tài khoản, phân quyền và theo dõi nhật ký hoạt động</p></div>
</div>
</div>
<c:if test="${not empty flash}">
<div class="alert-card ${flashType == 'success' ? 'success' : 'danger'}">
<i class="fas fa-${flashType == 'success' ? 'check-circle' : 'exclamation-circle'} alert-icon"></i>
<span>${flash}</span>
</div>
</c:if>
<div class="stats-grid">
<div class="stat-card"><div class="stat-icon blue"><i class="fas fa-users"></i></div><div class="stat-info"><h3>${totalUsers}</h3><p>Tổng tài khoản</p></div></div>
<div class="stat-card"><div class="stat-icon green"><i class="fas fa-user-check"></i></div><div class="stat-info"><h3>${activeUsers}</h3><p>Đang hoạt động</p></div></div>
<div class="stat-card"><div class="stat-icon orange"><i class="fas fa-user-clock"></i></div><div class="stat-info"><h3>${pendingUsers}</h3><p>Đang chờ duyệt</p></div></div>
<div class="stat-card"><div class="stat-icon red"><i class="fas fa-user-slash"></i></div><div class="stat-info"><h3>${blockedUsers}</h3><p>Tài khoản bị khóa</p></div></div>
</div>
<div class="panel">
<div class="panel-header"><div class="panel-title"><span class="icon"><i class="fas fa-history"></i></span>Nhật ký hoạt động gần đây</div><a href="${pageContext.request.contextPath}/admin/logs" class="btn btn-outline btn-sm">Xem tất cả</a></div>
<table><thead><tr><th>Thời gian</th><th>Người dùng</th><th>Hành động</th><th>Mô tả</th></tr></thead><tbody>
<c:forEach var="log" items="${latestLogs}"><tr><td><i class="far fa-clock" style="margin-right:6px;color:#94a3b8"></i>${log.createdAt}</td><td><strong>${log.username}</strong></td><td><span class="badge badge-orange">${log.action}</span></td><td>${log.description}</td></tr></c:forEach>
<c:if test="${empty latestLogs}"><tr><td colspan="4" style="text-align:center;padding:32px;color:#94a3b8">Chưa có nhật ký hoạt động</td></tr></c:if>
</tbody></table>
</div>
<div class="grid-2">
<div class="panel"><div class="panel-header"><div class="panel-title"><span class="icon"><i class="fas fa-bolt"></i></span>Thao tác nhanh</div></div><div class="panel-body">
<a href="${pageContext.request.contextPath}/admin/users/create" class="btn btn-primary" style="display:flex;margin-bottom:10px"><i class="fas fa-user-plus"></i> Tạo tài khoản mới</a>
<a href="${pageContext.request.contextPath}/admin/users" class="btn btn-ghost" style="display:flex;margin-bottom:10px"><i class="fas fa-users-cog"></i> Quản lý người dùng</a>
<a href="${pageContext.request.contextPath}/admin/change-password" class="btn btn-ghost" style="display:flex"><i class="fas fa-key"></i> Đổi mật khẩu</a>
</div></div>
<div class="panel"><div class="panel-header"><div class="panel-title"><span class="icon"><i class="fas fa-server"></i></span>Thông tin hệ thống</div></div><div class="panel-body">
<div style="display:flex;justify-content:space-between;padding-bottom:10px;border-bottom:1px solid #e2e8f0"><span style="color:#64748b">Phiên bản</span><strong>v1.0.0</strong></div>
<div style="display:flex;justify-content:space-between;padding-bottom:10px;border-bottom:1px solid #e2e8f0"><span style="color:#64748b">Ngày cập nhật</span><strong>25/06/2026</strong></div>
<div style="display:flex;justify-content:space-between"><span style="color:#64748b">Trạng thái</span><span class="badge badge-success"><i class="fas fa-circle" style="font-size:6px"></i> Hoạt động</span></div>
</div></div>
</div>
</main>
</div>
</div>
</body>
</html>
