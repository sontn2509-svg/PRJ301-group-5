package com.mycompany.kindergartenkitchen.dao.impl;

import com.mycompany.kindergartenkitchen.dao.DBContext;
import com.mycompany.kindergartenkitchen.dao.MealTypeDao;
import com.mycompany.kindergartenkitchen.model.MealType;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class MealTypeDaoImpl implements MealTypeDao {

    private final DBContext db = new DBContext();

    private static final String SQL_FIND_ALL
            = "SELECT MealTypeID, MealTypeName FROM MealTypes ORDER BY MealTypeID";

    private static final String SQL_FIND_BY_ID
            = "SELECT MealTypeID, MealTypeName FROM MealTypes WHERE MealTypeID = ?";

    private static final String SQL_INSERT
            = "INSERT INTO MealTypes (MealTypeName) VALUES (?)";

    private static final String SQL_UPDATE
            = "UPDATE MealTypes SET MealTypeName = ? WHERE MealTypeID = ?";

    private static final String SQL_DELETE
            = "DELETE FROM MealTypes WHERE MealTypeID = ?";

    private static final String SQL_IS_IN_USE
            = "SELECT COUNT(*) FROM MenuDetails WHERE MealTypeID = ?";

    @Override
    public List<MealType> findAll() throws SQLException {
        List<MealType> mealTypeList = new ArrayList<>();
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_FIND_ALL);
                ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                mealTypeList.add(mapResultSetToMealType(resultSet));
            }
        } catch (Exception e) {
            throw new SQLException("Lỗi DBContext: " + e.getMessage());
        }
        return mealTypeList;
    }

    @Override
    public MealType findById(int mealTypeId) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_FIND_BY_ID)) {

            statement.setInt(1, mealTypeId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapResultSetToMealType(resultSet);
                }
            }
        } catch (Exception e) {
            throw new SQLException("Lỗi DBContext: " + e.getMessage());
        }
        return null;
    }

    @Override
    public int insert(MealType mealType) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement
                        = connection.prepareStatement(SQL_INSERT, Statement.RETURN_GENERATED_KEYS)) {

            statement.setString(1, mealType.getMealTypeName());
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
    public boolean update(MealType mealType) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_UPDATE)) {

            statement.setString(1, mealType.getMealTypeName());
            statement.setInt(2, mealType.getMealTypeId());
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            throw new SQLException("Lỗi DBContext: " + e.getMessage());
        }
    }

    @Override
    public boolean delete(int mealTypeId) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_DELETE)) {

            statement.setInt(1, mealTypeId);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            throw new SQLException("Lỗi DBContext: " + e.getMessage());
        }
    }

    @Override
    public boolean isInUse(int mealTypeId) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_IS_IN_USE)) {

            statement.setInt(1, mealTypeId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            throw new SQLException("Lỗi DBContext: " + e.getMessage());
        }
        return false;
    }

    private MealType mapResultSetToMealType(ResultSet resultSet) throws SQLException {
        return new MealType(resultSet.getInt("MealTypeID"), resultSet.getString("MealTypeName"));
    }
}
