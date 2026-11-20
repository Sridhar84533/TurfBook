package com.turfbook.servlet;

import com.turfbook.model.Review;
import com.turfbook.service.ReviewService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Logger;

@WebServlet("/user/review")
public class ReviewServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ReviewServlet.class.getName());
    private final ReviewService reviewService = new ReviewService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String userId = (String) session.getAttribute("userId");

        String turfId = req.getParameter("turfId");
        String bookingId = req.getParameter("bookingId");
        String ratingStr = req.getParameter("rating");
        String comment = req.getParameter("comment");

        try {
            int rating = Integer.parseInt(ratingStr != null ? ratingStr.trim() : "5");
            Review review = reviewService.submitReview(userId, turfId, bookingId, rating, comment);
            LOGGER.info("Review submitted: " + review.getReviewId());
            resp.sendRedirect(req.getContextPath() + "/user/booking?action=my-bookings&success=Review+submitted+successfully");
        } catch (Exception e) {
            LOGGER.severe("ReviewServlet error: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/user/booking?action=my-bookings&error=" +
                    java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }
}
