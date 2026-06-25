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
