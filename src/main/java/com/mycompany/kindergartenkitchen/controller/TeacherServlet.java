package com.mycompany.kindergartenkitchen.controller;

import com.mycompany.kindergartenkitchen.util.ServletUtils;
import com.mycompany.kindergartenkitchen.dao.ISystemLogDAO;
import com.mycompany.kindergartenkitchen.dao.IUserDAO;
import com.mycompany.kindergartenkitchen.dao.SystemLogDAO;
import com.mycompany.kindergartenkitchen.dao.UserDAO;
import com.mycompany.kindergartenkitchen.dao.ClassDAO;
import com.mycompany.kindergartenkitchen.dao.StudentDAO;
import com.mycompany.kindergartenkitchen.dao.AttendanceDAO;
import com.mycompany.kindergartenkitchen.model.ClassInfo;
import com.mycompany.kindergartenkitchen.model.Student;
import com.mycompany.kindergartenkitchen.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/*
 * Teacher Dashboard Servlet
 * Route: /teacher/*
 * 
 * CHUC NANG CAN LAM (cho thanh vien 3):
 * - /teacher/my-class   -> Xem thong tin lop hoc duoc phan cong
 * - /teacher/attendance -> Diem danh hang ngay cho hoc sinh
 * - /teacher/absences  -> Gui/Giu yeu cau xin nghi an
 * - /teacher/change-password -> Doi mat khau
 */
@WebServlet(urlPatterns = {"/teacher", "/teacher/*"})
public class TeacherServlet extends HttpServlet {

    private final IUserDAO userDAO = new UserDAO();
    private final ISystemLogDAO systemLogDAO = new SystemLogDAO();
    private final ClassDAO classDAO = new ClassDAO();
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
        if (!"Teacher".equalsIgnoreCase(currentUser.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Lớp học đầu tiên của giáo viên (dùng chung cho dashboard/my-class)
        List<ClassInfo> myClasses = classDAO.getClassesByTeacher(currentUser.getUserId());
        ClassInfo myClass = (myClasses != null && !myClasses.isEmpty()) ? myClasses.get(0) : null;

        // Route theo path
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/dashboard")) {
            if (myClass != null) {
                List<Student> students = studentDAO.getStudentsByClass(myClass.getClassID());
                request.setAttribute("className", myClass.getClassName());
                request.setAttribute("studentCount", students != null ? students.size() : 0);
                request.setAttribute("pendingAbsences", attendanceDAO.getPendingAbsencesByTeacher(currentUser.getUserId()).size());
            } else {
                request.setAttribute("className", "Chưa phân công");
                request.setAttribute("studentCount", 0);
                request.setAttribute("pendingAbsences", 0);
            }
            request.getRequestDispatcher("/jsp/teacher/dashboard.jsp").forward(request, response);
        } else if (pathInfo.equals("/my-class")) {
            if (myClass != null) {
                request.setAttribute("className", myClass.getClassName());
                List<Student> students = studentDAO.getStudentsByClass(myClass.getClassID());
                request.setAttribute("studentCount", students != null ? students.size() : 0);
                request.setAttribute("students", students);
            } else {
                request.setAttribute("className", "Chưa được phân công lớp");
                request.setAttribute("studentCount", 0);
            }
            request.getRequestDispatcher("/jsp/teacher/my-class.jsp").forward(request, response);
        } else if (pathInfo.equals("/absences")) {
            request.setAttribute("pendingList", attendanceDAO.getPendingAbsencesByTeacher(currentUser.getUserId()));
            String msg = request.getParameter("message");
            if ("confirmSuccess".equals(msg)) {
                request.setAttribute("message", "Xác nhận nghỉ thành công.");
            } else if ("error".equals(msg)) {
                request.setAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại.");
            }
            request.getRequestDispatcher("/jsp/teacher/absences.jsp").forward(request, response);
        } else if (pathInfo.equals("/change-password")) {
            request.getRequestDispatcher("/jsp/teacher/change-password.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/teacher");
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
            response.sendRedirect(request.getContextPath() + "/teacher");
        }
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        String currentPassword = ServletUtils.safeTrim(request.getParameter("currentPassword"));
        String newPassword = ServletUtils.safeTrim(request.getParameter("newPassword"));
        String confirmPassword = ServletUtils.safeTrim(request.getParameter("confirmPassword"));

        if (currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("error", "Vui long dien day du thong tin.");
            request.getRequestDispatcher("/jsp/teacher/change-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Xac nhan mat khau khong khop.");
            request.getRequestDispatcher("/jsp/teacher/change-password.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 6) {
            request.setAttribute("error", "Mat khau moi phai co it nhat 6 ky tu.");
            request.getRequestDispatcher("/jsp/teacher/change-password.jsp").forward(request, response);
            return;
        }

        try {
            if (!currentUser.getPassword().equals(currentPassword)) {
                request.setAttribute("error", "Mat khau hien tai khong dung.");
                request.getRequestDispatcher("/jsp/teacher/change-password.jsp").forward(request, response);
                return;
            }

            userDAO.resetPassword(currentUser.getUserId(), newPassword);
            
            systemLogDAO.create(currentUser.getUserId(), "CHANGE_PASSWORD", "Users", currentUser.getUserId(),
                    "Giao vien " + currentUser.getUsername() + " doi mat khau");

            currentUser.setPassword(newPassword);
            request.getSession(true).setAttribute("authUser", currentUser);

            request.setAttribute("success", "Doi mat khau thanh cong!");
            request.getRequestDispatcher("/jsp/teacher/change-password.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Khong the doi mat khau", e);
        }
    }
}
