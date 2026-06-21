package com.mycompany.kindergartenkitchen.controller;

import com.mycompany.kindergartenkitchen.dao.IngredientDao;
import com.mycompany.kindergartenkitchen.dao.IngredientImportDao;
import com.mycompany.kindergartenkitchen.dao.impl.IngredientDaoImpl;
import com.mycompany.kindergartenkitchen.dao.impl.IngredientImportDaoImpl;
import com.mycompany.kindergartenkitchen.model.Ingredient;
import com.mycompany.kindergartenkitchen.model.IngredientImport;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

/**
 * Controller xử lý nghiệp vụ nhập kho nguyên liệu.
 * Sau khi nhập kho thành công, cộng dồn số lượng vào tồn kho hiện tại.
 */
public class IngredientImportController {

    private final IngredientImportDao ingredientImportDao;
    private final IngredientDao ingredientDao;

    public IngredientImportController() {
        this.ingredientImportDao = new IngredientImportDaoImpl();
        this.ingredientDao = new IngredientDaoImpl();
    }

    public List<IngredientImport> getAllImport() throws SQLException {
        return ingredientImportDao.findAll();
    }

    public List<IngredientImport> getImportByDateRange(Date fromDate, Date toDate) throws SQLException {
        return ingredientImportDao.findByDateRange(fromDate, toDate);
    }

    /**
     * Tạo phiếu nhập kho và cộng dồn số lượng vào Ingredients.QuantityInStock.
     */
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

    public double getTotalCost(Date fromDate, Date toDate) throws SQLException {
        return ingredientImportDao.sumTotalCostByDateRange(fromDate, toDate);
    }
}
