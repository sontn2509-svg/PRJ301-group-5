package com.mycompany.kindergartenkitchen.controller;

import com.mycompany.kindergartenkitchen.dao.AttendanceDAO;
import com.mycompany.kindergartenkitchen.dao.IUserDAO;
import com.mycompany.kindergartenkitchen.dao.ISystemLogDAO;
import com.mycompany.kindergartenkitchen.dao.IngredientUsageDao;
import com.mycompany.kindergartenkitchen.dao.SystemLogDAO;
import com.mycompany.kindergartenkitchen.dao.UserDAO;
import com.mycompany.kindergartenkitchen.dao.impl.IngredientUsageDaoImpl;
import com.mycompany.kindergartenkitchen.entity.User;
import com.mycompany.kindergartenkitchen.model.AttendanceClassSummary;
import com.mycompany.kindergartenkitchen.model.IngredientShortageRow;
import com.mycompany.kindergartenkitchen.service.IngredientCalculatorService;
import com.mycompany.kindergartenkitchen.service.impl.IngredientCalculatorServiceImpl;
import com.mycompany.kindergartenkitchen.util.ServletUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/*
 * Kitchen Staff Dashboard Servlet
 * Route: /kitchen/*
 */
@WebServlet(urlPatterns = {
    "/kitchen",
    "/kitchen/dashboard",
    "/kitchen/meal-count",
    "/kitchen/meal-history",
    "/kitchen/ingredients",
    "/kitchen/change-password"
})
public class KitchenServlet extends HttpServlet {

    private final IUserDAO userDAO = new UserDAO();
    private final ISystemLogDAO systemLogDAO = new SystemLogDAO();
    private final AttendanceDAO attendanceDAO = new AttendanceDAO();
    private final IngredientCalculatorService ingredientCalculatorService = new IngredientCalculatorServiceImpl();
    private final IngredientUsageDao ingredientUsageDao = new IngredientUsageDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        User currentUser = ServletUtils.currentUser(request);

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!"KitchenStaff".equalsIgnoreCase(currentUser.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        switch (path) {
            case "/kitchen", "/kitchen/dashboard" ->
                handleDashboard(request, response);
            case "/kitchen/meal-count" ->
                handleMealCount(request, response);
            case "/kitchen/meal-history" ->
                handleMealHistory(request, response);
            case "/kitchen/ingredients" ->
                handleIngredients(request, response);
            case "/kitchen/change-password" ->
                request.getRequestDispatcher("/jsp/kitchen/change-password.jsp").forward(request, response);
            default ->
                response.sendRedirect(request.getContextPath() + "/kitchen");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        User currentUser = ServletUtils.currentUser(request);

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if ("/kitchen/change-password".equals(path)) {
            handleChangePassword(request, response, currentUser);
        } else {
            response.sendRedirect(request.getContextPath() + "/kitchen");
        }
    }

    /**
     * Tổng hợp điểm danh + suất ăn theo TỪNG LỚP trong 1 ngày. Dùng chung cho
     * cả /kitchen/meal-count và /kitchen/meal-history (tính suất ăn từng
     * ngày trong quá khứ vì hệ thống không lưu bảng lịch sử suất ăn riêng).
     */
    private int getTotalMealCountOnDate(Date date) {
        List<AttendanceClassSummary> summary = attendanceDAO.getAttendanceSummaryByDate(date);
        int total = 0;
        for (AttendanceClassSummary a : summary) {
            total += (a.getTotal() - a.getAbsentMeal());
        }
        return total;
    }

    private void handleMealCount(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String dateRaw = request.getParameter("mealDate");
        Date mealDate = (dateRaw == null || dateRaw.isBlank())
                ? Date.valueOf(LocalDate.now())
                : Date.valueOf(dateRaw);

        List<AttendanceClassSummary> summary = attendanceDAO.getAttendanceSummaryByDate(mealDate);

        int totalStudents = 0, totalPresent = 0, totalAbsent = 0, totalMeals = 0;
        List<Map<String, Object>> mealCounts = new ArrayList<>();

        for (AttendanceClassSummary a : summary) {
            int mealCount = a.getTotal() - a.getAbsentMeal();

            Map<String, Object> row = new HashMap<>();
            row.put("className", a.getClassName());
            row.put("totalStudents", a.getTotal());
            row.put("present", a.getPresent());
            row.put("absent", a.getAbsent());
            row.put("mealCount", mealCount);
            mealCounts.add(row);

            totalStudents += a.getTotal();
            totalPresent += a.getPresent();
            totalAbsent += a.getAbsent();
            totalMeals += mealCount;
        }

        request.setAttribute("date", mealDate);
        request.setAttribute("mealCounts", mealCounts);
        request.setAttribute("totalStudents", totalStudents);
        request.setAttribute("totalPresent", totalPresent);
        request.setAttribute("totalAbsent", totalAbsent);
        request.setAttribute("totalMeals", totalMeals);

        request.getRequestDispatcher("/jsp/kitchen/meal-count.jsp").forward(request, response);
    }

    /**
     * Cảnh báo nguyên liệu thiếu hôm nay = so sánh nguyên liệu CẦN dùng
     * (công thức món trong thực đơn hôm nay x số suất ăn thực tế) với TỒN
     * KHO hiện tại.
     */
    private void handleIngredients(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Date today = Date.valueOf(LocalDate.now());

        List<IngredientShortageRow> shortageList;
        try {
            shortageList = ingredientCalculatorService.getShortageDetails(today);
        } catch (SQLException e) {
            shortageList = new ArrayList<>();
            request.setAttribute("error", "Không thể tính toán nguyên liệu cần dùng hôm nay (có thể hôm nay chưa có thực đơn).");
        }

        request.setAttribute("date", today);
        request.setAttribute("shortageList", shortageList);

        request.getRequestDispatcher("/jsp/kitchen/ingredients.jsp").forward(request, response);
    }

    private void handleMealHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, Object>> meals = new ArrayList<>();
        LocalDate today = LocalDate.now();

        // Không có bảng lưu lịch sử suất ăn riêng, nên tính lại theo điểm
        // danh cho 14 ngày gần nhất (kể cả hôm nay).
        for (int i = 0; i < 14; i++) {
            LocalDate d = today.minusDays(i);
            Date sqlDate = Date.valueOf(d);
            int totalCount = getTotalMealCountOnDate(sqlDate);

            Map<String, Object> row = new HashMap<>();
            row.put("date", sqlDate);
            row.put("totalCount", totalCount);
            row.put("note", i == 0 ? "Hôm nay" : "");
            meals.add(row);
        }

        request.setAttribute("meals", meals);
        request.getRequestDispatcher("/jsp/kitchen/meal-history.jsp").forward(request, response);
    }

    private void handleDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LocalDate today = LocalDate.now();
        Date sqlToday = Date.valueOf(today);

        int todayCount = getTotalMealCountOnDate(sqlToday);

        List<IngredientShortageRow> shortageList;
        try {
            shortageList = ingredientCalculatorService.getShortageDetails(sqlToday);
        } catch (SQLException e) {
            shortageList = new ArrayList<>();
        }
        List<Map<String, Object>> lowStockList = new ArrayList<>();
        int lowStockCount = 0;
        for (IngredientShortageRow r : shortageList) {
            if (r.isBelowStock()) {
                lowStockCount++;
                Map<String, Object> row = new HashMap<>();
                row.put("name", r.getIngredientName());
                row.put("unit", r.getUnit());
                row.put("quantity", r.getStock());
                row.put("minThreshold", r.getNeeded());
                lowStockList.add(row);
            }
        }

        int completedToday;
        try {
            completedToday = ingredientUsageDao.findByDate(sqlToday).size();
        } catch (SQLException e) {
            completedToday = 0;
        }

        // Tổng suất ăn 7 ngày gần nhất (kể cả hôm nay)
        int totalMeals = 0;
        List<Map<String, Object>> recentMeals = new ArrayList<>();
        for (int i = 0; i < 7; i++) {
            LocalDate d = today.minusDays(i);
            Date sqlDate = Date.valueOf(d);
            int count = getTotalMealCountOnDate(sqlDate);
            totalMeals += count;

            Map<String, Object> row = new HashMap<>();
            row.put("day", String.format("%02d", d.getDayOfMonth()));
            row.put("month", d.getMonth().getDisplayName(TextStyle.SHORT, new Locale("vi")));
            row.put("date", sqlDate);
            row.put("totalCount", count);
            row.put("note", i == 0 ? "Hôm nay" : "");
            recentMeals.add(row);
        }

        request.setAttribute("todayCount", todayCount);
        request.setAttribute("totalMeals", totalMeals);
        request.setAttribute("lowStockCount", lowStockCount);
        request.setAttribute("lowStockList", lowStockList);
        request.setAttribute("completedToday", completedToday);
        request.setAttribute("recentMeals", recentMeals);

        request.getRequestDispatcher("/jsp/kitchen/dashboard.jsp").forward(request, response);
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        String currentPassword = ServletUtils.safeTrim(request.getParameter("currentPassword"));
        String newPassword = ServletUtils.safeTrim(request.getParameter("newPassword"));
        String confirmPassword = ServletUtils.safeTrim(request.getParameter("confirmPassword"));

        if (currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("error", "Vui long dien day du thong tin.");
            request.getRequestDispatcher("/jsp/kitchen/change-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Xac nhan mat khau khong khop.");
            request.getRequestDispatcher("/jsp/kitchen/change-password.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 6) {
            request.setAttribute("error", "Mat khau moi phai co it nhat 6 ky tu.");
            request.getRequestDispatcher("/jsp/kitchen/change-password.jsp").forward(request, response);
            return;
        }

        try {
            if (!currentUser.getPassword().equals(currentPassword)) {
                request.setAttribute("error", "Mat khau hien tai khong dung.");
                request.getRequestDispatcher("/jsp/kitchen/change-password.jsp").forward(request, response);
                return;
            }

            userDAO.resetPassword(currentUser.getUserId(), newPassword);

            systemLogDAO.create(currentUser.getUserId(), "CHANGE_PASSWORD", "Users", currentUser.getUserId(),
                    "Nhan vien bep " + currentUser.getUsername() + " doi mat khau");

            currentUser.setPassword(newPassword);
            request.getSession(true).setAttribute("authUser", currentUser);

            request.setAttribute("success", "Doi mat khau thanh cong!");
            request.getRequestDispatcher("/jsp/kitchen/change-password.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Khong the doi mat khau", e);
        }
    }
}
