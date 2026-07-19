<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử bếp - KindergartenKitchen</title>
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
                        <div class="page-header-icon"><i class="fas fa-history"></i></div>
                        <div>
                            <h1>Lịch sử bếp</h1>
                            <p>Xem lại các bữa ăn đã nấu và số lượng suất đã phục vụ</p>
                        </div>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title"><span class="icon"><i class="fas fa-clock-rotate-left"></i></span>Danh sách bữa ăn</div>
                    </div>
                    <div class="panel-body" style="padding: 0;">
                        <table>
                            <thead>
                                <tr>
                                    <th>Ngày</th>
                                    <th>Tổng suất</th>
                                    <th>Ghi chú</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="meal" items="${meals}">
                                    <tr>
                                        <td><i class="far fa-calendar" style="margin-right: 8px; color: #94a3b8;"></i>${meal.date}</td>
                                        <td><strong style="color: #f97316;">${meal.totalCount}</strong> suất</td>
                                        <td>${meal.note}</td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty meals}">
                                    <tr><td colspan="3" style="text-align: center; padding: 32px; color: #94a3b8;">Chưa có bữa ăn nào.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>
