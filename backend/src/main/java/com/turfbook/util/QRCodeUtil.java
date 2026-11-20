package com.turfbook.util;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;

import java.io.ByteArrayOutputStream;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Logger;

/**
 * Enterprise utility for generating high-contrast, professional QR codes.
 * Uses ZXing with Level H error correction and safe quiet zones.
 */
public class QRCodeUtil {
    private static final Logger LOGGER = Logger.getLogger(QRCodeUtil.class.getName());
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    /**
     * Generates a cryptographically strong unique booking check-in token.
     * Format: TB-CHECKIN-[HEX-TOKEN]
     */
    public static String generateSecureToken() {
        byte[] randomBytes = new byte[12];
        SECURE_RANDOM.nextBytes(randomBytes);
        StringBuilder sb = new StringBuilder("TB-CHECKIN-");
        for (byte b : randomBytes) {
            sb.append(String.format("%02X", b));
        }
        return sb.toString();
    }

    /**
     * Generates a crisp PNG byte array for the given text.
     */
    public static byte[] generateQRCodeBytes(String text, int width, int height) throws Exception {
        if (text == null || text.trim().isEmpty()) {
            throw new IllegalArgumentException("QR content cannot be empty.");
        }
        if (width <= 0) width = 300;
        if (height <= 0) height = 300;

        Map<EncodeHintType, Object> hints = new HashMap<>();
        hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.H);
        hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
        hints.put(EncodeHintType.MARGIN, 2); // 2-module white quiet zone for high scan readability

        QRCodeWriter qrCodeWriter = new QRCodeWriter();
        BitMatrix bitMatrix = qrCodeWriter.encode(text, BarcodeFormat.QR_CODE, width, height, hints);

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        MatrixToImageWriter.writeToStream(bitMatrix, "PNG", baos);
        return baos.toByteArray();
    }

    /**
     * Generates an inline Data URI (data:image/png;base64,...) for the given text.
     * Allows immediate rendering in JSP/HTML without extra network roundtrips.
     */
    public static String generateQRCodeDataUri(String text, int width, int height) {
        try {
            byte[] bytes = generateQRCodeBytes(text, width, height);
            return "data:image/png;base64," + Base64.getEncoder().encodeToString(bytes);
        } catch (Exception e) {
            LOGGER.severe("Failed to generate QR data URI: " + e.getMessage());
            return "";
        }
    }

    /**
     * Resolves the full check-in URL for a booking QR pass.
     * When scanned by ANY standard phone camera or QR scanner app, this URL is opened.
     * If request host is localhost or 127.0.0.1, it attempts to resolve the LAN IP so phones can connect over Wi-Fi.
     */
    public static String buildCheckInUrl(jakarta.servlet.http.HttpServletRequest request, String token) {
        if (token == null || token.trim().isEmpty()) {
            return "";
        }
        String scheme = request != null ? request.getScheme() : "http";
        String host = request != null ? request.getServerName() : "localhost";
        int port = request != null ? request.getServerPort() : 8080;
        String contextPath = request != null ? request.getContextPath() : "/turfbook";

        if ("localhost".equalsIgnoreCase(host) || "127.0.0.1".equals(host)) {
            try {
                String lanIp = java.net.InetAddress.getLocalHost().getHostAddress();
                if (lanIp != null && !lanIp.isEmpty() && !lanIp.startsWith("127.")) {
                    host = lanIp;
                }
            } catch (Exception ignored) {}
        }

        StringBuilder url = new StringBuilder();
        url.append(scheme).append("://").append(host);
        if ((scheme.equals("http") && port != 80) || (scheme.equals("https") && port != 443)) {
            url.append(":").append(port);
        }
        url.append(contextPath).append("/admin/checkin?token=").append(token);
        return url.toString();
    }
}
