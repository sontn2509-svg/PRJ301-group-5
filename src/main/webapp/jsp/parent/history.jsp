<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử ăn - KindergartenKitchen</title>
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
                        <div class="page-header-icon"><i class="fas fa-history"></i></div>
                        <div><h1>Lịch sử ăn</h1><p>Xem lịch sử ăn uống của con</p></div>
                    </div>
                </div>
                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title"><span class="icon"><i class="fas fa-clock-rotate-left"></i></span>Danh sách bữa ăn</div>
                        <form method="get" action="${pageContext.request.contextPath}/parent/history" style="display:flex; gap:8px; align-items:center;">
                            <input type="month" name="month" class="form-control" value="${selectedMonth}" style="padding:8px 12px;" onchange="this.form.submit()">
                        </form>
                    </div>
                    <div class="panel-body" style="padding: 0;">
                        <table>
                            <thead><tr><th>Ngày</th><th>Con</th><th>Lớp</th><th>Trạng thái</th></tr></thead>
                            <tbody>
                                <c:forEach var="h" items="${history}">
                                    <tr>
                                        <td><i class="far fa-calendar" style="margin-right: 8px; color: #94a3b8;"></i>${h.date}</td>
                                        <td><strong>${h.studentName}</strong></td>
                                        <td>${h.className}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${h.status == 'present'}"><span class="badge badge-success"><i class="fas fa-check"></i> Ăn bếp</span></c:when>
                                                <c:when test="${h.status == 'absent_meal'}"><span class="badge badge-warning"><i class="fas fa-utensils-slash"></i> Nghỉ ăn</span></c:when>
                                                <c:otherwise><span class="badge badge-danger"><i class="fas fa-times"></i> Vắng mặt</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty history}"><tr><td colspan="4" style="text-align: center; padding: 32px; color: #94a3b8;">Chưa có lịch sử ăn uống.</td></tr></c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>
