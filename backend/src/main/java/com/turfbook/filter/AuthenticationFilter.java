package com.turfbook.filter;

import com.turfbook.util.DatabaseSeeder;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Set;

@WebFilter(urlPatterns = {"/user/*", "/api/*"})
public class AuthenticationFilter implements Filter {

    /**
     * Public API paths that do NOT require authentication.
     * Add any other read-only, guest-accessible endpoints here.
     */
    private static final Set<String> PUBLIC_API_PATHS = Set.of(
        "/api/badminton/availability"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialize DB seeder on startup
        try {
            DatabaseSeeder.seedIfEmpty();
        } catch (Exception e) {
            filterConfig.getServletContext().log("Database seeding failed: " + e.getMessage());
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpReq  = (HttpServletRequest) request;
        HttpServletResponse httpResp = (HttpServletResponse) response;

        // Allow public API paths without authentication
        String servletPath = httpReq.getServletPath();
        for (String publicPath : PUBLIC_API_PATHS) {
            if (servletPath.startsWith(publicPath)) {
                chain.doFilter(request, response);
                return;
            }
        }

        HttpSession session = httpReq.getSession(false);
        boolean loggedIn = (session != null && session.getAttribute("userId") != null);

        if (!loggedIn) {
            String contextPath = httpReq.getContextPath();
            httpResp.sendRedirect(contextPath + "/login.jsp?error=Please+login+to+continue.");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
