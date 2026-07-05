package com.mycompany.kindergartenkitchen.service;

import com.mycompany.kindergartenkitchen.model.DishIngredient;
import java.sql.Date;
import java.sql.SQLException;
import java.util.Map;

/**
 * Service Rules: dùng Interface cho tầng nghiệp vụ phức tạp.
 * Tính nguyên liệu cần dùng dựa trên số suất ăn thực tế trong ngày.
 */
public interface IngredientCalculatorService {

    /**
     * Tính tổng nguyên liệu cần cho 1 món theo số suất ăn.
     *
     * @param dishId       id món ăn
     * @param studentCount số suất ăn thực tế (đã trừ học sinh báo nghỉ)
     * @return danh sách nguyên liệu kèm số lượng cần dùng
     */
    Map<DishIngredient, Double> calculateForDish(int dishId, int studentCount) throws SQLException;

    /**
     * So sánh nguyên liệu cần dùng (theo menu + số suất ăn ngày đó)
     * với nguyên liệu tồn kho hiện tại, để cảnh báo thiếu/thừa.
     *
     * @param menuDate ngày cần kiểm tra
     * @return danh sách nguyên liệu kèm số lượng còn thiếu (âm = dư)
     */
    Map<String, Double> compareNeededVersusStock(Date menuDate) throws SQLException;

    /**
     * So sánh nguyên liệu CẦN dùng (theo công thức món trong thực đơn ngày đó
     * + số suất ăn thực tế) với nguyên liệu THỰC TẾ đã được bếp ghi nhận dùng
     * trong IngredientUsages cùng ngày.
     *
     * @param usageDate ngày cần kiểm tra
     * @return danh sách nguyên liệu kèm chênh lệch (cần dùng - thực tế đã
     *         dùng). Dương = ghi nhận ít hơn công thức (có thể thiếu ghi
     *         nhận); âm = dùng nhiều hơn công thức (có thể hao hụt/lãng phí).
     */
    Map<String, Double> compareNeededVersusActualUsage(Date usageDate) throws SQLException;
}
