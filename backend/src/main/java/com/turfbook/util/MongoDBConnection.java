package com.turfbook.util;

import com.mongodb.ConnectionString;
import com.mongodb.MongoClientSettings;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

import java.io.InputStream;
import java.util.Properties;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Centralized, singleton MongoDB Connection Manager.
 * Ensures a single shared MongoClient instance across the entire application lifecycle.
 */
public class MongoDBConnection {
    private static final Logger LOGGER = Logger.getLogger(MongoDBConnection.class.getName());

    private static MongoClient mongoClient;
    private static MongoDatabase database;

    private static String mongoUri = "mongodb://localhost:27017";
    private static String databaseName = "turf_booking_db";

    static {
        loadConfiguration();
        initializeClient();
    }

    private MongoDBConnection() {
        // Prevent direct instantiation
    }

    private static void loadConfiguration() {
        try {
            InputStream input = null;
            ClassLoader cl = Thread.currentThread().getContextClassLoader();
            if (cl != null) {
                input = cl.getResourceAsStream("application.properties");
            }
            if (input == null) {
                input = MongoDBConnection.class.getResourceAsStream("/application.properties");
            }
            if (input == null) {
                input = MongoDBConnection.class.getClassLoader().getResourceAsStream("application.properties");
            }

            if (input != null) {
                Properties props = new Properties();
                props.load(input);
                if (props.getProperty("mongodb.uri") != null && !props.getProperty("mongodb.uri").trim().isEmpty()) {
                    mongoUri = props.getProperty("mongodb.uri").trim();
                }
                if (props.getProperty("mongodb.database") != null && !props.getProperty("mongodb.database").trim().isEmpty()) {
                    databaseName = props.getProperty("mongodb.database").trim();
                }
                input.close();
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to load application.properties; proceeding with default connection settings.", e);
        }
    }

    private static synchronized void initializeClient() {
        try {
            LOGGER.info("Initializing MongoDB Client for URI: " + mongoUri + ", Database: " + databaseName);
            MongoClientSettings settings = MongoClientSettings.builder()
                    .applyConnectionString(new ConnectionString(mongoUri))
                    .applyToSocketSettings(builder -> builder.connectTimeout(5000, TimeUnit.MILLISECONDS))
                    .applyToClusterSettings(builder -> builder.serverSelectionTimeout(5000, TimeUnit.MILLISECONDS))
                    .build();

            mongoClient = MongoClients.create(settings);
            database = mongoClient.getDatabase(databaseName);

            // Verify connectivity
            database.runCommand(new Document("ping", 1));
            LOGGER.info("Database connection successful: connected to MongoDB '" + databaseName + "'.");

            // Register JVM shutdown hook
            Runtime.getRuntime().addShutdownHook(new Thread(MongoDBConnection::close));
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Database connection failed! Could not reach MongoDB at: " + mongoUri, e);
        }
    }

    public static synchronized MongoDatabase getDatabase() {
        if (mongoClient == null || database == null) {
            initializeClient();
        }
        return database;
    }

    public static boolean isConnected() {
        try {
            MongoDatabase db = getDatabase();
            if (db != null) {
                db.runCommand(new Document("ping", 1));
                return true;
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "MongoDB health check ping failed: " + e.getMessage());
        }
        return false;
    }

    public static MongoCollection<Document> getCollection(String collectionName) {
        MongoDatabase db = getDatabase();
        if (db == null) {
            throw new IllegalStateException("MongoDB is unavailable. Database connection could not be established.");
        }
        return db.getCollection(collectionName);
    }

    public static MongoCollection<Document> getUsersCollection() {
        return getCollection("users");
    }

    public static MongoCollection<Document> getTurfsCollection() {
        return getCollection("turfs");
    }

    public static MongoCollection<Document> getBookingsCollection() {
        return getCollection("bookings");
    }

    public static MongoCollection<Document> getPaymentsCollection() {
        return getCollection("payments");
    }

    public static MongoCollection<Document> getReviewsCollection() {
        return getCollection("reviews");
    }

    public static MongoCollection<Document> getNotificationsCollection() {
        return getCollection("notifications");
    }

    public static synchronized void close() {
        if (mongoClient != null) {
            try {
                mongoClient.close();
                LOGGER.info("MongoDB client connection gracefully closed.");
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Error closing MongoDB client", e);
            } finally {
                mongoClient = null;
                database = null;
            }
        }
    }
}
