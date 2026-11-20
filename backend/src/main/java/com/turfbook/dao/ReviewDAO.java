package com.turfbook.dao;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.model.Filters;
import com.turfbook.model.Review;
import com.turfbook.util.MongoDBConnection;
import org.bson.Document;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Logger;

public class ReviewDAO {
    private static final Logger LOGGER = Logger.getLogger(ReviewDAO.class.getName());

    public boolean createReview(Review review) {
        try {
            MongoCollection<Document> col = MongoDBConnection.getReviewsCollection();
            Document doc = new Document()
                    .append("reviewId", review.getReviewId())
                    .append("userId", review.getUserId())
                    .append("turfId", review.getTurfId())
                    .append("bookingId", review.getBookingId())
                    .append("rating", review.getRating())
                    .append("comment", review.getComment())
                    .append("createdAt", review.getCreatedAt() != null ? review.getCreatedAt() : new Date());
            col.insertOne(doc);
            return true;
        } catch (Exception e) {
            LOGGER.severe("ReviewDAO.createReview failed: " + e.getMessage());
            return false;
        }
    }

    public List<Review> findByTurfId(String turfId) {
        List<Review> reviews = new ArrayList<>();
        try {
            for (Document doc : MongoDBConnection.getReviewsCollection()
                    .find(Filters.eq("turfId", turfId))) {
                Review r = docToReview(doc);
                if (r != null) reviews.add(r);
            }
        } catch (Exception e) {
            LOGGER.severe("ReviewDAO.findByTurfId failed: " + e.getMessage());
        }
        return reviews;
    }

    public List<Review> findAll() {
        List<Review> reviews = new ArrayList<>();
        try {
            for (Document doc : MongoDBConnection.getReviewsCollection().find()) {
                Review r = docToReview(doc);
                if (r != null) reviews.add(r);
            }
        } catch (Exception e) {
            LOGGER.severe("ReviewDAO.findAll failed: " + e.getMessage());
        }
        return reviews;
    }

    public double getAverageRatingForTurf(String turfId) {
        List<Review> reviews = findByTurfId(turfId);
        if (reviews.isEmpty()) return 0.0;
        return reviews.stream().mapToInt(Review::getRating).average().orElse(0.0);
    }

    public boolean deleteReview(String reviewId) {
        try {
            long count = MongoDBConnection.getReviewsCollection().deleteOne(Filters.eq("reviewId", reviewId)).getDeletedCount();
            return count > 0;
        } catch (Exception e) {
            LOGGER.severe("ReviewDAO.deleteReview failed: " + e.getMessage());
            return false;
        }
    }

    private Review docToReview(Document doc) {
        if (doc == null) return null;
        Review r = new Review();
        r.setReviewId(doc.getString("reviewId"));
        r.setUserId(doc.getString("userId"));
        r.setTurfId(doc.getString("turfId"));
        r.setBookingId(doc.getString("bookingId"));
        Integer rating = doc.getInteger("rating");
        if (rating != null) r.setRating(rating);
        r.setComment(doc.getString("comment"));
        r.setCreatedAt(doc.getDate("createdAt"));
        return r;
    }
}
