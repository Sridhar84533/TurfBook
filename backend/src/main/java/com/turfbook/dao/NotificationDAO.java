package com.turfbook.dao;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Sorts;
import com.mongodb.client.model.Updates;
import com.turfbook.model.Notification;
import com.turfbook.util.MongoDBConnection;
import org.bson.Document;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.logging.Logger;

public class NotificationDAO {
    private static final Logger LOGGER = Logger.getLogger(NotificationDAO.class.getName());

    public boolean createNotification(Notification notification) {
        try {
            if (notification.getId() == null || notification.getId().isEmpty()) {
                notification.setId(UUID.randomUUID().toString());
            }
            if (notification.getCreatedAt() == null) {
                notification.setCreatedAt(new Date());
            }

            MongoCollection<Document> col = MongoDBConnection.getNotificationsCollection();
            Document doc = new Document()
                    .append("id", notification.getId())
                    .append("userId", notification.getUserId())
                    .append("title", notification.getTitle())
                    .append("message", notification.getMessage())
                    .append("type", notification.getType())
                    .append("createdAt", notification.getCreatedAt())
                    .append("read", notification.isRead())
                    .append("link", notification.getLink());
            col.insertOne(doc);
            return true;
        } catch (Exception e) {
            LOGGER.severe("NotificationDAO.createNotification error: " + e.getMessage());
            return false;
        }
    }

    public List<Notification> findByUserId(String userId) {
        List<Notification> list = new ArrayList<>();
        try {
            MongoCollection<Document> col = MongoDBConnection.getNotificationsCollection();
            for (Document doc : col.find(Filters.eq("userId", userId)).sort(Sorts.descending("createdAt"))) {
                Notification n = docToNotification(doc);
                if (n != null) list.add(n);
            }
        } catch (Exception e) {
            LOGGER.severe("NotificationDAO.findByUserId error: " + e.getMessage());
        }
        return list;
    }

    public long countUnreadByUserId(String userId) {
        try {
            MongoCollection<Document> col = MongoDBConnection.getNotificationsCollection();
            return col.countDocuments(Filters.and(
                    Filters.eq("userId", userId),
                    Filters.eq("read", false)
            ));
        } catch (Exception e) {
            LOGGER.severe("NotificationDAO.countUnreadByUserId error: " + e.getMessage());
            return 0;
        }
    }

    public boolean markAsRead(String id) {
        try {
            MongoCollection<Document> col = MongoDBConnection.getNotificationsCollection();
            col.updateOne(Filters.eq("id", id), Updates.set("read", true));
            return true;
        } catch (Exception e) {
            LOGGER.severe("NotificationDAO.markAsRead error: " + e.getMessage());
            return false;
        }
    }

    private Notification docToNotification(Document doc) {
        if (doc == null) return null;
        Notification n = new Notification();
        n.setId(doc.getString("id"));
        n.setUserId(doc.getString("userId"));
        n.setTitle(doc.getString("title"));
        n.setMessage(doc.getString("message"));
        n.setType(doc.getString("type"));
        n.setCreatedAt(doc.getDate("createdAt"));
        Boolean read = doc.getBoolean("read");
        n.setRead(read != null ? read : false);
        n.setLink(doc.getString("link"));
        return n;
    }
}
