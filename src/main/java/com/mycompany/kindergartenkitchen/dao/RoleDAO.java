package com.mycompany.kindergartenkitchen.dao;

import com.mycompany.kindergartenkitchen.entity.Role;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/*
  Data Access Object cho bang Roles.
  - Hien tai chi co 1 phuong thuc findAll() de lay danh sach vai tro
  - Roles duoc sap xep theo RoleID tang dan
  - RoleID = 1 luon la Admin
 */
public class RoleDAO implements IRoleDAO {

    @Override
    public List<Role> findAll() throws SQLException {
        String sql = "SELECT RoleID, RoleName FROM Roles ORDER BY RoleID";
        List<Role> roles = new ArrayList<>();
        try (Connection connection = new DBContext().getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                roles.add(new Role(resultSet.getInt("RoleID"), resultSet.getString("RoleName")));
            }
        }
        return roles;
    }
}
