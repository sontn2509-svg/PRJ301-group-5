package com.mycompany.kindergartenkitchen.dao.impl;

import com.mycompany.kindergartenkitchen.config.DbConnection;
import com.mycompany.kindergartenkitchen.dao.NotificationDao;
import com.mycompany.kindergartenkitchen.model.Notification;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Implementation của NotificationDao.
 * Lưu nội dung thông báo (chưa gắn với user cụ thể).
 */
public class NotificationDaoImpl implements NotificationDao {

    private static final String SQL_INSERT
            = "INSERT INTO Notifications (Title, Message, NotificationType, RelatedID, CreatedBy) "
            + "VALUES (?, ?, ?, ?, ?)";

    private static final String SQL_FIND_BY_ID
            = "SELECT NotificationID, Title, Message, NotificationType, RelatedID, "
            + "CreatedBy, CreatedAt, Status FROM Notifications WHERE NotificationID = ?";

    private static final String SQL_FIND_ALL
            = "SELECT NotificationID, Title, Message, NotificationType, RelatedID, "
            + "CreatedBy, CreatedAt, Status FROM Notifications ORDER BY CreatedAt DESC";

    @Override
    public int insert(Notification notification) throws SQLException {
        try (Connection connection = DbConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(
                        SQL_INSERT, Statement.RETURN_GENERATED_KEYS)) {

            statement.setString(1, notification.getTitle());
            statement.setString(2, notification.getMessage());
            statement.setString(3, notification.getNotificationType());

            if (notification.getRelatedId() != null) {
                statement.setInt(4, notification.getRelatedId());
            } else {
                statement.setNull(4, java.sql.Types.INTEGER);
            }

            if (notification.getCreatedBy() != null) {
                statement.setInt(5, notification.getCreatedBy());
            } else {
                statement.setNull(5, java.sql.Types.INTEGER);
            }

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
    public Notification findById(int notificationId) throws SQLException {
        try (Connection connection = DbConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_FIND_BY_ID)) {

            statement.setInt(1, notificationId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapResultSetToNotification(resultSet);
                }
            }
        }
        return null;
    }

    @Override
    public List<Notification> findAll() throws SQLException {
        List<Notification> notificationList = new ArrayList<>();
        try (Connection connection = DbConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_FIND_ALL);
                ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                notificationList.add(mapResultSetToNotification(resultSet));
            }
        }
        return notificationList;
    }

    private Notification mapResultSetToNotification(ResultSet resultSet) throws SQLException {
        Notification notification = new Notification();
        notification.setNotificationId(resultSet.getInt("NotificationID"));
        notification.setTitle(resultSet.getString("Title"));
        notification.setMessage(resultSet.getString("Message"));
        notification.setNotificationType(resultSet.getString("NotificationType"));

        int relatedId = resultSet.getInt("RelatedID");
        notification.setRelatedId(resultSet.wasNull() ? null : relatedId);

        int createdBy = resultSet.getInt("CreatedBy");
        notification.setCreatedBy(resultSet.wasNull() ? null : createdBy);

        notification.setCreatedAt(resultSet.getTimestamp("CreatedAt"));
        notification.setStatus(resultSet.getBoolean("Status"));
        return notification;
    }
}
