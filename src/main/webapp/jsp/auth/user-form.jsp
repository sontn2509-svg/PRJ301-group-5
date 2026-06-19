<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${editMode ? 'Sửa tài khoản' : 'Tạo tài khoản'} - KindergartenKitchen</title>
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
                        <h2>${editMode ? 'Sửa tài khoản' : 'Tạo tài khoản'}</h2>
                        <span>Quản lý thông tin người dùng</span>
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
                        <span class="emoji">${editMode ? '✏️' : '➕'}</span>
                        ${editMode ? 'Sửa tài khoản' : 'Tạo tài khoản mới'}
                    </h1>
                    <p>Điền thông tin bên dưới để ${editMode ? 'cập nhật' : 'tạo mới'} tài khoản</p>
                </div>

                <c:if test="${not empty errors}">
                    <div class="alert-card danger" style="margin-bottom: 25px;">
                        <span class="alert-icon">⚠️</span>
                        <div class="alert-content">
                            <h4>Vui lòng kiểm tra lại thông tin</h4>
                            <c:forEach var="error" items="${errors}">
                                <p style="margin: 5px 0 0 0;">• <c:out value="${error}"/></p>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>

                <div class="panel" style="max-width: 700px;">
                    <div class="panel-header">
                        <div class="panel-title">
                            <span class="icon"><i class="fas fa-user-circle"></i></span>
                            Thông tin tài khoản
                        </div>
                    </div>
                    <div class="panel-body">
                        <form method="post" action="${formAction}">
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                                <div class="form-group">
                                    <label class="form-label">
                                        <i class="fas fa-user"></i> Tên đăng nhập
                                    </label>
                                    <c:choose>
                                        <c:when test="${editMode}">
                                            <input type="text" class="form-control" value="${userForm.username}" disabled 
                                                   style="background: #f5f5f5; cursor: not-allowed;">
                                        </c:when>
                                        <c:otherwise>
                                            <input type="text" name="username" class="form-control" 
                                                   value="${userForm.username}" required
                                                   placeholder="Nhập tên đăng nhập">
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">
                                        <i class="fas fa-lock"></i> Mật khẩu
                                        <c:if test="${editMode}">
                                            <span style="font-weight: 400; color: var(--text-light);">(để trống nếu không đổi)</span>
                                        </c:if>
                                    </label>
                                    <input type="password" name="password" class="form-control" 
                                           ${editMode ? '' : 'required'}
                                           placeholder="${editMode ? 'Nhập mật khẩu mới' : 'Nhập mật khẩu'}">
                                </div>

                                <div class="form-group">
                                    <label class="form-label">
                                        <i class="fas fa-id-card"></i> Họ và tên
                                    </label>
                                    <input type="text" name="fullName" class="form-control" 
                                           value="${userForm.fullName}" required
                                           placeholder="Nhập họ và tên đầy đủ">
                                </div>

                                <div class="form-group">
                                    <label class="form-label">
                                        <i class="fas fa-envelope"></i> Email
                                    </label>
                                    <input type="email" name="email" class="form-control" 
                                           value="${userForm.email}"
                                           placeholder="Nhập địa chỉ email">
                                </div>

                                <div class="form-group">
                                    <label class="form-label">
                                        <i class="fas fa-phone"></i> Số điện thoại
                                    </label>
                                    <input type="text" name="phone" class="form-control" 
                                           value="${userForm.phone}"
                                           placeholder="Nhập số điện thoại">
                                </div>

                                <div class="form-group">
                                    <label class="form-label">
                                        <i class="fas fa-user-tag"></i> Vai trò
                                    </label>
                                    <select name="roleId" class="form-control form-select" required>
                                        <option value="">-- Chọn vai trò --</option>
                                        <c:forEach var="role" items="${roles}">
                                            <c:if test="${editMode || role.roleId != 1}">
                                                <option value="${role.roleId}" ${userForm.roleId == role.roleId ? 'selected' : ''}>
                                                    <c:out value="${role.roleName}"/>
                                                </option>
                                            </c:if>
                                        </c:forEach>
                                    </select>
                                    <c:if test="${not editMode}">
                                        <small style="color: var(--text-light); font-size: 12px; margin-top: 4px; display: block;">
                                            <i class="fas fa-info-circle"></i> Chỉ có duy nhất 1 tài khoản Admin trong hệ thống
                                        </small>
                                    </c:if>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">
                                        <i class="fas fa-toggle-on"></i> Trạng thái
                                    </label>
                                    <select name="status" class="form-control form-select">
                                        <option value="1" ${userForm.status == 1 ? 'selected' : ''}>Hoạt động</option>
                                        <option value="0" ${userForm.status == 0 ? 'selected' : ''}>Chờ duyệt</option>
                                        <option value="2" ${userForm.status == 2 ? 'selected' : ''}>Bị khóa</option>
                                    </select>
                                </div>
                            </div>

                            <div style="display: flex; gap: 15px; margin-top: 30px; padding-top: 20px; border-top: 1px dashed #E8E2DB;">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> ${editMode ? 'Lưu thay đổi' : 'Tạo tài khoản'}
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline">
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
