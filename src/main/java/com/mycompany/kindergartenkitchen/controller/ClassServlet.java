package com.mycompany.kindergartenkitchen.controller;

import com.mycompany.kindergartenkitchen.dao.ClassDAO;
import com.mycompany.kindergartenkitchen.model.ClassInfo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ClassServlet", urlPatterns = {"/classes"})
public class ClassServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ClassDAO dao = new ClassDAO();
        List<ClassInfo> classes = dao.getAllClasses();

        request.setAttribute("classes", classes);
        request.getRequestDispatcher("/views/class-list.jsp").forward(request, response);
    }
}