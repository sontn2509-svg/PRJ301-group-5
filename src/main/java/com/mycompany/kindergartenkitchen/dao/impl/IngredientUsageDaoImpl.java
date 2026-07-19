package com.mycompany.kindergartenkitchen.dao.impl;

import com.mycompany.kindergartenkitchen.dao.DBContext; // Thay đổi import sang DBContext
import com.mycompany.kindergartenkitchen.dao.IngredientUsageDao;
import com.mycompany.kindergartenkitchen.model.IngredientUsage;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class IngredientUsageDaoImpl implements IngredientUsageDao {

    // Tạo đối tượng DBContext dùng chung cho toàn bộ Class
    private final DBContext db = new DBContext();

    private static final String SQL_FIND_BY_DATE
            = "SELECT iu.UsageID, iu.IngredientID, iu.QuantityUsed, iu.UsageDate, "
            + "iu.UpdatedBy, iu.Note, i.IngredientName, i.Unit, u.FullName AS UpdatedByName "
            + "FROM IngredientUsages iu "
            + "JOIN Ingredients i ON iu.IngredientID = i.IngredientID "
            + "JOIN Users u ON iu.UpdatedBy = u.UserID "
            + "WHERE iu.UsageDate = ? "
            + "ORDER BY i.IngredientName";

    private static final String SQL_FIND_BY_ID
            = "SELECT iu.UsageID, iu.IngredientID, iu.QuantityUsed, iu.UsageDate, "
            + "iu.UpdatedBy, iu.Note, i.IngredientName, i.Unit, u.FullName AS UpdatedByName "
            + "FROM IngredientUsages iu "
            + "JOIN Ingredients i ON iu.IngredientID = i.IngredientID "
            + "JOIN Users u ON iu.UpdatedBy = u.UserID "
            + "WHERE iu.UsageID = ?";

    private static final String SQL_INSERT
            = "INSERT INTO IngredientUsages (IngredientID, QuantityUsed, UsageDate, UpdatedBy, Note) "
            + "VALUES (?, ?, ?, ?, ?)";

    private static final String SQL_UPDATE
            = "UPDATE IngredientUsages SET QuantityUsed = ?, Note = ? WHERE UsageID = ?";

    private static final String SQL_DELETE
            = "DELETE FROM IngredientUsages WHERE UsageID = ?";

    @Override
    public List<IngredientUsage> findByDate(Date usageDate) throws SQLException {
        List<IngredientUsage> usageList = new ArrayList<>();
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_FIND_BY_DATE)) {

            statement.setDate(1, usageDate);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    usageList.add(mapResultSetToIngredientUsage(resultSet));
                }
            }
        } catch (Exception e) {
            throw new SQLException("Lỗi kết nối DBContext: " + e.getMessage());
        }
        return usageList;
    }

    @Override
    public IngredientUsage findById(int usageId) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_FIND_BY_ID)) {

            statement.setInt(1, usageId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapResultSetToIngredientUsage(resultSet);
                }
            }
        } catch (Exception e) {
            throw new SQLException("Lỗi kết nối DBContext: " + e.getMessage());
        }
        return null;
    }

    @Override
    public int insert(IngredientUsage ingredientUsage) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(
                        SQL_INSERT, Statement.RETURN_GENERATED_KEYS)) {

            statement.setInt(1, ingredientUsage.getIngredientId());
            statement.setDouble(2, ingredientUsage.getQuantityUsed());
            statement.setDate(3, ingredientUsage.getUsageDate());
            statement.setInt(4, ingredientUsage.getUpdatedBy());
            statement.setString(5, ingredientUsage.getNote());
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
    public boolean update(IngredientUsage ingredientUsage) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_UPDATE)) {

            statement.setDouble(1, ingredientUsage.getQuantityUsed());
            statement.setString(2, ingredientUsage.getNote());
            statement.setInt(3, ingredientUsage.getUsageId());
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            throw new SQLException("Lỗi kết nối DBContext: " + e.getMessage());
        }
    }

    @Override
    public boolean delete(int usageId) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_DELETE)) {

            statement.setInt(1, usageId);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            throw new SQLException("Lỗi kết nối DBContext: " + e.getMessage());
        }
    }

    private IngredientUsage mapResultSetToIngredientUsage(ResultSet resultSet) throws SQLException {
        IngredientUsage ingredientUsage = new IngredientUsage();
        ingredientUsage.setUsageId(resultSet.getInt("UsageID"));
        ingredientUsage.setIngredientId(resultSet.getInt("IngredientID"));
        ingredientUsage.setQuantityUsed(resultSet.getDouble("QuantityUsed"));
        ingredientUsage.setUsageDate(resultSet.getDate("UsageDate"));
        ingredientUsage.setUpdatedBy(resultSet.getInt("UpdatedBy"));
        ingredientUsage.setNote(resultSet.getString("Note"));
        ingredientUsage.setIngredientName(resultSet.getString("IngredientName"));
        ingredientUsage.setUnit(resultSet.getString("Unit"));
        ingredientUsage.setUpdatedByName(resultSet.getString("UpdatedByName"));
        return ingredientUsage;
    }
}