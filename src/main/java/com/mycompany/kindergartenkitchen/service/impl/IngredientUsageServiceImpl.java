package com.mycompany.kindergartenkitchen.service.impl;

import com.mycompany.kindergartenkitchen.dao.IngredientDao;
import com.mycompany.kindergartenkitchen.dao.IngredientUsageDao;
import com.mycompany.kindergartenkitchen.dao.impl.IngredientDaoImpl;
import com.mycompany.kindergartenkitchen.dao.impl.IngredientUsageDaoImpl;
import com.mycompany.kindergartenkitchen.model.Ingredient;
import com.mycompany.kindergartenkitchen.model.IngredientUsage;
import com.mycompany.kindergartenkitchen.service.IngredientUsageService;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

/**
 * Triển khai nghiệp vụ ghi nhận nguyên liệu đã dùng.
 * Chuyển từ controller.IngredientUsageController sang service.impl.IngredientUsageServiceImpl.
 */
public class IngredientUsageServiceImpl implements IngredientUsageService {

    private final IngredientUsageDao ingredientUsageDao;
    private final IngredientDao ingredientDao;

    public IngredientUsageServiceImpl() {
        this.ingredientUsageDao = new IngredientUsageDaoImpl();
        this.ingredientDao = new IngredientDaoImpl();
    }

    @Override
    public List<IngredientUsage> getUsageByDate(Date usageDate) throws SQLException {
        return ingredientUsageDao.findByDate(usageDate);
    }

    @Override
    public boolean recordUsage(int ingredientId, double quantityUsed, Date usageDate,
            int updatedBy, String note) {

        if (quantityUsed <= 0) {
            return false;
        }

        IngredientUsage ingredientUsage
                = new IngredientUsage(ingredientId, quantityUsed, usageDate, updatedBy, note);

        try {
            int usageId = ingredientUsageDao.insert(ingredientUsage);
            if (usageId <= 0) {
                return false;
            }

            Ingredient ingredient = ingredientDao.findById(ingredientId);
            if (ingredient == null) {
                return false;
            }

            double newStock = Math.max(0, ingredient.getQuantityInStock() - quantityUsed);
            return ingredientDao.updateStock(ingredientId, newStock);

        } catch (SQLException exception) {
            return false;
        }
    }

    @Override
    public boolean updateUsage(int usageId, double quantityUsed, String note) {
        IngredientUsage ingredientUsage = new IngredientUsage();
        ingredientUsage.setUsageId(usageId);
        ingredientUsage.setQuantityUsed(quantityUsed);
        ingredientUsage.setNote(note);

        try {
            return ingredientUsageDao.update(ingredientUsage);
        } catch (SQLException exception) {
            return false;
        }
    }
}
