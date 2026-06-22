package com.mycompany.kindergartenkitchen.service;

import com.mycompany.kindergartenkitchen.model.IngredientUsage;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

/**
 * Service xử lý nghiệp vụ ghi nhận nguyên liệu đã dùng mỗi ngày.
 */
public interface IngredientUsageService {

    List<IngredientUsage> getUsageByDate(Date usageDate) throws SQLException;

    /**
     * Ghi nhận nguyên liệu đã dùng và trừ vào tồn kho.
     */
    boolean recordUsage(int ingredientId, double quantityUsed, Date usageDate,
            int updatedBy, String note);

    boolean updateUsage(int usageId, double quantityUsed, String note);
}
