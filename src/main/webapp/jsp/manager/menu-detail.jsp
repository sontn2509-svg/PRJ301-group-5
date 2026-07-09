<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%
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
    <title>Chi tiết thực đơn - KindergartenKitchen</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="app-container">
        <jsp:include page="/jsp/layout/sidebar-manager.jsp"/>
        <div class="main-content">
            <jsp:include page="/jsp/layout/header.jsp"/>
            <main class="page-content">
                <c:set var="dayNames" value="Thứ 2,Thứ 3,Thứ 4,Thứ 5,Thứ 6,Thứ 7,Chủ nhật" />

                <div class="page-header-card">
                    <div class="page-header-content">
                        <div class="page-header-icon"><i class="fas fa-calendar-week"></i></div>
                        <div>
                            <h1>Thực đơn ${menu.levelName}</h1>
                            <p>
                                <fmt:formatDate value="${menu.weekStartDate}" pattern="dd/MM/yyyy" /> &ndash;
                                <fmt:formatDate value="${menu.weekEndDate}" pattern="dd/MM/yyyy" />
                            </p>
                        </div>
                    </div>
                </div>

                <c:if test="${param.success == 'false'}">
                    <div class="alert-card warning"><i class="fas fa-exclamation-triangle alert-icon"></i>
                        <span>Không thêm được món — món này đã có trong đúng ngày/bữa đó rồi, hoặc ngày không thuộc tuần của thực đơn.</span>
                    </div>
                </c:if>

                <div class="panel" style="margin-bottom:20px;">
                    <div class="panel-body" style="display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:12px;">
                        <div>
                            <c:choose>
                                <c:when test="${menu.status}">
                                    <span class="badge badge-success"><i class="fas fa-eye"></i> Đã công bố cho phụ huynh</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-orange"><i class="fas fa-eye-slash"></i> Đang ở chế độ nháp</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div style="display:flex; gap:10px;">
                            <form method="post" action="${pageContext.request.contextPath}/menu">
                                <input type="hidden" name="action" value="setStatus">
                                <input type="hidden" name="menuId" value="${menu.menuId}">
                                <input type="hidden" name="status" value="${!menu.status}">
                                <button type="submit" class="btn ${menu.status ? 'btn-outline' : 'btn-primary'} btn-sm">
                                    <i class="fas ${menu.status ? 'fa-eye-slash' : 'fa-eye'}"></i>
                                    ${menu.status ? 'Ẩn khỏi phụ huynh' : 'Công bố cho phụ huynh'}
                                </button>
                            </form>
                            <a href="${pageContext.request.contextPath}/menu/list" class="btn btn-ghost btn-sm">&larr; Danh sách thực đơn</a>
                        </div>
                    </div>
                </div>

                <c:if test="${empty dishOptionList}">
                    <div class="alert-card warning"><i class="fas fa-exclamation-triangle alert-icon"></i>
                        <span>Chưa có món ăn nào đang hoạt động. Hãy <a href="${pageContext.request.contextPath}/dish/form">thêm món ăn</a> trước khi gắn vào thực đơn.</span>
                    </div>
                </c:if>
                <c:if test="${empty mealTypeList}">
                    <div class="alert-card warning"><i class="fas fa-exclamation-triangle alert-icon"></i>
                        <span>Chưa có loại bữa nào. Hãy vào <a href="${pageContext.request.contextPath}/dish/list">trang Món ăn</a> để thêm loại bữa (Sáng/Trưa/Xế).</span>
                    </div>
                </c:if>

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
                            <div class="grid-2" style="grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));">
                                <c:forEach var="mt" items="${mealTypeList}">
                                    <div style="border:1px solid #e2e8f0; border-radius:10px; padding:14px;">
                                        <div style="font-weight:600; color:#1e293b; margin-bottom:10px;">
                                            <i class="fas fa-clock" style="color:#f97316;"></i> ${mt.mealTypeName}
                                        </div>

                                        <ul style="list-style:none; padding:0; margin:0 0 10px 0; display:flex; flex-direction:column; gap:6px;">
                                            <c:set var="hasDish" value="false" />
                                            <c:forEach var="detail" items="${menuDetailList}">
                                                <c:if test="${detail.menuDate == day && detail.mealTypeId == mt.mealTypeId}">
                                                    <c:set var="hasDish" value="true" />
                                                    <li style="display:flex; align-items:center; justify-content:space-between; background:#f8fafc; border-radius:6px; padding:6px 10px;">
                                                        <span>${detail.dishName}</span>
                                                        <form method="post" action="${pageContext.request.contextPath}/menu" style="display:inline;">
                                                            <input type="hidden" name="action" value="removeDetail">
                                                            <input type="hidden" name="menuId" value="${menu.menuId}">
                                                            <input type="hidden" name="menuDetailId" value="${detail.menuDetailId}">
                                                            <button type="submit" class="btn btn-ghost btn-sm" style="padding:2px 6px;" title="Bỏ món">
                                                                <i class="fas fa-xmark" style="color:#ef4444;"></i>
                                                            </button>
                                                        </form>
                                                    </li>
                                                </c:if>
                                            </c:forEach>
                                            <c:if test="${!hasDish}">
                                                <li style="color:#94a3b8; font-size:13px; padding:4px 0;">Chưa có món nào</li>
                                            </c:if>
                                        </ul>

                                        <c:if test="${not empty dishOptionList}">
                                            <form method="post" action="${pageContext.request.contextPath}/menu" style="display:flex; gap:6px;">
                                                <input type="hidden" name="action" value="addDetail">
                                                <input type="hidden" name="menuId" value="${menu.menuId}">
                                                <input type="hidden" name="menuDate" value="${day}">
                                                <input type="hidden" name="mealTypeId" value="${mt.mealTypeId}">
                                                <select name="dishId" class="form-select" style="flex:1; font-size:13px;" required>
                                                    <option value="" disabled selected>+ Thêm món...</option>
                                                    <c:forEach var="dish" items="${dishOptionList}">
                                                        <option value="${dish.dishId}">${dish.dishName}</option>
                                                    </c:forEach>
                                                </select>
                                                <button type="submit" class="btn btn-primary btn-sm" title="Thêm"><i class="fas fa-plus"></i></button>
                                            </form>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </main>
        </div>
    </div>
</body>
</html>
