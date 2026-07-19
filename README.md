# 🍳 Kindergarten Kitchen Management System

> Hệ thống quản lý bếp ăn toàn diện dành cho các trường mầm non và mẫu giáo, giúp tối ưu hóa thực đơn, định lượng nguyên liệu và đồng bộ thông tin giữa nhà trường, phụ huynh và nhà bếp.

---

## 📌 Các Tính Năng Chính

*   **Lên thực đơn linh hoạt:** Quản lý và lên menu dự kiến theo tuần cho từng bữa (sáng, trưa, xế...). Hỗ trợ phân loại menu riêng biệt cho từng cấp học (nhà trẻ, mẫu giáo).
*   **Điểm danh & Báo suất ăn:** Quản lý danh sách trẻ đi học để tính toán số lượng suất ăn phù hợp theo thời gian thực (hỗ trợ chốt sổ báo nghỉ trước 7h sáng).
*   **Quản lý kho & Định lượng nguyên liệu:** Tự động tính toán lượng nguyên liệu cần mua dựa trên thực đơn và số trẻ đi học, hạn chế tối đa việc thừa/thiếu thực phẩm.
*   **Đồng bộ đa bên:** Phụ huynh theo dõi thực đơn/báo nghỉ, Giáo viên điểm danh, Nhân viên bếp cập nhật nhập xuất nguyên liệu, và Admin quản trị toàn bộ hệ thống.

---

## 🛠️ Công Nghệ & Công Cụ Sử Dụng

Dự án được xây dựng dựa trên mô hình MVC vững chắc bằng các công nghệ Java Web tiêu chuẩn:

| Thành phần | Công nghệ sử dụng |
| :--- | :--- |
| **Backend** | Java 17, Servlet, JSP |
| **Database** | SQL Server (MSSQL JDBC Driver) |
| **Build Tool** | Apache Maven |
| **IDE & Tools** | NetBeans IDE, Git / GitHub |
| **Frontend** | HTML5, CSS3, JavaScript, Bootstrap (JSTL Tags) |

---

## 📸 Hình Ảnh Giao Diện Gốc (Screenshots)

*Dưới đây là một số hình ảnh thực tế trực quan của hệ thống khi vận hành:*

### 1. Trang Dashboard / Quản lý Thực Đơn (Manager)
![Menu Management](https://raw.githubusercontent.com/sontn2509-svg/PRJ301-group-5/sonstudy_branch/database/screenshot1.png)

### 2. Trang Quản lý Nguyên Liệu & Kho (Kitchen Staff)
![Ingredients Management](https://raw.githubusercontent.com/sontn2509-svg/PRJ301-group-5/sonstudy_branch/database/screenshot2.png)

### 3. Giao diện Điểm Danh Lớp Học (Teacher)
![Attendance](https://raw.githubusercontent.com/sontn2509-svg/PRJ301-group-5/sonstudy_branch/database/screenshot3.png)

---

## 🚀 Hướng Dẫn Cài Đặt và Chạy Dự Án

### 1. Yêu cầu hệ thống
*   Máy tính đã cài đặt **JDK 17 (Default)**.
*   NetBeans IDE phiên bản hỗ trợ Maven / Java EE.
*   Đã cấu hình một Web Server (Apache Tomcat hoặc GlassFish).
*   Microsoft SQL Server để chạy database.

### 2. Các bước thiết lập và chạy
1. Clone dự án về máy:
   ```bash
   git clone [https://github.com/sontn2509-svg/PRJ301-group-5.git](https://github.com/sontn2509-svg/PRJ301-group-5.git)
