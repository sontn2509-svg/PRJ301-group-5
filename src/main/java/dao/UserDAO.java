package dao;

import model.User;
import config.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/*
  Data Access Object cho bảng Users.
  - Tất cả các phương thức đều sử dụng try-with-resources để đóng Connection tự động
  - Mật khẩu được lưu plain text (chưa mã hóa)
  - User Status: 0 = Pending, 1 = Active, 2 = Blocked
  - authenticate() chỉ đăng nhập user có Status = 1 (Active)
* - RoleID = 1 là Admin (chỉ có 1 tài khoản Admin duy nhất)
 */
public class UserDAO {

    public Optional<User> authenticate(String username, String password) throws SQLException {
        String sql = """
                SELECT u.UserID, u.Username, u.Password, u.FullName, u.Email, u.Phone,
                       u.RoleID, r.RoleName, u.Status, u.CreatedAt
                FROM Users u
                JOIN Roles r ON u.RoleID = r.RoleID
                WHERE u.Username = ? AND u.Password = ? AND u.Status = 1
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);
            statement.setString(2, password);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return Optional.of(mapUser(resultSet));
                }
            }
        }
        return Optional.empty();
    }

    public List<User> search(String keyword, Integer roleId, Integer status) throws SQLException {
        String sql = """
                SELECT u.UserID, u.Username, u.Password, u.FullName, u.Email, u.Phone,
                       u.RoleID, r.RoleName, u.Status, u.CreatedAt
                FROM Users u
                JOIN Roles r ON u.RoleID = r.RoleID
                WHERE (? = '' OR u.Username LIKE ? OR u.FullName LIKE ? OR u.Email LIKE ?)
                  AND (? IS NULL OR u.RoleID = ?)
                  AND (? IS NULL OR u.Status = ?)
                ORDER BY u.CreatedAt DESC, u.UserID DESC
                """;
        List<User> users = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            String safeKeyword = keyword == null ? "" : keyword.trim();
            String like = "%" + safeKeyword + "%";
            statement.setString(1, safeKeyword);
            statement.setString(2, like);
            statement.setString(3, like);
            statement.setString(4, like);
            setNullableInt(statement, 5, roleId);
            setNullableInt(statement, 6, roleId);
            setNullableInt(statement, 7, status);
            setNullableInt(statement, 8, status);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    users.add(mapUser(resultSet));
                }
            }
        }
        return users;
    }

    public Optional<User> findById(int id) throws SQLException {
        String sql = """
                SELECT u.UserID, u.Username, u.Password, u.FullName, u.Email, u.Phone,
                       u.RoleID, r.RoleName, u.Status, u.CreatedAt
                FROM Users u
                JOIN Roles r ON u.RoleID = r.RoleID
                WHERE u.UserID = ?
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return Optional.of(mapUser(resultSet));
                }
            }
        }
        return Optional.empty();
    }

    public Optional<User> findForPasswordReset(String username, String email, String phone) throws SQLException {
        String sql = """
                SELECT u.UserID, u.Username, u.Password, u.FullName, u.Email, u.Phone,
                       u.RoleID, r.RoleName, u.Status, u.CreatedAt
                FROM Users u
                JOIN Roles r ON u.RoleID = r.RoleID
                WHERE u.Username = ?
                  AND LOWER(ISNULL(u.Email, '')) = LOWER(?)
                  AND ISNULL(u.Phone, '') = ?
                  AND u.Status = 1
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);
            statement.setString(2, email);
            statement.setString(3, phone);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return Optional.of(mapUser(resultSet));
                }
            }
        }
        return Optional.empty();
    }

    public int countAll() throws SQLException {
        return countByCondition(null);
    }

    public int countActive() throws SQLException {
        return countByCondition(1);
    }

    public int countBlocked() throws SQLException {
        return countByCondition(2);
    }

    public int countPending() throws SQLException {
        return countByCondition(0);
    }

    public int create(User user) throws SQLException {
        String sql = """
                INSERT INTO Users(Username, Password, FullName, Email, Phone, RoleID, Status)
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            bindUserForm(statement, user, true);
            statement.executeUpdate();
            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        return 0;
    }

    public void update(User user, boolean changePassword) throws SQLException {
        String sql = changePassword
                ? """
                UPDATE Users
                SET Password = ?, FullName = ?, Email = ?, Phone = ?, RoleID = ?, Status = ?
                WHERE UserID = ?
                """
                : """
                UPDATE Users
                SET FullName = ?, Email = ?, Phone = ?, RoleID = ?, Status = ?
                WHERE UserID = ?
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            int index = 1;
            if (changePassword) {
                statement.setString(index++, user.getPassword());
            }
            statement.setString(index++, user.getFullName());
            statement.setString(index++, user.getEmail());
            statement.setString(index++, user.getPhone());
            statement.setInt(index++, user.getRoleId());
            statement.setInt(index++, user.getStatus());
            statement.setInt(index, user.getUserId());
            statement.executeUpdate();
        }
    }

    public void toggleStatus(int userId) throws SQLException {
        String sql = "UPDATE Users SET Status = CASE WHEN Status = 1 THEN 2 ELSE 1 END WHERE UserID = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            statement.executeUpdate();
        }
    }

    public void resetPassword(int userId, String newPassword) throws SQLException {
        String sql = "UPDATE Users SET Password = ? WHERE UserID = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, newPassword);
            statement.setInt(2, userId);
            statement.executeUpdate();
        }
    }

    public void delete(int userId) throws SQLException {
        String sql = "DELETE FROM Users WHERE UserID = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            statement.executeUpdate();
        }
    }

    public boolean usernameExists(String username, Integer exceptUserId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users WHERE Username = ? AND (? IS NULL OR UserID <> ?)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);
            setNullableInt(statement, 2, exceptUserId);
            setNullableInt(statement, 3, exceptUserId);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() && resultSet.getInt(1) > 0;
            }
        }
    }

    private int countByCondition(Integer status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users WHERE (? IS NULL OR Status = ?)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            setNullableInt(statement, 1, status);
            setNullableInt(statement, 2, status);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? resultSet.getInt(1) : 0;
            }
        }
    }

    public int countByRole(int roleId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users WHERE RoleID = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, roleId);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? resultSet.getInt(1) : 0;
            }
        }
    }

    private void bindUserForm(PreparedStatement statement, User user, boolean includeUsername) throws SQLException {
        int index = 1;
        if (includeUsername) {
            statement.setString(index++, user.getUsername());
        }
        statement.setString(index++, user.getPassword());
        statement.setString(index++, user.getFullName());
        statement.setString(index++, user.getEmail());
        statement.setString(index++, user.getPhone());
        statement.setInt(index++, user.getRoleId());
        statement.setInt(index, user.getStatus());
    }

    private void setNullableInt(PreparedStatement statement, int index, Integer value) throws SQLException {
        if (value == null) {
            statement.setNull(index, java.sql.Types.INTEGER);
        } else {
            statement.setInt(index, value);
        }
    }

    private User mapUser(ResultSet resultSet) throws SQLException {
        User user = new User();
        user.setUserId(resultSet.getInt("UserID"));
        user.setUsername(resultSet.getString("Username"));
        user.setPassword(resultSet.getString("Password"));
        user.setFullName(resultSet.getString("FullName"));
        user.setEmail(resultSet.getString("Email"));
        user.setPhone(resultSet.getString("Phone"));
        user.setRoleId(resultSet.getInt("RoleID"));
        user.setRoleName(resultSet.getString("RoleName"));
        user.setStatus(resultSet.getInt("Status"));
        Timestamp createdAt = resultSet.getTimestamp("CreatedAt");
        if (createdAt != null) {
            user.setCreatedAt(createdAt.toLocalDateTime());
        }
        return user;
    }
}
