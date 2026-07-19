package com.mycompany.kindergartenkitchen.controller;

import com.mycompany.kindergartenkitchen.entity.User;
import com.mycompany.kindergartenkitchen.model.Dish;
import com.mycompany.kindergartenkitchen.model.MealType;
import com.mycompany.kindergartenkitchen.service.DishService;
import com.mycompany.kindergartenkitchen.service.MealTypeService;
import com.mycompany.kindergartenkitchen.service.impl.DishServiceImpl;
import com.mycompany.kindergartenkitchen.service.impl.MealTypeServiceImpl;
import com.mycompany.kindergartenkitchen.util.ServletUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Controller (Servlet) quản lý danh sách món ăn (Dishes).
 * Bảo vệ bởi ManagerFilter ("/manager/*") KHÔNG áp dụng ở đây vì route này
 * nằm ngoài "/manager/*" (theo đúng cách P4 đã làm với /ingredient/*), nên tự
 * kiểm tra role Manager ngay trong Servlet.
 */
@WebServlet(name = "DishServlet", urlPatterns = {"/dish/*"})
public class DishServlet extends HttpServlet {

    private static final String VIEW_LIST = "/jsp/manager/dish-list.jsp";
    private static final String VIEW_FORM = "/jsp/manager/dish-form.jsp";

    private final DishService dishService = new DishServiceImpl();
    private final MealTypeService mealTypeService = new MealTypeServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!requireManager(request, response)) {
            return;
        }

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

        if (!requireManager(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        try {
            switch (action) {
                case "update":
                    handleUpdate(request, response);
                    break;
                case "setStatus":
                    handleSetStatus(request, response);
                    break;
                case "mealTypeCreate":
                    handleMealTypeCreate(request, response);
                    break;
                case "mealTypeUpdate":
                    handleMealTypeUpdate(request, response);
                    break;
                case "mealTypeDelete":
                    handleMealTypeDelete(request, response);
                    break;
                default:
                    handleCreate(request, response);
                    break;
            }
        } catch (SQLException exception) {
            response.sendRedirect(request.getContextPath() + "/dish/list?success=false");
        }
    }

    private boolean requireManager(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        User currentUser = ServletUtils.currentUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        if (!"Manager".equalsIgnoreCase(currentUser.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/");
            return false;
        }
        return true;
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        List<Dish> dishList = dishService.getAllDish();
        List<MealType> mealTypeList = mealTypeService.getAllMealType();
        request.setAttribute("dishList", dishList);
        request.setAttribute("mealTypeList", mealTypeList);
        request.getRequestDispatcher(VIEW_LIST).forward(request, response);
    }

    private void handleShowForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        String idParam = request.getParameter("id");
        if (idParam != null) {
            Dish dish = dishService.getById(Integer.parseInt(idParam));
            request.setAttribute("dish", dish);
        }
        request.getRequestDispatcher(VIEW_FORM).forward(request, response);
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {

        String dishName = ServletUtils.safeTrim(request.getParameter("dishName"));
        String description = ServletUtils.safeTrim(request.getParameter("description"));

        boolean success = dishService.createDish(dishName, description);
        response.sendRedirect(request.getContextPath() + "/dish/list?success=" + success);
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {

        int dishId = Integer.parseInt(request.getParameter("dishId"));
        String dishName = ServletUtils.safeTrim(request.getParameter("dishName"));
        String description = ServletUtils.safeTrim(request.getParameter("description"));

        boolean updated = dishService.updateDish(dishId, dishName, description);
        response.sendRedirect(request.getContextPath() + "/dish/list?success=" + updated);
    }

    private void handleSetStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {

        int dishId = Integer.parseInt(request.getParameter("dishId"));
        boolean status = Boolean.parseBoolean(request.getParameter("status"));
        dishService.setStatus(dishId, status);
        response.sendRedirect(request.getContextPath() + "/dish/list");
    }

    private void handleMealTypeCreate(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {

        String mealTypeName = ServletUtils.safeTrim(request.getParameter("mealTypeName"));
        boolean success = mealTypeService.createMealType(mealTypeName);
        response.sendRedirect(request.getContextPath() + "/dish/list?mtSuccess=" + success);
    }

    private void handleMealTypeUpdate(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {

        int mealTypeId = Integer.parseInt(request.getParameter("mealTypeId"));
        String mealTypeName = ServletUtils.safeTrim(request.getParameter("mealTypeName"));
        boolean updated = mealTypeService.updateMealType(mealTypeId, mealTypeName);
        response.sendRedirect(request.getContextPath() + "/dish/list?mtSuccess=" + updated);
    }

    private void handleMealTypeDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {

        int mealTypeId = Integer.parseInt(request.getParameter("mealTypeId"));
        boolean deleted = mealTypeService.deleteMealType(mealTypeId);
        response.sendRedirect(request.getContextPath() + "/dish/list?mtDeleted=" + deleted);
    }
}
