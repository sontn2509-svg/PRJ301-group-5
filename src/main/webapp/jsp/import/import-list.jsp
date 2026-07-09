<%-- 
    Document   : import-list
    Created on : Jun 21, 2026, 9:27:28 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.formats.fmt" %>
<!DOCTYPE html>

<html>
<head>
    <title>Lịch Sử Nhập Kho - Kindergarten Kitchen</title>
    <style>
        :root { --primary: #ff9f43; --secondary: #10ac84; --bg: #f7f9fc; --text: #2d3436; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 30px; background-color: var(--bg); color: var(--text); }
        .container { background: white; padding: 25px; border-radius: 16px; box-shadow: 0 8px 24px rgba(0,0,0,0.05); }
        h2 { color: var(--primary); display: flex; align-items: center; gap: 10px; margin-top: 0; }
        .btn { padding: 10px 20px; border: none; border-radius: 30px; cursor: pointer; text-decoration: none; color: white; font-weight: bold; font-size: 14px; display: inline-block; transition: all 0.3s; }
        .btn-add { background: linear-gradient(135deg, #ff9f43, #ffb142); box-shadow: 0 4px 12px rgba(255,159,67,0.3); margin-bottom: 20px; }
        .btn-add:hover { transform: translateY(-2px); box-shadow: 0 6px 15px rgba(255,159,67,0.4); }
        table { width: 100%; border-collapse: separate; border-spacing: 0 8px; margin-top: 10px; }
        th { background-color: #f1f2f6; color: #57606f; padding: 15px; text-align: left; font-weight: 600; }
        th:first-child { border-radius: 12px 0 0 12px; }
        th:last-child { border-radius: 0 12px 12px 0; }
        td { background: #fff; padding: 15px; border-top: 1px solid #f1f2f6; border-bottom: 1px solid #f1f2f6; }
        tr:hover td { background-color: #fff9f4; }
        td:first-child { border-left: 1px solid #f1f2f6; border-radius: 12px 0 0 12px; font-weight: bold; }
        td:last-child { border-right: 1px solid #f1f2f6; border-radius: 0 12px 12px 0; }
        .price { color: #ee5253; font-weight: bold; }
    </style>
</head>
<body>
<div class="container">
    <h2>🚚 Lịch Sử Nhập Kho Nguyên Liệu</h2>
    <a href="${pageContext.request.contextPath}/import/form" class="btn btn-add">➕ Tạo Đơn Nhập Kho Mới</a>
    
    <table>
        <thead>
            <tr>
                <th>Mã Đơn</th>
                <th>Tên Nguyên Liệu</th>
                <th>Số Lượng</th>
                <th>Tổng Chi Phí</th>
                <th>Ngày Nhập Kho</th>
                <th>Người Nhập</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty importList}">
                    <tr>
                        <td colspan="6" style="text-align: center; color: #a4b0be; padding: 30px;">Chưa có đơn nhập kho nào được ghi nhận.</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${importList}" var="imp">
                        <tr>
                            <td>#${imp.importId}</td>
                            <td><strong>${imp.ingredientName}</strong></td>
                            <td>${imp.quantity} ${imp.unit}</td>
                            <td class="price"><fmt:formatNumber value="${imp.totalPrice}" type="currency" currencySymbol="đ"/></td>
                            <td><fmt:formatDate value="${imp.importDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td><span style="background: #eccc68; padding: 4px 10px; border-radius: 20px; font-size: 12px;">${imp.supplierOrStaff}</span></td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>
</body>
</html>
