package com.mycompany.kindergartenkitchen.model;

import java.sql.Date;

/**
 * Model cho bảng Menus (thực đơn theo tuần cho 1 cấp học).
 * Status: 1 = đã công bố (phụ huynh xem được), 0 = nháp/ẩn.
 * levelName, createdByName là các trường JOIN thêm để hiển thị, không phải cột thật.
 */
public class Menu {

    private int menuId;
    private int levelId;
    private Date weekStartDate;
    private Date weekEndDate;
    private int createdBy;
    private boolean status;
    private String levelName;
    private String createdByName;

    public Menu() {
    }

    public Menu(int menuId, int levelId, Date weekStartDate, Date weekEndDate,
            int createdBy, boolean status) {
        this.menuId = menuId;
        this.levelId = levelId;
        this.weekStartDate = weekStartDate;
        this.weekEndDate = weekEndDate;
        this.createdBy = createdBy;
        this.status = status;
    }

    public int getMenuId() {
        return menuId;
    }

    public void setMenuId(int menuId) {
        this.menuId = menuId;
    }

    public int getLevelId() {
        return levelId;
    }

    public void setLevelId(int levelId) {
        this.levelId = levelId;
    }

    public Date getWeekStartDate() {
        return weekStartDate;
    }

    public void setWeekStartDate(Date weekStartDate) {
        this.weekStartDate = weekStartDate;
    }

    public Date getWeekEndDate() {
        return weekEndDate;
    }

    public void setWeekEndDate(Date weekEndDate) {
        this.weekEndDate = weekEndDate;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public String getLevelName() {
        return levelName;
    }

    public void setLevelName(String levelName) {
        this.levelName = levelName;
    }

    public String getCreatedByName() {
        return createdByName;
    }

    public void setCreatedByName(String createdByName) {
        this.createdByName = createdByName;
    }
}
