<%-- 
    Document   : parent-absence
    Created on : 15 thg 6, 2026, 17:29:31
    Author     : Vuong Nguyen
--%>

<%-- parent-absence.jsp – Phụ huynh báo nghỉ (Member 3) --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.mycompany.kindergartenkitchen.model.Student"%>
<%@page import="com.mycompany.kindergartenkitchen.model.Attendance"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Báo nghỉ – KindergartenKitchen</title>
        <link rel="stylesheet"
              href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body class="bg-light">
        <div class="container py-4">

            <h3 class="mb-4">📢 Phụ huynh báo nghỉ cho con</h3>

            <%
                String message = (String) request.getAttribute("message");
                String error   = (String) request.getAttribute("error");
                List<Student>   children         = (List<Student>)   request.getAttribute("children");
                List<Attendance> attendanceHistory = (List<Attendance>) request.getAttribute("attendanceHistory");
            %>

            <% if (message != null) { %><div class="alert alert-success"><%= message %></div><% } %>
            <% if (error   != null) { %><div class="alert alert-danger"><%= error   %></div><% } %>

            <%-- Form báo nghỉ --%>
            <div class="card shadow-sm mb-4">
                <div class="card-header fw-semibold">Gửi thông báo nghỉ</div>
                <div class="card-body">
                    <form action="<%= request.getContextPath() %>/parent/absence" method="post">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Chọn con <span class="text-danger">*</span></label>
                            <select name="studentID" class="form-select" required>
                                <option value="">-- Chọn học sinh --</option>
                                <% if (children != null) {
                               for (Student s : children) { %>
                                <option value="<%= s.getStudentID() %>">
                                    <%= s.getStudentName() %> – <%= s.getClassName() %>
                                </option>
                                <%     }
                           } %>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Ngày nghỉ <span class="text-danger">*</span></label>
                            <input type="date" name="attendanceDate" class="form-control"
                                   required min="<%= java.time.LocalDate.now() %>">
                            <div class="form-text text-muted">
                                Báo trước 7:00 sáng ngày nghỉ để không tính tiền ăn.
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Lý do nghỉ <span class="text-danger">*</span></label>
                            <textarea name="note" class="form-control" rows="3" required
                                      maxlength="255" placeholder="Ví dụ: Bé bị sốt, xin nghỉ 1 ngày."></textarea>
                        </div>

                        <button type="submit" class="btn btn-primary">Gửi báo nghỉ</button>
                    </form>
                </div>
            </div>

            <%-- Lịch sử báo nghỉ --%>
            <div class="card shadow-sm">
                <div class="card-header fw-semibold">Lịch sử báo nghỉ</div>
                <div class="card-body p-0">
                    <table class="table table-hover mb-0 align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Học sinh</th>
                                <th>Lớp</th>
                                <th>Ngày nghỉ</th>
                                <th>Thời gian báo</th>
                                <th>Tính tiền ăn</th>
                                <th>Người xác nhận</th>
                                <th>Trạng thái</th>
                                <th>Lý do</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (attendanceHistory != null && !attendanceHistory.isEmpty()) {
                                    int idx = 1;
                                    for (Attendance a : attendanceHistory) {
                                        String ns = a.getNotificationStatus() != null ? a.getNotificationStatus() : "";
                            %>
                            <tr>
                                <td><%= idx++ %></td>
                                <td><strong><%= a.getStudentName() %></strong></td>
                                <td><%= a.getClassName() %></td>
                                <td><%= a.getAttendanceDate() %></td>
                                <td><small><%= a.getReportedTime() != null ? a.getReportedTime() : "—" %></small></td>
                                <td>
                                    <% if (!a.isCharged()) { %>
                                    <span class="badge bg-success">Không tính</span>
                                    <% } else { %>
                                    <span class="badge bg-secondary">Có tính</span>
                                    <% } %>
                                </td>
                                <td><small><%= (a.getConfirmedByName() != null && !a.getConfirmedByName().isEmpty())
                                    ? a.getConfirmedByName() : "—" %></small></td>
                                <td>
                                    <% if ("Confirmed".equalsIgnoreCase(ns)) { %>
                                    <span class="badge bg-success">Đã xác nhận</span>
                                    <% } else if ("Pending".equalsIgnoreCase(ns)) { %>
                                    <span class="badge bg-warning text-dark">Chờ xác nhận</span>
                                    <% } else { %>
                                    <span class="badge bg-secondary"><%= ns %></span>
                                    <% } %>
                                </td>
                                <td><small><%= (a.getNote() != null && !a.getNote().isEmpty()) ? a.getNote() : "—" %></small></td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="9" class="text-center text-muted py-3">Chưa có lịch sử báo nghỉ.</td>
                            </tr>
                            <%  } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="mt-3">
                <a href="<%= request.getContextPath() %>/index.jsp" class="text-secondary">← Về trang chủ</a>
            </div>
        </div>
    </body>
</html>
