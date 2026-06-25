<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${editMode ? 'Sửa tài khoản' : 'Tạo tài khoản'} - KindergartenKitchen</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="app-container">
        <jsp:include page="/jsp/layout/sidebar-admin.jsp"/>
        <div class="main-content">
            <jsp:include page="/jsp/layout/header.jsp"/>
            <main class="page-content">
                <div class="page-header-card">
                    <div class="page-header-content">
                        <div class="page-header-icon"><i class="fas fa-user-circle"></i></div>
                        <div>
                            <h1>${editMode ? 'Sửa tài khoản' : 'Tạo tài khoản mới'}</h1>
                            <p>Điền thông tin bên dưới để ${editMode ? 'cập nhật' : 'tạo mới'} tài khoản</p>
                        </div>
                    </div>
                </div>

                <c:if test="${not empty errors}">
                    <div class="alert-card danger">
                        <i class="fas fa-exclamation-circle alert-icon"></i>
                        <div><strong>Vui lòng kiểm tra lại thông tin</strong>
                            <ul style="margin: 8px 0 0 20px;">
                                <c:forEach var="error" items="${errors}"><li>${error}</li></c:forEach>
                            </ul>
                        </div>
                    </div>
                </c:if>

                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title"><span class="icon"><i class="fas fa-user-circle"></i></span>Thông tin tài khoản</div>
                    </div>
                    <div class="panel-body">
                        <form method="post" action="${formAction}">
                            <div class="grid-2">
                                <div class="form-group">
                                    <label class="form-label"><i class="fas fa-user" style="color: #f97316; margin-right: 6px;"></i>Tên đăng nhập</label>
                                    <c:choose>
                                        <c:when test="${editMode}">
                                            <input type="text" class="form-control" value="${userForm.username}" disabled>
                                        </c:when>
                                        <c:otherwise>
                                            <input type="text" name="username" class="form-control" value="${userForm.username}" required placeholder="Nhập tên đăng nhập">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="form-group">
                                    <label class="form-label"><i class="fas fa-lock" style="color: #f97316; margin-right: 6px;"></i>Mật khẩu<c:if test="${editMode}"><span style="font-weight: 400; color: #94a3b8;"> (để trống nếu không đổi)</span></c:if></label>
                                    <input type="password" name="password" class="form-control" ${editMode ? '' : 'required'} placeholder="${editMode ? 'Nhập mật khẩu mới' : 'Nhập mật khẩu'}">
                                </div>
                            </div>
                            <div class="grid-2">
                                <div class="form-group">
                                    <label class="form-label"><i class="fas fa-id-card" style="color: #f97316; margin-right: 6px;"></i>Họ và tên</label>
                                    <input type="text" name="fullName" class="form-control" value="${userForm.fullName}" required placeholder="Nhập họ và tên đầy đủ">
                                </div>
                                <div class="form-group">
                                    <label class="form-label"><i class="fas fa-envelope" style="color: #f97316; margin-right: 6px;"></i>Email</label>
                                    <input type="email" name="email" class="form-control" value="${userForm.email}" placeholder="Nhập địa chỉ email">
                                </div>
                            </div>
                            <div class="grid-2">
                                <div class="form-group">
                                    <label class="form-label"><i class="fas fa-phone" style="color: #f97316; margin-right: 6px;"></i>Số điện thoại</label>
                                    <input type="text" name="phone" class="form-control" value="${userForm.phone}" placeholder="Nhập số điện thoại">
                                </div>
                                <div class="form-group">
                                    <label class="form-label"><i class="fas fa-shield-halved" style="color: #f97316; margin-right: 6px;"></i>Vai trò</label>
                                    <select name="roleId" class="form-control form-select" required>
                                        <option value="">-- Chọn vai trò --</option>
                                        <c:forEach var="role" items="${roles}">
                                            <c:if test="${editMode || role.roleId != 1}">
                                                <option value="${role.roleId}" ${userForm.roleId == role.roleId ? 'selected' : ''}>${role.roleName}</option>
                                            </c:if>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-label"><i class="fas fa-toggle-on" style="color: #f97316; margin-right: 6px;"></i>Trạng thái</label>
                                <select name="status" class="form-control form-select">
                                    <option value="1" ${userForm.status == 1 ? 'selected' : ''}>Hoạt động</option>
                                    <option value="0" ${userForm.status == 0 ? 'selected' : ''}>Chờ duyệt</option>
                                    <option value="2" ${userForm.status == 2 ? 'selected' : ''}>Bị khóa</option>
                                </select>
                            </div>
                            <div style="display: flex; gap: 12px; margin-top: 24px;">
                                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> ${editMode ? 'Lưu thay đổi' : 'Tạo tài khoản'}</button>
                                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-ghost"><i class="fas fa-arrow-left"></i> Quay lại</a>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>
