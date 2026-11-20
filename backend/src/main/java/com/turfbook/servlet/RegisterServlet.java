package com.turfbook.servlet;

import com.turfbook.exception.DatabaseException;
import com.turfbook.exception.InvalidUserException;
import com.turfbook.model.User;
import com.turfbook.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.logging.Logger;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(RegisterServlet.class.getName());
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        if (phone == null || phone.trim().isEmpty()) {
            phone = req.getParameter("mobile");
        }
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        if (username != null) username = username.trim();
        if (email != null) email = email.trim().toLowerCase();
        if (phone != null) phone = phone.replaceAll("[\\s-]", "");

        // Confirm password match
        if (password != null && !password.equals(confirmPassword)) {
            req.setAttribute("error", "Passwords do not match. Please try again.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        try {
            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setPhone(phone);

            User created = userService.registerUser(user, password);
            LOGGER.info("New user registered: " + created.getUsername());

            req.setAttribute("success", "Account created successfully! Please login to continue.");
            resp.sendRedirect(req.getContextPath() + "/login.jsp?success=Account+created+successfully+Please+login");

        } catch (InvalidUserException e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        } catch (DatabaseException e) {
            LOGGER.severe("Registration DB error: " + e.getMessage());
            req.setAttribute("error", "Unable to connect to the database. Please try again later.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}
