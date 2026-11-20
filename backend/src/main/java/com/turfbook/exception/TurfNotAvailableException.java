package com.turfbook.exception;

public class TurfNotAvailableException extends Exception {
    public TurfNotAvailableException(String message) {
        super(message);
    }

    public TurfNotAvailableException(String message, Throwable cause) {
        super(message, cause);
    }
}
