package com.mycompany.kindergartenkitchen.util;

import com.mycompany.kindergartenkitchen.entity.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/*
  Tien ich cho Controller - lay thong tin user hien tai va xu ly chuoi an toan.
  - currentUser() tra ve User tu session voi key "authUser"
  - safeTrim() luon tra ve chuoi rong neu null hoac chi co khoang trang
  - Class khong the khoi tao (private constructor)
 */
public final class ServletUtils {

    private ServletUtils() {
    }

    /**
     * Lay user hien dang dang nhap tu session.
     * @param request HttpServletRequest
     * @return User hoac null neu chua dang nhap
     */
    public static User currentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (User) session.getAttribute("authUser");
    }

    /**
     * Trim chuoi an toan, tra ve "" neu null.
     * @param value chuoi can trim
     * @return chuoi da trim hoac ""
     */
    public static String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
