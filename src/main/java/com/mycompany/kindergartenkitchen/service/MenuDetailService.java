package com.mycompany.kindergartenkitchen.service;

import com.mycompany.kindergartenkitchen.model.MenuDetail;
import java.sql.SQLException;
import java.util.List;

public interface MenuDetailService {

    List<MenuDetail> getByMenuId(int menuId) throws SQLException;

    /**
     * Gắn 1 món vào 1 ngày + 1 bữa của thực đơn.
     *
     * @return false nếu ngày không thuộc tuần của thực đơn này, hoặc món này
     *         đã được gắn vào đúng ngày + bữa đó rồi
     */
    boolean addDish(int menuId, java.sql.Date menuDate, int mealTypeId, int dishId) throws SQLException;

    boolean removeDish(int menuDetailId) throws SQLException;
}
