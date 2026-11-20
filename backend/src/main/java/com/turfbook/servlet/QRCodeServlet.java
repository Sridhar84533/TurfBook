package com.turfbook.servlet;

import com.turfbook.model.Booking;
import com.turfbook.service.BookingService;
import com.turfbook.util.QRCodeUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.OutputStream;
import java.util.logging.Logger;

@WebServlet(urlPatterns = {"/qr", "/booking/qr"})
public class QRCodeServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(QRCodeServlet.class.getName());
    private final BookingService bookingService = new BookingService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        String bookingId = req.getParameter("id");
        int size = 300;
        try {
            String sizeParam = req.getParameter("size");
            if (sizeParam != null && !sizeParam.isEmpty()) {
                size = Integer.parseInt(sizeParam);
                if (size < 100) size = 100;
                if (size > 1000) size = 1000;
            }
        } catch (NumberFormatException ignored) {}

        String qrPayload = token;
        if ((qrPayload == null || qrPayload.trim().isEmpty()) && bookingId != null && !bookingId.trim().isEmpty()) {
            Booking b = bookingService.getBookingById(bookingId);
            if (b != null && b.getQrToken() != null) {
                qrPayload = b.getQrToken();
            } else if (b != null) {
                qrPayload = b.getBookingId();
            }
        }

        if (qrPayload == null || qrPayload.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing QR token or booking id.");
            return;
        }

        try {
            String qrContent = QRCodeUtil.buildCheckInUrl(req, qrPayload);
            byte[] qrBytes = QRCodeUtil.generateQRCodeBytes(qrContent, size, size);
            resp.setContentType("image/png");
            resp.setContentLength(qrBytes.length);
            resp.setHeader("Cache-Control", "public, max-age=86400"); // 1 day cache
            try (OutputStream os = resp.getOutputStream()) {
                os.write(qrBytes);
                os.flush();
            }
        } catch (Exception e) {
            LOGGER.severe("QRCodeServlet error: " + e.getMessage());
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generating QR Code");
        }
    }
}
