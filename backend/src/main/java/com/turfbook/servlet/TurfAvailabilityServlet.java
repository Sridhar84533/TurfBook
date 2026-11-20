package com.turfbook.servlet;

import com.google.gson.Gson;
import com.turfbook.model.Booking;
import com.turfbook.service.BookingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

@WebServlet({"/turf/availability", "/turf-availability"})
public class TurfAvailabilityServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(TurfAvailabilityServlet.class.getName());
    private final BookingService bookingService = new BookingService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String turfId = req.getParameter("turfId");
        String date = req.getParameter("date");

        if (turfId == null || turfId.trim().isEmpty() || date == null || date.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            Map<String, Object> err = new HashMap<>();
            err.put("error", "turfId and date parameters are required.");
            resp.getWriter().write(gson.toJson(err));
            return;
        }

        try {
            List<Booking> bookings = bookingService.getBookingsByTurfAndDate(turfId.trim(), date.trim());
            List<Map<String, Object>> result = new ArrayList<>();

            for (Booking b : bookings) {
                Map<String, Object> slot = new HashMap<>();
                slot.put("bookingId", b.getBookingId());
                slot.put("turfId", b.getTurfId());
                slot.put("bookingDate", b.getBookingDate());
                slot.put("startTime", b.getStartTime());
                slot.put("endTime", b.getEndTime());
                slot.put("duration", b.getDuration());
                slot.put("status", b.getStatus() != null ? b.getStatus().name() : "CONFIRMED");
                result.add(slot);
            }

            PrintWriter out = resp.getWriter();
            out.write(gson.toJson(result));
            out.flush();
        } catch (Exception e) {
            LOGGER.severe("TurfAvailabilityServlet error: " + e.getMessage());
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            Map<String, Object> err = new HashMap<>();
            err.put("error", "Could not check availability: " + e.getMessage());
            resp.getWriter().write(gson.toJson(err));
        }
    }
}
