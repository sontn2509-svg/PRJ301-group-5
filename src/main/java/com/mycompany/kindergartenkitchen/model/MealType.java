package com.mycompany.kindergartenkitchen.model;

/**
 * Model cho bảng MealTypes (loại bữa: Sáng / Trưa / Xế...).
 */
public class MealType {

    private int mealTypeId;
    private String mealTypeName;

    public MealType() {
    }

    public MealType(int mealTypeId, String mealTypeName) {
        this.mealTypeId = mealTypeId;
        this.mealTypeName = mealTypeName;
    }

    public int getMealTypeId() {
        return mealTypeId;
    }

    public void setMealTypeId(int mealTypeId) {
        this.mealTypeId = mealTypeId;
    }

    public String getMealTypeName() {
        return mealTypeName;
    }

    public void setMealTypeName(String mealTypeName) {
        this.mealTypeName = mealTypeName;
    }
}
