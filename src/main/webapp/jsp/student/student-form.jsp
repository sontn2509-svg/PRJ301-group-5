<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty student ? 'Sửa học sinh' : 'Thêm học sinh'} - KindergartenKitchen</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="app-container">
        <jsp:include page="/jsp/layout/sidebar-manager.jsp"/>
        <div class="main-content">
            <jsp:include page="/jsp/layout/header.jsp"/>
            <main class="page-content">
                <div class="page-header-card">
                    <div class="page-header-content">
                        <div class="page-header-icon"><i class="fas ${not empty student ? 'fa-pen' : 'fa-plus'}"></i></div>
                        <div><h1>${not empty student ? 'Sửa thông tin học sinh' : 'Thêm học sinh mới'}</h1><p>Nhập thông tin học sinh</p></div>
                    </div>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert-card danger"><i class="fas fa-exclamation-circle alert-icon"></i><span>${error}</span></div>
                </c:if>

                <div class="panel">
                    <div class="panel-header"><div class="panel-title"><span class="icon"><i class="fas fa-user-graduate"></i></span>Thông tin học sinh</div></div>
                    <div class="panel-body">
                        <form method="post" action="${pageContext.request.contextPath}/manager/students" style="max-width:560px;">
                            <input type="hidden" name="action" value="${not empty student ? 'edit' : 'add'}">
                            <c:if test="${not empty student}">
                                <input type="hidden" name="studentID" value="${student.studentID}">
                            </c:if>

                            <div class="grid-2">
                                <div class="form-group">
                                    <label class="form-label">Mã học sinh <span style="color:#ef4444;">*</span></label>
                                    <input type="text" name="studentCode" class="form-control" maxlength="20" required
                                           value="${not empty student ? student.studentCode : ''}">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Họ và tên <span style="color:#ef4444;">*</span></label>
                                    <input type="text" name="studentName" class="form-control" maxlength="100" required
                                           value="${not empty student ? student.studentName : ''}">
                                </div>
                            </div>

                            <div class="grid-2">
                                <div class="form-group">
                                    <label class="form-label">Ngày sinh</label>
                                    <input type="date" name="dateOfBirth" class="form-control"
                                           value="${not empty student ? student.dateOfBirth : ''}">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Giới tính</label>
                                    <select name="gender" class="form-control form-select">
                                        <option value="1" ${not empty student && student.gender ? 'selected' : ''}>Nam</option>
                                        <option value="0" ${not empty student && !student.gender ? 'selected' : ''}>Nữ</option>
                                    </select>
                                </div>
                            </div>

                            <div class="grid-2">
                                <div class="form-group">
                                    <label class="form-label">Lớp <span style="color:#ef4444;">*</span></label>
                                    <select name="classID" class="form-control form-select" required>
                                        <c:forEach var="cls" items="${classList}">
                                            <option value="${cls.classID}" ${not empty student && student.classID == cls.classID ? 'selected' : ''}>${cls.className} - ${cls.levelName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Phụ huynh</label>
                                    <select name="parentID" class="form-control form-select">
                                        <option value="">-- Chưa có phụ huynh --</option>
                                        <c:forEach var="p" items="${parents}">
                                            <option value="${p.userID}" ${not empty student && student.parentID == p.userID ? 'selected' : ''}>${p.fullName} (${p.username})</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div style="display:flex; gap:10px; margin-top:8px;">
                                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> ${not empty student ? 'Lưu thay đổi' : 'Thêm học sinh'}</button>
                                <a href="${pageContext.request.contextPath}/manager/students" class="btn btn-outline">Hủy</a>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>
