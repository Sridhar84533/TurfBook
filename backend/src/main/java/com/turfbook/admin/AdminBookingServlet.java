package com.turfbook.admin;

import com.turfbook.model.Booking;
import com.turfbook.model.Turf;
import com.turfbook.model.User;
import com.turfbook.service.BookingService;
import com.turfbook.service.TurfService;
import com.turfbook.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/admin/bookings")
public class AdminBookingServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminBookingServlet.class.getName());
    private final BookingService bookingService = new BookingService();
    private final TurfService turfService = new TurfService();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<Booking> bookings = bookingService.getAllBookings();
            for (Booking b : bookings) {
                Turf t = turfService.getTurfById(b.getTurfId());
                if (t != null) b.setTurfName(t.getTurfName());
                User u = userDAO.findById(b.getUserId());
                if (u != null) b.setUserName(u.getUsername());
            }
            req.setAttribute("bookings", bookings);
            req.getRequestDispatcher("/admin/bookings.jsp").forward(req, resp);
        } catch (Exception e) {
            LOGGER.severe("AdminBookingServlet error: " + e.getMessage());
            req.setAttribute("error", "Unable to load bookings: " + e.getMessage());
            req.getRequestDispatcher("/admin/bookings.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String bookingId = req.getParameter("bookingId");
        String action = req.getParameter("action");
        try {
            if ("cancel".equals(action)) {
                bookingService.cancelBooking(bookingId);
                resp.sendRedirect(req.getContextPath() + "/admin/bookings?success=Booking+cancelled");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/bookings");
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/admin/bookings?error=" + e.getMessage());
        }
    }
}
