package com.mycompany.kindergartenkitchen.service.impl;

import com.mycompany.kindergartenkitchen.dao.LevelDao;
import com.mycompany.kindergartenkitchen.dao.impl.LevelDaoImpl;
import com.mycompany.kindergartenkitchen.model.Level;
import com.mycompany.kindergartenkitchen.service.LevelService;
import java.sql.SQLException;
import java.util.List;

public class LevelServiceImpl implements LevelService {

    private final LevelDao levelDao;

    public LevelServiceImpl() {
        this.levelDao = new LevelDaoImpl();
    }

    LevelServiceImpl(LevelDao levelDao) {
        this.levelDao = levelDao;
    }

    @Override
    public List<Level> getAllLevel() throws SQLException {
        return levelDao.findAll();
    }

    @Override
    public Level getById(int levelId) throws SQLException {
        return levelDao.findById(levelId);
    }
}
