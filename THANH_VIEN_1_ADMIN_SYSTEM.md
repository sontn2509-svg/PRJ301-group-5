# Thành viên 1 - Auth, Admin, Hệ thống

## Đã đổi theo form thống nhất của nhóm

- Package Java đã đổi thành:
  - `config`
  - `model`
  - `dao`
  - `servlet`
  - `filter`
  - `service`
- JSP đã chuyển về:
  - `src/main/webapp/jsp/layout`
  - `src/main/webapp/jsp/auth`
- CSS đã chuyển về:
  - `src/main/webapp/css/style.css`
- JS đã chuyển về:
  - `src/main/webapp/js/auth.js`
- Database đã đặt tại:
  - `database/KindergartenKitchen.sql`

## File thành viên 1 phụ trách

- `config/DBConnection.java`
- `config/ServletUtils.java`
- `model/User.java`
- `model/Role.java`
- `model/SystemLog.java`
- `dao/UserDAO.java`
- `dao/RoleDAO.java`
- `dao/SystemLogDAO.java`
- `servlet/AuthServlet.java`
- `servlet/AdminServlet.java`
- `servlet/UserServlet.java`
- `filter/AuthFilter.java`
- `filter/AdminFilter.java`
- `webapp/jsp/layout/header.jsp`
- `webapp/jsp/layout/sidebar.jsp`
- `webapp/jsp/layout/footer.jsp`
- `webapp/jsp/auth/login.jsp`
- `webapp/jsp/auth/forgot-password.jsp`
- `webapp/jsp/auth/role-waiting.jsp`
- `webapp/jsp/auth/dashboard.jsp`
- `webapp/jsp/auth/user-list.jsp`
- `webapp/jsp/auth/user-form.jsp`
- `webapp/jsp/auth/log-list.jsp`
- `webapp/css/style.css`
- `webapp/js/auth.js`

## Chức năng thành viên 1 đã có

- Đăng nhập cho tất cả role.
- Đăng xuất.
- Quên mật khẩu/lấy lại mật khẩu bằng username, email, số điện thoại.
- Session đăng nhập.
- Filter chặn request chưa đăng nhập.
- Filter chặn quyền Admin.
- Dashboard Admin.
- Quản lý tài khoản:
  - danh sách,
  - lọc theo keyword, role, trạng thái,
  - tạo tài khoản,
  - sửa tài khoản,
  - đổi mật khẩu trong form sửa,
  - khóa/mở khóa tài khoản,
  - phân quyền role.
- Xem System Logs.
- Ghi log khi login, logout, reset password, tạo/sửa/khóa/mở khóa tài khoản.

## Lưu ý khi ghép nhóm

- Thành viên khác có thể dùng lại `config.DBConnection`.
- Khi thêm module mới, tạo file trong đúng package theo form nhóm.
- Các JSP của P2, P3, P4 nên đặt vào `jsp/menu`, `jsp/attendance`, `jsp/ingredient`.
- Vì dùng Tomcat 10.1 nên tất cả Servlet phải dùng `jakarta.servlet.*`, không dùng `javax.servlet.*`.
