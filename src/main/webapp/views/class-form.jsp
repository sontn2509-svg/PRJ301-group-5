<%-- 
    Document   : class-form
    Created on : 21 thg 6, 2026, 23:19:21
    Author     : Vuong Nguyen
--%>

<%-- class-form.jsp – Form thêm / sửa lớp học (Member 3) --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.mycompany.kindergartenkitchen.model.ClassInfo"%>
<%@page import="com.mycompany.kindergartenkitchen.model.LevelInfo"%>
<%@page import="com.mycompany.kindergartenkitchen.model.UserInfo"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Thêm / Sửa lớp – KindergartenKitchen</title>
        <link rel="stylesheet"
              href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body class="bg-light">
        <div class="container py-4" style="max-width: 560px;">

            <%
                ClassInfo classInfo = (ClassInfo) request.getAttribute("classInfo");
                List<LevelInfo> levels  = (List<LevelInfo>) request.getAttribute("levels");
                List<UserInfo>  teachers = (List<UserInfo>)  request.getAttribute("teachers");

                boolean isEdit  = (classInfo != null);
                String  formAction = isEdit ? "edit" : "add";
                String  pageTitle  = isEdit ? "✏️ Sửa lớp học" : "➕ Thêm lớp mới";
            %>

            <h3 class="mb-4"><%= pageTitle %></h3>

            <div class="card shadow-sm">
                <div class="card-body">
                    <form action="<%= request.getContextPath() %>/classes" method="post">
                        <input type="hidden" name="action" value="<%= formAction %>">
                        <% if (isEdit) { %>
                        <input type="hidden" name="classID" value="<%= classInfo.getClassID() %>">
                        <% } %>

                        <%-- Tên lớp --%>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Tên lớp <span class="text-danger">*</span></label>
                            <input type="text" name="className" class="form-control"
                                   value="<%= isEdit ? classInfo.getClassName() : "" %>"
                                   required maxlength="50">
                        </div>

                        <%-- Cấp học --%>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Cấp học <span class="text-danger">*</span></label>
                            <select name="levelID" class="form-select" required>
                                <% if (levels != null) {
                                       for (LevelInfo l : levels) {
                                           boolean selected = isEdit && classInfo.getLevelID() == l.getLevelID(); %>
                                <option value="<%= l.getLevelID() %>"
                                        <%= selected ? "selected" : "" %>>
                                    <%= l.getLevelName() %>
                                </option>
                                <%     }
                           } %>
                            </select>
                        </div>

                        <%-- Giáo viên phụ trách --%>
                        <div class="mb-4">
                            <label class="form-label fw-semibold">Giáo viên phụ trách</label>
                            <select name="teacherID" class="form-select">
                                <option value="">-- Chưa phân công --</option>
                                <% if (teachers != null) {
                                       for (UserInfo t : teachers) {
                                           boolean selected = isEdit && classInfo.getTeacherID() == t.getUserID(); %>
                                <option value="<%= t.getUserID() %>"
                                        <%= selected ? "selected" : "" %>>
                                    <%= t.getFullName() %>
                                </option>
                                <%     }
                           } %>
                            </select>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary">
                                <%= isEdit ? "Lưu thay đổi" : "Thêm lớp" %>
                            </button>
                            <a href="<%= request.getContextPath() %>/classes"
                               class="btn btn-outline-secondary">Hủy</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>

