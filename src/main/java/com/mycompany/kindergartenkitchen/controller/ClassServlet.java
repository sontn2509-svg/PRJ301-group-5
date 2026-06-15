package com.mycompany.kindergartenkitchen.controller;

import com.mycompany.kindergartenkitchen.dao.ClassDAO;
import com.mycompany.kindergartenkitchen.model.ClassInfo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ClassServlet", urlPatterns = {"/classes"})
public class ClassServlet extends HttpServlet {

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
                deleteClass(request, response);
                break;
            default:
                showClassPage(request, response, null);
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
            updateClass(request, response);
        } else {
            insertClass(request, response);
        }
    }

    private void showClassPage(HttpServletRequest request, HttpServletResponse response, ClassInfo editClass)
            throws ServletException, IOException {

        request.setAttribute("classes", classDAO.getAllClasses());
        request.setAttribute("levels", classDAO.getAllLevels());
        request.setAttribute("teachers", classDAO.getActiveTeachers());
        request.setAttribute("editClass", editClass);

        String message = request.getParameter("message");

        if (message != null) {
            switch (message) {
                case "addSuccess":
                    request.setAttribute("message", "Thêm lớp học thành công.");
                    break;
                case "updateSuccess":
                    request.setAttribute("message", "Cập nhật lớp học thành công.");
                    break;
                case "deleteSuccess":
                    request.setAttribute("message", "Xóa lớp học thành công.");
                    break;
                case "error":
                    request.setAttribute("error", "Có lỗi xảy ra. Vui lòng kiểm tra lại dữ liệu.");
                    break;
                default:
                    break;
            }
        }

        request.getRequestDispatcher("/views/class-list.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int classID = Integer.parseInt(request.getParameter("id"));
            ClassInfo editClass = classDAO.getClassById(classID);
            showClassPage(request, response, editClass);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/classes?message=error");
        }
    }

    private void insertClass(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            String className = request.getParameter("className");
            int levelID = Integer.parseInt(request.getParameter("levelID"));
            int teacherID = parseTeacherID(request.getParameter("teacherID"));

            ClassInfo classInfo = new ClassInfo();
            classInfo.setClassName(className);
            classInfo.setLevelID(levelID);
            classInfo.setTeacherID(teacherID);

            boolean success = classDAO.insertClass(classInfo);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/classes?message=addSuccess");
            } else {
                response.sendRedirect(request.getContextPath() + "/classes?message=error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/classes?message=error");
        }
    }

    private void updateClass(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            int classID = Integer.parseInt(request.getParameter("classID"));
            String className = request.getParameter("className");
            int levelID = Integer.parseInt(request.getParameter("levelID"));
            int teacherID = parseTeacherID(request.getParameter("teacherID"));

            ClassInfo classInfo = new ClassInfo();
            classInfo.setClassID(classID);
            classInfo.setClassName(className);
            classInfo.setLevelID(levelID);
            classInfo.setTeacherID(teacherID);

            boolean success = classDAO.updateClass(classInfo);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/classes?message=updateSuccess");
            } else {
                response.sendRedirect(request.getContextPath() + "/classes?message=error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/classes?message=error");
        }
    }

    private void deleteClass(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            int classID = Integer.parseInt(request.getParameter("id"));
            boolean success = classDAO.deleteClass(classID);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/classes?message=deleteSuccess");
            } else {
                response.sendRedirect(request.getContextPath() + "/classes?message=error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/classes?message=error");
        }
    }

    private int parseTeacherID(String teacherIDRaw) {
        if (teacherIDRaw == null || teacherIDRaw.trim().isEmpty()) {
            return 0;
        }

        return Integer.parseInt(teacherIDRaw);
    }
}
