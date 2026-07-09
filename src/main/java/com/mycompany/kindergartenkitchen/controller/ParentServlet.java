package com.mycompany.kindergartenkitchen.controller;

import com.mycompany.kindergartenkitchen.util.ServletUtils;
import com.mycompany.kindergartenkitchen.dao.ISystemLogDAO;
import com.mycompany.kindergartenkitchen.dao.IUserDAO;
import com.mycompany.kindergartenkitchen.dao.SystemLogDAO;
import com.mycompany.kindergartenkitchen.dao.UserDAO;
import com.mycompany.kindergartenkitchen.entity.User;
import com.mycompany.kindergartenkitchen.model.IngredientImport;
import com.mycompany.kindergartenkitchen.model.Level;
import com.mycompany.kindergartenkitchen.model.Menu;
import com.mycompany.kindergartenkitchen.model.MenuDetail;
import com.mycompany.kindergartenkitchen.service.IngredientImportService;
import com.mycompany.kindergartenkitchen.service.LevelService;
import com.mycompany.kindergartenkitchen.service.MealTypeService;
import com.mycompany.kindergartenkitchen.service.MenuDetailService;
import com.mycompany.kindergartenkitchen.service.MenuService;
import com.mycompany.kindergartenkitchen.service.impl.IngredientImportServiceImpl;
import com.mycompany.kindergartenkitchen.service.impl.LevelServiceImpl;
import com.mycompany.kindergartenkitchen.service.impl.MealTypeServiceImpl;
import com.mycompany.kindergartenkitchen.service.impl.MenuDetailServiceImpl;
import com.mycompany.kindergartenkitchen.service.impl.MenuServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.List;

/*
 * Parent Dashboard Servlet
 * Route: /parent/*
 * 
 * CHUC NANG CAN LAM (cho thanh vien 4):
 * - /parent/my-children -> Xem thong tin con em minh
 * - /parent/absences   -> Gui yeu cau xin nghi an cho con
 * - /parent/history    -> Xem lich su an uong cua con
 * - /parent/change-password -> Doi mat khau
 */
@WebServlet(urlPatterns = {"/parent", "/parent/*"})
public class ParentServlet extends HttpServlet {

    private final IUserDAO userDAO = new UserDAO();
    private final ISystemLogDAO systemLogDAO = new SystemLogDAO();
    private final LevelService levelService = new LevelServiceImpl();
    private final MenuService menuService = new MenuServiceImpl();
    private final MenuDetailService menuDetailService = new MenuDetailServiceImpl();
    private final MealTypeService mealTypeService = new MealTypeServiceImpl();
    private final IngredientImportService ingredientImportService = new IngredientImportServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        User currentUser = ServletUtils.currentUser(request);

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check role
        if (!"Parent".equalsIgnoreCase(currentUser.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Route theo path
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/dashboard")) {
            request.getRequestDispatcher("/jsp/parent/dashboard.jsp").forward(request, response);
        } else if (pathInfo.equals("/my-children")) {
            request.getRequestDispatcher("/jsp/parent/my-children.jsp").forward(request, response);
        } else if (pathInfo.equals("/absences")) {
            request.getRequestDispatcher("/jsp/parent/absences.jsp").forward(request, response);
        } else if (pathInfo.equals("/history")) {
            request.getRequestDispatcher("/jsp/parent/history.jsp").forward(request, response);

        } else if (pathInfo.equals("/transparency")) {
            try {
                handleTransparency(request, response);
            } catch (SQLException exception) {
                throw new ServletException("Khong the tai du lieu minh bach", exception);
            }
        } else if (pathInfo.equals("/menu")) {
            try {
                handleViewMenu(request, response);
            } catch (SQLException exception) {
                throw new ServletException("Khong the tai thuc don", exception);
            }
        } else if (pathInfo.equals("/change-password")) {
            request.getRequestDispatcher("/jsp/parent/change-password.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/parent");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        User currentUser = ServletUtils.currentUser(request);

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (pathInfo != null && pathInfo.equals("/change-password")) {
            handleChangePassword(request, response, currentUser);
        } else {
            response.sendRedirect(request.getContextPath() + "/parent");
        }
    }

    /**
     * Trang Phụ huynh xem menu của con: theo tuần, theo cấp học.
     *
     * LƯU Ý: module Học sinh/Lớp (P3) chưa merge nên chưa thể tự động suy ra
     * cấp học của con phụ huynh này từ Students/Classes. Tạm thời cho phụ huynh
     * tự chọn cấp học qua dropdown (mặc định cấp học đầu tiên). Khi P3 bàn giao
     * StudentDao/ClassDao, thay đoạn chọn levelId thủ công này bằng cách tra
     * cứu qua ParentID -> Students -> Classes -> LevelID.
     */
    private void handleViewMenu(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        List<Level> levelList = levelService.getAllLevel();

        int levelId;
        String levelIdParam = request.getParameter("levelId");
        if (levelIdParam != null && !levelIdParam.isBlank()) {
            levelId = Integer.parseInt(levelIdParam);
        } else if (!levelList.isEmpty()) {
            levelId = levelList.get(0).getLevelId();
        } else {
            levelId = -1;
        }
        request.setAttribute("levelList", levelList);
        request.setAttribute("selectedLevelId", levelId);

        Date anchorDate;
        String fromDateParam = request.getParameter("fromDate");
        anchorDate = fromDateParam != null && !fromDateParam.isBlank()
                ? Date.valueOf(fromDateParam) : Date.valueOf(java.time.LocalDate.now());

        Menu menu = levelId > 0 ? menuService.getPublishedMenuForDate(levelId, anchorDate) : null;
        request.setAttribute("menu", menu);

        if (menu != null) {
            List<MenuDetail> menuDetailList = menuDetailService.getByMenuId(menu.getMenuId());
            List<Date> weekDates = new ArrayList<>();
            java.time.LocalDate day = menu.getWeekStartDate().toLocalDate();
            for (int i = 0; i < 7; i++) {
                weekDates.add(Date.valueOf(day.plusDays(i)));
            }
            request.setAttribute("menuDetailList", menuDetailList);
            request.setAttribute("mealTypeList", mealTypeService.getAllMealType());
            request.setAttribute("weekDates", weekDates);
            request.setAttribute("prevWeekStart", day.minusWeeks(1));
            request.setAttribute("nextWeekStart", day.plusWeeks(1));
        }

        request.getRequestDispatcher("/jsp/parent/menu.jsp").forward(request, response);
    }

    /**
     * Trang Phụ huynh: xem minh bạch nguyên liệu nhập kho trong tuần (nhà
     * cung cấp, chi phí, số lượng). Route riêng "/parent/transparency" (thay
     * vì dùng chung "/ingredient-import/transparency" của P4) để KHÔNG bị
     * KitchenIngredientFilter chặn — filter đó chỉ cho Manager/Bếp vào
     * "/ingredient-import/*", trong khi route này nằm trong "/parent/*" nên
     * chỉ chịu sự kiểm soát của ParentFilter (đã cho phép role Parent).
     */
    private void handleTransparency(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        LocalDate anchorDate;
        String fromDateParam = request.getParameter("fromDate");
        anchorDate = (fromDateParam != null && !fromDateParam.isBlank())
                ? LocalDate.parse(fromDateParam) : LocalDate.now();

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
        request.getRequestDispatcher("/jsp/parent/transparency.jsp").forward(request, response);
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        String currentPassword = ServletUtils.safeTrim(request.getParameter("currentPassword"));
        String newPassword = ServletUtils.safeTrim(request.getParameter("newPassword"));
        String confirmPassword = ServletUtils.safeTrim(request.getParameter("confirmPassword"));

        if (currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("error", "Vui long dien day du thong tin.");
            request.getRequestDispatcher("/jsp/parent/change-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Xac nhan mat khau khong khop.");
            request.getRequestDispatcher("/jsp/parent/change-password.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 6) {
            request.setAttribute("error", "Mat khau moi phai co it nhat 6 ky tu.");
            request.getRequestDispatcher("/jsp/parent/change-password.jsp").forward(request, response);
            return;
        }

        try {
            if (!currentUser.getPassword().equals(currentPassword)) {
                request.setAttribute("error", "Mat khau hien tai khong dung.");
                request.getRequestDispatcher("/jsp/parent/change-password.jsp").forward(request, response);
                return;
            }

            userDAO.resetPassword(currentUser.getUserId(), newPassword);

            systemLogDAO.create(currentUser.getUserId(), "CHANGE_PASSWORD", "Users", currentUser.getUserId(),
                    "Phu huynh " + currentUser.getUsername() + " doi mat khau");

            currentUser.setPassword(newPassword);
            request.getSession(true).setAttribute("authUser", currentUser);

            request.setAttribute("success", "Doi mat khau thanh cong!");
            request.getRequestDispatcher("/jsp/parent/change-password.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Khong the doi mat khau", e);
        }
    }
}