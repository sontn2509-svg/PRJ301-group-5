<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Học sinh - KindergartenKitchen</title>
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
                        <div class="page-header-icon"><i class="fas fa-user-graduate"></i></div>
                        <div><h1>Quản lý học sinh</h1><p>Thêm, sửa, xóa thông tin học sinh</p></div>
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
                        <div class="panel-title"><span class="icon"><i class="fas fa-list"></i></span>Danh sách học sinh</div>
                        <span style="color: #64748b;">Tổng: <strong style="color: #f97316;">${students.size()}</strong> học sinh</span>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Họ tên</th>
                                <th>Lớp</th>
                                <th>Ngày sinh</th>
                                <th>Phụ huynh</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="s" items="${students}">
                                <tr>
                                    <td><strong style="color: #f97316;">#${s.studentId}</strong></td>
                                    <td>
                                        <div class="student-row">
                                            <div class="student-avatar">${s.fullName.substring(0,1)}</div>
                                            <span class="student-name">${s.fullName}</span>
                                        </div>
                                    </td>
                                    <td>${s.className}</td>
                                    <td>${s.dateOfBirth}</td>
                                    <td>${s.parentName}</td>
                                    <td><a href="${pageContext.request.contextPath}/manager/students/edit?id=${s.studentId}" class="btn btn-ghost btn-sm"><i class="fas fa-pen"></i></a></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty students}">
                                <tr><td colspan="6" style="text-align: center; padding: 32px; color: #94a3b8;">Chưa có học sinh nào.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>
    </div>
</body>
</html>