<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ taglib prefix="c" uri="jakarta.tags.core" %><%@ taglib prefix="fn" uri="jakarta.tags.functions" %><%
    if (session.getAttribute("authUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    com.mycompany.kindergartenkitchen.entity.User authUser = (com.mycompany.kindergartenkitchen.entity.User) session.getAttribute("authUser");
    if (!"Manager".equalsIgnoreCase(authUser.getRoleName())) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }
%><!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tổng quan Quản lý - KindergartenKitchen</title>
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
.stat-icon.purple{background:rgba(168,85,247,0.1);color:#a855f7}
.stat-info h3{font-size:28px;font-weight:800;color:#1e293b;line-height:1}
.stat-info p{font-size:13px;color:#94a3b8;margin-top:4px}
.panel{background:#fff;border-radius:16px;box-shadow:0 2px 8px rgba(0,0,0,0.04);border:1px solid #e2e8f0;margin-bottom:20px;overflow:hidden}
.panel-header{padding:18px 24px;border-bottom:1px solid #e2e8f0;display:flex;align-items:center;justify-content:space-between}
.panel-title{display:flex;align-items:center;gap:10px;font-size:16px;font-weight:700;color:#1e293b}
.panel-title .icon{width:32px;height:32px;background:rgba(249,115,22,0.1);border-radius:8px;display:flex;align-items:center;justify-content:center;color:#f97316;font-size:14px}
.panel-body{padding:24px}
.btn{display:inline-flex;align-items:center;justify-content:center;gap:8px;padding:10px 18px;border-radius:10px;font-size:14px;font-weight:600;border:none;cursor:pointer;transition:all 0.2s;font-family:inherit}
.btn-primary{background:linear-gradient(135deg,#f97316,#fb923c);color:#fff;box-shadow:0 4px 12px rgba(249,115,22,0.3)}
.btn-outline{background:transparent;color:#1e293b;border:2px solid #e2e8f0}
.btn-outline:hover{border-color:#f97316;color:#f97316}
.btn-sm{padding:8px 12px;font-size:13px}
.alert-card{border-radius:12px;padding:16px 20px;margin-bottom:20px;display:flex;align-items:center;gap:14px}
.alert-card.info{background:rgba(59,130,246,0.1);border:1px solid rgba(59,130,246,0.3);color:#3b82f6}
.alert-card.warning{background:rgba(245,158,11,0.1);border:1px solid rgba(245,158,11,0.3);color:#f59e0b}
.alert-icon{font-size:20px}
table{width:100%;border-collapse:collapse}
table thead{background:#f5f7fa}
table th{padding:14px 16px;text-align:left;font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:0.5px;color:#94a3b8;border-bottom:1px solid #e2e8f0}
table td{padding:14px 16px;border-bottom:1px solid #e2e8f0;font-size:14px;color:#475569}
table tbody tr:hover{background:#f5f7fa}
table tbody tr:last-child td{border-bottom:none}
.meal-list{display:flex;flex-direction:column;gap:12px}
.meal-item{display:flex;align-items:center;gap:16px;padding:14px 16px;border-radius:12px;background:#f5f7fa;border:1px solid #e2e8f0;transition:all 0.2s}
.meal-date{width:64px;height:64px;background:linear-gradient(135deg,#f97316,#fb923c);border-radius:12px;display:flex;flex-direction:column;align-items:center;justify-content:center;color:#fff;flex-shrink:0}
.meal-date .day{font-size:22px;font-weight:800;line-height:1}
.meal-date .month{font-size:11px;font-weight:600;text-transform:uppercase;opacity:0.9}
.meal-info{flex:1}
.meal-info h4{font-size:14px;font-weight:700;color:#1e293b;margin-bottom:2px}
.meal-info p{font-size:12px;color:#94a3b8}
.meal-stat{font-size:18px;font-weight:800;color:#f97316}
.ingredient-row{display:flex;align-items:center;gap:12px}
.ingredient-icon{width:40px;height:40px;background:rgba(249,115,22,0.1);border-radius:10px;display:flex;align-items:center;justify-content:center;color:#f97316;flex-shrink:0}
.ingredient-name{font-weight:700;color:#1e293b}
.ingredient-qty{color:#f97316;font-weight:700}
.badge{display:inline-flex;align-items:center;gap:6px;padding:4px 10px;border-radius:6px;font-size:12px;font-weight:600}
.badge-success{background:rgba(16,185,129,0.1);color:#10b981}
.badge-danger{background:rgba(239,68,68,0.1);color:#ef4444}
.badge-warning{background:rgba(245,158,11,0.1);color:#f59e0b}
.empty-state{text-align:center;padding:32px 20px;color:#94a3b8}
.empty-state i{font-size:36px;margin-bottom:8px;opacity:0.4;display:block}
.empty-state p{font-size:13px}
@media(max-width:1024px){.stats-grid{grid-template-columns:repeat(2,1fr)}}
@media(max-width:768px){.main-content{margin-left:80px}.stats-grid{grid-template-columns:1fr}.page-content{padding:16px}}
    </style>
</head>
<body>
<jsp:include page="/jsp/layout/sidebar-manager.jsp"/>
<div class="main-content">
<jsp:include page="/jsp/layout/header.jsp"/>
<main class="page-content">
<div class="page-header-card">
<div class="page-header-content">
<div class="page-header-icon"><i class="fas fa-chart-line"></i></div>
<div><h1>Tổng quan Quản lý</h1><p>Theo dõi hoạt động và thống kê của bếp ăn mầm non</p></div>
</div>
</div>
<c:if test="${not empty flash}">
<div class="alert-card info"><i class="fas fa-info-circle alert-icon"></i><span>${flash}</span></div>
</c:if>
<div class="stats-grid">
<div class="stat-card"><div class="stat-icon blue"><i class="fas fa-user-graduate"></i></div><div class="stat-info"><h3>${totalStudents != null ? totalStudents : 0}</h3><p>Học sinh</p></div></div>
<div class="stat-card"><div class="stat-icon green"><i class="fas fa-chalkboard"></i></div><div class="stat-info"><h3>${totalClasses != null ? totalClasses : 0}</h3><p>Lớp học</p></div></div>
<div class="stat-card"><div class="stat-icon orange"><i class="fas fa-utensils"></i></div><div class="stat-info"><h3>${totalMeals != null ? totalMeals : 0}</h3><p>Bữa ăn tuần này</p></div></div>
<div class="stat-card"><div class="stat-icon purple"><i class="fas fa-carrot"></i></div><div class="stat-info"><h3>${totalIngredients != null ? totalIngredients : 0}</h3><p>Nguyên liệu</p></div></div>
</div>
<c:if test="${lowStockCount != null && lowStockCount > 0}">
<div class="alert-card warning">
<i class="fas fa-exclamation-triangle alert-icon"></i>
<div style="flex:1"><strong>Cảnh báo nguyên liệu</strong><p style="font-size:13px;margin-top:2px">Có <strong>${lowStockCount}</strong> nguyên liệu sắp hết cần bổ sung ngay</p></div>
<a href="${pageContext.request.contextPath}/manager/ingredients" class="btn btn-outline btn-sm">Xem ngay</a>
</div>
</c:if>
<div class="panel">
<div class="panel-header"><div class="panel-title"><span class="icon"><i class="fas fa-bolt"></i></span>Thao tác nhanh</div></div>
<div class="panel-body">
<div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:12px">
<a href="${pageContext.request.contextPath}/manager/classes" class="btn btn-primary" style="justify-content:flex-start"><i class="fas fa-chalkboard"></i> Quản lý lớp học</a>
<a href="${pageContext.request.contextPath}/manager/students" class="btn btn-primary" style="justify-content:flex-start"><i class="fas fa-user-graduate"></i> Quản lý học sinh</a>
<a href="${pageContext.request.contextPath}/manager/attendance" class="btn btn-primary" style="justify-content:flex-start"><i class="fas fa-calendar-check"></i> Điểm danh</a>
<a href="${pageContext.request.contextPath}/manager/ingredients" class="btn btn-primary" style="justify-content:flex-start"><i class="fas fa-carrot"></i> Nguyên liệu</a>
<a href="${pageContext.request.contextPath}/manager/meals" class="btn btn-primary" style="justify-content:flex-start"><i class="fas fa-utensils"></i> Lịch sử bếp</a>
</div>
</div>
</div>
<div class="panel">
<div class="panel-header"><div class="panel-title"><span class="icon"><i class="fas fa-utensils"></i></span>Bữa ăn gần đây</div><a href="${pageContext.request.contextPath}/manager/meals" style="font-size:13px;color:#f97316;font-weight:600">Xem tất cả <i class="fas fa-arrow-right" style="margin-left:4px"></i></a></div>
<div class="panel-body">
<c:choose>
<c:when test="${not empty recentMeals}">
<div class="meal-list">
<c:forEach var="m" items="${recentMeals}">
<div class="meal-item">
<div class="meal-date"><span class="day">${m.day}</span><span class="month">${m.month}</span></div>
<div class="meal-info"><h4>${m.note != null && m.note != '' ? m.note : 'Bữa ăn trong ngày'}</h4><p><i class="far fa-calendar" style="margin-right:4px"></i>${m.date}</p></div>
<div class="meal-stat">${m.totalCount} <small style="font-size:12px;color:#94a3b8;font-weight:600">suất</small></div>
</div>
</c:forEach>
</div>
</c:when>
<c:otherwise>
<div class="empty-state"><i class="fas fa-utensils"></i><p>Chưa có dữ liệu bữa ăn.</p></div>
</c:otherwise>
</c:choose>
</div>
</div>
<div class="panel">
<div class="panel-header"><div class="panel-title"><span class="icon"><i class="fas fa-carrot"></i></span>Nguyên liệu sắp hết</div><a href="${pageContext.request.contextPath}/manager/ingredients" style="font-size:13px;color:#f97316;font-weight:600">Quản lý <i class="fas fa-arrow-right" style="margin-left:4px"></i></a></div>
<c:choose>
<c:when test="${not empty lowStock}">
<table><thead><tr><th>Nguyên liệu</th><th>Đơn vị</th><th>Tồn kho</th><th>Tối thiểu</th><th>Trạng thái</th></tr></thead><tbody>
<c:forEach var="i" items="${lowStock}">
<tr><td><div class="ingredient-row"><div class="ingredient-icon"><i class="fas fa-carrot"></i></div><span class="ingredient-name">${i.name}</span></div></td><td>${i.unit}</td><td><span class="ingredient-qty">${i.quantity}</span></td><td>${i.minThreshold}</td><td><span class="badge badge-danger"><i class="fas fa-exclamation-triangle"></i> Sắp hết</span></td></tr>
</c:forEach>
</tbody></table>
</c:when>
<c:otherwise>
<div class="panel-body"><div class="empty-state"><i class="fas fa-check-circle" style="color:#10b981;opacity:0.6"></i><p>Tất cả nguyên liệu đều còn đủ. Tuyệt vời!</p></div></div>
</c:otherwise>
</c:choose>
</div>
</main>
</div>
</body>
</html>
