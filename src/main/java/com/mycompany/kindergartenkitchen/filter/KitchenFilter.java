package com.mycompany.kindergartenkitchen.filter;

import com.mycompany.kindergartenkitchen.util.ServletUtils;
import com.mycompany.kindergartenkitchen.entity.User;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/*
  Filter phan quyen KitchenStaff - chi cho phep KitchenStaff truy cap /kitchen/*
  - Neu khong phai KitchenStaff, chuyen ve trang chu
 */
@WebFilter("/kitchen/*")
public class KitchenFilter extends HttpFilter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        User user = ServletUtils.currentUser(req);
        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String role = user.getRoleName();
        boolean allowed = "Manager".equalsIgnoreCase(role) || "KitchenStaff".equalsIgnoreCase(role);

        if (!allowed) {
            res.sendRedirect(req.getContextPath() + "/");
            return;
        }
        chain.doFilter(request, response);
    }
}
