package com.mycompany.kindergartenkitchen.dao;

import com.mycompany.kindergartenkitchen.model.Notification;
import java.sql.SQLException;
import java.util.List;

/**
 * DAO Rules: bắt buộc sử dụng Interface.
 * Định nghĩa thao tác cho bảng Notifications.
 */
public interface NotificationDao {

    int insert(Notification notification) throws SQLException;

    Notification findById(int notificationId) throws SQLException;

    List<Notification> findAll() throws SQLException;
}
