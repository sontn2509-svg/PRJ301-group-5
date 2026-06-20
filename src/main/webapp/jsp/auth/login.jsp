<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - KindergartenKitchen</title>
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
        
        /* Animated background circles */
        body::before {
            content: '';
            position: absolute;
            inset: 0;
            background: 
                radial-gradient(ellipse 80% 50% at 20% 40%, rgba(251, 146, 60, 0.15), transparent),
                radial-gradient(ellipse 60% 40% at 80% 60%, rgba(253, 186, 116, 0.12), transparent),
                radial-gradient(ellipse 40% 30% at 50% 80%, rgba(249, 115, 22, 0.08), transparent);
            animation: bgPulse 8s ease-in-out infinite;
        }
        
        @keyframes bgPulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.7; }
        }
        
        /* Grid pattern overlay */
        body::after {
            content: '';
            position: absolute;
            inset: 0;
            background-image: 
                linear-gradient(rgba(249, 115, 22, 0.03) 1px, transparent 1px),
                linear-gradient(90deg, rgba(249, 115, 22, 0.03) 1px, transparent 1px);
            background-size: 50px 50px;
            pointer-events: none;
        }
        
        .login-card {
            background: #ffffff;
            border: 1px solid rgba(249, 115, 22, 0.1);
            border-radius: 20px;
            overflow: hidden;
            width: 100%;
            max-width: 420px;
            position: relative;
            z-index: 1;
            animation: fadeInUp 0.6s cubic-bezier(0.16, 1, 0.3, 1);
            box-shadow: 
                0 0 0 1px rgba(249, 115, 22, 0.05),
                0 25px 50px -12px rgba(249, 115, 22, 0.15);
        }
        
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px) scale(0.96); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }
        
        .login-header {
            background: linear-gradient(180deg, rgba(251, 146, 60, 0.15) 0%, rgba(253, 186, 116, 0.08) 100%);
            border-bottom: 1px solid rgba(249, 115, 22, 0.1);
            padding: 20px 32px 36px;
            text-align: center;
            position: relative;
        }
        
        .home-link {
            position: absolute;
            top: 16px;
            right: 20px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            background: rgba(249, 115, 22, 0.1);
            border: 1px solid rgba(249, 115, 22, 0.2);
            border-radius: 8px;
            color: #ea580c;
            font-size: 12px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s ease;
        }
        
        .home-link:hover {
            background: rgba(249, 115, 22, 0.2);
            color: #c2410c;
        }
        
        .home-link i { font-size: 11px; }
        
        .login-header::before {
            content: '';
            position: absolute;
            inset: 0;
            background: radial-gradient(ellipse at 50% 0%, rgba(251, 146, 60, 0.25) 0%, transparent 60%);
            pointer-events: none;
        }
        
        .login-logo {
            width: 72px;
            height: 72px;
            background: linear-gradient(135deg, rgba(249, 115, 22, 0.3), rgba(251, 146, 60, 0.2));
            border: 1px solid rgba(249, 115, 22, 0.3);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 32px;
            color: #ea580c;
            animation: fadeInUp 0.6s 0.1s cubic-bezier(0.16, 1, 0.3, 1) both;
            box-shadow: 
                0 0 30px rgba(249, 115, 22, 0.2),
                inset 0 0 20px rgba(249, 115, 22, 0.1);
        }
        
        .login-header h1 {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 8px;
            color: #9a3412;
            animation: fadeInUp 0.6s 0.15s cubic-bezier(0.16, 1, 0.3, 1) both;
            letter-spacing: -0.5px;
        }
        
        .login-header p {
            color: #9a3412;
            opacity: 0.7;
            font-size: 13px;
            font-weight: 500;
            animation: fadeInUp 0.6s 0.2s cubic-bezier(0.16, 1, 0.3, 1) both;
        }
        
        .login-body {
            padding: 32px;
            animation: fadeInUp 0.6s 0.25s cubic-bezier(0.16, 1, 0.3, 1) both;
        }
        
        /* Alert boxes */
        .alert-card {
            border-radius: 12px;
            padding: 14px 16px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 13px;
            font-weight: 500;
            border: 1px solid;
            animation: fadeInUp 0.4s ease;
        }
        
        .alert-card.danger {
            background: rgba(239, 68, 68, 0.1);
            border-color: rgba(239, 68, 68, 0.3);
            color: #dc2626;
        }
        
        .alert-card.success {
            background: rgba(34, 197, 94, 0.1);
            border-color: rgba(34, 197, 94, 0.3);
            color: #16a34a;
        }
        
        .alert-card i { font-size: 18px; }
        
        /* Form elements */
        .form-group { margin-bottom: 20px; }
        
        .form-label {
            display: block;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            color: #9a3412;
            margin-bottom: 10px;
        }
        
        .form-label i { color: #ea580c; margin-right: 6px; }
        
        .form-control {
            width: 100%;
            padding: 14px 16px;
            border: 1px solid rgba(249, 115, 22, 0.2);
            border-radius: 10px;
            font-family: 'Segoe UI', sans-serif;
            font-size: 14px;
            color: #7c2d12;
            background: #fffbf5;
            transition: all 0.3s ease;
            outline: none;
        }
        
        .form-control::placeholder { color: #c2410c; opacity: 0.5; }
        
        .form-control:focus {
            border-color: rgba(249, 115, 22, 0.6);
            background: #ffffff;
            box-shadow: 
                0 0 0 3px rgba(249, 115, 22, 0.1),
                0 0 20px rgba(249, 115, 22, 0.1);
        }
        
        /* Remember me checkbox */
        .remember-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
        }
        
        .remember-me {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
            font-size: 13px;
            color: #9a3412;
        }
        
        .remember-me input[type="checkbox"] {
            width: 18px;
            height: 18px;
            accent-color: #ea580c;
            cursor: pointer;
        }
        
        .forgot-link {
            color: #ea580c;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            transition: color 0.2s;
        }
        
        .forgot-link:hover { color: #c2410c; }
        
        /* Submit button */
        .btn-login {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #ea580c, #fb923c);
            color: white;
            border: none;
            border-radius: 10px;
            font-family: 'Segoe UI', sans-serif;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            letter-spacing: 0.5px;
            position: relative;
            overflow: hidden;
        }
        
        .btn-login::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, rgba(255,255,255,0.2), transparent);
            opacity: 0;
            transition: opacity 0.3s;
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 
                0 10px 30px -5px rgba(234, 88, 12, 0.4),
                0 0 0 1px rgba(234, 88, 12, 0.5);
        }
        
        .btn-login:hover::before { opacity: 1; }
        
        .btn-login:active { transform: translateY(0); }
        
        /* Bottom link */
        .back-link {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            margin-top: 28px;
            padding-top: 24px;
            border-top: 1px solid rgba(249, 115, 22, 0.1);
            color: #9a3412;
            font-size: 13px;
            font-weight: 500;
            text-decoration: none;
            transition: color 0.2s;
        }
        
        .back-link:hover { color: #ea580c; }
        .back-link i { font-size: 12px; }
        
        /* Floating particles */
        .particle {
            position: absolute;
            width: 4px;
            height: 4px;
            background: rgba(249, 115, 22, 0.4);
            border-radius: 50%;
            animation: float 6s ease-in-out infinite;
            pointer-events: none;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(0deg); opacity: 0.4; }
            50% { transform: translateY(-20px) rotate(180deg); opacity: 0.8; }
        }
        
        /* Floating home button on left edge */
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
        
    </style>
</head>
<body>
    <a href="${pageContext.request.contextPath}/" class="floating-home-btn">
        <i class="fas fa-arrow-left"></i>
        <span>Quay lại trang chủ</span>
    </a>
    
        <div class="login-card">
        <div class="login-header">
            <div class="login-logo">
                <i class="fas fa-utensils"></i>
            </div>
            <h1>KindergartenKitchen</h1>
            <p>Đăng nhập để truy cập hệ thống</p>
        </div>

        <div class="login-body">
            <c:if test="${not empty errors}">
                <div class="alert-card danger">
                    <i class="fas fa-circle-exclamation"></i>
                    <span>${errors}</span>
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
