package com.turfbook.enums;

public enum BookingStatus {
    CONFIRMED,
    CANCELLED,
    COMPLETED,
    PENDING,
    EXPIRED;

    public static BookingStatus fromString(String statusStr) {
        if (statusStr == null) return CONFIRMED;
        try {
            return BookingStatus.valueOf(statusStr.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return CONFIRMED;
        }
    }
}
