package com.mycompany.kindergartenkitchen.service;

import com.mycompany.kindergartenkitchen.model.Level;
import java.sql.SQLException;
import java.util.List;

public interface LevelService {

    List<Level> getAllLevel() throws SQLException;

    Level getById(int levelId) throws SQLException;
}
