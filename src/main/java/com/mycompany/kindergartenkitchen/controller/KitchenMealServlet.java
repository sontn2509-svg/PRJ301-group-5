package com.mycompany.kindergartenkitchen.controller;

import com.mycompany.kindergartenkitchen.service.MealCountService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;

@WebServlet(name = "KitchenMealServlet", urlPatterns = {"/kitchen/meal-count"})
public class KitchenMealServlet extends HttpServlet {

    private final MealCountService mealCountService = new MealCountService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String dateRaw = request.getParameter("mealDate");
            Date mealDate;

            if (dateRaw == null || dateRaw.trim().isEmpty()) {
                mealDate = Date.valueOf(LocalDate.now());
            } else {
                mealDate = Date.valueOf(dateRaw);
            }

            request.setAttribute("mealDate", mealDate);
            request.setAttribute("mealCountList", mealCountService.getMealCountByDate(mealDate));
            request.setAttribute("levelMealCountList", mealCountService.getMealCountByLevel(mealDate));
            request.setAttribute("presentStudents", mealCountService.getPresentStudentsByDate(mealDate));
            request.setAttribute("totalMealCount", mealCountService.getTotalMealCount(mealDate));

            request.getRequestDispatcher("/views/kitchen-meal-count.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }
}
