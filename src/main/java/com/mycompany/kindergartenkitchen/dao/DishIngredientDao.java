package com.mycompany.kindergartenkitchen.dao;

import com.mycompany.kindergartenkitchen.model.DishIngredient;
import com.mycompany.kindergartenkitchen.model.DishOption;
import java.sql.SQLException;
import java.util.List;

/**
 * DAO Rules: bắt buộc sử dụng Interface.
 * Định nghĩa các thao tác CRUD cho bảng DishIngredients (công thức món ăn).
 */
public interface DishIngredientDao {

    /**
     * Lấy toàn bộ công thức của tất cả món ăn (đã JOIN tên món, tên nguyên
     * liệu), dùng cho trang quản lý công thức xem theo nhóm món.
     */
    List<DishIngredient> findAll() throws SQLException;

    /**
     * Lấy danh sách rút gọn (id + tên) các món đang hoạt động, dùng để đổ vào
     * dropdown chọn món khi thêm/sửa công thức.
     */
    List<DishOption> findAllActiveDishOptions() throws SQLException;

    List<DishIngredient> findByDishId(int dishId) throws SQLException;

    DishIngredient findById(int dishIngredientId) throws SQLException;

    int insert(DishIngredient dishIngredient) throws SQLException;

    boolean update(DishIngredient dishIngredient) throws SQLException;

    boolean delete(int dishIngredientId) throws SQLException;
}
