package com.mycompany.kindergartenkitchen.dao.impl;

import com.mycompany.kindergartenkitchen.dao.DBContext; // Thay đổi import sang DBContext
import com.mycompany.kindergartenkitchen.dao.IngredientDao;
import com.mycompany.kindergartenkitchen.model.Ingredient;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class IngredientDaoImpl implements IngredientDao {

    // Tạo đối tượng DBContext dùng chung cho toàn bộ Class./
    private final DBContext db = new DBContext();

    private static final String SQL_FIND_ALL
            = "SELECT IngredientID, IngredientName, Unit, QuantityInStock, Status "
            + "FROM Ingredients WHERE Status = 1 ORDER BY IngredientName";

    private static final String SQL_FIND_BY_ID
            = "SELECT IngredientID, IngredientName, Unit, QuantityInStock, Status "
            + "FROM Ingredients WHERE IngredientID = ?";

    private static final String SQL_INSERT
            = "INSERT INTO Ingredients (IngredientName, Unit, QuantityInStock, Status) "
            + "VALUES (?, ?, ?, 1)";

    private static final String SQL_UPDATE
            = "UPDATE Ingredients SET IngredientName = ?, Unit = ?, QuantityInStock = ? "
            + "WHERE IngredientID = ?";

    private static final String SQL_DEACTIVATE
            = "UPDATE Ingredients SET Status = 0 WHERE IngredientID = ?";

    private static final String SQL_UPDATE_STOCK
            = "UPDATE Ingredients SET QuantityInStock = ? WHERE IngredientID = ?";

    private static final String SQL_FIND_LOW_STOCK
            = "SELECT IngredientID, IngredientName, Unit, QuantityInStock, Status "
            + "FROM Ingredients WHERE Status = 1 AND QuantityInStock <= ? "
            + "ORDER BY QuantityInStock ASC";

    private static final String SQL_FIND_BY_NAME
            = "SELECT IngredientID, IngredientName, Unit, QuantityInStock, Status "
            + "FROM Ingredients WHERE LTRIM(RTRIM(IngredientName)) = LTRIM(RTRIM(?))";

    @Override
    public List<Ingredient> findAll() throws SQLException {
        List<Ingredient> ingredientList = new ArrayList<>();
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_FIND_ALL);
                ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                ingredientList.add(mapResultSetToIngredient(resultSet));
            }
        } catch (Exception e) {
            throw new SQLException("Lỗi kết nối DBContext: " + e.getMessage());
        }
        return ingredientList;
    }

    @Override
    public Ingredient findById(int ingredientId) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_FIND_BY_ID)) {

            statement.setInt(1, ingredientId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapResultSetToIngredient(resultSet);
                }
            }
        } catch (Exception e) {
            throw new SQLException("Lỗi kết nối DBContext: " + e.getMessage());
        }
        return null;
    }

    @Override
    public int insert(Ingredient ingredient) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(
                        SQL_INSERT, Statement.RETURN_GENERATED_KEYS)) {

            statement.setString(1, ingredient.getIngredientName());
            statement.setString(2, ingredient.getUnit());
            statement.setDouble(3, ingredient.getQuantityInStock());
            statement.executeUpdate();

            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (Exception e) {
            throw new SQLException("Lỗi kết nối DBContext: " + e.getMessage());
        }
        return -1;
    }

    @Override
    public boolean update(Ingredient ingredient) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_UPDATE)) {

            statement.setString(1, ingredient.getIngredientName());
            statement.setString(2, ingredient.getUnit());
            statement.setDouble(3, ingredient.getQuantityInStock());
            statement.setInt(4, ingredient.getIngredientId());
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            throw new SQLException("Lỗi kết nối DBContext: " + e.getMessage());
        }
    }

    @Override
    public boolean deactivate(int ingredientId) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_DEACTIVATE)) {

            statement.setInt(1, ingredientId);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            throw new SQLException("Lỗi kết nối DBContext: " + e.getMessage());
        }
    }

    @Override
    public boolean updateStock(int ingredientId, double newQuantity) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_UPDATE_STOCK)) {

            statement.setDouble(1, newQuantity);
            statement.setInt(2, ingredientId);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            throw new SQLException("Lỗi kết nối DBContext: " + e.getMessage());
        }
    }

    @Override
    public List<Ingredient> findLowStock(double threshold) throws SQLException {
        List<Ingredient> ingredientList = new ArrayList<>();
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_FIND_LOW_STOCK)) {

            statement.setDouble(1, threshold);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    ingredientList.add(mapResultSetToIngredient(resultSet));
                }
            }
        } catch (Exception e) {
            throw new SQLException("Lỗi kết nối DBContext: " + e.getMessage());
        }
        return ingredientList;
    }

    @Override
    public Ingredient findByName(String ingredientName) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_FIND_BY_NAME)) {

            statement.setString(1, ingredientName);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapResultSetToIngredient(resultSet);
                }
            }
        } catch (Exception e) {
            throw new SQLException("Lỗi kết nối DBContext: " + e.getMessage());
        }
        return null;
    }

    private Ingredient mapResultSetToIngredient(ResultSet resultSet) throws SQLException {
        Ingredient ingredient = new Ingredient();
        ingredient.setIngredientId(resultSet.getInt("IngredientID"));
        ingredient.setIngredientName(resultSet.getString("IngredientName"));
        ingredient.setUnit(resultSet.getString("Unit"));
        ingredient.setQuantityInStock(resultSet.getDouble("QuantityInStock"));
        ingredient.setStatus(resultSet.getBoolean("Status"));
        return ingredient;
    }
}