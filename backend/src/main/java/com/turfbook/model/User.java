package com.turfbook.model;

import com.turfbook.enums.UserRole;
import java.util.Date;

public class User implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private String userId;
    private String username;
    private transient String passwordHash;
    private String email;
    private String phone;
    private UserRole role;
    private Date createdAt;
    private Date updatedAt;

    public User() {
        this.role = UserRole.USER;
        this.createdAt = new Date();
        this.updatedAt = new Date();
    }

    public User(String userId, String username, String passwordHash, String email, String phone, UserRole role) {
        this.userId = userId;
        this.username = username != null ? username.trim() : "";
        this.passwordHash = passwordHash;
        this.email = email != null ? email.trim() : "";
        this.phone = phone != null ? phone.trim() : "";
        this.role = role != null ? role : UserRole.USER;
        this.createdAt = new Date();
        this.updatedAt = new Date();
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username != null ? username.trim() : "";
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email != null ? email.trim().toLowerCase() : "";
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone != null ? phone.trim() : "";
    }

    public UserRole getRole() {
        return role;
    }

    public void setRole(UserRole role) {
        this.role = role != null ? role : UserRole.USER;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    // Phase 1 - Core String Validation Methods using trim(), isEmpty(), length(), matches()
    public boolean isValidUsername() {
        if (this.username == null) return false;
        String trimmed = this.username.trim();
        return !trimmed.isEmpty() && trimmed.length() >= 3 && trimmed.length() <= 30 && trimmed.matches("^[a-zA-Z0-9_.-]+$");
    }

    public boolean isValidEmail() {
        if (this.email == null) return false;
        String trimmed = this.email.trim();
        return !trimmed.isEmpty() && trimmed.length() >= 5 && trimmed.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    }

    public boolean isValidPhone() {
        if (this.phone == null) return false;
        String clean = this.phone.replaceAll("[\\s-]", "");
        return clean.matches("^[6-9]\\d{9}$");
    }

    public static boolean isValidPassword(String rawPassword) {
        if (rawPassword == null) return false;
        String trimmed = rawPassword.trim();
        return !trimmed.isEmpty() && trimmed.length() >= 6;
    }

    public boolean isValidUser() {
        return isValidUsername() && isValidEmail() && isValidPhone() && role != null;
    }

    @Override
    public String toString() {
        return "User{" +
                "userId='" + userId + '\'' +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", role=" + role +
                '}';
    }
}
