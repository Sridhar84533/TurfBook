package com.turfbook.model;

import java.util.Date;

public class Review {
    private String reviewId;
    private String userId;
    private String turfId;
    private String bookingId;
    private int rating; // 1 to 5
    private String comment;
    private Date createdAt;

    // View helper fields
    private String userName;
    private String turfName;

    public Review() {
        this.rating = 5;
        this.createdAt = new Date();
    }

    public Review(String reviewId, String userId, String turfId, String bookingId, int rating, String comment) {
        this.reviewId = reviewId;
        this.userId = userId;
        this.turfId = turfId;
        this.bookingId = bookingId;
        this.rating = rating;
        this.comment = comment != null ? comment.trim() : "";
        this.createdAt = new Date();
    }

    public String getReviewId() {
        return reviewId;
    }

    public void setReviewId(String reviewId) {
        this.reviewId = reviewId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getTurfId() {
        return turfId;
    }

    public void setTurfId(String turfId) {
        this.turfId = turfId;
    }

    public String getBookingId() {
        return bookingId;
    }

    public void setBookingId(String bookingId) {
        this.bookingId = bookingId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = Math.max(1, Math.min(5, rating));
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment != null ? comment.trim() : "";
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getTurfName() {
        return turfName;
    }

    public void setTurfName(String turfName) {
        this.turfName = turfName;
    }

    @Override
    public String toString() {
        return "Review{" +
                "reviewId='" + reviewId + '\'' +
                ", userId='" + userId + '\'' +
                ", turfId='" + turfId + '\'' +
                ", rating=" + rating +
                ", comment='" + comment + '\'' +
                '}';
    }
}
