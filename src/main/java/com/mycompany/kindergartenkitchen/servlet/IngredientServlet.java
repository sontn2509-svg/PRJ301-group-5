package com.mycompany.kindergartenkitchen.servlet;

import com.mycompany.kindergartenkitchen.controller.IngredientController;
import com.mycompany.kindergartenkitchen.model.Ingredient;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Servlet chỉ làm nhiệm vụ: nhận request, parse param, gọi Controller, forward JSP.
 * Không chứa logic nghiệp vụ.
 */
@WebServlet(name = "IngredientServlet", urlPatterns = {"/ingredient/*"})
public class IngredientServlet extends HttpServlet {

    private static final String VIEW_LIST = "/jsp/ingredient/ingredient-list.jsp";
    private static final String VIEW_FORM = "/jsp/ingredient/ingredient-form.jsp";

    private final IngredientController ingredientController = new IngredientController();

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

        List<Ingredient> ingredientList = ingredientController.getAllIngredient();
        request.setAttribute("ingredientList", ingredientList);
        request.getRequestDispatcher(VIEW_LIST).forward(request, response);
    }

    private void handleLowStock(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        List<Ingredient> ingredientList = ingredientController.getLowStockIngredient();
        request.setAttribute("ingredientList", ingredientList);
        request.setAttribute("isLowStockView", true);
        request.getRequestDispatcher(VIEW_LIST).forward(request, response);
    }

    private void handleShowForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        String idParam = request.getParameter("id");
        if (idParam != null) {
            Ingredient ingredient = ingredientController.getIngredientById(Integer.parseInt(idParam));
            request.setAttribute("ingredient", ingredient);
        }
        request.getRequestDispatcher(VIEW_FORM).forward(request, response);
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String ingredientName = request.getParameter("ingredientName");
        String unit = request.getParameter("unit");
        double quantityInStock = parseDoubleOrZero(request.getParameter("quantityInStock"));

        boolean success = ingredientController.createIngredient(ingredientName, unit, quantityInStock);
        request.setAttribute("success", success);
        response.sendRedirect(request.getContextPath() + "/ingredient/list");
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int ingredientId = Integer.parseInt(request.getParameter("ingredientId"));
        String ingredientName = request.getParameter("ingredientName");
        String unit = request.getParameter("unit");
        double quantityInStock = parseDoubleOrZero(request.getParameter("quantityInStock"));

        ingredientController.updateIngredient(ingredientId, ingredientName, unit, quantityInStock);
        response.sendRedirect(request.getContextPath() + "/ingredient/list");
    }

    private void handleDeactivate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int ingredientId = Integer.parseInt(request.getParameter("ingredientId"));
        ingredientController.deactivateIngredient(ingredientId);
        response.sendRedirect(request.getContextPath() + "/ingredient/list");
    }

    private double parseDoubleOrZero(String value) {
        try {
            return value == null ? 0 : Double.parseDouble(value);
        } catch (NumberFormatException exception) {
            return 0;
        }
    }
}
