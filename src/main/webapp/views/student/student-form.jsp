<%-- 
    Document   : student-form
    Created on : 21 thg 6, 2026, 23:18:41
    Author     : Vuong Nguyen
--%>

<%-- student-form.jsp – Form thêm / sửa học sinh (Member 3) --%>
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
        <title>Thêm / Sửa học sinh – KindergartenKitchen</title>
        <link rel="stylesheet"
              href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body class="bg-light">
        <div class="container py-4" style="max-width: 600px;">

            <%
                Student        student   = (Student)       request.getAttribute("student");
                List<ClassInfo> classList = (List<ClassInfo>) request.getAttribute("classList");
                List<UserInfo>  parents   = (List<UserInfo>)  request.getAttribute("parents");

                boolean isEdit     = (student != null);
                String  formAction = isEdit ? "edit" : "add";
                String  pageTitle  = isEdit ? "✏️ Sửa thông tin học sinh" : "➕ Thêm học sinh mới";
            %>

            <h3 class="mb-4"><%= pageTitle %></h3>

            <div class="card shadow-sm">
                <div class="card-body">
                    <form action="<%= request.getContextPath() %>/students" method="post">
                        <input type="hidden" name="action" value="<%= formAction %>">
                        <% if (isEdit) { %>
                        <input type="hidden" name="studentID" value="<%= student.getStudentID() %>">
                        <% } %>

                        <%-- Mã học sinh --%>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Mã học sinh <span class="text-danger">*</span></label>
                            <input type="text" name="studentCode" class="form-control"
                                   value="<%= isEdit ? student.getStudentCode() : "" %>"
                                   required maxlength="20">
                        </div>

                        <%-- Họ tên --%>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Họ và tên <span class="text-danger">*</span></label>
                            <input type="text" name="studentName" class="form-control"
                                   value="<%= isEdit ? student.getStudentName() : "" %>"
                                   required maxlength="100">
                        </div>

                        <%-- Ngày sinh --%>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Ngày sinh</label>
                            <input type="date" name="dateOfBirth" class="form-control"
                                   value="<%= (isEdit && student.getDateOfBirth() != null) ? student.getDateOfBirth() : "" %>">
                        </div>

                        <%-- Giới tính --%>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Giới tính</label>
                            <select name="gender" class="form-select">
                                <option value="1" <%= (isEdit && student.isGender()) ? "selected" : "" %>>Nam</option>
                                <option value="0" <%= (isEdit && !student.isGender()) ? "selected" : "" %>>Nữ</option>
                            </select>
                        </div>

                        <%-- Lớp học --%>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Lớp học <span class="text-danger">*</span></label>
                            <select name="classID" class="form-select" required>
                                <option value="">-- Chọn lớp --</option>
                                <% if (classList != null) {
                                       for (ClassInfo c : classList) {
                                           boolean sel = isEdit && student.getClassID() == c.getClassID(); %>
                                <option value="<%= c.getClassID() %>" <%= sel ? "selected" : "" %>>
                                    <%= c.getClassName() %> (<%= c.getLevelName() %>)
                                </option>
                                <%     }
                           } %>
                            </select>
                        </div>

                        <%-- Phụ huynh --%>
                        <div class="mb-4">
                            <label class="form-label fw-semibold">Phụ huynh</label>
                            <select name="parentID" class="form-select">
                                <option value="">-- Chưa liên kết --</option>
                                <% if (parents != null) {
                                       for (UserInfo p : parents) {
                                           boolean sel = isEdit && student.getParentID() == p.getUserID(); %>
                                <option value="<%= p.getUserID() %>" <%= sel ? "selected" : "" %>>
                                    <%= p.getFullName() %> (<%= p.getUsername() %>)
                                </option>
                                <%     }
                           } %>
                            </select>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary">
                                <%= isEdit ? "Lưu thay đổi" : "Thêm học sinh" %>
                            </button>
                            <a href="<%= request.getContextPath() %>/students"
                               class="btn btn-outline-secondary">Hủy</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>

