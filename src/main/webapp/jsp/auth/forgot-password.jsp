<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu - KindergartenKitchen</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
            background: #fffbf5;
            position: relative;
            overflow: hidden;
        }
        
        /* Background decoration */
        body::before {
            content: '';
            position: absolute;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(251, 146, 60, 0.15) 0%, transparent 70%);
            border-radius: 50%;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            animation: pulse 8s ease-in-out infinite;
            pointer-events: none;
        }
        
        @keyframes pulse {
            0%, 100% { transform: translate(-50%, -50%) scale(1); opacity: 0.8; }
            50% { transform: translate(-50%, -50%) scale(1.1); opacity: 0.5; }
        }
        
        /* Floating particles */
        .particle {
            position: absolute;
            width: 6px;
            height: 6px;
            background: rgba(249, 115, 22, 0.3);
            border-radius: 50%;
            animation: float 6s ease-in-out infinite;
            pointer-events: none;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(0deg); opacity: 0.4; }
            50% { transform: translateY(-20px) rotate(180deg); opacity: 0.8; }
        }
        
        /* Floating home button */
        .floating-home-btn {
            position: fixed;
            top: 20px;
            left: 16px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 16px;
            background: rgba(255, 255, 255, 0.95);
            border: 1px solid rgba(249, 115, 22, 0.2);
            border-radius: 10px;
            color: #ea580c;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.3s ease;
            z-index: 100;
            box-shadow: 0 4px 20px rgba(249, 115, 22, 0.15);
        }
        
        .floating-home-btn:hover {
            background: #ea580c;
            color: white;
            left: 12px;
            box-shadow: 0 6px 25px rgba(234, 88, 12, 0.3);
        }
        
        .floating-home-btn i {
            font-size: 14px;
            transition: transform 0.3s ease;
        }
        
        .floating-home-btn:hover i {
            transform: translateX(-3px);
        }
        
        .login-card {
            background: rgba(255, 255, 255, 0.98);
            border: 1px solid rgba(249, 115, 22, 0.1);
            border-radius: 24px;
            overflow: hidden;
            width: 100%;
            max-width: 440px;
            position: relative;
            z-index: 1;
            animation: fadeInUp 0.6s cubic-bezier(0.16, 1, 0.3, 1);
            box-shadow: 
                0 25px 50px -12px rgba(249, 115, 22, 0.1),
                0 0 80px rgba(249, 115, 22, 0.05);
        }
        
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px) scale(0.96); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }
        
        .login-header {
            background: linear-gradient(180deg, rgba(249, 115, 22, 0.1) 0%, rgba(249, 115, 22, 0.02) 100%);
            border-bottom: 1px solid rgba(249, 115, 22, 0.08);
            padding: 40px 32px 36px;
            text-align: center;
            position: relative;
        }
        
        .login-header::before {
            content: '';
            position: absolute;
            inset: 0;
            background: radial-gradient(ellipse at 50% 0%, rgba(249, 115, 22, 0.2) 0%, transparent 60%);
            pointer-events: none;
        }
        
        .login-logo {
            width: 72px;
            height: 72px;
            background: linear-gradient(135deg, rgba(249, 115, 22, 0.2), rgba(251, 146, 60, 0.15));
            border: 1px solid rgba(249, 115, 22, 0.25);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 32px;
            color: #ea580c;
            animation: fadeInUp 0.6s 0.1s cubic-bezier(0.16, 1, 0.3, 1) both;
            box-shadow: 0 0 30px rgba(249, 115, 22, 0.2), inset 0 0 20px rgba(249, 115, 22, 0.05);
        }
        
        .login-header h1 {
            font-size: 22px;
            font-weight: 700;
            margin-bottom: 6px;
            color: #9a3412;
            animation: fadeInUp 0.6s 0.15s cubic-bezier(0.16, 1, 0.3, 1) both;
        }
        
        .login-header p {
            color: #c2410c;
            font-size: 13px;
            font-weight: 500;
            animation: fadeInUp 0.6s 0.2s cubic-bezier(0.16, 1, 0.3, 1) both;
        }
        
        .login-body {
            padding: 32px;
            animation: fadeInUp 0.6s 0.25s cubic-bezier(0.16, 1, 0.3, 1) both;
        }
        
        /* Alert */
        .alert-card { border-radius: 12px; padding: 14px 16px; margin-bottom: 24px; display: flex; align-items: center; gap: 12px; font-size: 13px; font-weight: 500; border: 1px solid; }
        .alert-card.danger { background: rgba(239, 68, 68, 0.08); border-color: rgba(239, 68, 68, 0.25); color: #dc2626; }
        .alert-card.success { background: rgba(34, 197, 94, 0.08); border-color: rgba(34, 197, 94, 0.25); color: #16a34a; }
        .alert-card i { font-size: 18px; }
        
        /* Form */
        .form-group { margin-bottom: 20px; }
        .form-label { display: block; font-size: 12px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.8px; color: #c2410c; margin-bottom: 10px; }
        .form-label i { color: #ea580c; margin-right: 6px; }
        .form-control { width: 100%; padding: 14px 16px; border: 1px solid rgba(249, 115, 22, 0.15); border-radius: 10px; font-family: 'Segoe UI', sans-serif; font-size: 14px; color: #7c2d12; background: rgba(255, 255, 255, 0.8); transition: all 0.3s ease; outline: none; }
        .form-control::placeholder { color: #c9a88a; }
        .form-control:focus { border-color: rgba(249, 115, 22, 0.5); background: #ffffff; box-shadow: 0 0 0 3px rgba(249, 115, 22, 0.1); }
        
        /* Button */
        .btn-login { width: 100%; padding: 14px; background: linear-gradient(135deg, #ea580c, #fb923c); color: white; border: none; border-radius: 10px; font-family: 'Segoe UI', sans-serif; font-size: 14px; font-weight: 700; cursor: pointer; transition: all 0.3s ease; display: flex; align-items: center; justify-content: center; gap: 8px; box-shadow: 0 4px 14px rgba(234, 88, 12, 0.3); }
        .btn-login:hover { transform: translateY(-2px); box-shadow: 0 10px 30px -5px rgba(234, 88, 12, 0.4); filter: brightness(1.05); }
        
        .back-link { display: flex; align-items: center; justify-content: center; gap: 6px; margin-top: 28px; padding-top: 24px; border-top: 1px solid rgba(249, 115, 22, 0.08); color: #c2410c; font-size: 13px; font-weight: 500; text-decoration: none; transition: color 0.2s; }
        .back-link:hover { color: #ea580c; }
    </style>
</head>
<body>
    <a href="${pageContext.request.contextPath}/" class="floating-home-btn">
        <i class="fas fa-arrow-left"></i>
        <span>Quay lại trang chủ</span>
    </a>
    
    <div class="login-card">
        <div class="login-header">
            <div class="login-logo"><i class="fas fa-key"></i></div>
            <h1>Lấy lại mật khẩu</h1>
            <p>Xác minh thông tin tài khoản để tiếp tục</p>
        </div>

        <div class="login-body">
            <c:if test="${not empty success}">
                <div class="alert-card success">
                    <i class="fas fa-check-circle"></i>
                    <span>${success}</span>
                </div>
            </c:if>

            <c:if test="${not empty errors}">
                <div class="alert-card danger">
                    <i class="fas fa-circle-exclamation"></i>
                    <div>
                        <c:forEach var="error" items="${errors}">
                            <div>• <c:out value="${error}"/></div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/forgot-password">
                <div class="form-group">
                    <label class="form-label"><i class="fas fa-user"></i> Tên đăng nhập</label>
                    <input type="text" name="username" value="${username}" class="form-control" required autofocus placeholder="Nhập tên đăng nhập">
                </div>

                <div class="form-group">
                    <label class="form-label"><i class="fas fa-envelope"></i> Email</label>
                    <input type="email" name="email" value="${email}" class="form-control" required placeholder="Nhập địa chỉ email">
                </div>

                <div class="form-group">
                    <label class="form-label"><i class="fas fa-phone"></i> Số điện thoại</label>
                    <input type="text" name="phone" value="${phone}" class="form-control" required placeholder="Nhập số điện thoại">
                </div>

                <button type="submit" class="btn-login">
                    <i class="fas fa-search"></i> Xác minh tài khoản
                </button>

                <a href="${pageContext.request.contextPath}/login" class="back-link">
                    <i class="fas fa-arrow-left"></i> Quay lại đăng nhập
                </a>
            </form>
        </div>
    </div>
</body>
</html>
