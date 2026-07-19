package com.mycompany.kindergartenkitchen.controller;

import com.mycompany.kindergartenkitchen.dao.ClassDAO;
import com.mycompany.kindergartenkitchen.model.ClassInfo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * ClassServlet – Quản lý lớp học (dành cho Admin/Manager) URL: /classes
 *
 * Các action hỗ trợ (qua parameter "action"): - (mặc định / list): Hiển thị
 * danh sách lớp - add (GET): Hiển thị form thêm lớp mới - add (POST): Lưu lớp
 * mới - edit (GET): Hiển thị form chỉnh sửa lớp (cần classID) - edit (POST):
 * Lưu thay đổi lớp - delete (POST): Xóa mềm lớp (Status = 0)
 */
@WebServlet(name = "ClassServlet", urlPatterns = {"/manager/classes"})
public class ClassServlet extends HttpServlet {

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
            // Hiển thị form thêm lớp
            request.setAttribute("levels", classDAO.getAllLevels());
            request.setAttribute("teachers", classDAO.getActiveTeachers());

            // Đã sửa đường dẫn ở đây: thêm thư mục "class/"
            request.getRequestDispatcher("/jsp/class/class-form.jsp").forward(request, response);
            return;
        }

        if ("edit".equals(action)) {
            // Hiển thị form chỉnh sửa
            String classIDRaw = request.getParameter("classID");
            if (classIDRaw == null || classIDRaw.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/manager/classes");
                return;
            }
            int classID = Integer.parseInt(classIDRaw);
            ClassInfo classInfo = classDAO.getClassById(classID);

            if (classInfo == null) {
                response.sendRedirect(request.getContextPath() + "/manager/classes?message=notFound");
                return;
            }

            request.setAttribute("classInfo", classInfo);
            request.setAttribute("levels", classDAO.getAllLevels());
            request.setAttribute("teachers", classDAO.getActiveTeachers());

            // Đã sửa đường dẫn ở đây: thêm thư mục "class/"
            request.getRequestDispatcher("/jsp/class/class-form.jsp").forward(request, response);
            return;
        }

        // Mặc định: hiển thị danh sách lớp
        request.setAttribute("classList", classDAO.getAllClasses());

        String msg = request.getParameter("message");
        if (msg != null) {
            switch (msg) {
                case "addSuccess":
                    request.setAttribute("message", "Thêm lớp thành công.");
                    break;
                case "editSuccess":
                    request.setAttribute("message", "Cập nhật lớp thành công.");
                    break;
                case "deleteSuccess":
                    request.setAttribute("message", "Xóa lớp thành công.");
                    break;
                case "error":
                    request.setAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại.");
                    break;
                case "notFound":
                    request.setAttribute("error", "Không tìm thấy lớp học.");
                    break;
                default:
                    break;
            }
        }

        // Đã sửa đường dẫn ở đây: thêm thư mục "class/"
        request.getRequestDispatcher("/jsp/class/class-list.jsp").forward(request, response);
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

        // ── Xóa mềm ──
        if ("delete".equals(action)) {
            try {
                int classID = Integer.parseInt(request.getParameter("classID"));
                boolean ok = classDAO.deleteClass(classID);
                response.sendRedirect(request.getContextPath()
                        + "/manager/classes?message=" + (ok ? "deleteSuccess" : "error"));
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/manager/classes?message=error");
            }
            return;
        }

        // ── Thêm mới ──
        if ("add".equals(action)) {
            try {
                String className = request.getParameter("className");
                int levelID = Integer.parseInt(request.getParameter("levelID"));
                String teacherIDRaw = request.getParameter("teacherID");
                int teacherID = (teacherIDRaw == null || teacherIDRaw.trim().isEmpty())
                        ? 0
                        : Integer.parseInt(teacherIDRaw);

                if (className == null || className.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/manager/classes?action=add&message=error");
                    return;
                }

                ClassInfo classInfo = new ClassInfo();
                classInfo.setClassName(className.trim());
                classInfo.setLevelID(levelID);
                classInfo.setTeacherID(teacherID);

                boolean ok = classDAO.insertClass(classInfo);
                response.sendRedirect(request.getContextPath()
                        + "/manager/classes?message=" + (ok ? "addSuccess" : "error"));
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/manager/classes?message=error");
            }
            return;
        }

        // ── Chỉnh sửa ──
        if ("edit".equals(action)) {
            try {
                int classID = Integer.parseInt(request.getParameter("classID"));
                String className = request.getParameter("className");
                int levelID = Integer.parseInt(request.getParameter("levelID"));
                String teacherIDRaw = request.getParameter("teacherID");
                int teacherID = (teacherIDRaw == null || teacherIDRaw.trim().isEmpty())
                        ? 0
                        : Integer.parseInt(teacherIDRaw);

                if (className == null || className.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath()
                            + "/manager/classes?action=edit&classID=" + classID + "&message=error");
                    return;
                }

                ClassInfo classInfo = new ClassInfo();
                classInfo.setClassID(classID);
                classInfo.setClassName(className.trim());
                classInfo.setLevelID(levelID);
                classInfo.setTeacherID(teacherID);

                boolean ok = classDAO.updateClass(classInfo);
                response.sendRedirect(request.getContextPath()
                        + "/manager/classes?message=" + (ok ? "editSuccess" : "error"));
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/manager/classes?message=error");
            }
            return;
        }

        // Không khớp action nào
        response.sendRedirect(request.getContextPath() + "/manager/classes");
    }
}
