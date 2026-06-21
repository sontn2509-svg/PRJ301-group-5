/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.kindergartenkitchen.controller;

import com.mycompany.kindergartenkitchen.dao.AttendanceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;

/**
 *
 * @author VuongNguyen
 */
@WebServlet(name = "MealHistoryServlet", urlPatterns = {"/parent/meal-history"})
public class MealHistoryServlet extends HttpServlet {

    private final AttendanceDAO attendanceDAO = new AttendanceDAO();

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

        int parentID = (int) session.getAttribute("userId");

        LocalDate today = LocalDate.now();
        int year = today.getYear();
        int month = today.getMonthValue();

        String yearRaw = request.getParameter("year");
        String monthRaw = request.getParameter("month");

        if (yearRaw != null && !yearRaw.trim().isEmpty()) {
            year = Integer.parseInt(yearRaw);
        }

        if (monthRaw != null && !monthRaw.trim().isEmpty()) {
            month = Integer.parseInt(monthRaw);
        }

        request.setAttribute("selectedYear", year);
        request.setAttribute("selectedMonth", month);
        request.setAttribute("mealHistoryList", attendanceDAO.getMealHistoryByParent(parentID, year, month));

        request.getRequestDispatcher("/views/meal-history.jsp").forward(request, response);
    }
}
