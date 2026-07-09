<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
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
    <title>Thực đơn - KindergartenKitchen</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="app-container">
        <jsp:include page="/jsp/layout/sidebar-manager.jsp"/>
        <div class="main-content">
            <jsp:include page="/jsp/layout/header.jsp"/>
            <main class="page-content">
                <div class="page-header-card">
                    <div class="page-header-content">
                        <div class="page-header-icon"><i class="fas fa-calendar-week"></i></div>
                        <div><h1>Thực đơn theo tuần</h1><p>Tạo và quản lý thực đơn cho từng cấp học</p></div>
                    </div>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert-card warning"><i class="fas fa-exclamation-triangle alert-icon"></i><span>${errorMessage}</span></div>
                </c:if>
                <c:if test="${param.deleted == 'true'}">
                    <div class="alert-card success"><i class="fas fa-check-circle alert-icon"></i><span>Đã xoá thực đơn.</span></div>
                </c:if>

                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title"><span class="icon"><i class="fas fa-filter"></i></span>Danh sách thực đơn</div>
                        <a href="${pageContext.request.contextPath}/menu/form" class="btn btn-primary btn-sm"><i class="fas fa-plus"></i> Tạo thực đơn tuần mới</a>
                    </div>
                    <div class="panel-body" style="padding-bottom:0;">
                        <form method="get" action="${pageContext.request.contextPath}/menu/list" style="display:flex; gap:10px; align-items:end; max-width:320px;">
                            <div class="form-group" style="flex:1; margin-bottom:16px;">
                                <label class="form-label">Lọc theo cấp học</label>
                                <select name="levelId" class="form-select" onchange="this.form.submit()">
                                    <option value="">-- Tất cả cấp học --</option>
                                    <c:forEach var="lv" items="${levelList}">
                                        <option value="${lv.levelId}" ${param.levelId == lv.levelId ? "selected" : ""}>${lv.levelName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </form>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>Tuần</th>
                                <th>Cấp học</th>
                                <th>Người tạo</th>
                                <th>Trạng thái</th>
                                <th style="width:160px;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="mn" items="${menuList}">
                                <tr>
                                    <td>
                                        <fmt:formatDate value="${mn.weekStartDate}" pattern="dd/MM/yyyy" /> &ndash;
                                        <fmt:formatDate value="${mn.weekEndDate}" pattern="dd/MM/yyyy" />
                                    </td>
                                    <td>${mn.levelName}</td>
                                    <td style="color:#64748b;">${mn.createdByName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${mn.status}">
                                                <span class="badge badge-success"><i class="fas fa-eye"></i> Đã công bố</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-orange"><i class="fas fa-eye-slash"></i> Nháp</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/menu/detail?id=${mn.menuId}" class="btn btn-ghost btn-sm" title="Xem / sửa chi tiết"><i class="fas fa-list-check"></i></a>
                                        <form method="post" action="${pageContext.request.contextPath}/menu" style="display:inline;"
                                              onsubmit="return confirm('Xoá cả thực đơn tuần này (kèm toàn bộ món đã gắn)?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="menuId" value="${mn.menuId}">
                                            <button type="submit" class="btn btn-ghost btn-sm" title="Xoá"><i class="fas fa-trash" style="color:#ef4444;"></i></button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty menuList}">
                                <tr><td colspan="5" style="text-align:center; padding:32px; color:#94a3b8;">Chưa có thực đơn nào.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>
    </div>
</body>
</html>
