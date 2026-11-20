package com.turfbook.interfaces;

import com.turfbook.exception.AuthenticationException;
import com.turfbook.exception.DatabaseException;
import com.turfbook.exception.InvalidUserException;
import com.turfbook.model.User;

public interface UserOperations {
    User registerUser(User user, String rawPassword) throws InvalidUserException, DatabaseException;
    User authenticateUser(String usernameOrEmail, String rawPassword) throws AuthenticationException, DatabaseException;
    User getUserById(String userId) throws DatabaseException;
    boolean updateUser(User user) throws InvalidUserException, DatabaseException;
}
