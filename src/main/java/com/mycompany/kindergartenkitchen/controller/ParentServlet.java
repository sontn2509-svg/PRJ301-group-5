package com.mycompany.kindergartenkitchen.controller;

import com.mycompany.kindergartenkitchen.util.ServletUtils;
import com.mycompany.kindergartenkitchen.dao.ISystemLogDAO;
import com.mycompany.kindergartenkitchen.dao.IUserDAO;
import com.mycompany.kindergartenkitchen.dao.SystemLogDAO;
import com.mycompany.kindergartenkitchen.dao.UserDAO;
import com.mycompany.kindergartenkitchen.dao.StudentDAO;
import com.mycompany.kindergartenkitchen.dao.AttendanceDAO;
import com.mycompany.kindergartenkitchen.entity.User;
import com.mycompany.kindergartenkitchen.model.ChildView;
import com.mycompany.kindergartenkitchen.model.AttendanceHistoryView;
import com.mycompany.kindergartenkitchen.model.IngredientImport;
import com.mycompany.kindergartenkitchen.model.Level;
import com.mycompany.kindergartenkitchen.model.Menu;
import com.mycompany.kindergartenkitchen.model.MenuDetail;
import com.mycompany.kindergartenkitchen.model.Student;
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
    private final StudentDAO studentDAO = new StudentDAO();
    private final AttendanceDAO attendanceDAO = new AttendanceDAO();

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
            handleDashboard(request, response, currentUser);
        } else if (pathInfo.equals("/my-children")) {
            handleMyChildren(request, response, currentUser);
        } else if (pathInfo.equals("/absences")) {
            handleAbsencesGet(request, response, currentUser);
        } else if (pathInfo.equals("/history")) {
            handleHistory(request, response, currentUser);

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
        } else if (pathInfo != null && pathInfo.equals("/absences")) {
            handleAbsencesPost(request, response, currentUser);
        } else {
            response.sendRedirect(request.getContextPath() + "/parent");
        }
    }

    /**
     * /parent/dashboard – Tổng quan: số con, số ngày đi học/ăn bếp tháng
     * này, tình trạng hôm nay của từng con, và bữa ăn gần đây (toàn bộ con).
     */
    private void handleDashboard(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        int parentID = currentUser.getUserId();
        Date today = Date.valueOf(LocalDate.now());

        List<Student> students = studentDAO.getStudentsByParent(parentID);
        List<ChildView> children = new ArrayList<>();
        if (students != null) {
            for (Student s : students) {
                String todayStatus = attendanceDAO.getStudentStatusOnDate(s.getStudentID(), today);
                children.add(new ChildView(
                        s.getStudentID(), s.getStudentCode(), s.getStudentName(),
                        s.getClassName(), s.getDateOfBirth(), todayStatus));
            }
        }
        request.setAttribute("childCount", children.size());
        request.setAttribute("children", children);

        java.time.YearMonth thisMonth = java.time.YearMonth.now();
        Date monthStart = Date.valueOf(thisMonth.atDay(1));
        Date monthEnd = Date.valueOf(thisMonth.atEndOfMonth());

        List<AttendanceHistoryView> monthHistory = attendanceDAO.getAttendanceHistoryFullByParent(parentID, monthStart, monthEnd);

        int attendanceDays = 0; // Số ngày con thực sự có mặt ở trường
        int mealDays = 0;       // Số ngày bếp đã chuẩn bị suất ăn cho con (có mặt hoặc báo nghỉ trễ)
        for (AttendanceHistoryView h : monthHistory) {
            if ("present".equals(h.getStatus())) {
                attendanceDays++;
                mealDays++;
            } else if ("absent".equals(h.getStatus())) {
                mealDays++;
            }
        }
        request.setAttribute("attendanceDays", attendanceDays);
        request.setAttribute("mealDays", mealDays);

        // Bữa ăn gần đây (7 ngày gần nhất, tất cả các con), tối đa 8 dòng
        Date recentFrom = Date.valueOf(LocalDate.now().minusDays(6));
        List<AttendanceHistoryView> recentHistory = attendanceDAO.getAttendanceHistoryFullByParent(parentID, recentFrom, today);

        List<java.util.Map<String, Object>> recentMeals = new ArrayList<>();
        int limit = 0;
        for (AttendanceHistoryView h : recentHistory) {
            if (limit >= 8) {
                break;
            }
            java.time.LocalDate d = h.getDate().toLocalDate();
            java.util.Map<String, Object> row = new java.util.HashMap<>();
            row.put("day", String.format("%02d", d.getDayOfMonth()));
            row.put("month", d.getMonth().getDisplayName(java.time.format.TextStyle.SHORT, new java.util.Locale("vi")));
            row.put("studentName", h.getStudentName());
            row.put("className", h.getClassName());
            row.put("status", h.getStatus());
            recentMeals.add(row);
            limit++;
        }
        request.setAttribute("recentMeals", recentMeals);

        request.getRequestDispatcher("/jsp/parent/dashboard.jsp").forward(request, response);
    }

    /**
     * /parent/my-children (GET) – Danh sách con kèm trạng thái điểm danh hôm
     * nay.
     */
    private void handleMyChildren(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        int parentID = currentUser.getUserId();
        Date today = Date.valueOf(LocalDate.now());

        List<Student> students = studentDAO.getStudentsByParent(parentID);
        List<ChildView> children = new ArrayList<>();
        if (students != null) {
            for (Student s : students) {
                String todayStatus = attendanceDAO.getStudentStatusOnDate(s.getStudentID(), today);
                children.add(new ChildView(
                        s.getStudentID(), s.getStudentCode(), s.getStudentName(),
                        s.getClassName(), s.getDateOfBirth(), todayStatus));
            }
        }

        request.setAttribute("children", children);
        request.getRequestDispatcher("/jsp/parent/my-children.jsp").forward(request, response);
    }

    /**
     * /parent/absences (GET) – Form báo nghỉ + lịch sử các lần báo nghỉ.
     */
    private void handleAbsencesGet(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        int parentID = currentUser.getUserId();

        List<Student> students = studentDAO.getStudentsByParent(parentID);
        List<ChildView> children = new ArrayList<>();
        if (students != null) {
            for (Student s : students) {
                children.add(new ChildView(
                        s.getStudentID(), s.getStudentCode(), s.getStudentName(),
                        s.getClassName(), s.getDateOfBirth(), null));
            }
        }
        request.setAttribute("children", children);
        request.setAttribute("absences", attendanceDAO.getAttendanceHistoryByParent(parentID));

        String message = request.getParameter("message");
        if (message != null) {
            switch (message) {
                case "success":
                    request.setAttribute("flash", "Gửi báo nghỉ thành công.");
                    break;
                case "missing":
                    request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin báo nghỉ.");
                    break;
                case "invalidChild":
                    request.setAttribute("error", "Bạn không có quyền báo nghỉ cho học sinh này.");
                    break;
                case "error":
                    request.setAttribute("error", "Có lỗi xảy ra. Vui lòng kiểm tra lại thông tin.");
                    break;
                default:
                    break;
            }
        }

        request.getRequestDispatcher("/jsp/parent/absences.jsp").forward(request, response);
    }

    /**
     * /parent/absences (POST) – Phụ huynh gửi báo nghỉ ăn cho con.
     */
    private void handleAbsencesPost(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws IOException {

        int parentID = currentUser.getUserId();

        try {
            String studentIdRaw = request.getParameter("studentId");
            String dateRaw = request.getParameter("date");
            String reason = request.getParameter("reason");

            if (studentIdRaw == null || studentIdRaw.isBlank() || dateRaw == null || dateRaw.isBlank()) {
                response.sendRedirect(request.getContextPath() + "/parent/absences?message=missing");
                return;
            }

            int studentId = Integer.parseInt(studentIdRaw);
            Date attendanceDate = Date.valueOf(dateRaw);

            if (!studentDAO.isStudentOfParent(studentId, parentID)) {
                response.sendRedirect(request.getContextPath() + "/parent/absences?message=invalidChild");
                return;
            }

            String note = (reason == null) ? "" : reason.trim();
            boolean success = attendanceDAO.reportAbsent(studentId, attendanceDate, parentID, note);

            response.sendRedirect(request.getContextPath() + "/parent/absences?message=" + (success ? "success" : "error"));

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/parent/absences?message=error");
        }
    }

    /**
     * /parent/history (GET) – Lịch sử điểm danh/ăn uống của các con trong
     * tháng được chọn (mặc định tháng hiện tại).
     */
    private void handleHistory(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        int parentID = currentUser.getUserId();

        YearMonthParam ym = resolveYearMonth(request.getParameter("month"));

        Date fromDate = Date.valueOf(ym.yearMonth.atDay(1));
        Date toDate = Date.valueOf(ym.yearMonth.atEndOfMonth());

        request.setAttribute("history", attendanceDAO.getAttendanceHistoryFullByParent(parentID, fromDate, toDate));
        request.setAttribute("selectedMonth", ym.text);

        request.getRequestDispatcher("/jsp/parent/history.jsp").forward(request, response);
    }

    private static class YearMonthParam {
        java.time.YearMonth yearMonth;
        String text;
    }

    private YearMonthParam resolveYearMonth(String monthParam) {
        YearMonthParam result = new YearMonthParam();
        try {
            result.yearMonth = (monthParam != null && !monthParam.isBlank())
                    ? java.time.YearMonth.parse(monthParam) : java.time.YearMonth.now();
        } catch (Exception e) {
            result.yearMonth = java.time.YearMonth.now();
        }
        result.text = result.yearMonth.toString();
        return result;
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