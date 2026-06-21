<%-- 
    Document   : kitchen-meal-count
    Created on : 15 thg 6, 2026, 23:42:10
    Author     : Vuong Nguyen
--%>

<%-- kitchen-meal-count.jsp – Bếp xem số suất ăn (Member 3) --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.Date"%>
<%@page import="com.mycompany.kindergartenkitchen.model.MealCount"%>
<%@page import="com.mycompany.kindergartenkitchen.model.LevelMealCount"%>
<%@page import="com.mycompany.kindergartenkitchen.model.Attendance"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Số suất ăn – KindergartenKitchen</title>
        <link rel="stylesheet"
              href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body class="bg-light">
        <div class="container py-4">

            <h3 class="mb-4">🍽️ Bếp – Số suất ăn cần chuẩn bị</h3>

            <%
                Date      mealDate          = (Date)      request.getAttribute("mealDate");
                Integer   totalMealCountObj = (Integer)   request.getAttribute("totalMealCount");
                int       totalMealCount    = totalMealCountObj != null ? totalMealCountObj : 0;
                List<MealCount>  mealCountList   = (List<MealCount>)  request.getAttribute("mealCountList");
                List<LevelMealCount> levelMealCountList = (List<LevelMealCount>) request.getAttribute("levelMealCountList");
                List<Attendance> presentStudents = (List<Attendance>) request.getAttribute("presentStudents");
            %>

            <%-- Bộ chọn ngày --%>
            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <form action="<%= request.getContextPath() %>/kitchen/meal-count" method="get"
                          class="row g-3 align-items-end">
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Chọn ngày</label>
                            <input type="date" name="mealDate" class="form-control" required
                                   value="<%= mealDate != null ? mealDate : "" %>">
                        </div>
                        <div class="col-auto">
                            <button type="submit" class="btn btn-primary">Xem</button>
                        </div>
                    </form>
                </div>
            </div>

            <%-- Tổng suất ăn --%>
            <div class="alert alert-primary fs-5">
                📅 Ngày: <strong><%= mealDate != null ? mealDate : "—" %></strong>
                &nbsp;|&nbsp;
                🍴 Tổng số suất ăn cần chuẩn bị:
                <strong class="text-primary fs-4"><%= totalMealCount %></strong>
            </div>

            <%-- Tổng suất ăn theo cấp học --%>
            <div class="card shadow-sm mb-4">
                <div class="card-header fw-semibold">Số suất ăn theo cấp học</div>
                <div class="card-body p-0">
                    <table class="table table-hover mb-0 align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Cấp học</th>
                                <th class="text-center">Số suất ăn</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (levelMealCountList != null && !levelMealCountList.isEmpty()) {
                                    int idx = 1;
                                    for (LevelMealCount l : levelMealCountList) {
                            %>
                            <tr>
                                <td><%= idx++ %></td>
                                <td><strong><%= l.getLevelName() %></strong></td>
                                <td class="text-center"><span class="badge bg-primary fs-6"><%= l.getMealCount() %></span></td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="3" class="text-center text-muted py-3">
                                    Chưa có dữ liệu suất ăn theo cấp học.
                                </td>
                            </tr>
                            <%  } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <%-- Bảng theo lớp --%>
            <div class="card shadow-sm mb-4">
                <div class="card-header fw-semibold">Số suất ăn theo lớp</div>
                <div class="card-body p-0">
                    <table class="table table-hover mb-0 align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Lớp</th>
                                <th>Cấp học</th>
                                <th class="text-center">Số học sinh có mặt</th>
                                <th class="text-center">Số suất ăn</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (mealCountList != null && !mealCountList.isEmpty()) {
                                    int idx = 1;
                                    for (MealCount m : mealCountList) {
                            %>
                            <tr>
                                <td><%= idx++ %></td>
                                <td><strong><%= m.getClassName() %></strong></td>
                                <td><%= m.getLevelName() %></td>
                                <td class="text-center"><span class="badge bg-success fs-6"><%= m.getPresentCount() %></span></td>
                                <td class="text-center"><span class="badge bg-primary fs-6"><%= m.getMealCount() %></span></td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="5" class="text-center text-muted py-3">
                                    Chưa có dữ liệu suất ăn cho ngày này.
                                </td>
                            </tr>
                            <%  } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <%-- Bảng danh sách học sinh có mặt --%>
            <div class="card shadow-sm">
                <div class="card-header fw-semibold">Danh sách học sinh có mặt hôm nay</div>
                <div class="card-body p-0">
                    <table class="table table-hover mb-0 align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Mã HS</th>
                                <th>Tên học sinh</th>
                                <th>Lớp</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (presentStudents != null && !presentStudents.isEmpty()) {
                                    int idx = 1;
                                    for (Attendance a : presentStudents) {
                            %>
                            <tr>
                                <td><%= idx++ %></td>
                                <td><code><%= a.getStudentCode() %></code></td>
                                <td><strong><%= a.getStudentName() %></strong></td>
                                <td><%= a.getClassName() %></td>
                                <td><span class="badge bg-success">Có mặt</span></td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="5" class="text-center text-muted py-3">
                                    Chưa có học sinh nào có mặt trong ngày này.
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
