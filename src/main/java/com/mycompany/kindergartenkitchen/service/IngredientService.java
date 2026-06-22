package com.mycompany.kindergartenkitchen.service;

import com.mycompany.kindergartenkitchen.model.Ingredient;
import java.sql.SQLException;
import java.util.List;

/**
 * Service xử lý nghiệp vụ liên quan đến Ingredient.
 */
public interface IngredientService {

    List<Ingredient> getAllIngredient() throws SQLException;

    Ingredient getIngredientById(int ingredientId) throws SQLException;

    boolean createIngredient(String ingredientName, String unit, double quantityInStock);

    boolean updateIngredient(int ingredientId, String ingredientName,
            String unit, double quantityInStock);

    boolean deactivateIngredient(int ingredientId);

    List<Ingredient> getLowStockIngredient() throws SQLException;
}
