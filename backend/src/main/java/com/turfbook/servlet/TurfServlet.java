package com.turfbook.servlet;

import com.turfbook.model.Turf;
import com.turfbook.service.TurfService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/turfs")
public class TurfServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(TurfServlet.class.getName());
    private final TurfService turfService = new TurfService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String turfId = req.getParameter("id");

        try {
            if (turfId != null && !turfId.isEmpty()) {
                // Single turf details
                Turf turf = turfService.getTurfById(turfId);
                if (turf == null) {
                    req.setAttribute("error", "Turf not found.");
                    req.getRequestDispatcher("/user/explore.jsp").forward(req, resp);
                    return;
                }
                req.setAttribute("turf", turf);
                req.getRequestDispatcher("/user/turf-details.jsp").forward(req, resp);
            } else {
                // Explore all turfs with optional search/filter
                String search = req.getParameter("search");
                String type = req.getParameter("type");

                List<Turf> turfs;
                if (search != null && !search.trim().isEmpty()) {
                    turfs = turfService.searchTurfs(search.trim());
                } else if (type != null && !type.trim().isEmpty()) {
                    turfs = turfService.filterByType(type.trim());
                } else {
                    turfs = turfService.getAllActiveTurfs();
                }

                req.setAttribute("turfs", turfs);
                req.setAttribute("searchQuery", search);
                req.setAttribute("selectedType", type);
                req.getRequestDispatcher("/user/explore.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            LOGGER.severe("TurfServlet error: " + e.getMessage());
            req.setAttribute("error", "Unable to load turfs. Please try again.");
            req.getRequestDispatcher("/user/explore.jsp").forward(req, resp);
        }
    }
}
