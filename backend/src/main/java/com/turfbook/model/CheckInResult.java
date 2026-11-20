package com.turfbook.model;

import java.io.Serializable;

public class CheckInResult implements Serializable {
    private static final long serialVersionUID = 1L;

    private boolean success;
    private String resultCode; // SUCCESS, ALREADY_CHECKED_IN, OUT_OF_WINDOW, INVALID_QR, CANCELLED, ERROR
    private String message;
    private Booking booking;
    private String customerName;
    private String customerEmail;
    private String customerPhone;
    private String turfName;
    private String turfLocation;
    private String checkInTimeFormatted;
    private String checkedInBy;
    private String windowDetails;

    public CheckInResult() {}

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getResultCode() {
        return resultCode;
    }

    public void setResultCode(String resultCode) {
        this.resultCode = resultCode;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Booking getBooking() {
        return booking;
    }

    public void setBooking(Booking booking) {
        this.booking = booking;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerEmail() {
        return customerEmail;
    }

    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public String getTurfName() {
        return turfName;
    }

    public void setTurfName(String turfName) {
        this.turfName = turfName;
    }

    public String getTurfLocation() {
        return turfLocation;
    }

    public void setTurfLocation(String turfLocation) {
        this.turfLocation = turfLocation;
    }

    public String getCheckInTimeFormatted() {
        return checkInTimeFormatted;
    }

    public void setCheckInTimeFormatted(String checkInTimeFormatted) {
        this.checkInTimeFormatted = checkInTimeFormatted;
    }

    public String getCheckedInBy() {
        return checkedInBy;
    }

    public void setCheckedInBy(String checkedInBy) {
        this.checkedInBy = checkedInBy;
    }

    public String getWindowDetails() {
        return windowDetails;
    }

    public void setWindowDetails(String windowDetails) {
        this.windowDetails = windowDetails;
    }
}
