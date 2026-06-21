package com.mycompany.kindergartenkitchen.model;

/**
 * Model tương ứng bảng Ingredients.
 * Quy tắc đặt tên: danh từ số ít.
 */
public class Ingredient {

    private int ingredientId;
    private String ingredientName;
    private String unit;
    private double quantityInStock;
    private boolean status;

    public Ingredient() {
    }

    public Ingredient(int ingredientId, String ingredientName, String unit,
            double quantityInStock, boolean status) {
        this.ingredientId = ingredientId;
        this.ingredientName = ingredientName;
        this.unit = unit;
        this.quantityInStock = quantityInStock;
        this.status = status;
    }

    public int getIngredientId() {
        return ingredientId;
    }

    public void setIngredientId(int ingredientId) {
        this.ingredientId = ingredientId;
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

    public double getQuantityInStock() {
        return quantityInStock;
    }

    public void setQuantityInStock(double quantityInStock) {
        this.quantityInStock = quantityInStock;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Ingredient{" + "ingredientId=" + ingredientId
                + ", ingredientName=" + ingredientName
                + ", unit=" + unit
                + ", quantityInStock=" + quantityInStock
                + ", status=" + status + '}';
    }
}
