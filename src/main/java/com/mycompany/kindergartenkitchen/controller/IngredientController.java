package com.mycompany.kindergartenkitchen.controller;

import com.mycompany.kindergartenkitchen.dao.IngredientDao;
import com.mycompany.kindergartenkitchen.dao.impl.IngredientDaoImpl;
import com.mycompany.kindergartenkitchen.model.Ingredient;
import java.sql.SQLException;
import java.util.List;

/**
 * Controller xử lý nghiệp vụ liên quan đến Ingredient.
 * Servlet gọi Controller, Controller gọi DAO.
 */
public class IngredientController {

    private static final double DEFAULT_LOW_STOCK_THRESHOLD = 5.0;

    private final IngredientDao ingredientDao;

    public IngredientController() {
        this.ingredientDao = new IngredientDaoImpl();
    }

    public List<Ingredient> getAllIngredient() throws SQLException {
        return ingredientDao.findAll();
    }

    public Ingredient getIngredientById(int ingredientId) throws SQLException {
        return ingredientDao.findById(ingredientId);
    }

    public boolean createIngredient(String ingredientName, String unit, double quantityInStock) {
        if (ingredientName == null || ingredientName.isBlank()) {
            return false;
        }
        if (unit == null || unit.isBlank()) {
            return false;
        }
        if (quantityInStock < 0) {
            return false;
        }

        Ingredient ingredient = new Ingredient();
        ingredient.setIngredientName(ingredientName.trim());
        ingredient.setUnit(unit.trim());
        ingredient.setQuantityInStock(quantityInStock);

        try {
            return ingredientDao.insert(ingredient) > 0;
        } catch (SQLException exception) {
            return false;
        }
    }

    public boolean updateIngredient(int ingredientId, String ingredientName,
            String unit, double quantityInStock) {

        if (ingredientName == null || ingredientName.isBlank()) {
            return false;
        }

        Ingredient ingredient = new Ingredient();
        ingredient.setIngredientId(ingredientId);
        ingredient.setIngredientName(ingredientName.trim());
        ingredient.setUnit(unit.trim());
        ingredient.setQuantityInStock(quantityInStock);

        try {
            return ingredientDao.update(ingredient);
        } catch (SQLException exception) {
            return false;
        }
    }

    public boolean deactivateIngredient(int ingredientId) {
        try {
            return ingredientDao.deactivate(ingredientId);
        } catch (SQLException exception) {
            return false;
        }
    }

    public List<Ingredient> getLowStockIngredient() throws SQLException {
        return ingredientDao.findLowStock(DEFAULT_LOW_STOCK_THRESHOLD);
    }
}
