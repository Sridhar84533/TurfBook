package com.turfbook.servlet;

import com.turfbook.model.Booking;
import com.turfbook.model.Payment;
import com.turfbook.service.BookingService;
import com.turfbook.service.PaymentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Logger;

@WebServlet("/user/payment")
public class PaymentServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(PaymentServlet.class.getName());
    private final PaymentService paymentService = new PaymentService();
    private final BookingService bookingService = new BookingService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String bookingId = req.getParameter("bookingId");
        try {
            Booking booking = bookingService.getBookingById(bookingId);
            if (booking == null) {
                resp.sendRedirect(req.getContextPath() + "/user/booking?action=my-bookings");
                return;
            }
            req.setAttribute("booking", booking);
            req.getRequestDispatcher("/user/payment.jsp").forward(req, resp);
        } catch (Exception e) {
            LOGGER.severe("PaymentServlet GET error: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/user/dashboard.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String userId = (String) session.getAttribute("userId");

        String bookingId = req.getParameter("bookingId");
        String paymentMethod = req.getParameter("paymentMethod");

        try {
            Booking booking = bookingService.getBookingById(bookingId);
            if (booking == null) throw new Exception("Booking not found.");

            Payment payment = paymentService.processPayment(bookingId, userId, booking.getTotalAmount(), paymentMethod);

            // Clear pending booking from session
            session.removeAttribute("pendingBooking");

            // Reload fresh booking with QR token
            booking = bookingService.getBookingById(bookingId);
            com.turfbook.model.Turf turf = (new com.turfbook.service.TurfService()).getTurfById(booking.getTurfId());
            if (turf != null) {
                booking.setTurfName(turf.getTurfName());
                booking.setTurfLocation(turf.getFullLocation());
            }

            // Forward to confirmation
            req.setAttribute("payment", payment);
            req.setAttribute("booking", booking);
            req.getRequestDispatcher("/user/booking-confirmation.jsp").forward(req, resp);

        } catch (Exception e) {
            LOGGER.severe("PaymentServlet POST error: " + e.getMessage());
            Booking booking = bookingService.getBookingById(bookingId);
            req.setAttribute("booking", booking);
            req.setAttribute("error", "Payment failed: " + e.getMessage());
            req.getRequestDispatcher("/user/payment.jsp").forward(req, resp);
        }
    }
}
