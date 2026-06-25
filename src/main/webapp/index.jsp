<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("authUser") != null) {
        com.mycompany.kindergartenkitchen.entity.User user =
            (com.mycompany.kindergartenkitchen.entity.User) session.getAttribute("authUser");
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
        :root {
            --primary-start: #ea580c;
            --primary-mid: #f97316;
            --primary-end: #fb923c;
            --sidebar-dark: #1e293b;
            --sidebar-darker: #0f172a;
            --bg-light: #f5f7fa;
            --bg-mid: #e2e8f0;
            --text-dark: #0f172a;
            --text-muted: #64748b;
            --text-light: #94a3b8;
            --border: #e2e8f0;
            --white: #ffffff;
            --card-bg: #ffffff;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            background: var(--bg-light);
            color: var(--text-dark);
            overflow-x: hidden;
        }

        /* Navigation */
        .navbar {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 100;
            padding: 0 40px;
            height: 72px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: rgba(30, 41, 59, 0.85);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.06);
            animation: navFadeIn 0.8s ease-out;
        }

        @keyframes navFadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .nav-brand {
            display: flex;
            align-items: center;
            gap: 14px;
            text-decoration: none;
        }

        .nav-logo {
            width: 44px;
            height: 44px;
            background: linear-gradient(145deg, var(--primary-start), var(--primary-mid), var(--primary-end));
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 14px rgba(249, 115, 22, 0.3);
        }

        .nav-logo i {
            font-size: 20px;
            color: var(--white);
        }

        .nav-brand-name {
            font-size: 18px;
            font-weight: 800;
            color: var(--white);
            letter-spacing: -0.3px;
        }

        .nav-actions {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .nav-btn-ghost {
            padding: 10px 22px;
            background: transparent;
            border: 1.5px solid rgba(255, 255, 255, 0.2);
            border-radius: 10px;
            color: rgba(255, 255, 255, 0.7);
            font-size: 14px;
            font-weight: 600;
            font-family: inherit;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .nav-btn-ghost:hover {
            background: rgba(255, 255, 255, 0.08);
            border-color: rgba(255, 255, 255, 0.35);
            color: var(--white);
        }

        .nav-btn-primary {
            padding: 10px 22px;
            background: linear-gradient(145deg, var(--primary-mid), var(--primary-end));
            border: none;
            border-radius: 10px;
            color: var(--white);
            font-size: 14px;
            font-weight: 700;
            font-family: inherit;
            cursor: pointer;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 14px rgba(249, 115, 22, 0.3);
            transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .nav-btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(249, 115, 22, 0.4);
        }

        /* Hero Section */
        .hero {
            min-height: 100vh;
            background: linear-gradient(165deg, var(--sidebar-dark) 0%, var(--sidebar-darker) 60%, #020617 100%);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 120px 40px 80px;
            position: relative;
            overflow: hidden;
        }

        .hero::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -20%;
            width: 80%;
            height: 150%;
            background: radial-gradient(ellipse, rgba(249, 115, 22, 0.06) 0%, transparent 70%);
            pointer-events: none;
        }

        .hero::after {
            content: '';
            position: absolute;
            bottom: -30%;
            right: -10%;
            width: 60%;
            height: 100%;
            background: radial-gradient(ellipse, rgba(251, 146, 60, 0.05) 0%, transparent 70%);
            pointer-events: none;
        }

        .hero-content {
            max-width: 960px;
            width: 100%;
            text-align: center;
            position: relative;
            z-index: 1;
            animation: heroFadeUp 1s cubic-bezier(0.16, 1, 0.3, 1) 0.2s both;
        }

        @keyframes heroFadeUp {
            from { opacity: 0; transform: translateY(40px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .hero-logo {
            width: 100px;
            height: 100px;
            background: linear-gradient(145deg, var(--primary-start), var(--primary-mid), var(--primary-end));
            border-radius: 28px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 32px;
            box-shadow: 
                0 16px 48px rgba(249, 115, 22, 0.3),
                0 4px 12px rgba(0, 0, 0, 0.2),
                inset 0 1px 0 rgba(255, 255, 255, 0.25);
            animation: logoFloat 4s ease-in-out infinite;
            position: relative;
        }

        .hero-logo::after {
            content: '';
            position: absolute;
            inset: -8px;
            border-radius: 36px;
            background: radial-gradient(ellipse, rgba(249, 115, 22, 0.15), transparent);
            filter: blur(16px);
            z-index: -1;
        }

        @keyframes logoFloat {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-6px); }
        }

        .hero-logo i {
            font-size: 44px;
            color: var(--white);
            filter: drop-shadow(0 2px 8px rgba(0, 0, 0, 0.15));
        }

        .hero-title {
            font-size: 52px;
            font-weight: 900;
            letter-spacing: -1px;
            line-height: 1.1;
            margin-bottom: 16px;
            background: linear-gradient(135deg, #ffffff 0%, #e2e8f0 50%, #cbd5e1 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .hero-title span {
            background: linear-gradient(135deg, var(--primary-mid), var(--primary-end), #fcd34d);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .hero-subtitle {
            font-size: 18px;
            color: rgba(255, 255, 255, 0.5);
            margin-bottom: 48px;
            font-weight: 400;
            line-height: 1.6;
        }

        /* Feature cards in hero */
        .hero-features {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 52px;
        }

        .hero-feature {
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 18px;
            padding: 28px 20px 24px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            animation: cardStagger 0.8s cubic-bezier(0.16, 1, 0.3, 1) both;
            position: relative;
            overflow: hidden;
        }

        .hero-feature::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 2px;
            background: linear-gradient(90deg, transparent, var(--primary-mid), transparent);
            opacity: 0;
            transition: opacity 0.3s;
        }

        .hero-feature:nth-child(1) { animation-delay: 0.3s; }
        .hero-feature:nth-child(2) { animation-delay: 0.4s; }
        .hero-feature:nth-child(3) { animation-delay: 0.5s; }
        .hero-feature:nth-child(4) { animation-delay: 0.6s; }

        @keyframes cardStagger {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .hero-feature:hover {
            background: rgba(255, 255, 255, 0.07);
            border-color: rgba(249, 115, 22, 0.25);
            transform: translateY(-4px);
        }

        .hero-feature:hover::before {
            opacity: 1;
        }

        .hero-feature-icon {
            width: 52px;
            height: 52px;
            background: rgba(249, 115, 22, 0.12);
            border: 1px solid rgba(249, 115, 22, 0.2);
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 16px;
            font-size: 22px;
            color: var(--primary-end);
            transition: all 0.3s;
        }

        .hero-feature:hover .hero-feature-icon {
            background: rgba(249, 115, 22, 0.18);
            border-color: rgba(249, 115, 22, 0.35);
            transform: scale(1.05);
        }

        .hero-feature h3 {
            font-size: 15px;
            font-weight: 700;
            color: rgba(255, 255, 255, 0.9);
            margin-bottom: 6px;
        }

        .hero-feature p {
            font-size: 13px;
            color: rgba(255, 255, 255, 0.4);
            line-height: 1.5;
        }

        /* CTA buttons */
        .hero-actions {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 14px;
            animation: heroFadeUp 1s cubic-bezier(0.16, 1, 0.3, 1) 0.7s both;
        }

        .btn-primary-lg {
            padding: 16px 36px;
            background: linear-gradient(145deg, var(--primary-mid), var(--primary-end));
            color: var(--white);
            border: none;
            border-radius: 14px;
            font-size: 16px;
            font-weight: 700;
            font-family: inherit;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            box-shadow: 
                0 8px 28px rgba(249, 115, 22, 0.35),
                0 2px 4px rgba(0, 0, 0, 0.08);
            transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }

        .btn-primary-lg::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.15), transparent);
            transition: left 0.6s;
        }

        .btn-primary-lg:hover {
            transform: translateY(-2px);
            box-shadow: 
                0 12px 36px rgba(249, 115, 22, 0.45),
                0 4px 8px rgba(0, 0, 0, 0.12);
        }

        .btn-primary-lg:hover::before {
            left: 100%;
        }

        .btn-ghost-lg {
            padding: 16px 36px;
            background: rgba(255, 255, 255, 0.05);
            color: rgba(255, 255, 255, 0.7);
            border: 1.5px solid rgba(255, 255, 255, 0.15);
            border-radius: 14px;
            font-size: 16px;
            font-weight: 600;
            font-family: inherit;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .btn-ghost-lg:hover {
            background: rgba(255, 255, 255, 0.09);
            border-color: rgba(255, 255, 255, 0.28);
            color: var(--white);
            transform: translateY(-2px);
        }

        /* Info Section */
        .info-section {
            background: var(--white);
            padding: 80px 40px;
        }

        .info-section-inner {
            max-width: 960px;
            margin: 0 auto;
        }

        .section-header {
            text-align: center;
            margin-bottom: 48px;
        }

        .section-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            background: rgba(249, 115, 22, 0.08);
            border: 1px solid rgba(249, 115, 22, 0.15);
            border-radius: 100px;
            font-size: 13px;
            font-weight: 600;
            color: var(--primary-mid);
            margin-bottom: 16px;
        }

        .section-badge i {
            font-size: 12px;
        }

        .section-title {
            font-size: 32px;
            font-weight: 800;
            color: var(--text-dark);
            margin-bottom: 10px;
            letter-spacing: -0.5px;
        }

        .section-subtitle {
            font-size: 16px;
            color: var(--text-muted);
            max-width: 520px;
            margin: 0 auto;
            line-height: 1.6;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
        }

        .info-card {
            background: var(--bg-light);
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: 32px 28px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }

        .info-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, var(--primary-start), var(--primary-mid), var(--primary-end));
            opacity: 0;
            transition: opacity 0.3s;
        }

        .info-card:hover {
            border-color: rgba(249, 115, 22, 0.2);
            box-shadow: 
                0 8px 30px rgba(249, 115, 22, 0.08),
                0 2px 8px rgba(0, 0, 0, 0.04);
            transform: translateY(-4px);
        }

        .info-card:hover::before {
            opacity: 1;
        }

        .info-card-icon {
            width: 56px;
            height: 56px;
            background: rgba(249, 115, 22, 0.1);
            border: 1px solid rgba(249, 115, 22, 0.15);
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            font-size: 24px;
            color: var(--primary-mid);
            transition: all 0.3s;
        }

        .info-card:hover .info-card-icon {
            background: rgba(249, 115, 22, 0.15);
            border-color: rgba(249, 115, 22, 0.25);
            transform: scale(1.05);
        }

        .info-card-number {
            position: absolute;
            top: 24px;
            right: 24px;
            font-size: 48px;
            font-weight: 900;
            color: rgba(226, 232, 240, 0.6);
            line-height: 1;
            user-select: none;
        }

        .info-card h3 {
            font-size: 18px;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 10px;
        }

        .info-card p {
            font-size: 14px;
            color: var(--text-muted);
            line-height: 1.7;
        }

        /* Footer */
        .footer {
            background: var(--bg-light);
            border-top: 1px solid var(--border);
            padding: 28px 40px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .footer-left {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .footer-logo {
            width: 32px;
            height: 32px;
            background: linear-gradient(145deg, var(--primary-mid), var(--primary-end));
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .footer-logo i {
            font-size: 14px;
            color: var(--white);
        }

        .footer-brand {
            font-size: 14px;
            font-weight: 700;
            color: var(--text-dark);
        }

        .footer-copy {
            font-size: 13px;
            color: var(--text-light);
        }

        .footer-right {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            color: var(--text-light);
        }

        .footer-right i {
            color: var(--danger);
            font-size: 12px;
        }

        /* Responsive */
        @media (max-width: 900px) {
            .hero-features {
                grid-template-columns: repeat(2, 1fr);
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .hero-title {
                font-size: 40px;
            }

            .hero {
                padding: 100px 24px 60px;
            }

            .section-title {
                font-size: 26px;
            }
        }

        @media (max-width: 600px) {
            .navbar {
                padding: 0 20px;
            }

            .nav-brand-name {
                display: none;
            }

            .hero-features {
                grid-template-columns: 1fr;
                gap: 12px;
            }

            .hero-actions {
                flex-direction: column;
                width: 100%;
            }

            .btn-primary-lg,
            .btn-ghost-lg {
                width: 100%;
                justify-content: center;
            }

            .hero-title {
                font-size: 32px;
            }

            .hero-subtitle {
                font-size: 15px;
            }

            .hero {
                padding: 90px 20px 48px;
            }

            .info-section {
                padding: 48px 20px;
            }

            .footer {
                flex-direction: column;
                gap: 12px;
                text-align: center;
                padding: 24px 20px;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar">
        <a href="<%= request.getContextPath() %>/" class="nav-brand">
            <div class="nav-logo">
                <i class="fas fa-utensils"></i>
            </div>
            <span class="nav-brand-name">KindergartenKitchen</span>
        </a>
        <div class="nav-actions">
            <a href="<%= request.getContextPath() %>/forgot-password" class="nav-btn-ghost">
                <i class="fas fa-key"></i>
                Quên mật khẩu
            </a>
            <a href="<%= request.getContextPath() %>/login" class="nav-btn-primary">
                <i class="fas fa-sign-in-alt"></i>
                Đăng nhập
            </a>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-content">
            <div class="hero-logo">
                <i class="fas fa-utensils"></i>
            </div>

            <h1 class="hero-title">
                <span>Kindergarten</span>Kitchen
            </h1>
            <p class="hero-subtitle">
                Hệ thống quản lý bếp ăn thông minh — kết nối giáo viên, phụ huynh và nhà bếp<br>
                trong một nền tảng hiện đại, dễ sử dụng.
            </p>

            <div class="hero-features">
                <div class="hero-feature">
                    <div class="hero-feature-icon">
                        <i class="fas fa-utensils"></i>
                    </div>
                    <h3>Quản lý bếp ăn</h3>
                    <p>Theo dõi suất ăn, nguyên liệu và lên thực đơn hàng ngày</p>
                </div>
                <div class="hero-feature">
                    <div class="hero-feature-icon">
                        <i class="fas fa-clipboard-list"></i>
                    </div>
                    <h3>Quản lý lớp</h3>
                    <p>Phân công giáo viên, theo dõi danh sách học sinh theo lớp</p>
                </div>
                <div class="hero-feature">
                    <div class="hero-feature-icon">
                        <i class="fas fa-user-check"></i>
                    </div>
                    <h3>Điểm danh</h3>
                    <p>Cập nhật trạng thái điểm danh của từng bé hàng ngày</p>
                </div>
                <div class="hero-feature">
                    <div class="hero-feature-icon">
                        <i class="fas fa-bell"></i>
                    </div>
                    <h3>Thông báo</h3>
                    <p>Cập nhật tình trạng ăn uống cho phụ huynh theo thời gian thực</p>
                </div>
            </div>

            <div class="hero-actions">
                <a href="<%= request.getContextPath() %>/login" class="btn-primary-lg">
                    <i class="fas fa-sign-in-alt"></i>
                    Đăng nhập
                </a>
                <a href="<%= request.getContextPath() %>/forgot-password" class="btn-ghost-lg">
                    <i class="fas fa-key"></i>
                    Quên mật khẩu?
                </a>
            </div>
        </div>
    </section>

    <!-- Info Section -->
    <section class="info-section">
        <div class="info-section-inner">
            <div class="section-header">
                <div class="section-badge">
                    <i class="fas fa-star"></i>
                    Tính năng nổi bật
                </div>
                <h2 class="section-title">Giới thiệu hệ thống</h2>
                <p class="section-subtitle">
                    Hỗ trợ quản lý toàn diện hoạt động bếp ăn trường mầm non,
                    từ theo dõi học sinh đến quản lý nguyên liệu.
                </p>
            </div>

            <div class="info-grid">
                <div class="info-card">
                    <div class="info-card-number">01</div>
                    <div class="info-card-icon">
                        <i class="fas fa-chart-pie"></i>
                    </div>
                    <h3>Tổng quan trực quan</h3>
                    <p>Theo dõi tình hình hoạt động, số lượng học sinh và suất ăn theo thời gian thực qua các biểu đồ và dashboard chuyên nghiệp.</p>
                </div>
                <div class="info-card">
                    <div class="info-card-number">02</div>
                    <div class="info-card-icon">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <h3>Điểm danh & Ăn uống</h3>
                    <p>Giáo viên cập nhật trạng thái điểm danh, tình trạng ăn uống của từng bé mỗi ngày nhanh chóng và chính xác.</p>
                </div>
                <div class="info-card">
                    <div class="info-card-number">03</div>
                    <div class="info-card-icon">
                        <i class="fas fa-seedling"></i>
                    </div>
                    <h3>Quản lý nguyên liệu</h3>
                    <p>Kiểm soát kho nguyên liệu, lên thực đơn cân bằng dinh dưỡng và theo dõi số lượng suất ăn cần chuẩn bị.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="footer-left">
            <div class="footer-logo">
                <i class="fas fa-utensils"></i>
            </div>
            <span class="footer-brand">KindergartenKitchen</span>
            <span class="footer-copy">&copy; 2026 — Hệ thống quản lý bếp ăn mầm non</span>
        </div>
        <div class="footer-right">
            Made with <i class="fas fa-heart"></i> for kindergarten
        </div>
    </footer>
</body>
</html>
