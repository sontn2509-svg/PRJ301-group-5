<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nguyên liệu - KindergartenKitchen</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="app-container">
        <jsp:include page="/jsp/layout/sidebar-kitchen.jsp"/>
        <div class="main-content">
            <jsp:include page="/jsp/layout/header.jsp"/>
            <main class="page-content">
                <div class="page-header-card">
                    <div class="page-header-content">
                        <div class="page-header-icon"><i class="fas fa-carrot"></i></div>
                        <div>
                            <h1>Nguyên liệu</h1>
                            <p>So sánh nguyên liệu cần dùng hôm nay (theo thực đơn) với tồn kho hiện tại</p>
                        </div>
                    </div>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert-card danger"><i class="fas fa-exclamation-circle alert-icon"></i><span>${error}</span></div>
                </c:if>

                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon orange"><i class="fas fa-calendar"></i></div>
                        <div class="stat-info"><h3><fmt:formatDate value="${date}" pattern="dd/MM/yyyy"/></h3><p>Ngày kiểm tra</p></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon red"><i class="fas fa-triangle-exclamation"></i></div>
                        <div class="stat-info">
                            <h3>
                                <c:set var="shortCount" value="0"/>
                                <c:forEach var="r" items="${shortageList}">
                                    <c:if test="${r.belowStock}">
                                        <c:set var="shortCount" value="${shortCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${shortCount}
                            </h3>
                            <p>Nguyên liệu đang thiếu</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon blue"><i class="fas fa-boxes-stacked"></i></div>
                        <div class="stat-info"><h3>${fn:length(shortageList)}</h3><p>Nguyên liệu dùng trong thực đơn hôm nay</p></div>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title"><span class="icon"><i class="fas fa-scale-balanced"></i></span>Cần dùng hôm nay so với tồn kho</div>
                        <a href="${pageContext.request.contextPath}/ingredient/list" class="btn btn-outline btn-sm"><i class="fas fa-warehouse"></i> Quản lý kho nguyên liệu</a>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>Nguyên liệu</th>
                                <th>Đơn vị</th>
                                <th>Tồn kho</th>
                                <th>Cần dùng hôm nay</th>
                                <th>Chênh lệch</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="r" items="${shortageList}">
                                <tr>
                                    <td>
                                        <div class="ingredient-row">
                                            <div class="ingredient-icon"><i class="fas fa-carrot"></i></div>
                                            <span class="ingredient-name">${r.ingredientName}</span>
                                        </div>
                                    </td>
                                    <td>${r.unit}</td>
                                    <td><span class="ingredient-qty"><fmt:formatNumber value="${r.stock}" maxFractionDigits="2"/></span></td>
                                    <td><fmt:formatNumber value="${r.needed}" maxFractionDigits="2"/></td>
                                    <td style="color: ${r.belowStock ? '#ef4444' : '#10b981'}; font-weight:600;">
                                        <c:choose>
                                            <c:when test="${r.belowStock}">
                                                Thiếu <fmt:formatNumber value="${r.shortage}" maxFractionDigits="2"/>
                                            </c:when>
                                            <c:otherwise>
                                                Dư <fmt:formatNumber value="${r.shortage * -1}" maxFractionDigits="2"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${r.belowStock}">
                                                <span class="badge badge-danger"><i class="fas fa-exclamation-triangle"></i> Cần nhập thêm</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-success"><i class="fas fa-check"></i> Đủ dùng</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty shortageList}">
                                <tr><td colspan="6" style="text-align: center; padding: 32px; color: #94a3b8;">Hôm nay chưa có thực đơn nào được lên, hoặc không có nguyên liệu cần tính.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>
    </div>
</body>
</html>