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
    public boolean updateUsage(int usageId, double newQuantityUsed, String note) {
        if (newQuantityUsed <= 0) {
            return false;
        }
        try {
            // Lấy bản ghi cũ để tính chênh lệch tồn kho
            IngredientUsage old = ingredientUsageDao.findById(usageId);
            if (old == null) {
                return false;
            }

            // QUAN TRỌNG: phải đọc số lượng CŨ ra biến riêng TRƯỚC khi gọi
            // setQuantityUsed() — nếu không, old.getQuantityUsed() ở dưới sẽ
            // trả về số MỚI (vì cùng 1 object), khiến diff luôn = 0.
            double oldQuantityUsed = old.getQuantityUsed();

            // Cập nhật bản ghi
            old.setQuantityUsed(newQuantityUsed);
            old.setNote(note);
            boolean updated = ingredientUsageDao.update(old);
            if (!updated) {
                return false;
            }

            // Vá tồn kho: hoàn lại số cũ rồi trừ số mới
            Ingredient ingredient = ingredientDao.findById(old.getIngredientId());
            if (ingredient == null) {
                return false;
            }
            double diff = newQuantityUsed - oldQuantityUsed;
            double newStock = Math.max(0, ingredient.getQuantityInStock() - diff);
            return ingredientDao.updateStock(old.getIngredientId(), newStock);

        } catch (SQLException exception) {
            return false;
        }
    }

    @Override
    public boolean deleteUsage(int usageId) {
        try {
            // Lấy bản ghi trước khi xoá để hoàn lại tồn kho
            IngredientUsage usage = ingredientUsageDao.findById(usageId);
            if (usage == null) {
                return false;
            }

            boolean deleted = ingredientUsageDao.delete(usageId);
            if (!deleted) {
                return false;
            }

            // Hoàn lại tồn kho số đã dùng
            Ingredient ingredient = ingredientDao.findById(usage.getIngredientId());
            if (ingredient == null) {
                return true; // đã xoá record, nguyên liệu bị mất thì bỏ qua
            }
            double restoredStock = ingredient.getQuantityInStock() + usage.getQuantityUsed();
            return ingredientDao.updateStock(usage.getIngredientId(), restoredStock);

        } catch (SQLException exception) {
            return false;
        }
    }
}