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
        <jsp:include page="/jsp/layout/sidebar-manager.jsp"/>
        <div class="main-content">
            <jsp:include page="/jsp/layout/header.jsp"/>
            <main class="page-content">
                <div class="page-header-card">
                    <div class="page-header-content">
                        <div class="page-header-icon"><i class="fas fa-calendar-check"></i></div>
                        <div><h1>Điểm danh</h1><p>Theo dõi và cập nhật điểm danh hàng ngày</p></div>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title"><span class="icon"><i class="fas fa-calendar"></i></span>Ngày: ${date}</div>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>Lớp</th>
                                <th>Tổng</th>
                                <th>Có mặt</th>
                                <th>Nghỉ</th>
                                <th>Nghỉ ăn</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="a" items="${attendance}">
                                <tr>
                                    <td>
                                        <div class="class-row">
                                            <div class="class-icon"><i class="fas fa-chalkboard"></i></div>
                                            <span class="class-name">${a.className}</span>
                                        </div>
                                    </td>
                                    <td><strong>${a.total}</strong></td>
                                    <td><span class="badge badge-success"><i class="fas fa-check"></i> ${a.present}</span></td>
                                    <td><span class="badge badge-danger"><i class="fas fa-times"></i> ${a.absent}</span></td>
                                    <td><span class="badge badge-warning"><i class="fas fa-utensils-slash"></i> ${a.absentMeal}</span></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty attendance}">
                                <tr><td colspan="5" style="text-align: center; padding: 32px; color: #94a3b8;">Chưa có dữ liệu điểm danh.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>
    </div>
</body>
</html>