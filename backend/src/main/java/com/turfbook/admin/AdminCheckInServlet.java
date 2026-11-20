package com.turfbook.admin;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.turfbook.model.Booking;
import com.turfbook.model.CheckInResult;
import com.turfbook.model.User;
import com.turfbook.service.BookingService;
import com.turfbook.util.CheckInConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

@WebServlet(urlPatterns = {"/admin/scanner", "/admin/checkin"})
public class AdminCheckInServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminCheckInServlet.class.getName());
    private final BookingService bookingService = new BookingService();
    private final Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        if (token == null || token.trim().isEmpty()) {
            token = req.getParameter("qrToken");
        }

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"ADMIN".equals(session.getAttribute("role"))) {
            if (token != null && !token.trim().isEmpty()) {
                String redirectTarget = req.getContextPath() + "/admin/checkin?token=" + java.net.URLEncoder.encode(token, "UTF-8");
                resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Admin+login+required+to+verify+gate+pass.&redirect=" + java.net.URLEncoder.encode(redirectTarget, "UTF-8"));
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Admin+access+required.");
            return;
        }

        String action = req.getParameter("action");
        try {
            if ("history".equals(action)) {
                List<Booking> checkIns = bookingService.getRecentCheckIns(50);
                req.setAttribute("checkIns", checkIns);
                req.setAttribute("todayCount", bookingService.countTodayCheckIns());
                req.getRequestDispatcher("/admin/checkin-history.jsp").forward(req, resp);
                return;
            }

            // If a token is passed via GET (e.g. normal phone camera or QR scanner app)
            if (token != null && !token.trim().isEmpty()) {
                String adminUsername = "admin";
                User userObj = (User) session.getAttribute("user");
                if (userObj != null && userObj.getUsername() != null) {
                    adminUsername = userObj.getUsername();
                } else if (session.getAttribute("username") != null) {
                    adminUsername = (String) session.getAttribute("username");
                }

                CheckInResult result = bookingService.validateAndCheckIn(token, adminUsername);
                req.setAttribute("checkInResult", result);
            }

            // Default: QR Scanner Page
            req.setAttribute("todayCheckInsCount", bookingService.countTodayCheckIns());
            req.setAttribute("todayBookingsCount", bookingService.countTodayBookings());
            req.setAttribute("recentCheckIns", bookingService.getRecentCheckIns(10));
            req.setAttribute("preCheckInMinutes", CheckInConfig.getPreCheckInMinutes());

            req.getRequestDispatcher("/admin/scanner.jsp").forward(req, resp);
        } catch (Exception e) {
            LOGGER.severe("AdminCheckInServlet GET error: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"ADMIN".equals(session.getAttribute("role"))) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            respondJson(resp, false, "FORBIDDEN", "Unauthorized. Administrator session required.", null);
            return;
        }

        String adminUsername = "admin";
        User userObj = (User) session.getAttribute("user");
        if (userObj != null && userObj.getUsername() != null) {
            adminUsername = userObj.getUsername();
        } else if (session.getAttribute("username") != null) {
            adminUsername = (String) session.getAttribute("username");
        }

        String token = req.getParameter("token");
        if (token == null || token.trim().isEmpty()) {
            token = req.getParameter("qrToken");
        }

        CheckInResult result = bookingService.validateAndCheckIn(token, adminUsername);

        // Check if request is AJAX/fetch JSON
        String accept = req.getHeader("Accept");
        String format = req.getParameter("format");
        boolean isJson = (accept != null && accept.contains("application/json")) || "json".equalsIgnoreCase(format);

        if (isJson) {
            resp.setContentType("application/json;charset=UTF-8");
            try (PrintWriter out = resp.getWriter()) {
                out.print(gson.toJson(result));
                out.flush();
            }
        } else {
            req.setAttribute("checkInResult", result);
            req.setAttribute("todayCheckInsCount", bookingService.countTodayCheckIns());
            req.setAttribute("todayBookingsCount", bookingService.countTodayBookings());
            req.setAttribute("recentCheckIns", bookingService.getRecentCheckIns(10));
            req.setAttribute("preCheckInMinutes", CheckInConfig.getPreCheckInMinutes());
            req.getRequestDispatcher("/admin/scanner.jsp").forward(req, resp);
        }
    }

    private void respondJson(HttpServletResponse resp, boolean success, String code, String message, Object data) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        Map<String, Object> map = new HashMap<>();
        map.put("success", success);
        map.put("resultCode", code);
        map.put("message", message);
        if (data != null) map.put("data", data);
        try (PrintWriter out = resp.getWriter()) {
            out.print(gson.toJson(map));
            out.flush();
        }
    }
}
