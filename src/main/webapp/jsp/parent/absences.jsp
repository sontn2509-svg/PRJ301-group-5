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
                        <div class="page-header-icon"><i class="fas fa-user-slash"></i></div>
                        <div><h1>Xin nghỉ học</h1><p>Gửi yêu cầu báo nghỉ cho con</p></div>
                    </div>
                </div>
                <c:if test="${not empty flash}">
                    <div class="alert-card success"><span class="alert-icon"><i class="fas fa-check-circle"></i></span><span>${flash}</span></div>
                </c:if>
                <div class="panel">
                    <div class="panel-header"><div class="panel-title"><span class="icon"><i class="fas fa-paper-plane"></i></span>Gửi yêu cầu mới</div></div>
                    <div class="panel-body">
                        <form method="post" action="${pageContext.request.contextPath}/parent/absences">
                            <div class="grid-2">
                                <div class="form-group">
                                    <label class="form-label"><i class="fas fa-child" style="color: #f97316; margin-right: 6px;"></i>Chọn con</label>
                                    <select name="studentId" class="form-control form-select" required>
                                        <option value="">-- Chọn con --</option>
                                        <c:forEach var="c" items="${children}">
                                            <option value="${c.studentId}">${c.fullName} - ${c.className}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label class="form-label"><i class="fas fa-calendar" style="color: #f97316; margin-right: 6px;"></i>Ngày nghỉ</label>
                                    <input type="date" name="date" class="form-control" required>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-label"><i class="fas fa-comment" style="color: #f97316; margin-right: 6px;"></i>Lý do</label>
                                <textarea name="reason" class="form-control" rows="3" placeholder="Nhập lý do xin nghỉ ăn..."></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary"><i class="fas fa-paper-plane"></i> Gửi yêu cầu</button>
                        </form>
                    </div>
                </div>
                <div class="panel">
                    <div class="panel-header"><div class="panel-title"><span class="icon"><i class="fas fa-history"></i></span>Lịch sử yêu cầu</div></div>
                    <div class="panel-body" style="padding: 0;">
                        <table>
                            <thead><tr><th>Con</th><th>Ngày</th><th>Ghi chú</th><th>Tính tiền ăn</th><th>Trạng thái</th></tr></thead>
                            <tbody>
                                <c:forEach var="a" items="${absences}">
                                    <tr>
                                        <td><strong>${a.studentName}</strong></td>
                                        <td>${a.attendanceDate}</td>
                                        <td>${not empty a.note ? a.note : '—'}</td>
                                        <td>${a.chargedText}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${a.notificationStatus == 'Pending'}"><span class="badge badge-warning">Chờ GV xác nhận</span></c:when>
                                                <c:when test="${a.notificationStatus == 'Confirmed'}"><span class="badge badge-success">Đã xác nhận</span></c:when>
                                                <c:otherwise><span class="badge">${a.notificationStatus}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty absences}"><tr><td colspan="5" style="text-align: center; padding: 32px; color: #94a3b8;">Chưa có yêu cầu nào.</td></tr></c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>
