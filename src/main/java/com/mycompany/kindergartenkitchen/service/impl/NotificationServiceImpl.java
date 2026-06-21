package com.mycompany.kindergartenkitchen.service.impl;

import com.mycompany.kindergartenkitchen.dao.NotificationDao;
import com.mycompany.kindergartenkitchen.dao.UserNotificationDao;
import com.mycompany.kindergartenkitchen.dao.impl.NotificationDaoImpl;
import com.mycompany.kindergartenkitchen.dao.impl.UserNotificationDaoImpl;
import com.mycompany.kindergartenkitchen.model.Notification;
import com.mycompany.kindergartenkitchen.service.NotificationService;
import java.sql.SQLException;
import java.util.List;

/**
 * Implementation của NotificationService.
 * Tạo 1 Notification gốc, sau đó gắn cho nhiều user trong UserNotifications.
 */
public class NotificationServiceImpl implements NotificationService {

    private final NotificationDao notificationDao;
    private final UserNotificationDao userNotificationDao;

    public NotificationServiceImpl() {
        this.notificationDao = new NotificationDaoImpl();
        this.userNotificationDao = new UserNotificationDaoImpl();
    }

    @Override
    public int sendNotification(String title, String message, String notificationType,
            Integer relatedId, Integer createdBy, List<Integer> receiverUserIdList)
            throws SQLException {

        Notification notification = new Notification(title, message, notificationType,
                relatedId, createdBy);

        int notificationId = notificationDao.insert(notification);

        if (notificationId > 0 && receiverUserIdList != null) {
            for (Integer userId : receiverUserIdList) {
                userNotificationDao.insert(notificationId, userId);
            }
        }

        return notificationId;
    }
}
