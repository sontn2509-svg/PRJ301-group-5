<%-- 
    Document   : import-form
    Created on : Jun 21, 2026, 9:27:38 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Tạo Phiếu Nhập Kho</title>
    <style>
        :root { --primary: #ff9f43; --bg: #f7f9fc; }
        body { font-family: 'Segoe UI', sans-serif; background-color: var(--bg); margin: 50px; }
        .form-card { max-width: 550px; background: white; padding: 35px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); margin: 0 auto; border-top: 5px solid var(--primary); }
        h3 { margin-top: 0; color: #333; text-align: center; font-size: 22px; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 8px; font-weight: 600; color: #57606f; }
        select, input { width: 100%; padding: 12px; border: 2px solid #f1f2f6; border-radius: 10px; box-sizing: border-box; font-size: 15px; transition: 0.3s; }
        select:focus, input:focus { border-color: var(--primary); outline: none; background-color: #fffdfb; }
        .btn-area { text-align: center; margin-top: 30px; }
        .btn { padding: 12px 28px; border: none; border-radius: 25px; cursor: pointer; font-size: 15px; font-weight: bold; text-decoration: none; display: inline-block; }
        .btn-save { background: linear-gradient(135deg, #10ac84, #1dd1a1); color: white; box-shadow: 0 4px 12px rgba(16,172,132,0.3); }
        .btn-cancel { background: #ee5253; color: white; margin-left: 15px; }
    </style>
</head>
<body>
<div class="form-card">
    <h3>🚚 LẬP PHIẾU NHẬP KHO NGUYÊN LIỆU</h3>
    <form action="${pageContext.request.contextPath}/import/create" method="POST">
        <div class="form-group">
            <label>Chọn Nguyên Liệu Nhập:</label>
            <select name="ingredientId" required>
                <option value="">-- Chọn một nguyên liệu có sẵn --</option>
                <c:forEach items="${activeIngredients}" var="ing">
                    <option value="${ing.ingredientId}">${ing.ingredientName} (${ing.unit})</option>
                </c:forEach>
            </select>
        </div>
        <div class="form-group">
            <label>Số Lượng Nhập:</label>
            <input type="number" name="quantity" step="0.01" min="0.01" placeholder="Nhập số lượng thực tế..." required>
        </div>
        <div class="form-group">
            <label>Tổng Số Tiền Chi Trả (VNĐ):</label>
            <input type="number" name="totalPrice" min="0" placeholder="Tổng số tiền hóa đơn đơn nhập..." required>
        </div>
        <div class="btn-area">
            <button type="submit" class="btn btn-save">Xác Nhận Nhập Kho</button>
            <a href="${pageContext.request.contextPath}/import/list" class="btn btn-cancel">Hủy Bỏ</a>
        </div>
    </form>
</div>
</body>
</html>
