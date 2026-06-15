<%-- 
    Document   : meal-history
    Created on : 15 thg 6, 2026, 22:44:35
    Author     : Vuong Nguyen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.mycompany.kindergartenkitchen.model.MealHistory"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Lịch sử ăn của con</title>
    </head>
    <body>
        <h2>Phụ huynh xem lịch sử ăn của con</h2>

        <%
            List<MealHistory> mealHistoryList = (List<MealHistory>) request.getAttribute("mealHistoryList");
        %>

        <table border="1" cellpadding="8" cellspacing="0">
            <tr>
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

            <%
                if (mealHistoryList != null && !mealHistoryList.isEmpty()) {
                    for (MealHistory h : mealHistoryList) {
            %>
            <tr>
                <td><%= h.getStudentName() %></td>
                <td><%= h.getClassName() %></td>
                <td><%= h.getLevelName() %></td>
                <td><%= h.getMenuDate() %></td>
                <td><%= h.getMealTypeName() %></td>
                <td><%= h.getDishName() %></td>
                <td><%= h.getAttendanceStatusText() %></td>
                <td><%= h.getChargedText() %></td>
                <td><%= h.getNote() != null ? h.getNote() : "" %></td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="9">Chưa có dữ liệu lịch sử ăn.</td>
            </tr>
            <%
                }
            %>
        </table>

        <br>
        <a href="<%= request.getContextPath() %>/index.jsp">Về trang chủ</a>
    </body>
</html>