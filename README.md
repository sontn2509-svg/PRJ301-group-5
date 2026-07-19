# 🍳 Kindergarten Kitchen Management System

<p align="center">
  <img src="https://img.shields.io/badge/Java-17-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white" alt="Java 17" />
  <img src="https://img.shields.io/badge/Servlet%20%26%20JSP-Jakarta-007396?style=for-the-badge&logo=java&logoColor=white" alt="Servlet JSP" />
  <img src="https://img.shields.io/badge/MSSQL%20Server-Database-CC292B?style=for-the-badge&logo=microsoft-sql-server&logoColor=white" alt="SQL Server" />
  <img src="https://img.shields.io/badge/Apache%20Maven-Build-C71A36?style=for-the-badge&logo=apache-maven&logoColor=white" alt="Maven" />
  <img src="https://img.shields.io/badge/Bootstrap-v5.3-7952B3?style=for-the-badge&logo=bootstrap&logoColor=white" alt="Bootstrap" />
</p>

> 💡 **Hệ thống quản lý bếp ăn toàn diện dành cho các trường mầm non và mẫu giáo.** Giúp tối ưu hóa thực đơn, tự động định lượng nguyên liệu và đồng bộ thông tin thông minh giữa Nhà trường, Phụ huynh và Bộ phận nhà bếp.

---

## 📌 🌟 Các Tính Năng Nổi Bật

*   📋 **Lên thực đơn linh hoạt:** Quản lý và lên menu dự kiến theo tuần cho từng bữa (sáng, trưa, xế...). Hỗ trợ phân loại menu riêng biệt cho từng cấp học (nhà trẻ, mẫu giáo).
*   ⏱️ **Điểm danh & Báo suất ăn real-time:** Quản lý danh sách trẻ đi học để tính toán số lượng suất ăn phù hợp theo thời gian thực (tự động khóa sổ báo nghỉ sau 7h sáng).
*   📊 **Quản lý kho & Tự động định lượng:** Tự động tính toán chi tiết lượng nguyên liệu cần mua dựa trên công thức món ăn và số trẻ đi học thực tế, hạn chế tối đa việc thừa/thiếu thực phẩm.
*   🤝 **Đồng bộ tương tác đa bên:** 
    *   *Phụ huynh:* Theo dõi thực đơn hằng ngày, báo nghỉ học trực tuyến.
    *   *Giáo viên:* Điểm danh học sinh nhanh chóng.
    *   *Nhân viên bếp:* Quản lý kho, cập nhật nhập/xuất thực phẩm tiện lợi.
    *   *Admin:* Điều hành, phân quyền và quản trị toàn bộ hệ thống.

---

## 🛠️ 🎨 Hệ Sinh Thái Công Nghệ

Dự án được triển khai theo kiến trúc **MVC (Model-View-Controller)** chuẩn mực, đảm bảo tính mở rộng và dễ bảo trì:

| Thành phần | Công nghệ & Công cụ | Trạng thái hiển thị |
| :--- | :--- | :--- |
| **☕ Backend** | Java 17, Servlet API, JSP | `Active` |
| **🗄️ Database** | Microsoft SQL Server (JDBC Driver) | `Connected` |
| **📦 Build Tool** | Apache Maven | `Stable` |
| **💻 Frontend** | HTML5, CSS3, JavaScript, Bootstrap 5, JSTL Tags | `Responsive` |
| **🛠️ IDE & VCS** | NetBeans IDE, Git / GitHub | `Managed` |

---

## 📸 💎 Hình Ảnh Giao Diện Thực Tế

> 🖼️ *Dưới đây là một số hình ảnh trực quan sinh động của hệ thống khi vận hành thực tế trên trình duyệt:*

### 🍱 1. Trang Dashboard / Quản lý Thực Đơn (Manager View)
![Menu Management](https://raw.githubusercontent.com/sontn2509-svg/PRJ301-group-5/sonstudy_branch/database/screenshot1.png)

### 🥬 2. Trang Quản lý Nguyên Liệu & Kho Số Lượng (Kitchen Staff)
![Ingredients Management](https://raw.githubusercontent.com/sontn2509-svg/PRJ301-group-5/sonstudy_branch/database/screenshot2.png)

### 🎒 3. Giao diện Điểm Danh Học Sinh Đầu Ngày (Teacher View)
![Attendance](https://raw.githubusercontent.com/sontn2509-svg/PRJ301-group-5/sonstudy_branch/database/screenshot3.png)

---

## 🚀 ⚡ Hướng Dẫn Cài Đặt & Khởi Chạy Nhanh

### 🧱 1. Yêu cầu môi trường
*   Cài đặt **JDK 17 (Mặc định)** trên máy tính.
*   Sử dụng **NetBeans IDE** phiên bản hỗ trợ tốt Maven.
*   Môi trường máy chủ Web **Apache Tomcat** hoặc **GlassFish**.
*   Hệ quản trị cơ sở dữ liệu **Microsoft SQL Server**.

### 🔧 2. Các bước triển khai chi tiết
1.  **Tải mã nguồn về máy local:**
    ```bash
    git clone [https://github.com/sontn2509-svg/PRJ301-group-5.git](https://github.com/sontn2509-svg/PRJ301-group-5.git)
    ```
2.  **Khởi tạo Cơ sở dữ liệu:**
    *   Mở công cụ **SSMS (SQL Server Management Studio)**.
    *   Tạo một cơ sở dữ liệu mới (Ví dụ tên: `KindergartenKitchen`).
    *   Mở và chạy file script `.sql` nằm trong thư mục `/database` để tự động khởi tạo các bảng dữ liệu và nạp dữ liệu demo ban đầu.
    *   *Lưu ý:* Hãy nhớ vào file cấu hình kết nối database trong code (ví dụ `DBContext.java`) để cập nhật lại `username` và `password` tài khoản SQL của bạn.
3.  **Biên dịch & Chạy dự án:**
    *   Mở NetBeans, chọn **Open Project** và chọn thư mục chứa dự án vừa sao chép.
    *   Nhấp chuột phải vào tên dự án, chọn **Clean and Build** để kích hoạt Maven tự động tải toàn bộ thư viện dependencies cần thiết về máy.
    *   Sau khi build hoàn tất, nhấp chuột phải chọn **Run** để khởi chạy server và trải nghiệm hệ thống bếp ăn mầm non ngay trên trình duyệt của bạn! 🎉
