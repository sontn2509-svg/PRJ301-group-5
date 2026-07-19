<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ taglib prefix="c" uri="jakarta.tags.core" %><%@ taglib prefix="fn" uri="jakarta.tags.functions" %><%
    if (session.getAttribute("authUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    com.mycompany.kindergartenkitchen.entity.User authUser = (com.mycompany.kindergartenkitchen.entity.User) session.getAttribute("authUser");
    if (!"Teacher".equalsIgnoreCase(authUser.getRoleName())) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }
%><!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tổng quan Giáo viên - KindergartenKitchen</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<jsp:include page="/jsp/layout/sidebar-teacher.jsp"/>
<div class="main-content">
<jsp:include page="/jsp/layout/header.jsp"/>
<main class="page-content">
<div class="page-header-card">
<div class="page-header-content">
<div class="page-header-icon"><i class="fas fa-chalkboard-teacher"></i></div>
<div><h1>Tổng quan Giáo viên</h1><p>Quản lý lớp học và điểm danh học sinh</p></div>
</div>
</div>
<c:if test="${not empty flash}">
<div class="alert-card info"><i class="fas fa-info-circle alert-icon"></i><span>${flash}</span></div>
</c:if>
<c:if test="${not empty className}">
<div class="panel">
<div class="panel-header"><div class="panel-title"><span class="icon"><i class="fas fa-chalkboard"></i></span>Lớp của tôi</div></div>
<div class="panel-body">
<div class="class-info-card">
<div class="class-icon-lg"><i class="fas fa-chalkboard"></i></div>
<div class="class-info-text"><h3>${className}</h3><p><i class="fas fa-user-graduate" style="margin-right:4px"></i>${studentCount} học sinh</p></div>
<a href="${pageContext.request.contextPath}/teacher/my-class" class="btn btn-primary"><i class="fas fa-arrow-right"></i> Chi tiết</a>
</div>
</div>
</div>
</c:if>
<div class="stats-grid-3">
<div class="stat-card"><div class="stat-icon blue"><i class="fas fa-users"></i></div><div class="stat-info"><h3>${studentCount != null ? studentCount : 0}</h3><p>Học sinh trong lớp</p></div></div>
<div class="stat-card"><div class="stat-icon green"><i class="fas fa-calendar-check"></i></div><div class="stat-info"><h3>${attendanceDays != null ? attendanceDays : 0}</h3><p>Ngày đã điểm danh</p></div></div>
<div class="stat-card"><div class="stat-icon orange"><i class="fas fa-user-slash"></i></div><div class="stat-info"><h3>${absenceCount != null ? absenceCount : 0}</h3><p>Yêu cầu nghỉ ăn</p></div></div>
</div>
<div class="panel">
<div class="panel-header"><div class="panel-title"><span class="icon"><i class="fas fa-bolt"></i></span>Thao tác nhanh</div></div>
<div class="panel-body">
<div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:16px">
<a href="${pageContext.request.contextPath}/teacher/my-class" class="btn btn-primary" style="justify-content:flex-start"><i class="fas fa-users"></i> Xem lớp của tôi</a>
<a href="${pageContext.request.contextPath}/teacher/attendance" class="btn btn-primary" style="justify-content:flex-start"><i class="fas fa-calendar-check"></i> Điểm danh hôm nay</a>
<a href="${pageContext.request.contextPath}/teacher/absences" class="btn btn-primary" style="justify-content:flex-start"><i class="fas fa-user-slash"></i> Xin nghỉ ăn cho học sinh</a>
</div>
</div>
</div>
<c:if test="${pendingAbsences != null && pendingAbsences > 0}">
<div class="alert-card warning">
<i class="fas fa-clock alert-icon"></i>
<div style="flex:1"><strong>Yêu cầu đang chờ duyệt</strong><p style="font-size:13px;margin-top:2px">Có <strong>${pendingAbsences}</strong> yêu cầu nghỉ ăn đang chờ xử lý</p></div>
<a href="${pageContext.request.contextPath}/teacher/absences" class="btn btn-outline btn-sm">Xem ngay</a>
</div>
</c:if>
<div class="panel">
<div class="panel-header"><div class="panel-title"><span class="icon"><i class="fas fa-user-graduate"></i></span>Học sinh trong lớp</div><a href="${pageContext.request.contextPath}/teacher/my-class" style="font-size:13px;color:#f97316;font-weight:600">Xem tất cả <i class="fas fa-arrow-right" style="margin-left:4px"></i></a></div>
<c:choose>
<c:when test="${not empty students}">
<table><thead><tr><th>Học sinh</th><th>Ngày sinh</th><th>Phụ huynh</th><th>SĐT phụ huynh</th></tr></thead><tbody>
<c:forEach var="s" items="${students}">
<tr><td><div class="student-row"><div class="student-avatar">${s.fullName != null && s.fullName.length() > 0 ? s.fullName.substring(0,1) : '?'}</div><span class="student-name">${s.fullName}</span></div></td><td>${s.dateOfBirth}</td><td>${s.parentName}</td><td><i class="fas fa-phone" style="color:#94a3b8;margin-right:6px"></i>${s.parentPhone}</td></tr>
</c:forEach>
</tbody></table>
</c:when>
<c:otherwise>
<div class="panel-body"><div class="empty-state"><i class="fas fa-user-graduate"></i><p>Chưa có học sinh trong lớp.</p></div></div>
</c:otherwise>
</c:choose>
</div>
</main>
</div>
</body>
</html>
