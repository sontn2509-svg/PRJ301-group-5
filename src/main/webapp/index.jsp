<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- Khai báo thư viện thẻ JSTL chuẩn Jakarta EE 10 cho Tomcat 10 --%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Hệ Thống Bếp Ăn Mầm Non</title>
        <style>
            body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; background-color: #f4f7f6; }
            .container { background: white; padding: 30px; display: inline-block; border-radius: 10px; box-shadow: 0px 0px 10px rgba(0,0,0,0.1); }
            h1 { color: #2c3e50; }
            .status-success { color: #27ae60; font-weight: bold; font-size: 1.2em; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🏫 Hệ Thống Quản Lý Bếp Ăn Mầm Non</h1>
            <p>Dự án: <strong>KindergartenKitchen</strong></p>
            
            <%-- Dùng thẻ c:set và c:if của JSTL 2.0 để test thư viện --%>
            <c:set var="projectStatus" value="Sẵn Sàng" />
            <c:if test="${projectStatus == 'Sẵn Sàng'}">
                <p class="status-success">🎉 Cấu hình JSTL 2.0 & Tomcat 10.5 chạy ngon lành cành đào!</p>
            </c:if>
            
            <hr>
            <p style="color: #7f8c8d;">Nhóm 4 người - Sẵn sàng đẩy code lên GitHub</p>
        </div>
    </body>
</html>