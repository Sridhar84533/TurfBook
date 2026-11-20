package com.turfbook.enums;

public enum CheckInStatus {
    NOT_CHECKED_IN,
    CHECKED_IN;

    public static CheckInStatus fromString(String statusStr) {
        if (statusStr == null || statusStr.trim().isEmpty()) {
            return NOT_CHECKED_IN;
        }
        try {
            return CheckInStatus.valueOf(statusStr.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return NOT_CHECKED_IN;
        }
    }
}
