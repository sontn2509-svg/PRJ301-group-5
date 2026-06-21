package com.mycompany.kindergartenkitchen.model;

import java.sql.Timestamp;

/**
 * Model tương ứng bảng Notifications.
 */
public class Notification {

    private int notificationId;
    private String title;
    private String message;
    private String notificationType;
    private Integer relatedId;
    private Integer createdBy;
    private Timestamp createdAt;
    private boolean status;

    public Notification() {
    }

    public Notification(String title, String message, String notificationType,
            Integer relatedId, Integer createdBy) {
        this.title = title;
        this.message = message;
        this.notificationType = notificationType;
        this.relatedId = relatedId;
        this.createdBy = createdBy;
    }

    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
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

    public Integer getRelatedId() {
        return relatedId;
    }

    public void setRelatedId(Integer relatedId) {
        this.relatedId = relatedId;
    }

    public Integer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
}
