<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
    <title>Món ăn - KindergartenKitchen</title>
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
                        <div class="page-header-icon"><i class="fas fa-utensils"></i></div>
                        <div><h1>Danh sách món ăn</h1><p>Quản lý món ăn dùng để xây dựng thực đơn hằng tuần</p></div>
                    </div>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert-card warning"><i class="fas fa-exclamation-triangle alert-icon"></i><span>${errorMessage}</span></div>
                </c:if>
                <c:if test="${param.success == 'true'}">
                    <div class="alert-card success"><i class="fas fa-check-circle alert-icon"></i><span>Đã lưu món ăn thành công.</span></div>
                </c:if>
                <c:if test="${param.success == 'false'}">
                    <div class="alert-card warning"><i class="fas fa-exclamation-triangle alert-icon"></i><span>Lưu thất bại — tên món trống hoặc đã trùng với món khác đang dùng.</span></div>
                </c:if>

                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title"><span class="icon"><i class="fas fa-list"></i></span>Danh sách món ăn</div>
                        <a href="${pageContext.request.contextPath}/dish/form" class="btn btn-primary btn-sm"><i class="fas fa-plus"></i> Thêm món</a>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên món</th>
                                <th>Mô tả</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="dish" items="${dishList}">
                                <tr>
                                    <td><strong style="color:#f97316;">#${dish.dishId}</strong></td>
                                    <td><strong>${dish.dishName}</strong></td>
                                    <td style="color:#64748b;">${empty dish.description ? "—" : dish.description}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${dish.status}">
                                                <span class="badge badge-success"><i class="fas fa-check"></i> Đang dùng</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-danger"><i class="fas fa-ban"></i> Ngừng dùng</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/dish/form?id=${dish.dishId}" class="btn btn-ghost btn-sm" title="Sửa"><i class="fas fa-pen"></i></a>
                                        <form method="post" action="${pageContext.request.contextPath}/dish" style="display:inline;">
                                            <input type="hidden" name="action" value="setStatus">
                                            <input type="hidden" name="dishId" value="${dish.dishId}">
                                            <input type="hidden" name="status" value="${!dish.status}">
                                            <button type="submit" class="btn btn-ghost btn-sm" title="${dish.status ? 'Ngừng dùng' : 'Dùng lại'}">
                                                <i class="fas ${dish.status ? 'fa-ban' : 'fa-rotate-left'}"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty dishList}">
                                <tr><td colspan="5" style="text-align:center; padding:32px; color:#94a3b8;">Chưa có món ăn nào.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title"><span class="icon"><i class="fas fa-clock"></i></span>Loại bữa (Sáng / Trưa / Xế...)</div>
                    </div>
                    <div class="panel-body">
                        <c:if test="${param.mtSuccess == 'false'}">
                            <div class="alert-card warning"><i class="fas fa-exclamation-triangle alert-icon"></i><span>Thao tác thất bại — tên trống, đã trùng, hoặc loại bữa đang được thực đơn sử dụng nên không thể xoá.</span></div>
                        </c:if>
                        <div class="grid-2" style="align-items:start; gap:20px;">
                            <table>
                                <thead><tr><th>Tên loại bữa</th><th style="width:140px;">Thao tác</th></tr></thead>
                                <tbody>
                                    <c:forEach var="mt" items="${mealTypeList}">
                                        <tr>
                                            <td>
                                                <form method="post" action="${pageContext.request.contextPath}/dish" style="display:flex; gap:6px;">
                                                    <input type="hidden" name="action" value="mealTypeUpdate">
                                                    <input type="hidden" name="mealTypeId" value="${mt.mealTypeId}">
                                                    <input type="text" name="mealTypeName" class="form-control" value="${mt.mealTypeName}" style="max-width:180px;">
                                                    <button type="submit" class="btn btn-ghost btn-sm" title="Cập nhật"><i class="fas fa-save"></i></button>
                                                </form>
                                            </td>
                                            <td>
                                                <form method="post" action="${pageContext.request.contextPath}/dish"
                                                      onsubmit="return confirm('Xoá loại bữa &quot;${mt.mealTypeName}&quot;? Chỉ xoá được nếu chưa có thực đơn nào dùng.');">
                                                    <input type="hidden" name="action" value="mealTypeDelete">
                                                    <input type="hidden" name="mealTypeId" value="${mt.mealTypeId}">
                                                    <button type="submit" class="btn btn-ghost btn-sm" title="Xoá"><i class="fas fa-trash" style="color:#ef4444;"></i></button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty mealTypeList}">
                                        <tr><td colspan="2" style="text-align:center; padding:16px; color:#94a3b8;">Chưa có loại bữa nào.</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                            <form method="post" action="${pageContext.request.contextPath}/dish">
                                <input type="hidden" name="action" value="mealTypeCreate">
                                <div class="form-group">
                                    <label class="form-label">Thêm loại bữa mới</label>
                                    <input type="text" name="mealTypeName" class="form-control" placeholder="VD: Bữa xế" required>
                                </div>
                                <button type="submit" class="btn btn-primary btn-sm"><i class="fas fa-plus"></i> Thêm</button>
                            </form>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>
