<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ taglib prefix="c" uri="jakarta.tags.core" %><%@ taglib prefix="fn" uri="jakarta.tags.functions" %><%
    if (session.getAttribute("authUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    com.mycompany.kindergartenkitchen.entity.User authUser = (com.mycompany.kindergartenkitchen.entity.User) session.getAttribute("authUser");
    if (!"Parent".equalsIgnoreCase(authUser.getRoleName())) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }
%><!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tổng quan Phụ huynh - KindergartenKitchen</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<jsp:include page="/jsp/layout/sidebar-parent.jsp"/>
<div class="main-content">
<jsp:include page="/jsp/layout/header.jsp"/>
<main class="page-content">
<div class="page-header-card">
<div class="page-header-content">
<div class="page-header-icon"><i class="fas fa-user-friends"></i></div>
<div><h1>Tổng quan Phụ huynh</h1><p>Theo dõi tình hình ăn uống của con em mình</p></div>
</div>
</div>
<c:if test="${not empty flash}">
<div class="alert-card ${flashType == 'success' ? 'success' : 'info'}">
<i class="fas ${flashType == 'success' ? 'fa-check-circle' : 'fa-info-circle'} alert-icon"></i>
<span>${flash}</span>
</div>
</c:if>
<div class="stats-grid-3">
<div class="stat-card"><div class="stat-icon blue"><i class="fas fa-child"></i></div><div class="stat-info"><h3>${childCount != null ? childCount : 0}</h3><p>Con đang theo học</p></div></div>
<div class="stat-card"><div class="stat-icon green"><i class="fas fa-calendar-check"></i></div><div class="stat-info"><h3>${attendanceDays != null ? attendanceDays : 0}</h3><p>Ngày đi học (tháng này)</p></div></div>
<div class="stat-card"><div class="stat-icon orange"><i class="fas fa-utensils"></i></div><div class="stat-info"><h3>${mealDays != null ? mealDays : 0}</h3><p>Ngày đã ăn bếp</p></div></div>
</div>
<div class="panel">
<div class="panel-header"><div class="panel-title"><span class="icon"><i class="fas fa-bolt"></i></span>Thao tác nhanh</div></div>
<div class="panel-body">
<div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:16px">
<a href="${pageContext.request.contextPath}/parent/my-children" class="btn btn-primary" style="justify-content:flex-start"><i class="fas fa-child"></i> Xem con em</a>
<a href="${pageContext.request.contextPath}/parent/absences" class="btn btn-primary" style="justify-content:flex-start"><i class="fas fa-user-slash"></i> Xin nghỉ ăn cho con</a>
<a href="${pageContext.request.contextPath}/parent/history" class="btn btn-primary" style="justify-content:flex-start"><i class="fas fa-history"></i> Xem lịch sử ăn</a>
</div>
</div>
</div>
<div class="panel">
<div class="panel-header"><div class="panel-title"><span class="icon"><i class="fas fa-child"></i></span>Tình trạng con em hôm nay</div></div>
<div class="panel-body">
<c:choose>
<c:when test="${not empty children}">
<c:forEach var="c" items="${children}">
<div class="child-card">
<div class="child-avatar">${c.fullName != null && c.fullName.length() > 0 ? c.fullName.substring(0,1) : '?'}</div>
<div class="child-info"><h4>${c.fullName}</h4><p><i class="fas fa-chalkboard" style="margin-right:4px"></i>${c.className}</p></div>
<c:choose>
    <c:when test="${c.todayStatus == 'present'}">
        <span class="child-status ate"><i class="fas fa-check"></i> Ăn bếp</span>
    </c:when>
    <c:when test="${c.todayStatus == 'absent_meal'}">
        <span class="child-status skip"><i class="fas fa-utensils-slash"></i> Nghỉ ăn</span>
    </c:when>
    <c:when test="${c.todayStatus == 'absent'}">
        <span class="child-status absent"><i class="fas fa-times"></i> Vắng</span>
    </c:when>
    <c:otherwise>
        <span class="child-status skip"><i class="fas fa-question"></i> Chưa cập nhật</span>
    </c:otherwise>
</c:choose>
</div>
</c:forEach>
</c:when>
<c:otherwise>
<div class="empty-state"><i class="fas fa-child"></i><p>Chưa có thông tin con em. Vui lòng liên hệ nhà trường.</p></div>
</c:otherwise>
</c:choose>
</div>
</div>
<div class="panel">
<div class="panel-header"><div class="panel-title"><span class="icon"><i class="fas fa-clock-rotate-left"></i></span>Bữa ăn gần đây</div><a href="${pageContext.request.contextPath}/parent/history" style="font-size:13px;color:#f97316;font-weight:600">Xem tất cả <i class="fas fa-arrow-right" style="margin-left:4px"></i></a></div>
<div class="panel-body">
<c:choose>
<c:when test="${not empty recentMeals}">
<div class="meal-list">
<c:forEach var="m" items="${recentMeals}">
<div class="meal-item">
<div class="meal-date"><span class="day">${m.day}</span><span class="month">${m.month}</span></div>
<div class="meal-info"><h4>${m.studentName}</h4><p><i class="fas fa-chalkboard" style="margin-right:4px"></i>${m.className}</p></div>
<c:choose>
    <c:when test="${m.status == 'present'}">
        <span class="meal-status ate">Ăn bếp</span>
    </c:when>
    <c:when test="${m.status == 'absent_meal'}">
        <span class="meal-status skip">Nghỉ ăn</span>
    </c:when>
    <c:otherwise>
        <span class="meal-status absent">Vắng</span>
    </c:otherwise>
</c:choose>
</div>
</c:forEach>
</div>
</c:when>
<c:otherwise>
<div class="empty-state"><i class="fas fa-utensils"></i><p>Chưa có dữ liệu bữa ăn gần đây.</p></div>
</c:otherwise>
</c:choose>
</div>
</div>
</main>
</div>
</body>
</html>
