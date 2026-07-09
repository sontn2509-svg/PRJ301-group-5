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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
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
