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

import java.io.IOException;

/*
  Filter kiểm tra quyền Admin cho /admin/*.
  - Áp dụng cho tất cả URL bắt đầu bằng /admin/
  - Static resources (.css, .js, images...) được cho qua không kiểm tra
  - Yêu cầu: User phải đăng nhập VÀ có RoleName = "Admin"
  - Nếu không có quyền: trả về HTTP 403 Forbidden
  - CHẠY SAU AuthFilter (do thứ tự filter trong chain)
 */
@WebFilter("/admin/*")
public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        String uri = httpRequest.getRequestURI();

        if (uri.endsWith(".css") || uri.endsWith(".js") || uri.endsWith(".png")
                || uri.endsWith(".jpg") || uri.endsWith(".jpeg") || uri.endsWith(".svg")
                || uri.endsWith(".ico") || uri.endsWith(".woff") || uri.endsWith(".woff2")
                || uri.endsWith(".ttf")) {
            chain.doFilter(request, response);
            return;
        }

        User user = (User) httpRequest.getSession().getAttribute("authUser");

        if (user == null || !"Admin".equalsIgnoreCase(user.getRoleName())) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Bạn không có quyền truy cập chức năng Admin.");
            return;
        }

        chain.doFilter(request, response);
    }
}
