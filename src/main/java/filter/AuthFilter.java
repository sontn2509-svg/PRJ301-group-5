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
                uri.equals(contextPath + "/login")
                || uri.equals(contextPath + "/forgot-password")
                || uri.startsWith(contextPath + "/assets/")
                || uri.startsWith(contextPath + "/favicon");

        if (publicResource) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = httpRequest.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("authUser");

        if (user == null) {
            httpResponse.sendRedirect(contextPath + "/login");
            return;
        }

        chain.doFilter(request, response);
    }
}
