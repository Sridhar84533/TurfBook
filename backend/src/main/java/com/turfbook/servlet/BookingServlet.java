package com.turfbook.servlet;

import com.turfbook.dao.BookingDAO;
import com.turfbook.exception.InvalidBookingException;
import com.turfbook.exception.TurfNotAvailableException;
import com.turfbook.model.Booking;
import com.turfbook.model.Payment;
import com.turfbook.model.Turf;
import com.turfbook.service.BookingService;
import com.turfbook.service.TurfService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/user/booking")
public class BookingServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(BookingServlet.class.getName());
    private final BookingService bookingService = new BookingService();
    private final TurfService turfService = new TurfService();
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String currentAction = action != null ? action : "";

        try {
            switch (currentAction) {
                case "my-bookings" -> {
                    HttpSession session = req.getSession(false);
                    String userId = (String) session.getAttribute("userId");
                    List<Booking> bookings = bookingService.getUserBookings(userId);
                    // Enrich bookings with turf names
                    for (Booking b : bookings) {
                        Turf t = turfService.getTurfById(b.getTurfId());
                        if (t != null) {
                            b.setTurfName(t.getTurfName());
                            b.setTurfLocation(t.getCity());
                        }
                    }
                    req.setAttribute("bookings", bookings);
                    req.getRequestDispatcher("/user/my-bookings.jsp").forward(req, resp);
                }
                case "details", "pass" -> {
                    String bookingId = req.getParameter("id");
                    Booking booking = bookingService.getBookingById(bookingId);
                    if (booking != null) {
                        Turf t = turfService.getTurfById(booking.getTurfId());
                        if (t != null) {
                            booking.setTurfName(t.getTurfName());
                            booking.setTurfLocation(t.getFullLocation());
                        }
                        Payment payment = (new com.turfbook.service.PaymentService()).getPaymentByBookingId(bookingId);
                        req.setAttribute("payment", payment);
                    }
                    req.setAttribute("booking", booking);
                    req.getRequestDispatcher("/user/booking-details.jsp").forward(req, resp);
                }
                case "court-selection" -> {
                    // ── Badminton Court Selection Page ──────────────────────────────
                    String turfId    = req.getParameter("turfId");
                    String date      = req.getParameter("date");
                    String startTime = req.getParameter("startTime");
                    String endTime   = req.getParameter("endTime");

                    // Validate required parameters
                    if (turfId == null || turfId.isEmpty() ||
                        date == null || date.isEmpty() ||
                        startTime == null || startTime.isEmpty() ||
                        endTime == null || endTime.isEmpty()) {
                        resp.sendRedirect(req.getContextPath() + "/turfs");
                        return;
                    }

                    Turf turf = turfService.getTurfById(turfId);
                    if (turf == null || !turf.isBadminton()) {
                        resp.sendRedirect(req.getContextPath() + "/turfs");
                        return;
                    }

                    // Determine which courts are already booked for this slot
                    Set<Integer> occupiedCourts = bookingDAO.findBookedCourtsForSlot(turfId, date, startTime, endTime);

                    req.setAttribute("turf", turf);
                    req.setAttribute("bookingDate", date);
                    req.setAttribute("startTime", startTime);
                    req.setAttribute("endTime", endTime);
                    req.setAttribute("occupiedCourts", occupiedCourts);
                    req.getRequestDispatcher("/user/court-selection.jsp").forward(req, resp);
                }
                default -> {
                    // Show booking form
                    String turfId = req.getParameter("turfId");
                    if (turfId != null && !turfId.isEmpty()) {
                        Turf turf = turfService.getTurfById(turfId);
                        req.setAttribute("turf", turf);
                    }
                    req.getRequestDispatcher("/user/booking.jsp").forward(req, resp);
                }
            }
        } catch (ServletException | IOException e) {
            LOGGER.log(Level.SEVERE, "BookingServlet GET error: {0}", e.getMessage());
            req.setAttribute("error", "An error occurred. Please try again.");
            req.getRequestDispatcher("/user/booking.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String userId = (String) session.getAttribute("userId");

        String turfId      = req.getParameter("turfId");
        String bookingDate = req.getParameter("bookingDate");
        String startTime   = req.getParameter("startTime");
        String endTime     = req.getParameter("endTime");

        // Parse court selection for Badminton bookings (one or multiple)
        List<Integer> assignedCourts = new ArrayList<>();
        String courtsParam = req.getParameter("assignedCourts");
        String[] courtsArray = req.getParameterValues("assignedCourts");

        if (courtsParam != null && !courtsParam.trim().isEmpty()) {
            for (String p : courtsParam.split(",")) {
                try {
                    int c = Integer.parseInt(p.trim());
                    if (c > 0 && !assignedCourts.contains(c)) assignedCourts.add(c);
                } catch (NumberFormatException ignored) {}
            }
        } else if (courtsArray != null && courtsArray.length > 0) {
            for (String p : courtsArray) {
                try {
                    int c = Integer.parseInt(p.trim());
                    if (c > 0 && !assignedCourts.contains(c)) assignedCourts.add(c);
                } catch (NumberFormatException ignored) {}
            }
        }

        // Fallback for legacy single court parameter
        String courtParam = req.getParameter("assignedCourt");
        if (assignedCourts.isEmpty() && courtParam != null && !courtParam.trim().isEmpty()) {
            try {
                int c = Integer.parseInt(courtParam.trim());
                if (c > 0) assignedCourts.add(c);
            } catch (NumberFormatException ignored) {}
        }

        try {
            Booking booking;
            if (!assignedCourts.isEmpty()) {
                // Badminton: book requested court(s) with atomic server-side validation
                booking = bookingService.createBookingWithCourts(userId, turfId, bookingDate, startTime, endTime, assignedCourts);
            } else {
                booking = bookingService.createBooking(userId, turfId, bookingDate, startTime, endTime);
            }

            Turf turf = turfService.getTurfById(turfId);
            if (turf != null) {
                booking.setTurfName(turf.getTurfName());
                booking.setTurfLocation(turf.getFullLocation());
            }

            // Redirect to payment page
            req.getSession().setAttribute("pendingBooking", booking);
            resp.sendRedirect(req.getContextPath() + "/user/payment?bookingId=" + booking.getBookingId());

        } catch (TurfNotAvailableException | InvalidBookingException e) {
            // If this was a court-selection booking, return to court selection page
            if (!assignedCourts.isEmpty() || (courtParam != null && !courtParam.isEmpty())) {
                resp.sendRedirect(req.getContextPath() +
                    "/user/booking?action=court-selection&turfId=" + turfId +
                    "&date=" + bookingDate +
                    "&startTime=" + java.net.URLEncoder.encode(startTime, "UTF-8") +
                    "&endTime=" + java.net.URLEncoder.encode(endTime, "UTF-8") +
                    "&error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
            } else {
                Turf turf = turfService.getTurfById(turfId);
                req.setAttribute("turf", turf);
                req.setAttribute("error", e.getMessage());
                req.getRequestDispatcher("/user/booking.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "BookingServlet POST error: {0}", e.getMessage());
            req.setAttribute("error", "Booking failed. Please try again.");
            req.getRequestDispatcher("/user/booking.jsp").forward(req, resp);
        }
    }
}
