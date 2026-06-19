package servlet;

import dao.SystemLogDAO;
import dao.UserDAO;
import model.User;
import config.ServletUtils;
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

@WebServlet(urlPatterns = {"/admin/change-password"})
public class ChangePasswordServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final SystemLogDAO systemLogDAO = new SystemLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/auth/change-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String currentPassword = ServletUtils.safeTrim(request.getParameter("currentPassword"));
        String newPassword = ServletUtils.safeTrim(request.getParameter("newPassword"));
        String confirmPassword = ServletUtils.safeTrim(request.getParameter("confirmPassword"));

        User currentUser = ServletUtils.currentUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<String> errors = validate(currentPassword, newPassword, confirmPassword);
        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.getRequestDispatcher("/jsp/auth/change-password.jsp").forward(request, response);
            return;
        }

        try {
            if (!currentUser.getPassword().equals(currentPassword)) {
                request.setAttribute("errors", List.of("Mật khẩu hiện tại không đúng."));
                request.getRequestDispatcher("/jsp/auth/change-password.jsp").forward(request, response);
                return;
            }

            userDAO.resetPassword(currentUser.getUserId(), newPassword);

            currentUser.setPassword(newPassword);
            HttpSession session = request.getSession();
            session.setAttribute("authUser", currentUser);

            systemLogDAO.create(currentUser.getUserId(), "CHANGE_PASSWORD", "Users", currentUser.getUserId(),
                    "Người dùng " + currentUser.getUsername() + " tự thay đổi mật khẩu");

            request.setAttribute("success", "Đổi mật khẩu thành công!");
            request.getRequestDispatcher("/jsp/auth/change-password.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Không thể đổi mật khẩu", e);
        }
    }

    private List<String> validate(String currentPassword, String newPassword, String confirmPassword) {
        List<String> errors = new ArrayList<>();

        if (currentPassword.isBlank()) {
            errors.add("Mật khẩu hiện tại không được để trống.");
        }
        if (newPassword.length() < 6) {
            errors.add("Mật khẩu mới phải có ít nhất 6 ký tự.");
        }
        if (!newPassword.equals(confirmPassword)) {
            errors.add("Xác nhận mật khẩu mới không khớp.");
        }
        if (currentPassword.equals(newPassword)) {
            errors.add("Mật khẩu mới không được trùng với mật khẩu hiện tại.");
        }
        return errors;
    }
}
