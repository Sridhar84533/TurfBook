package com.turfbook.util;

import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Logger;

public class CheckInConfig {
    private static final Logger LOGGER = Logger.getLogger(CheckInConfig.class.getName());
    private static int preCheckInMinutes = 15; // default 15 minutes before slot start

    static {
        loadConfig();
    }

    private static void loadConfig() {
        try {
            InputStream in = CheckInConfig.class.getClassLoader().getResourceAsStream("application.properties");
            if (in != null) {
                Properties p = new Properties();
                p.load(in);
                String val = p.getProperty("checkin.pre.minutes");
                if (val != null && !val.trim().isEmpty()) {
                    preCheckInMinutes = Integer.parseInt(val.trim());
                }
                in.close();
            }
        } catch (Exception e) {
            LOGGER.warning("Could not read checkin.pre.minutes from application.properties, using default: " + preCheckInMinutes);
        }
    }

    public static int getPreCheckInMinutes() {
        return preCheckInMinutes;
    }

    public static void setPreCheckInMinutes(int minutes) {
        preCheckInMinutes = minutes;
    }
}
