package servlet;

import config.ServletUtils;
import dao.SystemLogDAO;
import dao.UserDAO;
import model.User;
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
 * CHỨC NĂNG CẦN LÀM (cho thành viên 2):
 * - /manager/classes     → Quản lý lớp học (CRUD)
 * - /manager/students    → Quản lý học sinh (CRUD) 
 * - /manager/attendance  → Điểm danh hàng ngày
 * - /manager/ingredients → Quản lý nguyên liệu
 * - /manager/meals       → Lịch sử bếp
 * - /manager/change-password → Đổi mật khẩu
 */
@WebServlet(urlPatterns = {"/manager", "/manager/*"})
public class ManagerServlet extends HttpServlet {

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
        if (!"Manager".equalsIgnoreCase(currentUser.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Route theo path
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/dashboard")) {
            request.getRequestDispatcher("/jsp/manager/dashboard-manager.jsp").forward(request, response);
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
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin.");
            request.getRequestDispatcher("/jsp/manager/change-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Xác nhận mật khẩu không khớp.");
            request.getRequestDispatcher("/jsp/manager/change-password.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 6) {
            request.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự.");
            request.getRequestDispatcher("/jsp/manager/change-password.jsp").forward(request, response);
            return;
        }

        try {
            if (!currentUser.getPassword().equals(currentPassword)) {
                request.setAttribute("error", "Mật khẩu hiện tại không đúng.");
                request.getRequestDispatcher("/jsp/manager/change-password.jsp").forward(request, response);
                return;
            }

            userDAO.resetPassword(currentUser.getUserId(), newPassword);
            
            systemLogDAO.create(currentUser.getUserId(), "CHANGE_PASSWORD", "Users", currentUser.getUserId(),
                    "Quản lý " + currentUser.getUsername() + " đổi mật khẩu");

            currentUser.setPassword(newPassword);
            request.getSession(true).setAttribute("authUser", currentUser);

            request.setAttribute("success", "Đổi mật khẩu thành công!");
            request.getRequestDispatcher("/jsp/manager/change-password.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Không thể đổi mật khẩu", e);
        }
    }
}
