package dao;

import model.SystemLog;
import config.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class SystemLogDAO {

    public void create(Integer userId, String action, String tableName, Integer recordId, String description) throws SQLException {
        String sql = """
                INSERT INTO SystemLogs(UserID, Action, TableName, RecordID, Description)
                VALUES (?, ?, ?, ?, ?)
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            if (userId == null) {
                statement.setNull(1, java.sql.Types.INTEGER);
            } else {
                statement.setInt(1, userId);
            }
            statement.setString(2, action);
            statement.setString(3, tableName);
            if (recordId == null) {
                statement.setNull(4, java.sql.Types.INTEGER);
            } else {
                statement.setInt(4, recordId);
            }
            statement.setString(5, description);
            statement.executeUpdate();
        }
    }

    public List<SystemLog> findLatest(String actionKeyword, int limit) throws SQLException {
        String sql = """
                SELECT TOP (?) sl.LogID, sl.UserID, u.Username, u.FullName, sl.Action,
                       sl.TableName, sl.RecordID, sl.Description, sl.CreatedAt
                FROM SystemLogs sl
                LEFT JOIN Users u ON sl.UserID = u.UserID
                WHERE (? = '' OR sl.Action LIKE ? OR sl.Description LIKE ?)
                ORDER BY sl.CreatedAt DESC
                """;
        List<SystemLog> logs = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            String keyword = actionKeyword == null ? "" : actionKeyword.trim();
            String like = "%" + keyword + "%";
            statement.setInt(1, limit);
            statement.setString(2, keyword);
            statement.setString(3, like);
            statement.setString(4, like);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    logs.add(mapLog(resultSet));
                }
            }
        }
        return logs;
    }

    private SystemLog mapLog(ResultSet resultSet) throws SQLException {
        SystemLog log = new SystemLog();
        log.setLogId(resultSet.getInt("LogID"));
        int userId = resultSet.getInt("UserID");
        log.setUserId(resultSet.wasNull() ? null : userId);
        log.setUsername(resultSet.getString("Username"));
        log.setFullName(resultSet.getString("FullName"));
        log.setAction(resultSet.getString("Action"));
        log.setTableName(resultSet.getString("TableName"));
        int recordId = resultSet.getInt("RecordID");
        log.setRecordId(resultSet.wasNull() ? null : recordId);
        log.setDescription(resultSet.getString("Description"));
        Timestamp createdAt = resultSet.getTimestamp("CreatedAt");
        if (createdAt != null) {
            log.setCreatedAt(createdAt.toLocalDateTime());
        }
        return log;
    }
}
