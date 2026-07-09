package com.mycompany.kindergartenkitchen.service;

import com.mycompany.kindergartenkitchen.model.Dish;
import java.sql.SQLException;
import java.util.List;

public interface DishService {

    List<Dish> getAllDish() throws SQLException;

    List<Dish> getAllActiveDish() throws SQLException;

    Dish getById(int dishId) throws SQLException;

    /**
     * @return false nếu tên món trống hoặc đã trùng tên với món khác đang hoạt động
     */
    boolean createDish(String dishName, String description) throws SQLException;

    boolean updateDish(int dishId, String dishName, String description) throws SQLException;

    boolean setStatus(int dishId, boolean status) throws SQLException;
}
