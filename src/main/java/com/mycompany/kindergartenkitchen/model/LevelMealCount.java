package com.mycompany.kindergartenkitchen.model;

import java.sql.Date;

public class LevelMealCount {

    private Date attendanceDate;
    private String levelName;
    private int mealCount;

    public LevelMealCount() {
    }

    public LevelMealCount(Date attendanceDate, String levelName, int mealCount) {
        this.attendanceDate = attendanceDate;
        this.levelName = levelName;
        this.mealCount = mealCount;
    }

    public Date getAttendanceDate() {
        return attendanceDate;
    }

    public void setAttendanceDate(Date attendanceDate) {
        this.attendanceDate = attendanceDate;
    }

    public String getLevelName() {
        return levelName;
    }

    public void setLevelName(String levelName) {
        this.levelName = levelName;
    }

    public int getMealCount() {
        return mealCount;
    }

    public void setMealCount(int mealCount) {
        this.mealCount = mealCount;
    }
}
