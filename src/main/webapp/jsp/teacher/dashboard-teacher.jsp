<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giáo viên - KindergartenKitchen</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; font-size: 14px; color: #7c2d12; background: #fffbf5; min-height: 100vh; }
        .app-container { display: flex; min-height: 100vh; }
        .sidebar { width: 260px; background: #fff; border-right: 1px solid rgba(249, 115, 22, 0.1); position: fixed; height: 100vh; overflow-y: auto; display: flex; flex-direction: column; }
        .sidebar-header { padding: 28px 24px; text-align: center; border-bottom: 1px solid rgba(249, 115, 22, 0.1); background: linear-gradient(180deg, rgba(251, 146, 60, 0.08) 0%, transparent 100%); }
        .sidebar-logo { width: 60px; height: 60px; background: linear-gradient(135deg, rgba(249, 115, 22, 0.2), rgba(251, 146, 60, 0.15)); border-radius: 16px; display: flex; align-items: center; justify-content: center; margin: 0 auto 14px; font-size: 26px; color: #ea580c; }
        .sidebar-title { font-size: 15px; font-weight: 700; color: #9a3412; }
        .sidebar-subtitle { font-size: 11px; color: #c2410c; }
        .sidebar-nav { padding: 16px 12px; flex: 1; }
        .nav-section-label { font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: 1.2px; color: #a8a29e; padding: 12px 12px 6px; margin-top: 8px; }
        .nav-item { margin-bottom: 4px; }
        .nav-item a { display: flex; align-items: center; gap: 12px; padding: 11px 14px; color: #78716c; text-decoration: none; border-radius: 10px; font-weight: 600; transition: all 0.2s; }
        .nav-item a:hover, .nav-item a.active { background: rgba(249, 115, 22, 0.1); color: #ea580c; }
        .nav-icon { width: 34px; height: 34px; background: rgba(249, 115, 22, 0.05); border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 14px; }
        .sidebar-footer { padding: 16px 12px; border-top: 1px solid rgba(249, 115, 22, 0.08); }
        .logout-btn { display: flex; align-items: center; gap: 12px; padding: 11px 14px; color: #78716c; border-radius: 10px; font-weight: 600; width: 100%; cursor: pointer; border: none; background: none; font-family: inherit; transition: all 0.2s; }
        .logout-btn:hover { background: rgba(239, 68, 68, 0.1); color: #dc2626; }
        .main-content { flex: 1; margin-left: 260px; min-height: 100vh; display: flex; flex-direction: column; }
        .header { background: rgba(255, 255, 255, 0.98); height: 68px; padding: 0 32px; display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid rgba(249, 115, 22, 0.08); position: sticky; top: 0; z-index: 50; }
        .header-greeting h2 { font-size: 17px; font-weight: 700; color: #9a3412; }
        .header-greeting span { font-size: 12px; color: #c2410c; }
        .header-right { display: flex; align-items: center; gap: 14px; }
        .header-date { padding: 6px 12px; background: rgba(249, 115, 22, 0.05); border: 1px solid rgba(249, 115, 22, 0.1); border-radius: 999px; font-size: 12px; font-weight: 600; color: #c2410c; }
        .header-user { display: flex; align-items: center; gap: 10px; padding: 5px 12px 5px 5px; background: rgba(249, 115, 22, 0.05); border: 1px solid rgba(249, 115, 22, 0.1); border-radius: 999px; }
        .user-avatar { width: 34px; height: 34px; background: linear-gradient(135deg, #ea580c, #fb923c); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: 800; font-size: 13px; }
        .user-name { font-weight: 700; font-size: 12px; color: #9a3412; }
        .user-role { font-size: 10px; color: #ea580c; font-weight: 600; }
        .page-content { padding: 28px 32px; flex: 1; }
        .page-header-card { background: linear-gradient(135deg, rgba(249, 115, 22, 0.1) 0%, rgba(251, 146, 60, 0.05) 100%); border: 1px solid rgba(249, 115, 22, 0.15); border-radius: 16px; padding: 24px 28px; margin-bottom: 28px; }
        .page-header-content { display: flex; align-items: center; gap: 18px; }
        .page-header-icon { width: 54px; height: 54px; background: linear-gradient(135deg, rgba(249, 115, 22, 0.2), rgba(251, 146, 60, 0.15)); border: 1px solid rgba(249, 115, 22, 0.25); border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 22px; color: #ea580c; }
        .page-header-content h1 { font-size: 20px; font-weight: 800; color: #9a3412; margin-bottom: 3px; }
        .page-header-content p { color: #c2410c; font-size: 13px; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 20px; margin-bottom: 28px; }
        .stat-card { background: #fff; border: 1px solid rgba(249, 115, 22, 0.1); border-radius: 14px; padding: 22px 24px; display: flex; align-items: center; gap: 18px; transition: all 0.3s ease; }
        .stat-card:hover { transform: translateY(-2px); box-shadow: 0 8px 25px rgba(249, 115, 22, 0.1); }
        .stat-icon { width: 52px; height: 52px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 22px; }
        .stat-icon.blue { background: rgba(59, 130, 246, 0.1); color: #3b82f6; }
        .stat-icon.green { background: rgba(34, 197, 94, 0.1); color: #22c55e; }
        .stat-icon.orange { background: rgba(249, 115, 22, 0.1); color: #ea580c; }
        .stat-info h3 { font-size: 26px; font-weight: 800; color: #9a3412; }
        .stat-info p { font-size: 12px; color: #c2410c; font-weight: 500; }
        .info-box { background: #fff; border: 1px solid rgba(249, 115, 22, 0.1); border-radius: 14px; padding: 24px; }
        .info-box h3 { font-size: 16px; font-weight: 700; color: #9a3412; margin-bottom: 16px; display: flex; align-items: center; gap: 10px; }
        .info-box h3 i { color: #ea580c; }
        .info-list { list-style: none; }
        .info-list li { padding: 12px 0; border-bottom: 1px solid rgba(249, 115, 22, 0.08); display: flex; align-items: center; gap: 12px; }
        .info-list li:last-child { border-bottom: none; }
        .info-list li i { width: 32px; height: 32px; background: rgba(249, 115, 22, 0.1); border-radius: 8px; display: flex; align-items: center; justify-content: center; color: #ea580c; font-size: 14px; }
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(16px); } to { opacity: 1; transform: translateY(0); } }
        .page-header-card, .stat-card, .info-box { animation: fadeInUp 0.4s ease forwards; }
        @media (max-width: 768px) { .sidebar { transform: translateX(-100%); } .main-content { margin-left: 0; } }
    </style>
</head>
<body>
    <div class="app-container">
        <aside class="sidebar">
            <div class="sidebar-header">
                <div class="sidebar-logo"><i class="fas fa-chalkboard-teacher"></i></div>
                <h3 class="sidebar-title">KindergartenKitchen</h3>
                <span class="sidebar-subtitle">Quản lý bếp ăn</span>
            </div>
            <nav class="sidebar-nav">
                <div class="nav-section-label">Chính</div>
                <div class="nav-item"><a href="${pageContext.request.contextPath}/teacher" class="active"><span class="nav-icon"><i class="fas fa-home"></i></span><span>Tổng quan</span></a></div>
                <div class="nav-item"><a href="${pageContext.request.contextPath}/teacher/my-class"><span class="nav-icon"><i class="fas fa-users"></i></span><span>Lớp học</span></a></div>
                <div class="nav-item"><a href="${pageContext.request.contextPath}/teacher/attendance"><span class="nav-icon"><i class="fas fa-calendar-check"></i></span><span>Điểm danh</span></a></div>
                <div class="nav-item"><a href="${pageContext.request.contextPath}/teacher/absences"><span class="nav-icon"><i class="fas fa-user-slash"></i></span><span>Xin nghỉ ăn</span></a></div>
                <div class="nav-section-label">Tài khoản</div>
                <div class="nav-item"><a href="${pageContext.request.contextPath}/teacher/change-password"><span class="nav-icon"><i class="fas fa-key"></i></span><span>Đổi mật khẩu</span></a></div>
            </nav>
            <div class="sidebar-footer">
                <form method="post" action="${pageContext.request.contextPath}/logout"><button type="submit" class="logout-btn"><span class="nav-icon"><i class="fas fa-sign-out-alt"></i></span><span>Đăng xuất</span></button></form>
            </div>
        </aside>
        <div class="main-content">
            <header class="header">
                <div class="header-greeting">
                    <h2>Tổng quan</h2>
                    <span>Xin chào, giáo viên!</span>
                </div>
                <div class="header-right">
                    <div class="header-date"><i class="far fa-calendar-alt"></i><span id="currentDate"></span></div>
                    <div class="header-user">
                        <div class="user-avatar">T</div>
                        <div><span class="user-name"><c:out value="${sessionScope.authUser.fullName}"/></span><br><span class="user-role">Giáo viên</span></div>
                    </div>
                </div>
            </header>
            <main class="page-content">
                <div class="page-header-card">
                    <div class="page-header-content">
                        <div class="page-header-icon"><i class="fas fa-chalkboard-teacher"></i></div>
                        <div>
                            <h1>Tổng quan Giáo viên</h1>
                            <p>Quản lý lớp học và điểm danh học sinh</p>
                        </div>
                    </div>
                </div>
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon blue"><i class="fas fa-users"></i></div>
                        <div class="stat-info"><h3>25</h3><p>Học sinh trong lớp</p></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon green"><i class="fas fa-calendar-check"></i></div>
                        <div class="stat-info"><h3>22</h3><p>Ngày đã điểm danh</p></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon orange"><i class="fas fa-user-slash"></i></div>
                        <div class="stat-info"><h3>3</h3><p>Yêu cầu nghỉ ăn</p></div>
                    </div>
                </div>
                <div class="info-box" style="margin-top: 20px;">
                    <h3><i class="fas fa-info-circle"></i> Hướng dẫn cho Giáo viên</h3>
                    <ul class="info-list">
                        <li><i class="fas fa-users"></i> <span>Lớp học: Xem thông tin lớp học được phân công</span></li>
                        <li><i class="fas fa-calendar-check"></i> <span>Điểm danh: Cập nhật điểm danh hàng ngày cho học sinh</span></li>
                        <li><i class="fas fa-user-slash"></i> <span>Xin nghỉ ăn: Gửi yêu cầu xin nghỉ ăn cho học sinh</span></li>
                        <li><i class="fas fa-key"></i> <span>Đổi mật khẩu: Thay đổi mật khẩu để bảo mật tài khoản</span></li>
                    </ul>
                </div>
            </main>
        </div>
    </div>
    <script>
        document.getElementById('currentDate').textContent = new Date().toLocaleDateString('vi-VN', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' });
    </script>
</body>
</html>
