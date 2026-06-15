<%-- 
    Document   : kitchen-meal-count
    Created on : 15 thg 6, 2026, 23:42:10
    Author     : Vuong Nguyen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.Date"%>
<%@page import="com.mycompany.kindergartenkitchen.model.MealCount"%>
<%@page import="com.mycompany.kindergartenkitchen.model.Attendance"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Bếp xem số suất ăn</title>
    </head>
    <body>
        <h2>Bếp xem danh sách học sinh có mặt / số suất ăn</h2>

        <%
            Date mealDate = (Date) request.getAttribute("mealDate");
            Integer totalMealCountObj = (Integer) request.getAttribute("totalMealCount");
            int totalMealCount = totalMealCountObj != null ? totalMealCountObj : 0;

            List<MealCount> mealCountList = (List<MealCount>) request.getAttribute("mealCountList");
            List<Attendance> presentStudents = (List<Attendance>) request.getAttribute("presentStudents");
        %>

        <h3>Chọn ngày</h3>

        <form action="<%= request.getContextPath() %>/kitchen/meal-count" method="get">
            <table>
                <tr>
                    <td>Ngày:</td>
                    <td>
                        <input type="date" name="mealDate" required
                               value="<%= mealDate != null ? mealDate : "" %>">
                    </td>
                    <td>
                        <button type="submit">Xem</button>
                    </td>
                </tr>
            </table>
        </form>

        <hr>

        <h3>Tổng số suất ăn cần chuẩn bị</h3>

        <p>
            Ngày: <strong><%= mealDate != null ? mealDate : "" %></strong>
        </p>

        <p>
            Tổng số suất ăn: <strong><%= totalMealCount %></strong>
        </p>

        <h3>Số suất ăn theo lớp</h3>

        <table border="1" cellpadding="8" cellspacing="0">
            <tr>
                <th>Lớp</th>
                <th>Cấp học</th>
                <th>Số học sinh có mặt</th>
                <th>Số suất ăn</th>
            </tr>

            <%
                if (mealCountList != null && !mealCountList.isEmpty()) {
                    for (MealCount m : mealCountList) {
            %>
            <tr>
                <td><%= m.getClassName() %></td>
                <td><%= m.getLevelName() %></td>
                <td><%= m.getPresentCount() %></td>
                <td><%= m.getPresentCount() %></td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="4">Chưa có dữ liệu suất ăn cho ngày này.</td>
            </tr>
            <%
                }
            %>
        </table>

        <hr>

        <h3>Danh sách học sinh có mặt</h3>

        <table border="1" cellpadding="8" cellspacing="0">
            <tr>
                <th>ID</th>
                <th>Mã học sinh</th>
                <th>Tên học sinh</th>
                <th>Lớp</th>
                <th>Ngày</th>
                <th>Trạng thái</th>
            </tr>

            <%
                if (presentStudents != null && !presentStudents.isEmpty()) {
                    for (Attendance a : presentStudents) {
            %>
            <tr>
                <td><%= a.getStudentID() %></td>
                <td><%= a.getStudentCode() %></td>
                <td><%= a.getStudentName() %></td>
                <td><%= a.getClassName() %></td>
                <td><%= a.getAttendanceDate() %></td>
                <td><%= a.getStatusText() %></td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="6">Chưa có học sinh có mặt trong ngày này.</td>
            </tr>
            <%
                }
            %>
        </table>

        <br>
        <a href="<%= request.getContextPath() %>/index.jsp">Về trang chủ</a>
    </body>
</html>
