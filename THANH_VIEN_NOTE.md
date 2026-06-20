# HƯỚNG DẪN CHO THÀNH VIÊN 2, 3, 4

## THÀNH VIÊN 2 - Manager + Kitchen Ingredients

### Trách nhiệm:
1. **Manager Dashboard** - Quản lý toàn bộ hệ thống
2. **Kitchen Ingredients** - Quản lý nguyên liệu cho bếp

### Các trang cần code trong `jsp/manager/`:
- `classes.jsp` - Quản lý Lớp học (CRUD)
- `students.jsp` - Quản lý Học sinh (CRUD)
- `attendance.jsp` - Điểm danh hàng ngày
- `ingredients.jsp` - Quản lý Nguyên liệu (CRUD)
- `meals.jsp` - Lịch sử các bữa ăn đã nấu

### Các trang cần code trong `jsp/kitchen/`:
- `meal-count.jsp` - Số suất ăn cần chuẩn bị theo ngày
- `meal-history.jsp` - Lịch sử các bữa ăn đã nấu
- `ingredients.jsp` - Nguyên liệu cần chuẩn bị

### DAO/Model cần tạo trong `src/main/java/`:
- `dao/ClassDAO.java`
- `dao/StudentDAO.java`
- `dao/AttendanceDAO.java`
- `dao/IngredientDAO.java`
- `dao/MealDAO.java`
- `model/Class.java`
- `model/Student.java`
- `model/Attendance.java`
- `model/Ingredient.java`
- `model/Meal.java`

---

## THÀNH VIÊN 3 - Teacher (Giáo viên)

### Trách nhiệm:
Quản lý lớp học và điểm danh cho học sinh

### Các trang cần code trong `jsp/teacher/`:
- `my-class.jsp` - Xem thông tin lớp học được phân công
- `attendance.jsp` - Điểm danh hàng ngày cho học sinh
- `absences.jsp` - Gửi yêu cầu xin nghỉ ăn cho học sinh

### DAO/Model cần tạo:
- `dao/TeacherDAO.java` - Lấy lớp được phân công
- `dao/StudentDAO.java` - Lấy danh sách học sinh trong lớp
- `dao/AbsenceDAO.java` - Quản lý yêu cầu nghỉ ăn
- `model/Absence.java` - Model cho bảng nghỉ phép

---

## THÀNH VIÊN 4 - Parent (Phụ huynh)

### Trách nhiệm:
Theo dõi tình hình ăn uống của con em mình

### Các trang cần code trong `jsp/parent/`:
- `my-children.jsp` - Xem thông tin con em đang theo học
- `absences.jsp` - Gửi yêu cầu xin nghỉ ăn cho con
- `history.jsp` - Xem lịch sử ăn uống của con

### DAO cần tạo:
- `dao/ParentDAO.java` - Lấy danh sách con của phụ huynh
- `dao/MealHistoryDAO.java` - Lấy lịch sử ăn uống

---

## CẬP NHẬT SERVLET

Các Servlet đã có sẵn route, các bạn chỉ cần thêm xử lý POST:

### `ManagerServlet.java`
```java
// Thêm xử lý POST cho các chức năng CRUD
@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) {
    String pathInfo = request.getPathInfo();
    // Xử lý: /classes (add/update/delete), /students, /attendance, /ingredients, /meals
}
```

### `TeacherServlet.java`
```java
@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) {
    String pathInfo = request.getPathInfo();
    // Xử lý: /attendance (điểm danh), /absences (gửi yêu cầu)
}
```

### `ParentServlet.java`
```java
@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) {
    String pathInfo = request.getPathInfo();
    // Xử lý: /absences (gửi yêu cầu nghỉ ăn cho con)
}
```

---

## CẤU TRÚC THƯ MỤC

```
src/main/
├── java/
│   ├── servlet/
│   │   ├── ManagerServlet.java    ← thêm POST handler
│   │   ├── TeacherServlet.java    ← thêm POST handler
│   │   ├── ParentServlet.java     ← thêm POST handler
│   │   └── KitchenServlet.java    ← thêm POST handler
│   ├── dao/                       ← TẠO MỚI
│   │   ├── ClassDAO.java
│   │   ├── StudentDAO.java
│   │   ├── AttendanceDAO.java
│   │   ├── IngredientDAO.java
│   │   ├── MealDAO.java
│   │   ├── AbsenceDAO.java
│   │   ├── TeacherDAO.java
│   │   ├── ParentDAO.java
│   │   └── MealHistoryDAO.java
│   └── model/                     ← TẠO MỚI
│       ├── Class.java
│       ├── Student.java
│       ├── Attendance.java
│       ├── Ingredient.java
│       ├── Meal.java
│       └── Absence.java
└── webapp/
    └── jsp/
        ├── manager/               ← Đã có placeholder
        │   ├── dashboard-manager.jsp
        │   ├── classes.jsp        ← CODE
        │   ├── students.jsp       ← CODE
        │   ├── attendance.jsp     ← CODE
        │   ├── ingredients.jsp    ← CODE
        │   ├── meals.jsp          ← CODE
        │   └── change-password.jsp
        ├── teacher/               ← Đã có placeholder
        │   ├── dashboard-teacher.jsp
        │   ├── my-class.jsp       ← CODE
        │   ├── attendance.jsp     ← CODE
        │   ├── absences.jsp       ← CODE
        │   └── change-password.jsp
        ├── parent/                ← Đã có placeholder
        │   ├── dashboard-parent.jsp
        │   ├── my-children.jsp    ← CODE
        │   ├── absences.jsp       ← CODE
        │   ├── history.jsp         ← CODE
        │   └── change-password.jsp
        └── kitchen/               ← Đã có placeholder
            ├── dashboard-kitchen.jsp
            ├── meal-count.jsp      ← CODE
            ├── meal-history.jsp    ← CODE
            ├── ingredients.jsp     ← CODE
            └── change-password.jsp
```

---

## CHỨC NĂNG CHI TIẾT

### 1. Quản lý Lớp học (Manager)
- Thêm lớp mới (tên lớp, sĩ số, giáo viên chủ nhiệm)
- Sửa thông tin lớp
- Xóa lớp
- Xem danh sách lớp

### 2. Quản lý Học sinh (Manager)
- Thêm học sinh (tên, ngày sinh, lớp, phụ huynh)
- Sửa thông tin học sinh
- Xóa học sinh
- Xem danh sách học sinh

### 3. Điểm danh (Manager/Teacher)
- Chọn ngày điểm danh
- Chọn lớp
- Đánh dấu học sinh: Có mặt / Vắng mặt / Nghỉ ăn
- Lưu điểm danh hàng ngày

### 4. Quản lý Nguyên liệu (Manager)
- Thêm nguyên liệu (tên, đơn vị, số lượng tồn kho)
- Sửa thông tin nguyên liệu
- Xóa nguyên liệu
- Cập nhật số lượng tồn kho

### 5. Số suất ăn (Kitchen)
- Xem tổng số suất ăn cần chuẩn bị (dựa vào điểm danh)
- Phân chia theo từng lớp

### 6. Lịch sử bếp (Kitchen/Manager)
- Xem danh sách các bữa ăn đã nấu
- Xem chi tiết từng bữa ăn (ngày, món ăn, số suất)

### 7. Xin nghỉ ăn (Teacher/Parent)
- Chọn học sinh
- Chọn ngày nghỉ
- Gửi yêu cầu (lý do nghỉ)
- Xem/duyệt yêu cầu nghỉ

### 8. Lịch sử ăn của con (Parent)
- Xem danh sách bữa ăn của con theo ngày
- Xem tình trạng: Ăn / Nghỉ / Vắng

---

## LƯU Ý

1. Các Servlet đã có routing, chỉ cần thêm xử lý logic
2. Cần tạo DAO để truy vấn database
3. Có thể cần tạo thêm Model class cho các bảng mới
4. Tham khảo code trong `AuthServlet.java` và `AdminServlet.java` để biết cách xử lý
5. Database schema cần được cập nhật nếu chưa có các bảng cần thiết
