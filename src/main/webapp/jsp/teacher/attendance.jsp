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

                <c:if test="${not empty message}">
                    <div class="alert-card success"><i class="fas fa-check-circle alert-icon"></i><span>${message}</span></div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert-card danger"><i class="fas fa-exclamation-circle alert-icon"></i><span>${error}</span></div>
                </c:if>

                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title"><span class="icon"><i class="fas fa-filter"></i></span>Chọn lớp &amp; ngày</div>
                    </div>
                    <div class="panel-body">
                        <form method="get" action="${pageContext.request.contextPath}/teacher/attendance" style="display:flex; gap:14px; align-items:end; flex-wrap:wrap;">
                            <div class="form-group" style="min-width:220px; margin-bottom:0;">
                                <label class="form-label">Lớp</label>
                                <select name="classID" class="form-control form-select" onchange="this.form.submit()">
                                    <c:forEach var="c" items="${classes}">
                                        <option value="${c.classID}" ${selectedClassID == c.classID ? 'selected' : ''}>${c.className} - ${c.levelName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group" style="min-width:180px; margin-bottom:0;">
                                <label class="form-label">Ngày điểm danh</label>
                                <input type="date" name="attendanceDate" class="form-control" value="${attendanceDate}" onchange="this.form.submit()">
                            </div>
                            <button type="submit" class="btn btn-primary"><i class="fas fa-search"></i> Xem</button>
                        </form>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title"><span class="icon"><i class="fas fa-calendar"></i></span>Ngày: ${attendanceDate}</div>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>Học sinh</th>
                                <th>Trạng thái</th>
                                <th>Người báo / thời gian</th>
                                <th>Tính tiền ăn</th>
                                <th>Xác nhận nghỉ</th>
                                <th style="min-width:220px;">Cập nhật điểm danh</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="a" items="${attendanceList}">
                                <tr>
                                    <td>
                                        <div class="student-row">
                                            <div class="student-avatar">${fn:substring(a.studentName,0,1)}</div>
                                            <span class="student-name">${a.studentName}</span>
                                        </div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${empty a.status}"><span class="badge">Chưa điểm danh</span></c:when>
                                            <c:when test="${a.status == 'Present'}"><span class="badge badge-success"><i class="fas fa-check"></i> Có mặt</span></c:when>
                                            <c:otherwise><span class="badge badge-danger"><i class="fas fa-times"></i> Vắng</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="color:#64748b; font-size:13px;">
                                        <c:if test="${not empty a.reportedByName}">${a.reportedByName}<br>${a.reportedTime}</c:if>
                                        <c:if test="${empty a.reportedByName}">—</c:if>
                                    </td>
                                    <td>
                                        <c:if test="${a.status == 'Absent'}">${a.chargedText}</c:if>
                                        <c:if test="${a.status != 'Absent'}">—</c:if>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${a.attendanceID > 0 && a.notificationStatus == 'Pending'}">
                                                <form method="post" action="${pageContext.request.contextPath}/teacher/attendance">
                                                    <input type="hidden" name="action" value="confirm">
                                                    <input type="hidden" name="attendanceID" value="${a.attendanceID}">
                                                    <input type="hidden" name="classID" value="${selectedClassID}">
                                                    <input type="hidden" name="attendanceDate" value="${attendanceDate}">
                                                    <button type="submit" class="btn btn-outline btn-sm"><i class="fas fa-check"></i> Xác nhận</button>
                                                </form>
                                            </c:when>
                                            <c:when test="${a.notificationStatus == 'Confirmed'}">
                                                <span class="badge badge-success"><i class="fas fa-check-double"></i> Đã xác nhận</span>
                                            </c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <form method="post" action="${pageContext.request.contextPath}/teacher/attendance" style="display:flex; gap:6px; align-items:center;">
                                            <input type="hidden" name="action" value="mark">
                                            <input type="hidden" name="studentID" value="${a.studentID}">
                                            <input type="hidden" name="classID" value="${selectedClassID}">
                                            <input type="hidden" name="attendanceDate" value="${attendanceDate}">
                                            <select name="status" class="form-control form-select" style="padding:6px 10px; font-size:13px;">
                                                <option value="Present" ${a.status == 'Present' ? 'selected' : ''}>Có mặt</option>
                                                <option value="Absent" ${a.status == 'Absent' ? 'selected' : ''}>Vắng</option>
                                            </select>
                                            <input type="text" name="note" class="form-control" style="padding:6px 10px; font-size:13px;" placeholder="Ghi chú" value="${a.note}">
                                            <button type="submit" class="btn btn-primary btn-sm"><i class="fas fa-save"></i></button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty attendanceList}">
                                <tr><td colspan="6" style="text-align: center; padding: 32px; color: #94a3b8;">Chưa có học sinh trong lớp này.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>
    </div>
</body>
</html>
