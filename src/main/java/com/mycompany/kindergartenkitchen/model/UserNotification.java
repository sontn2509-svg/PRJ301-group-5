package com.mycompany.kindergartenkitchen.model;

import java.sql.Timestamp;

/**
 * Model tương ứng bảng UserNotifications.
 * Gắn 1 thông báo với 1 user cụ thể, theo dõi trạng thái đã đọc.
 */
public class UserNotification {

    private int userNotificationId;
    private int notificationId;
    private int userId;
    private boolean isRead;
    private Timestamp readAt;

    /* Thông tin bổ sung khi JOIN với Notifications */
    private String title;
    private String message;
    private String notificationType;
    private Timestamp createdAt;

    public UserNotification() {
    }

    public UserNotification(int notificationId, int userId, boolean isRead) {
        this.notificationId = notificationId;
        this.userId = userId;
        this.isRead = isRead;
    }

    public int getUserNotificationId() {
        return userNotificationId;
    }

    public void setUserNotificationId(int userNotificationId) {
        this.userNotificationId = userNotificationId;
    }

    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        isRead = read;
    }

    public Timestamp getReadAt() {
        return readAt;
    }

    public void setReadAt(Timestamp readAt) {
        this.readAt = readAt;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getNotificationType() {
        return notificationType;
    }

    public void setNotificationType(String notificationType) {
        this.notificationType = notificationType;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
