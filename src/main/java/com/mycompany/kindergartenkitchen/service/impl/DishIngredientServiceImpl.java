package com.mycompany.kindergartenkitchen.service.impl;

import com.mycompany.kindergartenkitchen.dao.DishDao;
import com.mycompany.kindergartenkitchen.dao.DishIngredientDao;
import com.mycompany.kindergartenkitchen.dao.impl.DishDaoImpl;
import com.mycompany.kindergartenkitchen.dao.impl.DishIngredientDaoImpl;
import com.mycompany.kindergartenkitchen.model.Dish;
import com.mycompany.kindergartenkitchen.model.DishIngredient;
import com.mycompany.kindergartenkitchen.service.DishIngredientService;
import java.sql.SQLException;
import java.util.List;

public class DishIngredientServiceImpl implements DishIngredientService {

    private final DishIngredientDao dishIngredientDao;
    private final DishDao dishDao;

    public DishIngredientServiceImpl() {
        this.dishIngredientDao = new DishIngredientDaoImpl();
        this.dishDao = new DishDaoImpl();
    }

    @Override
    public List<DishIngredient> getAllDishIngredient() throws SQLException {
        return dishIngredientDao.findAll();
    }

    @Override
    public List<DishIngredient> getByDishId(int dishId) throws SQLException {
        return dishIngredientDao.findByDishId(dishId);
    }

    @Override
    public List<Dish> getAllActiveDishOptions() throws SQLException {
        return dishDao.findAllActive();
    }

    @Override
    public DishIngredient getById(int dishIngredientId) throws SQLException {
        return dishIngredientDao.findById(dishIngredientId);
    }

    @Override
    public boolean createDishIngredient(int dishId, int ingredientId, double quantityPerStudent)
            throws SQLException {

        if (quantityPerStudent <= 0) {
            return false;
        }

        // Không cho thêm trùng nguyên liệu trong cùng 1 món (nên sửa định lượng thay vì thêm mới)
        for (DishIngredient existing : dishIngredientDao.findByDishId(dishId)) {
            if (existing.getIngredientId() == ingredientId) {
                return false;
            }
        }

        DishIngredient dishIngredient = new DishIngredient(0, dishId, ingredientId, quantityPerStudent);
        return dishIngredientDao.insert(dishIngredient) > 0;
    }

    @Override
    public boolean updateDishIngredient(int dishIngredientId, double quantityPerStudent)
            throws SQLException {

        if (quantityPerStudent <= 0) {
            return false;
        }
        DishIngredient dishIngredient = dishIngredientDao.findById(dishIngredientId);
        if (dishIngredient == null) {
            return false;
        }
        dishIngredient.setQuantityPerStudent(quantityPerStudent);
        return dishIngredientDao.update(dishIngredient);
    }

    @Override
    public boolean deleteDishIngredient(int dishIngredientId) throws SQLException {
        return dishIngredientDao.delete(dishIngredientId);
    }
}
