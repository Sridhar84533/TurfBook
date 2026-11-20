package com.turfbook.enums;

public enum UserRole {
    USER,
    ADMIN;

    public static UserRole fromString(String roleStr) {
        if (roleStr == null) return USER;
        try {
            return UserRole.valueOf(roleStr.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return USER;
        }
    }
}
