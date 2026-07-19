package com.mycompany.kindergartenkitchen.dao.impl;

import com.mycompany.kindergartenkitchen.dao.DBContext;
import com.mycompany.kindergartenkitchen.dao.MenuDetailDao;
import com.mycompany.kindergartenkitchen.model.MenuDetail;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class MenuDetailDaoImpl implements MenuDetailDao {

    private final DBContext db = new DBContext();

    private static final String SQL_FIND_BY_MENU_ID
            = "SELECT md.MenuDetailID, md.MenuID, md.MenuDate, md.MealTypeID, md.DishID, "
            + "d.DishName, mt.MealTypeName "
            + "FROM MenuDetails md "
            + "JOIN Dishes d ON md.DishID = d.DishID "
            + "JOIN MealTypes mt ON md.MealTypeID = mt.MealTypeID "
            + "WHERE md.MenuID = ? "
            + "ORDER BY md.MenuDate, md.MealTypeID";

    private static final String SQL_EXISTS
            = "SELECT COUNT(*) FROM MenuDetails "
            + "WHERE MenuID = ? AND MenuDate = ? AND MealTypeID = ? AND DishID = ?";

    private static final String SQL_INSERT
            = "INSERT INTO MenuDetails (MenuID, MenuDate, MealTypeID, DishID) VALUES (?, ?, ?, ?)";

    private static final String SQL_DELETE_BY_ID
            = "DELETE FROM MenuDetails WHERE MenuDetailID = ?";

    private static final String SQL_DELETE_BY_MENU_ID
            = "DELETE FROM MenuDetails WHERE MenuID = ?";

    @Override
    public List<MenuDetail> findByMenuId(int menuId) throws SQLException {
        List<MenuDetail> menuDetailList = new ArrayList<>();
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_FIND_BY_MENU_ID)) {

            statement.setInt(1, menuId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    menuDetailList.add(mapResultSetToMenuDetail(resultSet));
                }
            }
        } catch (Exception e) {
            throw new SQLException("Lỗi DBContext: " + e.getMessage());
        }
        return menuDetailList;
    }

    @Override
    public boolean exists(int menuId, Date menuDate, int mealTypeId, int dishId) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_EXISTS)) {

            statement.setInt(1, menuId);
            statement.setDate(2, menuDate);
            statement.setInt(3, mealTypeId);
            statement.setInt(4, dishId);
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

    @Override
    public int insert(MenuDetail menuDetail) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement
                        = connection.prepareStatement(SQL_INSERT, Statement.RETURN_GENERATED_KEYS)) {

            statement.setInt(1, menuDetail.getMenuId());
            statement.setDate(2, menuDetail.getMenuDate());
            statement.setInt(3, menuDetail.getMealTypeId());
            statement.setInt(4, menuDetail.getDishId());
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
    public boolean deleteById(int menuDetailId) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_DELETE_BY_ID)) {

            statement.setInt(1, menuDetailId);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            throw new SQLException("Lỗi DBContext: " + e.getMessage());
        }
    }

    @Override
    public boolean deleteByMenuId(int menuId) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_DELETE_BY_MENU_ID)) {

            statement.setInt(1, menuId);
            statement.executeUpdate();
            return true;
        } catch (Exception e) {
            throw new SQLException("Lỗi DBContext: " + e.getMessage());
        }
    }

    private MenuDetail mapResultSetToMenuDetail(ResultSet resultSet) throws SQLException {
        MenuDetail menuDetail = new MenuDetail();
        menuDetail.setMenuDetailId(resultSet.getInt("MenuDetailID"));
        menuDetail.setMenuId(resultSet.getInt("MenuID"));
        menuDetail.setMenuDate(resultSet.getDate("MenuDate"));
        menuDetail.setMealTypeId(resultSet.getInt("MealTypeID"));
        menuDetail.setDishId(resultSet.getInt("DishID"));
        menuDetail.setDishName(resultSet.getString("DishName"));
        menuDetail.setMealTypeName(resultSet.getString("MealTypeName"));
        return menuDetail;
    }
}
