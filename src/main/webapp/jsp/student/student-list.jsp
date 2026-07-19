<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Học sinh - KindergartenKitchen</title>
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
                            <div class="page-header-icon"><i class="fas fa-user-graduate"></i></div>
                            <div><h1>Quản lý học sinh</h1><p>Thêm, sửa, xóa thông tin học sinh</p></div>
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
                            <div class="panel-title"><span class="icon"><i class="fas fa-list"></i></span>Danh sách học sinh</div>
                            <div style="display:flex; align-items:center; gap:14px;">
                                <span style="color: #64748b;">Tổng: <strong style="color: #f97316;">${fn:length(studentList)}</strong> học sinh</span>
                                <a href="${pageContext.request.contextPath}/manager/students?action=add" class="btn btn-primary btn-sm"><i class="fas fa-plus"></i> Thêm học sinh</a>
                            </div>
                        </div>
                        <div class="panel-body" style="padding-bottom:0;">
                            <form method="get" action="${pageContext.request.contextPath}/manager/students" style="display:flex; gap:10px; align-items:end; max-width:320px;">
                                <div class="form-group" style="flex:1; margin-bottom:16px;">
                                    <label class="form-label">Lọc theo lớp</label>
                                    <select name="classID" class="form-control form-select" onchange="this.form.submit()">
                                        <option value="">-- Tất cả lớp --</option>
                                        <c:forEach var="cls" items="${classList}">
                                            <option value="${cls.classID}" ${param.classID == cls.classID ? 'selected' : ''}>${cls.className}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </form>
                        </div>
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Họ tên</th>
                                    <th>Lớp</th>
                                    <th>Ngày sinh</th>
                                    <th>Phụ huynh</th>
                                    <th style="width:140px;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="s" items="${studentList}">
                                    <tr>
                                        <td><strong style="color: #f97316;">#${s.studentID}</strong></td>
                                        <td>
                                            <div class="student-row">
                                                <div class="student-avatar">${fn:substring(s.studentName,0,1)}</div>
                                                <span class="student-name">${s.studentName}</span>
                                            </div>
                                        </td>
                                        <td>${s.className}</td>
                                        <td><fmt:formatDate value="${s.dateOfBirth}" pattern="dd/MM/yyyy"/></td>
                                        <td>${s.parentName}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/manager/students?action=edit&studentID=${s.studentID}" class="btn btn-ghost btn-sm" title="Sửa"><i class="fas fa-pen"></i></a>
                                            <form method="post" action="${pageContext.request.contextPath}/manager/students" style="display:inline;">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="studentID" value="${s.studentID}">
                                                <button type="button" class="btn btn-ghost btn-sm" title="Xoá"
                                                        onclick="confirmDelete(this.form, 'Xoá học sinh \'${s.studentName}\'?')">
                                                    <i class="fas fa-trash" style="color:#ef4444;"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty studentList}">
                                    <tr><td colspan="6" style="text-align: center; padding: 32px; color: #94a3b8;">Chưa có học sinh nào.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </main>
            </div>
        </div>
    </body>
</html>
