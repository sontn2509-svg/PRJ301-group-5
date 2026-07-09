<%-- 
    Document   : student-list
    Created on : 15 thg 6, 2026, 17:18:30
    Author     : Vuong Nguyen
--%>

<%-- student-list.jsp – Danh sách học sinh (Member 3) --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.mycompany.kindergartenkitchen.model.Student"%>
<%@page import="com.mycompany.kindergartenkitchen.model.ClassInfo"%>
<%@page import="com.mycompany.kindergartenkitchen.model.UserInfo"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Danh sách học sinh – KindergartenKitchen</title>
        <link rel="stylesheet"
              href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body class="bg-light">
        <div class="container py-4">

            <div class="d-flex justify-content-between align-items-center mb-3">
                <h3 class="mb-0">👶 Danh sách học sinh</h3>
                <a href="<%= request.getContextPath() %>/students?action=add"
                   class="btn btn-success">+ Thêm học sinh</a>
            </div>

            <%
                String  message     = (String)  request.getAttribute("message");
                String  error       = (String)  request.getAttribute("error");
                List<Student>   studentList  = (List<Student>)   request.getAttribute("studentList");
                List<ClassInfo> classList    = (List<ClassInfo>) request.getAttribute("classList");

                String filterClass = request.getParameter("classID");
            %>

            <% if (message != null) { %>
            <div class="alert alert-success"><%= message %></div>
            <% } %>
            <% if (error != null) { %>
            <div class="alert alert-danger"><%= error %></div>
            <% } %>

            <%-- Bộ lọc theo lớp --%>
            <form action="<%= request.getContextPath() %>/students" method="get" class="row g-2 mb-3">
                <div class="col-auto">
                    <select name="classID" class="form-select">
                        <option value="">-- Tất cả lớp --</option>
                        <% if (classList != null) {
                               for (ClassInfo c : classList) {
                                   boolean sel = String.valueOf(c.getClassID()).equals(filterClass); %>
                        <option value="<%= c.getClassID() %>" <%= sel ? "selected" : "" %>>
                            <%= c.getClassName() %>
                        </option>
                        <%     }
                   } %>
                    </select>
                </div>
                <div class="col-auto">
                    <button type="submit" class="btn btn-outline-primary">Lọc</button>
                </div>
            </form>

            <div class="card shadow-sm">
                <div class="card-body p-0">
                    <table class="table table-hover mb-0">
                        <thead class="table-success">
                            <tr>
                                <th>#</th>
                                <th>Mã HS</th>
                                <th>Tên học sinh</th>
                                <th>Ngày sinh</th>
                                <th>Giới tính</th>
                                <th>Lớp</th>
                                <th>Cấp học</th>
                                <th>Phụ huynh</th>
                                <th class="text-center">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (studentList != null && !studentList.isEmpty()) {
                                    int idx = 1;
                                    for (Student s : studentList) {
                            %>
                            <tr>
                                <td><%= idx++ %></td>
                                <td><code><%= s.getStudentCode() %></code></td>
                                <td><strong><%= s.getStudentName() %></strong></td>
                                <td><%= s.getDateOfBirth() %></td>
                                <td><%= s.isGender() ? "Nam" : "Nữ" %></td>
                                <td><%= s.getClassName() %></td>
                                <td><%= s.getLevelName() %></td>
                                <td><%= s.getParentName() %></td>
                                <td class="text-center">
                                    <a href="<%= request.getContextPath() %>/students?action=edit&studentID=<%= s.getStudentID() %>"
                                       class="btn btn-sm btn-outline-primary me-1">Sửa</a>

                                    <form action="<%= request.getContextPath() %>/students"
                                          method="post" class="d-inline"
                                          onsubmit="return confirm('Xác nhận xóa học sinh này?');">
                                        <input type="hidden" name="action"    value="delete">
                                        <input type="hidden" name="studentID" value="<%= s.getStudentID() %>">
                                        <button type="submit" class="btn btn-sm btn-outline-danger">Xóa</button>
                                    </form>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="9" class="text-center text-muted py-3">
                                    Không có học sinh nào.
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
