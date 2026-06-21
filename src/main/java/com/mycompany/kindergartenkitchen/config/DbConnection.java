package com.mycompany.kindergartenkitchen.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * LƯU Ý: Đây là bản tham khảo. P1 sẽ tạo file chính thức ở
 * com.mycompany.kindergartenkitchen.config.DbConnection
 * P4 chỉ import và dùng, không tự ý sửa class này.
 */
public class DbConnection {

    private static final String URL
            = "jdbc:sqlserver://localhost:1433;databaseName=KindergartenKitchen;"
            + "encrypt=true;trustServerCertificate=true";
    private static final String USERNAME = "sa";
    private static final String PASSWORD = "123";
    private static final String DRIVER_CLASS_NAME
            = "com.microsoft.sqlserver.jdbc.SQLServerDriver";

    private DbConnection() {
    }

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName(DRIVER_CLASS_NAME);
        } catch (ClassNotFoundException exception) {
            throw new SQLException("Không tìm thấy driver SQL Server.", exception);
        }
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
    public static void main(String[] args) {
        try (Connection conn = DbConnection.getConnection()) {
            if (conn != null) {
                System.out.println("=== FILE DbConnection KẾT NỐI DB THÀNH CÔNG! ===");
            }
        } catch (Exception e) {
            System.out.println("DbConnection thất bại: " + e.getMessage());
        }
    }
}
