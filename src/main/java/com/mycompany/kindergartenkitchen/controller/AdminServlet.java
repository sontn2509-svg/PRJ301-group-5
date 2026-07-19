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
import java.util.List;

/*
  Trang Dashboard va Logs cho Admin.
  LUU Y QUAN TRONG:
  - Chi Admin moi duoc truy cap (qua AdminFilter)
  - Dashboard hien thi: tong user, user active, blocked, pending + logs gan nhat
  - Logs hien thi 100 ban ghi gan nhat, co tim kiem theo action/description
 */
@WebServlet(urlPatterns = {"/admin/dashboard", "/admin/logs", "/admin/change-password"})
public class AdminServlet extends HttpServlet {

    private final IUserDAO userDAO = new UserDAO();
    private final ISystemLogDAO systemLogDAO = new SystemLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        try {
            if ("/admin/logs".equals(path)) {
                showLogs(request, response);
            } else if ("/admin/change-password".equals(path)) {
                request.getRequestDispatcher("/jsp/admin/change-password.jsp").forward(request, response);
            } else {
                showDashboard(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Khong the tai trang Admin", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/admin/change-password".equals(path)) {
            handleAdminChangePassword(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleAdminChangePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = ServletUtils.currentUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String currentPassword = ServletUtils.safeTrim(request.getParameter("currentPassword"));
        String newPassword = ServletUtils.safeTrim(request.getParameter("newPassword"));
        String confirmPassword = ServletUtils.safeTrim(request.getParameter("confirmPassword"));

        if (currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("errors", List.of("Vui long dien day du thong tin."));
            request.getRequestDispatcher("/jsp/admin/change-password.jsp").forward(request, response);
            return;
        }
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errors", List.of("Xac nhan mat khau khong khop."));
            request.getRequestDispatcher("/jsp/admin/change-password.jsp").forward(request, response);
            return;
        }
        if (newPassword.length() < 6) {
            request.setAttribute("errors", List.of("Mat khau moi phai co it nhat 6 ky tu."));
            request.getRequestDispatcher("/jsp/admin/change-password.jsp").forward(request, response);
            return;
        }
        if (!currentUser.getPassword().equals(currentPassword)) {
            request.setAttribute("errors", List.of("Mat khau hien tai khong dung."));
            request.getRequestDispatcher("/jsp/admin/change-password.jsp").forward(request, response);
            return;
        }

        try {
            userDAO.resetPassword(currentUser.getUserId(), newPassword);
            systemLogDAO.create(currentUser.getUserId(), "CHANGE_PASSWORD", "Users", currentUser.getUserId(),
                    "Admin " + currentUser.getUsername() + " doi mat khau");
            currentUser.setPassword(newPassword);
            request.getSession(true).setAttribute("authUser", currentUser);
            request.setAttribute("success", "Doi mat khau thanh cong!");
            request.getRequestDispatcher("/jsp/admin/change-password.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Khong the doi mat khau", e);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        request.setAttribute("totalUsers", userDAO.countAll());
        request.setAttribute("activeUsers", userDAO.countActive());
        request.setAttribute("blockedUsers", userDAO.countBlocked());
        request.setAttribute("pendingUsers", userDAO.countPending());
        request.setAttribute("latestLogs", systemLogDAO.findLatest("", 8));
        request.getRequestDispatcher("/jsp/admin/dashboard.jsp").forward(request, response);
    }

    private void showLogs(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String keyword = ServletUtils.safeTrim(request.getParameter("keyword"));
        request.setAttribute("keyword", keyword);
        request.setAttribute("logs", systemLogDAO.findLatest(keyword, 100));
        request.getRequestDispatcher("/jsp/admin/log-list.jsp").forward(request, response);
    }
}
