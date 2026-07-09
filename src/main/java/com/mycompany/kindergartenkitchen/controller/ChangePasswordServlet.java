package com.mycompany.kindergartenkitchen.controller;

import com.mycompany.kindergartenkitchen.util.ServletUtils;
import com.mycompany.kindergartenkitchen.dao.IUserDAO;
import com.mycompany.kindergartenkitchen.dao.ISystemLogDAO;
import com.mycompany.kindergartenkitchen.dao.UserDAO;
import com.mycompany.kindergartenkitchen.dao.SystemLogDAO;
import com.mycompany.kindergartenkitchen.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

/*
 * Change Password Servlet
 * Route: /change-password
 * Su dung chung cho tat ca cac role
 */
@WebServlet(urlPatterns = {"/change-password"})
public class ChangePasswordServlet extends HttpServlet {

    private final IUserDAO userDAO = new UserDAO();
    private final ISystemLogDAO systemLogDAO = new SystemLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = ServletUtils.currentUser(request);
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Chuyen den trang doi mat khau cua role tuong ung
        String role = currentUser.getRoleName();
        String jspPath = "/jsp/auth/change-password.jsp";
        
        switch (role) {
            case "Admin" -> jspPath = "/jsp/admin/change-password.jsp";
            case "Manager" -> jspPath = "/jsp/manager/change-password.jsp";
            case "Teacher" -> jspPath = "/jsp/teacher/change-password.jsp";
            case "Parent" -> jspPath = "/jsp/parent/change-password.jsp";
            case "KitchenStaff" -> jspPath = "/jsp/kitchen/change-password.jsp";
        }
        
        request.getRequestDispatcher(jspPath).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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
            request.setAttribute("error", "Vui long dien day du thong tin.");
            forwardBack(request, response, currentUser.getRoleName());
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Xac nhan mat khau khong khop.");
            forwardBack(request, response, currentUser.getRoleName());
            return;
        }

        if (newPassword.length() < 6) {
            request.setAttribute("error", "Mat khau moi phai co it nhat 6 ky tu.");
            forwardBack(request, response, currentUser.getRoleName());
            return;
        }

        try {
            if (!currentUser.getPassword().equals(currentPassword)) {
                request.setAttribute("error", "Mat khau hien tai khong dung.");
                forwardBack(request, response, currentUser.getRoleName());
                return;
            }

            userDAO.resetPassword(currentUser.getUserId(), newPassword);
            
            systemLogDAO.create(currentUser.getUserId(), "CHANGE_PASSWORD", "Users", currentUser.getUserId(),
                    "Nguoi dung " + currentUser.getUsername() + " doi mat khau");

            currentUser.setPassword(newPassword);
            request.getSession(true).setAttribute("authUser", currentUser);

            request.setAttribute("success", "Doi mat khau thanh cong!");
            forwardBack(request, response, currentUser.getRoleName());

        } catch (SQLException e) {
            throw new ServletException("Khong the doi mat khau", e);
        }
    }

    private void forwardBack(HttpServletRequest request, HttpServletResponse response, String role)
            throws ServletException, IOException {
        String jspPath = "/jsp/auth/change-password.jsp";
        
        switch (role) {
            case "Admin" -> jspPath = "/jsp/admin/change-password.jsp";
            case "Manager" -> jspPath = "/jsp/manager/change-password.jsp";
            case "Teacher" -> jspPath = "/jsp/teacher/change-password.jsp";
            case "Parent" -> jspPath = "/jsp/parent/change-password.jsp";
            case "KitchenStaff" -> jspPath = "/jsp/kitchen/change-password.jsp";
        }
        
        request.getRequestDispatcher(jspPath).forward(request, response);
    }
}
