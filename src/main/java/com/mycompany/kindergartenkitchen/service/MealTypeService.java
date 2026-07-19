package com.mycompany.kindergartenkitchen.service;

import com.mycompany.kindergartenkitchen.model.MealType;
import java.sql.SQLException;
import java.util.List;

public interface MealTypeService {

    List<MealType> getAllMealType() throws SQLException;

    boolean createMealType(String mealTypeName) throws SQLException;

    boolean updateMealType(int mealTypeId, String mealTypeName) throws SQLException;

    /**
     * @return false nếu loại bữa không tồn tại HOẶC đang được thực đơn nào đó tham chiếu
     */
    boolean deleteMealType(int mealTypeId) throws SQLException;
}
