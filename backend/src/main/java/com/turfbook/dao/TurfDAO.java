package com.turfbook.dao;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import com.turfbook.enums.TurfStatus;
import com.turfbook.enums.TurfType;
import com.turfbook.model.Turf;
import com.turfbook.util.MongoDBConnection;
import org.bson.Document;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.logging.Logger;

public class TurfDAO {
    private static final Logger LOGGER = Logger.getLogger(TurfDAO.class.getName());

    public boolean createTurf(Turf turf) {
        try {
            MongoCollection<Document> col = MongoDBConnection.getTurfsCollection();
            Document loc = new Document()
                    .append("address", turf.getAddress())
                    .append("city", turf.getCity())
                    .append("state", turf.getState())
                    .append("postalCode", turf.getPostalCode())
                    .append("latitude", turf.getLatitude())
                    .append("longitude", turf.getLongitude());

            Document doc = new Document()
                    .append("turfId", turf.getTurfId())
                    .append("turfName", turf.getTurfName())
                    .append("description", turf.getDescription())
                    .append("location", loc)
                    .append("turfType", turf.getTurfType().name())
                    .append("pricePerHour", turf.getPricePerHour())
                    .append("capacity", turf.getCapacity())
                    .append("amenities", turf.getAmenities())
                    .append("imageUrl", turf.getImageUrl())
                    .append("bannerSubtitle", turf.getBannerSubtitle())
                    .append("galleryImage1", turf.getGalleryImage1())
                    .append("galleryCaption1", turf.getGalleryCaption1())
                    .append("galleryImage2", turf.getGalleryImage2())
                    .append("galleryCaption2", turf.getGalleryCaption2())
                    .append("status", turf.getStatus().name())
                    .append("createdAt", turf.getCreatedAt() != null ? turf.getCreatedAt() : new Date());

            // Badminton-specific fields
            if (turf.getTurfType() == com.turfbook.enums.TurfType.BADMINTON) {
                doc.append("courtCount", turf.getCourtCount() > 0 ? turf.getCourtCount() : 4)
                   .append("openingTime", turf.getOpeningTime() != null ? turf.getOpeningTime() : "07:00")
                   .append("closingTime", turf.getClosingTime() != null ? turf.getClosingTime() : "00:00")
                   .append("slotDurationMinutes", turf.getSlotDurationMinutes());
            }

            col.insertOne(doc);
            LOGGER.info("TurfDAO: Turf '" + turf.getTurfName() + "' created with ID: " + turf.getTurfId());
            return true;
        } catch (Exception e) {
            LOGGER.severe("TurfDAO.createTurf failed: " + e.getMessage());
            return false;
        }
    }

    public Turf findById(String turfId) {
        try {
            MongoCollection<Document> col = MongoDBConnection.getTurfsCollection();
            Document doc = col.find(Filters.eq("turfId", turfId)).first();
            return docToTurf(doc);
        } catch (Exception e) {
            LOGGER.severe("TurfDAO.findById failed: " + e.getMessage());
            return null;
        }
    }

    public List<Turf> findAll() {
        List<Turf> turfs = new ArrayList<>();
        try {
            MongoCollection<Document> col = MongoDBConnection.getTurfsCollection();
            for (Document doc : col.find()) {
                Turf t = docToTurf(doc);
                if (t != null) turfs.add(t);
            }
        } catch (Exception e) {
            LOGGER.severe("TurfDAO.findAll failed: " + e.getMessage());
        }
        return turfs;
    }

    public List<Turf> findAllActive() {
        List<Turf> turfs = new ArrayList<>();
        try {
            MongoCollection<Document> col = MongoDBConnection.getTurfsCollection();
            for (Document doc : col.find(Filters.eq("status", TurfStatus.ACTIVE.name()))) {
                Turf t = docToTurf(doc);
                if (t != null) turfs.add(t);
            }
        } catch (Exception e) {
            LOGGER.severe("TurfDAO.findAllActive failed: " + e.getMessage());
        }
        return turfs;
    }

    public List<Turf> searchTurfs(String query) {
        List<Turf> turfs = new ArrayList<>();
        try {
            MongoCollection<Document> col = MongoDBConnection.getTurfsCollection();
            Document filter = new Document("status", TurfStatus.ACTIVE.name())
                    .append("$or", Arrays.asList(
                            new Document("turfName", new Document("$regex", query).append("$options", "i")),
                            new Document("location.city", new Document("$regex", query).append("$options", "i")),
                            new Document("turfType", new Document("$regex", query).append("$options", "i"))
                    ));
            for (Document doc : col.find(filter)) {
                Turf t = docToTurf(doc);
                if (t != null) turfs.add(t);
            }
        } catch (Exception e) {
            LOGGER.severe("TurfDAO.searchTurfs failed: " + e.getMessage());
        }
        return turfs;
    }

    public List<Turf> findByType(String turfType) {
        List<Turf> turfs = new ArrayList<>();
        try {
            MongoCollection<Document> col = MongoDBConnection.getTurfsCollection();
            for (Document doc : col.find(Filters.and(
                    Filters.eq("status", TurfStatus.ACTIVE.name()),
                    Filters.eq("turfType", turfType)))) {
                Turf t = docToTurf(doc);
                if (t != null) turfs.add(t);
            }
        } catch (Exception e) {
            LOGGER.severe("TurfDAO.findByType failed: " + e.getMessage());
        }
        return turfs;
    }

    public boolean updateTurf(Turf turf) {
        try {
            MongoCollection<Document> col = MongoDBConnection.getTurfsCollection();
            Document loc = new Document()
                    .append("address", turf.getAddress())
                    .append("city", turf.getCity())
                    .append("state", turf.getState())
                    .append("postalCode", turf.getPostalCode())
                    .append("latitude", turf.getLatitude())
                    .append("longitude", turf.getLongitude());

            List<org.bson.conversions.Bson> updateFields = new java.util.ArrayList<>();
            updateFields.add(Updates.set("turfName", turf.getTurfName()));
            updateFields.add(Updates.set("description", turf.getDescription()));
            updateFields.add(Updates.set("location", loc));
            updateFields.add(Updates.set("turfType", turf.getTurfType().name()));
            updateFields.add(Updates.set("pricePerHour", turf.getPricePerHour()));
            updateFields.add(Updates.set("capacity", turf.getCapacity()));
            updateFields.add(Updates.set("amenities", turf.getAmenities()));
            updateFields.add(Updates.set("imageUrl", turf.getImageUrl()));
            updateFields.add(Updates.set("bannerSubtitle", turf.getBannerSubtitle()));
            updateFields.add(Updates.set("galleryImage1", turf.getGalleryImage1()));
            updateFields.add(Updates.set("galleryCaption1", turf.getGalleryCaption1()));
            updateFields.add(Updates.set("galleryImage2", turf.getGalleryImage2()));
            updateFields.add(Updates.set("galleryCaption2", turf.getGalleryCaption2()));
            updateFields.add(Updates.set("status", turf.getStatus().name()));

            // Badminton-specific fields
            if (turf.getTurfType() == com.turfbook.enums.TurfType.BADMINTON) {
                updateFields.add(Updates.set("courtCount", turf.getCourtCount() > 0 ? turf.getCourtCount() : 4));
                updateFields.add(Updates.set("openingTime", turf.getOpeningTime() != null ? turf.getOpeningTime() : "07:00"));
                updateFields.add(Updates.set("closingTime", turf.getClosingTime() != null ? turf.getClosingTime() : "00:00"));
                updateFields.add(Updates.set("slotDurationMinutes", turf.getSlotDurationMinutes()));
            }

            col.updateOne(
                    Filters.eq("turfId", turf.getTurfId()),
                    Updates.combine(updateFields)
            );
            return true;
        } catch (Exception e) {
            LOGGER.severe("TurfDAO.updateTurf failed: " + e.getMessage());
            return false;
        }
    }

    public boolean updateStatus(String turfId, TurfStatus status) {
        try {
            MongoDBConnection.getTurfsCollection().updateOne(
                    Filters.eq("turfId", turfId),
                    Updates.set("status", status.name())
            );
            return true;
        } catch (Exception e) {
            LOGGER.severe("TurfDAO.updateStatus failed: " + e.getMessage());
            return false;
        }
    }

    public long countActiveTurfs() {
        try {
            return MongoDBConnection.getTurfsCollection()
                    .countDocuments(Filters.eq("status", TurfStatus.ACTIVE.name()));
        } catch (Exception e) {
            return 0;
        }
    }

    @SuppressWarnings("unchecked")
    private Turf docToTurf(Document doc) {
        if (doc == null) return null;
        Turf turf = new Turf();
        turf.setTurfId(doc.getString("turfId"));
        turf.setTurfName(doc.getString("turfName"));
        turf.setDescription(doc.getString("description"));

        Document loc = doc.get("location", Document.class);
        if (loc != null) {
            turf.setAddress(loc.getString("address"));
            turf.setCity(loc.getString("city"));
            turf.setState(loc.getString("state"));
            turf.setPostalCode(loc.getString("postalCode"));
            Double lat = loc.getDouble("latitude");
            Double lng = loc.getDouble("longitude");
            if (lat != null) turf.setLatitude(lat);
            if (lng != null) turf.setLongitude(lng);
        }

        turf.setTurfType(TurfType.fromString(doc.getString("turfType")));
        Double price = doc.getDouble("pricePerHour");
        if (price != null) turf.setPricePerHour(price);
        Integer cap = doc.getInteger("capacity");
        if (cap != null) turf.setCapacity(cap);

        Object amenitiesObj = doc.get("amenities");
        if (amenitiesObj instanceof List) {
            turf.setAmenities((List<String>) amenitiesObj);
        }

        turf.setImageUrl(doc.getString("imageUrl"));
        turf.setBannerSubtitle(doc.getString("bannerSubtitle"));
        turf.setGalleryImage1(doc.getString("galleryImage1"));
        turf.setGalleryCaption1(doc.getString("galleryCaption1"));
        turf.setGalleryImage2(doc.getString("galleryImage2"));
        turf.setGalleryCaption2(doc.getString("galleryCaption2"));
        turf.setStatus(TurfStatus.fromString(doc.getString("status")));
        turf.setCreatedAt(doc.getDate("createdAt"));

        // Badminton fields (backward-compatible)
        Integer courtCount = doc.getInteger("courtCount");
        if (courtCount != null) turf.setCourtCount(courtCount);
        String openingTime = doc.getString("openingTime");
        if (openingTime != null) turf.setOpeningTime(openingTime);
        String closingTime = doc.getString("closingTime");
        if (closingTime != null) turf.setClosingTime(closingTime);
        Integer slotDuration = doc.getInteger("slotDurationMinutes");
        if (slotDuration != null) turf.setSlotDurationMinutes(slotDuration);
        // Defaults for badminton if not configured
        if (turf.isBadminton()) {
            if (turf.getCourtCount() <= 0) turf.setCourtCount(4);
            if (turf.getOpeningTime() == null) turf.setOpeningTime("07:00");
            if (turf.getClosingTime() == null) turf.setClosingTime("00:00");
            if (turf.getSlotDurationMinutes() <= 0) turf.setSlotDurationMinutes(60);
        }

        return turf;
    }
}
