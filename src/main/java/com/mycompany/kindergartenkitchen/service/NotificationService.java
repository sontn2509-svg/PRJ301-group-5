package com.mycompany.kindergartenkitchen.service;

import com.mycompany.kindergartenkitchen.model.UserNotification;
import java.sql.SQLException;
import java.util.List;

/**
 * Service xử lý nghiệp vụ thông báo.
 */
public interface NotificationService {

    /**
     * Gửi thông báo tới danh sách người nhận.
     * @return số bản ghi UserNotification được tạo
     */
    int sendNotification(String title, String message, String notificationType,
            Integer relatedId, Integer createdBy, List<Integer> receiverUserIdList)
            throws SQLException;

    List<UserNotification> getNotificationByUserId(int userId) throws SQLException;

    int getUnreadCount(int userId) throws SQLException;

    boolean markAsRead(int userNotificationId);
}
