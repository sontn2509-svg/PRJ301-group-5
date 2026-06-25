<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử bếp - KindergartenKitchen</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
* { margin: 0; padding: 0; box-sizing: border-box; }
body { font-family: 'Segoe UI', Tahoma, sans-serif; background: #f5f7fa; color: #1e293b; line-height: 1.6; }
a { text-decoration: none; color: inherit; }
.app-container { display: flex; min-height: 100vh; }
.main-content { flex: 1; margin-left: 260px; display: flex; flex-direction: column; min-height: 100vh; }
.page-content { flex: 1; padding: 24px 32px; }

.page-header-card { background: linear-gradient(135deg, #ea580c 0%, #f97316 50%, #fb923c 100%); border-radius: 16px; padding: 28px 32px; margin-bottom: 24px; color: #fff; }
.page-header-content { display: flex; align-items: center; gap: 20px; }
.page-header-icon { width: 60px; height: 60px; background: rgba(255,255,255,0.2); border: 2px solid rgba(255,255,255,0.3); border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 28px; flex-shrink: 0; }
.page-header-card h1 { font-size: 24px; font-weight: 800; margin-bottom: 4px; }
.page-header-card p { opacity: 0.9; font-size: 14px; }

.panel { background: #fff; border-radius: 16px; box-shadow: 0 2px 8px rgba(0,0,0,0.04); border: 1px solid #e2e8f0; margin-bottom: 20px; overflow: hidden; }
.panel-header { padding: 18px 24px; border-bottom: 1px solid #e2e8f0; display: flex; align-items: center; justify-content: space-between; }
.panel-title { display: flex; align-items: center; gap: 10px; font-size: 16px; font-weight: 700; color: #1e293b; }
.panel-title .icon { width: 32px; height: 32px; background: rgba(249,115,22,0.1); border-radius: 8px; display: flex; align-items: center; justify-content: center; color: #f97316; font-size: 14px; }

table { width: 100%; border-collapse: collapse; }
table thead { background: #f5f7fa; }
table th { padding: 14px 16px; text-align: left; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; color: #94a3b8; border-bottom: 1px solid #e2e8f0; }
table td { padding: 16px; border-bottom: 1px solid #e2e8f0; font-size: 14px; color: #475569; }
table tbody tr:hover { background: #f5f7fa; }
table tbody tr:last-child td { border-bottom: none; }

.meal-stat { font-weight: 800; color: #f97316; }

@media (max-width: 768px) { .main-content { margin-left: 80px; } .page-content { padding: 16px; } }
    </style>
</head>
<body>
    <div class="app-container">
        <jsp:include page="/jsp/layout/sidebar-manager.jsp"/>
        <div class="main-content">
            <jsp:include page="/jsp/layout/header.jsp"/>
            <main class="page-content">
                <div class="page-header-card">
                    <div class="page-header-content">
                        <div class="page-header-icon"><i class="fas fa-utensils"></i></div>
                        <div><h1>Lịch sử bếp</h1><p>Xem lại lịch sử các bữa ăn đã nấu</p></div>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title"><span class="icon"><i class="fas fa-clock-rotate-left"></i></span>Danh sách bữa ăn</div>
                        <span style="color: #64748b;">Tổng: <strong style="color: #f97316;">${meals.size()}</strong> bữa</span>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>Ngày</th>
                                <th>Tổng suất</th>
                                <th>Ghi chú</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="m" items="${meals}">
                                <tr>
                                    <td><i class="far fa-calendar" style="margin-right: 8px; color: #94a3b8;"></i>${m.date}</td>
                                    <td><span class="meal-stat">${m.totalCount}</span> suất</td>
                                    <td>${m.note}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty meals}">
                                <tr><td colspan="3" style="text-align: center; padding: 32px; color: #94a3b8;">Chưa có bữa ăn nào.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>
    </div>
</body>
</html>