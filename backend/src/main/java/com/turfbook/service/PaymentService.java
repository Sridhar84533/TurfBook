package com.turfbook.service;

import com.turfbook.dao.BookingDAO;
import com.turfbook.dao.PaymentDAO;
import com.turfbook.enums.BookingStatus;
import com.turfbook.enums.PaymentStatus;
import com.turfbook.model.Payment;
import com.turfbook.model.Booking;

import java.util.List;
import java.util.UUID;
import java.util.logging.Logger;

public class PaymentService {
    private static final Logger LOGGER = Logger.getLogger(PaymentService.class.getName());
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    /**
     * Simulates payment processing. In a real app this would call a payment gateway.
     * @param bookingId The booking to pay for
     * @param userId    The user making the payment
     * @param amount    The declared amount (server will validate against booking amount)
     * @param method    Payment method: UPI, CARD, NET_BANKING, WALLET
     * @return Payment object with SUCCESS status
     */
    public Payment processPayment(String bookingId, String userId, double amount, String method) throws Exception {
        if (bookingId == null || bookingId.trim().isEmpty()) throw new Exception("Booking ID is required.");
        if (method == null || method.trim().isEmpty()) throw new Exception("Payment method is required.");

        // Validate booking exists
        Booking booking = bookingDAO.findById(bookingId);
        if (booking == null) throw new Exception("Booking not found.");

        // Use server-authoritative amount — ignore client-sent amount
        double authorizedAmount = booking.getTotalAmount();

        // Generate a unique transaction reference
        String transactionRef = "TXN-" + UUID.randomUUID().toString().substring(0, 12).toUpperCase();

        // Simulate payment (always succeeds in demo; in production, gateway is called here)
        PaymentStatus status = PaymentStatus.SUCCESS;

        Payment payment = new Payment();
        payment.setPaymentId("PAY-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        payment.setBookingId(bookingId);
        payment.setUserId(userId);
        payment.setAmount(authorizedAmount);
        payment.setPaymentMethod(method.trim().toUpperCase());
        payment.setTransactionReference(transactionRef);
        payment.setPaymentStatus(status);

        boolean saved = paymentDAO.createPayment(payment);
        if (!saved) throw new Exception("Failed to record payment. Please try again.");

        // Update booking status to CONFIRMED if payment succeeded
        if (status == PaymentStatus.SUCCESS) {
            bookingDAO.updateStatus(bookingId, BookingStatus.CONFIRMED);
            LOGGER.info("Payment " + payment.getPaymentId() + " processed successfully for booking " + bookingId);
        }

        return payment;
    }

    public Payment getPaymentByBookingId(String bookingId) {
        return paymentDAO.findByBookingId(bookingId);
    }

    public List<Payment> getAllPayments() {
        return paymentDAO.findAll();
    }

    public List<Payment> getPaymentsByUserId(String userId) {
        return paymentDAO.findByUserId(userId);
    }

    public double getTotalRevenue() {
        return paymentDAO.getTotalRevenue();
    }
}
