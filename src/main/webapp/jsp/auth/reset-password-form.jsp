<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt lại mật khẩu - KindergartenKitchen</title>
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
                radial-gradient(ellipse 80% 50% at 20% 40%, rgba(120, 119, 198, 0.12), transparent),
                radial-gradient(ellipse 60% 40% at 80% 60%, rgba(167, 139, 250, 0.08), transparent);
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
                0 0 100px rgba(139, 92, 246, 0.1);
        }
        
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px) scale(0.96); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }
        
        .login-header {
            background: linear-gradient(180deg, rgba(139, 92, 246, 0.2) 0%, rgba(139, 92, 246, 0.05) 100%);
            border-bottom: 1px solid rgba(255, 255, 255, 0.06);
            padding: 40px 32px 36px;
            text-align: center;
            position: relative;
        }
        
        .login-header::before {
            content: '';
            position: absolute;
            inset: 0;
            background: radial-gradient(ellipse at 50% 0%, rgba(139, 92, 246, 0.3) 0%, transparent 60%);
            pointer-events: none;
        }
        
        .login-logo {
            width: 72px;
            height: 72px;
            background: linear-gradient(135deg, rgba(139, 92, 246, 0.3), rgba(167, 139, 250, 0.2));
            border: 1px solid rgba(139, 92, 246, 0.3);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 32px;
            color: #a78bfa;
            backdrop-filter: blur(10px);
            box-shadow: 0 0 30px rgba(139, 92, 246, 0.3);
        }
        
        .login-header h1 { font-size: 22px; font-weight: 700; margin-bottom: 6px; color: #ffffff; }
        .login-header p { color: #71717a; font-size: 13px; font-weight: 500; }
        
        .login-body { padding: 32px; }
        
        .alert-card { border-radius: 12px; padding: 14px 16px; margin-bottom: 20px; display: flex; align-items: flex-start; gap: 12px; font-size: 13px; font-weight: 500; background: rgba(239, 68, 68, 0.1); border: 1px solid rgba(239, 68, 68, 0.3); color: #fca5a5; }
        .alert-card i { font-size: 18px; margin-top: 2px; }
        
        .form-group { margin-bottom: 20px; }
        .form-label { display: block; font-size: 12px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.8px; color: #71717a; margin-bottom: 10px; }
        .form-label i { color: #a78bfa; margin-right: 6px; }
        .form-control { width: 100%; padding: 14px 16px; border: 1px solid rgba(255, 255, 255, 0.08); border-radius: 10px; font-family: 'Segoe UI', sans-serif; font-size: 14px; color: #fafafa; background: rgba(255, 255, 255, 0.03); transition: all 0.3s ease; outline: none; }
        .form-control::placeholder { color: #52525b; }
        .form-control:focus { border-color: rgba(139, 92, 246, 0.6); background: rgba(139, 92, 246, 0.05); box-shadow: 0 0 0 3px rgba(139, 92, 246, 0.1); }
        
        .btn-login { width: 100%; padding: 14px; background: linear-gradient(135deg, #8b5cf6, #a78bfa); color: white; border: none; border-radius: 10px; font-family: 'Segoe UI', sans-serif; font-size: 14px; font-weight: 700; cursor: pointer; transition: all 0.3s ease; display: flex; align-items: center; justify-content: center; gap: 8px; box-shadow: 0 4px 14px rgba(139, 92, 246, 0.3); }
        .btn-login:hover { transform: translateY(-2px); box-shadow: 0 10px 30px -5px rgba(139, 92, 246, 0.5); }
        
        .back-link { display: flex; align-items: center; justify-content: center; gap: 6px; margin-top: 28px; padding-top: 24px; border-top: 1px solid rgba(255, 255, 255, 0.06); color: #71717a; font-size: 13px; font-weight: 500; text-decoration: none; transition: color 0.2s; }
        .back-link:hover { color: #a78bfa; }
    </style>
</head>
<body>
    <div class="login-card">
        <div class="login-header">
            <div class="login-logo"><i class="fas fa-shield-halved"></i></div>
            <h1>Đặt lại mật khẩu</h1>
            <p>Xác minh thành công. Nhập mật khẩu mới cho <strong>${verifiedUsername}</strong></p>
        </div>

        <div class="login-body">
            <c:if test="${not empty errors}">
                <div class="alert-card">
                    <i class="fas fa-exclamation-circle"></i>
                    <div>
                        <c:forEach var="error" items="${errors}">
                            <div>• <c:out value="${error}"/></div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/forgot-password">
                <input type="hidden" name="verified" value="true">
                <input type="hidden" name="userId" value="${userId}">

                <div class="form-group">
                    <label class="form-label"><i class="fas fa-key"></i> Mật khẩu mới</label>
                    <input type="password" name="newPassword" class="form-control" minlength="6" required autofocus placeholder="Ít nhất 6 ký tự">
                </div>

                <div class="form-group">
                    <label class="form-label"><i class="fas fa-check-double"></i> Xác nhận mật khẩu</label>
                    <input type="password" name="confirmPassword" class="form-control" minlength="6" required placeholder="Nhập lại mật khẩu mới">
                </div>

                <button type="submit" class="btn-login">
                    <i class="fas fa-floppy-disk"></i> Lưu mật khẩu mới
                </button>

                <a href="${pageContext.request.contextPath}/login" class="back-link">
                    <i class="fas fa-arrow-left"></i> Quay lại đăng nhập
                </a>
            </form>
        </div>
    </div>
</body>
</html>
