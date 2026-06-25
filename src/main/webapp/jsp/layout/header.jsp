<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%
    com.mycompany.kindergartenkitchen.entity.User authUser = (com.mycompany.kindergartenkitchen.entity.User) session.getAttribute("authUser");
    String username = "Guest";
    String fullName = "Khach";
    String roleName = "";
    if (authUser != null) {
        username = authUser.getUsername() != null ? authUser.getUsername() : "User";
        fullName = authUser.getFullName() != null ? authUser.getFullName() : username;
        roleName = authUser.getRoleName() != null ? authUser.getRoleName() : "";
    }
%>
<style>
.main-header{background:#fff;height:70px;padding:0 32px;display:flex;align-items:center;justify-content:space-between;border-bottom:1px solid #e2e8f0;position:sticky;top:0;z-index:50}
.header-left,.header-right{display:flex;align-items:center;gap:16px}
.breadcrumb{font-size:14px;color:#94a3b8}
.breadcrumb strong{color:#1e293b;font-weight:600}
.user-info{display:flex;align-items:center;gap:12px}
.user-avatar{width:42px;height:42px;background:linear-gradient(135deg,#f97316,#fb923c);border-radius:12px;display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:16px}
.user-details{display:flex;flex-direction:column}
.user-name{font-weight:700;font-size:14px;color:#1e293b}
.user-role{font-size:12px;color:#94a3b8}
</style>
<header class="main-header">
<div class="header-left">
<span class="breadcrumb"><strong>KindergartenKitchen</strong> / <span id="currentPage">Dashboard</span></span>
</div>
<div class="header-right">
<div class="user-info">
<div class="user-avatar"><%= username.substring(0,1).toUpperCase() %></div>
<div class="user-details">
<span class="user-name"><%= fullName %></span>
<span class="user-role"><%= roleName %></span>
</div>
</div>
</div>
</header>
