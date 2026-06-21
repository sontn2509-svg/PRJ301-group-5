package com.mycompany.kindergartenkitchen.dao.impl;

import com.mycompany.kindergartenkitchen.config.DbConnection;
import com.mycompany.kindergartenkitchen.dao.DishIngredientDao;
import com.mycompany.kindergartenkitchen.model.DishIngredient;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Implementation của DishIngredientDao.
 * Quản lý công thức món: 1 món cần những nguyên liệu nào, định lượng/học sinh.
 */
public class DishIngredientDaoImpl implements DishIngredientDao {

    private static final String SQL_FIND_BY_DISH_ID
            = "SELECT di.DishIngredientID, di.DishID, di.IngredientID, di.QuantityPerStudent, "
            + "d.DishName, i.IngredientName, i.Unit "
            + "FROM DishIngredients di "
            + "JOIN Dishes d ON di.DishID = d.DishID "
            + "JOIN Ingredients i ON di.IngredientID = i.IngredientID "
            + "WHERE di.DishID = ?";

    private static final String SQL_FIND_BY_ID
            = "SELECT di.DishIngredientID, di.DishID, di.IngredientID, di.QuantityPerStudent, "
            + "d.DishName, i.IngredientName, i.Unit "
            + "FROM DishIngredients di "
            + "JOIN Dishes d ON di.DishID = d.DishID "
            + "JOIN Ingredients i ON di.IngredientID = i.IngredientID "
            + "WHERE di.DishIngredientID = ?";

    private static final String SQL_INSERT
            = "INSERT INTO DishIngredients (DishID, IngredientID, QuantityPerStudent) "
            + "VALUES (?, ?, ?)";

    private static final String SQL_UPDATE
            = "UPDATE DishIngredients SET QuantityPerStudent = ? WHERE DishIngredientID = ?";

    private static final String SQL_DELETE
            = "DELETE FROM DishIngredients WHERE DishIngredientID = ?";

    @Override
    public List<DishIngredient> findByDishId(int dishId) throws SQLException {
        List<DishIngredient> dishIngredientList = new ArrayList<>();
        try (Connection connection = DbConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_FIND_BY_DISH_ID)) {

            statement.setInt(1, dishId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    dishIngredientList.add(mapResultSetToDishIngredient(resultSet));
                }
            }
        }
        return dishIngredientList;
    }

    @Override
    public DishIngredient findById(int dishIngredientId) throws SQLException {
        try (Connection connection = DbConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_FIND_BY_ID)) {

            statement.setInt(1, dishIngredientId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapResultSetToDishIngredient(resultSet);
                }
            }
        }
        return null;
    }

    @Override
    public int insert(DishIngredient dishIngredient) throws SQLException {
        try (Connection connection = DbConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(
                        SQL_INSERT, Statement.RETURN_GENERATED_KEYS)) {

            statement.setInt(1, dishIngredient.getDishId());
            statement.setInt(2, dishIngredient.getIngredientId());
            statement.setDouble(3, dishIngredient.getQuantityPerStudent());
            statement.executeUpdate();

            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        }
        return -1;
    }

    @Override
    public boolean update(DishIngredient dishIngredient) throws SQLException {
        try (Connection connection = DbConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_UPDATE)) {

            statement.setDouble(1, dishIngredient.getQuantityPerStudent());
            statement.setInt(2, dishIngredient.getDishIngredientId());
            return statement.executeUpdate() > 0;
        }
    }

    @Override
    public boolean delete(int dishIngredientId) throws SQLException {
        try (Connection connection = DbConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_DELETE)) {

            statement.setInt(1, dishIngredientId);
            return statement.executeUpdate() > 0;
        }
    }

    private DishIngredient mapResultSetToDishIngredient(ResultSet resultSet) throws SQLException {
        DishIngredient dishIngredient = new DishIngredient();
        dishIngredient.setDishIngredientId(resultSet.getInt("DishIngredientID"));
        dishIngredient.setDishId(resultSet.getInt("DishID"));
        dishIngredient.setIngredientId(resultSet.getInt("IngredientID"));
        dishIngredient.setQuantityPerStudent(resultSet.getDouble("QuantityPerStudent"));
        dishIngredient.setDishName(resultSet.getString("DishName"));
        dishIngredient.setIngredientName(resultSet.getString("IngredientName"));
        dishIngredient.setUnit(resultSet.getString("Unit"));
        return dishIngredient;
    }
}
