<%-- 
    Document   : teacher-attendance
    Created on : 15 thg 6, 2026, 17:34:25
    Author     : Vuong Nguyen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.Date"%>
<%@page import="com.mycompany.kindergartenkitchen.model.ClassInfo"%>
<%@page import="com.mycompany.kindergartenkitchen.model.Attendance"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Giáo viên điểm danh</title>
    </head>
    <body>
        <h2>Giáo viên điểm danh / xác nhận nghỉ</h2>

        <%
            String message = (String) request.getAttribute("message");
            String error = (String) request.getAttribute("error");

            List<ClassInfo> classes = (List<ClassInfo>) request.getAttribute("classes");
            List<Attendance> attendanceList = (List<Attendance>) request.getAttribute("attendanceList");

            Integer selectedClassIDObj = (Integer) request.getAttribute("selectedClassID");
            int selectedClassID = selectedClassIDObj != null ? selectedClassIDObj : 0;

            Date attendanceDate = (Date) request.getAttribute("attendanceDate");
        %>

        <% if (message != null) { %>
        <p style="color: green;"><%= message %></p>
        <% } %>

        <% if (error != null) { %>
        <p style="color: red;"><%= error %></p>
        <% } %>

        <h3>Chọn lớp và ngày điểm danh</h3>

        <form action="<%= request.getContextPath() %>/teacher/attendance" method="get">
            <table>
                <tr>
                    <td>Lớp:</td>
                    <td>
                        <select name="classID" required>
                            <%
                                if (classes != null && !classes.isEmpty()) {
                                    for (ClassInfo c : classes) {
                            %>
                            <option value="<%= c.getClassID() %>"
                                    <%= selectedClassID == c.getClassID() ? "selected" : "" %>>
                                <%= c.getClassName() %> - <%= c.getLevelName() %>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>Ngày:</td>
                    <td>
                        <input type="date" name="attendanceDate" required
                               value="<%= attendanceDate != null ? attendanceDate : "" %>">
                    </td>
                </tr>

                <tr>
                    <td></td>
                    <td>
                        <button type="submit">Xem danh sách</button>
                    </td>
                </tr>
            </table>
        </form>

        <hr>

        <h3>Danh sách học sinh</h3>

        <table border="1" cellpadding="8" cellspacing="0">
            <tr>
                <th>ID</th>
                <th>Mã học sinh</th>
                <th>Tên học sinh</th>
                <th>Lớp</th>
                <th>Ngày</th>
                <th>Trạng thái hiện tại</th>
                <th>Người báo nghỉ</th>
                <th>Thời gian báo</th>
                <th>Tính tiền ăn</th>
                <th>Xác nhận</th>
                <th>Ghi chú</th>
                <th>Điểm danh</th>
            </tr>

            <%
                if (attendanceList != null && !attendanceList.isEmpty()) {
                    for (Attendance a : attendanceList) {
                        String currentStatus = a.getStatus() != null ? a.getStatus() : "";
            %>
            <tr>
                <td><%= a.getStudentID() %></td>
                <td><%= a.getStudentCode() %></td>
                <td><%= a.getStudentName() %></td>
                <td><%= a.getClassName() %></td>
                <td><%= a.getAttendanceDate() %></td>

                <td>
                    <% if (currentStatus.trim().isEmpty()) { %>
                    Chưa điểm danh
                    <% } else { %>
                    <%= a.getStatusText() %>
                    <% } %>
                </td>

                <td><%= a.getReportedByName() != null ? a.getReportedByName() : "" %></td>
                <td><%= a.getReportedTime() != null ? a.getReportedTime() : "" %></td>
                <td><%= a.getChargedText() %></td>

                <td>
                    <% if (a.getAttendanceID() > 0 && "Pending".equalsIgnoreCase(a.getNotificationStatus())) { %>
                    <form action="<%= request.getContextPath() %>/teacher/attendance" method="post">
                        <input type="hidden" name="action" value="confirm">
                        <input type="hidden" name="attendanceID" value="<%= a.getAttendanceID() %>">
                        <input type="hidden" name="classID" value="<%= selectedClassID %>">
                        <input type="hidden" name="attendanceDate" value="<%= attendanceDate %>">
                        <button type="submit">Xác nhận nghỉ</button>
                    </form>
                    <% } else if ("Confirmed".equalsIgnoreCase(a.getNotificationStatus())) { %>
                    Đã xác nhận
                    <% } else { %>
                    -
                    <% } %>
                </td>

                <td><%= a.getNote() != null ? a.getNote() : "" %></td>

                <td>
                    <form action="<%= request.getContextPath() %>/teacher/attendance" method="post">
                        <input type="hidden" name="action" value="mark">
                        <input type="hidden" name="studentID" value="<%= a.getStudentID() %>">
                        <input type="hidden" name="classID" value="<%= selectedClassID %>">
                        <input type="hidden" name="attendanceDate" value="<%= attendanceDate %>">

                        <select name="status" required>
                            <option value="Present" <%= "Present".equalsIgnoreCase(currentStatus) ? "selected" : "" %>>
                                Có mặt
                            </option>
                            <option value="Absent" <%= "Absent".equalsIgnoreCase(currentStatus) ? "selected" : "" %>>
                                Vắng
                            </option>
                        </select>

                        <br><br>

                        <input type="text" name="note" placeholder="Ghi chú nếu có">

                        <br><br>

                        <button type="submit">Lưu</button>
                    </form>
                </td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="12">Không có học sinh nào để điểm danh.</td>
            </tr>
            <%
                }
            %>
        </table>

        <br>
        <a href="<%= request.getContextPath() %>/index.jsp">Về trang chủ</a>
    </body>
</html>
