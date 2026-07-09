package com.mycompany.kindergartenkitchen.dao;

import com.mycompany.kindergartenkitchen.model.MenuDetail;
import java.sql.SQLException;
import java.util.List;

/**
 * DAO Rules: bắt buộc sử dụng Interface.
 * Định nghĩa các thao tác thêm/sửa/xoá chi tiết từng ngày-bữa-món của 1 thực đơn.
 */
public interface MenuDetailDao {

    /**
     * Lấy toàn bộ chi tiết của 1 thực đơn (đã JOIN tên món, tên loại bữa),
     * dùng để dựng lưới hiển thị theo ngày/bữa.
     */
    List<MenuDetail> findByMenuId(int menuId) throws SQLException;

    /**
     * Kiểm tra món này đã được gắn vào đúng ngày + bữa này chưa (chặn thêm trùng).
     */
    boolean exists(int menuId, java.sql.Date menuDate, int mealTypeId, int dishId) throws SQLException;

    int insert(MenuDetail menuDetail) throws SQLException;

    boolean deleteById(int menuDetailId) throws SQLException;

    boolean deleteByMenuId(int menuId) throws SQLException;
}
