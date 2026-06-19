package config;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/*
  Kết nối database SQL Server.
  - File db.properties phải đặt trong src/main/resources/
  - Các trường db.properties: db.url, db.username, db.password
  - Driver SQL Server (com.microsoft.sqlserver.jdbc.SQLServerDriver) đã được load trong static block
  - Connection không tự động đóng, cần dùng try-with-resources hoặc đóng thủ công
  - Nếu db.properties không tìm thấy sẽ ném IllegalStateException khi khởi động ứng dụng
 */
public final class DBConnection {

    private static final Properties PROPERTIES = new Properties();

    static {
        try (InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input == null) {
                throw new IllegalStateException("Missing db.properties");
            }
            PROPERTIES.load(input);
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (IOException | ClassNotFoundException e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    private DBConnection() {
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(
                PROPERTIES.getProperty("db.url"),
                PROPERTIES.getProperty("db.username"),
                PROPERTIES.getProperty("db.password")
        );
    }
}
