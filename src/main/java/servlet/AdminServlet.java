package servlet;

import config.ServletUtils;
import dao.SystemLogDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet(urlPatterns = {"/admin/dashboard", "/admin/logs"})
public class AdminServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final SystemLogDAO systemLogDAO = new SystemLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        try {
            if ("/admin/logs".equals(path)) {
                showLogs(request, response);
            } else {
                showDashboard(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Không thể tải trang Admin", e);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        request.setAttribute("totalUsers", userDAO.countAll());
        request.setAttribute("activeUsers", userDAO.countActive());
        request.setAttribute("blockedUsers", userDAO.countBlocked());
        request.setAttribute("pendingUsers", userDAO.countPending());
        request.setAttribute("latestLogs", systemLogDAO.findLatest("", 8));
        request.getRequestDispatcher("/jsp/auth/dashboard.jsp").forward(request, response);
    }

    private void showLogs(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String keyword = ServletUtils.safeTrim(request.getParameter("keyword"));
        request.setAttribute("keyword", keyword);
        request.setAttribute("logs", systemLogDAO.findLatest(keyword, 100));
        request.getRequestDispatcher("/jsp/auth/log-list.jsp").forward(request, response);
    }
}
