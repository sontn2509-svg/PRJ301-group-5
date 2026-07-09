package com.mycompany.kindergartenkitchen.controller;

import com.mycompany.kindergartenkitchen.model.DishIngredient;
import com.mycompany.kindergartenkitchen.model.Dish;
import com.mycompany.kindergartenkitchen.model.Ingredient;
import com.mycompany.kindergartenkitchen.service.DishIngredientService;
import com.mycompany.kindergartenkitchen.service.IngredientService;
import com.mycompany.kindergartenkitchen.service.impl.DishIngredientServiceImpl;
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
 * Controller (Servlet) quản lý công thức món ăn (DishIngredients):
 * món ăn nào cần những nguyên liệu gì, định lượng cho 1 học sinh.
 * Chỉ làm nhiệm vụ: nhận request, parse param, gọi Service, forward JSP.
 */
@WebServlet(name = "DishIngredientServlet", urlPatterns = {"/dish-ingredient/*"})
public class DishIngredientServlet extends HttpServlet {

    private static final String VIEW_LIST = "/jsp/ingredient/dish-ingredient-list.jsp";
    private static final String VIEW_FORM = "/jsp/ingredient/dish-ingredient-form.jsp";

    private final DishIngredientService dishIngredientService = new DishIngredientServiceImpl();
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
            throws IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        try {
            switch (action) {
                case "update":
                    handleUpdate(request, response);
                    break;
                case "delete":
                    handleDelete(request, response);
                    break;
                default:
                    handleCreate(request, response);
                    break;
            }
        } catch (SQLException exception) {
            response.sendRedirect(request.getContextPath()
                    + "/dish-ingredient/list?success=false");
        }
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        List<DishIngredient> dishIngredientList = dishIngredientService.getAllDishIngredient();
        request.setAttribute("dishIngredientList", dishIngredientList);
        request.getRequestDispatcher(VIEW_LIST).forward(request, response);
    }

    private void handleShowForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        List<Dish> dishOptionList = dishIngredientService.getAllActiveDishOptions();
        List<Ingredient> ingredientList = ingredientService.getAllIngredient();
        request.setAttribute("dishOptionList", dishOptionList);
        request.setAttribute("ingredientList", ingredientList);

        String idParam = request.getParameter("id");
        if (idParam != null) {
            DishIngredient dishIngredient = dishIngredientService.getById(Integer.parseInt(idParam));
            request.setAttribute("dishIngredient", dishIngredient);
        }
        request.getRequestDispatcher(VIEW_FORM).forward(request, response);
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {

        int dishId = Integer.parseInt(request.getParameter("dishId"));
        int ingredientId = Integer.parseInt(request.getParameter("ingredientId"));
        double quantityPerStudent = parseDoubleOrZero(request.getParameter("quantityPerStudent"));

        boolean success = dishIngredientService.createDishIngredient(dishId, ingredientId, quantityPerStudent);
        response.sendRedirect(request.getContextPath() + "/dish-ingredient/list?success=" + success);
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {

        int dishIngredientId = Integer.parseInt(request.getParameter("dishIngredientId"));
        double quantityPerStudent = parseDoubleOrZero(request.getParameter("quantityPerStudent"));

        boolean updated = dishIngredientService.updateDishIngredient(dishIngredientId, quantityPerStudent);
        response.sendRedirect(request.getContextPath() + "/dish-ingredient/list?success=" + updated);
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {

        int dishIngredientId = Integer.parseInt(request.getParameter("dishIngredientId"));
        boolean deleted = dishIngredientService.deleteDishIngredient(dishIngredientId);
        response.sendRedirect(request.getContextPath() + "/dish-ingredient/list?deleted=" + deleted);
    }

    private double parseDoubleOrZero(String value) {
        try {
            return value == null ? 0 : Double.parseDouble(value);
        } catch (NumberFormatException exception) {
            return 0;
        }
    }
}
