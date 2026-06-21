<%-- 
    Document   : class-list
    Created on : 15 thg 6, 2026, 17:17:44
    Author     : Vuong Nguyen
--%>

<%-- class-list.jsp – Danh sách lớp học (Member 3) --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.mycompany.kindergartenkitchen.model.ClassInfo"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Quản lý lớp học – KindergartenKitchen</title>
        <link rel="stylesheet"
              href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body class="bg-light">
        <div class="container py-4">

            <div class="d-flex justify-content-between align-items-center mb-3">
                <h3 class="mb-0">📚 Quản lý lớp học</h3>
                <a href="<%= request.getContextPath() %>/classes?action=add"
                   class="btn btn-success">+ Thêm lớp mới</a>
            </div>

            <%
                String message = (String) request.getAttribute("message");
                String error   = (String) request.getAttribute("error");
                List<ClassInfo> classList = (List<ClassInfo>) request.getAttribute("classList");
            %>

            <% if (message != null) { %>
            <div class="alert alert-success"><%= message %></div>
            <% } %>
            <% if (error != null) { %>
            <div class="alert alert-danger"><%= error %></div>
            <% } %>

            <div class="card shadow-sm">
                <div class="card-body p-0">
                    <table class="table table-hover mb-0">
                        <thead class="table-primary">
                            <tr>
                                <th>#</th>
                                <th>Tên lớp</th>
                                <th>Cấp học</th>
                                <th>Giáo viên phụ trách</th>
                                <th class="text-center">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (classList != null && !classList.isEmpty()) {
                                    int idx = 1;
                                    for (ClassInfo c : classList) {
                            %>
                            <tr>
                                <td><%= idx++ %></td>
                                <td><strong><%= c.getClassName() %></strong></td>
                                <td><%= c.getLevelName() %></td>
                                <td><%= c.getTeacherName() %></td>
                                <td class="text-center">
                                    <a href="<%= request.getContextPath() %>/classes?action=edit&classID=<%= c.getClassID() %>"
                                       class="btn btn-sm btn-outline-primary me-1">Sửa</a>

                                    <form action="<%= request.getContextPath() %>/classes"
                                          method="post" class="d-inline"
                                          onsubmit="return confirm('Xác nhận xóa lớp này?');">
                                        <input type="hidden" name="action"  value="delete">
                                        <input type="hidden" name="classID" value="<%= c.getClassID() %>">
                                        <button type="submit" class="btn btn-sm btn-outline-danger">Xóa</button>
                                    </form>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="5" class="text-center text-muted py-3">
                                    Chưa có lớp học nào.
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
