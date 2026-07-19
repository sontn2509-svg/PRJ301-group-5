package com.mycompany.kindergartenkitchen.dao.impl;

import com.mycompany.kindergartenkitchen.dao.DBContext;
import com.mycompany.kindergartenkitchen.dao.MenuDao;
import com.mycompany.kindergartenkitchen.model.Menu;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class MenuDaoImpl implements MenuDao {

    private final DBContext db = new DBContext();

    private static final String SQL_FIND_ALL
            = "SELECT mn.MenuID, mn.LevelID, mn.WeekStartDate, mn.WeekEndDate, mn.CreatedBy, mn.Status, "
            + "l.LevelName, u.FullName AS CreatedByName "
            + "FROM Menus mn "
            + "JOIN Levels l ON mn.LevelID = l.LevelID "
            + "JOIN Users u ON mn.CreatedBy = u.UserID "
            + "ORDER BY mn.WeekStartDate DESC";

    private static final String SQL_FIND_BY_LEVEL
            = "SELECT mn.MenuID, mn.LevelID, mn.WeekStartDate, mn.WeekEndDate, mn.CreatedBy, mn.Status, "
            + "l.LevelName, u.FullName AS CreatedByName "
            + "FROM Menus mn "
            + "JOIN Levels l ON mn.LevelID = l.LevelID "
            + "JOIN Users u ON mn.CreatedBy = u.UserID "
            + "WHERE mn.LevelID = ? "
            + "ORDER BY mn.WeekStartDate DESC";

    private static final String SQL_FIND_BY_ID
            = "SELECT mn.MenuID, mn.LevelID, mn.WeekStartDate, mn.WeekEndDate, mn.CreatedBy, mn.Status, "
            + "l.LevelName, u.FullName AS CreatedByName "
            + "FROM Menus mn "
            + "JOIN Levels l ON mn.LevelID = l.LevelID "
            + "JOIN Users u ON mn.CreatedBy = u.UserID "
            + "WHERE mn.MenuID = ?";

    private static final String SQL_FIND_BY_LEVEL_AND_DATE
            = "SELECT mn.MenuID, mn.LevelID, mn.WeekStartDate, mn.WeekEndDate, mn.CreatedBy, mn.Status, "
            + "l.LevelName, u.FullName AS CreatedByName "
            + "FROM Menus mn "
            + "JOIN Levels l ON mn.LevelID = l.LevelID "
            + "JOIN Users u ON mn.CreatedBy = u.UserID "
            + "WHERE mn.LevelID = ? AND ? BETWEEN mn.WeekStartDate AND mn.WeekEndDate";

    private static final String SQL_FIND_BY_LEVEL_AND_WEEK_START
            = "SELECT mn.MenuID, mn.LevelID, mn.WeekStartDate, mn.WeekEndDate, mn.CreatedBy, mn.Status, "
            + "l.LevelName, u.FullName AS CreatedByName "
            + "FROM Menus mn "
            + "JOIN Levels l ON mn.LevelID = l.LevelID "
            + "JOIN Users u ON mn.CreatedBy = u.UserID "
            + "WHERE mn.LevelID = ? AND mn.WeekStartDate = ?";

    private static final String SQL_INSERT
            = "INSERT INTO Menus (LevelID, WeekStartDate, WeekEndDate, CreatedBy, Status) "
            + "VALUES (?, ?, ?, ?, 1)";

    private static final String SQL_SET_STATUS
            = "UPDATE Menus SET Status = ? WHERE MenuID = ?";

    private static final String SQL_DELETE
            = "DELETE FROM Menus WHERE MenuID = ?";

    @Override
    public List<Menu> findAll() throws SQLException {
        List<Menu> menuList = new ArrayList<>();
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_FIND_ALL);
                ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                menuList.add(mapResultSetToMenu(resultSet));
            }
        } catch (Exception e) {
            throw new SQLException("Lỗi DBContext: " + e.getMessage());
        }
        return menuList;
    }

    @Override
    public List<Menu> findByLevel(int levelId) throws SQLException {
        List<Menu> menuList = new ArrayList<>();
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_FIND_BY_LEVEL)) {

            statement.setInt(1, levelId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    menuList.add(mapResultSetToMenu(resultSet));
                }
            }
        } catch (Exception e) {
            throw new SQLException("Lỗi DBContext: " + e.getMessage());
        }
        return menuList;
    }

    @Override
    public Menu findById(int menuId) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_FIND_BY_ID)) {

            statement.setInt(1, menuId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapResultSetToMenu(resultSet);
                }
            }
        } catch (Exception e) {
            throw new SQLException("Lỗi DBContext: " + e.getMessage());
        }
        return null;
    }

    @Override
    public Menu findByLevelAndDate(int levelId, Date anyDateInWeek) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_FIND_BY_LEVEL_AND_DATE)) {

            statement.setInt(1, levelId);
            statement.setDate(2, anyDateInWeek);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapResultSetToMenu(resultSet);
                }
            }
        } catch (Exception e) {
            throw new SQLException("Lỗi DBContext: " + e.getMessage());
        }
        return null;
    }

    @Override
    public Menu findByLevelAndWeekStart(int levelId, Date weekStartDate) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_FIND_BY_LEVEL_AND_WEEK_START)) {

            statement.setInt(1, levelId);
            statement.setDate(2, weekStartDate);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapResultSetToMenu(resultSet);
                }
            }
        } catch (Exception e) {
            throw new SQLException("Lỗi DBContext: " + e.getMessage());
        }
        return null;
    }

    @Override
    public int insert(Menu menu) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement
                        = connection.prepareStatement(SQL_INSERT, Statement.RETURN_GENERATED_KEYS)) {

            statement.setInt(1, menu.getLevelId());
            statement.setDate(2, menu.getWeekStartDate());
            statement.setDate(3, menu.getWeekEndDate());
            statement.setInt(4, menu.getCreatedBy());
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
    public boolean setStatus(int menuId, boolean status) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_SET_STATUS)) {

            statement.setBoolean(1, status);
            statement.setInt(2, menuId);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            throw new SQLException("Lỗi DBContext: " + e.getMessage());
        }
    }

    @Override
    public boolean delete(int menuId) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_DELETE)) {

            statement.setInt(1, menuId);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            throw new SQLException("Lỗi DBContext: " + e.getMessage());
        }
    }

    private Menu mapResultSetToMenu(ResultSet resultSet) throws SQLException {
        Menu menu = new Menu();
        menu.setMenuId(resultSet.getInt("MenuID"));
        menu.setLevelId(resultSet.getInt("LevelID"));
        menu.setWeekStartDate(resultSet.getDate("WeekStartDate"));
        menu.setWeekEndDate(resultSet.getDate("WeekEndDate"));
        menu.setCreatedBy(resultSet.getInt("CreatedBy"));
        menu.setStatus(resultSet.getBoolean("Status"));
        menu.setLevelName(resultSet.getString("LevelName"));
        menu.setCreatedByName(resultSet.getString("CreatedByName"));
        return menu;
    }
}
