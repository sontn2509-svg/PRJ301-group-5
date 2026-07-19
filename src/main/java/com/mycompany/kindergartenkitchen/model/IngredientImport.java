package com.mycompany.kindergartenkitchen.model;

import java.sql.Date;

/**
 * Model tương ứng bảng IngredientImports.
 * TotalPrice là computed column phía SQL (Quantity * UnitPrice),
 * nên chỉ có getter, không có setter.
 */
public class IngredientImport {

    private int importId;
    private int ingredientId;
    private double quantity;
    private double unitPrice;
    private double totalPrice;
    private Date importDate;
    private String supplierName;
    private int createdBy;
    private String note;

    /* Thông tin bổ sung khi JOIN */
    private String ingredientName;
    private String unit;
    private String createdByName;

    public IngredientImport() {
    }

    public IngredientImport(int ingredientId, double quantity, double unitPrice,
            Date importDate, String supplierName, int createdBy, String note) {
        this.ingredientId = ingredientId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.importDate = importDate;
        this.supplierName = supplierName;
        this.createdBy = createdBy;
        this.note = note;
    }

    public int getImportId() {
        return importId;
    }

    public void setImportId(int importId) {
        this.importId = importId;
    }

    public int getIngredientId() {
        return ingredientId;
    }

    public void setIngredientId(int ingredientId) {
        this.ingredientId = ingredientId;
    }

    public double getQuantity() {
        return quantity;
    }

    public void setQuantity(double quantity) {
        this.quantity = quantity;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public Date getImportDate() {
        return importDate;
    }

    public void setImportDate(Date importDate) {
        this.importDate = importDate;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
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

    public String getCreatedByName() {
        return createdByName;
    }

    public void setCreatedByName(String createdByName) {
        this.createdByName = createdByName;
    }
}
