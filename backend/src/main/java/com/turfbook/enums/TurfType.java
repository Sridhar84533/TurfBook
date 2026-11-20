package com.turfbook.enums;

public enum TurfType {
    FOOTBALL_5V5("5v5 Football"),
    FOOTBALL_7V7("7v7 Football"),
    BOX_CRICKET("Box Cricket"),
    BADMINTON("Badminton"),
    TENNIS("Tennis / Padel"),
    MULTI_SPORT("Multi-Sport Arena");

    private final String displayName;

    TurfType(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    public static TurfType fromString(String typeStr) {
        if (typeStr == null) return MULTI_SPORT;
        String clean = typeStr.trim().replace(" ", "_").toUpperCase();
        for (TurfType t : values()) {
            if (t.name().equalsIgnoreCase(clean) || t.displayName.equalsIgnoreCase(typeStr.trim()) || t.name().startsWith(clean)) {
                return t;
            }
        }
        return MULTI_SPORT;
    }
}
