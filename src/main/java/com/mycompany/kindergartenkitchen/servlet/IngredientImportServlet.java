package com.mycompany.kindergartenkitchen.servlet;

import com.mycompany.kindergartenkitchen.controller.IngredientController;
import com.mycompany.kindergartenkitchen.controller.IngredientImportController;
import com.mycompany.kindergartenkitchen.model.Ingredient;
import com.mycompany.kindergartenkitchen.model.IngredientImport;
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
 * Servlet quản lý nhập kho nguyên liệu.
 */
@WebServlet(name = "IngredientImportServlet", urlPatterns = {"/ingredient-import/*"})
public class IngredientImportServlet extends HttpServlet {

    private static final String VIEW_LIST = "/jsp/ingredient/import-list.jsp";
    private static final String VIEW_FORM = "/jsp/ingredient/import-form.jsp";

    private final IngredientImportController ingredientImportController
            = new IngredientImportController();
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

        boolean success = ingredientImportController.createImport(
                ingredientId, quantity, unitPrice, importDate, supplierName, currentUserId, note);

        request.setAttribute("success", success);
        response.sendRedirect(request.getContextPath() + "/ingredient-import/list");
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        List<IngredientImport> importList = ingredientImportController.getAllImport();
        request.setAttribute("importList", importList);
        request.getRequestDispatcher(VIEW_LIST).forward(request, response);
    }

    private void handleShowForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        List<Ingredient> ingredientList = ingredientController.getAllIngredient();
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
