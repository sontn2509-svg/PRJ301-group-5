/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.kindergartenkitchen.model;

import java.sql.Date;

/**
 *
 * @author VuongNguyen
 */
public class MealCount {

    private Date attendanceDate;
    private int classID;
    private String className;
    private String levelName;
    private int presentCount;
    private int mealCount;

    public MealCount() {
    }

    public MealCount(Date attendanceDate, int classID, String className,
            String levelName, int presentCount, int mealCount) {
        this.attendanceDate = attendanceDate;
        this.classID = classID;
        this.className = className;
        this.levelName = levelName;
        this.presentCount = presentCount;
        this.mealCount = mealCount;
    }

    public Date getAttendanceDate() {
        return attendanceDate;
    }

    public void setAttendanceDate(Date attendanceDate) {
        this.attendanceDate = attendanceDate;
    }

    public int getClassID() {
        return classID;
    }

    public void setClassID(int classID) {
        this.classID = classID;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public String getLevelName() {
        return levelName;
    }

    public void setLevelName(String levelName) {
        this.levelName = levelName;
    }

    public int getPresentCount() {
        return presentCount;
    }

    public void setPresentCount(int presentCount) {
        this.presentCount = presentCount;
    }

    public int getMealCount() {
        return mealCount;
    }

    public void setMealCount(int mealCount) {
        this.mealCount = mealCount;
    }
}
