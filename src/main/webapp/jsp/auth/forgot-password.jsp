<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu - KindergartenKitchen</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="login-container">
    <div class="login-card">
        <div class="login-header">
            <div class="login-logo">
                <i class="fas fa-key" style="color: var(--primary-color);"></i>
            </div>
            <h1>Lấy lại mật khẩu</h1>
            <p>Nhập thông tin đã đăng ký để đặt lại mật khẩu</p>
        </div>
        
        <div class="login-body">
            <c:if test="${not empty errors}">
                <div class="alert-card danger" style="margin-bottom: 20px;">
                    <span class="alert-icon">⚠️</span>
                    <div class="alert-content">
                        <c:forEach var="error" items="${errors}">
                            <p style="margin: 0;">• <c:out value="${error}"/></p>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty success}">
                <div class="alert-card success" style="margin-bottom: 20px;">
                    <span class="alert-icon">✅</span>
                    <div class="alert-content">
                        <p><c:out value="${success}"/></p>
                    </div>
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/forgot-password">
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-user"></i> Tên đăng nhập
                    </label>
                    <input type="text" name="username" value="${username}" class="form-control" 
                           required autofocus placeholder="Nhập tên đăng nhập">
                </div>

                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-envelope"></i> Email
                    </label>
                    <input type="email" name="email" value="${email}" class="form-control" 
                           required placeholder="Nhập địa chỉ email">
                </div>

                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-phone"></i> Số điện thoại
                    </label>
                    <input type="text" name="phone" value="${phone}" class="form-control" 
                           required placeholder="Nhập số điện thoại">
                </div>

                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-key"></i> Mật khẩu mới
                    </label>
                    <input type="password" name="newPassword" class="form-control" 
                           minlength="6" required placeholder="Nhập mật khẩu mới (ít nhất 6 ký tự)">
                </div>

                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-check-double"></i> Xác nhận mật khẩu mới
                    </label>
                    <input type="password" name="confirmPassword" class="form-control" 
                           minlength="6" required placeholder="Nhập lại mật khẩu mới">
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 10px;">
                    <i class="fas fa-sync-alt"></i> Đặt lại mật khẩu
                </button>
                
                <div style="text-align: center; margin-top: 20px;">
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline btn-sm">
                        <i class="fas fa-arrow-left"></i> Quay lại đăng nhập
                    </a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
