/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package com.mycompany.kindergartenkitchen.model;

/**
 *
 * @author VuongNguyen
 */
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

    public ClassInfo(int classID, String className, int levelID, String levelName, int teacherID, String teacherName, boolean status) {
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

    public void setClassID(int classID) {
        this.classID = classID;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public int getLevelID() {
        return levelID;
    }

    public void setLevelID(int levelID) {
        this.levelID = levelID;
    }

    public String getLevelName() {
        return levelName;
    }

    public void setLevelName(String levelName) {
        this.levelName = levelName;
    }

    public int getTeacherID() {
        return teacherID;
    }

    public void setTeacherID(int teacherID) {
        this.teacherID = teacherID;
    }

    public String getTeacherName() {
        return teacherName;
    }

    public void setTeacherName(String teacherName) {
        this.teacherName = teacherName;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
    

}
