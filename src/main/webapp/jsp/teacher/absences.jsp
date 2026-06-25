<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xin nghỉ ăn - KindergartenKitchen</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/shared.css">
</head>
<body>
    <div class="app-container">
        <jsp:include page="/jsp/layout/sidebar-teacher.jsp"/>
        <div class="main-content">
            <jsp:include page="/jsp/layout/header.jsp"/>
            <main class="page-content">
                <div class="page-header-card">
                    <div class="page-header-content">
                        <div class="page-header-icon"><i class="fas fa-user-slash"></i></div>
                        <div><h1>Xin nghỉ ăn</h1><p>Gửi yêu cầu xin nghỉ ăn cho học sinh</p></div>
                    </div>
                </div>
                <div class="panel">
                    <div class="panel-header"><div class="panel-title"><span class="icon"><i class="fas fa-list"></i></span>Danh sách yêu cầu</div></div>
                    <div class="panel-body" style="padding: 0;">
                        <table>
                            <thead><tr><th>Học sinh</th><th>Ngày</th><th>Lý do</th><th>Trạng thái</th></tr></thead>
                            <tbody>
                                <c:forEach var="a" items="${absences}">
                                    <tr>
                                        <td><strong>${a.studentName}</strong></td>
                                        <td>${a.date}</td>
                                        <td>${a.reason}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${a.status == 'pending'}"><span class="badge badge-warning">Chờ duyệt</span></c:when>
                                                <c:when test="${a.status == 'approved'}"><span class="badge badge-success">Đồng ý</span></c:when>
                                                <c:otherwise><span class="badge badge-danger">Từ chối</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty absences}"><tr><td colspan="4" style="text-align: center; padding: 32px; color: #94a3b8;">Chưa có yêu cầu nào.</td></tr></c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>
