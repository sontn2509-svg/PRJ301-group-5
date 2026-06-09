<%-- 
    Document   : class-list
    Created on : 9 thg 6, 2026, 12:23:10
    Author     : VuongNguyen _ HE191013
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.mycompany.kindergartenkitchen.model.ClassInfo"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh sách lớp học</title>
    </head>
    <body>
        <h2>Danh sách lớp học</h2>

        <table border="1" cellpadding="8" cellspacing="0">
            <tr>
                <th>ID</th>
                <th>Tên lớp</th>
                <th>Cấp học</th>
                <th>Giáo viên</th>
                <th>Trạng thái</th>
            </tr>

            <%
                List<ClassInfo> classes = (List<ClassInfo>) request.getAttribute("classes");
                if (classes != null) {
                    for (ClassInfo c : classes) {
            %>
            <tr>
                <td><%= c.getClassID() %></td>
                <td><%= c.getClassName() %></td>
                <td><%= c.getLevelName() %></td>
                <td><%= c.getTeacherName() %></td>
                <td><%= c.isStatus() ? "Đang hoạt động" : "Ngừng hoạt động" %></td>
            </tr>
            <%
                    }
                }
            %>
        </table>
    </body>
</html>