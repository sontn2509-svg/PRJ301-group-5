<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Con em - KindergartenKitchen</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="app-container">
        <jsp:include page="/jsp/layout/sidebar-parent.jsp"/>
        <div class="main-content">
            <jsp:include page="/jsp/layout/header.jsp"/>
            <main class="page-content">
                <div class="page-header-card">
                    <div class="page-header-content">
                        <div class="page-header-icon"><i class="fas fa-child"></i></div>
                        <div><h1>Con em</h1><p>Xem thông tin và tình trạng ăn uống của con</p></div>
                    </div>
                </div>
                <div class="panel">
                    <div class="panel-header"><div class="panel-title"><span class="icon"><i class="fas fa-list"></i></span>Danh sách con</div></div>
                    <div class="panel-body" style="padding: 0;">
                        <table>
                            <thead><tr><th>Họ tên</th><th>Lớp</th><th>Ngày sinh</th><th>Trạng thái hôm nay</th></tr></thead>
                            <tbody>
                                <c:forEach var="c" items="${children}">
                                    <tr>
                                        <td><div style="display: flex; align-items: center; gap: 10px;"><div class="avatar-sm">${c.fullName.substring(0,1)}</div><strong>${c.fullName}</strong></div></td>
                                        <td>${c.className}</td>
                                        <td>${c.dateOfBirth}</td>
                                        <td><span class="badge ${c.todayStatus == 'present' ? 'badge-success' : c.todayStatus == 'absent_meal' ? 'badge-warning' : 'badge-danger'}">${c.todayStatus == 'present' ? 'Ăn bếp' : c.todayStatus == 'absent_meal' ? 'Nghỉ ăn' : 'Vắng mặt'}</span></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty children}"><tr><td colspan="4" style="text-align: center; padding: 32px; color: #94a3b8;">Chưa có thông tin con em.</td></tr></c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>
