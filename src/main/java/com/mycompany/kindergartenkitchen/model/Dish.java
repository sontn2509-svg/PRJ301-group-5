package com.mycompany.kindergartenkitchen.model;

/**
 * Model cho bảng Dishes (món ăn).
 * Status: 1 = đang dùng, 0 = ngừng dùng.
 */
public class Dish {

    private int dishId;
    private String dishName;
    private String description;
    private boolean status;

    public Dish() {
    }

    public Dish(int dishId, String dishName, String description, boolean status) {
        this.dishId = dishId;
        this.dishName = dishName;
        this.description = description;
        this.status = status;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
}
