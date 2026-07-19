package com.mycompany.kindergartenkitchen.service.impl;

import com.mycompany.kindergartenkitchen.dao.IngredientDao;
import com.mycompany.kindergartenkitchen.dao.impl.IngredientDaoImpl;
import com.mycompany.kindergartenkitchen.model.Ingredient;
import com.mycompany.kindergartenkitchen.service.IngredientService;
import java.sql.SQLException;
import java.util.List;

/**
 * Triển khai nghiệp vụ Ingredient.
 
 */
public class IngredientServiceImpl implements IngredientService {

    private static final double DEFAULT_LOW_STOCK_THRESHOLD = 5.0;

    private final IngredientDao ingredientDao;

    public IngredientServiceImpl() {
        this.ingredientDao = new IngredientDaoImpl();
    }

    @Override
    public List<Ingredient> getAllIngredient() throws SQLException {
        return ingredientDao.findAll();
    }

    @Override
    public Ingredient getIngredientById(int ingredientId) throws SQLException {
        return ingredientDao.findById(ingredientId);
    }

    @Override
    public Ingredient findByName(String ingredientName) throws SQLException {
        return ingredientDao.findByName(ingredientName);
    }

    @Override
    public boolean createIngredient(String ingredientName, String unit) {
        if (ingredientName == null || ingredientName.isBlank()) {
            return false;
        }
        if (unit == null || unit.isBlank()) {
            return false;
        }
        try {
            if (isDuplicateActiveName(ingredientName, -1)) {
                return false;
            }
        } catch (SQLException exception) {
            return false;
        }

        Ingredient ingredient = new Ingredient();
        ingredient.setIngredientName(ingredientName.trim());
        ingredient.setUnit(unit.trim());
      
        ingredient.setQuantityInStock(0);

        try {
            return ingredientDao.insert(ingredient) > 0;
        } catch (SQLException exception) {
            return false;
        }
    }

    @Override
    public boolean updateIngredient(int ingredientId, String ingredientName, String unit) {

        if (ingredientName == null || ingredientName.isBlank()) {
            return false;
        }
        try {
            if (isDuplicateActiveName(ingredientName, ingredientId)) {
                return false;
            }
        } catch (SQLException exception) {
            return false;
        }

        Ingredient ingredient = new Ingredient();
        ingredient.setIngredientId(ingredientId);
        ingredient.setIngredientName(ingredientName.trim());
        ingredient.setUnit(unit.trim());
        // Không đụng tới QuantityInStock ở đây — DAO.update() giờ chỉ sửa
        // tên/đơn vị, tồn kho chỉ đổi qua Nhập kho/Sử dụng.

        try {
            return ingredientDao.update(ingredient);
        } catch (SQLException exception) {
            return false;
        }
    }

    
    private boolean isDuplicateActiveName(String ingredientName, int excludeIngredientId) throws SQLException {
        String normalized = ingredientName.trim();
        for (Ingredient existing : ingredientDao.findAll()) {
            if (existing.getIngredientId() != excludeIngredientId
                    && existing.getIngredientName().equalsIgnoreCase(normalized)) {
                return true;
            }
        }
        return false;
    }

    @Override
    public boolean deactivateIngredient(int ingredientId) {
        try {
            return ingredientDao.deactivate(ingredientId);
        } catch (SQLException exception) {
            return false;
        }
    }

    @Override
    public List<Ingredient> getLowStockIngredient() throws SQLException {
        return ingredientDao.findLowStock(DEFAULT_LOW_STOCK_THRESHOLD);
    }
}
