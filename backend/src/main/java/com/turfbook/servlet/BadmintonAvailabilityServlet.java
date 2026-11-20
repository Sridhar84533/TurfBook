package com.turfbook.servlet;

import com.google.gson.Gson;
import com.turfbook.dao.BookingDAO;
import com.turfbook.dao.TurfDAO;
import com.turfbook.model.Booking;
import com.turfbook.model.Turf;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Returns real-time court slot availability for a badminton turf.
 *
 * GET /api/badminton/availability?turfId=...&date=YYYY-MM-DD
 *
 * Response:
 * {
 *   "success": true,
 *   "courtCount": 4,
 *   "openingTime": "07:00",
 *   "closingTime": "00:00",
 *   "slotDurationMinutes": 60,
 *   "slots": [
 *     {
 *       "startTime": "07:00",
 *       "endTime": "08:00",
 *       "label": "07:00 AM – 08:00 AM",
 *       "totalCourts": 4,
 *       "availableCourts": 3,
 *       "bookedCourts": 1,
 *       "available": true
 *     },
 *     ...
 *   ]
 * }
 */
@WebServlet("/api/badminton/availability")
public class BadmintonAvailabilityServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(BadmintonAvailabilityServlet.class.getName());
    private final TurfDAO turfDAO = new TurfDAO();
    private final BookingDAO bookingDAO = new BookingDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-store");
        PrintWriter out = resp.getWriter();

        String turfId = req.getParameter("turfId");
        String date   = req.getParameter("date");

        if (turfId == null || turfId.trim().isEmpty() || date == null || !date.matches("\\d{4}-\\d{2}-\\d{2}")) {
            resp.setStatus(400);
            out.print(gson.toJson(Map.of("success", false, "error", "turfId and date (YYYY-MM-DD) are required.")));
            return;
        }

        Turf turf = turfDAO.findById(turfId.trim());
        if (turf == null || !turf.isBadminton()) {
            resp.setStatus(404);
            out.print(gson.toJson(Map.of("success", false, "error", "Badminton turf not found: " + turfId)));
            return;
        }

        int courtCount = turf.getCourtCount();
        String openingTimeStr = turf.getOpeningTime();   // e.g. "07:00"
        String closingTimeStr = turf.getClosingTime();   // e.g. "00:00" (midnight)
        int slotMins = turf.getSlotDurationMinutes();

        // Build list of slot start times as "HH:mm" strings
        List<String> slotStarts = generateSlots(openingTimeStr, closingTimeStr, slotMins);

        // Determine if this is today to filter past slots
        boolean isToday = date.equals(java.time.LocalDate.now().toString());
        LocalTime nowTime = LocalTime.now();

        // Fetch ALL bookings for this turf on this date once (single DB query)
        List<Booking> dayBookings = bookingDAO.findByTurfAndDate(turfId.trim(), date);

        List<Map<String, Object>> slots = new ArrayList<>();
        for (String startStr : slotStarts) {
            // Compute end time
            int startMins = timeToMinutes(startStr);
            int endMins   = startMins + slotMins;
            String endStr = minutesToTime(endMins % (24 * 60));

            // Filter: if today, skip slots whose end has already passed
            if (isToday) {
                try {
                    LocalTime slotEnd = LocalTime.parse(endStr.length() == 5 ? endStr : endStr.substring(0, 5));
                    // Allow up to end of slot
                    if (nowTime.isAfter(slotEnd)) continue;
                } catch (DateTimeParseException ignored) {}
            }

            // Find all courts booked overlapping this slot
            Set<Integer> bookedInSlot = new HashSet<>();
            for (Booking b : dayBookings) {
                int exStart = timeToMinutes(b.getStartTime());
                int exEnd   = timeToMinutes(b.getEndTime());
                if (exStart < endMins && exEnd > startMins) {
                    bookedInSlot.addAll(b.getAssignedCourts());
                }
            }

            int bookedCount = bookedInSlot.size();
            int available   = courtCount - bookedCount;

            Map<String, Object> slot = new LinkedHashMap<>();
            slot.put("startTime", startStr);
            slot.put("endTime", endStr);
            slot.put("label", formatTime12h(startStr) + " – " + formatTime12h(endStr));
            slot.put("totalCourts", courtCount);
            slot.put("availableCourts", Math.max(0, available));
            slot.put("bookedCourts", bookedCount);
            slot.put("available", available > 0);
            slots.add(slot);
        }

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("success", true);
        result.put("turfId", turfId);
        result.put("courtCount", courtCount);
        result.put("openingTime", openingTimeStr);
        result.put("closingTime", closingTimeStr);
        result.put("slotDurationMinutes", slotMins);
        result.put("slots", slots);
        LOGGER.log(Level.INFO, "Badminton availability fetched for turf: {0}, date: {1}", new Object[]{turfId, date});
        out.print(gson.toJson(result));
    }

    /**
     * Generate slot start times between openingTime and closingTime.
     * closingTime "00:00" is treated as midnight (1440 min = next day boundary).
     */
    private List<String> generateSlots(String openingStr, String closingStr, int slotMins) {
        List<String> starts = new ArrayList<>();
        int start = timeToMinutes(openingStr);
        int end   = timeToMinutes(closingStr);
        // Treat midnight (00:00) as end-of-day when it means 24:00
        if (end == 0) end = 24 * 60;
        if (slotMins <= 0) slotMins = 60;

        for (int t = start; t + slotMins <= end; t += slotMins) {
            starts.add(minutesToTime(t % (24 * 60)));
        }
        return starts;
    }

    private int timeToMinutes(String hhmm) {
        if (hhmm == null) return 0;
        String[] p = hhmm.split(":");
        try {
            return Integer.parseInt(p[0]) * 60 + Integer.parseInt(p[1]);
        } catch (NumberFormatException | ArrayIndexOutOfBoundsException e) { return 0; }
    }

    private String minutesToTime(int mins) {
        int h = (mins / 60) % 24;
        int m = mins % 60;
        return String.format("%02d:%02d", h, m);
    }

    private String formatTime12h(String hhmm) {
        try {
            int mins = timeToMinutes(hhmm);
            int h = (mins / 60) % 24;
            int m = mins % 60;
            String ampm = h < 12 ? "AM" : "PM";
            int h12 = h % 12 == 0 ? 12 : h % 12;
            return String.format("%d:%02d %s", h12, m, ampm);
        } catch (Exception e) { return hhmm; }
    }
}
