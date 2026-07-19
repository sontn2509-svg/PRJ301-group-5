package com.mycompany.kindergartenkitchen.dao.impl;

import com.mycompany.kindergartenkitchen.dao.DBContext;
import com.mycompany.kindergartenkitchen.dao.LevelDao;
import com.mycompany.kindergartenkitchen.model.Level;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class LevelDaoImpl implements LevelDao {

    private final DBContext db = new DBContext();

    private static final String SQL_FIND_ALL
            = "SELECT LevelID, LevelName, Description FROM Levels ORDER BY LevelID";

    private static final String SQL_FIND_BY_ID
            = "SELECT LevelID, LevelName, Description FROM Levels WHERE LevelID = ?";

    @Override
    public List<Level> findAll() throws SQLException {
        List<Level> levelList = new ArrayList<>();
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_FIND_ALL);
                ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                levelList.add(mapResultSetToLevel(resultSet));
            }
        } catch (Exception e) {
            throw new SQLException("Lỗi DBContext: " + e.getMessage());
        }
        return levelList;
    }

    @Override
    public Level findById(int levelId) throws SQLException {
        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_FIND_BY_ID)) {

            statement.setInt(1, levelId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapResultSetToLevel(resultSet);
                }
            }
        } catch (Exception e) {
            throw new SQLException("Lỗi DBContext: " + e.getMessage());
        }
        return null;
    }

    private Level mapResultSetToLevel(ResultSet resultSet) throws SQLException {
        return new Level(resultSet.getInt("LevelID"), resultSet.getString("LevelName"),
                resultSet.getString("Description"));
    }
}
