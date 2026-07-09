package com.mycompany.kindergartenkitchen.controller;

import com.mycompany.kindergartenkitchen.entity.User;
import com.mycompany.kindergartenkitchen.model.Dish;
import com.mycompany.kindergartenkitchen.model.Level;
import com.mycompany.kindergartenkitchen.model.MealType;
import com.mycompany.kindergartenkitchen.model.Menu;
import com.mycompany.kindergartenkitchen.model.MenuDetail;
import com.mycompany.kindergartenkitchen.service.DishService;
import com.mycompany.kindergartenkitchen.service.LevelService;
import com.mycompany.kindergartenkitchen.service.MealTypeService;
import com.mycompany.kindergartenkitchen.service.MenuDetailService;
import com.mycompany.kindergartenkitchen.service.MenuService;
import com.mycompany.kindergartenkitchen.service.impl.DishServiceImpl;
import com.mycompany.kindergartenkitchen.service.impl.LevelServiceImpl;
import com.mycompany.kindergartenkitchen.service.impl.MealTypeServiceImpl;
import com.mycompany.kindergartenkitchen.service.impl.MenuDetailServiceImpl;
import com.mycompany.kindergartenkitchen.service.impl.MenuServiceImpl;
import com.mycompany.kindergartenkitchen.util.ServletUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Controller (Servlet) quản lý thực đơn theo tuần (Menus) và chi tiết
 * ngày/bữa/món (MenuDetails). Manager tạo thực đơn cho 1 cấp học/1 tuần, sau
 * đó vào trang chi tiết để gắn món ăn vào từng ngày + từng bữa.
 */
@WebServlet(name = "MenuServlet", urlPatterns = {"/menu/*"})
public class MenuServlet extends HttpServlet {

    private static final String VIEW_LIST = "/jsp/manager/menu-list.jsp";
    private static final String VIEW_FORM = "/jsp/manager/menu-form.jsp";
    private static final String VIEW_DETAIL = "/jsp/manager/menu-detail.jsp";

    private final MenuService menuService = new MenuServiceImpl();
    private final MenuDetailService menuDetailService = new MenuDetailServiceImpl();
    private final LevelService levelService = new LevelServiceImpl();
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
                case "/detail":
                    handleShowDetail(request, response);
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
                case "setStatus":
                    handleSetStatus(request, response);
                    break;
                case "delete":
                    handleDelete(request, response);
                    break;
                case "addDetail":
                    handleAddDetail(request, response);
                    break;
                case "removeDetail":
                    handleRemoveDetail(request, response);
                    break;
                default:
                    handleCreate(request, response);
                    break;
            }
        } catch (SQLException exception) {
            response.sendRedirect(request.getContextPath() + "/menu/list?success=false");
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

        List<Level> levelList = levelService.getAllLevel();
        String levelIdParam = request.getParameter("levelId");

        List<Menu> menuList;
        if (levelIdParam != null && !levelIdParam.isBlank()) {
            menuList = menuService.getMenuByLevel(Integer.parseInt(levelIdParam));
        } else {
            menuList = menuService.getAllMenu();
        }

        request.setAttribute("levelList", levelList);
        request.setAttribute("menuList", menuList);
        request.getRequestDispatcher(VIEW_LIST).forward(request, response);
    }

    private void handleShowForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        List<Level> levelList = levelService.getAllLevel();
        request.setAttribute("levelList", levelList);
        request.getRequestDispatcher(VIEW_FORM).forward(request, response);
    }

    private void handleShowDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        int menuId = Integer.parseInt(request.getParameter("id"));
        Menu menu = menuService.getById(menuId);
        if (menu == null) {
            response.sendRedirect(request.getContextPath() + "/menu/list");
            return;
        }

        List<MenuDetail> menuDetailList = menuDetailService.getByMenuId(menuId);
        List<MealType> mealTypeList = mealTypeService.getAllMealType();
        List<Dish> dishOptionList = dishService.getAllActiveDish();

        List<Date> weekDates = new ArrayList<>();
        java.time.LocalDate day = menu.getWeekStartDate().toLocalDate();
        for (int i = 0; i < 7; i++) {
            weekDates.add(Date.valueOf(day.plusDays(i)));
        }

        request.setAttribute("menu", menu);
        request.setAttribute("menuDetailList", menuDetailList);
        request.setAttribute("mealTypeList", mealTypeList);
        request.setAttribute("dishOptionList", dishOptionList);
        request.setAttribute("weekDates", weekDates);
        request.getRequestDispatcher(VIEW_DETAIL).forward(request, response);
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {

        User currentUser = ServletUtils.currentUser(request);
        int levelId = Integer.parseInt(request.getParameter("levelId"));
        Date weekStartDate = Date.valueOf(request.getParameter("weekStartDate"));

        int menuId = menuService.createWeeklyMenu(levelId, weekStartDate, currentUser.getUserId());
        if (menuId <= 0) {
            response.sendRedirect(request.getContextPath() + "/menu/form?success=false");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/menu/detail?id=" + menuId);
    }

    private void handleSetStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {

        int menuId = Integer.parseInt(request.getParameter("menuId"));
        boolean status = Boolean.parseBoolean(request.getParameter("status"));
        menuService.setStatus(menuId, status);
        response.sendRedirect(request.getContextPath() + "/menu/detail?id=" + menuId);
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {

        int menuId = Integer.parseInt(request.getParameter("menuId"));
        menuService.deleteMenu(menuId);
        response.sendRedirect(request.getContextPath() + "/menu/list?deleted=true");
    }

    private void handleAddDetail(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {

        int menuId = Integer.parseInt(request.getParameter("menuId"));
        Date menuDate = Date.valueOf(request.getParameter("menuDate"));
        int mealTypeId = Integer.parseInt(request.getParameter("mealTypeId"));
        int dishId = Integer.parseInt(request.getParameter("dishId"));

        boolean success = menuDetailService.addDish(menuId, menuDate, mealTypeId, dishId);
        response.sendRedirect(request.getContextPath() + "/menu/detail?id=" + menuId + "&success=" + success);
    }

    private void handleRemoveDetail(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {

        int menuId = Integer.parseInt(request.getParameter("menuId"));
        int menuDetailId = Integer.parseInt(request.getParameter("menuDetailId"));
        menuDetailService.removeDish(menuDetailId);
        response.sendRedirect(request.getContextPath() + "/menu/detail?id=" + menuId);
    }
}
