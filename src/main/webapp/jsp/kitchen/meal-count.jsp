<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đếm suất ăn - KindergartenKitchen</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="app-container">
        <jsp:include page="/jsp/layout/sidebar-kitchen.jsp"/>
        <div class="main-content">
            <jsp:include page="/jsp/layout/header.jsp"/>
            <main class="page-content">
                <div class="page-header-card">
                    <div class="page-header-content">
                        <div class="page-header-icon"><i class="fas fa-calculator"></i></div>
                        <div>
                            <h1>Đếm suất ăn</h1>
                            <p>Cập nhật số lượng suất ăn hàng ngày</p>
                        </div>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title"><span class="icon"><i class="fas fa-calendar"></i></span>Ngày: ${date}</div>
                    </div>
                    <div class="panel-body">
                        <table>
                            <thead>
                                <tr>
                                    <th>Lớp</th>
                                    <th>Tổng học sinh</th>
                                    <th>Có mặt</th>
                                    <th>Nghỉ ăn</th>
                                    <th>Suất ăn</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${mealCounts}">
                                    <tr>
                                        <td><strong>${item.className}</strong></td>
                                        <td>${item.totalStudents}</td>
                                        <td><span class="badge badge-success">${item.present}</span></td>
                                        <td><span class="badge badge-danger">${item.absent}</span></td>
                                        <td><strong style="color: #f97316;">${item.mealCount}</strong></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty mealCounts}">
                                    <tr><td colspan="5" style="text-align: center; padding: 32px; color: #94a3b8;">Chưa có dữ liệu điểm danh cho ngày này.</td></tr>
                                </c:if>
                            </tbody>
                            <tfoot>
                                <tr style="background: #f5f7fa; font-weight: 700;">
                                    <td>Tổng cộng</td>
                                    <td>${totalStudents}</td>
                                    <td>${totalPresent}</td>
                                    <td>${totalAbsent}</td>
                                    <td><strong style="color: #f97316; font-size: 18px;">${totalMeals}</strong></td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>
