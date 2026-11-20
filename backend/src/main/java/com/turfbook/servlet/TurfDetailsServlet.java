package com.turfbook.servlet;

import com.turfbook.model.Turf;
import com.turfbook.service.TurfService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.logging.Logger;

@WebServlet("/turf-details")
public class TurfDetailsServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(TurfDetailsServlet.class.getName());
    private final TurfService turfService = new TurfService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String turfId = req.getParameter("id");
        if (turfId == null || turfId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/turfs");
            return;
        }

        try {
            Turf turf = turfService.getTurfById(turfId.trim());
            if (turf == null) {
                req.setAttribute("error", "The requested turf was not found.");
                req.getRequestDispatcher("/user/explore.jsp").forward(req, resp);
                return;
            }

            req.setAttribute("turf", turf);
            req.getRequestDispatcher("/user/turf-details.jsp").forward(req, resp);
        } catch (Exception e) {
            LOGGER.severe("TurfDetailsServlet error: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/turfs");
        }
    }
}
