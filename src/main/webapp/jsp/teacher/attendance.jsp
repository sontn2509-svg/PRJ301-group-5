<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Điểm danh - KindergartenKitchen</title>
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
                        <div class="page-header-icon"><i class="fas fa-calendar-check"></i></div>
                        <div><h1>Điểm danh</h1><p>Cập nhật điểm danh hàng ngày cho học sinh</p></div>
                    </div>
                </div>
                <div class="panel">
                    <div class="panel-header"><div class="panel-title"><span class="icon"><i class="fas fa-calendar"></i></span>Ngày: ${date}</div></div>
                    <div class="panel-body" style="padding: 0;">
                        <table>
                            <thead><tr><th>Họ tên</th><th>Trạng thái</th><th>Nghỉ ăn</th></tr></thead>
                            <tbody>
                                <c:forEach var="s" items="${students}">
                                    <tr>
                                        <td><div style="display: flex; align-items: center; gap: 10px;"><div class="avatar-sm">${s.fullName.substring(0,1)}</div><strong>${s.fullName}</strong></div></td>
                                        <td><span class="badge ${s.present ? 'badge-success' : 'badge-danger'}">${s.present ? 'Có mặt' : 'Vắng mặt'}</span></td>
                                        <td><span class="badge ${s.absentMeal ? 'badge-warning' : 'badge-success'}">${s.absentMeal ? 'Nghỉ ăn' : 'Ăn bếp'}</span></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty students}"><tr><td colspan="3" style="text-align: center; padding: 32px; color: #94a3b8;">Chưa có học sinh.</td></tr></c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>
