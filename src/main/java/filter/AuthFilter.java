package filter;

import model.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/*
  Filter kiểm tra đăng nhập cho tất cả request.
  - Áp dụng cho tất cả URL ("/*")
  - Cho phép truy cập: trang chủ (/), /login, /forgot-password, assets, css, js, images, fonts
  - Nếu chưa đăng nhập: chuyển hướng về trang chủ (ngoại trừ /login)
  - User đăng nhập được lưu trong session với key "authUser"
  - Chỉ kiểm tra đăng nhập, KHÔNG kiểm tra quyền Admin (dùng AdminFilter cho /admin/*)
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String contextPath = httpRequest.getContextPath();
        String uri = httpRequest.getRequestURI();

        boolean publicResource =
                uri.equals(contextPath + "/")
                || uri.equals(contextPath + "/login")
                || uri.equals(contextPath + "/forgot-password")
                || uri.startsWith(contextPath + "/assets/")
                || uri.startsWith(contextPath + "/css/")
                || uri.startsWith(contextPath + "/js/")
                || uri.startsWith(contextPath + "/fonts/")
                || uri.startsWith(contextPath + "/images/")
                || uri.startsWith(contextPath + "/img/")
                || uri.startsWith(contextPath + "/favicon")
                || uri.endsWith(".css")
                || uri.endsWith(".js")
                || uri.endsWith(".png")
                || uri.endsWith(".jpg")
                || uri.endsWith(".jpeg")
                || uri.endsWith(".gif")
                || uri.endsWith(".svg")
                || uri.endsWith(".ico")
                || uri.endsWith(".woff")
                || uri.endsWith(".woff2")
                || uri.endsWith(".ttf");

        if (publicResource) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = httpRequest.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("authUser");

        if (user == null) {
            // Nếu đang cố truy cập /login thì cho về login page
            if (uri.equals(contextPath + "/login")) {
                chain.doFilter(request, response);
            } else {
                httpResponse.sendRedirect(contextPath + "/");
            }
            return;
        }

        chain.doFilter(request, response);
    }
}
