package com.turfbook.admin;

import com.turfbook.model.Payment;
import com.turfbook.service.PaymentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/admin/payments")
public class AdminPaymentServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminPaymentServlet.class.getName());
    private final PaymentService paymentService = new PaymentService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<Payment> payments = paymentService.getAllPayments();
            double revenue = paymentService.getTotalRevenue();
            req.setAttribute("payments", payments);
            req.setAttribute("totalRevenue", revenue);
            req.getRequestDispatcher("/admin/payments.jsp").forward(req, resp);
        } catch (Exception e) {
            LOGGER.severe("AdminPaymentServlet error: " + e.getMessage());
            req.setAttribute("error", "Unable to load payments.");
            req.getRequestDispatcher("/admin/payments.jsp").forward(req, resp);
        }
    }
}
