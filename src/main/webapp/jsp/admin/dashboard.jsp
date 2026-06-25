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
    <style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:'Segoe UI',Tahoma,sans-serif;background:#f5f7fa;color:#1e293b;line-height:1.6}
a{text-decoration:none;color:inherit}
.app-container{display:flex;min-height:100vh}
.main-content{flex:1;margin-left:260px;display:flex;flex-direction:column;min-height:100vh}
.page-content{flex:1;padding:24px 32px}
.page-header-card{background:linear-gradient(135deg,#ea580c 0%,#f97316 50%,#fb923c 100%);border-radius:16px;padding:28px 32px;margin-bottom:24px;color:#fff}
.page-header-content{display:flex;align-items:center;gap:20px}
.page-header-icon{width:60px;height:60px;background:rgba(255,255,255,0.2);border:2px solid rgba(255,255,255,0.3);border-radius:14px;display:flex;align-items:center;justify-content:center;font-size:28px;flex-shrink:0}
.page-header-card h1{font-size:24px;font-weight:800;margin-bottom:4px}
.page-header-card p{opacity:0.9;font-size:14px}
.stats-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:20px;margin-bottom:24px}
.stat-card{background:#fff;border-radius:16px;padding:20px;display:flex;align-items:center;gap:16px;box-shadow:0 2px 8px rgba(0,0,0,0.04);border:1px solid #e2e8f0}
.stat-icon{width:56px;height:56px;border-radius:14px;display:flex;align-items:center;justify-content:center;font-size:24px;flex-shrink:0}
.stat-icon.blue{background:rgba(59,130,246,0.1);color:#3b82f6}
.stat-icon.green{background:rgba(16,185,129,0.1);color:#10b981}
.stat-icon.orange{background:rgba(249,115,22,0.1);color:#f97316}
.stat-icon.red{background:rgba(239,68,68,0.1);color:#ef4444}
.stat-info h3{font-size:28px;font-weight:800;color:#1e293b;line-height:1}
.stat-info p{font-size:13px;color:#94a3b8;margin-top:4px}
.panel{background:#fff;border-radius:16px;box-shadow:0 2px 8px rgba(0,0,0,0.04);border:1px solid #e2e8f0;margin-bottom:20px;overflow:hidden}
.panel-header{padding:18px 24px;border-bottom:1px solid #e2e8f0;display:flex;align-items:center;justify-content:space-between}
.panel-title{display:flex;align-items:center;gap:10px;font-size:16px;font-weight:700;color:#1e293b}
.panel-title .icon{width:32px;height:32px;background:rgba(249,115,22,0.1);border-radius:8px;display:flex;align-items:center;justify-content:center;color:#f97316;font-size:14px}
.panel-body{padding:24px}
table{width:100%;border-collapse:collapse}
table thead{background:#f5f7fa}
table th{padding:14px 16px;text-align:left;font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:0.5px;color:#94a3b8;border-bottom:1px solid #e2e8f0}
table td{padding:16px;border-bottom:1px solid #e2e8f0;font-size:14px;color:#475569}
table tbody tr:hover{background:#f5f7fa}
table tbody tr:last-child td{border-bottom:none}
.btn{display:inline-flex;align-items:center;justify-content:center;gap:8px;padding:10px 18px;border-radius:10px;font-size:14px;font-weight:600;border:none;cursor:pointer;transition:all 0.2s;font-family:inherit}
.btn-sm{padding:8px 12px;font-size:13px}
.btn-primary{background:linear-gradient(135deg,#f97316,#fb923c);color:#fff;box-shadow:0 4px 12px rgba(249,115,22,0.3)}
.btn-outline{background:transparent;color:#1e293b;border:2px solid #e2e8f0}
.btn-outline:hover{border-color:#f97316;color:#f97316}
.btn-ghost{background:transparent;color:#475569}
.btn-ghost:hover{background:#f5f7fa;color:#1e293b}
.badge{display:inline-flex;align-items:center;gap:6px;padding:4px 10px;border-radius:6px;font-size:12px;font-weight:600}
.badge-success{background:rgba(16,185,129,0.1);color:#10b981}
.badge-orange{background:rgba(249,115,22,0.1);color:#f97316}
.alert-card{border-radius:12px;padding:16px 20px;margin-bottom:20px;display:flex;align-items:center;gap:14px}
.alert-card.success{background:rgba(16,185,129,0.1);border:1px solid rgba(16,185,129,0.3);color:#10b981}
.alert-card.danger{background:rgba(239,68,68,0.1);border:1px solid rgba(239,68,68,0.3);color:#ef4444}
.alert-card.warning{background:rgba(245,158,11,0.1);border:1px solid rgba(245,158,11,0.3);color:#f59e0b}
.alert-icon{font-size:20px}
.grid-2{display:grid;grid-template-columns:repeat(2,1fr);gap:20px}
@media(max-width:1024px){.stats-grid{grid-template-columns:repeat(2,1fr)}}
@media(max-width:768px){.main-content{margin-left:80px}.stats-grid,.grid-2{grid-template-columns:1fr}.page-content{padding:16px}}
    </style>
</head>
<body>
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
</body>
</html>
