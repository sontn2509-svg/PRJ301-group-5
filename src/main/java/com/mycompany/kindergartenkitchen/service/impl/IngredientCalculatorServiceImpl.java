package com.mycompany.kindergartenkitchen.service.impl;

import com.mycompany.kindergartenkitchen.config.DbConnection;
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

/**
 * Implementation của IngredientCalculatorService.
 * Công thức: SốLượngCần = QuantityPerStudent x SốSuấtĂnThựcTế
 */
public class IngredientCalculatorServiceImpl implements IngredientCalculatorService {

    /* Lấy danh sách món + số suất ăn của 1 ngày, dựa trên Menu + Attendance */
    private static final String SQL_MENU_DISH_OF_DATE
            = "SELECT DISTINCT md.DishID "
            + "FROM MenuDetails md "
            + "JOIN Menus m ON md.MenuID = m.MenuID "
            + "WHERE md.MenuDate = ?";

    /* Đếm số suất ăn thực tế trong countStudentForDate(), tách riêng để gọi theo từng ngày */

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

        Map<Integer, Double> neededByIngredientId = new HashMap<>();

        try (Connection connection = DbConnection.getConnection()) {

            /* Bước 1: lấy danh sách DishID có trong menu của ngày đó */
            try (PreparedStatement dishStatement
                    = connection.prepareStatement(SQL_MENU_DISH_OF_DATE)) {

                dishStatement.setDate(1, menuDate);
                try (ResultSet dishResultSet = dishStatement.executeQuery()) {

                    while (dishResultSet.next()) {
                        int dishId = dishResultSet.getInt("DishID");

                        /* Bước 2: với mỗi món, cộng dồn nguyên liệu cần */
                        for (DishIngredient dishIngredient : dishIngredientDao.findByDishId(dishId)) {
                            int studentCount = countStudentForDate(connection, menuDate);
                            double neededQuantity
                                    = dishIngredient.getQuantityPerStudent() * studentCount;

                            neededByIngredientId.merge(
                                    dishIngredient.getIngredientId(), neededQuantity, Double::sum);
                        }
                    }
                }
            }
        }

        /* Bước 3: so sánh với tồn kho hiện tại */
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

    /* Đếm số suất ăn thực tế của 1 ngày — tạm tính theo toàn trường, có thể tách theo LevelID */
    private int countStudentForDate(Connection connection, Date attendanceDate) throws SQLException {
        String sql = "SELECT COUNT(*) AS StudentCount FROM Students s "
                + "WHERE s.StudentID NOT IN ("
                + "    SELECT a.StudentID FROM Attendance a "
                + "    WHERE a.AttendanceDate = ? AND a.Status = 'Absent'"
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
}
