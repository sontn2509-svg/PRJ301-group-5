package com.mycompany.kindergartenkitchen.dao;

import com.mycompany.kindergartenkitchen.model.MealType;
import java.sql.SQLException;
import java.util.List;

/**
 * DAO Rules: bắt buộc sử dụng Interface.
 * Định nghĩa các thao tác CRUD cho bảng MealTypes (loại bữa).
 */
public interface MealTypeDao {

    List<MealType> findAll() throws SQLException;

    MealType findById(int mealTypeId) throws SQLException;

    int insert(MealType mealType) throws SQLException;

    boolean update(MealType mealType) throws SQLException;

    boolean delete(int mealTypeId) throws SQLException;

    /**
     * Kiểm tra loại bữa này đã được dùng trong MenuDetails chưa — dùng để
     * chặn xoá loại bữa đang được thực đơn tham chiếu (tránh vi phạm FK).
     */
    boolean isInUse(int mealTypeId) throws SQLException;
}
