package com.mycompany.kindergartenkitchen.model;

public class ClassInfo {

    private int classID;
    private String className;
    private int levelID;
    private String levelName;
    private int teacherID;
    private String teacherName;
    private boolean status;

    public ClassInfo() {
    }

    public ClassInfo(int classID, String className, int levelID, String levelName,
            int teacherID, String teacherName, boolean status) {
        this.classID = classID;
        this.className = className;
        this.levelID = levelID;
        this.levelName = levelName;
        this.teacherID = teacherID;
        this.teacherName = teacherName;
        this.status = status;
    }

    public int getClassID() {
        return classID;
    }

    public String getClassName() {
        return className;
    }

    public int getLevelID() {
        return levelID;
    }

    public String getLevelName() {
        return levelName;
    }

    public int getTeacherID() {
        return teacherID;
    }

    public String getTeacherName() {
        return teacherName;
    }

    public boolean isStatus() {
        return status;
    }
}
