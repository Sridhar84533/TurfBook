package com.turfbook.enums;

public enum TurfStatus {
    ACTIVE,
    INACTIVE,
    MAINTENANCE;

    public static TurfStatus fromString(String statusStr) {
        if (statusStr == null) return ACTIVE;
        try {
            return TurfStatus.valueOf(statusStr.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return ACTIVE;
        }
    }
}
