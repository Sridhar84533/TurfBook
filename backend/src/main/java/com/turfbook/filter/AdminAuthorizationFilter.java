package com.turfbook.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*"})
public class AdminAuthorizationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpReq = (HttpServletRequest) request;
        HttpServletResponse httpResp = (HttpServletResponse) response;

        HttpSession session = httpReq.getSession(false);
        String contextPath = httpReq.getContextPath();

        // Not logged in at all — redirect to login
        if (session == null || session.getAttribute("userId") == null) {
            String token = httpReq.getParameter("token");
            if (token != null && !token.trim().isEmpty() && httpReq.getRequestURI().contains("/checkin")) {
                String redirectTarget = contextPath + "/admin/checkin?token=" + java.net.URLEncoder.encode(token, "UTF-8");
                httpResp.sendRedirect(contextPath + "/login.jsp?error=Admin+login+required+to+verify+gate+pass.&redirect=" + java.net.URLEncoder.encode(redirectTarget, "UTF-8"));
                return;
            }
            httpResp.sendRedirect(contextPath + "/login.jsp?error=Please+login+to+continue.");
            return;
        }

        // Logged in but not ADMIN — 403 Unauthorized
        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role)) {
            httpResp.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Access Denied. You do not have administrator privileges.");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}
