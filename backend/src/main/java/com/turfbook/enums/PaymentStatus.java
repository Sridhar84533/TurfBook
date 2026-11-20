package com.turfbook.enums;

public enum PaymentStatus {
    SUCCESS,
    FAILED,
    PENDING;

    public static PaymentStatus fromString(String statusStr) {
        if (statusStr == null) return PENDING;
        try {
            return PaymentStatus.valueOf(statusStr.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return PENDING;
        }
    }
}
