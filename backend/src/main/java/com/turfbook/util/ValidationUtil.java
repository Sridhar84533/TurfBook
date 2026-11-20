package com.turfbook.util;

public class ValidationUtil {

    public static boolean isNotEmpty(String str) {
        return str != null && !str.trim().isEmpty();
    }

    public static boolean isValidEmail(String email) {
        if (!isNotEmpty(email)) return false;
        return email.trim().matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    }

    public static boolean isValidPhone(String phone) {
        if (!isNotEmpty(phone)) return false;
        String clean = phone.replaceAll("[\\s-]", "");
        return clean.matches("^[6-9]\\d{9}$");
    }

    public static boolean isValidPrice(double price) {
        return price > 0 && price <= 50000;
    }

    public static boolean isValidCapacity(int capacity) {
        return capacity > 0 && capacity <= 100;
    }

    public static boolean isValidLatitude(double lat) {
        return lat >= -90.0 && lat <= 90.0;
    }

    public static boolean isValidLongitude(double lng) {
        return lng >= -180.0 && lng <= 180.0;
    }

    public static boolean isValidPostalCode(String postalCode) {
        if (!isNotEmpty(postalCode)) return false;
        return postalCode.trim().matches("^\\d{5,6}$");
    }

    public static boolean isValidDate(String dateStr) {
        if (!isNotEmpty(dateStr)) return false;
        return dateStr.trim().matches("^\\d{4}-\\d{2}-\\d{2}$");
    }

    public static boolean isValidTime(String timeStr) {
        if (!isNotEmpty(timeStr)) return false;
        return timeStr.trim().matches("^([01]\\d|2[0-3]):[0-5]\\d$");
    }

    public static double parseDoubleOrDefault(String val, double defaultVal) {
        if (!isNotEmpty(val)) return defaultVal;
        try {
            return Double.parseDouble(val.trim());
        } catch (NumberFormatException e) {
            return defaultVal;
        }
    }

    public static int parseIntOrDefault(String val, int defaultVal) {
        if (!isNotEmpty(val)) return defaultVal;
        try {
            return Integer.parseInt(val.trim());
        } catch (NumberFormatException e) {
            return defaultVal;
        }
    }
}
