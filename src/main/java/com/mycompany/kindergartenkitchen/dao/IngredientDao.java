package com.mycompany.kindergartenkitchen.dao;

import com.mycompany.kindergartenkitchen.model.Ingredient;
import java.sql.SQLException;
import java.util.List;

/**
 * DAO Rules: bắt buộc sử dụng Interface../
 * Định nghĩa các thao tác CRUD cho bảng Ingredients.
 */
public interface IngredientDao {

    List<Ingredient> findAll() throws SQLException;

    Ingredient findById(int ingredientId) throws SQLException;

    int insert(Ingredient ingredient) throws SQLException;

    boolean update(Ingredient ingredient) throws SQLException;

    boolean deactivate(int ingredientId) throws SQLException;

    boolean updateStock(int ingredientId, double newQuantity) throws SQLException;

    List<Ingredient> findLowStock(double threshold) throws SQLException;

    Ingredient findByName(String ingredientName) throws SQLException;
}
