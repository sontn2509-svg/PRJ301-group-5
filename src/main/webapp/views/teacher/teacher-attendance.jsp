<%-- 
    Document   : teacher-attendance
    Created on : 15 thg 6, 2026, 17:34:25
    Author     : Vuong Nguyen
--%>

<%-- teacher-attendance.jsp – Giáo viên điểm danh (Member 3) --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.Date"%>
<%@page import="com.mycompany.kindergartenkitchen.model.ClassInfo"%>
<%@page import="com.mycompany.kindergartenkitchen.model.Attendance"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Điểm danh – KindergartenKitchen</title>
        <link rel="stylesheet"
              href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <style>
            .badge-present  {
                background-color: #198754;
            }
            .badge-absent   {
                background-color: #dc3545;
            }
            .badge-pending  {
                background-color: #ffc107;
                color: #000;
            }
            .badge-none     {
                background-color: #6c757d;
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="container py-4">

            <h3 class="mb-4">📋 Giáo viên điểm danh / xác nhận nghỉ</h3>

            <%
                String message = (String) request.getAttribute("message");
                String error   = (String) request.getAttribute("error");
                List<ClassInfo>  classes        = (List<ClassInfo>)  request.getAttribute("classes");
                List<Attendance> attendanceList = (List<Attendance>) request.getAttribute("attendanceList");
                Integer selectedClassIDObj = (Integer) request.getAttribute("selectedClassID");
                int selectedClassID = selectedClassIDObj != null ? selectedClassIDObj : 0;
                Date attendanceDate = (Date) request.getAttribute("attendanceDate");
            %>

            <% if (message != null) { %><div class="alert alert-success"><%= message %></div><% } %>
            <% if (error   != null) { %><div class="alert alert-danger"><%= error   %></div><% } %>

            <%-- Form chọn lớp và ngày --%>
            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <form action="<%= request.getContextPath() %>/teacher/attendance" method="get"
                          class="row g-3 align-items-end">
                        <div class="col-md-5">
                            <label class="form-label fw-semibold">Lớp</label>
                            <select name="classID" class="form-select" required>
                                <% if (classes != null) {
                               for (ClassInfo c : classes) { %>
                                <option value="<%= c.getClassID() %>"
                                        <%= selectedClassID == c.getClassID() ? "selected" : "" %>>
                                    <%= c.getClassName() %> – <%= c.getLevelName() %>
                                </option>
                                <%     }
                           } %>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Ngày điểm danh</label>
                            <input type="date" name="attendanceDate" class="form-control" required
                                   value="<%= attendanceDate != null ? attendanceDate : "" %>">
                        </div>
                        <div class="col-md-3">
                            <button type="submit" class="btn btn-primary w-100">Xem danh sách</button>
                        </div>
                    </form>
                </div>
            </div>

            <%-- Bảng điểm danh --%>
            <div class="card shadow-sm">
                <div class="card-header fw-semibold">Danh sách học sinh</div>
                <div class="card-body p-0">
                    <table class="table table-hover mb-0 align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Mã HS</th>
                                <th>Tên học sinh</th>
                                <th>Trạng thái</th>
                                <th>Người báo</th>
                                <th>Thời gian báo</th>
                                <th>Tính tiền ăn</th>
                                <th>Xác nhận nghỉ</th>
                                <th>Ghi chú</th>
                                <th>Điểm danh</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (attendanceList != null && !attendanceList.isEmpty()) {
                                    int idx = 1;
                                    for (Attendance a : attendanceList) {
                                        String cur = a.getStatus() != null ? a.getStatus().trim() : "";
                            %>
                            <tr>
                                <td><%= idx++ %></td>
                                <td><code><%= a.getStudentCode() %></code></td>
                                <td><strong><%= a.getStudentName() %></strong></td>

                                <%-- Trạng thái badge --%>
                                <td>
                                    <% if (cur.isEmpty()) { %>
                                    <span class="badge badge-none">Chưa điểm danh</span>
                                    <% } else if ("Present".equalsIgnoreCase(cur)) { %>
                                    <span class="badge badge-present">Có mặt</span>
                                    <% } else { %>
                                    <span class="badge badge-absent">Vắng</span>
                                    <% } %>
                                </td>

                                <td><small><%= a.getReportedByName() != null ? a.getReportedByName() : "—" %></small></td>
                                <td><small><%= a.getReportedTime() != null ? a.getReportedTime() : "—" %></small></td>

                                <td>
                                    <% if ("Absent".equalsIgnoreCase(cur)) { %>
                                    <%= a.getChargedText() %>
                                    <% } else { %>
                                    —
                                    <% } %>
                                </td>

                                <%-- Xác nhận nghỉ --%>
                                <td>
                                    <% if (a.getAttendanceID() > 0 && "Pending".equalsIgnoreCase(a.getNotificationStatus())) { %>
                                    <form action="<%= request.getContextPath() %>/teacher/attendance" method="post">
                                        <input type="hidden" name="action"         value="confirm">
                                        <input type="hidden" name="attendanceID"   value="<%= a.getAttendanceID() %>">
                                        <input type="hidden" name="classID"        value="<%= selectedClassID %>">
                                        <input type="hidden" name="attendanceDate" value="<%= attendanceDate %>">
                                        <button type="submit" class="btn btn-sm btn-warning">Xác nhận</button>
                                    </form>
                                    <% } else if ("Confirmed".equalsIgnoreCase(a.getNotificationStatus())) { %>
                                    <span class="text-success">✔ Đã xác nhận</span>
                                    <% } else { %>
                                    —
                                    <% } %>
                                </td>

                                <td><small><%= (a.getNote() != null && !a.getNote().isEmpty()) ? a.getNote() : "—" %></small></td>

                                <%-- Form điểm danh --%>
                                <td>
                                    <form action="<%= request.getContextPath() %>/teacher/attendance"
                                          method="post" class="d-flex flex-column gap-1" style="min-width:180px">
                                        <input type="hidden" name="action"         value="mark">
                                        <input type="hidden" name="studentID"      value="<%= a.getStudentID() %>">
                                        <input type="hidden" name="classID"        value="<%= selectedClassID %>">
                                        <input type="hidden" name="attendanceDate" value="<%= attendanceDate %>">

                                        <select name="status" class="form-select form-select-sm" required>
                                            <option value="Present" <%= "Present".equalsIgnoreCase(cur) ? "selected" : "" %>>Có mặt</option>
                                            <option value="Absent"  <%= "Absent".equalsIgnoreCase(cur)  ? "selected" : "" %>>Vắng</option>
                                        </select>
                                        <input type="text" name="note" class="form-control form-control-sm"
                                               placeholder="Ghi chú (tùy chọn)">
                                        <button type="submit" class="btn btn-sm btn-outline-primary">Lưu</button>
                                    </form>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="10" class="text-center text-muted py-3">
                                    Không có học sinh nào trong lớp này.
                                </td>
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
