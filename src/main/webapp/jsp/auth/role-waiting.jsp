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
        <div class="login-header" style="background: linear-gradient(135deg, var(--warning-color), #FFA000);">
            <div class="login-logo" style="background: rgba(255,255,255,0.2); color: white;">
                <i class="fas fa-hourglass-half"></i>
            </div>
            <h1>Chờ phê duyệt</h1>
            <p>Tài khoản của bạn đang chờ được phê duyệt</p>
        </div>
        
        <div class="login-body" style="text-align: center;">
            <div style="padding: 20px 0;">
                <div style="font-size: 60px; margin-bottom: 20px;">⏳</div>
                <h3 style="color: var(--text-color); margin-bottom: 15px;">Tài khoản chưa được kích hoạt</h3>
                <p style="color: var(--text-light); margin-bottom: 20px;">
                    <c:out value="${message}"/>
                </p>
                <p style="color: var(--text-light); font-size: 14px;">
                    Vui lòng liên hệ quản trị viên để được kích hoạt tài khoản.
                </p>
            </div>
            
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-primary" style="width: 100%;">
                <i class="fas fa-sign-out-alt"></i> Đăng xuất
            </a>
        </div>
    </div>
</body>
</html>
