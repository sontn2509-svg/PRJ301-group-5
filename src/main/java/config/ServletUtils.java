package config;

import model.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public final class ServletUtils {

    private ServletUtils() {
    }

    public static User currentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (User) session.getAttribute("authUser");
    }

    public static String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
