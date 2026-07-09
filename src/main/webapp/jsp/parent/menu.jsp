<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ taglib prefix="c" uri="jakarta.tags.core" %><%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %><%@ taglib prefix="fn" uri="jakarta.tags.functions" %><%
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
    <title>Thực đơn của con - KindergartenKitchen</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<jsp:include page="/jsp/layout/sidebar-parent.jsp"/>
<div class="main-content">
<jsp:include page="/jsp/layout/header.jsp"/>
<main class="page-content">
<c:set var="dayNames" value="Thứ 2,Thứ 3,Thứ 4,Thứ 5,Thứ 6,Thứ 7,Chủ nhật" />

<div class="page-header-card">
<div class="page-header-content">
<div class="page-header-icon"><i class="fas fa-calendar-week"></i></div>
<div><h1>Thực đơn của con</h1><p>Xem thực đơn tuần theo cấp học của con</p></div>
</div>
</div>

<div class="panel" style="margin-bottom:20px;">
    <div class="panel-body" style="display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:12px;">
        <form method="get" action="${pageContext.request.contextPath}/parent/menu" style="display:flex; gap:10px; align-items:end;">
            <div class="form-group" style="margin-bottom:0;">
                <label class="form-label">Cấp học của con</label>
                <select name="levelId" class="form-select" onchange="this.form.submit()">
                    <c:forEach var="lv" items="${levelList}">
                        <option value="${lv.levelId}" ${selectedLevelId == lv.levelId ? "selected" : ""}>${lv.levelName}</option>
                    </c:forEach>
                </select>
            </div>
        </form>
        <c:if test="${not empty menu}">
            <div style="display:flex; gap:10px; align-items:center;">
                <a class="btn btn-outline btn-sm" href="${pageContext.request.contextPath}/parent/menu?levelId=${selectedLevelId}&fromDate=${prevWeekStart}">&larr; Tuần trước</a>
                <strong><fmt:formatDate value="${menu.weekStartDate}" pattern="dd/MM" /> &ndash; <fmt:formatDate value="${menu.weekEndDate}" pattern="dd/MM/yyyy" /></strong>
                <a class="btn btn-outline btn-sm" href="${pageContext.request.contextPath}/parent/menu?levelId=${selectedLevelId}&fromDate=${nextWeekStart}">Tuần sau &rarr;</a>
            </div>
        </c:if>
    </div>
</div>

<c:if test="${empty levelList}">
    <div class="alert-card warning"><i class="fas fa-exclamation-triangle alert-icon"></i><span>Hệ thống chưa cấu hình cấp học nào.</span></div>
</c:if>

<c:if test="${not empty levelList && empty menu}">
    <div class="panel">
        <div class="panel-body" style="text-align:center; padding:48px 24px; color:#94a3b8;">
            <i class="fas fa-calendar-xmark" style="font-size:36px; margin-bottom:12px; display:block;"></i>
            Nhà trường chưa công bố thực đơn cho tuần này.
        </div>
    </div>
</c:if>

<c:if test="${not empty menu}">
    <c:forEach var="day" items="${weekDates}" varStatus="dayStatus">
        <div class="panel" style="margin-bottom:16px;">
            <div class="panel-header">
                <div class="panel-title">
                    <span class="icon"><i class="fas fa-calendar-day"></i></span>
                    ${fn:split(dayNames, ',')[dayStatus.index]} &middot;
                    <fmt:formatDate value="${day}" pattern="dd/MM/yyyy" />
                </div>
            </div>
            <div class="panel-body">
                <div class="grid-2" style="grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));">
                    <c:forEach var="mt" items="${mealTypeList}">
                        <div style="border:1px solid #e2e8f0; border-radius:10px; padding:14px;">
                            <div style="font-weight:600; color:#1e293b; margin-bottom:10px;">
                                <i class="fas fa-clock" style="color:#f97316;"></i> ${mt.mealTypeName}
                            </div>
                            <ul style="list-style:none; padding:0; margin:0; display:flex; flex-direction:column; gap:6px;">
                                <c:set var="hasDish" value="false" />
                                <c:forEach var="detail" items="${menuDetailList}">
                                    <c:if test="${detail.menuDate == day && detail.mealTypeId == mt.mealTypeId}">
                                        <c:set var="hasDish" value="true" />
                                        <li style="background:#f8fafc; border-radius:6px; padding:6px 10px;">${detail.dishName}</li>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${!hasDish}">
                                    <li style="color:#94a3b8; font-size:13px;">Chưa có món</li>
                                </c:if>
                            </ul>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </c:forEach>
</c:if>
</main>
</div>
</body>
</html>
