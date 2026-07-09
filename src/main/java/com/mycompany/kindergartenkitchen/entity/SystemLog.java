package com.mycompany.kindergartenkitchen.entity;

import java.time.LocalDateTime;

/*
  Model cho bang SystemLogs - ghi nhan cac hoat dong trong he thong. 
  - userId co the null (action he thong)
  - recordId co the null (action khong lien quan ban ghi)
  - Cac action pho bien: LOGIN, LOGOUT, CREATE_USER, UPDATE_USER, 
    DELETE_USER, TOGGLE_USER_STATUS, CHANGE_PASSWORD, RESET_PASSWORD
 */
public class SystemLog {
    private int logId;
    private Integer userId;
    private String username;
    private String fullName;
    private String action;
    private String tableName;
    private Integer recordId;
    private String description;
    private LocalDateTime createdAt;

    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public Integer getRecordId() {
        return recordId;
    }

    public void setRecordId(Integer recordId) {
        this.recordId = recordId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
