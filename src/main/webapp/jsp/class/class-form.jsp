<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty classInfo ? 'Sửa lớp học' : 'Thêm lớp học'} - KindergartenKitchen</title>
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
                        <div class="page-header-icon"><i class="fas ${not empty classInfo ? 'fa-pen' : 'fa-plus'}"></i></div>
                        <div><h1>${not empty classInfo ? 'Sửa lớp học' : 'Thêm lớp học mới'}</h1><p>Nhập thông tin lớp học</p></div>
                    </div>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert-card danger"><i class="fas fa-exclamation-circle alert-icon"></i><span>${error}</span></div>
                </c:if>

                <div class="panel">
                    <div class="panel-header"><div class="panel-title"><span class="icon"><i class="fas fa-chalkboard"></i></span>Thông tin lớp</div></div>
                    <div class="panel-body">
                        <form method="post" action="${pageContext.request.contextPath}/manager/classes" style="max-width:520px;">
                            <input type="hidden" name="action" value="${not empty classInfo ? 'edit' : 'add'}">
                            <c:if test="${not empty classInfo}">
                                <input type="hidden" name="classID" value="${classInfo.classID}">
                            </c:if>

                            <div class="form-group">
                                <label class="form-label">Tên lớp <span style="color:#ef4444;">*</span></label>
                                <input type="text" name="className" class="form-control" maxlength="50" required
                                       value="${not empty classInfo ? classInfo.className : ''}">
                            </div>

                            <div class="form-group">
                                <label class="form-label">Cấp học <span style="color:#ef4444;">*</span></label>
                                <select name="levelID" class="form-control form-select" required>
                                    <c:forEach var="lv" items="${levels}">
                                        <option value="${lv.levelID}" ${not empty classInfo && classInfo.levelID == lv.levelID ? 'selected' : ''}>${lv.levelName}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Giáo viên phụ trách</label>
                                <select name="teacherID" class="form-control form-select">
                                    <option value="">-- Chưa phân công --</option>
                                    <c:forEach var="t" items="${teachers}">
                                        <option value="${t.userID}" ${not empty classInfo && classInfo.teacherID == t.userID ? 'selected' : ''}>${t.fullName}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div style="display:flex; gap:10px; margin-top:8px;">
                                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> ${not empty classInfo ? 'Lưu thay đổi' : 'Thêm lớp'}</button>
                                <a href="${pageContext.request.contextPath}/manager/classes" class="btn btn-outline">Hủy</a>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>
