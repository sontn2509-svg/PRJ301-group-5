<%-- 
    Document   : class-list
    Created on : 15 thg 6, 2026, 17:17:44
    Author     : Vuong Nguyen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.mycompany.kindergartenkitchen.model.ClassInfo"%>
<%@page import="com.mycompany.kindergartenkitchen.model.LevelInfo"%>
<%@page import="com.mycompany.kindergartenkitchen.model.UserInfo"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản lý lớp học</title>
    </head>
    <body>
        <h2>Quản lý lớp học</h2>

        <%
            String message = (String) request.getAttribute("message");
            String error = (String) request.getAttribute("error");

            ClassInfo editClass = (ClassInfo) request.getAttribute("editClass");

            List<ClassInfo> classes = (List<ClassInfo>) request.getAttribute("classes");
            List<LevelInfo> levels = (List<LevelInfo>) request.getAttribute("levels");
            List<UserInfo> teachers = (List<UserInfo>) request.getAttribute("teachers");
        %>

        <% if (message != null) { %>
        <p style="color: green;"><%= message %></p>
        <% } %>

        <% if (error != null) { %>
        <p style="color: red;"><%= error %></p>
        <% } %>

        <h3><%= editClass == null ? "Thêm lớp học" : "Cập nhật lớp học" %></h3>

        <form action="<%= request.getContextPath() %>/classes" method="post">
            <% if (editClass != null) { %>
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="classID" value="<%= editClass.getClassID() %>">
            <% } else { %>
            <input type="hidden" name="action" value="insert">
            <% } %>

            <table>
                <tr>
                    <td>Tên lớp:</td>
                    <td>
                        <input type="text" name="className" required
                               value="<%= editClass != null ? editClass.getClassName() : "" %>">
                    </td>
                </tr>

                <tr>
                    <td>Cấp học:</td>
                    <td>
                        <select name="levelID" required>
                            <%
                                if (levels != null) {
                                    for (LevelInfo level : levels) {
                            %>
                            <option value="<%= level.getLevelID() %>"
                                    <%= editClass != null && editClass.getLevelID() == level.getLevelID() ? "selected" : "" %>>
                                <%= level.getLevelName() %>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>Giáo viên:</td>
                    <td>
                        <select name="teacherID">
                            <option value="">-- Chưa gán giáo viên --</option>

                            <%
                                if (teachers != null) {
                                    for (UserInfo teacher : teachers) {
                            %>
                            <option value="<%= teacher.getUserID() %>"
                                    <%= editClass != null && editClass.getTeacherID() == teacher.getUserID() ? "selected" : "" %>>
                                <%= teacher.getFullName() %>
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
                            <%= editClass == null ? "Thêm lớp" : "Cập nhật" %>
                        </button>

                        <% if (editClass != null) { %>
                        <a href="<%= request.getContextPath() %>/classes">Hủy sửa</a>
                        <% } %>
                    </td>
                </tr>
            </table>
        </form>

        <hr>

        <h3>Danh sách lớp học</h3>

        <table border="1" cellpadding="8" cellspacing="0">
            <tr>
                <th>ID</th>
                <th>Tên lớp</th>
                <th>Cấp học</th>
                <th>Giáo viên</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>

            <%
                if (classes != null && !classes.isEmpty()) {
                    for (ClassInfo c : classes) {
            %>
            <tr>
                <td><%= c.getClassID() %></td>
                <td><%= c.getClassName() %></td>
                <td><%= c.getLevelName() %></td>
                <td><%= c.getTeacherName() %></td>
                <td><%= c.isStatus() ? "Đang hoạt động" : "Đã khóa" %></td>
                <td>
                    <a href="<%= request.getContextPath() %>/classes?action=edit&id=<%= c.getClassID() %>">Sửa</a>
                    |
                    <a href="<%= request.getContextPath() %>/classes?action=delete&id=<%= c.getClassID() %>"
                       onclick="return confirm('Bạn có chắc muốn xóa lớp này không?');">
                        Xóa
                    </a>
                </td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="6">Chưa có lớp học nào.</td>
            </tr>
            <%
                }
            %>
        </table>

        <br>
        <a href="<%= request.getContextPath() %>/index.jsp">Về trang chủ</a>
    </body>
</html>
