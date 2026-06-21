package com.mycompany.kindergartenkitchen.dao;

import com.mycompany.kindergartenkitchen.model.DishIngredient;
import java.sql.SQLException;
import java.util.List;

/**
 * DAO Rules: bắt buộc sử dụng Interface.
 * Định nghĩa các thao tác CRUD cho bảng DishIngredients (công thức món ăn).
 */
public interface DishIngredientDao {

    List<DishIngredient> findByDishId(int dishId) throws SQLException;

    DishIngredient findById(int dishIngredientId) throws SQLException;

    int insert(DishIngredient dishIngredient) throws SQLException;

    boolean update(DishIngredient dishIngredient) throws SQLException;

    boolean delete(int dishIngredientId) throws SQLException;
}
