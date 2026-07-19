package com.mycompany.kindergartenkitchen.controller;

import com.mycompany.kindergartenkitchen.dao.ClassDAO;
import com.mycompany.kindergartenkitchen.dao.StudentDAO;
import com.mycompany.kindergartenkitchen.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

/**
 * StudentServlet – Quản lý học sinh (dành cho Admin/Manager) URL: /students
 *
 * action (GET): (none/list) – danh sách, có thể lọc theo ?classID= add – form
 * thêm mới edit – form sửa (cần ?studentID=)
 *
 * action (POST): add – lưu mới edit – cập nhật delete – xóa mềm
 */
@WebServlet(name = "StudentServlet", urlPatterns = {"/manager/students"})
public class StudentServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();
    private final ClassDAO classDAO = new ClassDAO();

    // ─── GET ─────────────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        com.mycompany.kindergartenkitchen.entity.User currentUser
                = com.mycompany.kindergartenkitchen.util.ServletUtils.currentUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!"Manager".equalsIgnoreCase(currentUser.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            request.setAttribute("classList", classDAO.getAllClasses());
            request.setAttribute("parents", studentDAO.getActiveParents());

            // Đã sửa đường dẫn ở đây: thêm thư mục "student/"
            request.getRequestDispatcher("/jsp/student/student-form.jsp").forward(request, response);
            return;
        }

        if ("edit".equals(action)) {
            String studentIDRaw = request.getParameter("studentID");
            if (studentIDRaw == null || studentIDRaw.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/manager/students");
                return;
            }
            int studentID = Integer.parseInt(studentIDRaw);
            Student student = studentDAO.getStudentById(studentID);
            if (student == null) {
                response.sendRedirect(request.getContextPath() + "/manager/students?message=notFound");
                return;
            }
            request.setAttribute("student", student);
            request.setAttribute("classList", classDAO.getAllClasses());
            request.setAttribute("parents", studentDAO.getActiveParents());

            // Đã sửa đường dẫn ở đây: thêm thư mục "student/"
            request.getRequestDispatcher("/jsp/student/student-form.jsp").forward(request, response);
            return;
        }

        // Danh sách, hỗ trợ lọc theo lớp
        String classIDRaw = request.getParameter("classID");
        List<Student> students;

        if (classIDRaw != null && !classIDRaw.trim().isEmpty()) {
            students = studentDAO.getStudentsByClass(Integer.parseInt(classIDRaw));
        } else {
            students = studentDAO.getAllStudents();
        }

        request.setAttribute("studentList", students);
        request.setAttribute("classList", classDAO.getAllClasses());

        String msg = request.getParameter("message");
        if (msg != null) {
            switch (msg) {
                case "addSuccess":
                    request.setAttribute("message", "Thêm học sinh thành công.");
                    break;
                case "editSuccess":
                    request.setAttribute("message", "Cập nhật học sinh thành công.");
                    break;
                case "deleteSuccess":
                    request.setAttribute("message", "Xóa học sinh thành công.");
                    break;
                case "notFound":
                    request.setAttribute("error", "Không tìm thấy học sinh.");
                    break;
                case "error":
                    request.setAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại.");
                    break;
                default:
                    break;
            }
        }

        // Đã sửa đường dẫn ở đây: thêm thư mục "student/"
        request.getRequestDispatcher("/jsp/student/student-list.jsp").forward(request, response);
    }

    // ─── POST ────────────────────────────────────────────────────────────────
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
        if (!"Manager".equalsIgnoreCase(currentUser.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            try {
                int studentID = Integer.parseInt(request.getParameter("studentID"));
                boolean ok = studentDAO.deleteStudent(studentID);
                response.sendRedirect(request.getContextPath()
                        + "/manager/students?message=" + (ok ? "deleteSuccess" : "error"));
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/manager/students?message=error");
            }
            return;
        }

        if ("add".equals(action)) {
            try {
                Student s = buildStudentFromRequest(request, 0);
                if (s == null) {
                    response.sendRedirect(request.getContextPath() + "/manager/students?action=add&message=error");
                    return;
                }
                boolean ok = studentDAO.insertStudent(s);
                response.sendRedirect(request.getContextPath()
                        + "/manager/students?message=" + (ok ? "addSuccess" : "error"));
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/manager/students?message=error");
            }
            return;
        }

        if ("edit".equals(action)) {
            try {
                int studentID = Integer.parseInt(request.getParameter("studentID"));
                Student s = buildStudentFromRequest(request, studentID);
                if (s == null) {
                    response.sendRedirect(request.getContextPath()
                            + "/manager/students?action=edit&studentID=" + studentID + "&message=error");
                    return;
                }
                boolean ok = studentDAO.updateStudent(s);
                response.sendRedirect(request.getContextPath()
                        + "/manager/students?message=" + (ok ? "editSuccess" : "error"));
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/manager/students?message=error");
            }
            return;
        }

        response.sendRedirect(request.getContextPath() + "/manager/students");
    }

    // ─── Helper ──────────────────────────────────────────────────────────────
    private Student buildStudentFromRequest(HttpServletRequest request, int studentID) {
        try {
            String studentCode = request.getParameter("studentCode");
            String studentName = request.getParameter("studentName");
            String dobRaw = request.getParameter("dateOfBirth");
            String genderRaw = request.getParameter("gender");
            String classIDRaw = request.getParameter("classID");
            String parentIDRaw = request.getParameter("parentID");

            if (studentCode == null || studentCode.trim().isEmpty()
                    || studentName == null || studentName.trim().isEmpty()
                    || classIDRaw == null || classIDRaw.trim().isEmpty()) {
                return null;
            }

            int classID = Integer.parseInt(classIDRaw);
            int parentID = (parentIDRaw == null || parentIDRaw.trim().isEmpty())
                    ? 0 : Integer.parseInt(parentIDRaw);
            boolean gender = "1".equals(genderRaw) || "true".equalsIgnoreCase(genderRaw);
            Date dob = (dobRaw != null && !dobRaw.trim().isEmpty())
                    ? Date.valueOf(dobRaw) : null;

            Student s = new Student();
            s.setStudentID(studentID);
            s.setStudentCode(studentCode.trim());
            s.setStudentName(studentName.trim());
            s.setDateOfBirth(dob);
            s.setGender(gender);
            s.setClassID(classID);
            s.setParentID(parentID);
            return s;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
