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

<div id="confirmModal" class="modal-overlay" style="display:none;">
  <div class="modal-box">
    <p id="confirmModalText">Bạn có chắc muốn xoá?</p>
    <div class="modal-actions">
      <button type="button" class="btn btn-outline" onclick="closeConfirmModal()">Huỷ</button>
      <button type="button" class="btn" style="background:#ef4444;color:#fff;" id="confirmModalOkBtn">Xoá</button>
    </div>
  </div>
</div>

<script>
let __pendingDeleteForm = null;

function confirmDelete(formElement, message) {
    __pendingDeleteForm = formElement;
    document.getElementById('confirmModalText').textContent = message || 'Bạn có chắc muốn xoá?';
    document.getElementById('confirmModal').style.display = 'flex';
    return false;
}

function closeConfirmModal() {
    __pendingDeleteForm = null;
    document.getElementById('confirmModal').style.display = 'none';
}

document.getElementById('confirmModalOkBtn').addEventListener('click', function () {
    if (__pendingDeleteForm) {
        __pendingDeleteForm.submit();
    }
    closeConfirmModal();
});
</script>