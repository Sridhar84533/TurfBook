package com.turfbook.model;

import com.turfbook.enums.TurfStatus;
import com.turfbook.enums.TurfType;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Turf implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private String turfId;
    private String turfName;
    private String description;

    // Location Subdocument fields
    private String address;
    private String city;
    private String state;
    private String postalCode;
    private double latitude;
    private double longitude;

    private TurfType turfType;
    private double pricePerHour;
    private int capacity;
    private List<String> amenities;
    private String imageUrl;
    private TurfStatus status;
    private Date createdAt;

    // Badminton-specific court configuration (only for BADMINTON turfType)
    private int courtCount;            // e.g. 4
    private String openingTime;        // e.g. "07:00"
    private String closingTime;        // e.g. "00:00"  (midnight = next day)
    private int slotDurationMinutes;   // e.g. 60

    // Photography & Banner details
    private String bannerSubtitle;     // e.g. "500 Lux anti-glare floodlights with shock-padded monofilament turf"
    private String galleryImage1;      // Secondary Photo 1 (URL or Base64)
    private String galleryCaption1;    // Caption for Photo 1 (e.g. "Perimeter Netting" or "Court View")
    private String galleryImage2;      // Secondary Photo 2 (URL or Base64)
    private String galleryCaption2;    // Caption for Photo 2 (e.g. "Locker & Showers" or "Warm-up Area")

    public Turf() {
        this.amenities = new ArrayList<>();
        this.turfType = TurfType.MULTI_SPORT;
        this.status = TurfStatus.ACTIVE;
        this.createdAt = new Date();
    }

    public Turf(String turfId, String turfName, String description, String address, String city, String state,
                String postalCode, double latitude, double longitude, TurfType turfType, double pricePerHour,
                int capacity, List<String> amenities, String imageUrl, TurfStatus status) {
        this.turfId = turfId;
        this.turfName = turfName != null ? turfName.trim() : "";
        this.description = description != null ? description.trim() : "";
        this.address = address != null ? address.trim() : "";
        this.city = city != null ? city.trim() : "";
        this.state = state != null ? state.trim() : "";
        this.postalCode = postalCode != null ? postalCode.trim() : "";
        this.latitude = latitude;
        this.longitude = longitude;
        this.turfType = turfType != null ? turfType : TurfType.MULTI_SPORT;
        this.pricePerHour = pricePerHour;
        this.capacity = capacity;
        this.amenities = amenities != null ? amenities : new ArrayList<>();
        this.imageUrl = imageUrl != null ? imageUrl.trim() : "";
        this.status = status != null ? status : TurfStatus.ACTIVE;
        this.createdAt = new Date();
    }

    public String getTurfId() {
        return turfId;
    }

    public void setTurfId(String turfId) {
        this.turfId = turfId;
    }

    public String getTurfName() {
        return turfName;
    }

    public void setTurfName(String turfName) {
        this.turfName = turfName != null ? turfName.trim() : "";
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description != null ? description.trim() : "";
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address != null ? address.trim() : "";
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city != null ? city.trim() : "";
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state != null ? state.trim() : "";
    }

    public String getPostalCode() {
        return postalCode;
    }

    public void setPostalCode(String postalCode) {
        this.postalCode = postalCode != null ? postalCode.trim() : "";
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public TurfType getTurfType() {
        return turfType;
    }

    public void setTurfType(TurfType turfType) {
        this.turfType = turfType != null ? turfType : TurfType.MULTI_SPORT;
    }

    public double getPricePerHour() {
        return pricePerHour;
    }

    public void setPricePerHour(double pricePerHour) {
        this.pricePerHour = pricePerHour;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public List<String> getAmenities() {
        return amenities;
    }

    public void setAmenities(List<String> amenities) {
        this.amenities = amenities != null ? amenities : new ArrayList<>();
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl != null ? imageUrl.trim() : "";
    }

    public TurfStatus getStatus() {
        return status;
    }

    public void setStatus(TurfStatus status) {
        this.status = status != null ? status : TurfStatus.ACTIVE;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getFullLocation() {
        return address + ", " + city + ", " + state + " - " + postalCode;
    }

    public int getCourtCount() { return courtCount; }
    public void setCourtCount(int courtCount) { this.courtCount = courtCount; }

    public String getOpeningTime() { return openingTime; }
    public void setOpeningTime(String openingTime) { this.openingTime = openingTime; }

    public String getClosingTime() { return closingTime; }
    public void setClosingTime(String closingTime) { this.closingTime = closingTime; }

    public int getSlotDurationMinutes() { return slotDurationMinutes > 0 ? slotDurationMinutes : 60; }
    public void setSlotDurationMinutes(int slotDurationMinutes) { this.slotDurationMinutes = slotDurationMinutes; }

    public boolean isBadminton() {
        return this.turfType == TurfType.BADMINTON;
    }

    public String getBannerSubtitle() { return bannerSubtitle; }
    public void setBannerSubtitle(String bannerSubtitle) { this.bannerSubtitle = bannerSubtitle != null ? bannerSubtitle.trim() : ""; }

    public String getGalleryImage1() { return galleryImage1; }
    public void setGalleryImage1(String galleryImage1) { this.galleryImage1 = galleryImage1 != null ? galleryImage1.trim() : ""; }

    public String getGalleryCaption1() { return galleryCaption1; }
    public void setGalleryCaption1(String galleryCaption1) { this.galleryCaption1 = galleryCaption1 != null ? galleryCaption1.trim() : ""; }

    public String getGalleryImage2() { return galleryImage2; }
    public void setGalleryImage2(String galleryImage2) { this.galleryImage2 = galleryImage2 != null ? galleryImage2.trim() : ""; }

    public String getGalleryCaption2() { return galleryCaption2; }
    public void setGalleryCaption2(String galleryCaption2) { this.galleryCaption2 = galleryCaption2 != null ? galleryCaption2.trim() : ""; }

    public boolean isValid() {
        return turfName != null && !turfName.trim().isEmpty() &&
               city != null && !city.trim().isEmpty() &&
               pricePerHour > 0 && capacity > 0 &&
               latitude >= -90.0 && latitude <= 90.0 &&
               longitude >= -180.0 && longitude <= 180.0;
    }

    @Override
    public String toString() {
        return "Turf{" +
                "turfId='" + turfId + '\'' +
                ", turfName='" + turfName + '\'' +
                ", turfType=" + turfType +
                ", city='" + city + '\'' +
                ", pricePerHour=" + pricePerHour +
                ", capacity=" + capacity +
                ", status=" + status +
                '}';
    }
}
