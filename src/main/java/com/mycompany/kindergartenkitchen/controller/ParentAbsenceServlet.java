/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.kindergartenkitchen.controller;

import com.mycompany.kindergartenkitchen.dao.AttendanceDAO;
import com.mycompany.kindergartenkitchen.dao.StudentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;

/**
 *
 * @author VuongNguyen
 */
@WebServlet(name = "ParentAbsenceServlet", urlPatterns = {"/parent/absence"})
public class ParentAbsenceServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();
    private final AttendanceDAO attendanceDAO = new AttendanceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        com.mycompany.kindergartenkitchen.entity.User currentUser
                = com.mycompany.kindergartenkitchen.util.ServletUtils.currentUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int parentID = currentUser.getUserId();   // hoặc teacherID = currentUser.getUserId();

        request.setAttribute("children", studentDAO.getStudentsByParent(parentID));
        request.setAttribute("attendanceHistory", attendanceDAO.getAttendanceHistoryByParent(parentID));

        String message = request.getParameter("message");

        if (message != null) {
            switch (message) {
                case "success":
                    request.setAttribute("message", "Gửi báo nghỉ thành công.");
                    break;
                case "error":
                    request.setAttribute("error", "Có lỗi xảy ra. Vui lòng kiểm tra lại thông tin.");
                    break;
                case "missing":
                    request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin báo nghỉ.");
                    break;
                case "invalidChild":
                    request.setAttribute("error", "Bạn không có quyền báo nghỉ cho học sinh này.");
                    break;
                default:
                    break;
            }
        }

        // Đã sửa đường dẫn: trỏ vào thư mục "parent/"
        request.getRequestDispatcher("/jsp/parent/parent-absence.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        com.mycompany.kindergartenkitchen.entity.User currentUser
                = com.mycompany.kindergartenkitchen.util.ServletUtils.currentUser(request);

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int parentID = currentUser.getUserId();

            String studentIDRaw = request.getParameter("studentID");
            String attendanceDateRaw = request.getParameter("attendanceDate");
            String note = request.getParameter("note");

            if (studentIDRaw == null || studentIDRaw.trim().isEmpty()
                    || attendanceDateRaw == null || attendanceDateRaw.trim().isEmpty()
                    || note == null || note.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/parent/absence?message=missing");
                return;
            }

            int studentID = Integer.parseInt(studentIDRaw);
            Date attendanceDate = Date.valueOf(attendanceDateRaw);

            if (!studentDAO.isStudentOfParent(studentID, parentID)) {
                response.sendRedirect(request.getContextPath() + "/parent/absence?message=invalidChild");
                return;
            }

            boolean success = attendanceDAO.reportAbsent(studentID, attendanceDate, parentID, note.trim());

            if (success) {
                response.sendRedirect(request.getContextPath() + "/parent/absence?message=success");
            } else {
                response.sendRedirect(request.getContextPath() + "/parent/absence?message=error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/parent/absence?message=error");
        }
    }
}
