package com.mycompany.kindergartenkitchen.service.impl;

import com.mycompany.kindergartenkitchen.dao.MealTypeDao;
import com.mycompany.kindergartenkitchen.dao.impl.MealTypeDaoImpl;
import com.mycompany.kindergartenkitchen.model.MealType;
import com.mycompany.kindergartenkitchen.service.MealTypeService;
import java.sql.SQLException;
import java.util.List;

public class MealTypeServiceImpl implements MealTypeService {

    private final MealTypeDao mealTypeDao;

    public MealTypeServiceImpl() {
        this.mealTypeDao = new MealTypeDaoImpl();
    }

    MealTypeServiceImpl(MealTypeDao mealTypeDao) {
        this.mealTypeDao = mealTypeDao;
    }

    @Override
    public List<MealType> getAllMealType() throws SQLException {
        return mealTypeDao.findAll();
    }

    @Override
    public boolean createMealType(String mealTypeName) throws SQLException {
        if (mealTypeName == null || mealTypeName.isBlank()) {
            return false;
        }
        for (MealType mealType : mealTypeDao.findAll()) {
            if (mealType.getMealTypeName().equalsIgnoreCase(mealTypeName.trim())) {
                return false;
            }
        }
        return mealTypeDao.insert(new MealType(0, mealTypeName.trim())) > 0;
    }

    @Override
    public boolean updateMealType(int mealTypeId, String mealTypeName) throws SQLException {
        if (mealTypeName == null || mealTypeName.isBlank()) {
            return false;
        }
        MealType existing = mealTypeDao.findById(mealTypeId);
        if (existing == null) {
            return false;
        }
        existing.setMealTypeName(mealTypeName.trim());
        return mealTypeDao.update(existing);
    }

    @Override
    public boolean deleteMealType(int mealTypeId) throws SQLException {
        if (mealTypeDao.findById(mealTypeId) == null) {
            return false;
        }
        if (mealTypeDao.isInUse(mealTypeId)) {
            return false;
        }
        return mealTypeDao.delete(mealTypeId);
    }
}
