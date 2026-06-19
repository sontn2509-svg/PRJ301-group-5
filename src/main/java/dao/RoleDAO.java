package dao;

import model.Role;
import config.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/*
  Data Access Object cho bảng Roles.
  - Hiện tại chỉ có 1 phương thức findAll() để lấy danh sách vai trò
  - Roles được sắp xếp theo RoleID tăng dần
  - RoleID = 1 luôn là Admin
 */
public class RoleDAO {

    public List<Role> findAll() throws SQLException {
        String sql = "SELECT RoleID, RoleName FROM Roles ORDER BY RoleID";
        List<Role> roles = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                roles.add(new Role(resultSet.getInt("RoleID"), resultSet.getString("RoleName")));
            }
        }
        return roles;
    }
}
