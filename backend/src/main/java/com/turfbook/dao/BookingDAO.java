package com.turfbook.dao;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.logging.Logger;

import org.bson.Document;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.FindOneAndUpdateOptions;
import com.mongodb.client.model.ReturnDocument;
import com.mongodb.client.model.Sorts;
import com.mongodb.client.model.Updates;
import com.turfbook.enums.BookingStatus;
import com.turfbook.enums.CheckInStatus;
import com.turfbook.model.Booking;
import com.turfbook.util.MongoDBConnection;

public class BookingDAO {
    private static final Logger LOGGER = Logger.getLogger(BookingDAO.class.getName());

    public boolean createBooking(Booking booking) {
        try {
            MongoCollection<Document> col = MongoDBConnection.getBookingsCollection();
            Document doc = new Document()
                    .append("bookingId", booking.getBookingId())
                    .append("userId", booking.getUserId())
                    .append("turfId", booking.getTurfId())
                    .append("bookingDate", booking.getBookingDate())
                    .append("startTime", booking.getStartTime())
                    .append("endTime", booking.getEndTime())
                    .append("duration", booking.getDuration())
                    .append("totalAmount", booking.getTotalAmount())
                    .append("status", booking.getStatus().name())
                    .append("qrToken", booking.getQrToken())
                    .append("qrGeneratedAt", booking.getQrGeneratedAt() != null ? booking.getQrGeneratedAt() : new Date())
                    .append("checkInStatus", booking.getCheckInStatus() != null ? booking.getCheckInStatus().name() : CheckInStatus.NOT_CHECKED_IN.name())
                    .append("checkedInAt", booking.getCheckedInAt())
                    .append("checkedInBy", booking.getCheckedInBy())
                    .append("assignedCourt", booking.getAssignedCourt())
                    .append("assignedCourts", booking.getAssignedCourts())
                    .append("turfType", booking.getTurfType())
                    .append("createdAt", booking.getCreatedAt() != null ? booking.getCreatedAt() : new Date());
            col.insertOne(doc);
            LOGGER.info("BookingDAO: Booking created: " + booking.getBookingId());
            return true;
        } catch (Exception e) {
            LOGGER.severe("BookingDAO.createBooking failed: " + e.getMessage());
            return false;
        }
    }

    public Booking findById(String bookingId) {
        try {
            Document doc = MongoDBConnection.getBookingsCollection()
                    .find(Filters.eq("bookingId", bookingId)).first();
            return docToBooking(doc);
        } catch (Exception e) {
            LOGGER.severe("BookingDAO.findById failed: " + e.getMessage());
            return null;
        }
    }

    public List<Booking> findByUserId(String userId) {
        List<Booking> bookings = new ArrayList<>();
        try {
            for (Document doc : MongoDBConnection.getBookingsCollection()
                    .find(Filters.eq("userId", userId))) {
                Booking b = docToBooking(doc);
                if (b != null) bookings.add(b);
            }
        } catch (Exception e) {
            LOGGER.severe("BookingDAO.findByUserId failed: " + e.getMessage());
        }
        return bookings;
    }

    public List<Booking> findByTurfId(String turfId) {
        List<Booking> bookings = new ArrayList<>();
        try {
            for (Document doc : MongoDBConnection.getBookingsCollection()
                    .find(Filters.eq("turfId", turfId))) {
                Booking b = docToBooking(doc);
                if (b != null) bookings.add(b);
            }
        } catch (Exception e) {
            LOGGER.severe("BookingDAO.findByTurfId failed: " + e.getMessage());
        }
        return bookings;
    }

    /**
     * Find all active bookings for a specific turf, date, and start time slot.
     * Used for badminton court-slot availability checks.
     */
    public List<Booking> findByTurfDateAndSlot(String turfId, String bookingDate, String startTime) {
        List<Booking> bookings = new ArrayList<>();
        try {
            for (Document doc : MongoDBConnection.getBookingsCollection()
                    .find(Filters.and(
                            Filters.eq("turfId", turfId),
                            Filters.eq("bookingDate", bookingDate),
                            Filters.eq("startTime", startTime),
                            Filters.ne("status", BookingStatus.CANCELLED.name())
                    ))) {
                Booking b = docToBooking(doc);
                if (b != null) bookings.add(b);
            }
        } catch (Exception e) {
            LOGGER.severe("BookingDAO.findByTurfDateAndSlot failed: " + e.getMessage());
        }
        return bookings;
    }

    public List<Booking> findByTurfAndDate(String turfId, String bookingDate) {
        List<Booking> bookings = new ArrayList<>();
        try {
            for (Document doc : MongoDBConnection.getBookingsCollection()
                    .find(Filters.and(
                            Filters.eq("turfId", turfId),
                            Filters.eq("bookingDate", bookingDate),
                            Filters.ne("status", BookingStatus.CANCELLED.name())
                    ))) {
                Booking b = docToBooking(doc);
                if (b != null) bookings.add(b);
            }
        } catch (Exception e) {
            LOGGER.severe("BookingDAO.findByTurfAndDate failed: " + e.getMessage());
        }
        return bookings;
    }

    /**
     * Core overlap detection: checks if existing bookings on same turf/date overlap with proposed slot.
     * Overlap logic: existing.start < proposed.end AND existing.end > proposed.start
     */
    public boolean hasOverlappingBooking(String turfId, String bookingDate, String startTime, String endTime) {
        List<Booking> existingBookings = findByTurfAndDate(turfId, bookingDate);
        for (Booking b : existingBookings) {
            // Convert HH:mm times to minutes for comparison
            int reqStart = timeToMinutes(startTime);
            int reqEnd   = timeToMinutes(endTime);
            int exStart  = timeToMinutes(b.getStartTime());
            int exEnd    = timeToMinutes(b.getEndTime());

            // Overlap if: existing.start < requested.end AND existing.end > requested.start
            if (exStart < reqEnd && exEnd > reqStart) {
                LOGGER.info("Overlap detected: existing " + b.getStartTime() + "-" + b.getEndTime() +
                        " overlaps with requested " + startTime + "-" + endTime);
                return true;
            }
        }
        return false;
    }

    /**
     * Finds all court numbers that are already booked for a specific turf and overlapping slot.
     * Takes into account both single-court (legacy) and multi-court bookings.
     */
    public Set<Integer> findBookedCourtsForSlot(String turfId, String bookingDate, String startTime, String endTime) {
        Set<Integer> booked = new HashSet<>();
        int reqStart = timeToMinutes(startTime);
        int reqEnd   = timeToMinutes(endTime);
        List<Booking> dayBookings = findByTurfAndDate(turfId, bookingDate);
        for (Booking b : dayBookings) {
            int exStart = timeToMinutes(b.getStartTime());
            int exEnd   = timeToMinutes(b.getEndTime());
            if (exStart < reqEnd && exEnd > reqStart) {
                booked.addAll(b.getAssignedCourts());
            }
        }
        return booked;
    }

    public List<Booking> findAll() {
        List<Booking> bookings = new ArrayList<>();
        try {
            for (Document doc : MongoDBConnection.getBookingsCollection().find()) {
                Booking b = docToBooking(doc);
                if (b != null) bookings.add(b);
            }
        } catch (Exception e) {
            LOGGER.severe("BookingDAO.findAll failed: " + e.getMessage());
        }
        return bookings;
    }

    public boolean updateStatus(String bookingId, BookingStatus status) {
        try {
            MongoDBConnection.getBookingsCollection().updateOne(
                    Filters.eq("bookingId", bookingId),
                    Updates.set("status", status.name())
            );
            return true;
        } catch (Exception e) {
            LOGGER.severe("BookingDAO.updateStatus failed: " + e.getMessage());
            return false;
        }
    }

    public long countTotalBookings() {
        try {
            return MongoDBConnection.getBookingsCollection().countDocuments();
        } catch (Exception e) {
            return 0;
        }
    }

    private int timeToMinutes(String time) {
        if (time == null || !time.contains(":")) return 0;
        String[] parts = time.split(":");
        return Integer.parseInt(parts[0]) * 60 + Integer.parseInt(parts[1]);
    }

    public Booking findByQrToken(String qrToken) {
        if (qrToken == null || qrToken.trim().isEmpty()) return null;
        try {
            Document doc = MongoDBConnection.getBookingsCollection()
                    .find(Filters.eq("qrToken", qrToken.trim())).first();
            return docToBooking(doc);
        } catch (Exception e) {
            LOGGER.severe("BookingDAO.findByQrToken failed: " + e.getMessage());
            return null;
        }
    }

    public boolean updateQrToken(String bookingId, String qrToken, Date generatedAt) {
        try {
            MongoDBConnection.getBookingsCollection().updateOne(
                    Filters.eq("bookingId", bookingId),
                    Updates.combine(
                            Updates.set("qrToken", qrToken),
                            Updates.set("qrGeneratedAt", generatedAt != null ? generatedAt : new Date()),
                            Updates.set("checkInStatus", CheckInStatus.NOT_CHECKED_IN.name())
                    )
            );
            return true;
        } catch (Exception e) {
            LOGGER.severe("BookingDAO.updateQrToken failed: " + e.getMessage());
            return false;
        }
    }

    /**
     * Atomically transitions a booking from NOT_CHECKED_IN -> CHECKED_IN.
     * Prevents race conditions / duplicate scans across multiple admin devices.
     */
    public Booking atomicCheckIn(String qrToken, String adminUsername) {
        if (qrToken == null || qrToken.trim().isEmpty()) return null;
        try {
            Document updated = MongoDBConnection.getBookingsCollection().findOneAndUpdate(
                    Filters.and(
                            Filters.eq("qrToken", qrToken.trim()),
                            Filters.eq("checkInStatus", CheckInStatus.NOT_CHECKED_IN.name()),
                            Filters.eq("status", BookingStatus.CONFIRMED.name())
                    ),
                    Updates.combine(
                            Updates.set("checkInStatus", CheckInStatus.CHECKED_IN.name()),
                            Updates.set("checkedInAt", new Date()),
                            Updates.set("checkedInBy", adminUsername != null ? adminUsername : "admin")
                    ),
                    new FindOneAndUpdateOptions().returnDocument(ReturnDocument.AFTER)
            );
            return docToBooking(updated);
        } catch (Exception e) {
            LOGGER.severe("BookingDAO.atomicCheckIn failed: " + e.getMessage());
            return null;
        }
    }

    public long countTodayCheckIns(String todayDate) {
        try {
            return MongoDBConnection.getBookingsCollection().countDocuments(
                    Filters.and(
                            Filters.eq("bookingDate", todayDate),
                            Filters.eq("checkInStatus", CheckInStatus.CHECKED_IN.name())
                    )
            );
        } catch (Exception e) {
            return 0;
        }
    }

    public long countTodayBookings(String todayDate) {
        try {
            return MongoDBConnection.getBookingsCollection().countDocuments(
                    Filters.eq("bookingDate", todayDate)
            );
        } catch (Exception e) {
            return 0;
        }
    }

    public List<Booking> findTodayCheckIns(String todayDate) {
        List<Booking> list = new ArrayList<>();
        try {
            for (Document doc : MongoDBConnection.getBookingsCollection().find(
                    Filters.and(
                            Filters.eq("bookingDate", todayDate),
                            Filters.eq("checkInStatus", CheckInStatus.CHECKED_IN.name())
                    )
            ).sort(Sorts.descending("checkedInAt"))) {
                Booking b = docToBooking(doc);
                if (b != null) list.add(b);
            }
        } catch (Exception e) {
            LOGGER.severe("BookingDAO.findTodayCheckIns failed: " + e.getMessage());
        }
        return list;
    }

    public List<Booking> findRecentCheckIns(int limit) {
        List<Booking> list = new ArrayList<>();
        try {
            for (Document doc : MongoDBConnection.getBookingsCollection().find(
                    Filters.eq("checkInStatus", CheckInStatus.CHECKED_IN.name())
            ).sort(Sorts.descending("checkedInAt")).limit(limit)) {
                Booking b = docToBooking(doc);
                if (b != null) list.add(b);
            }
        } catch (Exception e) {
            LOGGER.severe("BookingDAO.findRecentCheckIns failed: " + e.getMessage());
        }
        return list;
    }

    public List<Booking> findTodayBookings(String todayDate) {
        List<Booking> list = new ArrayList<>();
        try {
            for (Document doc : MongoDBConnection.getBookingsCollection().find(
                    Filters.eq("bookingDate", todayDate)
            ).sort(Sorts.ascending("startTime"))) {
                Booking b = docToBooking(doc);
                if (b != null) list.add(b);
            }
        } catch (Exception e) {
            LOGGER.severe("BookingDAO.findTodayBookings failed: " + e.getMessage());
        }
        return list;
    }

    private Booking docToBooking(Document doc) {
        if (doc == null) return null;
        Booking b = new Booking();
        b.setBookingId(doc.getString("bookingId"));
        b.setUserId(doc.getString("userId"));
        b.setTurfId(doc.getString("turfId"));
        b.setBookingDate(doc.getString("bookingDate"));
        b.setStartTime(doc.getString("startTime"));
        b.setEndTime(doc.getString("endTime"));
        Double duration = doc.getDouble("duration");
        if (duration != null) b.setDuration(duration);
        Double amount = doc.getDouble("totalAmount");
        if (amount != null) b.setTotalAmount(amount);
        b.setStatus(BookingStatus.fromString(doc.getString("status")));
        b.setQrToken(doc.getString("qrToken"));
        b.setQrGeneratedAt(doc.getDate("qrGeneratedAt"));
        b.setCheckInStatus(CheckInStatus.fromString(doc.getString("checkInStatus")));
        b.setCheckedInAt(doc.getDate("checkedInAt"));
        b.setCheckedInBy(doc.getString("checkedInBy"));
        b.setCreatedAt(doc.getDate("createdAt"));
        // Badminton fields (backward-compatible)
        Integer assignedCourt = doc.getInteger("assignedCourt");
        if (assignedCourt != null) b.setAssignedCourt(assignedCourt);
        List<Integer> assignedCourts = doc.getList("assignedCourts", Integer.class);
        if (assignedCourts != null && !assignedCourts.isEmpty()) {
            b.setAssignedCourts(assignedCourts);
        } else if (assignedCourt != null && assignedCourt > 0) {
            b.setAssignedCourts(Collections.singletonList(assignedCourt));
        }
        String turfType = doc.getString("turfType");
        if (turfType != null) b.setTurfType(turfType);
        return b;
    }
}
