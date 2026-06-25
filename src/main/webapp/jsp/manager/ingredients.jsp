<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nguyên liệu - KindergartenKitchen</title>
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
                        <div class="page-header-icon"><i class="fas fa-carrot"></i></div>
                        <div><h1>Nguyên liệu</h1><p>Quản lý nguyên liệu cần thiết cho bếp</p></div>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title"><span class="icon"><i class="fas fa-list"></i></span>Danh sách nguyên liệu</div>
                        <span style="color: #64748b;">Tổng: <strong style="color: #f97316;">${ingredients.size()}</strong> nguyên liệu</span>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>Nguyên liệu</th>
                                <th>Đơn vị</th>
                                <th>Số lượng</th>
                                <th>Tối thiểu</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="i" items="${ingredients}">
                                <tr>
                                    <td>
                                        <div class="ingredient-row">
                                            <div class="ingredient-icon"><i class="fas fa-carrot"></i></div>
                                            <span class="ingredient-name">${i.name}</span>
                                        </div>
                                    </td>
                                    <td>${i.unit}</td>
                                    <td><span class="ingredient-qty">${i.quantity}</span></td>
                                    <td>${i.minThreshold}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${i.quantity <= i.minThreshold}">
                                                <span class="badge badge-danger"><i class="fas fa-exclamation-triangle"></i> Sắp hết</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-success"><i class="fas fa-check-circle"></i> Còn đủ</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty ingredients}">
                                <tr><td colspan="5" style="text-align: center; padding: 32px; color: #94a3b8;">Chưa có nguyên liệu nào.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>
    </div>
</body>
</html>