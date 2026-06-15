<%-- 
    Document   : parent-absence
    Created on : 15 thg 6, 2026, 17:29:31
    Author     : Vuong Nguyen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.mycompany.kindergartenkitchen.model.Student"%>
<%@page import="com.mycompany.kindergartenkitchen.model.Attendance"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Phụ huynh báo nghỉ</title>
    </head>
    <body>
        <h2>Phụ huynh báo nghỉ cho con</h2>

        <%
            String message = (String) request.getAttribute("message");
            String error = (String) request.getAttribute("error");

            List<Student> children = (List<Student>) request.getAttribute("children");
            List<Attendance> attendanceHistory = (List<Attendance>) request.getAttribute("attendanceHistory");
        %>

        <% if (message != null) { %>
        <p style="color: green;"><%= message %></p>
        <% } %>

        <% if (error != null) { %>
        <p style="color: red;"><%= error %></p>
        <% } %>

        <h3>Gửi báo nghỉ</h3>

        <form action="<%= request.getContextPath() %>/parent/absence" method="post">
            <table>
                <tr>
                    <td>Chọn con:</td>
                    <td>
                        <select name="studentID" required>
                            <option value="">-- Chọn học sinh --</option>
                            <%
                                if (children != null) {
                                    for (Student s : children) {
                            %>
                            <option value="<%= s.getStudentID() %>">
                                <%= s.getStudentName() %> - <%= s.getClassName() %>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>Ngày nghỉ:</td>
                    <td>
                        <input type="date" name="attendanceDate" required>
                    </td>
                </tr>

                <tr>
                    <td>Lý do nghỉ:</td>
                    <td>
                        <textarea name="note" rows="4" cols="50" required></textarea>
                    </td>
                </tr>

                <tr>
                    <td></td>
                    <td>
                        <button type="submit">Gửi báo nghỉ</button>
                    </td>
                </tr>
            </table>
        </form>

        <hr>

        <h3>Lịch sử báo nghỉ</h3>

        <table border="1" cellpadding="8" cellspacing="0">
            <tr>
                <th>ID</th>
                <th>Học sinh</th>
                <th>Lớp</th>
                <th>Ngày nghỉ</th>
                <th>Trạng thái</th>
                <th>Thời gian báo</th>
                <th>Tính tiền ăn</th>
                <th>Người xác nhận</th>
                <th>Thời gian xác nhận</th>
                <th>Trạng thái xác nhận</th>
                <th>Lý do</th>
            </tr>

            <%
                if (attendanceHistory != null && !attendanceHistory.isEmpty()) {
                    for (Attendance a : attendanceHistory) {
            %>
            <tr>
                <td><%= a.getAttendanceID() %></td>
                <td><%= a.getStudentName() %></td>
                <td><%= a.getClassName() %></td>
                <td><%= a.getAttendanceDate() %></td>
                <td><%= a.getStatusText() %></td>
                <td><%= a.getReportedTime() != null ? a.getReportedTime() : "" %></td>
                <td><%= a.getChargedText() %></td>
                <td><%= a.getConfirmedByName() != null ? a.getConfirmedByName() : "" %></td>
                <td><%= a.getConfirmedTime() != null ? a.getConfirmedTime() : "" %></td>
                <td><%= a.getNotificationStatus() != null ? a.getNotificationStatus() : "" %></td>
                <td><%= a.getNote() != null ? a.getNote() : "" %></td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="11">Chưa có lịch sử báo nghỉ.</td>
            </tr>
            <%
                }
            %>
        </table>

        <br>
        <a href="<%= request.getContextPath() %>/index.jsp">Về trang chủ</a>
    </body>
</html>
