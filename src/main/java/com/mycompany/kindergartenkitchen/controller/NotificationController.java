package com.mycompany.kindergartenkitchen.controller;

import com.mycompany.kindergartenkitchen.dao.UserNotificationDao;
import com.mycompany.kindergartenkitchen.dao.impl.UserNotificationDaoImpl;
import com.mycompany.kindergartenkitchen.model.UserNotification;
import com.mycompany.kindergartenkitchen.service.NotificationService;
import com.mycompany.kindergartenkitchen.service.impl.NotificationServiceImpl;
import java.sql.SQLException;
import java.util.List;

/**
 * Controller xử lý nghiệp vụ thông báo.
 */
public class NotificationController {

    private final NotificationService notificationService;
    private final UserNotificationDao userNotificationDao;

    public NotificationController() {
        this.notificationService = new NotificationServiceImpl();
        this.userNotificationDao = new UserNotificationDaoImpl();
    }

    public List<UserNotification> getNotificationByUserId(int userId) throws SQLException {
        return userNotificationDao.findByUserId(userId);
    }

    public int getUnreadCount(int userId) throws SQLException {
        return userNotificationDao.countUnreadByUserId(userId);
    }

    public boolean markAsRead(int userNotificationId) {
        try {
            return userNotificationDao.markAsRead(userNotificationId);
        } catch (SQLException exception) {
            return false;
        }
    }

    public boolean sendNotification(String title, String message, String notificationType,
            Integer relatedId, Integer createdBy, List<Integer> receiverUserIdList) {

        if (title == null || title.isBlank() || message == null || message.isBlank()) {
            return false;
        }

        try {
            return notificationService.sendNotification(
                    title, message, notificationType, relatedId, createdBy, receiverUserIdList) > 0;
        } catch (SQLException exception) {
            return false;
        }
    }
}
