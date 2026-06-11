/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package com.mycompany.kindergartenkitchen.model;

/**
 *
 * @author VuongNguyen
 */
public class LevelInfo {

    private int levelID;
    private String levelName;
    private String description;

    public LevelInfo() {
    }

    public LevelInfo(int levelID, String levelName, String description) {
        this.levelID = levelID;
        this.levelName = levelName;
        this.description = description;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
    
}
