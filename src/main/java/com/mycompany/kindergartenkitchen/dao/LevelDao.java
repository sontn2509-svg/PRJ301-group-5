package com.mycompany.kindergartenkitchen.dao;

import com.mycompany.kindergartenkitchen.model.Level;
import java.sql.SQLException;
import java.util.List;

/**
 * DAO Rules: bắt buộc sử dụng Interface.
 * Chỉ đọc danh sách cấp học (Nhà trẻ / Mẫu giáo) — dữ liệu do Admin cấu hình sẵn.
 */
public interface LevelDao {

    List<Level> findAll() throws SQLException;

    Level findById(int levelId) throws SQLException;
}
