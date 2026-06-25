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
.alert-card{border-radius:12px;padding:16px 20px;margin-bottom:20px;display:flex;align-items:center;gap:14px}
.alert-card.info{background:rgba(59,130,246,0.1);border:1px solid rgba(59,130,246,0.3);color:#3b82f6}
.alert-card.success{background:rgba(16,185,129,0.1);border:1px solid rgba(16,185,129,0.3);color:#10b981}
.alert-icon{font-size:20px}
.meal-list{display:flex;flex-direction:column;gap:12px}
.meal-item{display:flex;align-items:center;gap:16px;padding:14px 16px;border-radius:12px;background:#f5f7fa;border:1px solid #e2e8f0;transition:all 0.2s}
.meal-date{width:64px;height:64px;background:linear-gradient(135deg,#f97316,#fb923c);border-radius:12px;display:flex;flex-direction:column;align-items:center;justify-content:center;color:#fff;flex-shrink:0}
.meal-date .day{font-size:22px;font-weight:800;line-height:1}
.meal-date .month{font-size:11px;font-weight:600;text-transform:uppercase;opacity:0.9}
.meal-info{flex:1}
.meal-info h4{font-size:14px;font-weight:700;color:#1e293b;margin-bottom:2px}
.meal-info p{font-size:12px;color:#94a3b8}
.meal-status{padding:4px 10px;border-radius:6px;font-size:12px;font-weight:600}
.meal-status.ate{background:rgba(16,185,129,0.1);color:#10b981}
.meal-status.skip{background:rgba(245,158,11,0.1);color:#f59e0b}
.meal-status.absent{background:rgba(239,68,68,0.1);color:#ef4444}
.empty-state{text-align:center;padding:40px 20px;color:#94a3b8}
.empty-state i{font-size:48px;margin-bottom:12px;opacity:0.4}
.empty-state p{font-size:14px}
.child-card{display:flex;align-items:center;gap:16px;padding:16px;background:#f5f7fa;border-radius:12px;margin-bottom:12px}
.child-avatar{width:48px;height:48px;background:linear-gradient(135deg,#f97316,#fb923c);border-radius:12px;display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:18px;flex-shrink:0}
.child-info{flex:1}
.child-info h4{font-size:14px;font-weight:700;color:#1e293b;margin-bottom:2px}
.child-info p{font-size:12px;color:#94a3b8}
.child-status{padding:4px 10px;border-radius:6px;font-size:12px;font-weight:600}
.child-status.ate{background:rgba(16,185,129,0.1);color:#10b981}
.child-status.skip{background:rgba(245,158,11,0.1);color:#f59e0b}
.child-status.absent{background:rgba(239,68,68,0.1);color:#ef4444}
@media(max-width:1024px){.stats-grid{grid-template-columns:repeat(2,1fr)}}
@media(max-width:768px){.main-content{margin-left:80px}.stats-grid{grid-template-columns:1fr}.page-content{padding:16px}}
    </style>
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
<div class="stats-grid">
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
<%
    String status = c.getTodayStatus();
    String cssClass = "";
    String icon = "";
    String label = "";
    if ("present".equals(status)) { cssClass = "ate"; icon = "fa-check"; label = "Ăn bếp";
    } else if ("absent_meal".equals(status)) { cssClass = "skip"; icon = "fa-utensils-slash"; label = "Nghỉ ăn";
    } else if ("absent".equals(status)) { cssClass = "absent"; icon = "fa-times"; label = "Vắng";
    } else { cssClass = "skip"; icon = "fa-question"; label = "Chưa cập nhật"; }
%>
<span class="child-status ${cssClass}"><i class="fas ${icon}"></i> ${label}</span>
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
<%
    String mStatus = m.getStatus();
    String mCssClass = "";
    String mLabel = "";
    if ("present".equals(mStatus)) { mCssClass = "ate"; mLabel = "Ăn bếp";
    } else if ("absent_meal".equals(mStatus)) { mCssClass = "skip"; mLabel = "Nghỉ ăn";
    } else { mCssClass = "absent"; mLabel = "Vắng"; }
%>
<span class="meal-status ${mCssClass}">${mLabel}</span>
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
