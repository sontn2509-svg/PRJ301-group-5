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
 * Parent Dashboard Servlet
 * Route: /parent/*
 * 
 * CHỨC NĂNG CẦN LÀM (cho thành viên 4):
 * - /parent/my-children → Xem thông tin con em mình
 * - /parent/absences   → Gửi yêu cầu xin nghỉ ăn cho con
 * - /parent/history    → Xem lịch sử ăn uống của con
 * - /parent/change-password → Đổi mật khẩu
 */
@WebServlet(urlPatterns = {"/parent", "/parent/*"})
public class ParentServlet extends HttpServlet {

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
        if (!"Parent".equalsIgnoreCase(currentUser.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Route theo path
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/dashboard")) {
            request.getRequestDispatcher("/jsp/parent/dashboard-parent.jsp").forward(request, response);
        } else if (pathInfo.equals("/my-children")) {
            request.getRequestDispatcher("/jsp/parent/my-children.jsp").forward(request, response);
        } else if (pathInfo.equals("/absences")) {
            request.getRequestDispatcher("/jsp/parent/absences.jsp").forward(request, response);
        } else if (pathInfo.equals("/history")) {
            request.getRequestDispatcher("/jsp/parent/history.jsp").forward(request, response);
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
        } else {
            response.sendRedirect(request.getContextPath() + "/parent");
        }
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        String currentPassword = ServletUtils.safeTrim(request.getParameter("currentPassword"));
        String newPassword = ServletUtils.safeTrim(request.getParameter("newPassword"));
        String confirmPassword = ServletUtils.safeTrim(request.getParameter("confirmPassword"));

        if (currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin.");
            request.getRequestDispatcher("/jsp/parent/change-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Xác nhận mật khẩu không khớp.");
            request.getRequestDispatcher("/jsp/parent/change-password.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 6) {
            request.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự.");
            request.getRequestDispatcher("/jsp/parent/change-password.jsp").forward(request, response);
            return;
        }

        try {
            if (!currentUser.getPassword().equals(currentPassword)) {
                request.setAttribute("error", "Mật khẩu hiện tại không đúng.");
                request.getRequestDispatcher("/jsp/parent/change-password.jsp").forward(request, response);
                return;
            }

            userDAO.resetPassword(currentUser.getUserId(), newPassword);
            
            systemLogDAO.create(currentUser.getUserId(), "CHANGE_PASSWORD", "Users", currentUser.getUserId(),
                    "Phụ huynh " + currentUser.getUsername() + " đổi mật khẩu");

            currentUser.setPassword(newPassword);
            request.getSession(true).setAttribute("authUser", currentUser);

            request.setAttribute("success", "Đổi mật khẩu thành công!");
            request.getRequestDispatcher("/jsp/parent/change-password.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Không thể đổi mật khẩu", e);
        }
    }
}
