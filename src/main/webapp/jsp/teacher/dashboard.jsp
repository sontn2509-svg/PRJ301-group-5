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
.stats-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:20px;margin-bottom:24px}
.stat-card{background:#fff;border-radius:16px;padding:20px;display:flex;align-items:center;gap:16px;box-shadow:0 2px 8px rgba(0,0,0,0.04);border:1px solid #e2e8f0}
.stat-icon{width:56px;height:56px;border-radius:14px;display:flex;align-items:center;justify-content:center;font-size:24px;flex-shrink:0}
.stat-icon.blue{background:rgba(59,130,246,0.1);color:#3b82f6}
.stat-icon.green{background:rgba(16,185,129,0.1);color:#10b981}
.stat-icon.orange{background:rgba(249,115,22,0.1);color:#f97316}
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
.student-row{display:flex;align-items:center;gap:12px}
.student-avatar{width:36px;height:36px;background:linear-gradient(135deg,#f97316,#fb923c);border-radius:10px;display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:14px;flex-shrink:0}
.student-name{font-weight:700;color:#1e293b}
.badge{display:inline-flex;align-items:center;gap:6px;padding:4px 10px;border-radius:6px;font-size:12px;font-weight:600}
.badge-success{background:rgba(16,185,129,0.1);color:#10b981}
.badge-warning{background:rgba(245,158,11,0.1);color:#f59e0b}
.empty-state{text-align:center;padding:32px 20px;color:#94a3b8}
.empty-state i{font-size:36px;margin-bottom:8px;opacity:0.4;display:block}
.empty-state p{font-size:13px}
.class-info-card{display:flex;align-items:center;gap:20px;padding:20px;background:linear-gradient(135deg,rgba(249,115,22,0.05),rgba(251,146,60,0.05));border-radius:12px;border:1px solid rgba(249,115,22,0.15)}
.class-icon{width:64px;height:64px;background:linear-gradient(135deg,#f97316,#fb923c);border-radius:16px;display:flex;align-items:center;justify-content:center;color:#fff;font-size:28px;flex-shrink:0}
.class-info-text{flex:1}
.class-info-text h3{font-size:18px;font-weight:800;color:#1e293b;margin-bottom:4px}
.class-info-text p{font-size:13px;color:#94a3b8}
@media(max-width:1024px){.stats-grid{grid-template-columns:repeat(2,1fr)}}
@media(max-width:768px){.main-content{margin-left:80px}.stats-grid{grid-template-columns:1fr}.page-content{padding:16px}}
    </style>
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
<div class="class-icon"><i class="fas fa-chalkboard"></i></div>
<div class="class-info-text"><h3>${className}</h3><p><i class="fas fa-user-graduate" style="margin-right:4px"></i>${studentCount} học sinh</p></div>
<a href="${pageContext.request.contextPath}/teacher/my-class" class="btn btn-primary"><i class="fas fa-arrow-right"></i> Chi tiết</a>
</div>
</div>
</div>
</c:if>
<div class="stats-grid">
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
