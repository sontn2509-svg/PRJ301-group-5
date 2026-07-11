<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác nhận nghỉ ăn - KindergartenKitchen</title>
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
                        <div class="page-header-icon"><i class="fas fa-user-slash"></i></div>
                        <div><h1>Xác nhận nghỉ ăn</h1><p>Danh sách phụ huynh báo nghỉ, đang chờ giáo viên xác nhận</p></div>
                    </div>
                </div>

                <c:if test="${not empty message}">
                    <div class="alert-card success"><i class="fas fa-check-circle alert-icon"></i><span>${message}</span></div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert-card danger"><i class="fas fa-exclamation-circle alert-icon"></i><span>${error}</span></div>
                </c:if>

                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title"><span class="icon"><i class="fas fa-list"></i></span>Yêu cầu chờ xác nhận</div>
                        <span style="color:#64748b;">Tổng: <strong style="color:#f97316;">${fn:length(pendingList)}</strong></span>
                    </div>
                    <div class="panel-body" style="padding: 0;">
                        <table>
                            <thead>
                                <tr><th>Học sinh</th><th>Ngày nghỉ</th><th>Người báo</th><th>Ghi chú</th><th>Tính tiền ăn</th><th style="width:120px;">Thao tác</th></tr>
                            </thead>
                            <tbody>
                                <c:forEach var="a" items="${pendingList}">
                                    <tr>
                                        <td>
                                            <div class="student-row">
                                                <div class="student-avatar">${fn:substring(a.studentName,0,1)}</div>
                                                <span class="student-name">${a.studentName}</span>
                                            </div>
                                        </td>
                                        <td>${a.attendanceDate}</td>
                                        <td style="color:#64748b; font-size:13px;">${a.reportedByName}<br>${a.reportedTime}</td>
                                        <td>${not empty a.note ? a.note : '—'}</td>
                                        <td>${a.chargedText}</td>
                                        <td>
                                            <form method="post" action="${pageContext.request.contextPath}/teacher/attendance">
                                                <input type="hidden" name="action" value="confirm">
                                                <input type="hidden" name="attendanceID" value="${a.attendanceID}">
                                                <input type="hidden" name="classID" value="0">
                                                <input type="hidden" name="attendanceDate" value="${a.attendanceDate}">
                                                <input type="hidden" name="returnTo" value="absences">
                                                <button type="submit" class="btn btn-primary btn-sm"><i class="fas fa-check"></i> Xác nhận</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty pendingList}">
                                    <tr><td colspan="6" style="text-align: center; padding: 32px; color: #94a3b8;">Không có yêu cầu nào đang chờ xác nhận.</td></tr>
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
