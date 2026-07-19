package com.mycompany.kindergartenkitchen.dao;

import com.mycompany.kindergartenkitchen.model.Menu;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

/**
 * DAO Rules: bắt buộc sử dụng Interface.
 * Định nghĩa các thao tác CRUD cho bảng Menus (thực đơn theo tuần).
 */
public interface MenuDao {

    List<Menu> findAll() throws SQLException;

    List<Menu> findByLevel(int levelId) throws SQLException;

    Menu findById(int menuId) throws SQLException;

    /**
     * Tìm thực đơn của 1 cấp học có tuần chứa ngày truyền vào (dùng cho
     * trang Phụ huynh xem menu "tuần này").
     */
    Menu findByLevelAndDate(int levelId, Date anyDateInWeek) throws SQLException;

    /**
     * Kiểm tra cấp học này đã có thực đơn cho đúng tuần (WeekStartDate) này
     * chưa — dùng để chặn tạo trùng.
     */
    Menu findByLevelAndWeekStart(int levelId, Date weekStartDate) throws SQLException;

    int insert(Menu menu) throws SQLException;

    boolean setStatus(int menuId, boolean status) throws SQLException;

    boolean delete(int menuId) throws SQLException;
}
