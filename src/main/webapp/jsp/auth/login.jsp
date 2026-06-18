<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - KindergartenKitchen</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="login-container">
    <div class="login-card">
        <div class="login-header">
            <div class="login-logo">
                <i class="fas fa-utensils" style="color: var(--primary-color);"></i>
            </div>
            <h1>KindergartenKitchen</h1>
            <p>Hệ thống quản lý bếp ăn mầm non</p>
        </div>
        
        <div class="login-body">
            <c:if test="${not empty error}">
                <div class="alert-card danger" style="margin-bottom: 20px;">
                    <span class="alert-icon">⚠️</span>
                    <div class="alert-content">
                        <p>${error}</p>
                    </div>
                </div>
            </c:if>
            
            <form method="post" action="${pageContext.request.contextPath}/login">
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-user"></i> Tên đăng nhập
                    </label>
                    <input type="text" name="username" value="${username}" class="form-control" 
                           required autofocus placeholder="Nhập tên đăng nhập">
                </div>
                
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-lock"></i> Mật khẩu
                    </label>
                    <input type="password" name="password" class="form-control" 
                           required placeholder="Nhập mật khẩu">
                </div>
                
                <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 10px;">
                    <i class="fas fa-sign-in-alt"></i> Đăng nhập
                </button>
                
                <div style="text-align: center; margin-top: 20px;">
                    <a href="${pageContext.request.contextPath}/forgot-password" class="btn btn-outline btn-sm">
                        <i class="fas fa-key"></i> Quên mật khẩu?
                    </a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
