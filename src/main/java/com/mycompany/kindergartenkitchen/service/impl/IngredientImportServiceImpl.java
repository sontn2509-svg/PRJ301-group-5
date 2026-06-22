package com.mycompany.kindergartenkitchen.service.impl;

import com.mycompany.kindergartenkitchen.dao.IngredientDao;
import com.mycompany.kindergartenkitchen.dao.IngredientImportDao;
import com.mycompany.kindergartenkitchen.dao.impl.IngredientDaoImpl;
import com.mycompany.kindergartenkitchen.dao.impl.IngredientImportDaoImpl;
import com.mycompany.kindergartenkitchen.model.Ingredient;
import com.mycompany.kindergartenkitchen.model.IngredientImport;
import com.mycompany.kindergartenkitchen.service.IngredientImportService;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

/**
 * Triển khai nghiệp vụ nhập kho.
 * Chuyển từ controller.IngredientImportController sang service.impl.IngredientImportServiceImpl.
 */
public class IngredientImportServiceImpl implements IngredientImportService {

    private final IngredientImportDao ingredientImportDao;
    private final IngredientDao ingredientDao;

    public IngredientImportServiceImpl() {
        this.ingredientImportDao = new IngredientImportDaoImpl();
        this.ingredientDao = new IngredientDaoImpl();
    }

    @Override
    public List<IngredientImport> getAllImport() throws SQLException {
        return ingredientImportDao.findAll();
    }

    @Override
    public List<IngredientImport> getImportByDateRange(Date fromDate, Date toDate)
            throws SQLException {
        return ingredientImportDao.findByDateRange(fromDate, toDate);
    }

    @Override
    public boolean createImport(int ingredientId, double quantity, double unitPrice,
            Date importDate, String supplierName, int createdBy, String note) {

        if (quantity <= 0 || unitPrice < 0) {
            return false;
        }

        IngredientImport ingredientImport = new IngredientImport(
                ingredientId, quantity, unitPrice, importDate, supplierName, createdBy, note);

        try {
            int importId = ingredientImportDao.insert(ingredientImport);
            if (importId <= 0) {
                return false;
            }

            Ingredient ingredient = ingredientDao.findById(ingredientId);
            if (ingredient == null) {
                return false;
            }

            double newStock = ingredient.getQuantityInStock() + quantity;
            return ingredientDao.updateStock(ingredientId, newStock);

        } catch (SQLException exception) {
            return false;
        }
    }

    @Override
    public double getTotalCost(Date fromDate, Date toDate) throws SQLException {
        return ingredientImportDao.sumTotalCostByDateRange(fromDate, toDate);
    }
}
