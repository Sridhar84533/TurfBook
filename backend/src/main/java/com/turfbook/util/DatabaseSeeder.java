package com.turfbook.util;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.IndexOptions;
import com.mongodb.client.model.Indexes;
import com.turfbook.enums.TurfStatus;
import com.turfbook.enums.TurfType;
import com.turfbook.enums.UserRole;
import org.bson.Document;

import java.util.Arrays;
import java.util.Date;
import java.util.UUID;
import java.util.logging.Logger;

public class DatabaseSeeder {
    private static final Logger LOGGER = Logger.getLogger(DatabaseSeeder.class.getName());
    private static boolean seeded = false;

    public static synchronized void seedIfEmpty() {
        if (seeded) return;
        try {
            if (!MongoDBConnection.isConnected()) {
                LOGGER.warning("MongoDB not connected. Skipping seeding.");
                return;
            }

            MongoCollection<Document> usersCol = MongoDBConnection.getUsersCollection();
            MongoCollection<Document> turfsCol = MongoDBConnection.getTurfsCollection();

            // Create unique indices idempotently
            usersCol.createIndex(Indexes.ascending("username"), new IndexOptions().unique(true));
            usersCol.createIndex(Indexes.ascending("email"), new IndexOptions().unique(true));
            turfsCol.createIndex(Indexes.ascending("turfId"), new IndexOptions().unique(true));

            // Seed Admin User if not present
            if (usersCol.countDocuments(Filters.eq("role", "ADMIN")) == 0) {
                LOGGER.info("Seeding default Administrator account...");
                Document adminDoc = new Document()
                        .append("userId", "ADMIN-" + UUID.randomUUID().toString().substring(0, 8))
                        .append("username", "admin")
                        .append("passwordHash", PasswordUtil.hashPassword("Admin@123"))
                        .append("email", "admin@turfbook.in")
                        .append("phone", "9876543210")
                        .append("role", UserRole.ADMIN.name())
                        .append("createdAt", new Date())
                        .append("updatedAt", new Date());
                usersCol.insertOne(adminDoc);
            }

            // Seed Player User if not present
            if (usersCol.countDocuments(Filters.eq("username", "alex_striker")) == 0) {
                LOGGER.info("Seeding sample player account: alex_striker...");
                Document playerDoc = new Document()
                        .append("userId", "USER-" + UUID.randomUUID().toString().substring(0, 8))
                        .append("username", "alex_striker")
                        .append("passwordHash", PasswordUtil.hashPassword("Player@123"))
                        .append("email", "alex.morgan@sportsmail.com")
                        .append("phone", "9876543211")
                        .append("role", UserRole.USER.name())
                        .append("createdAt", new Date())
                        .append("updatedAt", new Date());
                usersCol.insertOne(playerDoc);
            }

            // Seed Initial Turfs if empty
            if (turfsCol.countDocuments() == 0) {
                LOGGER.info("Seeding initial verified sports turfs...");

                Document t1 = createTurfDoc(
                        "TURF-101",
                        "Green Arena Sports Hub",
                        "FIFA 2-Star Quality Pro floodlit artificial turf suitable for 7v7 and 5v5 football with pristine grass condition and full match amenities.",
                        "Koramangala 4th Block, Near Sony World Signal",
                        "Bengaluru",
                        "Karnataka",
                        "560034",
                        12.9352,
                        77.6245,
                        TurfType.FOOTBALL_7V7.name(),
                        1200.0,
                        14,
                        Arrays.asList("FIFA Certified Turf", "Floodlights", "Changing Rooms", "Locker Room", "Free Parking", "Drinking Water", "First Aid"),
                        "https://images.unsplash.com/photo-1529900748604-07564a03e7a6?auto=format&fit=crop&w=1200&q=80",
                        TurfStatus.ACTIVE.name()
                );

                Document t2 = createTurfDoc(
                        "TURF-102",
                        "Kickoff Futsal Arena",
                        "High-speed shock-absorbing rubber infill pitch ideal for fast 5v5 action and corporate tournaments.",
                        "Indiranagar 100ft Road",
                        "Bengaluru",
                        "Karnataka",
                        "560038",
                        12.9719,
                        77.6412,
                        TurfType.FOOTBALL_5V5.name(),
                        950.0,
                        10,
                        Arrays.asList("Shock Absorption Turf", "Floodlights", "Cafeteria", "Shower Facility", "Bibs & Balls Provided"),
                        "https://images.unsplash.com/photo-1575361204480-aadea25e6e68?auto=format&fit=crop&w=1200&q=80",
                        TurfStatus.ACTIVE.name()
                );

                Document t3 = createTurfDoc(
                        "TURF-103",
                        "Smashbox Cricket Ground",
                        "Enclosed all-weather premium box cricket arena with high rebound nets, digital scoring board, and match commentary setup.",
                        "HSR Layout Sector 2",
                        "Bengaluru",
                        "Karnataka",
                        "560102",
                        12.9121,
                        77.6446,
                        TurfType.BOX_CRICKET.name(),
                        1100.0,
                        16,
                        Arrays.asList("Enclosed Box Net", "Digital Scoreboard", "Floodlights", "Cricket Bats & Balls", "Seating Dugouts"),
                        "https://images.unsplash.com/photo-1531415074868-036b1c57e329?auto=format&fit=crop&w=1200&q=80",
                        TurfStatus.ACTIVE.name()
                );

                Document t4 = createTurfDoc(
                        "TURF-104",
                        "PlayArena Multi-Sport Dome",
                        "Versatile sports facility accommodating badminton, paddle tennis, and 5-a-side football with tournament-grade illumination.",
                        "Sarjapur Main Road, Kasavanahalli",
                        "Bengaluru",
                        "Karnataka",
                        "560035",
                        12.9081,
                        77.6835,
                        TurfType.MULTI_SPORT.name(),
                        1400.0,
                        20,
                        Arrays.asList("Indoor Airflow", "Equipment Rental", "Pro Coaching Available", "Locker Room", "Cafe Lounge"),
                        "https://images.unsplash.com/photo-1511886929837-354d827aae26?auto=format&fit=crop&w=1200&q=80",
                        TurfStatus.ACTIVE.name()
                );

                turfsCol.insertMany(Arrays.asList(t1, t2, t3, t4));
                LOGGER.info("Seeded 4 default turfs successfully.");
            }

            seeded = true;
        } catch (Exception e) {
            LOGGER.warning("Database seeding error: " + e.getMessage());
        }
    }

    private static Document createTurfDoc(String turfId, String name, String desc, String address, String city,
                                          String state, String postalCode, double lat, double lng, String turfType,
                                          double price, int capacity, java.util.List<String> amenities,
                                          String imageUrl, String status) {
        Document loc = new Document()
                .append("address", address)
                .append("city", city)
                .append("state", state)
                .append("postalCode", postalCode)
                .append("latitude", lat)
                .append("longitude", lng);

        return new Document()
                .append("turfId", turfId)
                .append("turfName", name)
                .append("description", desc)
                .append("location", loc)
                .append("turfType", turfType)
                .append("pricePerHour", price)
                .append("capacity", capacity)
                .append("amenities", amenities)
                .append("imageUrl", imageUrl)
                .append("status", status)
                .append("createdAt", new Date());
    }
}
