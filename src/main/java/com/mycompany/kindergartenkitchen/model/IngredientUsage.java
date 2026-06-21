package com.mycompany.kindergartenkitchen.model;

import java.sql.Date;

/**
 * Model tương ứng bảng IngredientUsages.
 * Lưu lại nguyên liệu thực tế bếp đã dùng trong ngày.
 */
public class IngredientUsage {

    private int usageId;
    private int ingredientId;
    private double quantityUsed;
    private Date usageDate;
    private int updatedBy;
    private String note;

    /* Thông tin bổ sung khi JOIN */
    private String ingredientName;
    private String unit;
    private String updatedByName;

    public IngredientUsage() {
    }

    public IngredientUsage(int ingredientId, double quantityUsed, Date usageDate,
            int updatedBy, String note) {
        this.ingredientId = ingredientId;
        this.quantityUsed = quantityUsed;
        this.usageDate = usageDate;
        this.updatedBy = updatedBy;
        this.note = note;
    }

    public int getUsageId() {
        return usageId;
    }

    public void setUsageId(int usageId) {
        this.usageId = usageId;
    }

    public int getIngredientId() {
        return ingredientId;
    }

    public void setIngredientId(int ingredientId) {
        this.ingredientId = ingredientId;
    }

    public double getQuantityUsed() {
        return quantityUsed;
    }

    public void setQuantityUsed(double quantityUsed) {
        this.quantityUsed = quantityUsed;
    }

    public Date getUsageDate() {
        return usageDate;
    }

    public void setUsageDate(Date usageDate) {
        this.usageDate = usageDate;
    }

    public int getUpdatedBy() {
        return updatedBy;
    }

    public void setUpdatedBy(int updatedBy) {
        this.updatedBy = updatedBy;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
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

    public String getUpdatedByName() {
        return updatedByName;
    }

    public void setUpdatedByName(String updatedByName) {
        this.updatedByName = updatedByName;
    }
}
