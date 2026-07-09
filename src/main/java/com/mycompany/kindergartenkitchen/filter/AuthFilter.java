package com.mycompany.kindergartenkitchen.filter;

import com.mycompany.kindergartenkitchen.util.ServletUtils;
import com.mycompany.kindergartenkitchen.entity.User;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/*
  Filter xac thuc - kiem tra nguoi dung da dang nhap hay chua.
  - Tat ca request deu phai di qua filter nay (/*)
  - Neu chua dang nhap, chuyen ve trang login
  - Cho phep cac duong dan: /login, /logout, /forgot-password, /index.jsp, /, static resources
  - Chan direct access den file .jsp
 */
@WebFilter("/*")
public class AuthFilter extends HttpFilter {

    @Override
    protected void doFilter(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        String path = request.getServletPath();

        // Cho phep cac duong dan khong can dang nhap
        if (path.equals("/") || path.equals("/index.jsp") || path.equals("/login") || path.equals("/logout")
                || path.equals("/forgot-password") || path.startsWith("/jsp/auth")
                || path.endsWith(".css") || path.endsWith(".js") || path.endsWith(".png")
                || path.endsWith(".jpg") || path.endsWith(".jpeg") || path.endsWith(".gif")
                || path.endsWith(".svg") || path.endsWith(".ico")) {
            chain.doFilter(request, response);
            return;
        }

        // Chan direct access den file .jsp
        if (path.endsWith(".jsp")) {
            User currentUser = ServletUtils.currentUser(request);
            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
        }

        // Kiem tra dang nhap
        User currentUser = ServletUtils.currentUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        chain.doFilter(request, response);
    }
}
