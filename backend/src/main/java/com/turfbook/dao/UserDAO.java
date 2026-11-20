package com.turfbook.dao;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import com.turfbook.enums.UserRole;
import com.turfbook.model.User;
import com.turfbook.util.MongoDBConnection;
import org.bson.Document;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Logger;

public class UserDAO {
    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    public boolean createUser(User user) {
        try {
            MongoCollection<Document> col = MongoDBConnection.getUsersCollection();
            Document doc = new Document()
                    .append("userId", user.getUserId())
                    .append("username", user.getUsername())
                    .append("passwordHash", user.getPasswordHash())
                    .append("email", user.getEmail())
                    .append("phone", user.getPhone())
                    .append("role", user.getRole().name())
                    .append("createdAt", new Date())
                    .append("updatedAt", new Date());
            col.insertOne(doc);
            return true;
        } catch (Exception e) {
            LOGGER.severe("UserDAO.createUser failed: " + e.getMessage());
            return false;
        }
    }

    public User findByUsername(String username) {
        try {
            MongoCollection<Document> col = MongoDBConnection.getUsersCollection();
            Document doc = col.find(Filters.eq("username", username)).first();
            return docToUser(doc);
        } catch (Exception e) {
            LOGGER.severe("UserDAO.findByUsername failed: " + e.getMessage());
            return null;
        }
    }

    public User findByEmail(String email) {
        try {
            MongoCollection<Document> col = MongoDBConnection.getUsersCollection();
            Document doc = col.find(Filters.eq("email", email.toLowerCase())).first();
            return docToUser(doc);
        } catch (Exception e) {
            LOGGER.severe("UserDAO.findByEmail failed: " + e.getMessage());
            return null;
        }
    }

    public User findById(String userId) {
        try {
            MongoCollection<Document> col = MongoDBConnection.getUsersCollection();
            Document doc = col.find(Filters.eq("userId", userId)).first();
            return docToUser(doc);
        } catch (Exception e) {
            LOGGER.severe("UserDAO.findById failed: " + e.getMessage());
            return null;
        }
    }

    public User findByUsernameOrEmail(String usernameOrEmail) {
        User u = findByUsername(usernameOrEmail);
        if (u == null) u = findByEmail(usernameOrEmail);
        return u;
    }

    public List<User> findAll() {
        List<User> users = new ArrayList<>();
        try {
            MongoCollection<Document> col = MongoDBConnection.getUsersCollection();
            for (Document doc : col.find()) {
                User u = docToUser(doc);
                if (u != null) users.add(u);
            }
        } catch (Exception e) {
            LOGGER.severe("UserDAO.findAll failed: " + e.getMessage());
        }
        return users;
    }

    public boolean updateUser(User user) {
        try {
            MongoCollection<Document> col = MongoDBConnection.getUsersCollection();
            col.updateOne(
                    Filters.eq("userId", user.getUserId()),
                    Updates.combine(
                            Updates.set("email", user.getEmail()),
                            Updates.set("phone", user.getPhone()),
                            Updates.set("updatedAt", new Date())
                    )
            );
            return true;
        } catch (Exception e) {
            LOGGER.severe("UserDAO.updateUser failed: " + e.getMessage());
            return false;
        }
    }

    public boolean usernameExists(String username) {
        try {
            return MongoDBConnection.getUsersCollection()
                    .countDocuments(Filters.eq("username", username)) > 0;
        } catch (Exception e) {
            return false;
        }
    }

    public boolean emailExists(String email) {
        try {
            return MongoDBConnection.getUsersCollection()
                    .countDocuments(Filters.eq("email", email.toLowerCase())) > 0;
        } catch (Exception e) {
            return false;
        }
    }

    public long countUsers() {
        try {
            return MongoDBConnection.getUsersCollection()
                    .countDocuments(Filters.eq("role", "USER"));
        } catch (Exception e) {
            return 0;
        }
    }

    private User docToUser(Document doc) {
        if (doc == null) return null;
        User user = new User();
        user.setUserId(doc.getString("userId"));
        user.setUsername(doc.getString("username"));
        user.setPasswordHash(doc.getString("passwordHash"));
        user.setEmail(doc.getString("email"));
        user.setPhone(doc.getString("phone"));
        user.setRole(UserRole.fromString(doc.getString("role")));
        user.setCreatedAt(doc.getDate("createdAt"));
        user.setUpdatedAt(doc.getDate("updatedAt"));
        return user;
    }
}
