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
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/*
 Xu ly dang nhap, dang xuat, quen mat khau va trang chu.
  - Admin sau khi dang nhap -> chuyen den /admin/dashboard
  - Role khac sau khi dang nhap -> hien thi trang cho
  - Quen mat khau: Buoc 1 xac minh (username + email + phone), Buoc 2 dat lai mat khau
  - Session luu user voi key "authUser"
  - Mat khau luu plain text (chua ma hoa)
 */
@WebServlet(urlPatterns = {"", "/login", "/logout", "/forgot-password"})
public class AuthServlet extends HttpServlet {

    private final IUserDAO userDAO = new UserDAO();
    private final ISystemLogDAO systemLogDAO = new SystemLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        switch (path) {
            case "/","" -> showHome(request, response);
            case "/login" -> showLogin(request, response);
            case "/logout" -> logout(request, response);
            case "/forgot-password" -> showForgotPassword(request, response);
            default -> response.sendRedirect(request.getContextPath() + "/");
        }
    }

    private void showLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/auth/login.jsp").forward(request, response);
    }

    private void showHome(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = ServletUtils.currentUser(request);

        if (currentUser != null) {
            String role = currentUser.getRoleName();
            if ("Admin".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else if ("Manager".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/manager/dashboard");
            } else if ("KitchenStaff".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/kitchen");
            } else if ("Teacher".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/teacher/dashboard");
            } else if ("Parent".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/parent/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/login");
            }
            return;
        }

        response.sendRedirect(request.getContextPath() + "/login");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String path = request.getServletPath();
        if ("/forgot-password".equals(path)) {
            handleForgotPassword(request, response);
        } else {
            login(request, response);
        }
    }

    private void showForgotPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String step = request.getParameter("step");
        HttpSession session = request.getSession(false);

        if ("2".equals(step) && session != null
                && session.getAttribute("resetUserId") != null) {
            request.setAttribute("userId", session.getAttribute("resetUserId"));
            request.setAttribute("verifiedUsername", session.getAttribute("resetUsername"));
            request.getRequestDispatcher("/jsp/auth/reset-password-form.jsp").forward(request, response);
            return;
        }

        request.getRequestDispatcher("/jsp/auth/forgot-password.jsp").forward(request, response);
    }

    private void login(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = ServletUtils.safeTrim(request.getParameter("username"));
        String password = ServletUtils.safeTrim(request.getParameter("password"));

        try {
            Optional<User> authenticated = userDAO.authenticate(username, password);

            if (authenticated.isEmpty()) {
                request.setAttribute("error", "Sai ten dang nhap, mat khau hoac tai khoan da bi khoa.");
                request.setAttribute("username", username);
                request.getRequestDispatcher("/jsp/auth/login.jsp").forward(request, response);
                return;
            }

            User user = authenticated.get();
            
            request.getSession(true).setAttribute("authUser", user);
            systemLogDAO.create(user.getUserId(), "LOGIN", "Users", user.getUserId(),
                    "Nguoi dung " + user.getUsername() + " dang nhap he thong");

            if ("Admin".equalsIgnoreCase(user.getRoleName())) {
                String redirectUrl = request.getContextPath() + "/admin/dashboard";
                response.sendRedirect(redirectUrl);
            } else if ("Manager".equalsIgnoreCase(user.getRoleName())) {
                String redirectUrl = request.getContextPath() + "/manager/dashboard";
                response.sendRedirect(redirectUrl);
            } else if ("KitchenStaff".equalsIgnoreCase(user.getRoleName())) {
                String redirectUrl = request.getContextPath() + "/kitchen";
                response.sendRedirect(redirectUrl);
            } else if ("Teacher".equalsIgnoreCase(user.getRoleName())) {
                String redirectUrl = request.getContextPath() + "/teacher/dashboard";
                response.sendRedirect(redirectUrl);
            } else if ("Parent".equalsIgnoreCase(user.getRoleName())) {
                String redirectUrl = request.getContextPath() + "/parent/dashboard";
                response.sendRedirect(redirectUrl);
            } else {
                request.setAttribute("message", "Dang nhap thanh cong. Module cua role " + user.getRoleName()
                        + " se do thanh vien khac trien khai.");
                request.getRequestDispatcher("/jsp/auth/role-waiting.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Khong the dang nhap", e);
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        User user = ServletUtils.currentUser(request);
        if (user != null) {
            try {
                systemLogDAO.create(user.getUserId(), "LOGOUT", "Users", user.getUserId(),
                        "Nguoi dung " + user.getUsername() + " dang xuat");
            } catch (SQLException e) {
                throw new ServletException("Khong the ghi log dang xuat", e);
            }
        }

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        response.sendRedirect(request.getContextPath() + "/");
    }

    private void handleForgotPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String verified = ServletUtils.safeTrim(request.getParameter("verified"));

        if ("true".equals(verified)) {
            resetPasswordStep2(request, response);
        } else {
            resetPasswordStep1(request, response);
        }
    }

    private void resetPasswordStep1(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = ServletUtils.safeTrim(request.getParameter("username"));
        String email = ServletUtils.safeTrim(request.getParameter("email"));
        String phone = ServletUtils.safeTrim(request.getParameter("phone"));

        request.setAttribute("username", username);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);

        List<String> errors = validateAccountInfo(username, email, phone);
        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.getRequestDispatcher("/jsp/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        try {
            Optional<User> user = userDAO.findForPasswordReset(username, email, phone);
            if (user.isEmpty()) {
                request.setAttribute("errors", List.of("Thong tin xac minh khong khop hoac tai khoan da bi khoa."));
                request.getRequestDispatcher("/jsp/auth/forgot-password.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession(true);
            session.setAttribute("resetUserId", user.get().getUserId());
            session.setAttribute("resetUsername", user.get().getUsername());

            response.sendRedirect(request.getContextPath() + "/forgot-password?step=2");

        } catch (SQLException e) {
            throw new ServletException("Khong the xac minh tai khoan", e);
        }
    }

    private void resetPasswordStep2(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("resetUserId") == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        Integer userId = (Integer) session.getAttribute("resetUserId");
        String username = (String) session.getAttribute("resetUsername");

        String newPassword = ServletUtils.safeTrim(request.getParameter("newPassword"));
        String confirmPassword = ServletUtils.safeTrim(request.getParameter("confirmPassword"));

        List<String> errors = validateNewPassword(newPassword, confirmPassword);
        if (!errors.isEmpty()) {
            request.setAttribute("userId", userId);
            request.setAttribute("verifiedUsername", username);
            request.setAttribute("errors", errors);
            request.getRequestDispatcher("/jsp/auth/reset-password-form.jsp").forward(request, response);
            return;
        }

        try {
            userDAO.resetPassword(userId, newPassword);
            systemLogDAO.create(userId, "RESET_PASSWORD", "Users", userId,
                    "Nguoi dung " + username + " lay lai mat khau");

            session.removeAttribute("resetUserId");
            session.removeAttribute("resetUsername");

            request.setAttribute("success", "Doi mat khau thanh cong. Ban co the dang nhap bang mat khau moi.");
            request.getRequestDispatcher("/jsp/auth/forgot-password.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Khong the luu mat khau moi", e);
        }
    }

    private List<String> validateAccountInfo(String username, String email, String phone) {
        List<String> errors = new ArrayList<>();

        if (username.isBlank()) {
            errors.add("Ten dang nhap khong duoc de trong.");
        }
        if (email.isBlank()) {
            errors.add("Email khong duoc de trong.");
        }
        String emailError = validateEmail(email);
        if (emailError != null) {
            errors.add(emailError);
        }
        if (phone.isBlank()) {
            errors.add("So dien thoai khong duoc de trong.");
        }
        String phoneError = validateVietnamPhone(phone);
        if (phoneError != null) {
            errors.add(phoneError);
        }
        return errors;
    }

    private List<String> validateNewPassword(String newPassword, String confirmPassword) {
        List<String> errors = new ArrayList<>();
        if (newPassword.length() < 6) {
            errors.add("Mat khau moi phai co it nhat 6 ky tu.");
        }
        if (!newPassword.equals(confirmPassword)) {
            errors.add("Xac nhan mat khau khong khop.");
        }
        return errors;
    }

    private String validateEmail(String email) {
        if (email == null || email.isBlank()) {
            return null;
        }
        String emailRegex = "^[a-zA-Z][a-zA-Z0-9._-]{5,29}@gmail\\.com$";
        if (!email.matches(emailRegex)) {
            return "Email phai co dinh dang Gmail hop le (vi du: example@gmail.com, ex.am-ple@gmail.com).";
        }
        if (email.matches(".*[._-]{2,}.*")) {
            return "Email khong duoc chua dau cham, gach duoi hoac gach ngang lien nhau.";
        }
        String localPart = email.split("@")[0];
        if (localPart.endsWith(".") || localPart.endsWith("_") || localPart.endsWith("-")) {
            return "Email khong duoc bat dau hoac ket thuc bang dau cham, gach duoi, hoac gach ngang.";
        }
        return null;
    }

    private String validateVietnamPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return null;
        }
        phone = phone.trim();
        if (!phone.startsWith("0")) {
            return "So dien thoai phai bat dau bang so 0 (vi du: 0912345678).";
        }
        if (!phone.matches("\\d{10,11}")) {
            return "So dien thoai phai co 10 hoac 11 chu so (vi du: 0912345678).";
        }
        String prefix = phone.substring(1, 3);
        boolean validPrefix = false;
        switch (prefix) {
            case "32","33","34","35","36","37","38","39",
                 "52","53","54","55","56","57","58","59",
                 "70","71","72","76","77","78","79",
                 "81","82","83","84","85","86","87","88","89",
                 "90","91","92","93","94","95","96","97","98","99"
                 -> validPrefix = true;
        }
        if (!validPrefix) {
            return "So dien thoai co dau so khong hop le. Dau so phai thuoc: 03x, 05x, 07x, 08x, 09x.";
        }
        return null;
    }
}
