package com.turfbook.service;

import com.turfbook.dao.BookingDAO;
import com.turfbook.dao.NotificationDAO;
import com.turfbook.dao.TurfDAO;
import com.turfbook.dao.UserDAO;
import com.turfbook.enums.BookingStatus;
import com.turfbook.enums.CheckInStatus;
import com.turfbook.exception.InvalidBookingException;
import com.turfbook.exception.TurfNotAvailableException;
import com.turfbook.model.Booking;
import com.turfbook.model.CheckInResult;
import com.turfbook.model.Notification;
import com.turfbook.model.Turf;
import com.turfbook.model.User;
import com.turfbook.util.CheckInConfig;
import com.turfbook.util.QRCodeUtil;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class BookingService {
    private static final Logger LOGGER = Logger.getLogger(BookingService.class.getName());
    private final BookingDAO bookingDAO = new BookingDAO();
    private final TurfDAO turfDAO = new TurfDAO();
    private final UserDAO userDAO = new UserDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();

    public Booking createBooking(String userId, String turfId, String bookingDate, String startTime, String endTime)
            throws InvalidBookingException, TurfNotAvailableException, Exception {

        // Validate fields
        if (userId == null || userId.trim().isEmpty()) throw new InvalidBookingException("User ID is required.");
        if (turfId == null || turfId.trim().isEmpty()) throw new InvalidBookingException("Turf ID is required.");
        if (bookingDate == null || !bookingDate.matches("\\d{4}-\\d{2}-\\d{2}")) {
            throw new InvalidBookingException("Booking date must be in YYYY-MM-DD format.");
        }
        if (startTime == null || !startTime.matches("([01]\\d|2[0-3]):[0-5]\\d")) {
            throw new InvalidBookingException("Start time must be in HH:mm format.");
        }
        if (endTime == null || !endTime.matches("([01]\\d|2[0-3]):[0-5]\\d")) {
            throw new InvalidBookingException("End time must be in HH:mm format.");
        }

        int startMinutes = timeToMinutes(startTime);
        int endMinutes = timeToMinutes(endTime);

        if (endMinutes <= startMinutes) {
            throw new InvalidBookingException("End time must be after start time.");
        }

        // Check turf availability
        Turf turf = turfDAO.findById(turfId);
        if (turf == null) throw new InvalidBookingException("The selected turf does not exist.");
        if (turf.getStatus() != com.turfbook.enums.TurfStatus.ACTIVE) {
            throw new TurfNotAvailableException("The selected turf is currently not available for booking.");
        }

        // Overlap detection — server-side authority
        // For BADMINTON: overlapping means same slot AND same court — handled via court assignment below.
        // For other turfs: traditional overlap check.
        boolean isBadminton = turf.isBadminton();
        if (!isBadminton && bookingDAO.hasOverlappingBooking(turfId, bookingDate, startTime, endTime)) {
            throw new TurfNotAvailableException(
                "The time slot " + startTime + " - " + endTime + " on " + bookingDate +
                " is already booked. Please select a different time slot."
            );
        }

        // Calculate duration and total amount on SERVER — never trust client-side
        double durationHours = (endMinutes - startMinutes) / 60.0;
        double totalAmount = Math.round(durationHours * turf.getPricePerHour() * 100.0) / 100.0;

        Booking booking = new Booking();
        booking.setBookingId("BK-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        booking.setUserId(userId);
        booking.setTurfId(turfId);
        booking.setBookingDate(bookingDate);
        booking.setStartTime(startTime);
        booking.setEndTime(endTime);
        booking.setDuration(durationHours);
        booking.setTotalAmount(totalAmount);
        booking.setStatus(BookingStatus.CONFIRMED);
        booking.setTurfType(turf.getTurfType().name());

        // For BADMINTON: assign an available court atomically
        if (isBadminton) {
            int courtCount = turf.getCourtCount() > 0 ? turf.getCourtCount() : 4;
            // Find courts already booked in this slot
            Set<Integer> bookedCourts = bookingDAO.findBookedCourtsForSlot(turfId, bookingDate, startTime, endTime);
            int assignedCourt = -1;
            for (int c = 1; c <= courtCount; c++) {
                if (!bookedCourts.contains(c)) { assignedCourt = c; break; }
            }
            if (assignedCourt == -1) {
                throw new TurfNotAvailableException(
                    "All " + courtCount + " courts are fully booked for " + startTime +
                    " - " + endTime + " on " + bookingDate + ". Please choose another slot."
                );
            }
            booking.setAssignedCourt(assignedCourt);
        }

        // Generate enterprise secure QR check-in token
        booking.setQrToken(QRCodeUtil.generateSecureToken());
        booking.setQrGeneratedAt(new Date());
        booking.setCheckInStatus(CheckInStatus.NOT_CHECKED_IN);

        boolean created = bookingDAO.createBooking(booking);
        if (!created) throw new Exception("Failed to save booking. Please try again.");

        return booking;
    }

    /**
     * Creates a badminton booking for a SPECIFIC single court (backward compatibility).
     */
    public Booking createBookingWithCourt(String userId, String turfId, String bookingDate,
                                          String startTime, String endTime, int requestedCourt)
            throws InvalidBookingException, TurfNotAvailableException, Exception {
        return createBookingWithCourts(userId, turfId, bookingDate, startTime, endTime, Collections.singletonList(requestedCourt));
    }

    /**
     * Creates a badminton booking for ONE OR MULTIPLE courts chosen by the user in a single transaction.
     * Validates that all requested courts are still available atomically.
     * Total amount is calculated on server: Number of Courts * Duration in Hours * Rate Per Court.
     * If even one selected court is unavailable, rejects the entire booking without partial saves.
     */
    public Booking createBookingWithCourts(String userId, String turfId, String bookingDate,
                                           String startTime, String endTime, List<Integer> requestedCourts)
            throws InvalidBookingException, TurfNotAvailableException, Exception {

        // Validate inputs
        if (userId == null || userId.trim().isEmpty()) throw new InvalidBookingException("User ID is required.");
        if (turfId == null || turfId.trim().isEmpty())  throw new InvalidBookingException("Turf ID is required.");
        if (bookingDate == null || !bookingDate.matches("\\d{4}-\\d{2}-\\d{2}")) {
            throw new InvalidBookingException("Booking date must be in YYYY-MM-DD format.");
        }
        if (startTime == null || !startTime.matches("([01]\\d|2[0-3]):[0-5]\\d")) {
            throw new InvalidBookingException("Start time must be in HH:mm format.");
        }
        if (endTime == null || !endTime.matches("([01]\\d|2[0-3]):[0-5]\\d")) {
            throw new InvalidBookingException("End time must be in HH:mm format.");
        }
        if (requestedCourts == null || requestedCourts.isEmpty()) {
            throw new InvalidBookingException("Please select at least one court.");
        }

        // Deduplicate and sanitize court list
        Set<Integer> uniqueCourts = new LinkedHashSet<>(requestedCourts);
        List<Integer> cleanCourts = new ArrayList<>(uniqueCourts);
        Collections.sort(cleanCourts);

        for (int court : cleanCourts) {
            if (court <= 0) throw new InvalidBookingException("Invalid court number: " + court);
        }

        int startMinutes = timeToMinutes(startTime);
        int endMinutes   = timeToMinutes(endTime);
        if (endMinutes <= startMinutes) throw new InvalidBookingException("End time must be after start time.");

        // Verify turf
        Turf turf = turfDAO.findById(turfId);
        if (turf == null) throw new InvalidBookingException("The selected turf does not exist.");
        if (turf.getStatus() != com.turfbook.enums.TurfStatus.ACTIVE) {
            throw new TurfNotAvailableException("The selected turf is currently not available for booking.");
        }
        if (!turf.isBadminton()) {
            throw new InvalidBookingException("Court selection is only available for Badminton turfs.");
        }

        int courtCount = turf.getCourtCount() > 0 ? turf.getCourtCount() : 4;
        for (int court : cleanCourts) {
            if (court > courtCount) {
                throw new InvalidBookingException("Court " + court + " does not exist. This turf has " + courtCount + " courts.");
            }
        }

        // Concurrency synchronization per slot to prevent race-condition double-booking
        String lockKey = (turfId + "_" + bookingDate + "_" + startTime).intern();
        synchronized (lockKey) {
            // ATOMIC availability check — find all already-booked courts in overlapping slot
            Set<Integer> bookedCourts = bookingDAO.findBookedCourtsForSlot(turfId, bookingDate, startTime, endTime);

            List<Integer> unavailable = new ArrayList<>();
            for (int court : cleanCourts) {
                if (bookedCourts.contains(court)) {
                    unavailable.add(court);
                }
            }

            if (!unavailable.isEmpty()) {
                StringBuilder msg = new StringBuilder();
                if (unavailable.size() == 1) {
                    msg.append("Court ").append(unavailable.get(0)).append(" is already booked");
                } else {
                    msg.append("Courts ");
                    for (int i = 0; i < unavailable.size(); i++) {
                        if (i > 0) msg.append(", ");
                        msg.append(unavailable.get(i));
                    }
                    msg.append(" are already booked");
                }
                msg.append(" for ").append(startTime).append(" – ").append(endTime)
                   .append(" on ").append(bookingDate).append(". Please choose available courts.");
                throw new TurfNotAvailableException(msg.toString());
            }

            // Server-side price calculation:
            // Total Amount = Number of Selected Courts * Rate Per Court * Booking Duration in Hours
            double durationHours = (endMinutes - startMinutes) / 60.0;
            double ratePerHour = turf.getPricePerHour();
            double totalAmount = Math.round(cleanCourts.size() * durationHours * ratePerHour * 100.0) / 100.0;

            Booking booking = new Booking();
            booking.setBookingId("BK-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            booking.setUserId(userId);
            booking.setTurfId(turfId);
            booking.setBookingDate(bookingDate);
            booking.setStartTime(startTime);
            booking.setEndTime(endTime);
            booking.setDuration(durationHours);
            booking.setTotalAmount(totalAmount);
            booking.setStatus(com.turfbook.enums.BookingStatus.CONFIRMED);
            booking.setTurfType(turf.getTurfType().name());
            booking.setAssignedCourts(cleanCourts);
            booking.setAssignedCourt(cleanCourts.get(0));

            // Generate QR token
            booking.setQrToken(QRCodeUtil.generateSecureToken());
            booking.setQrGeneratedAt(new Date());
            booking.setCheckInStatus(com.turfbook.enums.CheckInStatus.NOT_CHECKED_IN);

            boolean created = bookingDAO.createBooking(booking);
            if (!created) throw new Exception("Failed to save booking. Please try again.");

            LOGGER.log(Level.INFO, "BookingService: Created multi-court booking {0} with {1} courts: {2}", new Object[]{booking.getBookingId(), cleanCourts.size(), cleanCourts});
            return booking;
        }
    }

    public List<Booking> getUserBookings(String userId) {
        return bookingDAO.findByUserId(userId);
    }

    public Booking getBookingById(String bookingId) {
        Booking b = bookingDAO.findById(bookingId);
        if (b != null && (b.getQrToken() == null || b.getQrToken().trim().isEmpty())) {
            // Self-heal legacy bookings by provisioning a secure QR token
            String token = QRCodeUtil.generateSecureToken();
            Date now = new Date();
            bookingDAO.updateQrToken(b.getBookingId(), token, now);
            b.setQrToken(token);
            b.setQrGeneratedAt(now);
            b.setCheckInStatus(CheckInStatus.NOT_CHECKED_IN);
        }
        return b;
    }

    public Booking getBookingByQrToken(String qrToken) {
        return bookingDAO.findByQrToken(qrToken);
    }

    public List<Booking> getAllBookings() {
        return bookingDAO.findAll();
    }

    public boolean cancelBooking(String bookingId) {
        return bookingDAO.updateStatus(bookingId, BookingStatus.CANCELLED);
    }

    public List<Booking> getBookingsByTurfAndDate(String turfId, String date) {
        return bookingDAO.findByTurfAndDate(turfId, date);
    }

    /**
     * Validates and performs atomic check-in for an incoming QR token.
     * Enforces time-window, booking confirmation, and prevents double-checkins.
     */
    public CheckInResult validateAndCheckIn(String qrToken, String adminUsername) {
        CheckInResult res = new CheckInResult();
        if (qrToken == null || qrToken.trim().isEmpty()) {
            res.setSuccess(false);
            res.setResultCode("INVALID_QR");
            res.setMessage("Scanned QR code is empty or corrupted.");
            return res;
        }

        String token = qrToken.trim();
        if (token.contains("token=")) {
            int idx = token.indexOf("token=");
            token = token.substring(idx + 6);
            int amp = token.indexOf('&');
            if (amp != -1) {
                token = token.substring(0, amp);
            }
            try {
                token = java.net.URLDecoder.decode(token, "UTF-8");
            } catch (java.io.UnsupportedEncodingException | IllegalArgumentException ignored) {}
        }

        Booking booking = bookingDAO.findByQrToken(token);
        if (booking == null) {
            // Also try looking up directly by booking ID as a convenience fallback
            booking = bookingDAO.findById(token);
        }

        if (booking == null) {
            res.setSuccess(false);
            res.setResultCode("INVALID_QR");
            res.setMessage("Unrecognized pass. No booking found with QR payload: " + token);
            return res;
        }

        // Enrich with turf and customer details
        enrichBookingDetails(booking);
        res.setBooking(booking);
        res.setCustomerName(booking.getUserName() != null ? booking.getUserName() : "Player (" + booking.getUserId() + ")");
        res.setTurfName(booking.getTurfName() != null ? booking.getTurfName() : booking.getTurfId());
        res.setTurfLocation(booking.getTurfLocation() != null ? booking.getTurfLocation() : "Turf Venue");

        User player = userDAO.findById(booking.getUserId());
        if (player != null) {
            res.setCustomerEmail(player.getEmail());
            res.setCustomerPhone(player.getPhone());
        }

        // Check 1: Booking status
        if (booking.getStatus() == BookingStatus.CANCELLED) {
            res.setSuccess(false);
            res.setResultCode("CANCELLED");
            res.setMessage("Reservation " + booking.getBookingId() + " was CANCELLED and cannot be admitted.");
            return res;
        }
        if (booking.getStatus() == BookingStatus.PENDING) {
            res.setSuccess(false);
            res.setResultCode("PENDING");
            res.setMessage("Reservation " + booking.getBookingId() + " is PENDING payment and not confirmed.");
            return res;
        }

        // Check 2: Already checked in?
        if (booking.getCheckInStatus() == CheckInStatus.CHECKED_IN) {
            SimpleDateFormat sdf = new SimpleDateFormat("hh:mm a, dd MMM yyyy");
            String checkInTime = booking.getCheckedInAt() != null ? sdf.format(booking.getCheckedInAt()) : "earlier today";
            String checkedInBy = booking.getCheckedInBy() != null ? booking.getCheckedInBy() : "Administrator";

            res.setSuccess(false);
            res.setResultCode("ALREADY_CHECKED_IN");
            res.setCheckInTimeFormatted(checkInTime);
            res.setCheckedInBy(checkedInBy);
            res.setMessage("PASS ALREADY USED: This ticket was already checked in at " + checkInTime + " by " + checkedInBy + ".");
            return res;
        }

        // Check 3: Check-in Time Window Validation
        int preCheckInMinutes = CheckInConfig.getPreCheckInMinutes();
        String bookingDateStr = booking.getBookingDate();
        String startTimeStr = booking.getStartTime();
        String endTimeStr = booking.getEndTime();

        try {
            LocalDate today = LocalDate.now();
            LocalTime nowTime = LocalTime.now();
            LocalDate matchDate = LocalDate.parse(bookingDateStr.trim());

            if (matchDate.isBefore(today)) {
                res.setSuccess(false);
                res.setResultCode("OUT_OF_WINDOW");
                res.setMessage("Match date has expired (" + bookingDateStr + "). Pass is no longer valid.");
                return res;
            } else if (matchDate.isAfter(today)) {
                res.setSuccess(false);
                res.setResultCode("OUT_OF_WINDOW");
                res.setMessage("Match scheduled for future date: " + bookingDateStr + ". Check-in only allowed on game day.");
                return res;
            } else {
                // Today: validate time window [startTime - preCheckInMinutes, endTime]
                LocalTime slotStart = LocalTime.parse(startTimeStr.trim());
                LocalTime slotEnd = LocalTime.parse(endTimeStr.trim());
                LocalTime windowStart = slotStart.minusMinutes(preCheckInMinutes);

                res.setWindowDetails(windowStart + " – " + slotEnd);

                if (nowTime.isBefore(windowStart)) {
                    res.setSuccess(false);
                    res.setResultCode("OUT_OF_WINDOW");
                    res.setMessage("Check-in opens " + preCheckInMinutes + " mins prior to match start (at " +
                            windowStart.truncatedTo(ChronoUnit.MINUTES) + "). Current time is " +
                            nowTime.truncatedTo(ChronoUnit.MINUTES) + ".");
                    return res;
                }

                if (nowTime.isAfter(slotEnd)) {
                    res.setSuccess(false);
                    res.setResultCode("OUT_OF_WINDOW");
                    res.setMessage("Match slot concluded at " + slotEnd + ". Entry window closed.");
                    return res;
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Time window evaluation warning: {0}", e.getMessage());
            // If date/time parsing fails due to legacy formats, fallback to allow entry if valid booking
        }

        // Check 4: ATOMIC check-in to prevent double-scans across concurrent admin devices
        String actualToken = booking.getQrToken() != null ? booking.getQrToken() : token;
        Booking updatedBooking = bookingDAO.atomicCheckIn(actualToken, adminUsername);

        if (updatedBooking == null) {
            // Concurrent race condition caught!
            Booking latest = bookingDAO.findById(booking.getBookingId());
            res.setSuccess(false);
            res.setResultCode("ALREADY_CHECKED_IN");
            SimpleDateFormat sdf = new SimpleDateFormat("hh:mm a, dd MMM yyyy");
            String checkInTime = (latest != null && latest.getCheckedInAt() != null) ? sdf.format(latest.getCheckedInAt()) : "just now";
            String checkedInBy = (latest != null && latest.getCheckedInBy() != null) ? latest.getCheckedInBy() : "Admin";
            res.setCheckInTimeFormatted(checkInTime);
            res.setCheckedInBy(checkedInBy);
            res.setMessage("PASS ALREADY USED: Checked in at " + checkInTime + " by " + checkedInBy + ".");
            return res;
        }

        // SUCCESS!
        SimpleDateFormat sdf = new SimpleDateFormat("hh:mm a");
        String formattedCheckInTime = sdf.format(updatedBooking.getCheckedInAt());
        enrichBookingDetails(updatedBooking);

        res.setSuccess(true);
        res.setResultCode("SUCCESS");
        res.setBooking(updatedBooking);
        res.setCheckInTimeFormatted(formattedCheckInTime);
        res.setCheckedInBy(adminUsername != null ? adminUsername : "admin");
        res.setMessage("CHECK-IN SUCCESSFUL: Player squad admitted to " + res.getTurfName() + ".");

        // Create in-app notification for the customer
        try {
            Notification notif = new Notification();
            notif.setUserId(updatedBooking.getUserId());
            notif.setTitle("Gate Check-In Confirmed");
            String courtMsg = updatedBooking.getCourtCount() > 0 
                ? " (" + updatedBooking.getCourtsDisplay() + ")" 
                : "";
            notif.setMessage("You have been admitted to " + res.getTurfName() + courtMsg + 
                " for slot " + updatedBooking.getStartTime() + " – " + updatedBooking.getEndTime() + ".");
            notif.setType("CHECK_IN");
            notif.setLink("/user/booking?action=details&id=" + updatedBooking.getBookingId());
            notificationDAO.createNotification(notif);
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to create check-in notification: {0}", e.getMessage());
        }

        return res;
    }

    private void enrichBookingDetails(Booking b) {
        if (b == null) return;
        if (b.getTurfName() == null || b.getTurfLocation() == null) {
            Turf t = turfDAO.findById(b.getTurfId());
            if (t != null) {
                b.setTurfName(t.getTurfName());
                b.setTurfLocation(t.getFullLocation());
                // Ensure turfType is populated from DB if not stored on booking
                if (b.getTurfType() == null) b.setTurfType(t.getTurfType().name());
            }
        }
        if (b.getUserName() == null) {
            User u = userDAO.findById(b.getUserId());
            if (u != null) {
                b.setUserName(u.getUsername());
            }
        }
    }

    // Dashboard metrics & reporting
    public long countTodayCheckIns() {
        return bookingDAO.countTodayCheckIns(LocalDate.now().toString());
    }

    public long countTodayBookings() {
        return bookingDAO.countTodayBookings(LocalDate.now().toString());
    }

    public List<Booking> getTodayCheckIns() {
        List<Booking> list = bookingDAO.findTodayCheckIns(LocalDate.now().toString());
        for (Booking b : list) enrichBookingDetails(b);
        return list;
    }

    public List<Booking> getTodayBookings() {
        List<Booking> list = bookingDAO.findTodayBookings(LocalDate.now().toString());
        for (Booking b : list) enrichBookingDetails(b);
        return list;
    }

    public List<Booking> getRecentCheckIns(int limit) {
        List<Booking> list = bookingDAO.findRecentCheckIns(limit);
        for (Booking b : list) enrichBookingDetails(b);
        return list;
    }

    private int timeToMinutes(String time) {
        String[] parts = time.split(":");
        return Integer.parseInt(parts[0]) * 60 + Integer.parseInt(parts[1]);
    }
}
