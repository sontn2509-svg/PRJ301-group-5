<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chờ phê duyệt - KindergartenKitchen</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: 'Segoe UI', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
            background: #0a0a0f;
            position: relative;
        }
        
        body::before {
            content: '';
            position: absolute;
            inset: 0;
            background: 
                radial-gradient(ellipse 80% 50% at 20% 40%, rgba(245, 158, 11, 0.08), transparent),
                radial-gradient(ellipse 60% 40% at 80% 60%, rgba(251, 191, 36, 0.05), transparent);
            pointer-events: none;
        }
        
        .login-card {
            background: rgba(15, 15, 20, 0.95);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 20px;
            overflow: hidden;
            width: 100%;
            max-width: 420px;
            position: relative;
            z-index: 1;
            animation: fadeInUp 0.6s cubic-bezier(0.16, 1, 0.3, 1);
            backdrop-filter: blur(20px);
            box-shadow: 
                0 0 0 1px rgba(255,255,255,0.05),
                0 25px 50px -12px rgba(0, 0, 0, 0.5),
                0 0 100px rgba(245, 158, 11, 0.1);
        }
        
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px) scale(0.96); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }
        
        .login-header {
            background: linear-gradient(180deg, rgba(245, 158, 11, 0.2) 0%, rgba(245, 158, 11, 0.05) 100%);
            border-bottom: 1px solid rgba(255, 255, 255, 0.06);
            padding: 40px 32px 36px;
            text-align: center;
            position: relative;
        }
        
        .login-header::before {
            content: '';
            position: absolute;
            inset: 0;
            background: radial-gradient(ellipse at 50% 0%, rgba(245, 158, 11, 0.3) 0%, transparent 60%);
            pointer-events: none;
        }
        
        .login-logo {
            width: 72px;
            height: 72px;
            background: linear-gradient(135deg, rgba(245, 158, 11, 0.3), rgba(251, 191, 36, 0.2));
            border: 1px solid rgba(245, 158, 11, 0.3);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 32px;
            color: #fbbf24;
            backdrop-filter: blur(10px);
            box-shadow: 0 0 30px rgba(245, 158, 11, 0.3);
        }
        
        .login-header h1 { font-size: 22px; font-weight: 700; margin-bottom: 6px; color: #ffffff; }
        .login-header p { color: #71717a; font-size: 13px; font-weight: 500; }
        
        .login-body { padding: 32px; text-align: center; }
        
        .icon-large { font-size: 64px; margin-bottom: 20px; animation: pulse 2s ease-in-out infinite; }
        
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }
        
        .waiting-title { font-size: 18px; font-weight: 700; color: #fafafa; margin-bottom: 12px; }
        .waiting-message { font-size: 14px; color: #71717a; line-height: 1.6; margin-bottom: 12px; }
        .waiting-note { font-size: 13px; color: #52525b; margin-bottom: 24px; }
        
        .btn-logout { width: 100%; padding: 14px; background: linear-gradient(135deg, #f59e0b, #fbbf24); color: white; border: none; border-radius: 10px; font-family: 'Segoe UI', sans-serif; font-size: 14px; font-weight: 700; cursor: pointer; transition: all 0.3s ease; display: flex; align-items: center; justify-content: center; gap: 8px; box-shadow: 0 4px 14px rgba(245, 158, 11, 0.3); text-decoration: none; }
        .btn-logout:hover { transform: translateY(-2px); box-shadow: 0 10px 30px -5px rgba(245, 158, 11, 0.5); }
    </style>
</head>
<body>
    <div class="login-card">
        <div class="login-header">
            <div class="login-logo"><i class="fas fa-hourglass-half"></i></div>
            <h1>Chờ phê duyệt</h1>
            <p>Tài khoản của bạn đang chờ được kích hoạt</p>
        </div>

        <div class="login-body">
            <div class="icon-large">⏳</div>
            <h3 class="waiting-title">Tài khoản chưa được kích hoạt</h3>
            <p class="waiting-message"><c:out value="${message}"/></p>
            <p class="waiting-note">Vui lòng liên hệ quản trị viên để được kích hoạt tài khoản.</p>

            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
                <i class="fas fa-right-from-bracket"></i> Đăng xuất
            </a>
        </div>
    </div>
</body>
</html>
