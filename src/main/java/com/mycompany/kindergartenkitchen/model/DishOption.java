package com.mycompany.kindergartenkitchen.model;

/**
 * Model TẠM THỜI — chỉ dùng để đổ dữ liệu vào dropdown chọn món ăn
 * khi quản lý công thức (DishIngredients). Không map toàn bộ bảng Dishes.
 *
 * Khi P2 (module Thực đơn/Món ăn) bàn giao model Dish.java chính thức,
 * có thể thay thế/xóa class này mà không ảnh hưởng tới các module khác,
 * miễn class thay thế có getDishId()/getDishName() tương đương.
 */
public class DishOption {

    private int dishId;
    private String dishName;

    public DishOption() {
    }

    public DishOption(int dishId, String dishName) {
        this.dishId = dishId;
        this.dishName = dishName;
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
}
