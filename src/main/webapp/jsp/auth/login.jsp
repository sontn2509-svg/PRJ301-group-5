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
        :root {
            --primary-start: #ea580c;
            --primary-mid: #f97316;
            --primary-end: #fb923c;
            --sidebar-dark: #1e293b;
            --bg-light: #f5f7fa;
            --bg-mid: #e2e8f0;
            --text-dark: #0f172a;
            --text-muted: #64748b;
            --text-light: #94a3b8;
            --border: #e2e8f0;
            --white: #ffffff;
            --danger: #ef4444;
            --danger-bg: #fef2f2;
            --danger-border: #fecaca;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            background: linear-gradient(145deg, var(--bg-light) 0%, var(--bg-mid) 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px 16px;
            position: relative;
            overflow-x: hidden;
        }

        /* Animated background decoration */
        .bg-decoration {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            overflow: hidden;
            z-index: 0;
        }

        .bg-circle {
            position: absolute;
            border-radius: 50%;
            filter: blur(80px);
            opacity: 0.4;
        }

        .bg-circle-1 {
            width: 500px;
            height: 500px;
            background: linear-gradient(135deg, rgba(234, 88, 12, 0.15), rgba(249, 115, 22, 0.08));
            top: -200px;
            right: -100px;
            animation: float1 20s ease-in-out infinite;
        }

        .bg-circle-2 {
            width: 400px;
            height: 400px;
            background: linear-gradient(135deg, rgba(251, 146, 60, 0.12), rgba(234, 88, 12, 0.06));
            bottom: -150px;
            left: -100px;
            animation: float2 25s ease-in-out infinite;
        }

        .bg-circle-3 {
            width: 300px;
            height: 300px;
            background: linear-gradient(135deg, rgba(249, 115, 22, 0.1), rgba(251, 146, 60, 0.05));
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            animation: pulse 30s ease-in-out infinite;
        }

        @keyframes float1 {
            0%, 100% { transform: translate(0, 0) scale(1); }
            33% { transform: translate(-30px, 30px) scale(1.05); }
            66% { transform: translate(20px, -20px) scale(0.95); }
        }

        @keyframes float2 {
            0%, 100% { transform: translate(0, 0) scale(1); }
            33% { transform: translate(40px, -20px) scale(1.08); }
            66% { transform: translate(-20px, 30px) scale(0.92); }
        }

        @keyframes pulse {
            0%, 100% { transform: translate(-50%, -50%) scale(1); opacity: 0.3; }
            50% { transform: translate(-50%, -50%) scale(1.3); opacity: 0.15; }
        }

        /* Login card */
        .login-container {
            width: 100%;
            max-width: 420px;
            position: relative;
            z-index: 1;
            animation: slideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1);
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .login-card {
            background: var(--white);
            border-radius: 24px;
            box-shadow: 
                0 4px 6px -1px rgba(0, 0, 0, 0.05),
                0 10px 20px -2px rgba(0, 0, 0, 0.04),
                0 25px 50px -12px rgba(0, 0, 0, 0.08);
            border: 1px solid rgba(226, 232, 240, 0.8);
            overflow: hidden;
            position: relative;
        }

        .login-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-start), var(--primary-mid), var(--primary-end));
        }

        /* Header section */
        .login-header {
            padding: 48px 36px 32px;
            text-align: center;
            background: linear-gradient(180deg, rgba(249, 115, 22, 0.03) 0%, transparent 100%);
        }

        .logo-wrapper {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 80px;
            height: 80px;
            background: linear-gradient(145deg, var(--primary-start), var(--primary-mid), var(--primary-end));
            border-radius: 22px;
            margin-bottom: 24px;
            box-shadow: 
                0 8px 32px rgba(249, 115, 22, 0.25),
                0 2px 8px rgba(0, 0, 0, 0.06),
                inset 0 1px 0 rgba(255, 255, 255, 0.2);
            animation: logoFloat 3s ease-in-out infinite;
            position: relative;
        }

        .logo-wrapper::after {
            content: '';
            position: absolute;
            inset: -4px;
            border-radius: 26px;
            background: linear-gradient(145deg, rgba(249, 115, 22, 0.2), transparent);
            z-index: -1;
            filter: blur(12px);
        }

        @keyframes logoFloat {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-4px); }
        }

        .logo-wrapper i {
            font-size: 36px;
            color: var(--white);
            filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1));
        }

        .login-title {
            font-size: 26px;
            font-weight: 800;
            color: var(--text-dark);
            margin-bottom: 6px;
            letter-spacing: -0.3px;
        }

        .login-subtitle {
            font-size: 14px;
            color: var(--text-muted);
            font-weight: 500;
        }

        /* Form section */
        .login-body {
            padding: 8px 36px 36px;
        }

        /* Alert */
        .alert {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            padding: 14px 16px;
            background: var(--danger-bg);
            border: 1px solid var(--danger-border);
            border-radius: 12px;
            margin-bottom: 24px;
            animation: shake 0.5s ease-in-out;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            10%, 30%, 50%, 70%, 90% { transform: translateX(-4px); }
            20%, 40%, 60%, 80% { transform: translateX(4px); }
        }

        .alert-icon {
            width: 32px;
            height: 32px;
            background: var(--danger);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .alert-icon i {
            color: var(--white);
            font-size: 14px;
        }

        .alert-content {
            flex: 1;
        }

        .alert-title {
            font-size: 14px;
            font-weight: 600;
            color: var(--danger);
            margin-bottom: 2px;
        }

        .alert-message {
            font-size: 13px;
            color: #b91c1c;
            line-height: 1.4;
        }

        /* Form fields */
        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 8px;
            letter-spacing: 0.2px;
        }

        .form-label i {
            color: var(--primary-mid);
            margin-right: 6px;
            width: 16px;
            text-align: center;
        }

        .input-wrapper {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-light);
            font-size: 15px;
            transition: color 0.2s;
            pointer-events: none;
            z-index: 1;
        }

        .form-input {
            width: 100%;
            padding: 14px 16px 14px 46px;
            border: 2px solid var(--border);
            border-radius: 12px;
            font-size: 15px;
            font-family: inherit;
            color: var(--text-dark);
            background: var(--white);
            transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
            outline: none;
        }

        .form-input::placeholder {
            color: var(--text-light);
        }

        .form-input:focus {
            border-color: var(--primary-mid);
            box-shadow: 0 0 0 4px rgba(249, 115, 22, 0.1);
        }

        .input-wrapper:focus-within .input-icon {
            color: var(--primary-mid);
        }

        /* Remember & Forgot row */
        .form-options {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 28px;
            padding: 0 2px;
        }

        .remember-me {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
            user-select: none;
        }

        .remember-me input[type="checkbox"] {
            display: none;
        }

        .checkbox-custom {
            width: 20px;
            height: 20px;
            border: 2px solid var(--border);
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
            background: var(--white);
        }

        .checkbox-custom i {
            font-size: 12px;
            color: var(--white);
            opacity: 0;
            transform: scale(0.5);
            transition: all 0.2s;
        }

        .remember-me input:checked + .checkbox-custom {
            background: linear-gradient(145deg, var(--primary-mid), var(--primary-end));
            border-color: var(--primary-mid);
        }

        .remember-me input:checked + .checkbox-custom i {
            opacity: 1;
            transform: scale(1);
        }

        .remember-text {
            font-size: 14px;
            color: var(--text-muted);
            font-weight: 500;
        }

        .forgot-link {
            font-size: 14px;
            color: var(--primary-mid);
            font-weight: 600;
            text-decoration: none;
            transition: color 0.2s;
        }

        .forgot-link:hover {
            color: var(--primary-start);
        }

        /* Submit button */
        .btn-submit {
            width: 100%;
            padding: 15px 24px;
            background: linear-gradient(145deg, var(--primary-mid), var(--primary-end));
            color: var(--white);
            border: none;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 700;
            font-family: inherit;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            box-shadow: 
                0 4px 14px rgba(249, 115, 22, 0.35),
                0 1px 2px rgba(0, 0, 0, 0.05);
            transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }

        .btn-submit::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 
                0 8px 24px rgba(249, 115, 22, 0.4),
                0 2px 4px rgba(0, 0, 0, 0.08);
        }

        .btn-submit:hover::before {
            left: 100%;
        }

        .btn-submit:active {
            transform: translateY(0);
        }

        .btn-submit i {
            font-size: 16px;
        }

        /* Footer link */
        .back-link {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-top: 28px;
            padding-top: 24px;
            border-top: 1px solid var(--border);
            text-decoration: none;
            transition: all 0.2s;
        }

        .back-link i {
            font-size: 13px;
            color: var(--text-light);
            transition: all 0.2s;
        }

        .back-link span {
            font-size: 14px;
            color: var(--text-muted);
            font-weight: 500;
            transition: color 0.2s;
        }

        .back-link:hover i,
        .back-link:hover span {
            color: var(--primary-mid);
        }

        /* Responsive */
        @media (max-width: 480px) {
            body {
                padding: 16px 12px;
            }

            .login-header {
                padding: 40px 24px 24px;
            }

            .logo-wrapper {
                width: 72px;
                height: 72px;
                border-radius: 20px;
            }

            .logo-wrapper i {
                font-size: 32px;
            }

            .login-title {
                font-size: 22px;
            }

            .login-body {
                padding: 8px 24px 28px;
            }

            .form-options {
                flex-direction: column;
                align-items: flex-start;
                gap: 12px;
            }

            .btn-submit {
                padding: 14px 20px;
            }
        }
    </style>
</head>
<body>
    <div class="bg-decoration">
        <div class="bg-circle bg-circle-1"></div>
        <div class="bg-circle bg-circle-2"></div>
        <div class="bg-circle bg-circle-3"></div>
    </div>

    <div class="login-container">
        <div class="login-card">
            <div class="login-header">
                <div class="logo-wrapper">
                    <i class="fas fa-utensils"></i>
                </div>
                <h1 class="login-title">KindergartenKitchen</h1>
                <p class="login-subtitle">Hệ thống quản lý bếp ăn mầm non</p>
            </div>

            <div class="login-body">
                <c:if test="${not empty error}">
                    <div class="alert">
                        <div class="alert-icon">
                            <i class="fas fa-exclamation-triangle"></i>
                        </div>
                        <div class="alert-content">
                            <div class="alert-title">Đăng nhập thất bại</div>
                            <div class="alert-message">${error}</div>
                        </div>
                    </div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/login">
                    <div class="form-group">
                        <label class="form-label" for="username">
                            <i class="fas fa-user"></i>Tên đăng nhập
                        </label>
                        <div class="input-wrapper">
                            <input 
                                type="text" 
                                id="username"
                                name="username" 
                                value="${param.username}" 
                                class="form-input" 
                                required 
                                autofocus 
                                placeholder="Nhập tên đăng nhập"
                            >
                            <span class="input-icon"><i class="fas fa-user"></i></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="password">
                            <i class="fas fa-lock"></i>Mật khẩu
                        </label>
                        <div class="input-wrapper">
                            <input 
                                type="password" 
                                id="password"
                                name="password" 
                                class="form-input" 
                                required 
                                placeholder="Nhập mật khẩu"
                            >
                            <span class="input-icon"><i class="fas fa-lock"></i></span>
                        </div>
                    </div>

                    <div class="form-options">
                        <label class="remember-me">
                            <input type="checkbox" name="remember" value="true">
                            <span class="checkbox-custom">
                                <i class="fas fa-check"></i>
                            </span>
                            <span class="remember-text">Ghi nhớ đăng nhập</span>
                        </label>
                        <a href="${pageContext.request.contextPath}/forgot-password" class="forgot-link">
                            Quên mật khẩu?
                        </a>
                    </div>

                    <button type="submit" class="btn-submit">
                        <i class="fas fa-arrow-right-to-bracket"></i>
                        Đăng nhập
                    </button>
                </form>

                <a href="${pageContext.request.contextPath}/" class="back-link">
                    <i class="fas fa-arrow-left"></i>
                    <span>Quay lại trang chủ</span>
                </a>
            </div>
        </div>
    </div>
</body>
</html>
