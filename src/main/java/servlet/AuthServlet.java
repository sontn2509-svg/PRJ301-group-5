package servlet;

import config.ServletUtils;
import dao.SystemLogDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@WebServlet(urlPatterns = {"/login", "/logout", "/forgot-password"})
public class AuthServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final SystemLogDAO systemLogDAO = new SystemLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        switch (path) {
            case "/logout" -> logout(request, response);
            case "/forgot-password" -> request.getRequestDispatcher("/jsp/auth/forgot-password.jsp").forward(request, response);
            default -> showLogin(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String path = request.getServletPath();
        if ("/forgot-password".equals(path)) {
            resetPassword(request, response);
        } else {
            login(request, response);
        }
    }

    private void showLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = ServletUtils.currentUser(request);
        if (currentUser != null && "Admin".equalsIgnoreCase(currentUser.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }
        if (currentUser != null) {
            request.setAttribute("message", "Bạn đang đăng nhập với role " + currentUser.getRoleName()
                    + ". Module role này sẽ do thành viên khác triển khai.");
            request.getRequestDispatcher("/jsp/auth/role-waiting.jsp").forward(request, response);
            return;
        }
        request.getRequestDispatcher("/jsp/auth/login.jsp").forward(request, response);
    }

    private void login(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = ServletUtils.safeTrim(request.getParameter("username"));
        String password = ServletUtils.safeTrim(request.getParameter("password"));

        try {
            Optional<User> authenticated = userDAO.authenticate(username, password);
            if (authenticated.isEmpty()) {
                request.setAttribute("error", "Sai tên đăng nhập, mật khẩu hoặc tài khoản đã bị khóa.");
                request.setAttribute("username", username);
                request.getRequestDispatcher("/jsp/auth/login.jsp").forward(request, response);
                return;
            }

            User user = authenticated.get();
            request.getSession(true).setAttribute("authUser", user);
            systemLogDAO.create(user.getUserId(), "LOGIN", "Users", user.getUserId(),
                    "Người dùng " + user.getUsername() + " đăng nhập hệ thống");

            if ("Admin".equalsIgnoreCase(user.getRoleName())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                request.setAttribute("message", "Đăng nhập thành công. Module của role " + user.getRoleName()
                        + " sẽ do thành viên khác triển khai.");
                request.getRequestDispatcher("/jsp/auth/role-waiting.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Không thể đăng nhập", e);
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        User user = ServletUtils.currentUser(request);
        if (user != null) {
            try {
                systemLogDAO.create(user.getUserId(), "LOGOUT", "Users", user.getUserId(),
                        "Người dùng " + user.getUsername() + " đăng xuất");
            } catch (SQLException e) {
                throw new ServletException("Không thể ghi log đăng xuất", e);
            }
        }
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/login");
    }

    private void resetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = ServletUtils.safeTrim(request.getParameter("username"));
        String email = ServletUtils.safeTrim(request.getParameter("email"));
        String phone = ServletUtils.safeTrim(request.getParameter("phone"));
        String newPassword = ServletUtils.safeTrim(request.getParameter("newPassword"));
        String confirmPassword = ServletUtils.safeTrim(request.getParameter("confirmPassword"));

        List<String> errors = validatePasswordReset(username, email, phone, newPassword, confirmPassword);
        request.setAttribute("username", username);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.getRequestDispatcher("/jsp/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        try {
            Optional<User> user = userDAO.findForPasswordReset(username, email, phone);
            if (user.isEmpty()) {
                request.setAttribute("errors", List.of("Thông tin xác minh không khớp hoặc tài khoản đã bị khóa."));
                request.getRequestDispatcher("/jsp/auth/forgot-password.jsp").forward(request, response);
                return;
            }

            userDAO.resetPassword(user.get().getUserId(), newPassword);
            systemLogDAO.create(user.get().getUserId(), "RESET_PASSWORD", "Users", user.get().getUserId(),
                    "Người dùng " + username + " lấy lại mật khẩu bằng email và số điện thoại");
            request.setAttribute("success", "Đổi mật khẩu thành công. Bạn có thể đăng nhập bằng mật khẩu mới.");
            request.getRequestDispatcher("/jsp/auth/forgot-password.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Không thể lấy lại mật khẩu", e);
        }
    }

    private List<String> validatePasswordReset(String username, String email, String phone,
                                               String newPassword, String confirmPassword) {
        List<String> errors = new ArrayList<>();
        if (username.isBlank()) {
            errors.add("Tên đăng nhập không được để trống.");
        }
        if (email.isBlank()) {
            errors.add("Email không được để trống.");
        }
        if (phone.isBlank()) {
            errors.add("Số điện thoại không được để trống.");
        }
        if (newPassword.length() < 6) {
            errors.add("Mật khẩu mới phải có ít nhất 6 ký tự.");
        }
        if (!newPassword.equals(confirmPassword)) {
            errors.add("Xác nhận mật khẩu không khớp.");
        }
        return errors;
    }
}
