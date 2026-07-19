package com.mycompany.kindergartenkitchen.service.impl;

import com.mycompany.kindergartenkitchen.dao.DBContext; // Thay đổi import sang DBContext
import com.mycompany.kindergartenkitchen.dao.DishIngredientDao;
import com.mycompany.kindergartenkitchen.dao.IngredientDao;
import com.mycompany.kindergartenkitchen.dao.impl.DishIngredientDaoImpl;
import com.mycompany.kindergartenkitchen.dao.impl.IngredientDaoImpl;
import com.mycompany.kindergartenkitchen.model.DishIngredient;
import com.mycompany.kindergartenkitchen.model.Ingredient;
import com.mycompany.kindergartenkitchen.service.IngredientCalculatorService;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

public class IngredientCalculatorServiceImpl implements IngredientCalculatorService {

    // Khởi tạo DBContext cục bộ phục vụ cho luồng nghiệp vụ hỗn hợp của Service
    private final DBContext db = new DBContext();

    private static final String SQL_MENU_DISH_OF_DATE
            = "SELECT DISTINCT md.DishID "
            + "FROM MenuDetails md "
            + "JOIN Menus m ON md.MenuID = m.MenuID "
            + "WHERE md.MenuDate = ?";

    private static final String SQL_ACTUAL_USAGE_OF_DATE
            = "SELECT IngredientID, SUM(QuantityUsed) AS TotalUsed "
            + "FROM IngredientUsages "
            + "WHERE UsageDate = ? "
            + "GROUP BY IngredientID";

    private final DishIngredientDao dishIngredientDao;
    private final IngredientDao ingredientDao;

    public IngredientCalculatorServiceImpl() {
        this.dishIngredientDao = new DishIngredientDaoImpl();
        this.ingredientDao = new IngredientDaoImpl();
    }

    @Override
    public Map<DishIngredient, Double> calculateForDish(int dishId, int studentCount)
            throws SQLException {

        Map<DishIngredient, Double> resultMap = new LinkedHashMap<>();
        for (DishIngredient dishIngredient : dishIngredientDao.findByDishId(dishId)) {
            double neededQuantity = dishIngredient.getQuantityPerStudent() * studentCount;
            resultMap.put(dishIngredient, neededQuantity);
        }
        return resultMap;
    }

    @Override
    public Map<String, Double> compareNeededVersusStock(Date menuDate) throws SQLException {

        Map<Integer, Double> neededByIngredientId = getNeededByIngredientId(menuDate);

        /* So sánh với tồn kho hiện tại */
        Map<String, Double> comparisonResult = new LinkedHashMap<>();
        for (Map.Entry<Integer, Double> entry : neededByIngredientId.entrySet()) {
            Ingredient ingredient = ingredientDao.findById(entry.getKey());
            if (ingredient != null) {
                double shortageQuantity = entry.getValue() - ingredient.getQuantityInStock();
                comparisonResult.put(ingredient.getIngredientName(), shortageQuantity);
            }
        }
        return comparisonResult;
    }

    @Override
    public java.util.List<com.mycompany.kindergartenkitchen.model.UsageComparisonRow>
            getUsageComparisonDetails(Date usageDate) throws SQLException {

        Map<Integer, Double> neededByIngredientId = getNeededByIngredientId(usageDate);
        Map<Integer, Double> actualUsedByIngredientId = getActualUsedByIngredientId(usageDate);

        Map<Integer, Double> allIngredientIds = new LinkedHashMap<>(neededByIngredientId);
        for (Integer ingredientId : actualUsedByIngredientId.keySet()) {
            allIngredientIds.putIfAbsent(ingredientId, 0.0);
        }

        java.util.List<com.mycompany.kindergartenkitchen.model.UsageComparisonRow> rows = new java.util.ArrayList<>();
        for (Integer ingredientId : allIngredientIds.keySet()) {
            double needed = neededByIngredientId.getOrDefault(ingredientId, 0.0);
            double actualUsed = actualUsedByIngredientId.getOrDefault(ingredientId, 0.0);
            Ingredient ingredient = ingredientDao.findById(ingredientId);
            if (ingredient != null) {
                rows.add(new com.mycompany.kindergartenkitchen.model.UsageComparisonRow(
                        ingredient.getIngredientId(), ingredient.getIngredientName(), ingredient.getUnit(),
                        needed, actualUsed, needed - actualUsed));
            }
        }

        rows.sort((a, b) -> Double.compare(b.getDiff(), a.getDiff()));
        return rows;
    }

    @Override
    public Map<String, Double> compareNeededVersusActualUsage(Date usageDate) throws SQLException {

        Map<Integer, Double> neededByIngredientId = getNeededByIngredientId(usageDate);
        Map<Integer, Double> actualUsedByIngredientId = getActualUsedByIngredientId(usageDate);

        /* Gộp cả 2 chiều: nguyên liệu có trong công thức nhưng chưa ghi nhận dùng
           vẫn phải hiện ra (để biết bếp còn thiếu ghi nhận), và ngược lại. */
        Map<String, Double> comparisonResult = new LinkedHashMap<>();
        Map<Integer, Double> allIngredientIds = new LinkedHashMap<>(neededByIngredientId);
        for (Integer ingredientId : actualUsedByIngredientId.keySet()) {
            allIngredientIds.putIfAbsent(ingredientId, 0.0);
        }

        for (Integer ingredientId : allIngredientIds.keySet()) {
            double needed = neededByIngredientId.getOrDefault(ingredientId, 0.0);
            double actualUsed = actualUsedByIngredientId.getOrDefault(ingredientId, 0.0);
            Ingredient ingredient = ingredientDao.findById(ingredientId);
            if (ingredient != null) {
                comparisonResult.put(ingredient.getIngredientName(), needed - actualUsed);
            }
        }
        return comparisonResult;
    }

    /**
     * Tính tổng nguyên liệu CẦN dùng cho tất cả món trong thực đơn của 1 ngày,
     * dựa trên công thức món (QuantityPerStudent) nhân số suất ăn thực tế.
     * Dùng chung cho cả 2 chiều so sánh (vs tồn kho, vs thực tế đã dùng).
     */
    private Map<Integer, Double> getNeededByIngredientId(Date menuDate) throws SQLException {
        Map<Integer, Double> neededByIngredientId = new HashMap<>();

        // Sử dụng db.getConnection() thay cho DbConnection tĩnh cũ
        try (Connection connection = db.getConnection()) {

            int studentCount = countStudentForDate(connection, menuDate);

            /* Bước 1: lấy danh sách DishID có trong menu của ngày đó */
            try (PreparedStatement dishStatement
                    = connection.prepareStatement(SQL_MENU_DISH_OF_DATE)) {

                dishStatement.setDate(1, menuDate);
                try (ResultSet dishResultSet = dishStatement.executeQuery()) {

                    while (dishResultSet.next()) {
                        int dishId = dishResultSet.getInt("DishID");

                        /* Bước 2: với mỗi món, cộng dồn nguyên liệu cần */
                        for (DishIngredient dishIngredient : dishIngredientDao.findByDishId(dishId)) {
                            double neededQuantity
                                    = dishIngredient.getQuantityPerStudent() * studentCount;

                            neededByIngredientId.merge(
                                    dishIngredient.getIngredientId(), neededQuantity, Double::sum);
                        }
                    }
                }
            }
        } catch (Exception e) {
            throw new SQLException("Lỗi xử lý kết nối từ DBContext: " + e.getMessage());
        }
        return neededByIngredientId;
    }

    /**
     * Tổng số lượng đã được bếp ghi nhận dùng thực tế (IngredientUsages) trong
     * 1 ngày, cộng dồn theo từng nguyên liệu.
     */
    private Map<Integer, Double> getActualUsedByIngredientId(Date usageDate) throws SQLException {
        Map<Integer, Double> actualUsedByIngredientId = new HashMap<>();

        try (Connection connection = db.getConnection();
                PreparedStatement statement = connection.prepareStatement(SQL_ACTUAL_USAGE_OF_DATE)) {

            statement.setDate(1, usageDate);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    actualUsedByIngredientId.put(
                            resultSet.getInt("IngredientID"), resultSet.getDouble("TotalUsed"));
                }
            }
        } catch (Exception e) {
            throw new SQLException("Lỗi xử lý kết nối từ DBContext: " + e.getMessage());
        }
        return actualUsedByIngredientId;
    }

    private int countStudentForDate(Connection connection, Date attendanceDate) throws SQLException {
        // Đồng bộ với AttendanceDAO.getAttendanceSummaryByDate/getMealCountByDate:
        // suất ăn cần chuẩn bị = tổng học sinh CỦA LỚP ĐANG HOẠT ĐỘNG, trừ những
        // em đã báo nghỉ ăn HỢP LỆ (báo sớm, không bị tính tiền). Học sinh vắng
        // nhưng báo trễ (vẫn bị tính tiền) vẫn phải tính suất vì bếp đã lỡ chuẩn bị.
        //
        // LƯU Ý: trước đây hàm này không lọc theo Classes.Status, khác với mọi
        // hàm đếm suất ăn khác trong AttendanceDAO (đều có "AND c.Status = 1").
        // Hậu quả: nếu 1 lớp bị vô hiệu hoá nhưng học sinh trong lớp đó vẫn còn
        // Status = 1 (active), số suất ăn hiển thị cho bếp (MealCountService)
        // sẽ ít hơn số nguyên liệu được tính là "cần dùng" ở đây — dẫn đến cảnh
        // báo thiếu/thừa nguyên liệu sai lệch so với thực tế. Đã thêm JOIN
        // Classes + lọc c.Status = 1 để khớp hoàn toàn với các hàm còn lại.
        String sql = "SELECT COUNT(*) AS StudentCount FROM Students s "
                + "JOIN Classes c ON s.ClassID = c.ClassID "
                + "WHERE s.Status = 1 "
                + "AND c.Status = 1 "
                + "AND s.StudentID NOT IN ("
                + "    SELECT a.StudentID FROM Attendance a "
                + "    WHERE a.AttendanceDate = ? AND a.Status = 'Absent' AND a.IsCharged = 0"
                + ")";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setDate(1, attendanceDate);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt("StudentCount");
                }
            }
        }
        return 0;
    }

    @Override
    public java.util.List<com.mycompany.kindergartenkitchen.model.IngredientShortageRow> getShortageDetails(Date menuDate)
            throws SQLException {

        Map<Integer, Double> neededByIngredientId = getNeededByIngredientId(menuDate);

        java.util.List<com.mycompany.kindergartenkitchen.model.IngredientShortageRow> rows = new java.util.ArrayList<>();
        for (Map.Entry<Integer, Double> entry : neededByIngredientId.entrySet()) {
            Ingredient ingredient = ingredientDao.findById(entry.getKey());
            if (ingredient != null) {
                double needed = entry.getValue();
                double stock = ingredient.getQuantityInStock();
                double shortage = needed - stock;
                rows.add(new com.mycompany.kindergartenkitchen.model.IngredientShortageRow(
                        ingredient.getIngredientId(), ingredient.getIngredientName(), ingredient.getUnit(),
                        stock, needed, shortage));
            }
        }

        rows.sort((a, b) -> Double.compare(b.getShortage(), a.getShortage()));
        return rows;
    }
}