package servlet;

import config.ServletUtils;
import dao.UserDAO;
import dao.SystemLogDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

/*
 * Kitchen Staff Dashboard
 * Route: /kitchen/*
 */
@WebServlet(urlPatterns = {"/kitchen", "/kitchen/*"})
public class KitchenServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final SystemLogDAO systemLogDAO = new SystemLogDAO();

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
        if (!"KitchenStaff".equalsIgnoreCase(currentUser.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Route theo path
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/dashboard")) {
            request.getRequestDispatcher("/jsp/kitchen/dashboard-kitchen.jsp").forward(request, response);
        } else if (pathInfo.equals("/meal-count")) {
            request.getRequestDispatcher("/jsp/kitchen/meal-count.jsp").forward(request, response);
        } else if (pathInfo.equals("/meal-history")) {
            request.getRequestDispatcher("/jsp/kitchen/meal-history.jsp").forward(request, response);
        } else if (pathInfo.equals("/ingredients")) {
            request.getRequestDispatcher("/jsp/kitchen/ingredients.jsp").forward(request, response);
        } else if (pathInfo.equals("/change-password")) {
            request.getRequestDispatcher("/jsp/kitchen/change-password.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/kitchen");
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
            response.sendRedirect(request.getContextPath() + "/kitchen");
        }
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        String currentPassword = ServletUtils.safeTrim(request.getParameter("currentPassword"));
        String newPassword = ServletUtils.safeTrim(request.getParameter("newPassword"));
        String confirmPassword = ServletUtils.safeTrim(request.getParameter("confirmPassword"));

        // Validate
        if (currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin.");
            request.getRequestDispatcher("/jsp/kitchen/change-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Xác nhận mật khẩu không khớp.");
            request.getRequestDispatcher("/jsp/kitchen/change-password.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 6) {
            request.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự.");
            request.getRequestDispatcher("/jsp/kitchen/change-password.jsp").forward(request, response);
            return;
        }

        try {
            // Verify current password
            if (!currentUser.getPassword().equals(currentPassword)) {
                request.setAttribute("error", "Mật khẩu hiện tại không đúng.");
                request.getRequestDispatcher("/jsp/kitchen/change-password.jsp").forward(request, response);
                return;
            }

            // Update password
            userDAO.resetPassword(currentUser.getUserId(), newPassword);
            
            // Log
            systemLogDAO.create(currentUser.getUserId(), "CHANGE_PASSWORD", "Users", currentUser.getUserId(),
                    "Nhân viên bếp " + currentUser.getUsername() + " đổi mật khẩu");

            // Update session with new password
            currentUser.setPassword(newPassword);
            request.getSession(true).setAttribute("authUser", currentUser);

            request.setAttribute("success", "Đổi mật khẩu thành công!");
            request.getRequestDispatcher("/jsp/kitchen/change-password.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Không thể đổi mật khẩu", e);
        }
    }
}
