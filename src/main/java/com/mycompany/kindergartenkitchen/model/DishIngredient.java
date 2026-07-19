package com.mycompany.kindergartenkitchen.model;

/**
 * Model tương ứng bảng DishIngredients.
 * Công thức: 1 món cần những nguyên liệu gì, định lượng cho 1 học sinh.
 */
public class DishIngredient {

    private int dishIngredientId;
    private int dishId;
    private int ingredientId;
    private double quantityPerStudent;

    /* Thông tin bổ sung khi JOIN, không map cột trực tiếp */
    private String dishName;
    private String ingredientName;
    private String unit;

    public DishIngredient() {
    }

    public DishIngredient(int dishIngredientId, int dishId, int ingredientId,
            double quantityPerStudent) {
        this.dishIngredientId = dishIngredientId;
        this.dishId = dishId;
        this.ingredientId = ingredientId;
        this.quantityPerStudent = quantityPerStudent;
    }

    public int getDishIngredientId() {
        return dishIngredientId;
    }

    public void setDishIngredientId(int dishIngredientId) {
        this.dishIngredientId = dishIngredientId;
    }

    public int getDishId() {
        return dishId;
    }

    public void setDishId(int dishId) {
        this.dishId = dishId;
    }

    public int getIngredientId() {
        return ingredientId;
    }

    public void setIngredientId(int ingredientId) {
        this.ingredientId = ingredientId;
    }

    public double getQuantityPerStudent() {
        return quantityPerStudent;
    }

    public void setQuantityPerStudent(double quantityPerStudent) {
        this.quantityPerStudent = quantityPerStudent;
    }

    public String getDishName() {
        return dishName;
    }

    public void setDishName(String dishName) {
        this.dishName = dishName;
    }

    public String getIngredientName() {
        return ingredientName;
    }

    public void setIngredientName(String ingredientName) {
        this.ingredientName = ingredientName;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }
    
    public String getQuantityDisplay() {
        if (unit == null) {
            return String.format("%.2f", quantityPerStudent);
        }
        String u = unit.trim().toLowerCase();
        double value = quantityPerStudent;
        if (u.equals("kg") && value < 1) {
            return Math.round(value * 1000) + " g";
        }
        if ((u.equals("lít") || u.equals("l")) && value < 1) {
            return Math.round(value * 1000) + " ml";
        }
        if (value == Math.floor(value)) {
            return (long) value + " " + unit;
        }
        return String.format("%.2f %s", value, unit);
    }
}
