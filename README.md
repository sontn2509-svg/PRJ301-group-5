# KindergartenKitchen - Project NetBeans chung của nhóm

Stack: Java Web Application, JDK 17, Tomcat 10.1, SQL Server 2022, JSP/Servlet/DAO.

## Cấu trúc đã đổi theo form nhóm

- `src/main/java/config`: cấu hình dùng chung, gồm `DBConnection.java`.
- `src/main/java/model`: POJO/entity.
- `src/main/java/dao`: truy vấn database.
- `src/main/java/servlet`: controller servlet.
- `src/main/java/filter`: filter kiểm tra đăng nhập/phân quyền.
- `src/main/java/service`: service cho logic phức tạp, để trống cho thành viên khác.
- `src/main/webapp/css/style.css`: CSS chung.
- `src/main/webapp/js/auth.js`: JS module Auth/Admin.
- `src/main/webapp/jsp/layout`: header, sidebar, footer.
- `src/main/webapp/jsp/auth`: toàn bộ JSP của thành viên 1.
- `database/KindergartenKitchen.sql`: database chung.

## Phần thành viên 1 đã làm

- `servlet/AuthServlet.java`: đăng nhập, đăng xuất, quên mật khẩu/lấy lại mật khẩu.
- `servlet/AdminServlet.java`: dashboard Admin và System Logs.
- `servlet/UserServlet.java`: danh sách, tạo, sửa, khóa/mở khóa tài khoản.
- `filter/AuthFilter.java`: chặn request chưa đăng nhập.
- `filter/AdminFilter.java`: chỉ Admin được vào `/admin/*`.
- `dao/UserDAO.java`, `RoleDAO.java`, `SystemLogDAO.java`.
- `model/User.java`, `Role.java`, `SystemLog.java`.

## Cách chạy trên NetBeans + Tomcat 10.1 + SQL Server 2022

1. Chạy file `database/KindergartenKitchen.sql` trong SQL Server 2022.
2. Sửa `src/main/resources/db.properties` theo SQL Server của máy bạn.
3. Mở project trong NetBeans.
4. Chọn server Tomcat 10.1.
5. Run project.

Tài khoản test:

```text
admin / 123456
```

## URL chính

- `/login`
- `/forgot-password`
- `/logout`
- `/admin/dashboard`
- `/admin/users`
- `/admin/users/create`
- `/admin/users/edit?id=1`
- `/admin/users/toggle?id=1`
- `/admin/logs`
