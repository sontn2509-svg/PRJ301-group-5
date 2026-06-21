package com.mycompany.kindergartenkitchen.servlet;

import com.mycompany.kindergartenkitchen.controller.NotificationController;
import com.mycompany.kindergartenkitchen.model.UserNotification;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Servlet hiển thị và quản lý thông báo của user đang đăng nhập.
 * Dùng chung cho mọi role: Admin, Manager, Teacher, Parent, KitchenStaff.
 */
@WebServlet(name = "NotificationServlet", urlPatterns = {"/notification/*"})
public class NotificationServlet extends HttpServlet {

    private static final String VIEW_LIST = "/jsp/ingredient/notification-list.jsp";

    private final NotificationController notificationController = new NotificationController();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer currentUserId = (Integer) session.getAttribute("userId");
        if (currentUserId == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        try {
            List<UserNotification> notificationList
                    = notificationController.getNotificationByUserId(currentUserId);
            int unreadCount = notificationController.getUnreadCount(currentUserId);

            request.setAttribute("notificationList", notificationList);
            request.setAttribute("unreadCount", unreadCount);
            request.getRequestDispatcher(VIEW_LIST).forward(request, response);

        } catch (SQLException exception) {
            request.setAttribute("errorMessage", "Lỗi truy vấn dữ liệu: " + exception.getMessage());
            request.getRequestDispatcher(VIEW_LIST).forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String userNotificationIdParam = request.getParameter("userNotificationId");
        if (userNotificationIdParam != null) {
            int userNotificationId = Integer.parseInt(userNotificationIdParam);
            notificationController.markAsRead(userNotificationId);
        }

        response.sendRedirect(request.getContextPath() + "/notification");
    }
}
