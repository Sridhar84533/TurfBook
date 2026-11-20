package com.turfbook.model;

import com.turfbook.enums.BookingStatus;
import com.turfbook.enums.CheckInStatus;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

public class Booking implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private String bookingId;
    private String userId;
    private String turfId;
    private String bookingDate; // YYYY-MM-DD
    private String startTime;   // HH:mm (e.g. 18:00)
    private String endTime;     // HH:mm (e.g. 19:00)
    private double duration;    // in hours (e.g. 1.0)
    private double totalAmount;
    private BookingStatus status;
    private Date createdAt;

    // QR Pass and Check-in verification
    private String qrToken;
    private Date qrGeneratedAt;
    private CheckInStatus checkInStatus = CheckInStatus.NOT_CHECKED_IN;
    private Date checkedInAt;
    private String checkedInBy;

    // Supplementary fields for view rendering
    private String turfName;
    private String turfLocation;
    private String userName;

    // Badminton-specific: assigned court numbers (1..courtCount)
    private int assignedCourt; // legacy single court, 0 means not applicable (non-badminton)
    private List<Integer> assignedCourts = new ArrayList<>();
    private String turfType;   // denormalized for display convenience

    public Booking() {
        this.status = BookingStatus.CONFIRMED;
        this.checkInStatus = CheckInStatus.NOT_CHECKED_IN;
        this.createdAt = new Date();
    }

    public Booking(String bookingId, String userId, String turfId, String bookingDate, String startTime,
                   String endTime, double duration, double totalAmount, BookingStatus status) {
        this.bookingId = bookingId;
        this.userId = userId;
        this.turfId = turfId;
        this.bookingDate = bookingDate;
        this.startTime = startTime;
        this.endTime = endTime;
        this.duration = duration;
        this.totalAmount = totalAmount;
        this.status = status != null ? status : BookingStatus.CONFIRMED;
        this.createdAt = new Date();
    }

    public String getBookingId() {
        return bookingId;
    }

    public void setBookingId(String bookingId) {
        this.bookingId = bookingId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getTurfId() {
        return turfId;
    }

    public void setTurfId(String turfId) {
        this.turfId = turfId;
    }

    public String getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(String bookingDate) {
        this.bookingDate = bookingDate;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public double getDuration() {
        return duration;
    }

    public void setDuration(double duration) {
        this.duration = duration;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public boolean isExpired() {
        if (this.status == BookingStatus.CANCELLED) {
            return false;
        }
        if (this.status == BookingStatus.EXPIRED) {
            return true;
        }
        if (this.bookingDate == null || this.bookingDate.trim().isEmpty()) {
            return false;
        }
        try {
            java.time.LocalDate today = java.time.LocalDate.now();
            java.time.LocalDate bDate = java.time.LocalDate.parse(this.bookingDate.trim());
            if (bDate.isBefore(today)) {
                return true;
            } else if (bDate.isEqual(today)) {
                if (this.endTime != null && this.endTime.matches("([01]\\d|2[0-3]):[0-5]\\d")) {
                    java.time.LocalTime nowTime = java.time.LocalTime.now();
                    java.time.LocalTime bEndTime = java.time.LocalTime.parse(this.endTime.trim());
                    return nowTime.isAfter(bEndTime);
                }
            }
        } catch (Exception e) {
            // Ignore format exception and fallback
        }
        return false;
    }

    public BookingStatus getStatus() {
        if (this.status == BookingStatus.CONFIRMED && isExpired()) {
            return BookingStatus.EXPIRED;
        }
        return status;
    }

    public BookingStatus getRawStatus() {
        return this.status;
    }

    public void setStatus(BookingStatus status) {
        this.status = status != null ? status : BookingStatus.CONFIRMED;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
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

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getQrToken() {
        return qrToken;
    }

    public void setQrToken(String qrToken) {
        this.qrToken = qrToken;
    }

    public Date getQrGeneratedAt() {
        return qrGeneratedAt;
    }

    public void setQrGeneratedAt(Date qrGeneratedAt) {
        this.qrGeneratedAt = qrGeneratedAt;
    }

    public CheckInStatus getCheckInStatus() {
        return checkInStatus != null ? checkInStatus : CheckInStatus.NOT_CHECKED_IN;
    }

    public void setCheckInStatus(CheckInStatus checkInStatus) {
        this.checkInStatus = checkInStatus != null ? checkInStatus : CheckInStatus.NOT_CHECKED_IN;
    }

    public Date getCheckedInAt() {
        return checkedInAt;
    }

    public void setCheckedInAt(Date checkedInAt) {
        this.checkedInAt = checkedInAt;
    }

    public String getCheckedInBy() {
        return checkedInBy;
    }

    public void setCheckedInBy(String checkedInBy) {
        this.checkedInBy = checkedInBy;
    }

    public int getAssignedCourt() {
        if (assignedCourt > 0) return assignedCourt;
        if (assignedCourts != null && !assignedCourts.isEmpty()) return assignedCourts.get(0);
        return 0;
    }

    public void setAssignedCourt(int assignedCourt) {
        this.assignedCourt = assignedCourt;
        if (assignedCourt > 0 && (this.assignedCourts == null || this.assignedCourts.isEmpty())) {
            this.assignedCourts = new ArrayList<>(Collections.singletonList(assignedCourt));
        }
    }

    public List<Integer> getAssignedCourts() {
        if (assignedCourts != null && !assignedCourts.isEmpty()) {
            return Collections.unmodifiableList(assignedCourts);
        }
        if (assignedCourt > 0) {
            return Collections.singletonList(assignedCourt);
        }
        return Collections.emptyList();
    }

    public void setAssignedCourts(List<Integer> courts) {
        this.assignedCourts = courts != null ? new ArrayList<>(courts) : new ArrayList<>();
        if (!this.assignedCourts.isEmpty()) {
            this.assignedCourt = this.assignedCourts.get(0);
        } else {
            this.assignedCourt = 0;
        }
    }

    public int getCourtCount() {
        if (assignedCourts != null && !assignedCourts.isEmpty()) {
            return assignedCourts.size();
        }
        return assignedCourt > 0 ? 1 : 0;
    }

    public String getCourtsDisplay() {
        List<Integer> courts = getAssignedCourts();
        if (courts.isEmpty()) {
            return assignedCourt > 0 ? "Court #" + assignedCourt : "";
        }
        if (courts.size() == 1) {
            return "Court #" + courts.get(0);
        }
        StringBuilder sb = new StringBuilder("Courts ");
        for (int i = 0; i < courts.size(); i++) {
            if (i > 0) sb.append(", ");
            sb.append("#").append(courts.get(i));
        }
        return sb.toString();
    }

    public String getCourtsBadgeText() {
        List<Integer> courts = getAssignedCourts();
        if (courts.isEmpty()) {
            return assignedCourt > 0 ? "COURT #" + assignedCourt : "";
        }
        if (courts.size() == 1) {
            return "COURT #" + courts.get(0);
        }
        StringBuilder sb = new StringBuilder("COURTS: ");
        for (int i = 0; i < courts.size(); i++) {
            if (i > 0) sb.append(", ");
            sb.append("#").append(courts.get(i));
        }
        return sb.toString();
    }

    public String getTurfType() {
        return turfType;
    }

    public void setTurfType(String turfType) {
        this.turfType = turfType;
    }

    @Override
    public String toString() {
        return "Booking{" +
                "bookingId='" + bookingId + '\'' +
                ", userId='" + userId + '\'' +
                ", turfId='" + turfId + '\'' +
                ", bookingDate='" + bookingDate + '\'' +
                ", startTime='" + startTime + '\'' +
                ", endTime='" + endTime + '\'' +
                ", totalAmount=" + totalAmount +
                ", status=" + status +
                ", checkInStatus=" + checkInStatus +
                '}';
    }
}
