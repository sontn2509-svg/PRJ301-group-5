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
    <title>Tạo thực đơn tuần - KindergartenKitchen</title>
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
                        <div class="page-header-icon"><i class="fas fa-calendar-plus"></i></div>
                        <div><h1>Tạo thực đơn tuần mới</h1><p>Chọn cấp học và ngày Thứ 2 đầu tuần</p></div>
                    </div>
                </div>

                <c:if test="${param.success == 'false'}">
                    <div class="alert-card warning"><i class="fas fa-exclamation-triangle alert-icon"></i>
                        <span>Không tạo được — ngày chọn không phải Thứ 2, hoặc cấp học này đã có thực đơn cho đúng tuần đó rồi.</span>
                    </div>
                </c:if>

                <div class="panel" style="max-width:560px;">
                    <div class="panel-body">
                        <form method="post" action="${pageContext.request.contextPath}/menu">
                            <div class="form-group">
                                <label class="form-label">Cấp học <span style="color:#ef4444;">*</span></label>
                                <select name="levelId" class="form-select" required>
                                    <option value="" disabled selected>-- Chọn cấp học --</option>
                                    <c:forEach var="lv" items="${levelList}">
                                        <option value="${lv.levelId}">${lv.levelName}</option>
                                    </c:forEach>
                                </select>
                                <c:if test="${empty levelList}">
                                    <div style="color:#f59e0b; font-size:13px; margin-top:6px;">Chưa có cấp học nào trong hệ thống (Admin cần cấu hình bảng Levels).</div>
                                </c:if>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Ngày bắt đầu tuần (Thứ 2) <span style="color:#ef4444;">*</span></label>
                                <input type="date" name="weekStartDate" class="form-control" required>
                                <div style="color:#94a3b8; font-size:13px; margin-top:6px;">Hệ thống tự tính tuần kết thúc là Chủ nhật (+6 ngày). Bắt buộc chọn đúng ngày Thứ 2 để các tuần luôn đồng bộ.</div>
                            </div>

                            <div style="display:flex; gap:12px; margin-top:20px;">
                                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Tạo thực đơn</button>
                                <a href="${pageContext.request.contextPath}/menu/list" class="btn btn-outline">Huỷ</a>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>
