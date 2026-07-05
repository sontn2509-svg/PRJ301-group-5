package com.mycompany.kindergartenkitchen.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * ===================================================================== CHỈ
 * DÙNG KHI DEVELOPMENT / TEST — XOÁ TRƯỚC KHI NỘP BÀI
 * ===================================================================== Filter
 * này giả lập session đăng nhập để test các trang P4 mà không cần merge với
 * code Auth của P1.
 *
 * CÁCH BẬT / TẮT: - Test không cần login → để nguyên BYPASS_ENABLED = true -
 * Tích hợp với P1 xong → đổi BYPASS_ENABLED = false (hoặc xoá file này luôn)
 *
 * URL áp dụng: /ingredient/*, /ingredient-import/*, /ingredient-usage/*,
 * /notification/*
 * =====================================================================
 */
@WebFilter(urlPatterns = {
    "/ingredient/*",
    "/ingredient-import/*",
    "/ingredient-usage/*",
    "/notification/*"
})
public class DevBypassFilter implements Filter {

    // ══════════════════════════════════════════════
    // ĐỔI DÒNG NÀY ĐỂ BẬT / TẮT BYPASS
    private static final boolean BYPASS_ENABLED = true;
    // ══════════════════════════════════════════════

    /* Thông tin user giả — khớp với cấu trúc session mà P1 dùng */
    private static final int FAKE_USER_ID = 2;
    private static final String FAKE_USERNAME = "dev_p4_test";
    private static final String FAKE_FULL_NAME = "P4 Test User";
    private static final String FAKE_ROLE = "MANAGER"; // đổi tuỳ trang cần test

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        if (BYPASS_ENABLED) {
            System.out.println("[DevBypassFilter] ⚠ BYPASS AUTH đang BẬT — chỉ dùng khi dev!");
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        if (!BYPASS_ENABLED) {
            chain.doFilter(request, response);
            return;
        }

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        jakarta.servlet.http.HttpServletResponse httpResponse = (jakarta.servlet.http.HttpServletResponse) response;
        HttpSession session = httpRequest.getSession();

        /* 1. Mỗi lần F5 hoặc vào trang, ép filter lấy đúng Role đang cấu hình ở trên đầu file */
        session.setAttribute("userId", FAKE_USER_ID);
        session.setAttribute("username", FAKE_USERNAME);
        session.setAttribute("fullName", FAKE_FULL_NAME);
        session.setAttribute("role", FAKE_ROLE);

        /* 2. LOGIC KIỂM TRA QUYỀN GIẢ LẬP: Nếu phát hiện role là Parent -> Chặn đứng luôn */
//        if ("Parent".equals(FAKE_ROLE)) {
//            // Trả về lỗi 403 Forbidden để xem giao diện trình duyệt báo lỗi thế nào
//            httpResponse.sendError(jakarta.servlet.http.HttpServletResponse.SC_FORBIDDEN,
//                    "Lỗi phân quyền: Phụ huynh không được phép vào trang quản lý kho bếp!");
//            return; // Dừng lại ở đây, không cho đi tiếp vào Servlet/JSP của bạn nữa
//        }

        // Nếu là KitchenStaff hoặc Manager -> Cho phép đi tiếp bình thường
        chain.doFilter(request, response);
    }
}
