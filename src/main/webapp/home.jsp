<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KindergartenKitchen - Hệ thống quản lý bếp ăn</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, sans-serif;
            background: #fffbf5;
            color: #7c2d12;
            min-height: 100vh;
            overflow-x: hidden;
        }
        
        /* ===== NAVBAR ===== */
        .navbar {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            height: 72px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 48px;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(249, 115, 22, 0.1);
            z-index: 1000;
            box-shadow: 0 2px 20px rgba(249, 115, 22, 0.05);
        }
        
        .nav-brand {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .nav-logo {
            width: 44px;
            height: 44px;
            background: linear-gradient(135deg, rgba(249, 115, 22, 0.3), rgba(251, 146, 60, 0.2));
            border: 1px solid rgba(249, 115, 22, 0.3);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            color: #ea580c;
            box-shadow: 0 0 20px rgba(249, 115, 22, 0.2);
        }
        
        .nav-title {
            font-size: 18px;
            font-weight: 800;
            color: #9a3412;
            letter-spacing: -0.5px;
        }
        
        .nav-subtitle {
            font-size: 10px;
            color: #c2410c;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .nav-actions {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .btn-nav {
            padding: 10px 20px;
            border-radius: 10px;
            font-weight: 700;
            font-size: 13px;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-nav-outline {
            background: transparent;
            border: 1px solid rgba(249, 115, 22, 0.3);
            color: #ea580c;
        }
        
        .btn-nav-outline:hover {
            background: rgba(249, 115, 22, 0.1);
            color: #c2410c;
            border-color: rgba(249, 115, 22, 0.5);
        }
        
        .btn-nav-primary {
            background: linear-gradient(135deg, #ea580c, #fb923c);
            border: 1px solid rgba(249, 115, 22, 0.3);
            color: white;
            box-shadow: 0 4px 14px rgba(234, 88, 12, 0.3);
        }
        
        .btn-nav-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(234, 88, 12, 0.4);
            filter: brightness(1.05);
        }
        
        /* ===== HERO SECTION ===== */
        .hero {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 120px 48px 80px;
            position: relative;
            overflow: hidden;
        }
        
        .hero-bg {
            position: absolute;
            inset: 0;
            background: 
                linear-gradient(135deg, rgba(255, 251, 245, 0.92) 0%, rgba(255, 251, 245, 0.85) 100%),
                url('https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=1920&q=80') center/cover no-repeat;
            background-blend-mode: normal, overlay;
        }
        
        .hero::after {
            content: '';
            position: absolute;
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, rgba(251, 146, 60, 0.15) 0%, transparent 70%);
            border-radius: 50%;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            animation: pulse 8s ease-in-out infinite;
            pointer-events: none;
            z-index: 1;
        }
        
        @keyframes pulse {
            0%, 100% { transform: translate(-50%, -50%) scale(1); opacity: 1; }
            50% { transform: translate(-50%, -50%) scale(1.2); opacity: 0.6; }
        }
        
        .hero-content {
            max-width: 900px;
            text-align: center;
            position: relative;
            z-index: 2;
            animation: fadeInUp 0.8s ease;
        }
        
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(40px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            background: rgba(249, 115, 22, 0.15);
            border: 1px solid rgba(249, 115, 22, 0.2);
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
            color: #ea580c;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 28px;
            animation: fadeInUp 0.8s 0.1s ease both;
        }
        
        .hero-badge i { font-size: 10px; }
        
        .hero-title {
            font-size: 52px;
            font-weight: 800;
            color: #9a3412;
            line-height: 1.15;
            margin-bottom: 24px;
            letter-spacing: -1.5px;
            animation: fadeInUp 0.8s 0.2s ease both;
            white-space: nowrap;
        }
        
        .hero-title span {
            background: linear-gradient(135deg, #ea580c, #fb923c);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .hero-subtitle {
            font-size: 18px;
            color: #c2410c;
            line-height: 1.7;
            max-width: 600px;
            margin: 0 auto 40px;
            animation: fadeInUp 0.8s 0.3s ease both;
        }
        
        .hero-actions {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 16px;
            animation: fadeInUp 0.8s 0.4s ease both;
        }
        
        .btn-hero {
            padding: 14px 32px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 15px;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }
        
        .btn-hero-primary {
            background: linear-gradient(135deg, #ea580c, #fb923c);
            color: white;
            border: none;
            box-shadow: 0 8px 30px rgba(234, 88, 12, 0.4);
        }
        
        .btn-hero-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 40px rgba(234, 88, 12, 0.5);
            filter: brightness(1.05);
        }
        
        .btn-hero-outline {
            background: rgba(255, 255, 255, 0.8);
            border: 1px solid rgba(249, 115, 22, 0.3);
            color: #ea580c;
        }
        
        .btn-hero-outline:hover {
            background: rgba(255, 255, 255, 0.95);
            color: #c2410c;
            transform: translateY(-2px);
        }
        
        /* ===== FEATURES SECTION ===== */
        .features {
            padding: 100px 48px;
            position: relative;
            background: linear-gradient(180deg, #fff7ed 0%, #fffbf5 100%);
        }
        
        .features-bg {
            position: absolute;
            inset: 0;
            background: 
                linear-gradient(180deg, rgba(255, 247, 237, 0.95) 0%, rgba(255, 251, 245, 0.9) 100%),
                url('https://images.unsplash.com/photo-1507048331197-7d4ac70811cf?w=1920&q=80') center/cover no-repeat;
            background-blend-mode: normal, overlay;
        }
        
        .features {
            position: relative;
            overflow: hidden;
        }
        
        .features::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(249, 115, 22, 0.2), transparent);
        }
        
        .features > * {
            position: relative;
            z-index: 1;
        }
        
        .section-header {
            text-align: center;
            margin-bottom: 64px;
        }
        
        .section-label {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 14px;
            background: rgba(249, 115, 22, 0.1);
            border: 1px solid rgba(249, 115, 22, 0.15);
            border-radius: 999px;
            font-size: 11px;
            font-weight: 700;
            color: #ea580c;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 16px;
        }
        
        .section-title {
            font-size: 40px;
            font-weight: 800;
            color: #9a3412;
            margin-bottom: 16px;
            letter-spacing: -1px;
        }
        
        .section-desc {
            font-size: 16px;
            color: #c2410c;
            max-width: 500px;
            margin: 0 auto;
        }
        
        .features-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .feature-card {
            background: #ffffff;
            border: 1px solid rgba(249, 115, 22, 0.1);
            border-radius: 20px;
            padding: 32px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            cursor: pointer;
            text-decoration: none;
            display: block;
            color: inherit;
            box-shadow: 0 4px 20px rgba(249, 115, 22, 0.05);
        }

        .feature-card:hover {
            transform: translateY(-8px);
            border-color: rgba(249, 115, 22, 0.3);
            box-shadow: 0 20px 50px rgba(249, 115, 22, 0.15);
        }
        
        .feature-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, #ea580c, #fb923c);
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .feature-card:hover::before {
            opacity: 1;
        }
        
        .feature-icon {
            width: 56px;
            height: 56px;
            background: linear-gradient(135deg, rgba(249, 115, 22, 0.2), rgba(251, 146, 60, 0.1));
            border: 1px solid rgba(249, 115, 22, 0.2);
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: #ea580c;
            margin-bottom: 20px;
            box-shadow: 0 0 30px rgba(249, 115, 22, 0.15);
        }
        
        .feature-card.green .feature-icon { background: linear-gradient(135deg, rgba(34, 197, 94, 0.2), rgba(34, 197, 94, 0.1)); border-color: rgba(34, 197, 94, 0.2); color: #16a34a; box-shadow: 0 0 30px rgba(34, 197, 94, 0.15); }
        .feature-card.green::before { background: linear-gradient(90deg, #16a34a, #22c55e); }
        
        .feature-card.blue .feature-icon { background: linear-gradient(135deg, rgba(59, 130, 246, 0.2), rgba(59, 130, 246, 0.1)); border-color: rgba(59, 130, 246, 0.2); color: #2563eb; box-shadow: 0 0 30px rgba(59, 130, 246, 0.15); }
        .feature-card.blue::before { background: linear-gradient(90deg, #2563eb, #3b82f6); }
        
        .feature-card.cyan .feature-icon { background: linear-gradient(135deg, rgba(6, 182, 212, 0.2), rgba(6, 182, 212, 0.1)); border-color: rgba(6, 182, 212, 0.2); color: #0891b2; box-shadow: 0 0 30px rgba(6, 182, 212, 0.15); }
        .feature-card.cyan::before { background: linear-gradient(90deg, #0891b2, #06b6d4); }
        
        .feature-title {
            font-size: 18px;
            font-weight: 700;
            color: #9a3412;
            margin-bottom: 10px;
        }
        
        .feature-desc {
            font-size: 14px;
            color: #c2410c;
            line-height: 1.6;
        }
        
        /* ===== CTA SECTION ===== */
        .cta {
            padding: 120px 48px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .cta-bg {
            position: absolute;
            inset: 0;
            background: 
                linear-gradient(180deg, rgba(255, 251, 245, 0.9) 0%, rgba(255, 247, 237, 0.85) 100%),
                url('https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=1920&q=80') center/cover no-repeat;
            background-blend-mode: normal, overlay;
        }
        
        .cta {
            position: relative;
        }
        
        .cta > * {
            position: relative;
            z-index: 1;
        }
        
        .cta::before {
            content: '';
            position: absolute;
            inset: 0;
            background: radial-gradient(ellipse 60% 50% at 50% 50%, rgba(251, 146, 60, 0.15), transparent);
            pointer-events: none;
            z-index: 0;
        }
        
        .cta-content {
            max-width: 720px;
            margin: 0 auto;
            position: relative;
            z-index: 2;
        }
        
        .cta-title {
            font-size: 32px;
            font-weight: 800;
            color: #9a3412;
            margin-bottom: 16px;
            letter-spacing: -0.5px;
            text-align: center;
            display: block;
            white-space: nowrap;
            line-height: 1.2;
        }
        
        .cta-title .dash {
            display: inline-block;
            margin: 0 14px;
            color: #ea580c;
            opacity: 0.6;
        }
        
        .cta-title .accent {
            background: linear-gradient(135deg, #ea580c, #fb923c);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .cta-desc {
            font-size: 16px;
            color: #c2410c;
            margin-bottom: 32px;
        }
        
        /* ===== FOOTER ===== */
        .footer {
            padding: 32px 48px;
            border-top: 1px solid rgba(249, 115, 22, 0.1);
            text-align: center;
            background: rgba(255, 255, 255, 0.8);
        }
        
        .footer-content {
            display: flex;
            align-items: center;
            justify-content: space-between;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .footer-brand {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #c2410c;
            font-size: 13px;
        }
        
        .footer-brand i {
            color: #ea580c;
        }
        
        .footer-links {
            display: flex;
            align-items: center;
            gap: 24px;
        }
        
        .footer-links a {
            color: #c2410c;
            font-size: 13px;
            text-decoration: none;
            transition: color 0.2s;
        }
        
        .footer-links a:hover {
            color: #ea580c;
        }
        
        /* ===== RESPONSIVE ===== */
        @media (max-width: 1024px) {
            .features-grid { grid-template-columns: repeat(2, 1fr); }
            .hero-title { font-size: 42px; }
        }
        
        @media (max-width: 768px) {
            .navbar { padding: 0 24px; }
            .nav-subtitle { display: none; }
            .hero { padding: 100px 24px 60px; }
            .hero-title { font-size: 28px; white-space: normal; }
            .hero-subtitle { font-size: 15px; }
            .hero-actions { flex-direction: column; }
            .features { padding: 60px 24px; }
            .features-grid { grid-template-columns: 1fr; }
            .section-title { font-size: 28px; }
            .cta { padding: 80px 24px; }
            .cta-title { font-size: 22px; white-space: normal; }
            .footer { padding: 24px; }
            .footer-content { flex-direction: column; gap: 16px; }
        }
    </style>
</head>
<body>
    <!-- NAVBAR -->
    <nav class="navbar">
        <div class="nav-brand">
            <div class="nav-logo">
                <i class="fas fa-utensils"></i>
            </div>
            <div>
                <div class="nav-title">KindergartenKitchen</div>
                <div class="nav-subtitle">Hệ thống quản lý bếp ăn</div>
            </div>
        </div>
        <div class="nav-actions">
            <a href="${pageContext.request.contextPath}/login" class="btn-nav btn-nav-outline">
                <i class="fas fa-arrow-right-to-bracket"></i>
                Đăng nhập
            </a>
        </div>
    </nav>

    <!-- HERO SECTION -->
    <section class="hero">
        <div class="hero-bg"></div>
        <div class="hero-content">
            <div class="hero-badge">
                <i class="fas fa-utensils"></i>
                Hệ thống quản lý thông minh
            </div>
            <h1 class="hero-title">
                Quản lý bếp ăn chuyên nghiệp
            </h1>
            <p class="hero-subtitle">
                Giải pháp toàn diện giúp nhà trường quản lý thực đơn, dinh dưỡng và theo dõi chất lượng bếp ăn một cách hiệu quả và minh bạch.
            </p>
            <div class="hero-actions">
                <a href="${pageContext.request.contextPath}/login" class="btn-hero btn-hero-primary">
                    <i class="fas fa-arrow-right"></i>
                    Bắt đầu ngay
                </a>
                <a href="#features" class="btn-hero btn-hero-outline">
                    <i class="fas fa-play-circle"></i>
                    Khám phá tính năng
                </a>
            </div>
        </div>
    </section>

    <!-- FEATURES SECTION -->
    <section class="features" id="features">
        <div class="features-bg"></div>
        <div class="section-header">
            <div class="section-label">
                <i class="fas fa-star"></i>
                Tính năng nổi bật
            </div>
            <h2 class="section-title">Giải pháp toàn diện</h2>
            <p class="section-desc">
                Hệ thống được thiết kế để đáp ứng mọi nhu cầu quản lý bếp ăn của nhà trường
            </p>
        </div>

        <div class="features-grid">
            <!-- Feature 1 -->
            <a href="${pageContext.request.contextPath}/login" class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-calendar-check"></i>
                </div>
                <h3 class="feature-title">Lập kế hoạch thực đơn</h3>
                <p class="feature-desc">
                    Dễ dàng lên kế hoạch thực đơn hàng tuần, hàng tháng với đầy đủ thông tin dinh dưỡng và nguyên liệu cần thiết.
                </p>
            </a>

            <!-- Feature 2 -->
            <a href="${pageContext.request.contextPath}/login" class="feature-card green">
                <div class="feature-icon">
                    <i class="fas fa-leaf"></i>
                </div>
                <h3 class="feature-title">Dinh dưỡng cân đối</h3>
                <p class="feature-desc">
                    Theo dõi và đảm bảo chế độ dinh dưỡng hợp lý cho trẻ em với các công thức nấu ăn đã được nghiên cứu kỹ lưỡng.
                </p>
            </a>

            <!-- Feature 3 -->
            <a href="${pageContext.request.contextPath}/login" class="feature-card blue">
                <div class="feature-icon">
                    <i class="fas fa-clipboard-list"></i>
                </div>
                <h3 class="feature-title">Quản lý nguyên liệu</h3>
                <p class="feature-desc">
                    Kiểm soát tồn kho nguyên liệu, nhập hàng và xuất kho một cách chính xác, tránh thất thoát.
                </p>
            </a>

            <!-- Feature 4 -->
            <a href="${pageContext.request.contextPath}/login" class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-chart-line"></i>
                </div>
                <h3 class="feature-title">Báo cáo chi tiết</h3>
                <p class="feature-desc">
                    Thống kê chi phí, lượng tiêu thụ và dinh dưỡng qua các báo cáo trực quan, dễ hiểu.
                </p>
            </a>

            <!-- Feature 5 -->
            <a href="${pageContext.request.contextPath}/login" class="feature-card green">
                <div class="feature-icon">
                    <i class="fas fa-shield-halved"></i>
                </div>
                <h3 class="feature-title">An toàn thực phẩm</h3>
                <p class="feature-desc">
                    Đảm bảo an toàn vệ sinh thực phẩm với quy trình kiểm soát nghiêm ngặt từ nguyên liệu đến bàn ăn.
                </p>
            </a>

            <!-- Feature 6 -->
            <a href="${pageContext.request.contextPath}/login" class="feature-card cyan">
                <div class="feature-icon">
                    <i class="fas fa-users-gear"></i>
                </div>
                <h3 class="feature-title">Phân quyền nhân viên</h3>
                <p class="feature-desc">
                    Hệ thống phân quyền rõ ràng cho từng vị trí: quản lý, đầu bếp, nhân viên với quyền hạn cụ thể.
                </p>
            </a>
        </div>
    </section>

    <!-- CTA SECTION -->
    <section class="cta" id="cta">
        <div class="cta-bg"></div>
        <div class="cta-content">
            <p class="cta-title"><span class="accent">Chăm sóc bữa ăn</span><span class="dash">—</span><span class="accent">Nâng niu tương lai</span></p>
            <p class="cta-desc">
                Đăng nhập ngay để trải nghiệm hệ thống quản lý bếp ăn hiện đại và chuyên nghiệp.
            </p>
            <a href="${pageContext.request.contextPath}/login" class="btn-hero btn-hero-primary">
                <i class="fas fa-arrow-right-to-bracket"></i>
                Đăng nhập ngay
            </a>
        </div>
    </section>

    <!-- FOOTER -->
    <footer class="footer">
        <div class="footer-content">
            <div class="footer-brand">
                <i class="fas fa-utensils"></i>
                <span>KindergartenKitchen - Hệ thống quản lý bếp ăn mầm non</span>
            </div>
            <div class="footer-links">
                <a href="#features">Tính năng</a>
                <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
            </div>
        </div>
    </footer>

    <script>
        // Click vào feature card → scroll lên hero + hiệu ứng nhảy
        document.querySelectorAll('.feature-card').forEach(card => {
            card.addEventListener('click', function(e) {
                e.preventDefault();
                
                // Scroll lên hero section
                const hero = document.querySelector('.hero');
                if (hero) {
                    hero.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
                
                // Hiệu ứng nhảy cho card
                this.style.transform = 'translateY(-15px) scale(0.98)';
                this.style.boxShadow = '0 30px 60px rgba(249, 115, 22, 0.25)';
                this.style.transition = 'all 0.2s ease';
                
                // Lấy nút "Bắt đầu ngay"
                const startBtn = document.querySelector('.btn-hero-primary');
                if (!startBtn) return;
                
                // Nút nhảy lên sau khi scroll
                setTimeout(() => {
                    startBtn.style.transform = 'scale(1.15)';
                    startBtn.style.boxShadow = '0 15px 50px rgba(234, 88, 12, 0.5)';
                    startBtn.style.transition = 'all 0.2s ease';
                }, 500);
                
                // Reset
                setTimeout(() => {
                    this.style.transform = '';
                    this.style.boxShadow = '';
                    startBtn.style.transform = '';
                    startBtn.style.boxShadow = '';
                }, 1500);
            });
        });
    </script>
</body>
</html>
