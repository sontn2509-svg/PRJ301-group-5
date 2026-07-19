package com.mycompany.kindergartenkitchen.controller;

import com.mycompany.kindergartenkitchen.dao.IRoleDAO;
import com.mycompany.kindergartenkitchen.dao.ISystemLogDAO;
import com.mycompany.kindergartenkitchen.dao.IUserDAO;
import com.mycompany.kindergartenkitchen.dao.RoleDAO;
import com.mycompany.kindergartenkitchen.dao.SystemLogDAO;
import com.mycompany.kindergartenkitchen.dao.UserDAO;
import com.mycompany.kindergartenkitchen.entity.User;
import com.mycompany.kindergartenkitchen.util.ServletUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/*
  Quan ly nguoi dung (Admin only).
  URL PATTERNS:
  - /admin/users -> Danh sach nguoi dung (co tim kiem, loc theo role/status)
  - /admin/users/create -> Form tao nguoi dung moi
  - /admin/users/edit -> Form chinh sua nguoi dung
  - /admin/users/toggle -> Doi trang thai (kich hoat/khoa)
  - /admin/users/delete -> Xoa nguoi dung
  
  - Chi Admin moi duoc truy cap (qua AdminFilter)
  - Khong the tao them tai khoan Admin (RoleID = 1) - chi co 1 Admin
  - Khong the xoa tai khoan Admin
  - Khong the xoa tai khoan cua chinh minh
  - Toggle status: RoleID = 1 (Admin) khong duoc phep toggle
  - Tat ca thao tac deu duoc ghi log vao SystemLogs
 */
@WebServlet(urlPatterns = {
        "/admin/users",
        "/admin/users/create",
        "/admin/users/edit",
        "/admin/users/toggle",
        "/admin/users/delete"
})
public class UserServlet extends HttpServlet {

    private final IUserDAO userDAO = new UserDAO();
    private final IRoleDAO roleDAO = new RoleDAO();
    private final ISystemLogDAO systemLogDAO = new SystemLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        try {
            switch (path) {
                case "/admin/users/create" -> showCreateForm(request, response);
                case "/admin/users/edit" -> showEditForm(request, response);
                case "/admin/users/toggle" -> toggleStatus(request, response);
                case "/admin/users/delete" -> deleteUser(request, response);
                default -> showList(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Khong the xu ly nguoi dung", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String path = request.getServletPath();
        try {
            if ("/admin/users/create".equals(path)) {
                createUser(request, response);
            } else if ("/admin/users/edit".equals(path)) {
                updateUser(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            throw new ServletException("Khong the luu nguoi dung", e);
        }
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String keyword = ServletUtils.safeTrim(request.getParameter("keyword"));
        Integer roleId = parseNullableInt(request.getParameter("roleId"));
        Integer status = parseNullableInt(request.getParameter("status"));

        request.setAttribute("users", userDAO.search(keyword, roleId, status));
        request.setAttribute("roles", roleDAO.findAll());
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedRoleId", roleId);
        request.setAttribute("selectedStatus", status);
        moveFlash(request);
        request.getRequestDispatcher("/jsp/admin/user-list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        request.setAttribute("formAction", request.getContextPath() + "/admin/users/create");
        request.setAttribute("roles", roleDAO.findAll());
        request.setAttribute("userForm", new User());
        request.getRequestDispatcher("/jsp/admin/user-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = parseRequiredId(request);
        Optional<User> user = userDAO.findById(id);
        if (user.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Khong tim thay tai khoan.");
            return;
        }
        request.setAttribute("formAction", request.getContextPath() + "/admin/users/edit?id=" + id);
        request.setAttribute("roles", roleDAO.findAll());
        request.setAttribute("userForm", user.get());
        request.setAttribute("editMode", true);
        request.getRequestDispatcher("/jsp/admin/user-form.jsp").forward(request, response);
    }

    private void createUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        User form = readForm(request, true);
        List<String> errors = validate(form, true, null);
        if (!errors.isEmpty()) {
            forwardFormWithErrors(request, response, form, errors, false);
            return;
        }

        int newId = userDAO.create(form);
        User admin = ServletUtils.currentUser(request);
        systemLogDAO.create(admin.getUserId(), "CREATE_USER", "Users", newId,
                "Admin tao tai khoan " + form.getUsername());

        request.getSession().setAttribute("flash", "Da tao tai khoan " + form.getUsername() + ".");
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = parseRequiredId(request);
        Optional<User> existing = userDAO.findById(id);
        if (existing.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Khong tim thay tai khoan.");
            return;
        }

        User form = readForm(request, false);
        form.setUserId(id);
        form.setUsername(existing.get().getUsername());
        boolean changePassword = !ServletUtils.safeTrim(form.getPassword()).isEmpty();

        List<String> errors = validate(form, false, id);
        if (!errors.isEmpty()) {
            forwardFormWithErrors(request, response, form, errors, true);
            return;
        }

        userDAO.update(form, changePassword);
        User admin = ServletUtils.currentUser(request);
        systemLogDAO.create(admin.getUserId(), "UPDATE_USER", "Users", id,
                "Admin cap nhat tai khoan " + form.getUsername());

        request.getSession().setAttribute("flash", "Da cap nhat tai khoan " + form.getUsername() + ".");
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void toggleStatus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = parseRequiredId(request);
        Optional<User> target = userDAO.findById(id);

        if (target.isPresent() && target.get().getRoleId() != 1) {
            userDAO.toggleStatus(id);
            User admin = ServletUtils.currentUser(request);
            systemLogDAO.create(admin.getUserId(), "TOGGLE_USER_STATUS", "Users", id,
                    "Admin doi trang thai tai khoan " + target.get().getUsername());
            request.getSession().setAttribute("flash", "Da doi trang thai tai khoan " + target.get().getUsername() + ".");
        }
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = parseRequiredId(request);
        Optional<User> target = userDAO.findById(id);

        if (target.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        User admin = ServletUtils.currentUser(request);

        if (target.get().getRoleId() == 1) {
            request.getSession().setAttribute("flash", "Khong the xoa tai khoan Admin.");
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        if (admin != null && admin.getUserId() == id) {
            request.getSession().setAttribute("flash", "Ban khong the xoa tai khoan cua chinh minh.");
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        String deletedUsername = target.get().getUsername();
        int deletedId = target.get().getUserId();

        userDAO.delete(id);
        systemLogDAO.create(admin.getUserId(), "DELETE_USER", "Users", deletedId,
                "Admin xoa tai khoan " + deletedUsername);

        request.getSession().setAttribute("flash", "Da xoa tai khoan " + deletedUsername + ".");
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private User readForm(HttpServletRequest request, boolean includeUsername) {
        User user = new User();
        if (includeUsername) {
            user.setUsername(ServletUtils.safeTrim(request.getParameter("username")));
        }
        user.setPassword(ServletUtils.safeTrim(request.getParameter("password")));
        user.setFullName(ServletUtils.safeTrim(request.getParameter("fullName")));
        user.setEmail(ServletUtils.safeTrim(request.getParameter("email")));
        user.setPhone(ServletUtils.safeTrim(request.getParameter("phone")));
        user.setRoleId(parseNullableInt(request.getParameter("roleId")) == null ? 0 : parseNullableInt(request.getParameter("roleId")));
        user.setStatus(parseNullableInt(request.getParameter("status")) == null ? 1 : parseNullableInt(request.getParameter("status")));
        return user;
    }

    private List<String> validate(User user, boolean createMode, Integer exceptUserId) throws SQLException {
        List<String> errors = new ArrayList<>();

        if (createMode && user.getUsername().isBlank()) {
            errors.add("Ten dang nhap khong duoc de trong.");
        }
        if (createMode && userDAO.usernameExists(user.getUsername(), exceptUserId)) {
            errors.add("Ten dang nhap da ton tai.");
        }
        if (createMode && user.getPassword().isBlank()) {
            errors.add("Mat khau khong duoc de trong.");
        }
        if (user.getFullName().isBlank()) {
            errors.add("Ho ten khong duoc de trong.");
        }
        if (user.getRoleId() <= 0) {
            errors.add("Vui long chon vai tro.");
        }
        if (createMode && user.getRoleId() == 1) {
            errors.add("Khong the tao them tai khoan Admin. He thong chi cho phep duy nhat 1 tai khoan Admin.");
        }
        if (user.getStatus() < 0 || user.getStatus() > 2) {
            errors.add("Trang thai tai khoan khong hop le.");
        }
        String emailValidation = validateEmail(user.getEmail());
        if (emailValidation != null) {
            errors.add(emailValidation);
        }
        String phoneValidation = validateVietnamPhone(user.getPhone());
        if (phoneValidation != null) {
            errors.add(phoneValidation);
        }
        return errors;
    }

    private String validateEmail(String email) {
        if (email == null || email.isBlank()) {
            return null;
        }
        String emailRegex = "^[a-zA-Z][a-zA-Z0-9._-]{5,29}@gmail\\.com$";
        if (!email.matches(emailRegex)) {
            return "Email phai co dinh dang Gmail hop le (vi du: example@gmail.com, ex.am-ple@gmail.com).";
        }
        if (email.matches(".*[._-]{2,}.*")) {
            return "Email khong duoc chua dau cham, gach duoi hoac gach ngang lien nhau.";
        }
        String localPart = email.split("@")[0];
        if (localPart.endsWith(".") || localPart.endsWith("_") || localPart.endsWith("-")) {
            return "Email khong duoc bat dau hoac ket thuc bang dau cham, gach duoi, hoac gach ngang.";
        }
        return null;
    }

    private String validateVietnamPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return null;
        }
        phone = phone.trim();
        if (!phone.startsWith("0")) {
            return "So dien thoai phai bat dau bang so 0 (vi du: 0912345678).";
        }
        if (!phone.matches("\\d{10,11}")) {
            return "So dien thoai phai co 10 hoac 11 chu so (vi du: 0912345678).";
        }
        String prefix = phone.substring(1, 3);
        boolean validPrefix = false;
        switch (prefix) {
            case "32","33","34","35","36","37","38","39",
                 "52","53","54","55","56","57","58","59",
                 "70","71","72","76","77","78","79",
                 "81","82","83","84","85","86","87","88","89",
                 "90","91","92","93","94","95","96","97","98","99"
                 -> validPrefix = true;
        }
        if (!validPrefix) {
            return "So dien thoai co dau so khong hop le. Dau so phai thuoc: 03x, 05x, 07x, 08x, 09x.";
        }
        return null;
    }

    private void forwardFormWithErrors(HttpServletRequest request, HttpServletResponse response, User form,
                                      List<String> errors, boolean editMode)
            throws SQLException, ServletException, IOException {
        request.setAttribute("errors", errors);
        request.setAttribute("roles", roleDAO.findAll());
        request.setAttribute("userForm", form);
        request.setAttribute("editMode", editMode);
        String action = editMode
                ? request.getContextPath() + "/admin/users/edit?id=" + form.getUserId()
                : request.getContextPath() + "/admin/users/create";
        request.setAttribute("formAction", action);
        request.getRequestDispatcher("/jsp/admin/user-form.jsp").forward(request, response);
    }

    private Integer parseNullableInt(String raw) {
        String value = ServletUtils.safeTrim(raw);
        if (value.isEmpty()) {
            return null;
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private int parseRequiredId(HttpServletRequest request) {
        Integer id = parseNullableInt(request.getParameter("id"));
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("ID khong hop le.");
        }
        return id;
    }

    private void moveFlash(HttpServletRequest request) {
        Object flash = request.getSession().getAttribute("flash");
        if (flash != null) {
            request.setAttribute("flash", flash);
            request.getSession().removeAttribute("flash");
        }
    }
}
