package com.mycompany.kindergartenkitchen.model;

/**
 * DTO 1 dòng so sánh nguyên liệu CẦN dùng (theo công thức món trong thực đơn +
 * số suất ăn thực tế) với TỒN KHO hiện tại.
 *
 * shortage = needed - stock. Dương = thiếu (cần nhập thêm), Âm hoặc 0 = đủ/dư.
 */
public class IngredientShortageRow {

    private int ingredientId;
    private String ingredientName;
    private String unit;
    private double stock;
    private double needed;
    private double shortage;

    public IngredientShortageRow() {
    }

    public IngredientShortageRow(int ingredientId, String ingredientName, String unit,
            double stock, double needed, double shortage) {
        this.ingredientId = ingredientId;
        this.ingredientName = ingredientName;
        this.unit = unit;
        this.stock = stock;
        this.needed = needed;
        this.shortage = shortage;
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

    public double getStock() {
        return stock;
    }

    public void setStock(double stock) {
        this.stock = stock;
    }

    public double getNeeded() {
        return needed;
    }

    public void setNeeded(double needed) {
        this.needed = needed;
    }

    public double getShortage() {
        return shortage;
    }

    public void setShortage(double shortage) {
        this.shortage = shortage;
    }

    public boolean isBelowStock() {
        return shortage > 0;
    }
}
