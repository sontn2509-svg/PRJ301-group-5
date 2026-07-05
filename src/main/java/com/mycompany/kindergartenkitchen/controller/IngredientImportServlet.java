package com.mycompany.kindergartenkitchen.controller;

import com.mycompany.kindergartenkitchen.model.Ingredient;
import com.mycompany.kindergartenkitchen.model.IngredientImport;
import com.mycompany.kindergartenkitchen.service.IngredientImportService;
import com.mycompany.kindergartenkitchen.service.IngredientService;
import com.mycompany.kindergartenkitchen.service.impl.IngredientImportServiceImpl;
import com.mycompany.kindergartenkitchen.service.impl.IngredientServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.List;

/**
 * Controller (Servlet) quản lý nhập kho nguyên liệu.
 */
@WebServlet(name = "IngredientImportServlet", urlPatterns = {"/ingredient-import/*"})
public class IngredientImportServlet extends HttpServlet {

    private static final String VIEW_LIST = "/jsp/ingredient/import-list.jsp";
    private static final String VIEW_FORM = "/jsp/ingredient/import-form.jsp";
    private static final String VIEW_TRANSPARENCY = "/jsp/ingredient/transparency.jsp";

    private final IngredientImportService ingredientImportService = new IngredientImportServiceImpl();
    private final IngredientService ingredientService = new IngredientServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getPathInfo();
        if (action == null) {
            action = "/list";
        }

        try {
            switch (action) {
                case "/form":
                    handleShowForm(request, response);
                    break;
                case "/transparency":
                    handleTransparency(request, response);
                    break;
                default:
                    handleList(request, response);
                    break;
            }
        } catch (SQLException exception) {
            String view = "/transparency".equals(action) ? VIEW_TRANSPARENCY : VIEW_LIST;
            request.setAttribute("errorMessage", "Lỗi truy vấn dữ liệu: " + exception.getMessage());
            request.getRequestDispatcher(view).forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer currentUserId = (Integer) session.getAttribute("userId");
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        int ingredientId = Integer.parseInt(request.getParameter("ingredientId"));
        double quantity = parseDoubleOrZero(request.getParameter("quantity"));
        double unitPrice = parseDoubleOrZero(request.getParameter("unitPrice"));
        String supplierName = request.getParameter("supplierName");
        String note = request.getParameter("note");
        Date importDate = Date.valueOf(java.time.LocalDate.now());

        boolean success = ingredientImportService.createImport(
                ingredientId, quantity, unitPrice, importDate, supplierName, currentUserId, note);

        request.setAttribute("success", success);
        response.sendRedirect(request.getContextPath() + "/ingredient-import/list");
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        List<IngredientImport> importList = ingredientImportService.getAllImport();
        request.setAttribute("importList", importList);
        request.getRequestDispatcher(VIEW_LIST).forward(request, response);
    }

    /**
     * Trang Phụ huynh: xem minh bạch nguyên liệu nhập kho trong tuần
     * (nhà cung cấp, chi phí, số lượng). Mặc định hiển thị tuần hiện tại
     * (Thứ 2 - Chủ nhật); có thể xem tuần khác qua tham số fromDate.
     */
    private void handleTransparency(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        LocalDate anchorDate;
        String fromDateParam = request.getParameter("fromDate");
        if (fromDateParam != null && !fromDateParam.isBlank()) {
            anchorDate = LocalDate.parse(fromDateParam);
        } else {
            anchorDate = LocalDate.now();
        }

        LocalDate weekStart = anchorDate.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        LocalDate weekEnd = weekStart.plusDays(6);

        Date fromDate = Date.valueOf(weekStart);
        Date toDate = Date.valueOf(weekEnd);

        List<IngredientImport> importList = ingredientImportService.getImportByDateRange(fromDate, toDate);
        double totalCost = ingredientImportService.getTotalCost(fromDate, toDate);

        request.setAttribute("importList", importList);
        request.setAttribute("totalCost", totalCost);
        request.setAttribute("weekStart", weekStart);
        request.setAttribute("weekEnd", weekEnd);
        request.setAttribute("prevWeekStart", weekStart.minusWeeks(1));
        request.setAttribute("nextWeekStart", weekStart.plusWeeks(1));
        request.getRequestDispatcher(VIEW_TRANSPARENCY).forward(request, response);
    }

    private void handleShowForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        List<Ingredient> ingredientList = ingredientService.getAllIngredient();
        request.setAttribute("ingredientList", ingredientList);
        request.getRequestDispatcher(VIEW_FORM).forward(request, response);
    }

    private double parseDoubleOrZero(String value) {
        try {
            return value == null ? 0 : Double.parseDouble(value);
        } catch (NumberFormatException exception) {
            return 0;
        }
    }
}
