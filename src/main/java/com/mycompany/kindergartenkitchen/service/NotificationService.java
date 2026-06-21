package com.mycompany.kindergartenkitchen.service;

import java.sql.SQLException;
import java.util.List;

/**
 * Service Rules: dùng Interface cho tầng nghiệp vụ phức tạp.
 * Gửi thông báo đến nhiều user cùng lúc.
 */
public interface NotificationService {

    int sendNotification(String title, String message, String notificationType,
            Integer relatedId, Integer createdBy, List<Integer> receiverUserIdList)
            throws SQLException;
}
