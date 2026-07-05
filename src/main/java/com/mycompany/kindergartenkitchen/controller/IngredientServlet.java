package com.mycompany.kindergartenkitchen.controller;

import com.mycompany.kindergartenkitchen.model.Ingredient;
import com.mycompany.kindergartenkitchen.service.IngredientService;
import com.mycompany.kindergartenkitchen.service.impl.IngredientServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Controller (Servlet) xử lý request cho Ingredient.
 * Chỉ làm nhiệm vụ: nhận request, parse param, gọi Service, forward JSP.
 * Không chứa logic nghiệp vụ.
 */
@WebServlet(name = "IngredientServlet", urlPatterns = {"/ingredient/*"})
public class IngredientServlet extends HttpServlet {

    private static final String VIEW_LIST = "/jsp/ingredient/ingredient-list.jsp";
    private static final String VIEW_FORM = "/jsp/ingredient/ingredient-form.jsp";

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
                case "/low-stock":
                    handleLowStock(request, response);
                    break;
                default:
                    handleList(request, response);
                    break;
            }
        } catch (SQLException exception) {
            request.setAttribute("errorMessage", "Lỗi truy vấn dữ liệu: " + exception.getMessage());
            request.getRequestDispatcher(VIEW_LIST).forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "update":
                handleUpdate(request, response);
                break;
            case "deactivate":
                handleDeactivate(request, response);
                break;
            default:
                handleCreate(request, response);
                break;
        }
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        List<Ingredient> ingredientList = ingredientService.getAllIngredient();
        request.setAttribute("ingredientList", ingredientList);
        request.getRequestDispatcher(VIEW_LIST).forward(request, response);
    }

    private void handleLowStock(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        List<Ingredient> ingredientList = ingredientService.getLowStockIngredient();
        request.setAttribute("ingredientList", ingredientList);
        request.setAttribute("isLowStockView", true);
        request.getRequestDispatcher(VIEW_LIST).forward(request, response);
    }

    private void handleShowForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        String idParam = request.getParameter("id");
        if (idParam != null) {
            Ingredient ingredient = ingredientService.getIngredientById(Integer.parseInt(idParam));
            request.setAttribute("ingredient", ingredient);
        }
        request.getRequestDispatcher(VIEW_FORM).forward(request, response);
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String ingredientName = request.getParameter("ingredientName");
        String unit = request.getParameter("unit");
        double quantityInStock = parseDoubleOrZero(request.getParameter("quantityInStock"));

        boolean success = ingredientService.createIngredient(ingredientName, unit, quantityInStock);
        response.sendRedirect(request.getContextPath() + "/ingredient/list?success=" + success);
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int ingredientId = Integer.parseInt(request.getParameter("ingredientId"));
        String ingredientName = request.getParameter("ingredientName");
        String unit = request.getParameter("unit");
        double quantityInStock = parseDoubleOrZero(request.getParameter("quantityInStock"));

        boolean updated = ingredientService.updateIngredient(ingredientId, ingredientName, unit, quantityInStock);
        response.sendRedirect(request.getContextPath() + "/ingredient/list?success=" + updated);
    }

    private void handleDeactivate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int ingredientId = Integer.parseInt(request.getParameter("ingredientId"));
        boolean deleted = ingredientService.deactivateIngredient(ingredientId);
        response.sendRedirect(request.getContextPath() + "/ingredient/list?deleted=" + deleted);
    }

    private double parseDoubleOrZero(String value) {
        try {
            return value == null ? 0 : Double.parseDouble(value);
        } catch (NumberFormatException exception) {
            return 0;
        }
    }
}