/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.kindergartenkitchen.filter;

import com.mycompany.kindergartenkitchen.entity.User;
import com.mycompany.kindergartenkitchen.util.ServletUtils;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter(urlPatterns = {
    "/ingredient/*",
    "/ingredient-import/*",
    "/ingredient-usage/*",
    "/dish-ingredient/*"
})
public class KitchenIngredientFilter implements Filter {

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
        //

        if (!allowed) {
            res.sendRedirect(req.getContextPath() + "/");
            return;
        }

        chain.doFilter(request, response);
    }
}
