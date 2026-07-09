package com.mycompany.kindergartenkitchen.service;

import com.mycompany.kindergartenkitchen.model.Menu;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

public interface MenuService {

    List<Menu> getAllMenu() throws SQLException;

    List<Menu> getMenuByLevel(int levelId) throws SQLException;

    Menu getById(int menuId) throws SQLException;

    /**
     * Thực đơn (đã công bố) của 1 cấp học, cho tuần chứa ngày truyền vào.
     * Dùng cho trang Phụ huynh xem menu.
     */
    Menu getPublishedMenuForDate(int levelId, Date anyDateInWeek) throws SQLException;

    /**
     * Tạo thực đơn tuần mới (rỗng, chưa có món). weekStartDate bắt buộc là
     * Thứ 2 để các tuần luôn đồng bộ Thứ2-CN giữa các cấp học (khớp với cách
     * IngredientCalculatorService/Trang minh bạch nguyên liệu tính theo ngày).
     *
     * @return menuId vừa tạo, hoặc -1 nếu weekStartDate không phải Thứ 2 hoặc
     *         cấp học này đã có thực đơn cho đúng tuần đó rồi.
     */
    int createWeeklyMenu(int levelId, Date weekStartDate, int createdBy) throws SQLException;

    boolean setStatus(int menuId, boolean status) throws SQLException;

    /**
     * Xoá thực đơn kèm toàn bộ chi tiết ngày/bữa/món bên trong.
     */
    boolean deleteMenu(int menuId) throws SQLException;
}
