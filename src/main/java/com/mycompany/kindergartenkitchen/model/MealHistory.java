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
public class MealHistory {

    private int studentID;
    private String studentName;
    private String className;
    private String levelName;
    private Date menuDate;
    private String mealTypeName;
    private String dishName;
    private String attendanceStatus;
    private boolean charged;
    private String note;

    public MealHistory() {
    }

    public MealHistory(int studentID, String studentName, String className,
            String levelName, Date menuDate, String mealTypeName,
            String dishName, String attendanceStatus, boolean charged, String note) {
        this.studentID = studentID;
        this.studentName = studentName;
        this.className = className;
        this.levelName = levelName;
        this.menuDate = menuDate;
        this.mealTypeName = mealTypeName;
        this.dishName = dishName;
        this.attendanceStatus = attendanceStatus;
        this.charged = charged;
        this.note = note;
    }

    public int getStudentID() {
        return studentID;
    }

    public void setStudentID(int studentID) {
        this.studentID = studentID;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
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

    public Date getMenuDate() {
        return menuDate;
    }

    public void setMenuDate(Date menuDate) {
        this.menuDate = menuDate;
    }

    public String getMealTypeName() {
        return mealTypeName;
    }

    public void setMealTypeName(String mealTypeName) {
        this.mealTypeName = mealTypeName;
    }

    public String getDishName() {
        return dishName;
    }

    public void setDishName(String dishName) {
        this.dishName = dishName;
    }

    public String getAttendanceStatus() {
        return attendanceStatus;
    }

    public void setAttendanceStatus(String attendanceStatus) {
        this.attendanceStatus = attendanceStatus;
    }

    public boolean isCharged() {
        return charged;
    }

    public void setCharged(boolean charged) {
        this.charged = charged;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getAttendanceStatusText() {
        if ("Present".equalsIgnoreCase(attendanceStatus)) {
            return "Có mặt";
        }

        if ("Absent".equalsIgnoreCase(attendanceStatus)) {
            return "Vắng";
        }

        return "Chưa điểm danh";
    }

    public String getChargedText() {
        return charged ? "Có tính tiền ăn" : "Không tính tiền ăn";
    }
}
