<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("authUser") != null) {
        com.mycompany.kindergartenkitchen.entity.User user = (com.mycompany.kindergartenkitchen.entity.User) session.getAttribute("authUser");
        String role = user.getRoleName();
        if ("Admin".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else if ("Manager".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/manager/dashboard");
        } else if ("KitchenStaff".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/kitchen/dashboard");
        } else if ("Teacher".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/teacher/dashboard");
        } else if ("Parent".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/parent/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KindergartenKitchen - Hệ thống quản lý bếp ăn mầm non</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px;
            margin: 0;
            font-family: 'Segoe UI', Tahoma, sans-serif;
        }
        .hero {
            max-width: 900px;
            text-align: center;
            color: #fff;
        }
        .logo {
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, #f97316, #fb923c);
            border-radius: 28px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 32px;
            font-size: 48px;
            color: #fff;
            box-shadow: 0 16px 48px rgba(249,115,22,0.4);
        }
        h1 {
            font-size: 48px;
            font-weight: 900;
            letter-spacing: -1px;
            margin-bottom: 16px;
            background: linear-gradient(135deg, #fff 0%, #94a3b8 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .subtitle {
            font-size: 18px;
            color: #94a3b8;
            margin-bottom: 40px;
        }
        .features {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 40px;
        }
        .feature {
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 16px;
            padding: 24px;
            transition: all 0.3s;
        }
        .feature:hover {
            transform: translateY(-4px);
            background: rgba(255,255,255,0.08);
        }
        .feature-icon {
            width: 50px;
            height: 50px;
            background: rgba(249,115,22,0.2);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 14px;
            font-size: 22px;
            color: #fb923c;
        }
        .feature h3 {
            font-size: 16px;
            font-weight: 700;
            margin-bottom: 6px;
        }
        .feature p {
            font-size: 13px;
            color: #94a3b8;
        }
        .btn-group {
            display: flex;
            gap: 16px;
            justify-content: center;
        }
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 14px 28px;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.3s;
        }
        .btn-primary {
            background: linear-gradient(135deg, #f97316, #fb923c);
            color: #fff;
            box-shadow: 0 8px 24px rgba(249,115,22,0.3);
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 32px rgba(249,115,22,0.4);
        }
        .btn-outline {
            background: transparent;
            color: #fff;
            border: 2px solid rgba(255,255,255,0.2);
        }
        .btn-outline:hover {
            background: rgba(255,255,255,0.1);
            border-color: rgba(255,255,255,0.4);
        }
        @media (max-width: 768px) {
            .features { grid-template-columns: repeat(2, 1fr); }
            h1 { font-size: 36px; }
        }
    </style>
</head>
<body>
    <div class="hero">
        <div class="logo"><i class="fas fa-utensils"></i></div>
        <h1>KindergartenKitchen</h1>
        <p class="subtitle">Hệ thống quản lý bếp ăn thông minh cho trường mầm non</p>

        <div class="features">
            <div class="feature">
                <div class="feature-icon"><i class="fas fa-utensils"></i></div>
                <h3>Quản lý bếp ăn</h3>
                <p>Theo dõi suất ăn, nguyên liệu</p>
            </div>
            <div class="feature">
                <div class="feature-icon"><i class="fas fa-clipboard-list"></i></div>
                <h3>Quản lý lớp</h3>
                <p>Phân công, theo dõi học sinh</p>
            </div>
            <div class="feature">
                <div class="feature-icon"><i class="fas fa-user-check"></i></div>
                <h3>Điểm danh</h3>
                <p>Cập nhật trạng thái hàng ngày</p>
            </div>
            <div class="feature">
                <div class="feature-icon"><i class="fas fa-bell"></i></div>
                <h3>Thông báo</h3>
                <p>Cập nhật tình trạng ăn uống</p>
            </div>
        </div>

        <div class="btn-group">
            <a href="<%= request.getContextPath() %>/login" class="btn btn-primary">
                <i class="fas fa-sign-in-alt"></i>
                Đăng nhập
            </a>
            <a href="<%= request.getContextPath() %>/forgot-password" class="btn btn-outline">
                <i class="fas fa-key"></i>
                Quên mật khẩu
            </a>
        </div>
    </div>
</body>
</html>
