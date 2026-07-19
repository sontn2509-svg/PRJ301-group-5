package com.mycompany.kindergartenkitchen.dao;

import com.mycompany.kindergartenkitchen.model.UserNotification;
import java.sql.SQLException;
import java.util.List;

/**
 * DAO Rules: bắt buộc sử dụng Interface.
 * Định nghĩa thao tác cho bảng UserNotifications (gắn thông báo với từng user).
 */
public interface UserNotificationDao {

    int insert(int notificationId, int userId) throws SQLException;

    List<UserNotification> findByUserId(int userId) throws SQLException;

    boolean markAsRead(int userNotificationId) throws SQLException;

    int countUnreadByUserId(int userId) throws SQLException;
}
