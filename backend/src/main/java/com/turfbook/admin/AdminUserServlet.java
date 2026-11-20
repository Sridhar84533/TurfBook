package com.turfbook.admin;

import com.turfbook.dao.UserDAO;
import com.turfbook.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminUserServlet.class.getName());
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<User> users = userDAO.findAll();
            req.setAttribute("users", users);
            req.getRequestDispatcher("/admin/users.jsp").forward(req, resp);
        } catch (Exception e) {
            LOGGER.severe("AdminUserServlet error: " + e.getMessage());
            req.setAttribute("error", "Unable to load users.");
            req.getRequestDispatcher("/admin/users.jsp").forward(req, resp);
        }
    }
}
