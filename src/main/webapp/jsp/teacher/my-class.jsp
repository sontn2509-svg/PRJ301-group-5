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
        <jsp:include page="/jsp/layout/sidebar-teacher.jsp"/>
        <div class="main-content">
            <jsp:include page="/jsp/layout/header.jsp"/>
            <main class="page-content">
                <div class="page-header-card">
                    <div class="page-header-content">
                        <div class="page-header-icon"><i class="fas fa-users"></i></div>
                        <div><h1>Lớp học của tôi</h1><p>Xem thông tin lớp được phân công</p></div>
                    </div>
                </div>
                <div class="panel">
                    <div class="panel-header"><div class="panel-title"><span class="icon"><i class="fas fa-chalkboard"></i></span>Thông tin lớp</div></div>
                    <div class="panel-body">
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px;">
                            <div class="stat-card"><div class="stat-icon blue"><i class="fas fa-chalkboard"></i></div><div class="stat-info"><h3>${className}</h3><p>Lớp học</p></div></div>
                            <div class="stat-card"><div class="stat-icon green"><i class="fas fa-users"></i></div><div class="stat-info"><h3>${studentCount}</h3><p>Học sinh</p></div></div>
                        </div>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header"><div class="panel-title"><span class="icon"><i class="fas fa-user-graduate"></i></span>Danh sách học sinh</div></div>
                    <table>
                        <thead>
                            <tr><th>Học sinh</th><th>Ngày sinh</th><th>Giới tính</th><th>Phụ huynh</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="s" items="${students}">
                                <tr>
                                    <td>
                                        <div class="student-row">
                                            <div class="student-avatar">${fn:substring(s.studentName,0,1)}</div>
                                            <span class="student-name">${s.studentName}</span>
                                        </div>
                                    </td>
                                    <td>${s.dateOfBirth}</td>
                                    <td>${s.gender ? 'Nam' : 'Nữ'}</td>
                                    <td><i class="fas fa-user" style="color:#94a3b8; margin-right:6px;"></i>${s.parentName}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty students}">
                                <tr><td colspan="4" style="text-align:center; padding:32px; color:#94a3b8;">Chưa có học sinh trong lớp.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>
    </div>
</body>
</html>
