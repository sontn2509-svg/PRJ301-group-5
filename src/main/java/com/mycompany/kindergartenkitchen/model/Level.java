package com.mycompany.kindergartenkitchen.model;

/**
 * Model cho bảng Levels (cấp học: Nhà trẻ / Mẫu giáo...).
 */
public class Level {

    private int levelId;
    private String levelName;
    private String description;

    public Level() {
    }

    public Level(int levelId, String levelName, String description) {
        this.levelId = levelId;
        this.levelName = levelName;
        this.description = description;
    }

    public int getLevelId() {
        return levelId;
    }

    public void setLevelId(int levelId) {
        this.levelId = levelId;
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
