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
    <title>Minh bạch nguyên liệu - KindergartenKitchen</title>
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
<div class="page-header-icon"><i class="fas fa-box-open"></i></div>
<div><h1>Nguyên liệu nhập kho trong tuần</h1><p>Danh sách nguyên liệu bếp đã nhập kho, kèm nhà cung cấp và chi phí, để phụ huynh theo dõi minh bạch bữa ăn của các con</p></div>
</div>
</div>

<c:if test="${not empty errorMessage}">
    <div class="alert-card warning"><i class="fas fa-exclamation-triangle alert-icon"></i><span>${errorMessage}</span></div>
</c:if>

<div class="panel" style="margin-bottom:20px;">
    <div class="panel-body" style="display:flex; align-items:center; justify-content:center; gap:16px; flex-wrap:wrap;">
        <a class="btn btn-outline btn-sm" href="${pageContext.request.contextPath}/parent/transparency?fromDate=${prevWeekStart}">&larr; Tuần trước</a>
        <strong>
            <fmt:parseDate var="ws" value="${weekStart}" pattern="yyyy-MM-dd" />
            <fmt:parseDate var="we" value="${weekEnd}" pattern="yyyy-MM-dd" />
            <fmt:formatDate value="${ws}" pattern="dd/MM" /> &ndash; <fmt:formatDate value="${we}" pattern="dd/MM/yyyy" />
        </strong>
        <a class="btn btn-outline btn-sm" href="${pageContext.request.contextPath}/parent/transparency?fromDate=${nextWeekStart}">Tuần sau &rarr;</a>
    </div>
</div>

<div class="stats-grid-3">
    <div class="stat-card">
        <div class="stat-icon blue"><i class="fas fa-receipt"></i></div>
        <div class="stat-info"><h3>${fn:length(importList)}</h3><p>Số phiếu nhập trong tuần</p></div>
    </div>
    <div class="stat-card">
        <div class="stat-icon orange"><i class="fas fa-coins"></i></div>
        <div class="stat-info"><h3><fmt:formatNumber value="${totalCost}" pattern="#,##0" /> đ</h3><p>Tổng chi phí nguyên liệu tuần này</p></div>
    </div>
</div>

<div class="panel">
    <div class="panel-header">
        <div class="panel-title"><span class="icon"><i class="fas fa-list"></i></span>Chi tiết phiếu nhập</div>
    </div>
    <table>
        <thead>
            <tr>
                <th>Ngày nhập</th>
                <th>Nguyên liệu</th>
                <th>Số lượng</th>
                <th>Đơn giá</th>
                <th>Thành tiền</th>
                <th>Nhà cung cấp</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="imp" items="${importList}">
                <tr>
                    <td><fmt:formatDate value="${imp.importDate}" pattern="dd/MM/yyyy" /></td>
                    <td><strong>${imp.ingredientName}</strong></td>
                    <td><fmt:formatNumber value="${imp.quantity}" maxFractionDigits="2" /> ${imp.unit}</td>
                    <td><fmt:formatNumber value="${imp.unitPrice}" pattern="#,##0" /> đ</td>
                    <td><strong style="color:#f97316;"><fmt:formatNumber value="${imp.totalPrice}" pattern="#,##0" /> đ</strong></td>
                    <td style="color:#64748b;">${imp.supplierName}</td>
                </tr>
            </c:forEach>
            <c:if test="${empty importList}">
                <tr><td colspan="6" style="text-align:center; padding:32px; color:#94a3b8;">Chưa có phiếu nhập nào trong tuần này.</td></tr>
            </c:if>
        </tbody>
    </table>
</div>

</main>
</div>
</body>
</html>
