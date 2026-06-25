<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ taglib prefix="c" uri="jakarta.tags.core" %><%@ taglib prefix="fn" uri="jakarta.tags.functions" %><%
    if (session.getAttribute("authUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    com.mycompany.kindergartenkitchen.entity.User authUser = (com.mycompany.kindergartenkitchen.entity.User) session.getAttribute("authUser");
    if (!"KitchenStaff".equalsIgnoreCase(authUser.getRoleName())) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }
%><!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tổng quan Bếp ăn - KindergartenKitchen</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<jsp:include page="/jsp/layout/sidebar-kitchen.jsp"/>
<div class="main-content">
<jsp:include page="/jsp/layout/header.jsp"/>
<main class="page-content">
<div class="page-header-card">
<div class="page-header-content">
<div class="page-header-icon"><i class="fas fa-utensils"></i></div>
<div><h1>Tổng quan Bếp ăn</h1><p>Quản lý suất ăn, nguyên liệu và theo dõi hoạt động bếp</p></div>
</div>
</div>
<c:if test="${not empty flash}">
<div class="alert-card ${flashType == 'success' ? 'success' : 'info'}">
<i class="fas ${flashType == 'success' ? 'fa-check-circle' : 'fa-info-circle'} alert-icon"></i>
<span>${flash}</span>
</div>
</c:if>
<div class="stats-grid">
<div class="stat-card"><div class="stat-icon orange"><i class="fas fa-calculator"></i></div><div class="stat-info"><h3>${todayCount != null ? todayCount : 0}</h3><p>Suất ăn hôm nay</p></div></div>
<div class="stat-card"><div class="stat-icon blue"><i class="fas fa-history"></i></div><div class="stat-info"><h3>${totalMeals != null ? totalMeals : 0}</h3><p>Tổng bữa ăn</p></div></div>
<div class="stat-card"><div class="stat-icon green"><i class="fas fa-carrot"></i></div><div class="stat-info"><h3>${lowStockCount != null ? lowStockCount : 0}</h3><p>Nguyên liệu sắp hết</p></div></div>
<div class="stat-card"><div class="stat-icon purple"><i class="fas fa-check-circle"></i></div><div class="stat-info"><h3>${completedToday != null ? completedToday : 0}</h3><p>Đã hoàn thành</p></div></div>
</div>
<c:if test="${lowStockCount != null && lowStockCount > 0}">
<div class="alert-card warning">
<i class="fas fa-exclamation-triangle alert-icon"></i>
<div style="flex:1"><strong>Cảnh báo nguyên liệu sắp hết</strong><p style="font-size:13px;margin-top:2px">Có <strong>${lowStockCount}</strong> nguyên liệu dưới ngưỡng tối thiểu cần bổ sung</p></div>
<a href="${pageContext.request.contextPath}/kitchen/ingredients" class="btn btn-outline btn-sm">Xem ngay</a>
</div>
</c:if>
<div class="panel">
<div class="panel-header"><div class="panel-title"><span class="icon"><i class="fas fa-bolt"></i></span>Thao tác nhanh</div></div>
<div class="panel-body">
<div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:16px">
<a href="${pageContext.request.contextPath}/kitchen/meal-count" class="btn btn-primary" style="justify-content:flex-start"><i class="fas fa-calculator"></i> Đếm suất ăn hôm nay</a>
<a href="${pageContext.request.contextPath}/kitchen/meal-history" class="btn btn-primary" style="justify-content:flex-start"><i class="fas fa-history"></i> Lịch sử bếp</a>
<a href="${pageContext.request.contextPath}/kitchen/ingredients" class="btn btn-primary" style="justify-content:flex-start"><i class="fas fa-carrot"></i> Quản lý nguyên liệu</a>
</div>
</div>
</div>
<div class="panel">
<div class="panel-header"><div class="panel-title"><span class="icon"><i class="fas fa-utensils"></i></span>Bữa ăn gần đây</div><a href="${pageContext.request.contextPath}/kitchen/meal-history" style="font-size:13px;color:#f97316;font-weight:600">Xem tất cả <i class="fas fa-arrow-right" style="margin-left:4px"></i></a></div>
<div class="panel-body">
<c:choose>
<c:when test="${not empty recentMeals}">
<div class="meal-list">
<c:forEach var="m" items="${recentMeals}">
<div class="meal-item">
<div class="meal-date"><span class="day">${m.day}</span><span class="month">${m.month}</span></div>
<div class="meal-info"><h4>${m.note != null && m.note != '' ? m.note : 'Bữa ăn trong ngày'}</h4><p><i class="far fa-calendar" style="margin-right:4px"></i>${m.date}</p></div>
<div class="meal-stat">${m.totalCount} <small>suất</small></div>
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
<div class="panel-header"><div class="panel-title"><span class="icon"><i class="fas fa-carrot"></i></span>Nguyên liệu sắp hết</div><a href="${pageContext.request.contextPath}/kitchen/ingredients" style="font-size:13px;color:#f97316;font-weight:600">Quản lý <i class="fas fa-arrow-right" style="margin-left:4px"></i></a></div>
<c:choose>
<c:when test="${not empty lowStockList}">
<table><thead><tr><th>Nguyên liệu</th><th>Đơn vị</th><th>Tồn kho</th><th>Tối thiểu</th><th>Trạng thái</th></tr></thead><tbody>
<c:forEach var="i" items="${lowStockList}">
<tr><td><div class="ingredient-row"><div class="ingredient-icon"><i class="fas fa-carrot"></i></div><span class="ingredient-name">${i.name}</span></div></td><td>${i.unit}</td><td><span class="ingredient-qty">${i.quantity}</span></td><td>${i.minThreshold}</td><td><span class="badge badge-danger"><i class="fas fa-exclamation-triangle"></i> Sắp hết</span></td></tr>
</c:forEach>
</tbody></table>
</c:when>
<c:otherwise>
<div class="panel-body"><div class="empty-state"><i class="fas fa-check-circle" style="color:#10b981;opacity:0.6"></i><p>Tất cả nguyên liệu đều còn đủ.</p></div></div>
</c:otherwise>
</c:choose>
</div>
</main>
</div>
</body>
</html>
