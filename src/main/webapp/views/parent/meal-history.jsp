<%-- 
    Document   : meal-history
    Created on : 15 thg 6, 2026, 22:44:35
    Author     : Vuong Nguyen
--%>

<%-- meal-history.jsp – Phụ huynh xem lịch sử ăn của con (Member 3) --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.mycompany.kindergartenkitchen.model.MealHistory"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Lịch sử bữa ăn – KindergartenKitchen</title>
        <link rel="stylesheet"
              href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body class="bg-light">
        <div class="container py-4">

            <h3 class="mb-4">🍱 Lịch sử bữa ăn của con</h3>

            <%
                Integer selectedYearObj = (Integer) request.getAttribute("selectedYear");
                Integer selectedMonthObj = (Integer) request.getAttribute("selectedMonth");
                int selectedYear = selectedYearObj != null ? selectedYearObj : java.time.LocalDate.now().getYear();
                int selectedMonth = selectedMonthObj != null ? selectedMonthObj : java.time.LocalDate.now().getMonthValue();
                List<MealHistory> mealHistoryList = (List<MealHistory>) request.getAttribute("mealHistoryList");
            %>

            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <form action="<%= request.getContextPath() %>/parent/meal-history" method="get"
                          class="row g-3 align-items-end">
                        <div class="col-md-3">
                            <label class="form-label fw-semibold">Tháng</label>
                            <select name="month" class="form-select" required>
                                <% for (int m = 1; m <= 12; m++) { %>
                                <option value="<%= m %>" <%= selectedMonth == m ? "selected" : "" %>>
                                    Tháng <%= m %>
                                </option>
                                <% } %>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold">Năm</label>
                            <input type="number" name="year" class="form-control" required
                                   min="2020" max="2100" value="<%= selectedYear %>">
                        </div>
                        <div class="col-auto">
                            <button type="submit" class="btn btn-primary">Xem</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="card shadow-sm">
                <div class="card-body p-0">
                    <table class="table table-hover mb-0 align-middle">
                        <thead class="table-warning">
                            <tr>
                                <th>#</th>
                                <th>Học sinh</th>
                                <th>Lớp</th>
                                <th>Cấp học</th>
                                <th>Ngày</th>
                                <th>Bữa ăn</th>
                                <th>Món ăn</th>
                                <th>Trạng thái đi học</th>
                                <th>Tính tiền ăn</th>
                                <th>Ghi chú</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (mealHistoryList != null && !mealHistoryList.isEmpty()) {
                                    int idx = 1;
                                    for (MealHistory h : mealHistoryList) {
                            %>
                            <tr>
                                <td><%= idx++ %></td>
                                <td><strong><%= h.getStudentName() %></strong></td>
                                <td><%= h.getClassName() %></td>
                                <td><%= h.getLevelName() %></td>
                                <td><%= h.getMenuDate() %></td>
                                <td><span class="badge bg-info text-dark"><%= h.getMealTypeName() %></span></td>
                                <td><%= h.getDishName() %></td>
                                <td>
                                    <% String status = h.getAttendanceStatus(); %>
                                    <% if ("Present".equalsIgnoreCase(status)) { %>
                                    <span class="badge bg-success">Có mặt</span>
                                    <% } else if ("Absent".equalsIgnoreCase(status)) { %>
                                    <span class="badge bg-danger">Vắng</span>
                                    <% } else { %>
                                    <span class="badge bg-secondary">Chưa điểm danh</span>
                                    <% } %>
                                </td>
                                <td>
                                    <% if (!h.isCharged()) { %>
                                    <span class="badge bg-success">Không tính</span>
                                    <% } else { %>
                                    <span class="badge bg-secondary">Có tính</span>
                                    <% } %>
                                </td>
                                <td><small><%= (h.getNote() != null && !h.getNote().isEmpty()) ? h.getNote() : "—" %></small></td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="10" class="text-center text-muted py-3">
                                    Chưa có dữ liệu lịch sử bữa ăn.
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
