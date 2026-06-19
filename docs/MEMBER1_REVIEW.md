# 📌 Thành viên 1 — Authentication & User Management

## 1. Tổng quan module

Module quản lý **xác thực** (đăng nhập/đăng xuất) và **quản lý tài khoản** (CRUD user, phân quyền, nhật ký hệ thống). Chỉ tài khoản **Admin** được phép truy cập toàn bộ chức năng.

---

## 2. Luồng đăng nhập — Chi tiết từng bước

```
Browser gửi POST /login (username + password)
         │
         ▼
AuthServlet.login()
         │
         ▼
UserDAO.authenticate(username, password)
   SQL: SELECT ... FROM Users u JOIN Roles r ON ...
        WHERE u.Username = ? AND u.Password = ? AND u.Status = 1
         │
    ┌────┴────┐
    │ match?  │
    └────┬────┘
  Sai    │       ┌───✓───┐
   │     │       │       │
   ▼     │       │ Có    │
Forward  │       │ Status=1?
login.jsp│       └────┬───┘
(lỗi)    │        Có  │ Không
         │         │   ▼
         │    session.setAttribute("authUser", user)
         │    systemLogDAO.create(LOGIN)
         │         │
         │    roleName=="Admin"?
         │      ┌──┴──┐
         │     Có     Không
         │      │      │
         │      ▼      ▼
         │  redirect   forward
         │ /admin/    role-waiting.jsp
         │ dashboard
         └──────────────┘
```

**Điểm quan trọng:**
- `Status = 1` là điều kiện bắt buộc → tài khoản bị khóa (status=2) hoặc chờ duyệt (status=0) **không đăng nhập được**
- User object được JOIN từ 2 bảng Users + Roles → lấy luôn `roleName` trong 1 câu SQL
- Sau khi đăng nhập thành công → ghi log `LOGIN` vào SystemLogs

---

## 3. Hệ thống phân quyền — 2 lớp Filter

### AuthFilter (`/*`) — Kiểm tra đã đăng nhập chưa

```java
// 1. Public resources → cho qua không kiểm tra
uri.equals("/login")
uri.equals("/forgot-password")
uri.startsWith("/assets/")
uri.startsWith("/favicon")

// 2. Tất cả URL khác
session.getAttribute("authUser") == null
    → redirect /login
    → chain.doFilter()  // cho đi tiếp
```

### AdminFilter (`/admin/*`) — Kiểm tra có phải Admin không

```java
User user = session.getAttribute("authUser")

user == null || user.getRoleName() != "Admin"
    → sendError(403)
    → chain.doFilter()  // cho Admin đi tiếp
```

**Thứ tự Filter chạy:**
```
Request → AuthFilter (/*) → AdminFilter (/admin/*) → Servlet → JSP → Response
              ↓ kiểm tra              ↓ kiểm tra
         đã login? chưa?          là Admin? không?
```

---

## 4. CRUD User — Chi tiết từng thao tác

### 4.1. Tạo User mới (`POST /admin/users/create`)

```
Bước 1: readForm(request, true)
        → Đọc username, password, fullName, email, phone, roleId, status
        → includeUsername = true (vì đang tạo mới)

Bước 2: validate(form, true, null)
        → username không rỗng
        → username chưa tồn tại trong DB (usernameExists)
        → password không rỗng
        → fullName không rỗng
        → roleId > 0
        → status ∈ {0, 1, 2}

Bước 3: userDAO.create(form)
        → INSERT vào DB, trả về UserID mới

Bước 4: systemLogDAO.create(CREATE_USER, ...)
        → Ghi log: ai tạo tài khoản gì

Bước 5: session.setAttribute("flash", "Đã tạo tài khoản ...")
        → redirect /admin/users
```

### 4.2. Sửa User (`POST /admin/users/edit?id=X`)

```
Khác với tạo mới:
- includeUsername = false (giữ nguyên username cũ, không cho sửa)
- Gán lại username từ DB: form.setUsername(existing.getUsername())
- Password là optional: nếu không nhập → giữ nguyên; nhập → đổi password
- exceptUserId = id (khi kiểm tra username trùng → loại trừ chính nó)
```

### 4.3. Toggle trạng thái (`GET /admin/users/toggle?id=X`)

```java
// Điều kiện bảo vệ: KHÔNG BAO GIỜ khóa được Admin (roleId = 1)
if (target.isPresent() && target.getRoleId() != 1) {
    userDAO.toggleStatus(id);  // SQL: CASE WHEN Status=1 THEN 2 ELSE 1 END
    systemLogDAO.create(TOGGLE_USER_STATUS, ...);
}

// → ngay cả gọi trực tiếp URL, Admin vẫn không bị khóa
```

**Ý nghĩa status:**
| Giá trị | Trạng thái | Đăng nhập được? |
|---------|-----------|-----------------|
| 0 | Chờ duyệt | Không |
| 1 | Hoạt động | Có |
| 2 | Bị khóa | Không |

---

### 4.4. Xóa tài khoản (`GET /admin/users/delete?id=X`)

```
Bước 1: Lấy user từ DB theo ID
         │
         ▼
Bước 2: Kiểm tra bảo vệ
         ├── user không tồn tại → redirect về danh sách
         ├── là Admin (roleId == 1) → báo lỗi "Không thể xóa tài khoản Admin"
         └── là chính mình → báo lỗi "Không thể xóa tài khoản của chính mình"
         │
         ▼
Bước 3: Lưu username trước khi xóa (vì sau xóa không truy vấn được nữa)
         │
         ▼
Bước 4: userDAO.delete(id)
         SQL: DELETE FROM Users WHERE UserID = ?
         │
         ▼
Bước 5: systemLogDAO.create(DELETE_USER, ...)
         │
         ▼
Bước 6: Flash message → redirect /admin/users
```

**Bảo vệ 2 lớp:**
- Không xóa được tài khoản Admin → roleId = 1
- Không xóa được chính mình → kiểm tra admin.userId == id

---

## 6. Reset mật khẩu (Quên mật khẩu)

```
POST /forgot-password
   │
   ▼
validate: username, email, phone không rỗng,
          password ≥ 6 ký tự, password == confirmPassword
   │
   ▼
UserDAO.findForPasswordReset(username, email, phone)
   SQL: WHERE Username=?
        AND LOWER(ISNULL(Email,'')) = LOWER(?)
        AND ISNULL(Phone,'') = ?
        AND Status = 1
   │
┌──┴──┐
│match?│
└──┬──┘
Sai  │  ┌───✓───┐
 ▼   │  │ Có    │
Lỗi  │  │ Status=1
     │  └────┬──┘
     │       ▼
     │  userDAO.resetPassword(userId, newPassword)
     │  systemLogDAO.create(RESET_PASSWORD)
     │       ▼
     │  forward forgot-password.jsp (thành công)
     └───────┘
```

**Điểm quan trọng:**
- Phải khớp **username + email + phone** mới reset được → bảo mật hơn chỉ cần username
- `Status = 1` bắt buộc → tài khoản bị khóa không reset được
- `ISNULL(Phone,'')` → xử lý phone NULL trong DB

---

## 7. Đổi mật khẩu (Đã đăng nhập)

```
POST /admin/change-password
   │
   ▼
validate: currentPassword không rỗng
          newPassword ≥ 6 ký tự
          newPassword == confirmPassword
          newPassword != currentPassword
   │
   ▼
So sánh currentPassword với session.authUser.password
   │
┌──┴──┐
│khớp?│
└──┬──┘
Sai  │  ┌───✓───┐
 ▼   │  │ Có    │
Lỗi  │  └────┬──┘
     │       ▼
     │  userDAO.resetPassword(userId, newPassword)
     │  session.setAttribute("authUser", updatedUser)
     │       ← CẬP NHẬT SESSION vì password trong session đã cũ
     │  systemLogDAO.create(CHANGE_PASSWORD)
     │       ▼
     │  forward change-password.jsp (thành công)
     └───────┘
```

---

## 8. Nhật ký hệ thống (SystemLogs)

**Các action được ghi:**

| Action | Khi nào | Ai thực hiện |
|--------|---------|-------------|
| `LOGIN` | Đăng nhập thành công | User đang đăng nhập |
| `LOGOUT` | Đăng xuất | User đang đăng xuất |
| `CREATE_USER` | Tạo tài khoản mới | Admin |
| `UPDATE_USER` | Sửa tài khoản | Admin |
| `DELETE_USER` | Xóa tài khoản | Admin |
| `TOGGLE_USER_STATUS` | Khóa/mở tài khoản | Admin |
| `RESET_PASSWORD` | Reset mật khẩu (quên mk) | User |
| `CHANGE_PASSWORD` | Đổi mật khẩu (đã login) | User |

**Cấu trúc SystemLog:**
```java
logId        // ID tự tăng
userId       // Ai làm (nullable → reset password không cần login)
username     // Từ JOIN Users
action       // Loại hành động
tableName    // Bảng bị ảnh hưởng: "Users"
recordId     // ID bản ghi: UserID
description  // Mô tả chi tiết bằng tiếng Việt
createdAt    // Thời điểm
```

**Dashboard hiển thị:** 8 log gần nhất  
**Trang log:** tối đa 100 log, hỗ trợ tìm kiếm theo action/description

---

## 9. Flash Message — Hiển thị thông báo sau redirect

```
Tạo user thành công
         │
         ▼
session.setAttribute("flash", "Đã tạo tài khoản ...")
         │
         ▼
redirect /admin/users
         │
         ▼
showList():
  Object flash = session.getAttribute("flash")
  if (flash != null) {
      request.setAttribute("flash", flash)  // chuyển sang request
      session.removeAttribute("flash")      // xóa ngay
  }
         │
         ▼
JSP đọc ${flash} → hiển thị thông báo
         │
         ▼
Refresh trang → thông báo biến mất (vì đã remove)
```

**Ưu điểm:** Thông báo hiển thị sau redirect, không hiển thị lại khi refresh trang.

---

## 10. Bảo mật — Các điểm đã xử lý

| Vấn đề | Cách xử lý | File |
|--------|-----------|------|
| SQL Injection | PreparedStatement với `?` placeholder | UserDAO.java |
| Null parameter | `setNullableInt()` kiểm tra null → setNull() | UserDAO.java |
| Admin không bị khóa | `roleId != 1` check trước toggle | UserServlet.toggleStatus() |
| Admin không bị xóa | `roleId != 1` check trước delete + kiểm tra chính mình | UserServlet.deleteUser() |
| Tài khoản bị khóa không login | `Status = 1` trong WHERE authenticate | UserDAO.authenticate() |
| Email case-insensitive | `LOWER()` khi so sánh email | UserDAO.findForPasswordReset() |
| Null Phone/Email | `ISNULL(col, '')` trong SQL | UserDAO.findForPasswordReset() |
| Chưa đăng nhập không truy cập /admin | AdminFilter kiểm tra session | AdminFilter.java |
| Tạo thêm Admin | Không cho tạo khi roleId = 1 (validate + JSP) | UserServlet + user-form.jsp |

---

## 11. Các file chính cần nắm

```
servlet/
├── AuthServlet.java          ← Đăng nhập, đăng xuất, quên mật khẩu
├── UserServlet.java          ← CRUD user + toggle status + delete
├── ChangePasswordServlet.java ← Đổi mật khẩu (khi đã login)
filter/
├── AuthFilter.java           ← Bảo vệ toàn bộ trang (chưa login → /login)
├── AdminFilter.java          ← Bảo vệ /admin/* (không phải Admin → 403)
dao/
├── UserDAO.java              ← Tất cả SQL thao tác Users
├── SystemLogDAO.java        ← Ghi và đọc nhật ký hệ thống
```
