package com.mycompany.kindergartenkitchen.model;

/**
 * Tổng hợp điểm danh theo lớp trong 1 ngày – dùng cho trang
 * manager/attendance.jsp (view chuẩn tham chiếu cho toàn hệ thống).
 */
public class AttendanceClassSummary {

    private int classID;
    private String className;
    private int total;
    private int present;
    private int absent;
    private int absentMeal;

    public AttendanceClassSummary() {
    }

    public AttendanceClassSummary(int classID, String className, int total, int present, int absent, int absentMeal) {
        this.classID = classID;
        this.className = className;
        this.total = total;
        this.present = present;
        this.absent = absent;
        this.absentMeal = absentMeal;
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

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public int getPresent() {
        return present;
    }

    public void setPresent(int present) {
        this.present = present;
    }

    public int getAbsent() {
        return absent;
    }

    public void setAbsent(int absent) {
        this.absent = absent;
    }

    public int getAbsentMeal() {
        return absentMeal;
    }

    public void setAbsentMeal(int absentMeal) {
        this.absentMeal = absentMeal;
    }
}
