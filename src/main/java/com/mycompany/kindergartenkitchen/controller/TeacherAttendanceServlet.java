package com.mycompany.kindergartenkitchen.controller;

import com.mycompany.kindergartenkitchen.dao.AttendanceDAO;
import com.mycompany.kindergartenkitchen.dao.ClassDAO;
import com.mycompany.kindergartenkitchen.model.ClassInfo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

@WebServlet(name = "TeacherAttendanceServlet", urlPatterns = {"/teacher/attendance"})
public class TeacherAttendanceServlet extends HttpServlet {

    private final ClassDAO classDAO = new ClassDAO();
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

        int teacherID = (int) session.getAttribute("userId");

        List<ClassInfo> classes = classDAO.getClassesByTeacher(teacherID);

        String dateRaw = request.getParameter("attendanceDate");
        Date attendanceDate;

        if (dateRaw == null || dateRaw.trim().isEmpty()) {
            attendanceDate = Date.valueOf(LocalDate.now());
        } else {
            attendanceDate = Date.valueOf(dateRaw);
        }

        int selectedClassID = 0;

        String classIDRaw = request.getParameter("classID");

        if (classIDRaw != null && !classIDRaw.trim().isEmpty()) {
            selectedClassID = Integer.parseInt(classIDRaw);
        } else if (classes != null && !classes.isEmpty()) {
            selectedClassID = classes.get(0).getClassID();
        }

        if (selectedClassID > 0) {
            request.setAttribute("attendanceList",
                    attendanceDAO.getAttendanceByClassAndDate(selectedClassID, attendanceDate));
        }

        request.setAttribute("classes", classes);
        request.setAttribute("selectedClassID", selectedClassID);
        request.setAttribute("attendanceDate", attendanceDate);

        String message = request.getParameter("message");

        if (message != null) {
            switch (message) {
                case "markSuccess":
                    request.setAttribute("message", "Điểm danh thành công.");
                    break;
                case "confirmSuccess":
                    request.setAttribute("message", "Xác nhận nghỉ thành công.");
                    break;
                case "error":
                    request.setAttribute("error", "Có lỗi xảy ra. Vui lòng kiểm tra lại.");
                    break;
                default:
                    break;
            }
        }

        // Đã sửa đường dẫn ở đây: thêm thư mục "teacher/"
        request.getRequestDispatcher("/views/teacher/teacher-attendance.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int teacherID = (int) session.getAttribute("userId");

        String action = request.getParameter("action");
        String classIDRaw = request.getParameter("classID");
        String attendanceDateRaw = request.getParameter("attendanceDate");

        try {
            int classID = Integer.parseInt(classIDRaw);
            Date attendanceDate = Date.valueOf(attendanceDateRaw);

            if ("confirm".equals(action)) {
                int attendanceID = Integer.parseInt(request.getParameter("attendanceID"));

                boolean success = attendanceDAO.confirmAbsence(attendanceID, teacherID);

                if (success) {
                    response.sendRedirect(request.getContextPath()
                            + "/teacher/attendance?classID=" + classID
                            + "&attendanceDate=" + attendanceDate
                            + "&message=confirmSuccess");
                } else {
                    response.sendRedirect(request.getContextPath()
                            + "/teacher/attendance?classID=" + classID
                            + "&attendanceDate=" + attendanceDate
                            + "&message=error");
                }

                return;
            }

            int studentID = Integer.parseInt(request.getParameter("studentID"));
            String status = request.getParameter("status");
            String note = request.getParameter("note");

            if (!"Present".equals(status) && !"Absent".equals(status)) {
                response.sendRedirect(request.getContextPath()
                        + "/teacher/attendance?classID=" + classID
                        + "&attendanceDate=" + attendanceDate
                        + "&message=error");
                return;
            }

            if (note == null) {
                note = "";
            }

            boolean success = attendanceDAO.markAttendance(studentID, attendanceDate, status, teacherID, note.trim());

            if (success) {
                response.sendRedirect(request.getContextPath()
                        + "/teacher/attendance?classID=" + classID
                        + "&attendanceDate=" + attendanceDate
                        + "&message=markSuccess");
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/teacher/attendance?classID=" + classID
                        + "&attendanceDate=" + attendanceDate
                        + "&message=error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/teacher/attendance?message=error");
        }
    }
}
