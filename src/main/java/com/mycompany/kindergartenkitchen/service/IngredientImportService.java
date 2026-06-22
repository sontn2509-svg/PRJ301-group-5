package com.mycompany.kindergartenkitchen.service;

import com.mycompany.kindergartenkitchen.model.IngredientImport;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

/**
 * Service xử lý nghiệp vụ nhập kho nguyên liệu.
 */
public interface IngredientImportService {

    List<IngredientImport> getAllImport() throws SQLException;

    List<IngredientImport> getImportByDateRange(Date fromDate, Date toDate) throws SQLException;

    /**
     * Tạo phiếu nhập kho và cộng dồn số lượng vào Ingredients.QuantityInStock.
     */
    boolean createImport(int ingredientId, double quantity, double unitPrice,
            Date importDate, String supplierName, int createdBy, String note);

    double getTotalCost(Date fromDate, Date toDate) throws SQLException;
}
