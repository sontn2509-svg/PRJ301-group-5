package servlet;

import config.ServletUtils;
import dao.SystemLogDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/*
 Xử lý đăng nhập, đăng xuất, quên mật khẩu và trang chủ.
  - Admin sau khi đăng nhập → chuyển đến /admin/dashboard
  - Role khác sau khi đăng nhập → hiển thị trang chờ
  - Quên mật khẩu: Bước 1 xác minh (username + email + phone), Bước 2 đặt lại mật khẩu
  - Session lưu user với key "authUser"
  - Mật khẩu lưu plain text (chưa mã hóa)
 */
@WebServlet(urlPatterns = {"/", "/login", "/logout", "/forgot-password"})
public class AuthServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final SystemLogDAO systemLogDAO = new SystemLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        switch (path) {
            case "/" -> showHome(request, response);
            case "/logout" -> logout(request, response);
            case "/forgot-password" -> showForgotPassword(request, response);
            default -> showLogin(request, response);
        }
    }

    private void showHome(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = ServletUtils.currentUser(request);

        if (currentUser != null) {
            String role = currentUser.getRoleName();
            if ("Admin".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else if ("Manager".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/manager/dashboard");
            } else if ("KitchenStaff".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/kitchen");
            } else if ("Teacher".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/teacher/dashboard");
            } else if ("Parent".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/parent/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
            return;
        }

        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String path = request.getServletPath();
        if ("/forgot-password".equals(path)) {
            handleForgotPassword(request, response);
        } else {
            login(request, response);
        }
    }

    private void showForgotPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String step = request.getParameter("step");
        HttpSession session = request.getSession(false);

        if ("2".equals(step) && session != null
                && session.getAttribute("resetUserId") != null) {
            request.setAttribute("userId", session.getAttribute("resetUserId"));
            request.setAttribute("verifiedUsername", session.getAttribute("resetUsername"));
            request.getRequestDispatcher("/jsp/auth/reset-password-form.jsp").forward(request, response);
            return;
        }

        request.getRequestDispatcher("/jsp/auth/forgot-password.jsp").forward(request, response);
    }

    private void showLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = ServletUtils.currentUser(request);

        if (currentUser != null) {
            String role = currentUser.getRoleName();
            if ("Admin".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else if ("Manager".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/manager/dashboard");
            } else if ("KitchenStaff".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/kitchen");
            } else if ("Teacher".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/teacher/dashboard");
            } else if ("Parent".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/parent/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
            return;
        }

        request.getRequestDispatcher("/jsp/auth/login.jsp").forward(request, response);
    }

    private void login(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = ServletUtils.safeTrim(request.getParameter("username"));
        String password = ServletUtils.safeTrim(request.getParameter("password"));

        try {
            Optional<User> authenticated = userDAO.authenticate(username, password);

            if (authenticated.isEmpty()) {
                request.setAttribute("error", "Sai tên đăng nhập, mật khẩu hoặc tài khoản đã bị khóa.");
                request.setAttribute("username", username);
                request.getRequestDispatcher("/jsp/auth/login.jsp").forward(request, response);
                return;
            }

            User user = authenticated.get();
            
            // DEBUG
            System.out.println("=== LOGIN DEBUG ===");
            System.out.println("Username: " + user.getUsername());
            System.out.println("RoleID: " + user.getRoleId());
            System.out.println("RoleName: '" + user.getRoleName() + "'");
            
            request.getSession(true).setAttribute("authUser", user);
            systemLogDAO.create(user.getUserId(), "LOGIN", "Users", user.getUserId(),
                    "Người dùng " + user.getUsername() + " đăng nhập hệ thống");

            if ("Admin".equalsIgnoreCase(user.getRoleName())) {
                String redirectUrl = request.getContextPath() + "/admin";
                System.out.println("=== LOGIN REDIRECT ===");
                System.out.println("Redirecting Admin to: " + redirectUrl);
                response.sendRedirect(redirectUrl);
            } else if ("Manager".equalsIgnoreCase(user.getRoleName())) {
                String redirectUrl = request.getContextPath() + "/manager";
                System.out.println("=== LOGIN REDIRECT ===");
                System.out.println("Redirecting Manager to: " + redirectUrl);
                response.sendRedirect(redirectUrl);
            } else if ("KitchenStaff".equalsIgnoreCase(user.getRoleName())) {
                String redirectUrl = request.getContextPath() + "/kitchen";
                System.out.println("=== LOGIN REDIRECT ===");
                System.out.println("Redirecting Kitchen to: " + redirectUrl);
                response.sendRedirect(redirectUrl);
            } else if ("Teacher".equalsIgnoreCase(user.getRoleName())) {
                String redirectUrl = request.getContextPath() + "/teacher";
                System.out.println("=== LOGIN REDIRECT ===");
                System.out.println("Redirecting Teacher to: " + redirectUrl);
                response.sendRedirect(redirectUrl);
            } else if ("Parent".equalsIgnoreCase(user.getRoleName())) {
                String redirectUrl = request.getContextPath() + "/parent";
                System.out.println("=== LOGIN REDIRECT ===");
                System.out.println("Redirecting Parent to: " + redirectUrl);
                response.sendRedirect(redirectUrl);
            } else {
                request.setAttribute("message", "Đăng nhập thành công. Module của role " + user.getRoleName()
                        + " sẽ do thành viên khác triển khai.");
                request.getRequestDispatcher("/jsp/auth/role-waiting.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Không thể đăng nhập", e);
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        User user = ServletUtils.currentUser(request);
        if (user != null) {
            try {
                systemLogDAO.create(user.getUserId(), "LOGOUT", "Users", user.getUserId(),
                        "Người dùng " + user.getUsername() + " đăng xuất");
            } catch (SQLException e) {
                throw new ServletException("Không thể ghi log đăng xuất", e);
            }
        }

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        response.sendRedirect(request.getContextPath() + "/");
    }

    private void handleForgotPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String verified = ServletUtils.safeTrim(request.getParameter("verified"));

        if ("true".equals(verified)) {
            resetPasswordStep2(request, response);
        } else {
            resetPasswordStep1(request, response);
        }
    }

    private void resetPasswordStep1(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = ServletUtils.safeTrim(request.getParameter("username"));
        String email = ServletUtils.safeTrim(request.getParameter("email"));
        String phone = ServletUtils.safeTrim(request.getParameter("phone"));

        request.setAttribute("username", username);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);

        List<String> errors = validateAccountInfo(username, email, phone);
        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.getRequestDispatcher("/jsp/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        try {
            Optional<User> user = userDAO.findForPasswordReset(username, email, phone);
            if (user.isEmpty()) {
                request.setAttribute("errors", List.of("Thông tin xác minh không khớp hoặc tài khoản đã bị khóa."));
                request.getRequestDispatcher("/jsp/auth/forgot-password.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession(true);
            session.setAttribute("resetUserId", user.get().getUserId());
            session.setAttribute("resetUsername", user.get().getUsername());

            response.sendRedirect(request.getContextPath() + "/forgot-password?step=2");

        } catch (SQLException e) {
            throw new ServletException("Không thể xác minh tài khoản", e);
        }
    }

    private void resetPasswordStep2(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("resetUserId") == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        Integer userId = (Integer) session.getAttribute("resetUserId");
        String username = (String) session.getAttribute("resetUsername");

        String newPassword = ServletUtils.safeTrim(request.getParameter("newPassword"));
        String confirmPassword = ServletUtils.safeTrim(request.getParameter("confirmPassword"));

        List<String> errors = validateNewPassword(newPassword, confirmPassword);
        if (!errors.isEmpty()) {
            request.setAttribute("userId", userId);
            request.setAttribute("verifiedUsername", username);
            request.setAttribute("errors", errors);
            request.getRequestDispatcher("/jsp/auth/reset-password-form.jsp").forward(request, response);
            return;
        }

        try {
            userDAO.resetPassword(userId, newPassword);
            systemLogDAO.create(userId, "RESET_PASSWORD", "Users", userId,
                    "Người dùng " + username + " lấy lại mật khẩu");

            session.removeAttribute("resetUserId");
            session.removeAttribute("resetUsername");

            request.setAttribute("success", "Đổi mật khẩu thành công. Bạn có thể đăng nhập bằng mật khẩu mới.");
            request.getRequestDispatcher("/jsp/auth/forgot-password.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Không thể lưu mật khẩu mới", e);
        }
    }

    private List<String> validateAccountInfo(String username, String email, String phone) {
        List<String> errors = new ArrayList<>();

        if (username.isBlank()) {
            errors.add("Tên đăng nhập không được để trống.");
        }
        if (email.isBlank()) {
            errors.add("Email không được để trống.");
        }
        String emailError = validateEmail(email);
        if (emailError != null) {
            errors.add(emailError);
        }
        if (phone.isBlank()) {
            errors.add("Số điện thoại không được để trống.");
        }
        String phoneError = validateVietnamPhone(phone);
        if (phoneError != null) {
            errors.add(phoneError);
        }
        return errors;
    }

    private List<String> validateNewPassword(String newPassword, String confirmPassword) {
        List<String> errors = new ArrayList<>();
        if (newPassword.length() < 6) {
            errors.add("Mật khẩu mới phải có ít nhất 6 ký tự.");
        }
        if (!newPassword.equals(confirmPassword)) {
            errors.add("Xác nhận mật khẩu không khớp.");
        }
        return errors;
    }

    private String validateEmail(String email) {
        if (email == null || email.isBlank()) {
            return null;
        }
        String emailRegex = "^[a-zA-Z][a-zA-Z0-9._-]{5,29}@gmail\\.com$";
        if (!email.matches(emailRegex)) {
            return "Email phải có định dạng Gmail hợp lệ (ví dụ: example@gmail.com, ex.am-ple@gmail.com).";
        }
        if (email.matches(".*[._-]{2,}.*")) {
            return "Email không được chứa dấu chấm, gạch dưới hoặc gạch ngang liền nhau.";
        }
        String localPart = email.split("@")[0];
        if (localPart.endsWith(".") || localPart.endsWith("_") || localPart.endsWith("-")) {
            return "Email không được bắt đầu hoặc kết thúc bằng dấu chấm, gạch dưới, hoặc gạch ngang.";
        }
        return null;
    }

    private String validateVietnamPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return null;
        }
        phone = phone.trim();
        if (!phone.startsWith("0")) {
            return "Số điện thoại phải bắt đầu bằng số 0 (ví dụ: 0912345678).";
        }
        if (!phone.matches("\\d{10,11}")) {
            return "Số điện thoại phải có 10 hoặc 11 chữ số (ví dụ: 0912345678).";
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
            return "Số điện thoại có đầu số không hợp lệ. Đầu số phải thuộc: 03x, 05x, 07x, 08x, 09x.";
        }
        return null;
    }
}
