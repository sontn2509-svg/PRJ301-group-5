package com.mycompany.kindergartenkitchen.model;

import java.sql.Date;

/**
 * Model cho bảng MenuDetails (1 món ăn được gắn vào 1 ngày + 1 bữa của thực
 * đơn). Mỗi ngày/bữa có thể có nhiều dòng (nhiều món trong cùng 1 bữa).
 * dishName, mealTypeName là các trường JOIN thêm để hiển thị, không phải cột thật.
 */
public class MenuDetail {

    private int menuDetailId;
    private int menuId;
    private Date menuDate;
    private int mealTypeId;
    private int dishId;
    private String dishName;
    private String mealTypeName;

    public MenuDetail() {
    }

    public MenuDetail(int menuDetailId, int menuId, Date menuDate, int mealTypeId, int dishId) {
        this.menuDetailId = menuDetailId;
        this.menuId = menuId;
        this.menuDate = menuDate;
        this.mealTypeId = mealTypeId;
        this.dishId = dishId;
    }

    public int getMenuDetailId() {
        return menuDetailId;
    }

    public void setMenuDetailId(int menuDetailId) {
        this.menuDetailId = menuDetailId;
    }

    public int getMenuId() {
        return menuId;
    }

    public void setMenuId(int menuId) {
        this.menuId = menuId;
    }

    public Date getMenuDate() {
        return menuDate;
    }

    public void setMenuDate(Date menuDate) {
        this.menuDate = menuDate;
    }

    public int getMealTypeId() {
        return mealTypeId;
    }

    public void setMealTypeId(int mealTypeId) {
        this.mealTypeId = mealTypeId;
    }

    public int getDishId() {
        return dishId;
    }

    public void setDishId(int dishId) {
        this.dishId = dishId;
    }

    public String getDishName() {
        return dishName;
    }

    public void setDishName(String dishName) {
        this.dishName = dishName;
    }

    public String getMealTypeName() {
        return mealTypeName;
    }

    public void setMealTypeName(String mealTypeName) {
        this.mealTypeName = mealTypeName;
    }
}
