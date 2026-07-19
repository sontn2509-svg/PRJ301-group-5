package com.mycompany.kindergartenkitchen.dao;

import com.mycompany.kindergartenkitchen.model.IngredientUsage;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

/**
 * DAO Rules: bắt buộc sử dụng Interface.
 * Định nghĩa thao tác cho bảng IngredientUsages (nguyên liệu đã dùng).
 */
public interface IngredientUsageDao {

    List<IngredientUsage> findByDate(Date usageDate) throws SQLException;

    IngredientUsage findById(int usageId) throws SQLException;

    int insert(IngredientUsage ingredientUsage) throws SQLException;

    boolean update(IngredientUsage ingredientUsage) throws SQLException;

    boolean delete(int usageId) throws SQLException;
}
