<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý - KindergartenKitchen</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, sans-serif; font-size: 14px; line-height: 1.6; color: #7c2d12; background: #fffbf5; min-height: 100vh; }
        .app-container { display: flex; min-height: 100vh; }
        
        /* ===== SIDEBAR ===== */
        .sidebar { width: 260px; background: #ffffff; border-right: 1px solid rgba(249, 115, 22, 0.1); color: #7c2d12; position: fixed; height: 100vh; overflow-y: auto; z-index: 100; display: flex; flex-direction: column; box-shadow: 4px 0 20px rgba(249, 115, 22, 0.05); }
        .sidebar::after { content: ''; position: absolute; top: 0; right: 0; width: 1px; height: 100%; background: linear-gradient(180deg, rgba(249, 115, 22, 0.3) 0%, transparent 50%); pointer-events: none; }
        .sidebar-header { padding: 28px 24px; text-align: center; border-bottom: 1px solid rgba(249, 115, 22, 0.1); background: linear-gradient(180deg, rgba(251, 146, 60, 0.08) 0%, transparent 100%); }
        .sidebar-logo { width: 60px; height: 60px; background: linear-gradient(135deg, rgba(249, 115, 22, 0.2), rgba(251, 146, 60, 0.15)); border: 1px solid rgba(249, 115, 22, 0.25); border-radius: 16px; display: flex; align-items: center; justify-content: center; margin: 0 auto 14px; font-size: 26px; color: #ea580c; box-shadow: 0 0 30px rgba(249, 115, 22, 0.2); }
        .sidebar-title { font-size: 15px; font-weight: 700; margin-bottom: 2px; color: #9a3412; }
        .sidebar-subtitle { font-size: 11px; color: #c2410c; }
        .sidebar-nav { padding: 16px 12px; flex: 1; }
        .nav-section-label { font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: 1.2px; color: #a8a29e; padding: 12px 12px 6px; margin-top: 8px; }
        .nav-item { margin-bottom: 4px; }
        .nav-item a { display: flex; align-items: center; gap: 12px; padding: 11px 14px; color: #78716c; text-decoration: none; border-radius: 10px; font-weight: 600; font-size: 14px; transition: all 0.2s; border: 1px solid transparent; }
        .nav-item a:hover, .nav-item a.active { background: rgba(249, 115, 22, 0.1); color: #ea580c; border-color: rgba(249, 115, 22, 0.15); }
        .nav-icon { width: 34px; height: 34px; background: rgba(249, 115, 22, 0.05); border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 14px; }
        .nav-item a.active .nav-icon { background: rgba(249, 115, 22, 0.15); }
        .sidebar-footer { padding: 16px 12px; border-top: 1px solid rgba(249, 115, 22, 0.08); }
        .logout-btn { display: flex; align-items: center; gap: 12px; padding: 11px 14px; color: #78716c; border-radius: 10px; font-weight: 600; font-size: 14px; width: 100%; cursor: pointer; border: none; background: none; font-family: inherit; transition: all 0.2s; }
        .logout-btn:hover { background: rgba(239, 68, 68, 0.1); color: #dc2626; }
        
        /* ===== MAIN ===== */
        .main-content { flex: 1; margin-left: 260px; min-height: 100vh; display: flex; flex-direction: column; }
        .header { background: rgba(255, 255, 255, 0.98); height: 68px; padding: 0 32px; display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid rgba(249, 115, 22, 0.08); position: sticky; top: 0; z-index: 50; box-shadow: 0 2px 10px rgba(249, 115, 22, 0.05); }
        .header-greeting { display: flex; flex-direction: column; }
        .header-greeting h2 { font-size: 17px; font-weight: 700; color: #9a3412; }
        .header-greeting span { font-size: 12px; color: #c2410c; }
        .header-right { display: flex; align-items: center; gap: 14px; }
        .header-date { display: flex; align-items: center; gap: 6px; padding: 6px 12px; background: rgba(249, 115, 22, 0.05); border: 1px solid rgba(249, 115, 22, 0.1); border-radius: 999px; font-size: 12px; font-weight: 600; color: #c2410c; }
        .header-user { display: flex; align-items: center; gap: 10px; padding: 5px 12px 5px 5px; background: rgba(249, 115, 22, 0.05); border: 1px solid rgba(249, 115, 22, 0.1); border-radius: 999px; }
        .user-avatar { width: 34px; height: 34px; background: linear-gradient(135deg, #ea580c, #fb923c); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: 800; font-size: 13px; box-shadow: 0 0 20px rgba(234, 88, 12, 0.25); }
        .user-name { font-weight: 700; font-size: 12px; color: #9a3412; }
        .user-role { font-size: 10px; color: #ea580c; font-weight: 600; }
        
        /* ===== PAGE ===== */
        .page-content { padding: 28px 32px; flex: 1; }
        .page-header-card { background: linear-gradient(135deg, rgba(249, 115, 22, 0.1) 0%, rgba(251, 146, 60, 0.05) 100%); border: 1px solid rgba(249, 115, 22, 0.15); border-radius: 16px; padding: 24px 28px; margin-bottom: 28px; box-shadow: 0 4px 20px rgba(249, 115, 22, 0.08); }
        .page-header-content { display: flex; align-items: center; gap: 18px; }
        .page-header-icon { width: 54px; height: 54px; background: linear-gradient(135deg, rgba(249, 115, 22, 0.2), rgba(251, 146, 60, 0.15)); border: 1px solid rgba(249, 115, 22, 0.25); border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 22px; color: #ea580c; box-shadow: 0 0 30px rgba(249, 115, 22, 0.15); }
        .page-header-content h1 { font-size: 20px; font-weight: 800; color: #9a3412; margin-bottom: 3px; }
        .page-header-content p { color: #c2410c; font-size: 13px; }
        
        /* ===== STATS ===== */
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 20px; margin-bottom: 28px; }
        .stat-card { background: rgba(255, 255, 255, 0.98); border: 1px solid rgba(249, 115, 22, 0.1); border-radius: 14px; padding: 22px 24px; display: flex; align-items: center; gap: 18px; box-shadow: 0 4px 15px rgba(249, 115, 22, 0.05); transition: all 0.3s ease; }
        .stat-card:hover { transform: translateY(-2px); box-shadow: 0 8px 25px rgba(249, 115, 22, 0.1); }
        .stat-icon { width: 52px; height: 52px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 22px; }
        .stat-icon.blue { background: rgba(59, 130, 246, 0.1); color: #3b82f6; }
        .stat-icon.green { background: rgba(34, 197, 94, 0.1); color: #22c55e; }
        .stat-icon.orange { background: rgba(249, 115, 22, 0.1); color: #ea580c; }
        .stat-icon.purple { background: rgba(168, 85, 247, 0.1); color: #a855f7; }
        .stat-info h3 { font-size: 26px; font-weight: 800; color: #9a3412; }
        .stat-info p { font-size: 12px; color: #c2410c; font-weight: 500; }
        
        /* ===== INFO BOX ===== */
        .info-box { background: rgba(255, 255, 255, 0.98); border: 1px solid rgba(249, 115, 22, 0.1); border-radius: 14px; padding: 24px; box-shadow: 0 4px 15px rgba(249, 115, 22, 0.05); }
        .info-box h3 { font-size: 16px; font-weight: 700; color: #9a3412; margin-bottom: 16px; display: flex; align-items: center; gap: 10px; }
        .info-box h3 i { color: #ea580c; }
        .info-list { list-style: none; }
        .info-list li { padding: 12px 0; border-bottom: 1px solid rgba(249, 115, 22, 0.08); display: flex; align-items: center; gap: 12px; }
        .info-list li:last-child { border-bottom: none; }
        .info-list li i { width: 32px; height: 32px; background: rgba(249, 115, 22, 0.1); border-radius: 8px; display: flex; align-items: center; justify-content: center; color: #ea580c; font-size: 14px; }
        .info-list li span { font-size: 13px; color: #7c2d12; }
        
        /* ===== ANIMATION ===== */
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(16px); } to { opacity: 1; transform: translateY(0); } }
        .page-header-card, .stat-card, .info-box { animation: fadeInUp 0.4s ease forwards; }
        
        @media (max-width: 768px) { .sidebar { transform: translateX(-100%); } .main-content { margin-left: 0; } .page-content { padding: 20px 16px; } }
    </style>
</head>
<body>
    <div class="app-container">
        <aside class="sidebar">
            <div class="sidebar-header">
                <div class="sidebar-logo"><i class="fas fa-utensils"></i></div>
                <h3 class="sidebar-title">KindergartenKitchen</h3>
                <span class="sidebar-subtitle">Quản lý bếp ăn</span>
            </div>
            <nav class="sidebar-nav">
                <div class="nav-section-label">Chính</div>
                <div class="nav-item"><a href="${pageContext.request.contextPath}/manager" class="active"><span class="nav-icon"><i class="fas fa-home"></i></span><span>Tổng quan</span></a></div>
                <div class="nav-item"><a href="${pageContext.request.contextPath}/manager/classes"><span class="nav-icon"><i class="fas fa-chalkboard"></i></span><span>Lớp học</span></a></div>
                <div class="nav-item"><a href="${pageContext.request.contextPath}/manager/students"><span class="nav-icon"><i class="fas fa-user-graduate"></i></span><span>Học sinh</span></a></div>
                <div class="nav-item"><a href="${pageContext.request.contextPath}/manager/attendance"><span class="nav-icon"><i class="fas fa-calendar-check"></i></span><span>Điểm danh</span></a></div>
                <div class="nav-item"><a href="${pageContext.request.contextPath}/manager/ingredients"><span class="nav-icon"><i class="fas fa-carrot"></i></span><span>Nguyên liệu</span></a></div>
                <div class="nav-item"><a href="${pageContext.request.contextPath}/manager/meals"><span class="nav-icon"><i class="fas fa-utensils"></i></span><span>Lịch sử bếp</span></a></div>
                <div class="nav-section-label">Tài khoản</div>
                <div class="nav-item"><a href="${pageContext.request.contextPath}/manager/change-password"><span class="nav-icon"><i class="fas fa-key"></i></span><span>Đổi mật khẩu</span></a></div>
            </nav>
            <div class="sidebar-footer">
                <form method="post" action="${pageContext.request.contextPath}/logout" style="margin: 0;">
                    <button type="submit" class="logout-btn"><span class="nav-icon"><i class="fas fa-sign-out-alt"></i></span><span>Đăng xuất</span></button>
                </form>
            </div>
        </aside>

        <div class="main-content">
            <header class="header">
                <div class="header-greeting">
                    <h2>Tổng quan</h2>
                    <span>Xin chào, chào mừng quay trở lại!</span>
                </div>
                <div class="header-right">
                    <div class="header-date"><i class="far fa-calendar-alt"></i><span id="currentDate"></span></div>
                    <div class="header-user">
                        <div class="user-avatar">M</div>
                        <div class="user-info">
                            <span class="user-name"><c:out value="${sessionScope.authUser.fullName}"/></span>
                            <span class="user-role">Manager</span>
                        </div>
                    </div>
                </div>
            </header>

            <main class="page-content">
                <div class="page-header-card">
                    <div class="page-header-content">
                        <div class="page-header-icon"><i class="fas fa-chart-line"></i></div>
                        <div>
                            <h1>Tổng quan Manager</h1>
                            <p>Theo dõi hoạt động và thống kê của bếp ăn mầm non</p>
                        </div>
                    </div>
                </div>

                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon blue"><i class="fas fa-user-graduate"></i></div>
                        <div class="stat-info">
                            <h3>150</h3>
                            <p>Học sinh</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon green"><i class="fas fa-chalkboard"></i></div>
                        <div class="stat-info">
                            <h3>12</h3>
                            <p>Lớp học</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon orange"><i class="fas fa-utensils"></i></div>
                        <div class="stat-info">
                            <h3>145</h3>
                            <p>Suất ăn hôm nay</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon purple"><i class="fas fa-clipboard-list"></i></div>
                        <div class="stat-info">
                            <h3>5</h3>
                            <p>Thực đơn tuần này</p>
                        </div>
                    </div>
                </div>

                <div class="info-box" style="margin-top: 20px;">
                    <h3><i class="fas fa-info-circle"></i> Hướng dẫn cho Manager</h3>
                    <ul class="info-list">
                        <li><i class="fas fa-chalkboard"></i> <span>Quản lý lớp học: Thêm, sửa, xóa thông tin các lớp học</span></li>
                        <li><i class="fas fa-user-graduate"></i> <span>Quản lý học sinh: Thêm, sửa, xóa thông tin học sinh</span></li>
                        <li><i class="fas fa-calendar-check"></i> <span>Điểm danh: Theo dõi và cập nhật điểm danh hàng ngày</span></li>
                        <li><i class="fas fa-carrot"></i> <span>Nguyên liệu: Quản lý nguyên liệu cần thiết cho bếp</span></li>
                        <li><i class="fas fa-clipboard-list"></i> <span>Lịch sử bếp: Xem lại lịch sử các bữa ăn đã nấu</span></li>
                    </ul>
                </div>
            </main>
        </div>
    </div>

    <script>
        const dateEl = document.getElementById('currentDate');
        const today = new Date();
        const options = { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' };
        dateEl.textContent = today.toLocaleDateString('vi-VN', options);
    </script>
</body>
</html>
