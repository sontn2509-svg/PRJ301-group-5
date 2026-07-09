package com.mycompany.kindergartenkitchen.controller;

import com.mycompany.kindergartenkitchen.util.ServletUtils;
import com.mycompany.kindergartenkitchen.dao.ISystemLogDAO;
import com.mycompany.kindergartenkitchen.dao.IUserDAO;
import com.mycompany.kindergartenkitchen.dao.SystemLogDAO;
import com.mycompany.kindergartenkitchen.dao.UserDAO;
import com.mycompany.kindergartenkitchen.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

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
            request.getRequestDispatcher("/jsp/manager/dashboard.jsp").forward(request, response);
        } else if (pathInfo.equals("/classes")) {
            request.getRequestDispatcher("/jsp/manager/classes.jsp").forward(request, response);
        } else if (pathInfo.equals("/students")) {
            request.getRequestDispatcher("/jsp/manager/students.jsp").forward(request, response);
        } else if (pathInfo.equals("/attendance")) {
            request.getRequestDispatcher("/jsp/manager/attendance.jsp").forward(request, response);
        } else if (pathInfo.equals("/ingredients")) {
            request.getRequestDispatcher("/jsp/manager/ingredients.jsp").forward(request, response);
        } else if (pathInfo.equals("/meals")) {
            request.getRequestDispatcher("/jsp/manager/meals.jsp").forward(request, response);
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
