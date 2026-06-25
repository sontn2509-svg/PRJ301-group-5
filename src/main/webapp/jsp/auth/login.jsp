<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - KindergartenKitchen</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/shared.css">
    <style>
        body {
            background: #f5f7fa;
        }
        .login-card {
            background: #ffffff;
            border-radius: 24px;
            overflow: hidden;
            width: 100%;
            max-width: 440px;
            position: relative;
            z-index: 1;
            animation: fadeInUp 0.6s cubic-bezier(0.16, 1, 0.3, 1);
            box-shadow: 0 25px 50px -12px rgba(0,0,0,0.1);
        }
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px) scale(0.96); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }
        .login-header {
            background: linear-gradient(135deg, #92400e 0%, #b45309 50%, #d97706 100%);
            padding: 32px;
            text-align: center;
            position: relative;
        }
        .login-header::before {
            content: '';
            position: absolute;
            inset: 0;
            background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.05'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
            pointer-events: none;
        }
        .login-logo {
            width: 80px;
            height: 80px;
            background: rgba(255,255,255,0.2);
            backdrop-filter: blur(10px);
            border: 2px solid rgba(255,255,255,0.3);
            border-radius: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 36px;
            color: #fff;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
        }
        .login-header h1 {
            font-size: 26px;
            font-weight: 800;
            margin-bottom: 8px;
            color: #fff;
            letter-spacing: -0.5px;
        }
        .login-header p {
            color: rgba(255,255,255,0.85);
            font-size: 14px;
            font-weight: 500;
        }
        .login-body { padding: 32px; }
        .alert-card { border-radius: 14px; padding: 14px 18px; margin-bottom: 24px; display: flex; align-items: center; gap: 12px; font-size: 14px; font-weight: 500; border: 1px solid; }
        .alert-card.danger { background: rgba(239, 68, 68, 0.1); border-color: rgba(239, 68, 68, 0.3); color: #dc2626; }
        .alert-card i { font-size: 20px; }
        .form-group { margin-bottom: 20px; }
        .form-label { display: block; font-size: 13px; font-weight: 700; color: #374151; margin-bottom: 10px; }
        .form-label i { color: #f97316; margin-right: 6px; }
        .form-control {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            font-family: 'Segoe UI', sans-serif;
            font-size: 14px;
            color: #1e293b;
            background: #fff;
            transition: all 0.3s ease;
            outline: none;
        }
        .form-control::placeholder { color: #9ca3af; }
        .form-control:focus { border-color: #f97316; box-shadow: 0 0 0 4px rgba(249,115,22,0.1); }
        .remember-row { display: flex; align-items: center; justify-content: space-between; margin-bottom: 24px; }
        .remember-me { display: flex; align-items: center; gap: 10px; cursor: pointer; font-size: 14px; color: #374151; }
        .remember-me input[type="checkbox"] { width: 18px; height: 18px; accent-color: #f97316; cursor: pointer; }
        .forgot-link { color: #f97316; font-size: 14px; font-weight: 600; text-decoration: none; transition: color 0.2s; }
        .forgot-link:hover { color: #ea580c; }
        .btn-login {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #f97316, #fb923c);
            color: white;
            border: none;
            border-radius: 12px;
            font-family: 'Segoe UI', sans-serif;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            box-shadow: 0 4px 14px rgba(249,115,22,0.3);
        }
        .btn-login:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(249,115,22,0.4); }
        .btn-login:active { transform: translateY(0); }
        .back-link { display: flex; align-items: center; justify-content: center; gap: 8px; margin-top: 24px; padding-top: 24px; border-top: 1px solid #f1f5f9; color: #64748b; font-size: 14px; font-weight: 500; text-decoration: none; transition: color 0.2s; }
        .back-link:hover { color: #f97316; }
        .back-link i { font-size: 12px; }
        .floating-home-btn {
            position: fixed;
            top: 20px;
            left: 16px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 16px;
            background: rgba(255,255,255,0.95);
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            color: #1e293b;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.3s ease;
            z-index: 100;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        .floating-home-btn:hover { background: #1e293b; color: #fff; box-shadow: 0 6px 24px rgba(0,0,0,0.15); }
    </style>
</head>
<body>
    <a href="${pageContext.request.contextPath}/" class="floating-home-btn">
        <i class="fas fa-arrow-left"></i>
        <span>Quay lại</span>
    </a>
    <div class="login-card" style="margin: 0 auto;">
        <div class="login-header">
            <div class="login-logo"><i class="fas fa-utensils"></i></div>
            <h1>KindergartenKitchen</h1>
            <p>Hệ thống quản lý bếp ăn mầm non</p>
        </div>
        <div class="login-body">
            <c:if test="${not empty error}">
                <div class="alert-card danger">
                    <i class="fas fa-circle-exclamation"></i>
                    <span>${error}</span>
                </div>
            </c:if>
            <form method="post" action="${pageContext.request.contextPath}/login">
                <div class="form-group">
                    <label class="form-label"><i class="fas fa-user"></i> Tên đăng nhập</label>
                    <input type="text" name="username" value="${param.username}" class="form-control" required autofocus placeholder="Nhập tên đăng nhập">
                </div>
                <div class="form-group">
                    <label class="form-label"><i class="fas fa-lock"></i> Mật khẩu</label>
                    <input type="password" name="password" class="form-control" required placeholder="Nhập mật khẩu">
                </div>
                <div class="remember-row">
                    <label class="remember-me">
                        <input type="checkbox" name="remember" value="true">
                        <span>Ghi nhớ đăng nhập</span>
                    </label>
                    <a href="${pageContext.request.contextPath}/forgot-password" class="forgot-link">Quên mật khẩu?</a>
                </div>
                <button type="submit" class="btn-login">
                    <i class="fas fa-arrow-right-to-bracket"></i>
                    Đăng nhập
                </button>
            </form>
            <a href="${pageContext.request.contextPath}/forgot-password" class="back-link">
                <i class="fas fa-key"></i>
                Quên mật khẩu? Khôi phục tài khoản
            </a>
        </div>
    </div>
</body>
</html>
