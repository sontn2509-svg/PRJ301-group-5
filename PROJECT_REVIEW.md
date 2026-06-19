# 🍽️ KindergartenKitchen — Tài liệu dự án cho Review

> **Người review:** hihi15022020-spec  
> **Branch:** `quangnguyen`  
> **Framework:** Jakarta EE 6.0 + Maven + SQL Server

---

## 1. Tổng quan hệ thống

Đây là hệ thống **quản lý bếp ăn trường mầm non** (Kindergarten Canteen Management). Hệ thống theo dõi:

| Module | Mô tả |
|--------|--------|
| **Người dùng** | Đăng nhập, phân quyền, quản lý tài khoản |
| **Trẻ em** | Thông tin học sinh, lớp học, phụ huynh |
| **Bữa ăn** | Loại bữa (sáng, trưa, xế), món ăn, thực đơn |
| **Nguyên liệu** | Kho nguyên liệu, nhập kho, sử dụng hàng ngày |
| **Điểm danh** | Điểm danh học sinh |
| **Thông báo** | Hệ thống thông báo |

---

## 2. Vai trò & Quyền hạn

| ID | Vai trò | Quyền |
|----|---------|-------|
| 1 | **Admin** | Quản trị toàn bộ hệ thống |
| 2 | **Manager** | Quản lý thực đơn, nguyên liệu |
| 3 | **Teacher** | Điểm danh học sinh |
| 4 | **Parent** | Xem thực đơn, nhận thông báo |
| 5 | **KitchenStaff** | Xem/mở thực đơn, báo cáo sử dụng |

### Luồng đăng nhập (AuthServlet → `/login`)

```
Người dùng nhập username/password
         │
         ▼
   UserDAO.authenticate(username, password)
         │
    ┌────┴────┐
    │ match?  │
    └────┬────┘
   Sai     ┌───✓───┐
    │      │       │
  Về      │ Status == 1?  ── Không ──► role-waiting.jsp
 login.jsp│       │                    (Chờ duyệt / Bị khóa)
          │ Có    │
          └───────┼─────────────────────────┐
                  │                           │
           roleName == Admin?                 │
            ┌────┬┴────┐                      │
            │ Có │ Không                      │
            ▼     ▼                           │
   /admin/dashboard              role-waiting.jsp ◄─┘
```

### Bảo mật (Filter)

- **AuthFilter** (`/*`): Kiểm tra `authUser` trong session. Không có → redirect `/login`.
- **AdminFilter** (`/admin/*`): Chỉ `roleName == "Admin"` được vào. Sai → HTTP 403.

> **Lưu ý:** Tài khoản Admin (roleId=1) **không thể bị khóa** bằng nút toggle trên giao diện. Cả backend (`UserServlet.toggleStatus()`) lẫn frontend (`user-list.jsp`) đều đã chặn.

---

## 3. Cấu trúc thư mục

```
src/main/
├── java/
│   ├── servlet/          ← Xử lý request/response
│   │   ├── AuthServlet.java        POST /login, /logout, /forgot-password
│   │   ├── UserServlet.java        CRUD user + toggle status
│   │   ├── AdminServlet.java       Dashboard + xem log
│   │   └── ChangePasswordServlet.java  Đổi mật khẩu
│   │
│   ├── model/            ← Đối tượng dữ liệu (POJO)
│   │   ├── User.java
│   │   ├── Role.java
│   │   └── SystemLog.java
│   │
│   ├── dao/              ← Giao tiếp database (JDBC)
│   │   ├── UserDAO.java
│   │   ├── RoleDAO.java
│   │   └── SystemLogDAO.java
│   │
│   ├── filter/           ← Bộ lọc request
│   │   ├── AuthFilter.java
│   │   └── AdminFilter.java
│   │
│   └── config/            ← Tiện ích + kết nối DB
│       ├── DBConnection.java
│       └── ServletUtils.java
│
├── resources/
│   └── db.properties      ← Cấu hình kết nối SQL Server
│
└── webapp/
    ├── META-INF/context.xml
    ├── WEB-INF/web.xml
    ├── css/style.css
    ├── js/auth.js
    └── jsp/
        ├── layout/       ← sidebar, header, footer (dùng chung)
        │   ├── sidebar.jsp
        │   ├── header.jsp
        │   └── footer.jsp
        └── auth/         ← Trang liên quan auth
            ├── login.jsp
            ├── forgot-password.jsp
            ├── change-password.jsp
            ├── role-waiting.jsp
            ├── dashboard.jsp
            ├── user-list.jsp
            ├── user-form.jsp
            └── log-list.jsp
```

---

## 4. Database Schema (SQL Server)

### Bảng `Roles`
| Column | Kiểu | Ghi chú |
|--------|------|---------|
| `RoleID` | INT | PK, AUTO_INCREMENT |
| `RoleName` | NVARCHAR(50) | Admin, Manager, Teacher, Parent, KitchenStaff |

### Bảng `Users`
| Column | Kiểu | Ghi chú |
|--------|------|---------|
| `UserID` | INT | PK |
| `Username` | VARCHAR(50) | UNIQUE |
| `Password` | VARCHAR(255) | **Chưa mã hóa** ⚠️ |
| `FullName` | NVARCHAR(100) | |
| `Email` | VARCHAR(100) | |
| `Phone` | VARCHAR(20) | |
| `RoleID` | INT | FK → Roles |
| `Status` | INT | 0=Chờ duyệt, 1=Hoạt động, 2=Bị khóa |
| `CreatedAt` | DATETIME | |

### Bảng `SystemLogs`
| Column | Kiểu |
|--------|------|
| `LogID` | INT |
| `UserID` | INT (nullable) |
| `Action` | NVARCHAR(100) |
| `TableName` | NVARCHAR(100) |
| `RecordID` | INT |
| `Description` | NVARCHAR(500) |
| `CreatedAt` | DATETIME |

---

## 5. Các luồng chính (code flow)

### 5.1. CRUD User

```
/admin/users (GET)  ──► showList()
    │  ├─ userDAO.search(keyword, roleId, status) → list<User>
    │  ├─ roleDAO.findAll() → list<Role>
    │  └─ forward → user-list.jsp

/admin/users/create (GET)  ──► showCreateForm() → user-form.jsp

/admin/users/create (POST)  ──► createUser()
    │  ├─ readForm(request)
    │  ├─ validate()
    │  ├─ userDAO.create(form) → int newId
    │  ├─ systemLogDAO.create(LOG)
    │  └─ redirect /admin/users

/admin/users/edit (GET)  ──► showEditForm(id)
    │  ├─ userDAO.findById(id)
    │  └─ forward → user-form.jsp

/admin/users/edit (POST)  ──► updateUser()
    │  ├─ readForm(request)
    │  ├─ validate()
    │  ├─ userDAO.update(form, changePassword)
    │  ├─ systemLogDAO.create(LOG)
    │  └─ redirect /admin/users

/admin/users/toggle (GET)  ──► toggleStatus()
    │  ├─ userDAO.findById(id)
    │  ├─ userDAO.toggleStatus(id)     ← KHÔNG chạy nếu roleId == 1
    │  ├─ systemLogDAO.create(LOG)
    │  └─ redirect /admin/users
```

### 5.2. Quên mật khẩu

```
POST /forgot-password
    ├─ Đọc username, email, phone từ form
    ├─ userDAO.findForPasswordReset(username, email, phone)
    │      → Tìm user khớp cả 3 trường
    ├─ userDAO.resetPassword(userId, newPassword)
    ├─ systemLogDAO.create(RESET_PASSWORD)
    └─ redirect /login
```

### 5.3. Đổi mật khẩu (khi đã đăng nhập)

```
POST /admin/change-password
    ├─ Lấy currentPassword từ form
    ├─ So sánh với DB (UserDAO.authenticate)
    ├─ userDAO.resetPassword(userId, newPassword)
    ├─ Cập nhật session authUser
    ├─ systemLogDAO.create(CHANGE_PASSWORD)
    └─ redirect /admin/change-password (với flash success)
```

---

## 6. Các lớp chính — Vai trò chi tiết

### 6.1. UserDAO — Tất cả thao tác User trên DB

| Phương thức | SQL tương ứng |
|---|---|
| `authenticate(u, p)` | `SELECT * FROM Users WHERE Username=? AND Password=? AND Status=1` |
| `search(kw, roleId, status)` | `SELECT ... WHERE (kw IS NULL OR ...) AND (roleId IS NULL OR ...) AND ...` |
| `findById(id)` | `SELECT * FROM Users WHERE UserID=?` |
| `create(user)` | `INSERT INTO Users (Username, Password, FullName, Email, Phone, RoleID, Status)` |
| `update(user, changePwd)` | `UPDATE Users SET FullName=?, Email=?, Phone=?, RoleID=?, Status=? [+ Password]` |
| `toggleStatus(id)` | `UPDATE Users SET Status = CASE WHEN Status=1 THEN 2 ELSE 1 END` |
| `resetPassword(id, pwd)` | `UPDATE Users SET Password=? WHERE UserID=?` |
| `countAll/Active/Blocked/Pending()` | `SELECT COUNT(*) FROM Users WHERE Status=?` |

### 6.2. SystemLogDAO — Ghi nhận hành động

Mỗi servlet ghi log khi có thao tác quan trọng. Các action được ghi:

| Action | Khi nào |
|--------|---------|
| `LOGIN` | Đăng nhập thành công |
| `LOGOUT` | Đăng xuất |
| `CREATE_USER` | Tạo tài khoản mới |
| `UPDATE_USER` | Cập nhật tài khoản |
| `TOGGLE_USER_STATUS` | Khóa/mở khóa tài khoản |
| `CHANGE_PASSWORD` | Đổi mật khẩu (khi đã login) |
| `RESET_PASSWORD` | Reset mật khẩu (quên mk) |

### 6.3. AuthFilter & AdminFilter

```
Request đến server
       │
       ▼
AuthFilter.doFilter()
       │
  Public resource? (/login, /forgot-password, /assets/*)
       │
  ┌────┴────┐
  │  Có    │ Không
  ▼        ▼
 Pass    Có authUser trong session?
              │
         ┌────┴────┐
         │  Có     │ Không
         ▼         ▼
     Pass      redirect /login

Request đến /admin/*
       │
AdminFilter.doFilter()
       │
  Có authUser && roleName == "Admin"?
       │
  ┌────┴────┐
  │  Có     │ Không
  ▼         ▼
 Pass    sendError(403)
```

---

## 7. Điểm cần lưu ý cho buổi Review

### ⚠️ Điểm yếu bảo mật (đã biết)

1. **Password lưu plain text** — nên dùng BCrypt/Argon2 hash trước khi lưu DB.
2. **Không có giới hạn đăng nhập** — brute force không bị chặn.
3. **Không có CSRF token** — form có thể bị replay attack.
4. **Không có rate limit** trên `/forgot-password`.

### ✅ Điểm tốt

1. **Phân quyền rõ ràng** bằng Filter, dễ mở rộng.
2. **SystemLog đầy đủ** — mọi thao tác quan trọng đều được ghi nhận.
3. **Validate form đầy đủ** ở cả backend (Servlet) lẫn frontend (JSP).
4. **Tài khoản Admin không thể bị khóa** (đã fix).
5. **Tách biệt rõ ràng** Model / DAO / Servlet / View.

### 📋 Checklist cho reviewer

- [ ] Đăng nhập với tài khoản Admin → vào dashboard bình thường
- [ ] Đăng nhập với tài khoản Manager/Teacher → hiện trang "Chờ duyệt"
- [ ] Đăng nhập sai password → hiện lỗi trên login.jsp
- [ ] Tài khoản bị khóa (status=2) → không đăng nhập được
- [ ] Tạo user mới → user xuất hiện trong danh sách
- [ ] Sửa user → thông tin cập nhật đúng
- [ ] Toggle khóa user (không phải Admin) → status đổi 1↔2
- [ ] Toggle khóa user Admin → **không có gì xảy ra** (đã protected)
- [ ] Xem log trong dashboard → thấy các bản ghi SystemLog
- [ ] Đổi mật khẩu → mật khẩu mới hoạt động
- [ ] Quên mật khẩu (đúng username+email+phone) → reset được
- [ ] Quên mật khẩu (sai thông tin) → báo lỗi, không reset

---

## 8. Thông tin kết nối

| Thành phần | Giá trị |
|-----------|---------|
| Database | SQL Server |
| Config file | `src/main/resources/db.properties` |
| JNDI context | `java:comp/env/jdbc/KindergartenKitchen` |
| Context file | `src/main/webapp/META-INF/context.xml` |
| Database script | `database/KindergartenKitchen.sql` |
