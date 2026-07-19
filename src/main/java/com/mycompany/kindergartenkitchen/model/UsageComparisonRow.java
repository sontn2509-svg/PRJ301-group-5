package com.mycompany.kindergartenkitchen.model;

/**
 * DTO 1 dòng so sánh nguyên liệu CẦN dùng (theo công thức món trong thực đơn +
 * số suất ăn thực tế) với THỰC TẾ đã được bếp ghi nhận dùng (IngredientUsages)
 * trong cùng 1 ngày.
 *
 * diff = needed - actualUsed. Dương = ghi nhận ít hơn công thức (có thể thiếu
 * ghi nhận); âm = dùng nhiều hơn công thức (có thể hao hụt/lãng phí).
 */
public class UsageComparisonRow {

    private int ingredientId;
    private String ingredientName;
    private String unit;
    private double needed;
    private double actualUsed;
    private double diff;

    public UsageComparisonRow() {
    }

    public UsageComparisonRow(int ingredientId, String ingredientName, String unit,
            double needed, double actualUsed, double diff) {
        this.ingredientId = ingredientId;
        this.ingredientName = ingredientName;
        this.unit = unit;
        this.needed = needed;
        this.actualUsed = actualUsed;
        this.diff = diff;
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

    public double getNeeded() {
        return needed;
    }

    public void setNeeded(double needed) {
        this.needed = needed;
    }

    public double getActualUsed() {
        return actualUsed;
    }

    public void setActualUsed(double actualUsed) {
        this.actualUsed = actualUsed;
    }

    public double getDiff() {
        return diff;
    }

    public void setDiff(double diff) {
        this.diff = diff;
    }

    /**
     * Chuỗi hiển thị thân thiện cho từng cột (tự đổi kg/lít nhỏ sang g/ml).
     * Dùng trực tiếp trong JSP thay vì fmt:formatNumber + unit thô.
     */
    public String getNeededDisplay() {
        return com.mycompany.kindergartenkitchen.util.QuantityFormatter.format(needed, unit);
    }

    public String getActualUsedDisplay() {
        return com.mycompany.kindergartenkitchen.util.QuantityFormatter.format(actualUsed, unit);
    }

    public String getDiffDisplay() {
        return com.mycompany.kindergartenkitchen.util.QuantityFormatter.format(diff, unit);
    }
}
