package config;

import model.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/*
  Tiện ích cho Servlet - lấy thông tin user hiện tại và xử lý chuỗi an toàn.
  - currentUser() trả về User từ session với key "authUser"
  - safeTrim() luôn trả về chuỗi rỗng nếu null hoặc chỉ có khoảng trắng
  - Class không thể khởi tạo (private constructor)
 */
public final class ServletUtils {

    private ServletUtils() {
    }

    /**
     * Lấy user hiện đang đăng nhập từ session.
     * @param request HttpServletRequest
     * @return User hoặc null nếu chưa đăng nhập
     */
    public static User currentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (User) session.getAttribute("authUser");
    }

    /**
     * Trim chuỗi an toàn, trả về "" nếu null.
     * @param value chuỗi cần trim
     * @return chuỗi đã trim hoặc ""
     */
    public static String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
