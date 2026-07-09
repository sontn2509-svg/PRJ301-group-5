<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi mật khẩu - KindergartenKitchen</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="app-container">
        <jsp:include page="/jsp/layout/sidebar-admin.jsp"/>
        <div class="main-content">
            <jsp:include page="/jsp/layout/header.jsp"/>
            <main class="page-content">
                <div class="page-header-card">
                    <div class="page-header-content">
                        <div class="page-header-icon"><i class="fas fa-key"></i></div>
                        <div>
                            <h1>Đổi mật khẩu</h1>
                            <p>Thay đổi mật khẩu để bảo mật tài khoản của bạn</p>
                        </div>
                    </div>
                </div>

                <c:if test="${not empty errors}">
                    <div class="alert-card danger">
                        <i class="fas fa-exclamation-circle alert-icon"></i>
                        <div><strong>Vui lòng kiểm tra lại</strong>
                            <ul style="margin: 8px 0 0 20px;">
                                <c:forEach var="error" items="${errors}"><li>${error}</li></c:forEach>
                            </ul>
                        </div>
                    </div>
                </c:if>

                <c:if test="${not empty success}">
                    <div class="alert-card success">
                        <i class="fas fa-check-circle alert-icon"></i>
                        <span>${success}</span>
                    </div>
                </c:if>

                <div class="panel" style="max-width: 500px;">
                    <div class="panel-header">
                        <div class="panel-title"><span class="icon"><i class="fas fa-key"></i></span>Thông tin mật khẩu</div>
                    </div>
                    <div class="panel-body">
                        <form method="post" action="${pageContext.request.contextPath}/admin/change-password">
                            <div class="form-group">
                                <label class="form-label"><i class="fas fa-lock" style="color: #f97316; margin-right: 6px;"></i>Mật khẩu hiện tại</label>
                                <input type="password" name="currentPassword" class="form-control" required autofocus placeholder="Nhập mật khẩu hiện tại">
                            </div>
                            <div class="form-group">
                                <label class="form-label"><i class="fas fa-key" style="color: #f97316; margin-right: 6px;"></i>Mật khẩu mới</label>
                                <input type="password" name="newPassword" class="form-control" minlength="6" required placeholder="Ít nhất 6 ký tự">
                            </div>
                            <div class="form-group">
                                <label class="form-label"><i class="fas fa-check-double" style="color: #f97316; margin-right: 6px;"></i>Xác nhận mật khẩu mới</label>
                                <input type="password" name="confirmPassword" class="form-control" minlength="6" required placeholder="Nhập lại mật khẩu mới">
                            </div>
                            <div style="display: flex; gap: 12px; margin-top: 8px;">
                                <button type="submit" class="btn btn-primary"><i class="fas fa-floppy-disk"></i> Đổi mật khẩu</button>
                                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-ghost"><i class="fas fa-arrow-left"></i> Quay lại</a>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>
