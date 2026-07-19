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
    public boolean updateImport(int importId, double newQuantity, double newUnitPrice,
            String supplierName, String note) {

        if (newQuantity <= 0 || newUnitPrice < 0) {
            return false;
        }

        try {
            // Lấy bản ghi cũ để tính chênh lệch tồn kho
            IngredientImport old = ingredientImportDao.findById(importId);
            if (old == null) {
                return false;
            }

            // QUAN TRỌNG: phải đọc số lượng CŨ ra biến riêng TRƯỚC khi gọi
            // setQuantity() — nếu không, old.getQuantity() ở dưới sẽ trả về
            // số MỚI (vì cùng 1 object), khiến diff luôn = 0.
            double oldQuantity = old.getQuantity();

            // Cập nhật bản ghi
            old.setQuantity(newQuantity);
            old.setUnitPrice(newUnitPrice);
            old.setSupplierName(supplierName);
            old.setNote(note);
            boolean updated = ingredientImportDao.update(old);
            if (!updated) {
                return false;
            }

            // Vá tồn kho: trừ số lượng cũ đã cộng trước đó, cộng lại số lượng mới
            Ingredient ingredient = ingredientDao.findById(old.getIngredientId());
            if (ingredient == null) {
                return false;
            }
            double diff = newQuantity - oldQuantity;
            double newStock = Math.max(0, ingredient.getQuantityInStock() + diff);
            return ingredientDao.updateStock(old.getIngredientId(), newStock);

        } catch (SQLException exception) {
            return false;
        }
    }

    @Override
    public boolean deleteImport(int importId) {
        try {
            // Lấy bản ghi trước khi xoá để trừ ngược lại tồn kho
            IngredientImport ingredientImport = ingredientImportDao.findById(importId);
            if (ingredientImport == null) {
                return false;
            }

            boolean deleted = ingredientImportDao.delete(importId);
            if (!deleted) {
                return false;
            }

            // Trừ ngược lại số lượng đã cộng vào tồn kho lúc tạo phiếu
            Ingredient ingredient = ingredientDao.findById(ingredientImport.getIngredientId());
            if (ingredient == null) {
                return true; // đã xoá record, nguyên liệu bị mất thì bỏ qua
            }
            double newStock = Math.max(0,
                    ingredient.getQuantityInStock() - ingredientImport.getQuantity());
            return ingredientDao.updateStock(ingredientImport.getIngredientId(), newStock);

        } catch (SQLException exception) {
            return false;
        }
    }

    @Override
    public double getTotalCost(Date fromDate, Date toDate) throws SQLException {
        return ingredientImportDao.sumTotalCostByDateRange(fromDate, toDate);
    }
}
