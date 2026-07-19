<%-- 
    Document   : consumption-list
    Created on : Jun 21, 2026, 9:28:03 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.formats.fmt" %>
<html>
<head>
    <title>Báo Cáo Tiêu Hao - Kindergarten Kitchen</title>
    <style>
        :root { --primary: #10ac84; --bg: #f7f9fc; }
        body { font-family: 'Segoe UI', sans-serif; margin: 30px; background-color: var(--bg); }
        .container { background: white; padding: 25px; border-radius: 16px; box-shadow: 0 8px 24px rgba(0,0,0,0.05); }
        h2 { color: var(--primary); margin-top: 0; }
        .form-inline { background: #f8f9fa; padding: 15px; border-radius: 12px; margin-bottom: 20px; display: flex; gap: 15px; align-items: flex-end; }
        .form-inline label { font-size: 13px; font-weight: bold; color: #57606f; display: block; margin-bottom: 5px; }
        .form-inline select, .form-inline input { padding: 8px 12px; border: 1px solid #ced4da; border-radius: 6px; }
        .btn-sub { background-color: var(--primary); color: white; padding: 9px 15px; border: none; border-radius: 6px; font-weight: bold; cursor: pointer; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #dee2e6; }
        th { background-color: #10ac84; color: white; }
        tr:nth-child(even) { background-color: #f9f9f9; }
    </style>
</head>
<body>
<div class="container">
    <h2>🍳 Báo Cáo Nguyên Liệu Tiêu Hao Hàng Ngày</h2>

    <form action="${pageContext.request.contextPath}/consumption/add" method="POST" class="form-inline">
        <div>
            <label>Nguyên Liệu Sử Dụng:</label>
            <select name="ingredientId" required>
                <c:forEach items="${activeIngredients}" var="ing">
                    <option value="${ing.ingredientId}">${ing.ingredientName}</option>
                </c:forEach>
            </select>
        </div>
        <div>
            <label>Số Lượng Tiêu Hao:</label>
            <input type="number" name="quantityUsed" step="0.01" min="0.01" style="width: 120px;" required>
        </div>
        <div>
            <label>Lý Do / Bữa Ăn:</label>
            <input type="text" name="description" placeholder="Ví dụ: Bữa trưa các bé..." style="width: 200px;" required>
        </div>
        <button type="submit" class="btn-sub">✔ Ghi Nhận</button>
    </form>

    <table>
        <thead>
            <tr>
                <th>Ngày sử dụng</th>
                <th>Tên Nguyên Liệu</th>
                <th>Số Lượng Xuất Khỏi Kho</th>
                <th>Mục Đích Sử Dụng</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty consumptionList}">
                    <tr>
                        <td colspan="4" style="text-align: center; color: #999; padding: 20px;">Hôm nay bếp chưa xuất kho nguyên liệu nào.</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${consumptionList}" var="con">
                        <tr>
                            <td><fmt:formatDate value="${con.consumptionDate}" pattern="dd/MM/yyyy"/></td>
                            <td><strong>${con.ingredientName}</strong></td>
                            <td style="color: #ee5253; font-weight: bold;">-${con.quantityUsed} ${con.unit}</td>
                            <td>${con.description}</td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>
</body>
</html>
