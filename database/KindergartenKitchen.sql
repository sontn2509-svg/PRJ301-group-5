CREATE DATABASE KindergartenKitchen;
GO

USE KindergartenKitchen;
GO

-- =====================================================
-- 1. ROLES
-- Lưu vai trò người dùng trong hệ thống
-- =====================================================
CREATE TABLE Roles (
    RoleID INT PRIMARY KEY IDENTITY(1,1),
    RoleName NVARCHAR(50) NOT NULL UNIQUE
);
GO

INSERT INTO Roles(RoleName) VALUES
('Admin'),
('Manager'),
('Teacher'),
('Parent'),
('KitchenStaff');
GO

-- =====================================================
-- 2. USERS
-- Lưu toàn bộ tài khoản đăng nhập:
-- Admin, Manager, Teacher, Parent, KitchenStaff
-- =====================================================
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    RoleID INT NOT NULL,
    Status INT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);
GO

-- Status:
-- 0 = Pending
-- 1 = Active
-- 2 = Blocked

INSERT INTO Users(Username, Password, FullName, Email, Phone, RoleID, Status)
VALUES
('admin', '123456', N'Quản trị viên', 'admin@gmail.com', '0900000000', 1, 1),
('manager01', '123456', N'Nguyễn Thị Quản Lý', 'manager@gmail.com', '0911111111', 2, 1),
('teacher01', '123456', N'Trần Thị Giáo Viên', 'teacher@gmail.com', '0922222222', 3, 1),
('parent01', '123456', N'Nguyễn Văn Phụ Huynh', 'parent@gmail.com', '0933333333', 4, 1),
('kitchen01', '123456', N'Lê Văn Bếp', 'kitchen@gmail.com', '0944444444', 5, 1);
GO

-- =====================================================
-- 3. LEVELS
-- Cấp học: Nhà trẻ, Mẫu giáo
-- Menu sẽ khác nhau theo từng cấp học
-- =====================================================
CREATE TABLE Levels (
    LevelID INT PRIMARY KEY IDENTITY(1,1),
    LevelName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255)
);
GO

INSERT INTO Levels(LevelName, Description)
VALUES
(N'Nhà trẻ', N'Dành cho nhóm trẻ nhỏ tuổi'),
(N'Mẫu giáo', N'Dành cho nhóm trẻ mẫu giáo');
GO

-- =====================================================
-- 4. CLASSES
-- Lớp học
-- Mỗi lớp thuộc một cấp học và có giáo viên phụ trách
-- =====================================================
CREATE TABLE Classes (
    ClassID INT PRIMARY KEY IDENTITY(1,1),
    ClassName NVARCHAR(50) NOT NULL,
    LevelID INT NOT NULL,
    TeacherID INT,
    Status BIT DEFAULT 1,

    FOREIGN KEY (LevelID) REFERENCES Levels(LevelID),
    FOREIGN KEY (TeacherID) REFERENCES Users(UserID)
);
GO

INSERT INTO Classes(ClassName, LevelID, TeacherID)
VALUES
(N'Nhà trẻ A', 1, 3),
(N'Mẫu giáo A', 2, 3);
GO

-- =====================================================
-- 5. STUDENTS
-- Lưu thông tin học sinh
-- ParentID liên kết với tài khoản phụ huynh
-- =====================================================
CREATE TABLE Students (
    StudentID INT PRIMARY KEY IDENTITY(1,1),
    StudentCode NVARCHAR(20) NOT NULL UNIQUE,
    StudentName NVARCHAR(100) NOT NULL,
    DateOfBirth DATE,
    Gender BIT,
    ClassID INT NOT NULL,
    ParentID INT,
    Status BIT DEFAULT 1,

    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID),
    FOREIGN KEY (ParentID) REFERENCES Users(UserID)
);
GO

-- Gender:
-- 1 = Nam
-- 0 = Nữ

INSERT INTO Students(StudentCode, StudentName, DateOfBirth, Gender, ClassID, ParentID)
VALUES
('STU001', N'Nguyễn Minh An', '2020-05-10', 1, 1, 4),
('STU002', N'Trần Bảo Ngọc', '2019-08-15', 0, 2, 4);
GO

-- =====================================================
-- 6. MEAL TYPES
-- Loại bữa ăn trong ngày
-- =====================================================
CREATE TABLE MealTypes (
    MealTypeID INT PRIMARY KEY IDENTITY(1,1),
    MealTypeName NVARCHAR(50) NOT NULL UNIQUE
);
GO

INSERT INTO MealTypes(MealTypeName)
VALUES
(N'Bữa sáng'),
(N'Bữa trưa'),
(N'Bữa xế');
GO

-- =====================================================
-- 7. DISHES
-- Danh sách món ăn
-- =====================================================
CREATE TABLE Dishes (
    DishID INT PRIMARY KEY IDENTITY(1,1),
    DishName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    Status BIT DEFAULT 1
);
GO

INSERT INTO Dishes(DishName, Description)
VALUES
(N'Cháo gà', N'Món cháo phù hợp cho trẻ nhỏ'),
(N'Cơm thịt kho', N'Món chính cho bữa trưa'),
(N'Canh rau ngót', N'Món canh rau'),
(N'Sữa chua', N'Món ăn bữa xế');
GO

-- =====================================================
-- 8. INGREDIENTS
-- Danh sách nguyên liệu trong kho
-- =====================================================
CREATE TABLE Ingredients (
    IngredientID INT PRIMARY KEY IDENTITY(1,1),
    IngredientName NVARCHAR(100) NOT NULL,
    Unit NVARCHAR(30) NOT NULL,
    QuantityInStock FLOAT DEFAULT 0,
    Status BIT DEFAULT 1
);
GO

INSERT INTO Ingredients(IngredientName, Unit, QuantityInStock)
VALUES
(N'Gạo', N'kg', 50),
(N'Thịt gà', N'kg', 20),
(N'Cà rốt', N'kg', 10),
(N'Thịt heo', N'kg', 25),
(N'Rau ngót', N'kg', 15),
(N'Sữa chua', N'hộp', 100);
GO

-- =====================================================
-- 9. DISH INGREDIENTS
-- Công thức món ăn
-- Mỗi món cần nguyên liệu gì, định lượng bao nhiêu cho 1 học sinh
-- =====================================================
CREATE TABLE DishIngredients (
    DishIngredientID INT PRIMARY KEY IDENTITY(1,1),
    DishID INT NOT NULL,
    IngredientID INT NOT NULL,
    QuantityPerStudent FLOAT NOT NULL,

    FOREIGN KEY (DishID) REFERENCES Dishes(DishID),
    FOREIGN KEY (IngredientID) REFERENCES Ingredients(IngredientID)
);
GO

INSERT INTO DishIngredients(DishID, IngredientID, QuantityPerStudent)
VALUES
(1, 1, 0.08),
(1, 2, 0.05),
(1, 3, 0.02),

(2, 1, 0.10),
(2, 4, 0.07),

(3, 5, 0.04),

(4, 6, 1);
GO

-- Ví dụ:
-- Cháo gà cần:
-- Gạo 0.08 kg / học sinh
-- Thịt gà 0.05 kg / học sinh
-- Cà rốt 0.02 kg / học sinh

-- =====================================================
-- 10. MENUS
-- Menu theo tuần và theo cấp học
-- =====================================================
CREATE TABLE Menus (
    MenuID INT PRIMARY KEY IDENTITY(1,1),
    LevelID INT NOT NULL,
    WeekStartDate DATE NOT NULL,
    WeekEndDate DATE NOT NULL,
    CreatedBy INT NOT NULL,
    Status BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (LevelID) REFERENCES Levels(LevelID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);
GO

INSERT INTO Menus(LevelID, WeekStartDate, WeekEndDate, CreatedBy)
VALUES
(1, '2026-05-25', '2026-05-31', 2),
(2, '2026-05-25', '2026-05-31', 2);
GO

-- =====================================================
-- 11. MENU DETAILS
-- Chi tiết menu theo ngày, bữa ăn, món ăn
-- =====================================================
CREATE TABLE MenuDetails (
    MenuDetailID INT PRIMARY KEY IDENTITY(1,1),
    MenuID INT NOT NULL,
    MenuDate DATE NOT NULL,
    MealTypeID INT NOT NULL,
    DishID INT NOT NULL,

    FOREIGN KEY (MenuID) REFERENCES Menus(MenuID),
    FOREIGN KEY (MealTypeID) REFERENCES MealTypes(MealTypeID),
    FOREIGN KEY (DishID) REFERENCES Dishes(DishID)
);
GO

INSERT INTO MenuDetails(MenuID, MenuDate, MealTypeID, DishID)
VALUES
(1, '2026-05-25', 1, 1),
(1, '2026-05-25', 3, 4),

(2, '2026-05-25', 2, 2),
(2, '2026-05-25', 2, 3),
(2, '2026-05-25', 3, 4);
GO

-- =====================================================
-- 12. ATTENDANCE
-- Điểm danh và báo nghỉ
-- Bảng này dùng để:
-- - Phụ huynh báo nghỉ
-- - Giáo viên điểm danh
-- - Bếp tính số suất ăn
-- - Xác định có tính tiền ăn hay không
-- =====================================================
CREATE TABLE Attendance (
    AttendanceID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT NOT NULL,
    AttendanceDate DATE NOT NULL,
    Status NVARCHAR(20) NOT NULL,
    ReportedBy INT,
    ReportedTime DATETIME DEFAULT GETDATE(),
    IsCharged BIT DEFAULT 1,
    ConfirmedBy INT,
    ConfirmedTime DATETIME,
    NotificationStatus NVARCHAR(20) DEFAULT 'Pending',
    Note NVARCHAR(255),

    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (ReportedBy) REFERENCES Users(UserID),
    FOREIGN KEY (ConfirmedBy) REFERENCES Users(UserID)
);
GO

-- Status:
-- Present = có mặt
-- Absent = nghỉ

-- IsCharged:
-- 1 = vẫn tính tiền ăn
-- 0 = không tính tiền ăn

-- NotificationStatus:
-- Pending = mới tạo, chưa gửi thông báo
-- Sent = đã gửi thông báo
-- Confirmed = đã xác nhận
-- Cancelled = đã hủy

INSERT INTO Attendance
(StudentID, AttendanceDate, Status, ReportedBy, IsCharged, ConfirmedBy, ConfirmedTime, NotificationStatus, Note)
VALUES
(1, '2026-05-25', 'Absent', 4, 0, 3, GETDATE(), 'Sent', N'Phụ huynh báo nghỉ trước 7h'),
(2, '2026-05-25', 'Present', 3, 1, 3, GETDATE(), 'Confirmed', N'Giáo viên điểm danh có mặt');
GO

-- =====================================================
-- 13. INGREDIENT IMPORTS
-- Nhập nguyên liệu vào kho
-- Đã nâng cấp thêm:
-- UnitPrice: giá nhập trên 1 đơn vị
-- TotalPrice: tổng tiền tự tính
-- SupplierName: nhà cung cấp
-- =====================================================
CREATE TABLE IngredientImports (
    ImportID INT PRIMARY KEY IDENTITY(1,1),
    IngredientID INT NOT NULL,
    Quantity FLOAT NOT NULL,
    UnitPrice DECIMAL(18,2) NOT NULL,
    TotalPrice AS (Quantity * UnitPrice),
    ImportDate DATE DEFAULT GETDATE(),
    SupplierName NVARCHAR(100),
    CreatedBy INT NOT NULL,
    Note NVARCHAR(255),

    FOREIGN KEY (IngredientID) REFERENCES Ingredients(IngredientID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);
GO

INSERT INTO IngredientImports
(IngredientID, Quantity, UnitPrice, ImportDate, SupplierName, CreatedBy, Note)
VALUES
(1, 20, 18000, '2026-05-25', N'Cửa hàng thực phẩm sạch A', 2, N'Nhập thêm gạo đầu tuần'),
(2, 10, 85000, '2026-05-25', N'Cửa hàng thịt sạch B', 2, N'Nhập thịt gà'),
(3, 5, 15000, '2026-05-25', N'Cửa hàng rau củ C', 2, N'Nhập cà rốt'),
(4, 8, 95000, '2026-05-25', N'Cửa hàng thịt sạch B', 2, N'Nhập thịt heo'),
(5, 6, 12000, '2026-05-25', N'Cửa hàng rau củ C', 2, N'Nhập rau ngót'),
(6, 100, 6000, '2026-05-25', N'Đại lý sữa D', 2, N'Nhập sữa chua');
GO

-- =====================================================
-- 14. INGREDIENT USAGES
-- Nguyên liệu đã sử dụng mỗi ngày
-- =====================================================
CREATE TABLE IngredientUsages (
    UsageID INT PRIMARY KEY IDENTITY(1,1),
    IngredientID INT NOT NULL,
    QuantityUsed FLOAT NOT NULL,
    UsageDate DATE DEFAULT GETDATE(),
    UpdatedBy INT NOT NULL,
    Note NVARCHAR(255),

    FOREIGN KEY (IngredientID) REFERENCES Ingredients(IngredientID),
    FOREIGN KEY (UpdatedBy) REFERENCES Users(UserID)
);
GO

INSERT INTO IngredientUsages(IngredientID, QuantityUsed, UpdatedBy, Note)
VALUES
(1, 5, 5, N'Dùng nấu bữa sáng và bữa trưa'),
(2, 3, 5, N'Dùng nấu cháo gà');
GO

-- =====================================================
-- 15. NOTIFICATIONS
-- Lưu nội dung thông báo
-- Ví dụ: thông báo phụ huynh báo nghỉ cho giáo viên và bếp
-- =====================================================
CREATE TABLE Notifications (
    NotificationID INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(200) NOT NULL,
    Message NVARCHAR(1000) NOT NULL,
    NotificationType NVARCHAR(50) NOT NULL,
    RelatedID INT,
    CreatedBy INT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    Status BIT DEFAULT 1,

    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);
GO

-- NotificationType ví dụ:
-- ABSENCE_REPORT
-- ATTENDANCE_UPDATE
-- INGREDIENT_IMPORT
-- INGREDIENT_USAGE
-- MENU_UPDATE
-- SYSTEM

INSERT INTO Notifications
(Title, Message, NotificationType, RelatedID, CreatedBy)
VALUES
(
    N'Thông báo nghỉ học',
    N'Học sinh Nguyễn Minh An được phụ huynh báo nghỉ ngày 2026-05-25. Cần cập nhật lại số lượng suất ăn.',
    'ABSENCE_REPORT',
    1,
    4
),
(
    N'Cập nhật nguyên liệu nhập kho',
    N'Quản lý đã nhập thêm nguyên liệu cho tuần mới.',
    'INGREDIENT_IMPORT',
    1,
    2
);
GO

-- =====================================================
-- 16. USER NOTIFICATIONS
-- Lưu thông báo gửi cho user nào, đã đọc hay chưa
-- =====================================================
CREATE TABLE UserNotifications (
    UserNotificationID INT PRIMARY KEY IDENTITY(1,1),
    NotificationID INT NOT NULL,
    UserID INT NOT NULL,
    IsRead BIT DEFAULT 0,
    ReadAt DATETIME,

    FOREIGN KEY (NotificationID) REFERENCES Notifications(NotificationID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
GO

-- Thông báo nghỉ học gửi cho Teacher, Manager, KitchenStaff
INSERT INTO UserNotifications(NotificationID, UserID, IsRead)
VALUES
(1, 3, 0),
(1, 2, 0),
(1, 5, 0),

(2, 2, 0),
(2, 5, 0);
GO

-- =====================================================
-- 17. SYSTEM LOGS
-- Nhật ký hệ thống
-- Lưu lại các hành động quan trọng
-- =====================================================
CREATE TABLE SystemLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT,
    Action NVARCHAR(100) NOT NULL,
    TableName NVARCHAR(100),
    RecordID INT,
    Description NVARCHAR(1000),
    CreatedAt DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
GO

INSERT INTO SystemLogs(UserID, Action, TableName, RecordID, Description)
VALUES
(1, 'CREATE_DATABASE_SAMPLE', 'Database', NULL, N'Tạo dữ liệu mẫu cho hệ thống'),
(4, 'REPORT_ABSENCE', 'Attendance', 1, N'Phụ huynh báo nghỉ cho học sinh Nguyễn Minh An ngày 2026-05-25'),
(2, 'IMPORT_INGREDIENT', 'IngredientImports', 1, N'Quản lý nhập thêm nguyên liệu đầu tuần'),
(5, 'USE_INGREDIENT', 'IngredientUsages', 1, N'Nhân viên bếp cập nhật nguyên liệu đã sử dụng');
GO

-- =====================================================
-- QUERY TEST 1:
-- Xem danh sách user và role
-- =====================================================
SELECT 
    u.UserID,
    u.Username,
    u.FullName,
    u.Email,
    u.Phone,
    r.RoleName,
    u.Status
FROM Users u
JOIN Roles r ON u.RoleID = r.RoleID;
GO

-- =====================================================
-- QUERY TEST 2:
-- Xem danh sách học sinh kèm lớp, cấp học, phụ huynh
-- =====================================================
SELECT 
    s.StudentID,
    s.StudentCode,
    s.StudentName,
    c.ClassName,
    l.LevelName,
    p.FullName AS ParentName
FROM Students s
JOIN Classes c ON s.ClassID = c.ClassID
JOIN Levels l ON c.LevelID = l.LevelID
LEFT JOIN Users p ON s.ParentID = p.UserID;
GO

-- =====================================================
-- QUERY TEST 3:
-- Phụ huynh xem danh sách con của mình
-- Ví dụ ParentID = 4
-- =====================================================
SELECT 
    s.StudentID,
    s.StudentCode,
    s.StudentName,
    c.ClassName,
    l.LevelName
FROM Students s
JOIN Classes c ON s.ClassID = c.ClassID
JOIN Levels l ON c.LevelID = l.LevelID
WHERE s.ParentID = 4;
GO

-- =====================================================
-- QUERY TEST 4:
-- Xem menu theo cấp học
-- Ví dụ LevelID = 1 là Nhà trẻ
-- =====================================================
SELECT 
    l.LevelName,
    md.MenuDate,
    mt.MealTypeName,
    d.DishName
FROM Menus m
JOIN Levels l ON m.LevelID = l.LevelID
JOIN MenuDetails md ON m.MenuID = md.MenuID
JOIN MealTypes mt ON md.MealTypeID = mt.MealTypeID
JOIN Dishes d ON md.DishID = d.DishID
WHERE m.LevelID = 1
ORDER BY md.MenuDate, mt.MealTypeID;
GO

-- =====================================================
-- QUERY TEST 5:
-- Phụ huynh xem menu của con
-- Ví dụ StudentID = 1
-- =====================================================
SELECT 
    s.StudentName,
    c.ClassName,
    l.LevelName,
    md.MenuDate,
    mt.MealTypeName,
    d.DishName
FROM Students s
JOIN Classes c ON s.ClassID = c.ClassID
JOIN Levels l ON c.LevelID = l.LevelID
JOIN Menus m ON l.LevelID = m.LevelID
JOIN MenuDetails md ON m.MenuID = md.MenuID
JOIN MealTypes mt ON md.MealTypeID = mt.MealTypeID
JOIN Dishes d ON md.DishID = d.DishID
WHERE s.StudentID = 1
ORDER BY md.MenuDate, mt.MealTypeID;
GO

-- =====================================================
-- QUERY TEST 6:
-- Kiểm tra học sinh có thuộc phụ huynh không
-- Dùng khi phụ huynh báo nghỉ
-- Ví dụ StudentID = 1, ParentID = 4
-- =====================================================
SELECT COUNT(*) AS IsMyChild
FROM Students
WHERE StudentID = 1
AND ParentID = 4;
GO

-- =====================================================
-- QUERY TEST 7:
-- Tính số suất ăn theo cấp học trong ngày
-- Ví dụ ngày 2026-05-25
-- =====================================================
SELECT 
    l.LevelName,
    COUNT(s.StudentID) AS MealCount
FROM Students s
JOIN Classes c ON s.ClassID = c.ClassID
JOIN Levels l ON c.LevelID = l.LevelID
LEFT JOIN Attendance a 
    ON s.StudentID = a.StudentID 
    AND a.AttendanceDate = '2026-05-25'
WHERE s.Status = 1
AND (
    a.AttendanceID IS NULL
    OR a.Status = 'Present'
    OR (a.Status = 'Absent' AND a.IsCharged = 1)
)
GROUP BY l.LevelName;
GO

-- =====================================================
-- QUERY TEST 8:
-- Xem công thức món ăn
-- =====================================================
SELECT
    d.DishName,
    i.IngredientName,
    i.Unit,
    di.QuantityPerStudent
FROM DishIngredients di
JOIN Dishes d ON di.DishID = d.DishID
JOIN Ingredients i ON di.IngredientID = i.IngredientID
ORDER BY d.DishName;
GO

-- =====================================================
-- QUERY TEST 9:
-- Tính nguyên liệu cần dùng theo cấp học trong 1 ngày
-- Ví dụ ngày 2026-05-25, LevelID = 2
-- Query này tính định lượng cho 1 học sinh.
-- Bên Java nhân thêm với số suất ăn.
-- =====================================================
SELECT
    i.IngredientName,
    i.Unit,
    SUM(di.QuantityPerStudent) AS QuantityPerStudentTotal
FROM MenuDetails md
JOIN Menus m ON md.MenuID = m.MenuID
JOIN Dishes d ON md.DishID = d.DishID
JOIN DishIngredients di ON d.DishID = di.DishID
JOIN Ingredients i ON di.IngredientID = i.IngredientID
WHERE md.MenuDate = '2026-05-25'
AND m.LevelID = 2
GROUP BY i.IngredientName, i.Unit;
GO

-- =====================================================
-- QUERY TEST 10:
-- Phụ huynh xem minh bạch nguyên liệu nhập trong tuần
-- =====================================================
SELECT 
    ii.ImportDate,
    i.IngredientName,
    i.Unit,
    ii.Quantity,
    ii.UnitPrice,
    ii.TotalPrice,
    ii.SupplierName,
    ii.Note
FROM IngredientImports ii
JOIN Ingredients i ON ii.IngredientID = i.IngredientID
WHERE ii.ImportDate BETWEEN '2026-05-25' AND '2026-05-31'
ORDER BY ii.ImportDate DESC;
GO

-- =====================================================
-- QUERY TEST 11:
-- Tổng chi phí nhập nguyên liệu trong tuần
-- =====================================================
SELECT 
    SUM(ii.TotalPrice) AS TotalImportCost
FROM IngredientImports ii
WHERE ii.ImportDate BETWEEN '2026-05-25' AND '2026-05-31';
GO

-- =====================================================
-- QUERY TEST 12:
-- Tổng chi phí theo từng nguyên liệu
-- =====================================================
SELECT 
    i.IngredientName,
    i.Unit,
    SUM(ii.Quantity) AS TotalQuantity,
    SUM(ii.TotalPrice) AS TotalCost
FROM IngredientImports ii
JOIN Ingredients i ON ii.IngredientID = i.IngredientID
WHERE ii.ImportDate BETWEEN '2026-05-25' AND '2026-05-31'
GROUP BY i.IngredientName, i.Unit
ORDER BY TotalCost DESC;
GO

-- =====================================================
-- QUERY TEST 13:
-- User xem thông báo của mình
-- Ví dụ KitchenStaff có UserID = 5
-- =====================================================
SELECT 
    un.UserNotificationID,
    n.NotificationID,
    n.Title,
    n.Message,
    n.NotificationType,
    n.CreatedAt,
    un.IsRead,
    un.ReadAt
FROM UserNotifications un
JOIN Notifications n ON un.NotificationID = n.NotificationID
WHERE un.UserID = 5
ORDER BY n.CreatedAt DESC;
GO

-- =====================================================
-- QUERY TEST 14:
-- Đánh dấu thông báo đã đọc
-- Ví dụ UserNotificationID = 1
-- =====================================================
UPDATE UserNotifications
SET IsRead = 1,
    ReadAt = GETDATE()
WHERE UserNotificationID = 1;
GO

-- =====================================================
-- QUERY TEST 15:
-- Admin xem nhật ký hệ thống
-- =====================================================
SELECT 
    sl.LogID,
    u.Username,
    u.FullName,
    sl.Action,
    sl.TableName,
    sl.RecordID,
    sl.Description,
    sl.CreatedAt
FROM SystemLogs sl
LEFT JOIN Users u ON sl.UserID = u.UserID
ORDER BY sl.CreatedAt DESC;
GO
