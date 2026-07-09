package com.mycompany.kindergartenkitchen.service.impl;

import com.mycompany.kindergartenkitchen.dao.DishDao;
import com.mycompany.kindergartenkitchen.dao.impl.DishDaoImpl;
import com.mycompany.kindergartenkitchen.model.Dish;
import com.mycompany.kindergartenkitchen.service.DishService;
import java.sql.SQLException;
import java.util.List;

public class DishServiceImpl implements DishService {

    private final DishDao dishDao;

    public DishServiceImpl() {
        this.dishDao = new DishDaoImpl();
    }

    DishServiceImpl(DishDao dishDao) {
        this.dishDao = dishDao;
    }

    @Override
    public List<Dish> getAllDish() throws SQLException {
        return dishDao.findAll();
    }

    @Override
    public List<Dish> getAllActiveDish() throws SQLException {
        return dishDao.findAllActive();
    }

    @Override
    public Dish getById(int dishId) throws SQLException {
        return dishDao.findById(dishId);
    }

    @Override
    public boolean createDish(String dishName, String description) throws SQLException {
        if (dishName == null || dishName.isBlank()) {
            return false;
        }
        if (isDuplicateActiveName(dishName, -1)) {
            return false;
        }
        Dish dish = new Dish(0, dishName.trim(), description, true);
        return dishDao.insert(dish) > 0;
    }

    @Override
    public boolean updateDish(int dishId, String dishName, String description) throws SQLException {
        if (dishName == null || dishName.isBlank()) {
            return false;
        }
        Dish existing = dishDao.findById(dishId);
        if (existing == null) {
            return false;
        }
        if (isDuplicateActiveName(dishName, dishId)) {
            return false;
        }
        existing.setDishName(dishName.trim());
        existing.setDescription(description);
        return dishDao.update(existing);
    }

    @Override
    public boolean setStatus(int dishId, boolean status) throws SQLException {
        return dishDao.setStatus(dishId, status);
    }

    private boolean isDuplicateActiveName(String dishName, int excludeDishId) throws SQLException {
        for (Dish dish : dishDao.findAllActive()) {
            if (dish.getDishId() != excludeDishId && dish.getDishName().equalsIgnoreCase(dishName.trim())) {
                return true;
            }
        }
        return false;
    }
}
