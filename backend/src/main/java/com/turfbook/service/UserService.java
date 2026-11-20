package com.turfbook.service;

import com.turfbook.dao.UserDAO;
import com.turfbook.enums.UserRole;
import com.turfbook.exception.AuthenticationException;
import com.turfbook.exception.DatabaseException;
import com.turfbook.exception.InvalidUserException;
import com.turfbook.interfaces.UserOperations;
import com.turfbook.model.User;
import com.turfbook.util.PasswordUtil;

import java.util.UUID;
import java.util.logging.Logger;

public class UserService implements UserOperations {
    private static final Logger LOGGER = Logger.getLogger(UserService.class.getName());
    private final UserDAO userDAO = new UserDAO();

    @Override
    public User registerUser(User user, String rawPassword) throws InvalidUserException, DatabaseException {
        if (user == null) throw new InvalidUserException("User data cannot be null.");

        // Phase 1 Validation - using String methods trim(), isEmpty(), length(), matches()
        if (!user.isValidUsername()) {
            throw new InvalidUserException("Username must be 3-30 characters and contain only letters, numbers, underscores, dots, or hyphens.");
        }
        if (!user.isValidEmail()) {
            throw new InvalidUserException("Please provide a valid email address.");
        }
        if (!user.isValidPhone()) {
            throw new InvalidUserException("Phone must be a valid 10-digit Indian mobile number.");
        }
        if (!User.isValidPassword(rawPassword)) {
            throw new InvalidUserException("Password must be at least 6 characters long.");
        }

        // Uniqueness checks
        if (userDAO.usernameExists(user.getUsername().trim())) {
            throw new InvalidUserException("Username '" + user.getUsername() + "' is already taken. Please choose another.");
        }
        if (userDAO.emailExists(user.getEmail().trim())) {
            throw new InvalidUserException("An account with this email already exists.");
        }

        try {
            user.setUserId("USER-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            user.setPasswordHash(PasswordUtil.hashPassword(rawPassword));
            // Public registration always creates USER role — never ADMIN
            user.setRole(UserRole.USER);

            boolean created = userDAO.createUser(user);
            if (!created) {
                throw new DatabaseException("Failed to save the new user account. Please try again.");
            }
            return user;
        } catch (DatabaseException e) {
            throw e;
        } catch (Exception e) {
            LOGGER.severe("UserService.registerUser unexpected error: " + e.getMessage());
            throw new DatabaseException("Registration failed due to a server error.", e);
        }
    }

    @Override
    public User authenticateUser(String usernameOrEmail, String rawPassword) throws AuthenticationException, DatabaseException {
        if (usernameOrEmail == null || usernameOrEmail.trim().isEmpty()) {
            throw new AuthenticationException("Username or email is required.");
        }
        if (rawPassword == null || rawPassword.trim().isEmpty()) {
            throw new AuthenticationException("Password is required.");
        }

        try {
            User user = userDAO.findByUsernameOrEmail(usernameOrEmail.trim());
            if (user == null) {
                throw new AuthenticationException("No account found with those credentials.");
            }
            if (!PasswordUtil.checkPassword(rawPassword, user.getPasswordHash())) {
                throw new AuthenticationException("Invalid password. Please try again.");
            }
            return user;
        } catch (AuthenticationException e) {
            throw e;
        } catch (Exception e) {
            LOGGER.severe("UserService.authenticateUser error: " + e.getMessage());
            throw new DatabaseException("Login failed due to a server error.", e);
        }
    }

    @Override
    public User getUserById(String userId) throws DatabaseException {
        try {
            return userDAO.findById(userId);
        } catch (Exception e) {
            throw new DatabaseException("Could not retrieve user profile.", e);
        }
    }

    @Override
    public boolean updateUser(User user) throws InvalidUserException, DatabaseException {
        if (!user.isValidEmail()) {
            throw new InvalidUserException("Invalid email address.");
        }
        if (!user.isValidPhone()) {
            throw new InvalidUserException("Invalid phone number.");
        }
        try {
            return userDAO.updateUser(user);
        } catch (Exception e) {
            throw new DatabaseException("Profile update failed.", e);
        }
    }
}
