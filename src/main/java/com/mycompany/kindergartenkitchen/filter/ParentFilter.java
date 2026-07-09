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
  Filter phan quyen Parent - chi cho phep Parent truy cap /parent/*
  - Neu khong phai Parent, chuyen ve trang chu
 */
@WebFilter("/parent/*")
public class ParentFilter extends HttpFilter {

    @Override
    protected void doFilter(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        User currentUser = ServletUtils.currentUser(request);

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!"Parent".equalsIgnoreCase(currentUser.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        chain.doFilter(request, response);
    }
}
