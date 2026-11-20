package com.turfbook.dao;

import com.mongodb.client.MongoCollection;
import com.turfbook.enums.PaymentStatus;
import com.turfbook.model.Payment;
import com.turfbook.util.MongoDBConnection;
import com.mongodb.client.model.Filters;
import org.bson.Document;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Logger;

public class PaymentDAO {
    private static final Logger LOGGER = Logger.getLogger(PaymentDAO.class.getName());

    public boolean createPayment(Payment payment) {
        try {
            MongoCollection<Document> col = MongoDBConnection.getPaymentsCollection();
            Document doc = new Document()
                    .append("paymentId", payment.getPaymentId())
                    .append("bookingId", payment.getBookingId())
                    .append("userId", payment.getUserId())
                    .append("amount", payment.getAmount())
                    .append("paymentMethod", payment.getPaymentMethod())
                    .append("transactionReference", payment.getTransactionReference())
                    .append("paymentStatus", payment.getPaymentStatus().name())
                    .append("paymentDate", payment.getPaymentDate() != null ? payment.getPaymentDate() : new Date());
            col.insertOne(doc);
            return true;
        } catch (Exception e) {
            LOGGER.severe("PaymentDAO.createPayment failed: " + e.getMessage());
            return false;
        }
    }

    public Payment findByBookingId(String bookingId) {
        try {
            Document doc = MongoDBConnection.getPaymentsCollection()
                    .find(Filters.eq("bookingId", bookingId)).first();
            return docToPayment(doc);
        } catch (Exception e) {
            LOGGER.severe("PaymentDAO.findByBookingId failed: " + e.getMessage());
            return null;
        }
    }

    public List<Payment> findByUserId(String userId) {
        List<Payment> payments = new ArrayList<>();
        try {
            for (Document doc : MongoDBConnection.getPaymentsCollection()
                    .find(Filters.eq("userId", userId))) {
                Payment p = docToPayment(doc);
                if (p != null) payments.add(p);
            }
        } catch (Exception e) {
            LOGGER.severe("PaymentDAO.findByUserId failed: " + e.getMessage());
        }
        return payments;
    }

    public List<Payment> findAll() {
        List<Payment> payments = new ArrayList<>();
        try {
            for (Document doc : MongoDBConnection.getPaymentsCollection().find()) {
                Payment p = docToPayment(doc);
                if (p != null) payments.add(p);
            }
        } catch (Exception e) {
            LOGGER.severe("PaymentDAO.findAll failed: " + e.getMessage());
        }
        return payments;
    }

    public double getTotalRevenue() {
        double total = 0;
        try {
            for (Document doc : MongoDBConnection.getPaymentsCollection()
                    .find(Filters.eq("paymentStatus", PaymentStatus.SUCCESS.name()))) {
                Double amount = doc.getDouble("amount");
                if (amount != null) total += amount;
            }
        } catch (Exception e) {
            LOGGER.severe("PaymentDAO.getTotalRevenue failed: " + e.getMessage());
        }
        return total;
    }

    private Payment docToPayment(Document doc) {
        if (doc == null) return null;
        Payment p = new Payment();
        p.setPaymentId(doc.getString("paymentId"));
        p.setBookingId(doc.getString("bookingId"));
        p.setUserId(doc.getString("userId"));
        Double amount = doc.getDouble("amount");
        if (amount != null) p.setAmount(amount);
        p.setPaymentMethod(doc.getString("paymentMethod"));
        p.setTransactionReference(doc.getString("transactionReference"));
        p.setPaymentStatus(PaymentStatus.fromString(doc.getString("paymentStatus")));
        p.setPaymentDate(doc.getDate("paymentDate"));
        return p;
    }
}
