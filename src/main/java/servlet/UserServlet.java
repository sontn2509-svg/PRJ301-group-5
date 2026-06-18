package servlet;

import dao.RoleDAO;
import dao.SystemLogDAO;
import dao.UserDAO;
import model.User;
import config.ServletUtils;
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

@WebServlet(urlPatterns = {
        "/admin/users",
        "/admin/users/create",
        "/admin/users/edit",
        "/admin/users/toggle"
})
public class UserServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final RoleDAO roleDAO = new RoleDAO();
    private final SystemLogDAO systemLogDAO = new SystemLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        try {
            switch (path) {
                case "/admin/users/create" -> showCreateForm(request, response);
                case "/admin/users/edit" -> showEditForm(request, response);
                case "/admin/users/toggle" -> toggleStatus(request, response);
                default -> showList(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Không thể xử lý người dùng", e);
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
            throw new ServletException("Không thể lưu người dùng", e);
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
        request.getRequestDispatcher("/jsp/auth/user-list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        request.setAttribute("formAction", request.getContextPath() + "/admin/users/create");
        request.setAttribute("roles", roleDAO.findAll());
        request.setAttribute("userForm", new User());
        request.getRequestDispatcher("/jsp/auth/user-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = parseRequiredId(request);
        Optional<User> user = userDAO.findById(id);
        if (user.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy tài khoản.");
            return;
        }
        request.setAttribute("formAction", request.getContextPath() + "/admin/users/edit?id=" + id);
        request.setAttribute("roles", roleDAO.findAll());
        request.setAttribute("userForm", user.get());
        request.setAttribute("editMode", true);
        request.getRequestDispatcher("/jsp/auth/user-form.jsp").forward(request, response);
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
                "Admin tạo tài khoản " + form.getUsername());
        request.getSession().setAttribute("flash", "Đã tạo tài khoản " + form.getUsername() + ".");
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = parseRequiredId(request);
        Optional<User> existing = userDAO.findById(id);
        if (existing.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy tài khoản.");
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
                "Admin cập nhật tài khoản " + form.getUsername());
        request.getSession().setAttribute("flash", "Đã cập nhật tài khoản " + form.getUsername() + ".");
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
                    "Admin đổi trạng thái tài khoản " + target.get().getUsername());
            request.getSession().setAttribute("flash", "Đã đổi trạng thái tài khoản " + target.get().getUsername() + ".");
        }
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
            errors.add("Tên đăng nhập không được để trống.");
        }
        if (createMode && userDAO.usernameExists(user.getUsername(), exceptUserId)) {
            errors.add("Tên đăng nhập đã tồn tại.");
        }
        if (createMode && user.getPassword().isBlank()) {
            errors.add("Mật khẩu không được để trống.");
        }
        if (user.getFullName().isBlank()) {
            errors.add("Họ tên không được để trống.");
        }
        if (user.getRoleId() <= 0) {
            errors.add("Vui lòng chọn vai trò.");
        }
        if (user.getStatus() < 0 || user.getStatus() > 2) {
            errors.add("Trạng thái tài khoản không hợp lệ.");
        }
        return errors;
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
        request.getRequestDispatcher("/jsp/auth/user-form.jsp").forward(request, response);
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
            throw new IllegalArgumentException("ID không hợp lệ.");
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

