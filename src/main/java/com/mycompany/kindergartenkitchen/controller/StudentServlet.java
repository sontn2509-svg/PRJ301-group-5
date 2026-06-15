package com.mycompany.kindergartenkitchen.controller;

import com.mycompany.kindergartenkitchen.dao.ClassDAO;
import com.mycompany.kindergartenkitchen.dao.StudentDAO;
import com.mycompany.kindergartenkitchen.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;

@WebServlet(name = "StudentServlet", urlPatterns = {"/students"})
public class StudentServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();
    private final ClassDAO classDAO = new ClassDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteStudent(request, response);
                break;
            default:
                showStudentPage(request, response, null);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("update".equals(action)) {
            updateStudent(request, response);
        } else {
            insertStudent(request, response);
        }
    }

    private void showStudentPage(HttpServletRequest request, HttpServletResponse response, Student editStudent)
            throws ServletException, IOException {

        request.setAttribute("students", studentDAO.getAllStudents());
        request.setAttribute("classes", classDAO.getAllClasses());
        request.setAttribute("parents", studentDAO.getActiveParents());
        request.setAttribute("editStudent", editStudent);

        String message = request.getParameter("message");

        if (message != null) {
            switch (message) {
                case "addSuccess":
                    request.setAttribute("message", "Thêm học sinh thành công.");
                    break;
                case "updateSuccess":
                    request.setAttribute("message", "Cập nhật học sinh thành công.");
                    break;
                case "deleteSuccess":
                    request.setAttribute("message", "Xóa học sinh thành công.");
                    break;
                case "error":
                    request.setAttribute("error", "Có lỗi xảy ra. Vui lòng kiểm tra lại dữ liệu.");
                    break;
                default:
                    break;
            }
        }

        request.getRequestDispatcher("/views/student-list.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int studentID = Integer.parseInt(request.getParameter("id"));
            Student editStudent = studentDAO.getStudentById(studentID);
            showStudentPage(request, response, editStudent);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/students?message=error");
        }
    }

    private void insertStudent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            String studentCode = request.getParameter("studentCode");
            String studentName = request.getParameter("studentName");
            Date dateOfBirth = Date.valueOf(request.getParameter("dateOfBirth"));
            boolean gender = "1".equals(request.getParameter("gender"));
            int classID = Integer.parseInt(request.getParameter("classID"));
            int parentID = parseParentID(request.getParameter("parentID"));

            Student student = new Student();
            student.setStudentCode(studentCode);
            student.setStudentName(studentName);
            student.setDateOfBirth(dateOfBirth);
            student.setGender(gender);
            student.setClassID(classID);
            student.setParentID(parentID);

            boolean success = studentDAO.insertStudent(student);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/students?message=addSuccess");
            } else {
                response.sendRedirect(request.getContextPath() + "/students?message=error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/students?message=error");
        }
    }

    private void updateStudent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            int studentID = Integer.parseInt(request.getParameter("studentID"));
            String studentCode = request.getParameter("studentCode");
            String studentName = request.getParameter("studentName");
            Date dateOfBirth = Date.valueOf(request.getParameter("dateOfBirth"));
            boolean gender = "1".equals(request.getParameter("gender"));
            int classID = Integer.parseInt(request.getParameter("classID"));
            int parentID = parseParentID(request.getParameter("parentID"));

            Student student = new Student();
            student.setStudentID(studentID);
            student.setStudentCode(studentCode);
            student.setStudentName(studentName);
            student.setDateOfBirth(dateOfBirth);
            student.setGender(gender);
            student.setClassID(classID);
            student.setParentID(parentID);

            boolean success = studentDAO.updateStudent(student);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/students?message=updateSuccess");
            } else {
                response.sendRedirect(request.getContextPath() + "/students?message=error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/students?message=error");
        }
    }

    private void deleteStudent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            int studentID = Integer.parseInt(request.getParameter("id"));
            boolean success = studentDAO.deleteStudent(studentID);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/students?message=deleteSuccess");
            } else {
                response.sendRedirect(request.getContextPath() + "/students?message=error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/students?message=error");
        }
    }

    private int parseParentID(String parentIDRaw) {
        if (parentIDRaw == null || parentIDRaw.trim().isEmpty()) {
            return 0;
        }

        return Integer.parseInt(parentIDRaw);
    }
}
