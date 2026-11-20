package com.turfbook.service;

import com.turfbook.dao.TurfDAO;
import com.turfbook.enums.TurfStatus;
import com.turfbook.enums.TurfType;
import com.turfbook.exception.DatabaseException;
import com.turfbook.model.Turf;

import java.util.List;
import java.util.UUID;
import java.util.logging.Logger;

public class TurfService {
    private static final Logger LOGGER = Logger.getLogger(TurfService.class.getName());
    private final TurfDAO turfDAO = new TurfDAO();

    public Turf addTurf(String turfName, String description, String turfTypeStr, double pricePerHour, int capacity,
                        String address, String city, String state, String postalCode, double latitude, double longitude,
                        List<String> amenities, String imageUrl, String statusStr) throws Exception {

        // Validate required fields
        if (turfName == null || turfName.trim().isEmpty()) throw new Exception("Turf name is required.");
        if (pricePerHour <= 0) throw new Exception("Price per hour must be a positive number.");
        if (capacity <= 0) throw new Exception("Capacity must be a positive number.");
        if (city == null || city.trim().isEmpty()) throw new Exception("City is required.");
        if (latitude < -90 || latitude > 90) throw new Exception("Latitude must be between -90 and 90.");
        if (longitude < -180 || longitude > 180) throw new Exception("Longitude must be between -180 and 180.");
        if (postalCode != null && !postalCode.trim().isEmpty() && !postalCode.trim().matches("^\\d{5,6}$")) {
            throw new Exception("Postal code must be 5-6 digits.");
        }

        Turf turf = new Turf();
        turf.setTurfId("TURF-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        turf.setTurfName(turfName.trim());
        turf.setDescription(description != null ? description.trim() : "");
        turf.setTurfType(TurfType.fromString(turfTypeStr));
        turf.setPricePerHour(pricePerHour);
        turf.setCapacity(capacity);
        turf.setAddress(address != null ? address.trim() : "");
        turf.setCity(city.trim());
        turf.setState(state != null ? state.trim() : "");
        turf.setPostalCode(postalCode != null ? postalCode.trim() : "");
        turf.setLatitude(latitude);
        turf.setLongitude(longitude);
        turf.setAmenities(amenities);
        turf.setImageUrl(imageUrl != null ? imageUrl.trim() : "");
        turf.setStatus(TurfStatus.fromString(statusStr));

        boolean created = turfDAO.createTurf(turf);
        if (!created) throw new DatabaseException("Failed to save turf to the database. Please try again.");
        LOGGER.info("Created turf: " + turf.getTurfId() + " (" + turf.getTurfName() + ")");
        return turf;
    }

    public boolean updateTurf(Turf turf) throws Exception {
        if (turf.getTurfId() == null || turf.getTurfId().trim().isEmpty()) {
            throw new Exception("Turf ID is required for update.");
        }
        if (turf.getTurfName() == null || turf.getTurfName().trim().isEmpty()) {
            throw new Exception("Turf name cannot be empty.");
        }
        if (turf.getPricePerHour() <= 0) throw new Exception("Price per hour must be positive.");
        if (turf.getCapacity() <= 0) throw new Exception("Capacity must be positive.");

        boolean updated = turfDAO.updateTurf(turf);
        if (updated) {
            LOGGER.info("Updated turf: " + turf.getTurfId());
        }
        return updated;
    }

    public boolean deactivateTurf(String turfId) throws DatabaseException {
        return turfDAO.updateStatus(turfId, TurfStatus.INACTIVE);
    }

    public boolean activateTurf(String turfId) throws DatabaseException {
        return turfDAO.updateStatus(turfId, TurfStatus.ACTIVE);
    }

    public List<Turf> getAllTurfs() {
        return turfDAO.findAll();
    }

    public List<Turf> getAllActiveTurfs() {
        return turfDAO.findAllActive();
    }

    public Turf getTurfById(String turfId) {
        return turfDAO.findById(turfId);
    }

    public List<Turf> searchTurfs(String query) {
        if (query == null || query.trim().isEmpty()) return turfDAO.findAllActive();
        return turfDAO.searchTurfs(query.trim());
    }

    public List<Turf> filterByType(String turfType) {
        if (turfType == null || turfType.trim().isEmpty()) return turfDAO.findAllActive();
        return turfDAO.findByType(turfType.trim().toUpperCase());
    }
}
