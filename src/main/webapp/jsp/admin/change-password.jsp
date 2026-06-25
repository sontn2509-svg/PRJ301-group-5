<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi mật khẩu - KindergartenKitchen</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
* { margin: 0; padding: 0; box-sizing: border-box; }
body { font-family: 'Segoe UI', Tahoma, sans-serif; background: #f5f7fa; color: #1e293b; line-height: 1.6; }
a { text-decoration: none; color: inherit; }
.app-container { display: flex; min-height: 100vh; }
.main-content { flex: 1; margin-left: 260px; display: flex; flex-direction: column; min-height: 100vh; }
.page-content { flex: 1; padding: 24px 32px; }

.page-header-card { background: linear-gradient(135deg, #ea580c 0%, #f97316 50%, #fb923c 100%); border-radius: 16px; padding: 28px 32px; margin-bottom: 24px; color: #fff; }
.page-header-content { display: flex; align-items: center; gap: 20px; }
.page-header-icon { width: 60px; height: 60px; background: rgba(255,255,255,0.2); border: 2px solid rgba(255,255,255,0.3); border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 28px; flex-shrink: 0; }
.page-header-card h1 { font-size: 24px; font-weight: 800; margin-bottom: 4px; }
.page-header-card p { opacity: 0.9; font-size: 14px; }

.panel { background: #fff; border-radius: 16px; box-shadow: 0 2px 8px rgba(0,0,0,0.04); border: 1px solid #e2e8f0; margin-bottom: 20px; overflow: hidden; }
.panel-header { padding: 18px 24px; border-bottom: 1px solid #e2e8f0; display: flex; align-items: center; justify-content: space-between; }
.panel-title { display: flex; align-items: center; gap: 10px; font-size: 16px; font-weight: 700; color: #1e293b; }
.panel-title .icon { width: 32px; height: 32px; background: rgba(249,115,22,0.1); border-radius: 8px; display: flex; align-items: center; justify-content: center; color: #f97316; font-size: 14px; }
.panel-body { padding: 24px; }

.form-group { margin-bottom: 18px; }
.form-label { display: block; font-size: 13px; font-weight: 700; color: #1e293b; margin-bottom: 8px; }
.form-control { width: 100%; padding: 12px 16px; border: 2px solid #e2e8f0; border-radius: 10px; font-size: 14px; font-family: inherit; color: #1e293b; background: #fff; transition: all 0.2s; }
.form-control:focus { outline: none; border-color: #f97316; box-shadow: 0 0 0 4px rgba(249,115,22,0.1); }

.btn { display: inline-flex; align-items: center; justify-content: center; gap: 8px; padding: 10px 18px; border-radius: 10px; font-size: 14px; font-weight: 600; border: none; cursor: pointer; transition: all 0.2s; font-family: inherit; }
.btn-primary { background: linear-gradient(135deg, #f97316, #fb923c); color: #fff; box-shadow: 0 4px 12px rgba(249,115,22,0.3); }
.btn-ghost { background: transparent; color: #475569; }
.btn-ghost:hover { background: #f5f7fa; color: #1e293b; }

.alert-card { border-radius: 12px; padding: 16px 20px; margin-bottom: 20px; display: flex; align-items: center; gap: 14px; }
.alert-card.danger { background: rgba(239,68,68,0.1); border: 1px solid rgba(239,68,68,0.3); color: #ef4444; }
.alert-card.success { background: rgba(16,185,129,0.1); border: 1px solid rgba(16,185,129,0.3); color: #10b981; }
.alert-icon { font-size: 20px; }

@media (max-width: 768px) { .main-content { margin-left: 80px; } .page-content { padding: 16px; } }
    </style>
</head>
<body>
    <div class="app-container">
        <jsp:include page="/jsp/layout/sidebar-admin.jsp"/>
        <div class="main-content">
            <jsp:include page="/jsp/layout/header.jsp"/>
            <main class="page-content">
                <div class="page-header-card">
                    <div class="page-header-content">
                        <div class="page-header-icon"><i class="fas fa-key"></i></div>
                        <div>
                            <h1>Đổi mật khẩu</h1>
                            <p>Thay đổi mật khẩu để bảo mật tài khoản của bạn</p>
                        </div>
                    </div>
                </div>

                <c:if test="${not empty errors}">
                    <div class="alert-card danger">
                        <i class="fas fa-exclamation-circle alert-icon"></i>
                        <div><strong>Vui lòng kiểm tra lại</strong>
                            <ul style="margin: 8px 0 0 20px;">
                                <c:forEach var="error" items="${errors}"><li>${error}</li></c:forEach>
                            </ul>
                        </div>
                    </div>
                </c:if>

                <c:if test="${not empty success}">
                    <div class="alert-card success">
                        <i class="fas fa-check-circle alert-icon"></i>
                        <span>${success}</span>
                    </div>
                </c:if>

                <div class="panel" style="max-width: 500px;">
                    <div class="panel-header">
                        <div class="panel-title"><span class="icon"><i class="fas fa-key"></i></span>Thông tin mật khẩu</div>
                    </div>
                    <div class="panel-body">
                        <form method="post" action="${pageContext.request.contextPath}/admin/change-password">
                            <div class="form-group">
                                <label class="form-label"><i class="fas fa-lock" style="color: #f97316; margin-right: 6px;"></i>Mật khẩu hiện tại</label>
                                <input type="password" name="currentPassword" class="form-control" required autofocus placeholder="Nhập mật khẩu hiện tại">
                            </div>
                            <div class="form-group">
                                <label class="form-label"><i class="fas fa-key" style="color: #f97316; margin-right: 6px;"></i>Mật khẩu mới</label>
                                <input type="password" name="newPassword" class="form-control" minlength="6" required placeholder="Ít nhất 6 ký tự">
                            </div>
                            <div class="form-group">
                                <label class="form-label"><i class="fas fa-check-double" style="color: #f97316; margin-right: 6px;"></i>Xác nhận mật khẩu mới</label>
                                <input type="password" name="confirmPassword" class="form-control" minlength="6" required placeholder="Nhập lại mật khẩu mới">
                            </div>
                            <div style="display: flex; gap: 12px; margin-top: 8px;">
                                <button type="submit" class="btn btn-primary"><i class="fas fa-floppy-disk"></i> Đổi mật khẩu</button>
                                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-ghost"><i class="fas fa-arrow-left"></i> Quay lại</a>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>