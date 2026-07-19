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

    /**
     * Sửa phiếu nhập kho đã tạo (VD: Manager gõ nhầm số lượng/đơn giá).
     * Vá lại tồn kho theo chênh lệch giữa số lượng cũ và số lượng mới,
     * không sửa được IngredientID/ImportDate/CreatedBy.
     */
    boolean updateImport(int importId, double newQuantity, double newUnitPrice,
            String supplierName, String note);

    /**
     * Xoá phiếu nhập kho và hoàn lại tồn kho tương ứng
     * (trừ ngược lại số lượng đã cộng vào lúc tạo phiếu).
     */
    boolean deleteImport(int importId);

    double getTotalCost(Date fromDate, Date toDate) throws SQLException;
}
