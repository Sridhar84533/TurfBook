package com.turfbook.admin;

import com.turfbook.model.Review;
import com.turfbook.service.ReviewService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/admin/reviews")
public class AdminReviewServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminReviewServlet.class.getName());
    private final ReviewService reviewService = new ReviewService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<Review> reviews = reviewService.getAllReviews();
            req.setAttribute("reviews", reviews);
            req.getRequestDispatcher("/admin/reviews.jsp").forward(req, resp);
        } catch (Exception e) {
            LOGGER.severe("AdminReviewServlet doGet error: " + e.getMessage());
            req.setAttribute("error", "Unable to load reviews.");
            req.getRequestDispatcher("/admin/reviews.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String reviewId = req.getParameter("reviewId");

        if ("delete".equalsIgnoreCase(action) && reviewId != null && !reviewId.trim().isEmpty()) {
            boolean deleted = reviewService.deleteReview(reviewId.trim());
            if (deleted) {
                req.getSession().setAttribute("success", "Review deleted successfully.");
            } else {
                req.getSession().setAttribute("error", "Failed to delete review.");
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/reviews");
    }
}
