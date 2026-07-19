package com.mycompany.kindergartenkitchen.controller;

import com.mycompany.kindergartenkitchen.model.Ingredient;
import com.mycompany.kindergartenkitchen.model.IngredientUsage;
import com.mycompany.kindergartenkitchen.model.UsageComparisonRow;
import com.mycompany.kindergartenkitchen.service.IngredientCalculatorService;
import com.mycompany.kindergartenkitchen.service.IngredientService;
import com.mycompany.kindergartenkitchen.service.IngredientUsageService;
import com.mycompany.kindergartenkitchen.service.MealCountService;
import com.mycompany.kindergartenkitchen.service.impl.IngredientCalculatorServiceImpl;
import com.mycompany.kindergartenkitchen.service.impl.IngredientServiceImpl;
import com.mycompany.kindergartenkitchen.service.impl.IngredientUsageServiceImpl;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

/**
 * Controller (Servlet) ghi nhận nguyên liệu đã dùng mỗi ngày (dành cho nhân
 * viên bếp).
 */
@WebServlet(name = "IngredientUsageServlet", urlPatterns = {"/ingredient-usage/*", "/ingredient-usage"})
public class IngredientUsageServlet extends HttpServlet {

    private static final String VIEW_LIST = "/jsp/ingredient/usage-list.jsp";
    private static final String VIEW_FORM = "/jsp/ingredient/usage-form.jsp";

    private final IngredientUsageService ingredientUsageService = new IngredientUsageServiceImpl();
    private final IngredientService ingredientService = new IngredientServiceImpl();
    private final IngredientCalculatorService ingredientCalculatorService = new IngredientCalculatorServiceImpl();
    private final MealCountService mealCountService = new MealCountService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getPathInfo();
        if (action == null) {
            action = "/today";
        }

        try {
            switch (action) {
                case "/form":
                    handleShowForm(request, response);
                    break;
                case "/do":
                    handleListToday(request, response);
                    break;
                default:
                    handleListToday(request, response);
                    break;
            }
        } catch (SQLException exception) {
            request.setAttribute("errorMessage", "Lỗi truy vấn dữ liệu: " + exception.getMessage());
            request.getRequestDispatcher(VIEW_LIST).forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        com.mycompany.kindergartenkitchen.entity.User authUser
                = (com.mycompany.kindergartenkitchen.entity.User) request.getSession().getAttribute("authUser");
        if (authUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Integer currentUserId = authUser.getUserId();

        String action = request.getParameter("action");
        String note = request.getParameter("note");
        double quantityUsed = parseDoubleOrZero(request.getParameter("quantityUsed"));

        if ("update".equals(action)) {
            int usageId = Integer.parseInt(request.getParameter("usageId"));
            ingredientUsageService.updateUsage(usageId, quantityUsed, note);
            response.sendRedirect(request.getContextPath() + "/ingredient-usage/today?updated=true");
        } else if ("delete".equals(action)) {
            int usageId = Integer.parseInt(request.getParameter("usageId"));
            ingredientUsageService.deleteUsage(usageId);
            response.sendRedirect(request.getContextPath() + "/ingredient-usage/today?deleted=true");
        } else {
            int ingredientId = Integer.parseInt(request.getParameter("ingredientId"));
            Date usageDate = Date.valueOf(java.time.LocalDate.now());
            ingredientUsageService.recordUsage(ingredientId, quantityUsed, usageDate, currentUserId, note);
            response.sendRedirect(request.getContextPath() + "/ingredient-usage/today");
        }
    }

    private void handleListToday(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        Date today = Date.valueOf(java.time.LocalDate.now());
        List<IngredientUsage> usageList = ingredientUsageService.getUsageByDate(today);
        request.setAttribute("usageList", usageList);

      
        try {
            List<UsageComparisonRow> comparisonList = ingredientCalculatorService.getUsageComparisonDetails(today);
            request.setAttribute("comparisonList", comparisonList);
        } catch (SQLException exception) {
            request.setAttribute("comparisonUnavailable", true);
        }

        // Số suất ăn hôm nay (dựa trên điểm danh thực tế) — hiển thị cho bếp dễ hình dung quy mô nấu
        request.setAttribute("totalMealCount", mealCountService.getTotalMealCount(today));
        request.setAttribute("mealCountByLevel", mealCountService.getMealCountByLevel(today));

        request.getRequestDispatcher(VIEW_LIST).forward(request, response);
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