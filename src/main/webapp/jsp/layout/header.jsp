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
<div id="toastContainer" style="position:fixed; top:20px; right:20px; z-index:2000; display:flex; flex-direction:column; gap:10px;"></div>

<script>
function showToast(message, type) {
    var container = document.getElementById('toastContainer');
    var toast = document.createElement('div');
    var bgColor = type === 'error' ? '#fee2e2' : '#d1fae5';
    var textColor = type === 'error' ? '#991b1b' : '#065f46';
    var icon = type === 'error' ? 'fa-circle-exclamation' : 'fa-circle-check';

    toast.style.cssText =
        'background:' + bgColor + '; color:' + textColor + ';' +
        'padding:12px 16px; border-radius:8px; box-shadow:0 4px 12px rgba(0,0,0,0.15);' +
        'font-size:14px; display:flex; align-items:center; gap:8px; min-width:240px;' +
        'opacity:0; transform:translateX(20px); transition:all 0.25s ease;';
    toast.innerHTML = '<i class="fas ' + icon + '"></i><span>' + message + '</span>';
    container.appendChild(toast);

    requestAnimationFrame(function () {
        toast.style.opacity = '1';
        toast.style.transform = 'translateX(0)';
    });

    setTimeout(function () {
        toast.style.opacity = '0';
        toast.style.transform = 'translateX(20px)';
        setTimeout(function () { toast.remove(); }, 250);
    }, 3000);
}
</script>