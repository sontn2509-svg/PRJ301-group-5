package com.mycompany.kindergartenkitchen.dao;

import com.mycompany.kindergartenkitchen.model.Dish;
import java.sql.SQLException;
import java.util.List;

/**
 * DAO Rules: bắt buộc sử dụng Interface.
 * Định nghĩa các thao tác CRUD cho bảng Dishes (món ăn).
 */
public interface DishDao {

    List<Dish> findAll() throws SQLException;

    List<Dish> findAllActive() throws SQLException;

    Dish findById(int dishId) throws SQLException;

    int insert(Dish dish) throws SQLException;

    boolean update(Dish dish) throws SQLException;

    boolean setStatus(int dishId, boolean status) throws SQLException;
}
