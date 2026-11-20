package com.turfbook.util;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class JSONUtil {
    private static final Gson GSON = new GsonBuilder()
            .setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ")
            .create();

    public static String toJson(Object obj) {
        return GSON.toJson(obj);
    }

    public static <T> T fromJson(String json, Class<T> classOfT) {
        return GSON.fromJson(json, classOfT);
    }

    public static Gson getGson() {
        return GSON;
    }

    /**
     * Serialises an object to JSON and escapes single-quotes so the result
     * is safe to embed inside an HTML single-quoted attribute value,
     * e.g. data-foo='...toSafeJson(obj)...'.
     * Also disables Gson HTML-escaping so < > & remain readable in JS.
     */
    public static String toSafeJson(Object obj) {
        String json = new GsonBuilder()
                .setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ")
                .disableHtmlEscaping()
                .create()
                .toJson(obj);
        // Replace single-quotes with HTML entity to keep attribute well-formed
        return json.replace("'", "&#39;");
    }
}
