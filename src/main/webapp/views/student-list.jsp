<%-- 
    Document   : student-list
    Created on : 15 thg 6, 2026, 17:18:30
    Author     : Vuong Nguyen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.mycompany.kindergartenkitchen.model.Student"%>
<%@page import="com.mycompany.kindergartenkitchen.model.ClassInfo"%>
<%@page import="com.mycompany.kindergartenkitchen.model.UserInfo"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản lý học sinh</title>
    </head>
    <body>
        <h2>Quản lý học sinh</h2>

        <%
            String message = (String) request.getAttribute("message");
            String error = (String) request.getAttribute("error");

            Student editStudent = (Student) request.getAttribute("editStudent");

            List<Student> students = (List<Student>) request.getAttribute("students");
            List<ClassInfo> classes = (List<ClassInfo>) request.getAttribute("classes");
            List<UserInfo> parents = (List<UserInfo>) request.getAttribute("parents");
        %>

        <% if (message != null) { %>
        <p style="color: green;"><%= message %></p>
        <% } %>

        <% if (error != null) { %>
        <p style="color: red;"><%= error %></p>
        <% } %>

        <h3><%= editStudent == null ? "Thêm học sinh" : "Cập nhật học sinh" %></h3>

        <form action="<%= request.getContextPath() %>/students" method="post">
            <% if (editStudent != null) { %>
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="studentID" value="<%= editStudent.getStudentID() %>">
            <% } else { %>
            <input type="hidden" name="action" value="insert">
            <% } %>

            <table>
                <tr>
                    <td>Mã học sinh:</td>
                    <td>
                        <input type="text" name="studentCode" required
                               value="<%= editStudent != null ? editStudent.getStudentCode() : "" %>">
                    </td>
                </tr>

                <tr>
                    <td>Tên học sinh:</td>
                    <td>
                        <input type="text" name="studentName" required
                               value="<%= editStudent != null ? editStudent.getStudentName() : "" %>">
                    </td>
                </tr>

                <tr>
                    <td>Ngày sinh:</td>
                    <td>
                        <input type="date" name="dateOfBirth" required
                               value="<%= editStudent != null && editStudent.getDateOfBirth() != null ? editStudent.getDateOfBirth() : "" %>">
                    </td>
                </tr>

                <tr>
                    <td>Giới tính:</td>
                    <td>
                        <select name="gender">
                            <option value="1" <%= editStudent != null && editStudent.isGender() ? "selected" : "" %>>Nam</option>
                            <option value="0" <%= editStudent != null && !editStudent.isGender() ? "selected" : "" %>>Nữ</option>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>Lớp:</td>
                    <td>
                        <select name="classID" required>
                            <%
                                if (classes != null) {
                                    for (ClassInfo c : classes) {
                            %>
                            <option value="<%= c.getClassID() %>"
                                    <%= editStudent != null && editStudent.getClassID() == c.getClassID() ? "selected" : "" %>>
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
                    <td>Phụ huynh:</td>
                    <td>
                        <select name="parentID">
                            <option value="">-- Chưa gán phụ huynh --</option>
                            <%
                                if (parents != null) {
                                    for (UserInfo p : parents) {
                            %>
                            <option value="<%= p.getUserID() %>"
                                    <%= editStudent != null && editStudent.getParentID() == p.getUserID() ? "selected" : "" %>>
                                <%= p.getFullName() %>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td></td>
                    <td>
                        <button type="submit">
                            <%= editStudent == null ? "Thêm học sinh" : "Cập nhật" %>
                        </button>

                        <% if (editStudent != null) { %>
                        <a href="<%= request.getContextPath() %>/students">Hủy sửa</a>
                        <% } %>
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
                <th>Ngày sinh</th>
                <th>Giới tính</th>
                <th>Lớp</th>
                <th>Cấp học</th>
                <th>Phụ huynh</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>

            <%
                if (students != null && !students.isEmpty()) {
                    for (Student s : students) {
            %>
            <tr>
                <td><%= s.getStudentID() %></td>
                <td><%= s.getStudentCode() %></td>
                <td><%= s.getStudentName() %></td>
                <td><%= s.getDateOfBirth() %></td>
                <td><%= s.isGender() ? "Nam" : "Nữ" %></td>
                <td><%= s.getClassName() %></td>
                <td><%= s.getLevelName() %></td>
                <td><%= s.getParentName() %></td>
                <td><%= s.isStatus() ? "Đang học" : "Đã nghỉ" %></td>
                <td>
                    <a href="<%= request.getContextPath() %>/students?action=edit&id=<%= s.getStudentID() %>">Sửa</a>
                    |
                    <a href="<%= request.getContextPath() %>/students?action=delete&id=<%= s.getStudentID() %>"
                       onclick="return confirm('Bạn có chắc muốn xóa học sinh này không?');">
                        Xóa
                    </a>
                </td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="10">Chưa có học sinh nào.</td>
            </tr>
            <%
                }
            %>
        </table>

        <br>
        <a href="<%= request.getContextPath() %>/index.jsp">Về trang chủ</a>
    </body>
</html>