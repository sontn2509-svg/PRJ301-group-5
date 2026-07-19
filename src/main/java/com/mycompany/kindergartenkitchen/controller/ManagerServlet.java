package com.mycompany.kindergartenkitchen.controller;

import com.mycompany.kindergartenkitchen.util.ServletUtils;
import com.mycompany.kindergartenkitchen.dao.ISystemLogDAO;
import com.mycompany.kindergartenkitchen.dao.IUserDAO;
import com.mycompany.kindergartenkitchen.dao.SystemLogDAO;
import com.mycompany.kindergartenkitchen.dao.UserDAO;
import com.mycompany.kindergartenkitchen.dao.AttendanceDAO;
import com.mycompany.kindergartenkitchen.dao.ClassDAO;
import com.mycompany.kindergartenkitchen.dao.StudentDAO;
import com.mycompany.kindergartenkitchen.dao.IngredientDao;
import com.mycompany.kindergartenkitchen.dao.impl.IngredientDaoImpl;
import com.mycompany.kindergartenkitchen.service.IngredientCalculatorService;
import com.mycompany.kindergartenkitchen.service.impl.IngredientCalculatorServiceImpl;
import com.mycompany.kindergartenkitchen.model.AttendanceClassSummary;
import com.mycompany.kindergartenkitchen.model.IngredientShortageRow;
import com.mycompany.kindergartenkitchen.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

/*
 * Manager Dashboard Servlet
 * Route: /manager/*
 * 
 * CHUC NANG CAN LAM (cho thanh vien 2):
 * - /manager/classes     -> Quan ly lop hoc (CRUD)
 * - /manager/students    -> Quan ly hoc sinh (CRUD) 
 * - /manager/attendance  -> Diem danh hang ngay
 * - /manager/ingredients -> Quan ly nguyen lieu
 * - /manager/meals       -> Lich su bep
 * - /manager/change-password -> Doi mat khau
 */
@WebServlet(urlPatterns = {"/manager", "/manager/*"})
public class ManagerServlet extends HttpServlet {

    private final IUserDAO userDAO = new UserDAO();
    private final ISystemLogDAO systemLogDAO = new SystemLogDAO();
    private final AttendanceDAO attendanceDAO = new AttendanceDAO();
    private final ClassDAO classDAO = new ClassDAO();
    private final StudentDAO studentDAO = new StudentDAO();
    private final IngredientDao ingredientDao = new IngredientDaoImpl();
    private final IngredientCalculatorService ingredientCalculatorService = new IngredientCalculatorServiceImpl();

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
        if (!"Manager".equalsIgnoreCase(currentUser.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Route theo path
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/dashboard")) {
            handleDashboard(request, response);
        } else if (pathInfo.equals("/attendance")) {
            handleAttendance(request, response);
        } else if (pathInfo.equals("/ingredients")) {
            request.getRequestDispatcher("/jsp/manager/ingredients.jsp").forward(request, response);
        } else if (pathInfo.equals("/meals")) {
            handleMeals(request, response);
        } else if (pathInfo.equals("/change-password")) {
            request.getRequestDispatcher("/jsp/manager/change-password.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/manager");
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

        // Handle change password
        if (pathInfo != null && pathInfo.equals("/change-password")) {
            handleChangePassword(request, response, currentUser);
        } else {
            response.sendRedirect(request.getContextPath() + "/manager");
        }
    }

    /**
     * Tổng suất ăn cần chuẩn bị trong 1 ngày, cộng dồn tất cả các lớp
     * (dùng chung cho dashboard và trang lịch sử bếp).
     */
    private int getTotalMealCountOnDate(Date date) {
        List<AttendanceClassSummary> summary = attendanceDAO.getAttendanceSummaryByDate(date);
        int total = 0;
        for (AttendanceClassSummary a : summary) {
            total += (a.getTotal() - a.getAbsentMeal());
        }
        return total;
    }

    private void handleDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LocalDate today = LocalDate.now();
        Date sqlToday = Date.valueOf(today);

        request.setAttribute("totalStudents", studentDAO.getAllStudents().size());
        request.setAttribute("totalClasses", classDAO.getAllClasses().size());

        int totalIngredients;
        try {
            totalIngredients = ingredientDao.findAll().size();
        } catch (SQLException e) {
            totalIngredients = 0;
        }
        request.setAttribute("totalIngredients", totalIngredients);

        List<IngredientShortageRow> shortageList;
        try {
            shortageList = ingredientCalculatorService.getShortageDetails(sqlToday);
        } catch (SQLException e) {
            shortageList = new java.util.ArrayList<>();
        }
        List<java.util.Map<String, Object>> lowStock = new java.util.ArrayList<>();
        int lowStockCount = 0;
        for (IngredientShortageRow r : shortageList) {
            if (r.isBelowStock()) {
                lowStockCount++;
                java.util.Map<String, Object> row = new java.util.HashMap<>();
                row.put("name", r.getIngredientName());
                row.put("unit", r.getUnit());
                row.put("quantity", r.getStock());
                row.put("minThreshold", r.getNeeded());
                lowStock.add(row);
            }
        }
        request.setAttribute("lowStock", lowStock);
        request.setAttribute("lowStockCount", lowStockCount);

        int totalMeals = 0;
        List<java.util.Map<String, Object>> recentMeals = new java.util.ArrayList<>();
        for (int i = 0; i < 7; i++) {
            LocalDate d = today.minusDays(i);
            Date sqlDate = Date.valueOf(d);
            int count = getTotalMealCountOnDate(sqlDate);
            totalMeals += count;

            java.util.Map<String, Object> row = new java.util.HashMap<>();
            row.put("day", String.format("%02d", d.getDayOfMonth()));
            row.put("month", d.getMonth().getDisplayName(java.time.format.TextStyle.SHORT, new java.util.Locale("vi")));
            row.put("date", sqlDate);
            row.put("totalCount", count);
            row.put("note", i == 0 ? "Hôm nay" : "");
            recentMeals.add(row);
        }
        request.setAttribute("totalMeals", totalMeals);
        request.setAttribute("recentMeals", recentMeals);

        request.getRequestDispatcher("/jsp/manager/dashboard.jsp").forward(request, response);
    }

    private void handleMeals(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<java.util.Map<String, Object>> meals = new java.util.ArrayList<>();
        LocalDate today = LocalDate.now();

        for (int i = 0; i < 14; i++) {
            LocalDate d = today.minusDays(i);
            Date sqlDate = Date.valueOf(d);
            int totalCount = getTotalMealCountOnDate(sqlDate);

            java.util.Map<String, Object> row = new java.util.HashMap<>();
            row.put("date", sqlDate);
            row.put("totalCount", totalCount);
            row.put("note", i == 0 ? "Hôm nay" : "");
            meals.add(row);
        }

        request.setAttribute("meals", meals);
        request.getRequestDispatcher("/jsp/manager/meals.jsp").forward(request, response);
    }

    /**
     * Trang điểm danh tổng hợp theo lớp cho Quản lý – VIEW CHUẨN tham chiếu
     * cho toàn hệ thống (manager/attendance.jsp). Hỗ trợ chọn ngày qua
     * ?date=yyyy-MM-dd, mặc định là hôm nay.
     */
    private void handleAttendance(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String dateParam = request.getParameter("date");
        Date attendanceDate;
        try {
            attendanceDate = (dateParam != null && !dateParam.isBlank())
                    ? Date.valueOf(dateParam) : Date.valueOf(LocalDate.now());
        } catch (IllegalArgumentException ex) {
            attendanceDate = Date.valueOf(LocalDate.now());
        }

        request.setAttribute("attendance", attendanceDAO.getAttendanceSummaryByDate(attendanceDate));
        request.setAttribute("date", attendanceDate);

        request.getRequestDispatcher("/jsp/manager/attendance.jsp").forward(request, response);
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        String currentPassword = ServletUtils.safeTrim(request.getParameter("currentPassword"));
        String newPassword = ServletUtils.safeTrim(request.getParameter("newPassword"));
        String confirmPassword = ServletUtils.safeTrim(request.getParameter("confirmPassword"));

        // Validate
        if (currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("error", "Vui long dien day du thong tin.");
            request.getRequestDispatcher("/jsp/manager/change-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Xac nhan mat khau khong khop.");
            request.getRequestDispatcher("/jsp/manager/change-password.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 6) {
            request.setAttribute("error", "Mat khau moi phai co it nhat 6 ky tu.");
            request.getRequestDispatcher("/jsp/manager/change-password.jsp").forward(request, response);
            return;
        }

        try {
            if (!currentUser.getPassword().equals(currentPassword)) {
                request.setAttribute("error", "Mat khau hien tai khong dung.");
                request.getRequestDispatcher("/jsp/manager/change-password.jsp").forward(request, response);
                return;
            }

            userDAO.resetPassword(currentUser.getUserId(), newPassword);

            systemLogDAO.create(currentUser.getUserId(), "CHANGE_PASSWORD", "Users", currentUser.getUserId(),
                    "Quan ly " + currentUser.getUsername() + " doi mat khau");

            currentUser.setPassword(newPassword);
            request.getSession(true).setAttribute("authUser", currentUser);

            request.setAttribute("success", "Doi mat khau thanh cong!");
            request.getRequestDispatcher("/jsp/manager/change-password.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Khong the doi mat khau", e);
        }
    }
}
