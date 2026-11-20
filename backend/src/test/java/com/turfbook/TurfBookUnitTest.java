package com.turfbook;

import com.turfbook.enums.BookingStatus;
import com.turfbook.enums.TurfStatus;
import com.turfbook.enums.TurfType;
import com.turfbook.model.Booking;
import com.turfbook.model.User;
import com.turfbook.util.PasswordUtil;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class TurfBookUnitTest {

    @Test
    @DisplayName("PasswordUtil: Hashing and BCrypt verification")
    public void testPasswordHashing() {
        String rawPassword = "Player@123";
        String hashed = PasswordUtil.hashPassword(rawPassword);

        assertNotNull(hashed, "Hashed password should not be null");
        assertNotEquals(rawPassword, hashed, "Hash must be different from plaintext");
        assertTrue(PasswordUtil.checkPassword(rawPassword, hashed), "Password verification must pass for correct plaintext");
        assertFalse(PasswordUtil.checkPassword("WrongPass@123", hashed), "Password verification must fail for wrong password");
    }

    @Test
    @DisplayName("User Model & ValidationUtil: Validations")
    public void testUserValidation() {
        // ValidationUtil email
        assertTrue(com.turfbook.util.ValidationUtil.isValidEmail("alex@example.com"));
        assertFalse(com.turfbook.util.ValidationUtil.isValidEmail("invalid-email"));

        // ValidationUtil phone (10 digits starting with 6-9)
        assertTrue(com.turfbook.util.ValidationUtil.isValidPhone("9876543210"));
        assertFalse(com.turfbook.util.ValidationUtil.isValidPhone("12345"));

        // User model instance validations
        User u = new User();
        u.setUsername("alex_striker");
        u.setEmail("alex@turfbook.in");
        u.setPhone("9876543210");
        assertTrue(u.isValidUsername());
        assertTrue(u.isValidEmail());
        assertTrue(u.isValidPhone());

        // Valid password (min 6, upper, lower, digit, special)
        assertTrue(User.isValidPassword("Admin@123"));
        assertFalse(User.isValidPassword("short"));
    }

    @Test
    @DisplayName("Turf Enum Parsing")
    public void testTurfEnums() {
        assertEquals(TurfType.FOOTBALL_7V7, TurfType.fromString("FOOTBALL_7V7"));
        assertEquals(TurfType.BOX_CRICKET, TurfType.fromString("box_cricket"));
        assertEquals(TurfType.MULTI_SPORT, TurfType.fromString("UNKNOWN"));

        assertEquals(TurfStatus.ACTIVE, TurfStatus.fromString("ACTIVE"));
        assertEquals(TurfStatus.INACTIVE, TurfStatus.fromString("inactive"));
    }

    @Test
    @DisplayName("Booking Model & Slot Integrity")
    public void testBookingModel() {
        String futureDate = java.time.LocalDate.now().plusDays(7).toString();
        Booking b = new Booking();
        b.setBookingId("BK-TEST01");
        b.setTurfId("TURF-001");
        b.setUserId("USER-001");
        b.setBookingDate(futureDate);
        b.setStartTime("19:00");
        b.setEndTime("20:00");
        b.setTotalAmount(1400.0);
        b.setStatus(BookingStatus.CONFIRMED);

        assertEquals("BK-TEST01", b.getBookingId());
        assertEquals("19:00", b.getStartTime());
        assertEquals("20:00", b.getEndTime());
        assertEquals(1400.0, b.getTotalAmount());
        assertEquals(BookingStatus.CONFIRMED, b.getStatus());
        assertFalse(b.isExpired(), "Future booking must not be expired");
    }

    @Test
    @DisplayName("Multiple Badminton Court Model & Pricing Calculation")
    public void testMultipleCourtBookingModel() {
        Booking b = new Booking();
        b.setBookingId("BK-MULTI01");
        b.setTurfId("TURF-BADMINTON");
        b.setUserId("USER-001");
        b.setBookingDate(java.time.LocalDate.now().plusDays(3).toString());
        b.setStartTime("18:00");
        b.setEndTime("19:00");
        
        // Multi-court assignment: Courts 1, 2, and 4
        java.util.List<Integer> courts = java.util.List.of(1, 2, 4);
        b.setAssignedCourts(courts);

        assertEquals(3, b.getCourtCount(), "Should have 3 courts assigned");
        assertEquals(1, b.getAssignedCourt(), "Primary court should be Court 1 for backward compatibility");
        assertEquals(java.util.List.of(1, 2, 4), b.getAssignedCourts(), "Assigned courts list must match");
        assertEquals("Courts #1, #2, #4", b.getCourtsDisplay());
        assertEquals("COURTS: #1, #2, #4", b.getCourtsBadgeText());

        // Calculation: 3 courts * 1.0 hour * 250 rs/hr = 750
        double ratePerHour = 250.0;
        double durationHours = 1.0;
        double totalAmount = b.getCourtCount() * durationHours * ratePerHour;
        b.setTotalAmount(totalAmount);
        assertEquals(750.0, b.getTotalAmount(), 0.001, "Total amount for 3 courts for 1 hr at 250/hr must be 750");
    }

    @Test
    @DisplayName("Booking Expiration Detection")
    public void testBookingExpiration() {
        String pastDate = java.time.LocalDate.now().minusDays(7).toString();
        Booking pastBooking = new Booking();
        pastBooking.setBookingId("BK-PAST01");
        pastBooking.setBookingDate(pastDate);
        pastBooking.setStartTime("10:00");
        pastBooking.setEndTime("11:00");
        pastBooking.setStatus(BookingStatus.CONFIRMED);

        assertTrue(pastBooking.isExpired(), "Past booking must evaluate as expired");
        assertEquals(BookingStatus.EXPIRED, pastBooking.getStatus(), "Status of past confirmed booking must resolve to EXPIRED");
    }

    @Test
    @DisplayName("Slot Overlap Detection Logic")
    public void testSlotOverlapAlgorithm() {
        // Slot A: 18:00 to 19:00 (1080 to 1140 min)
        int aStart = timeToMinutes("18:00");
        int aEnd = timeToMinutes("19:00");

        // Slot B overlapping: 18:30 to 19:30
        int bStart = timeToMinutes("18:30");
        int bEnd = timeToMinutes("19:30");
        assertTrue(aStart < bEnd && aEnd > bStart, "18:00-19:00 and 18:30-19:30 must overlap");

        // Slot C consecutive (non-overlapping): 19:00 to 20:00
        int cStart = timeToMinutes("19:00");
        int cEnd = timeToMinutes("20:00");
        assertFalse(aStart < cEnd && aEnd > cStart, "18:00-19:00 and 19:00-20:00 must NOT overlap");

        // Slot D before (non-overlapping): 16:00 to 17:00
        int dStart = timeToMinutes("16:00");
        int dEnd = timeToMinutes("17:00");
        assertFalse(aStart < dEnd && aEnd > dStart, "18:00-19:00 and 16:00-17:00 must NOT overlap");
    }

    private int timeToMinutes(String timeStr) {
        String[] parts = timeStr.trim().split(":");
        return Integer.parseInt(parts[0]) * 60 + Integer.parseInt(parts[1]);
    }
}
