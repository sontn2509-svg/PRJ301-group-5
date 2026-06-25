<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lớp học - KindergartenKitchen</title>
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
                        <div class="page-header-icon"><i class="fas fa-chalkboard"></i></div>
                        <div><h1>Quản lý lớp học</h1><p>Thêm, sửa, xóa thông tin các lớp học</p></div>
                    </div>
                </div>

                <c:if test="${not empty flash}">
                    <div class="alert-card success">
                        <i class="fas fa-check-circle alert-icon"></i>
                        <span>${flash}</span>
                    </div>
                </c:if>

                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title"><span class="icon"><i class="fas fa-list"></i></span>Danh sách lớp học</div>
                        <span style="color: #64748b;">Tổng: <strong style="color: #f97316;">${classes.size()}</strong> lớp</span>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên lớp</th>
                                <th>Giáo viên</th>
                                <th>Sĩ số</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="cls" items="${classes}">
                                <tr>
                                    <td><strong style="color: #f97316;">#${cls.classId}</strong></td>
                                    <td>
                                        <div class="class-row">
                                            <div class="class-icon"><i class="fas fa-chalkboard"></i></div>
                                            <span class="class-name">${cls.className}</span>
                                        </div>
                                    </td>
                                    <td><i class="fas fa-user" style="color: #94a3b8; margin-right: 6px;"></i>${cls.teacherName}</td>
                                    <td><span style="font-weight: 700; color: #1e293b;">${cls.studentCount}</span> học sinh</td>
                                    <td><a href="${pageContext.request.contextPath}/manager/classes/edit?id=${cls.classId}" class="btn btn-ghost btn-sm"><i class="fas fa-pen"></i></a></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty classes}">
                                <tr><td colspan="5" style="text-align: center; padding: 32px; color: #94a3b8;">Chưa có lớp học nào.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>
    </div>
</body>
</html>