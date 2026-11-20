package com.turfbook.admin;

import com.turfbook.enums.TurfStatus;
import com.turfbook.enums.TurfType;
import com.turfbook.model.Turf;
import com.turfbook.service.TurfService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Logger;
import java.util.stream.Collectors;

@WebServlet("/admin/turf")
public class AdminTurfServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminTurfServlet.class.getName());
    private final TurfService turfService = new TurfService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String turfId = req.getParameter("id");

        try {
            if ("edit".equals(action) && turfId != null) {
                Turf turf = turfService.getTurfById(turfId);
                if (turf == null) {
                    resp.sendRedirect(req.getContextPath() + "/admin/turfs.jsp?error=Turf+not+found");
                    return;
                }
                req.setAttribute("turf", turf);
                req.setAttribute("turfTypes", TurfType.values());
                req.setAttribute("turfStatuses", TurfStatus.values());
                req.getRequestDispatcher("/admin/edit-turf.jsp").forward(req, resp);
            } else if ("deactivate".equals(action) && turfId != null) {
                boolean ok = turfService.deactivateTurf(turfId);
                String msg = ok ? "Turf+deactivated+successfully" : "Failed+to+deactivate+turf";
                resp.sendRedirect(req.getContextPath() + "/admin/turf?action=list&" + (ok ? "success=" : "error=") + msg);
            } else if ("activate".equals(action) && turfId != null) {
                boolean ok = turfService.activateTurf(turfId);
                String msg = ok ? "Turf+activated+successfully" : "Failed+to+activate+turf";
                resp.sendRedirect(req.getContextPath() + "/admin/turf?action=list&" + (ok ? "success=" : "error=") + msg);
            } else if ("add".equals(action)) {
                req.setAttribute("turfTypes", TurfType.values());
                req.setAttribute("turfStatuses", TurfStatus.values());
                req.getRequestDispatcher("/admin/add-turf.jsp").forward(req, resp);
            } else {
                // List all turfs
                List<Turf> turfs = turfService.getAllTurfs();
                req.setAttribute("turfs", turfs);
                req.setAttribute("turfTypes", TurfType.values());
                req.getRequestDispatcher("/admin/turfs.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            LOGGER.severe("AdminTurfServlet GET error: " + e.getMessage());
            req.setAttribute("error", "An error occurred: " + e.getMessage());
            req.getRequestDispatcher("/admin/turfs.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("add".equals(action)) {
            handleAddTurf(req, resp);
        } else if ("edit".equals(action)) {
            handleEditTurf(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/turf?action=list");
        }
    }

    private void handleAddTurf(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String turfName = req.getParameter("turfName");
        if (turfName == null || turfName.trim().isEmpty()) {
            turfName = req.getParameter("name");
        }
        String description = req.getParameter("description");
        String turfType = req.getParameter("turfType");
        if (turfType == null || turfType.trim().isEmpty()) {
            turfType = req.getParameter("type");
        }
        String priceStr = req.getParameter("pricePerHour");
        String capacityStr = req.getParameter("capacity");
        String address = req.getParameter("address");
        String city = req.getParameter("city");
        String state = req.getParameter("state");
        String postalCode = req.getParameter("postalCode");
        String latStr = req.getParameter("latitude");
        String lngStr = req.getParameter("longitude");
        String amenitiesStr = req.getParameter("amenities");
        String imageUrl = req.getParameter("imageUrl");
        String bannerSubtitle = req.getParameter("bannerSubtitle");
        String galleryImage1 = req.getParameter("galleryImage1");
        String galleryCaption1 = req.getParameter("galleryCaption1");
        String galleryImage2 = req.getParameter("galleryImage2");
        String galleryCaption2 = req.getParameter("galleryCaption2");
        String statusStr = req.getParameter("status");

        try {
            double price = Double.parseDouble(priceStr != null && !priceStr.trim().isEmpty() ? priceStr.trim() : "1000");
            int capacity = (capacityStr != null && !capacityStr.trim().isEmpty()) ? Integer.parseInt(capacityStr.trim()) : 14;
            if (capacity <= 0) capacity = 14;
            double latitude = Double.parseDouble(latStr != null && !latStr.trim().isEmpty() ? latStr.trim() : "12.9716");
            double longitude = Double.parseDouble(lngStr != null && !lngStr.trim().isEmpty() ? lngStr.trim() : "77.5946");

            if (city == null || city.trim().isEmpty()) city = "Bengaluru";
            if (state == null || state.trim().isEmpty()) state = "Karnataka";
            if (postalCode == null || postalCode.trim().isEmpty()) postalCode = "560001";
            if (address == null || address.trim().isEmpty()) address = city;
            if (statusStr == null || statusStr.trim().isEmpty()) statusStr = "ACTIVE";
            if (imageUrl == null || imageUrl.trim().isEmpty()) {
                imageUrl = "https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=800&auto=format&fit=crop&q=80";
            }

            List<String> amenities = Arrays.stream(
                    (amenitiesStr != null ? amenitiesStr : "").split(","))
                    .map(String::trim)
                    .filter(s -> !s.isEmpty())
                    .collect(Collectors.toList());

            Turf created = turfService.addTurf(turfName, description, turfType, price, capacity,
                    address, city, state, postalCode, latitude, longitude, amenities, imageUrl, statusStr);

            // Photography and Banner fields
            created.setBannerSubtitle(bannerSubtitle);
            created.setGalleryImage1(galleryImage1);
            created.setGalleryCaption1(galleryCaption1);
            created.setGalleryImage2(galleryImage2);
            created.setGalleryCaption2(galleryCaption2);

            // Badminton-specific fields
            if ("BADMINTON".equalsIgnoreCase(turfType)) {
                String courtCountStr = req.getParameter("courtCount");
                String openingTime   = req.getParameter("openingTime");
                String closingTime   = req.getParameter("closingTime");
                String slotDurStr    = req.getParameter("slotDurationMinutes");
                created.setCourtCount(courtCountStr != null && !courtCountStr.isEmpty() ? Integer.parseInt(courtCountStr.trim()) : 4);
                created.setOpeningTime(openingTime != null && !openingTime.isEmpty() ? openingTime.trim() : "07:00");
                created.setClosingTime(closingTime != null && !closingTime.isEmpty() ? closingTime.trim() : "00:00");
                created.setSlotDurationMinutes(slotDurStr != null && !slotDurStr.isEmpty() ? Integer.parseInt(slotDurStr.trim()) : 60);
            }

            turfService.updateTurf(created);

            LOGGER.info("Admin added turf: " + created.getTurfName() + " ID=" + created.getTurfId());
            resp.sendRedirect(req.getContextPath() + "/admin/turf?action=list&success=Turf+'" +
                    java.net.URLEncoder.encode(created.getTurfName(), "UTF-8") + "'+added+successfully");

        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid numeric values for price, capacity, or coordinates.");
            req.setAttribute("turfTypes", TurfType.values());
            req.setAttribute("turfStatuses", TurfStatus.values());
            req.getRequestDispatcher("/admin/add-turf.jsp").forward(req, resp);
        } catch (Exception e) {
            LOGGER.severe("AdminTurfServlet.handleAddTurf error: " + e.getMessage());
            req.setAttribute("error", "Unable to add turf: " + e.getMessage());
            req.setAttribute("turfTypes", TurfType.values());
            req.setAttribute("turfStatuses", TurfStatus.values());
            req.getRequestDispatcher("/admin/add-turf.jsp").forward(req, resp);
        }
    }

    private void handleEditTurf(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String turfId = req.getParameter("turfId");
        if (turfId == null || turfId.trim().isEmpty()) {
            turfId = req.getParameter("id");
        }
        String turfName = req.getParameter("turfName");
        if (turfName == null || turfName.trim().isEmpty()) {
            turfName = req.getParameter("name");
        }
        String description = req.getParameter("description");
        String turfType = req.getParameter("turfType");
        if (turfType == null || turfType.trim().isEmpty()) {
            turfType = req.getParameter("type");
        }
        String priceStr = req.getParameter("pricePerHour");
        String capacityStr = req.getParameter("capacity");
        String address = req.getParameter("address");
        String city = req.getParameter("city");
        String state = req.getParameter("state");
        String postalCode = req.getParameter("postalCode");
        String latStr = req.getParameter("latitude");
        String lngStr = req.getParameter("longitude");
        String amenitiesStr = req.getParameter("amenities");
        String imageUrl = req.getParameter("imageUrl");
        String bannerSubtitle = req.getParameter("bannerSubtitle");
        String galleryImage1 = req.getParameter("galleryImage1");
        String galleryCaption1 = req.getParameter("galleryCaption1");
        String galleryImage2 = req.getParameter("galleryImage2");
        String galleryCaption2 = req.getParameter("galleryCaption2");
        String statusStr = req.getParameter("status");

        try {
            Turf turf = new Turf();
            turf.setTurfId(turfId);
            turf.setTurfName(turfName);
            turf.setDescription(description);
            turf.setTurfType(TurfType.fromString(turfType));
            turf.setPricePerHour(Double.parseDouble(priceStr != null && !priceStr.trim().isEmpty() ? priceStr.trim() : "1000"));
            int capacity = (capacityStr != null && !capacityStr.trim().isEmpty()) ? Integer.parseInt(capacityStr.trim()) : 14;
            if (capacity <= 0) capacity = 14;
            turf.setCapacity(capacity);
            turf.setAddress(address);
            turf.setCity(city != null && !city.trim().isEmpty() ? city.trim() : "Bengaluru");
            turf.setState(state != null && !state.trim().isEmpty() ? state.trim() : "Karnataka");
            turf.setPostalCode(postalCode != null && !postalCode.trim().isEmpty() ? postalCode.trim() : "560001");
            turf.setLatitude(Double.parseDouble(latStr != null && !latStr.trim().isEmpty() ? latStr.trim() : "12.9716"));
            turf.setLongitude(Double.parseDouble(lngStr != null && !lngStr.trim().isEmpty() ? lngStr.trim() : "77.5946"));
            turf.setAmenities(Arrays.stream(
                    (amenitiesStr != null ? amenitiesStr : "").split(","))
                    .map(String::trim).filter(s -> !s.isEmpty()).collect(Collectors.toList()));
            turf.setImageUrl(imageUrl);
            turf.setBannerSubtitle(bannerSubtitle);
            turf.setGalleryImage1(galleryImage1);
            turf.setGalleryCaption1(galleryCaption1);
            turf.setGalleryImage2(galleryImage2);
            turf.setGalleryCaption2(galleryCaption2);
            turf.setStatus(TurfStatus.fromString(statusStr));

            // Badminton-specific fields
            if (turf.getTurfType() == TurfType.BADMINTON) {
                String courtCountStr = req.getParameter("courtCount");
                String openingTime   = req.getParameter("openingTime");
                String closingTime   = req.getParameter("closingTime");
                String slotDurStr    = req.getParameter("slotDurationMinutes");
                turf.setCourtCount(courtCountStr != null && !courtCountStr.isEmpty() ? Integer.parseInt(courtCountStr.trim()) : 4);
                turf.setOpeningTime(openingTime != null && !openingTime.isEmpty() ? openingTime.trim() : "07:00");
                turf.setClosingTime(closingTime != null && !closingTime.isEmpty() ? closingTime.trim() : "00:00");
                turf.setSlotDurationMinutes(slotDurStr != null && !slotDurStr.isEmpty() ? Integer.parseInt(slotDurStr.trim()) : 60);
            }

            boolean updated = turfService.updateTurf(turf);
            if (!updated) throw new Exception("Update failed — please try again.");
            resp.sendRedirect(req.getContextPath() + "/admin/turf?action=list&success=Turf+updated+successfully");

        } catch (Exception e) {
            LOGGER.severe("AdminTurfServlet.handleEditTurf error: " + e.getMessage());
            Turf existing = turfService.getTurfById(turfId);
            req.setAttribute("turf", existing);
            req.setAttribute("error", "Unable to update turf: " + e.getMessage());
            req.setAttribute("turfTypes", TurfType.values());
            req.setAttribute("turfStatuses", TurfStatus.values());
            req.getRequestDispatcher("/admin/edit-turf.jsp").forward(req, resp);
        }
    }
}
