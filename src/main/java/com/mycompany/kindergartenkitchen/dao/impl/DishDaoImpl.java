package com.mycompany.kindergartenkitchen.dao.impl;

import com.mycompany.kindergartenkitchen.dao.DBContext;
import com.mycompany.kindergartenkitchen.dao.DishDao;
import com.mycompany.kindergartenkitchen.model.Dish;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class DishDaoImpl implements DishDao {

    private final DBContext db = new DBContext();

    private static final String SQL_FIND_ALL
            = "SELECT DishID, DishName, Description, Status FROM Dishes ORDER BY DishName";

    private static final String SQL_FIND_ALL_ACTIVE
            = "SELECT DishID, DishName, Description, Status FROM Dishes "
            + "WHERE Status = 1 ORDER BY DishName";

    private static final String SQL_FIND_BY_ID
            = "SELECT DishID, DishName, Description, Status FROM Dishes WHERE DishID = ?";

    private static final String SQL_INSERT
            = "INSERT INTO Dishes (DishName, Description, Status) VALUES (?, ?, 1)";

    private static final String SQL_UPDATE
            = "UPDATE Dishes SET DishName = ?, Description = ? WHERE DishID = ?";

    private static final String SQL_SET_STATUS
            = "UPDATE Dishes SET Status = ? WHERE DishID = ?";

    @Override
    public List<Dish> findAll() throws SQLException {
        List<Dish> dishList = new ArrayList<>();
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_FIND_ALL);
                ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                dishList.add(mapResultSetToDish(resultSet));
            }
        } catch (Exception e) {
            throw new SQLException("Lỗi DBContext: " + e.getMessage());
        }
        return dishList;
    }

    @Override
    public List<Dish> findAllActive() throws SQLException {
        List<Dish> dishList = new ArrayList<>();
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_FIND_ALL_ACTIVE);
                ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                dishList.add(mapResultSetToDish(resultSet));
            }
        } catch (Exception e) {
            throw new SQLException("Lỗi DBContext: " + e.getMessage());
        }
        return dishList;
    }

    @Override
    public Dish findById(int dishId) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_FIND_BY_ID)) {

            statement.setInt(1, dishId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapResultSetToDish(resultSet);
                }
            }
        } catch (Exception e) {
            throw new SQLException("Lỗi DBContext: " + e.getMessage());
        }
        return null;
    }

    @Override
    public int insert(Dish dish) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement
                        = connection.prepareStatement(SQL_INSERT, Statement.RETURN_GENERATED_KEYS)) {

            statement.setString(1, dish.getDishName());
            statement.setString(2, dish.getDescription());
            statement.executeUpdate();

            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (Exception e) {
            throw new SQLException("Lỗi DBContext: " + e.getMessage());
        }
        return -1;
    }

    @Override
    public boolean update(Dish dish) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_UPDATE)) {

            statement.setString(1, dish.getDishName());
            statement.setString(2, dish.getDescription());
            statement.setInt(3, dish.getDishId());
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            throw new SQLException("Lỗi DBContext: " + e.getMessage());
        }
    }

    @Override
    public boolean setStatus(int dishId, boolean status) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_SET_STATUS)) {

            statement.setBoolean(1, status);
            statement.setInt(2, dishId);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            throw new SQLException("Lỗi DBContext: " + e.getMessage());
        }
    }

    private Dish mapResultSetToDish(ResultSet resultSet) throws SQLException {
        Dish dish = new Dish();
        dish.setDishId(resultSet.getInt("DishID"));
        dish.setDishName(resultSet.getString("DishName"));
        dish.setDescription(resultSet.getString("Description"));
        dish.setStatus(resultSet.getBoolean("Status"));
        return dish;
    }
}
