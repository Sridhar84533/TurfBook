package com.turfbook.servlet;

import com.turfbook.exception.AuthenticationException;
import com.turfbook.exception.DatabaseException;
import com.turfbook.model.User;
import com.turfbook.service.UserService;
import com.turfbook.util.DatabaseSeeder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Logger;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());
    private final UserService userService = new UserService();

    @Override
    public void init() throws ServletException {
        try {
            DatabaseSeeder.seedIfEmpty();
        } catch (Exception e) {
            LOGGER.warning("Seeder init warning: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // If already logged in, redirect appropriately
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            String role = (String) session.getAttribute("role");
            if ("ADMIN".equals(role)) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/user/dashboard.jsp");
            }
            return;
        }
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String usernameOrEmail = req.getParameter("usernameOrEmail");
        if (usernameOrEmail == null || usernameOrEmail.trim().isEmpty()) {
            usernameOrEmail = req.getParameter("identity");
        }
        if (usernameOrEmail == null || usernameOrEmail.trim().isEmpty()) {
            usernameOrEmail = req.getParameter("username");
        }
        if (usernameOrEmail == null || usernameOrEmail.trim().isEmpty()) {
            usernameOrEmail = req.getParameter("email");
        }
        String password = req.getParameter("password");

        if (usernameOrEmail != null) usernameOrEmail = usernameOrEmail.trim();
        if (password != null) password = password.trim();

        try {
            User user = userService.authenticateUser(usernameOrEmail, password);

            // Create new session and store user info
            HttpSession session = req.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("email", user.getEmail());
            session.setAttribute("role", user.getRole().name());

            LOGGER.info("User logged in: " + user.getUsername() + " | Role: " + user.getRole());

            // Role-based redirect
            String redirectUrl = req.getParameter("redirect");
            if (redirectUrl != null && !redirectUrl.trim().isEmpty() && redirectUrl.startsWith(req.getContextPath())) {
                if ("ADMIN".equals(user.getRole().name())) {
                    resp.sendRedirect(redirectUrl);
                    return;
                }
            }

            if (user.getRole().name().equals("ADMIN")) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/user/dashboard.jsp");
            }

        } catch (AuthenticationException e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        } catch (DatabaseException e) {
            LOGGER.severe("Login DB error: " + e.getMessage());
            req.setAttribute("error", "Unable to connect to the database. Please try again later.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}
