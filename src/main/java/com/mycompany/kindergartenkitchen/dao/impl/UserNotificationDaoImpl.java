package com.mycompany.kindergartenkitchen.dao.impl;

import com.mycompany.kindergartenkitchen.config.DbConnection;
import com.mycompany.kindergartenkitchen.dao.UserNotificationDao;
import com.mycompany.kindergartenkitchen.model.UserNotification;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Implementation của UserNotificationDao.
 * Gắn 1 thông báo cho 1 user cụ thể, theo dõi trạng thái đã đọc.
 */
public class UserNotificationDaoImpl implements UserNotificationDao {

    private static final String SQL_INSERT
            = "INSERT INTO UserNotifications (NotificationID, UserID, IsRead) VALUES (?, ?, 0)";

    private static final String SQL_FIND_BY_USER_ID
            = "SELECT un.UserNotificationID, un.NotificationID, un.UserID, un.IsRead, un.ReadAt, "
            + "n.Title, n.Message, n.NotificationType, n.CreatedAt "
            + "FROM UserNotifications un "
            + "JOIN Notifications n ON un.NotificationID = n.NotificationID "
            + "WHERE un.UserID = ? "
            + "ORDER BY n.CreatedAt DESC";

    private static final String SQL_MARK_AS_READ
            = "UPDATE UserNotifications SET IsRead = 1, ReadAt = GETDATE() "
            + "WHERE UserNotificationID = ?";

    private static final String SQL_COUNT_UNREAD
            = "SELECT COUNT(*) AS UnreadCount FROM UserNotifications "
            + "WHERE UserID = ? AND IsRead = 0";

    @Override
    public int insert(int notificationId, int userId) throws SQLException {
        try (Connection connection = DbConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(
                        SQL_INSERT, Statement.RETURN_GENERATED_KEYS)) {

            statement.setInt(1, notificationId);
            statement.setInt(2, userId);
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
    public List<UserNotification> findByUserId(int userId) throws SQLException {
        List<UserNotification> notificationList = new ArrayList<>();
        try (Connection connection = DbConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_FIND_BY_USER_ID)) {

            statement.setInt(1, userId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    notificationList.add(mapResultSetToUserNotification(resultSet));
                }
            }
        }
        return notificationList;
    }

    @Override
    public boolean markAsRead(int userNotificationId) throws SQLException {
        try (Connection connection = DbConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_MARK_AS_READ)) {

            statement.setInt(1, userNotificationId);
            return statement.executeUpdate() > 0;
        }
    }

    @Override
    public int countUnreadByUserId(int userId) throws SQLException {
        try (Connection connection = DbConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_COUNT_UNREAD)) {

            statement.setInt(1, userId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt("UnreadCount");
                }
            }
        }
        return 0;
    }

    private UserNotification mapResultSetToUserNotification(ResultSet resultSet) throws SQLException {
        UserNotification userNotification = new UserNotification();
        userNotification.setUserNotificationId(resultSet.getInt("UserNotificationID"));
        userNotification.setNotificationId(resultSet.getInt("NotificationID"));
        userNotification.setUserId(resultSet.getInt("UserID"));
        userNotification.setRead(resultSet.getBoolean("IsRead"));
        userNotification.setReadAt(resultSet.getTimestamp("ReadAt"));
        userNotification.setTitle(resultSet.getString("Title"));
        userNotification.setMessage(resultSet.getString("Message"));
        userNotification.setNotificationType(resultSet.getString("NotificationType"));
        userNotification.setCreatedAt(resultSet.getTimestamp("CreatedAt"));
        return userNotification;
    }
}
