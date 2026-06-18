<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi mật khẩu - KindergartenKitchen</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="app-container">
        <jsp:include page="/jsp/layout/sidebar.jsp"/>
        
        <div class="main-content">
            <header class="header">
                <div class="header-left">
                    <div class="header-greeting">
                        <h2>Đổi mật khẩu</h2>
                        <span>Thay đổi mật khẩu để bảo mật tài khoản</span>
                    </div>
                </div>
                <div class="header-right">
                    <div class="header-date">
                        <i class="far fa-calendar-alt"></i>
                        <span id="currentDate"></span>
                    </div>
                    <div class="header-user">
                        <div class="user-avatar">
                            ${sessionScope.authUser.roleName == 'Admin' ? 'A' : sessionScope.authUser.roleName == 'Manager' ? 'M' : 'K'}
                        </div>
                        <div class="user-info">
                            <span class="user-name"><c:out value="${sessionScope.authUser.fullName}"/></span>
                            <span class="user-role"><c:out value="${sessionScope.authUser.roleName}"/></span>
                        </div>
                    </div>
                </div>
            </header>

            <main class="page-content">
                <div class="page-title">
                    <h1>
                        <span class="emoji">🔐</span>
                        Đổi mật khẩu
                    </h1>
                    <p>Thay đổi mật khẩu để bảo mật tài khoản của bạn</p>
                </div>

                <c:if test="${not empty errors}">
                    <div class="alert-card danger" style="margin-bottom: 25px;">
                        <span class="alert-icon">⚠️</span>
                        <div class="alert-content">
                            <h4>Vui lòng kiểm tra lại</h4>
                            <c:forEach var="error" items="${errors}">
                                <p style="margin: 5px 0 0 0;">• <c:out value="${error}"/></p>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>

                <c:if test="${not empty success}">
                    <div class="alert-card success" style="margin-bottom: 25px;">
                        <span class="alert-icon">✅</span>
                        <div class="alert-content">
                            <p><c:out value="${success}"/></p>
                        </div>
                    </div>
                </c:if>

                <div class="panel" style="max-width: 500px;">
                    <div class="panel-header">
                        <div class="panel-title">
                            <span class="icon"><i class="fas fa-key"></i></span>
                            Thông tin mật khẩu
                        </div>
                    </div>
                    <div class="panel-body">
                        <form method="post" action="${pageContext.request.contextPath}/admin/change-password">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-lock"></i> Mật khẩu hiện tại
                                </label>
                                <input type="password" name="currentPassword" class="form-control" 
                                       required autofocus placeholder="Nhập mật khẩu hiện tại">
                            </div>

                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-key"></i> Mật khẩu mới
                                </label>
                                <input type="password" name="newPassword" class="form-control" 
                                       minlength="6" required placeholder="Nhập mật khẩu mới (ít nhất 6 ký tự)">
                            </div>

                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-check-double"></i> Xác nhận mật khẩu mới
                                </label>
                                <input type="password" name="confirmPassword" class="form-control" 
                                       minlength="6" required placeholder="Nhập lại mật khẩu mới">
                            </div>

                            <div style="display: flex; gap: 15px; margin-top: 25px;">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Đổi mật khẩu
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline">
                                    <i class="fas fa-arrow-left"></i> Quay lại
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script>
        const dateElement = document.getElementById('currentDate');
        const today = new Date();
        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        dateElement.textContent = today.toLocaleDateString('vi-VN', options);
    </script>
</body>
</html>
