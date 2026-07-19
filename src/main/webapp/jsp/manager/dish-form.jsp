<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
    <title>${empty dish ? "Thêm món ăn" : "Sửa món ăn"} - KindergartenKitchen</title>
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
                        <div><h1>${empty dish ? "Thêm món ăn" : "Sửa món ăn"}</h1><p>Thông tin món sẽ dùng khi gắn vào thực đơn hằng tuần</p></div>
                    </div>
                </div>

                <div class="panel" style="max-width:560px;">
                    <div class="panel-body">
                        <form method="post" action="${pageContext.request.contextPath}/dish">
                            <c:if test="${not empty dish}">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="dishId" value="${dish.dishId}">
                            </c:if>

                            <div class="form-group">
                                <label class="form-label">Tên món <span style="color:#ef4444;">*</span></label>
                                <input type="text" name="dishName" class="form-control" required
                                       value="${dish.dishName}" placeholder="VD: Cơm gà xối mỡ">
                            </div>

                            <div class="form-group">
                                <label class="form-label">Mô tả</label>
                                <textarea name="description" class="form-control" rows="3" placeholder="Mô tả ngắn về món ăn (tuỳ chọn)">${dish.description}</textarea>
                            </div>

                            <div style="display:flex; gap:12px; margin-top:20px;">
                                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Lưu món ăn</button>
                                <a href="${pageContext.request.contextPath}/dish/list" class="btn btn-outline">Huỷ</a>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>
