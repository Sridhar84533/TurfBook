package com.turfbook.service;

import com.turfbook.dao.ReviewDAO;
import com.turfbook.model.Review;

import java.util.List;
import java.util.UUID;
import java.util.logging.Logger;

public class ReviewService {
    private static final Logger LOGGER = Logger.getLogger(ReviewService.class.getName());
    private final ReviewDAO reviewDAO = new ReviewDAO();

    public Review submitReview(String userId, String turfId, String bookingId, int rating, String comment) throws Exception {
        if (userId == null || userId.trim().isEmpty()) throw new Exception("User ID is required.");
        if (turfId == null || turfId.trim().isEmpty()) throw new Exception("Turf ID is required.");
        if (rating < 1 || rating > 5) throw new Exception("Rating must be between 1 and 5 stars.");
        if (comment == null || comment.trim().isEmpty()) throw new Exception("Comment cannot be empty.");
        if (comment.trim().length() > 500) throw new Exception("Comment cannot exceed 500 characters.");

        Review review = new Review();
        review.setReviewId("REV-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        review.setUserId(userId);
        review.setTurfId(turfId);
        review.setBookingId(bookingId != null ? bookingId.trim() : "");
        review.setRating(rating);
        review.setComment(comment.trim());

        boolean saved = reviewDAO.createReview(review);
        if (!saved) throw new Exception("Failed to submit review. Please try again.");
        LOGGER.info("Review " + review.getReviewId() + " submitted for turf " + turfId);
        return review;
    }

    public List<Review> getReviewsForTurf(String turfId) {
        return reviewDAO.findByTurfId(turfId);
    }

    public List<Review> getAllReviews() {
        return reviewDAO.findAll();
    }

    public double getAverageRating(String turfId) {
        return reviewDAO.getAverageRatingForTurf(turfId);
    }

    public boolean deleteReview(String reviewId) {
        return reviewDAO.deleteReview(reviewId);
    }
}
