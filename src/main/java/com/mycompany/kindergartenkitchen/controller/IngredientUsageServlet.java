package com.mycompany.kindergartenkitchen.controller;

import com.mycompany.kindergartenkitchen.model.Ingredient;
import com.mycompany.kindergartenkitchen.model.IngredientUsage;
import com.mycompany.kindergartenkitchen.service.IngredientService;
import com.mycompany.kindergartenkitchen.service.IngredientUsageService;
import com.mycompany.kindergartenkitchen.service.impl.IngredientServiceImpl;
import com.mycompany.kindergartenkitchen.service.impl.IngredientUsageServiceImpl;
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
 * Controller (Servlet) ghi nhận nguyên liệu đã dùng mỗi ngày (dành cho nhân viên bếp).
 */
@WebServlet(name = "IngredientUsageServlet", urlPatterns = {"/ingredient-usage/*"})
public class IngredientUsageServlet extends HttpServlet {

    private static final String VIEW_LIST = "/jsp/ingredient/usage-list.jsp";
    private static final String VIEW_FORM = "/jsp/ingredient/usage-form.jsp";

    private final IngredientUsageService ingredientUsageService = new IngredientUsageServiceImpl();
    private final IngredientService ingredientService = new IngredientServiceImpl();

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

        HttpSession session = request.getSession();
        Integer currentUserId = (Integer) session.getAttribute("userId");
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        int ingredientId = Integer.parseInt(request.getParameter("ingredientId"));
        double quantityUsed = parseDoubleOrZero(request.getParameter("quantityUsed"));
        String note = request.getParameter("note");
        Date usageDate = Date.valueOf(java.time.LocalDate.now());

        ingredientUsageService.recordUsage(ingredientId, quantityUsed, usageDate, currentUserId, note);

        response.sendRedirect(request.getContextPath() + "/ingredient-usage/today");
    }

    private void handleListToday(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        Date today = Date.valueOf(java.time.LocalDate.now());
        List<IngredientUsage> usageList = ingredientUsageService.getUsageByDate(today);
        request.setAttribute("usageList", usageList);
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
