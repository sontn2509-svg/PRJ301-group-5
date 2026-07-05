package com.mycompany.kindergartenkitchen.service;

import com.mycompany.kindergartenkitchen.model.DishIngredient;
import com.mycompany.kindergartenkitchen.model.DishOption;
import java.sql.SQLException;
import java.util.List;

/**
 * Service xử lý nghiệp vụ quản lý công thức món ăn (DishIngredients):
 * món ăn nào cần những nguyên liệu gì, định lượng cho 1 học sinh.
 */
public interface DishIngredientService {

    List<DishIngredient> getAllDishIngredient() throws SQLException;

    List<DishIngredient> getByDishId(int dishId) throws SQLException;

    List<DishOption> getAllActiveDishOptions() throws SQLException;

    DishIngredient getById(int dishIngredientId) throws SQLException;

    /**
     * Thêm nguyên liệu vào công thức món. Trả về false nếu định lượng không
     * hợp lệ hoặc nguyên liệu đó đã tồn tại trong công thức của món này.
     */
    boolean createDishIngredient(int dishId, int ingredientId, double quantityPerStudent)
            throws SQLException;

    boolean updateDishIngredient(int dishIngredientId, double quantityPerStudent) throws SQLException;

    boolean deleteDishIngredient(int dishIngredientId) throws SQLException;
}
