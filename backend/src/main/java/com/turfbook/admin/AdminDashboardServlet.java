package com.turfbook.admin;

import com.turfbook.dao.BookingDAO;
import com.turfbook.dao.TurfDAO;
import com.turfbook.dao.UserDAO;
import com.turfbook.enums.BookingStatus;
import com.turfbook.model.Booking;
import com.turfbook.model.Turf;
import com.turfbook.model.User;
import com.turfbook.service.BookingService;
import com.turfbook.service.PaymentService;
import com.turfbook.service.TurfService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminDashboardServlet.class.getName());
    private final TurfDAO turfDAO = new TurfDAO();
    private final UserDAO userDAO = new UserDAO();
    private final BookingDAO bookingDAO = new BookingDAO();
    private final BookingService bookingService = new BookingService();
    private final PaymentService paymentService = new PaymentService();
    private final TurfService turfService = new TurfService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            long activeTurfs = turfDAO.countActiveTurfs();
            long totalUsers = userDAO.countUsers();
            long totalBookings = bookingDAO.countTotalBookings();
            double totalRevenue = paymentService.getTotalRevenue();

            // Mobile & Operational Quick KPI Metrics
            String todayDate = LocalDate.now().toString();
            long todayBookingsCount = bookingService.countTodayBookings();
            long todayCheckInsCount = bookingService.countTodayCheckIns();

            List<Booking> todayBookings = bookingService.getTodayBookings();
            double todayRevenue = 0.0;
            long pendingBookingsCount = 0;

            for (Booking b : todayBookings) {
                if (b.getStatus() == BookingStatus.CONFIRMED || b.getStatus() == BookingStatus.COMPLETED) {
                    todayRevenue += b.getTotalAmount();
                } else if (b.getStatus() == BookingStatus.PENDING) {
                    pendingBookingsCount++;
                }
            }

            List<Booking> recentCheckIns = bookingService.getRecentCheckIns(6);
            List<Booking> allBookings = bookingService.getAllBookings();
            List<Booking> recentBookings = new ArrayList<>();
            for (int i = 0; i < Math.min(6, allBookings.size()); i++) {
                Booking b = allBookings.get(i);
                Turf t = turfService.getTurfById(b.getTurfId());
                if (t != null) b.setTurfName(t.getTurfName());
                User u = userDAO.findById(b.getUserId());
                if (u != null) b.setUserName(u.getUsername());
                recentBookings.add(b);
            }

            req.setAttribute("activeTurfs", activeTurfs);
            req.setAttribute("totalUsers", totalUsers);
            req.setAttribute("totalBookings", totalBookings);
            req.setAttribute("totalRevenue", totalRevenue);

            req.setAttribute("todayBookingsCount", todayBookingsCount);
            req.setAttribute("todayCheckInsCount", todayCheckInsCount);
            req.setAttribute("todayRevenue", todayRevenue);
            req.setAttribute("pendingBookingsCount", pendingBookingsCount);
            req.setAttribute("todayBookings", todayBookings);
            req.setAttribute("todayDate", todayDate);
            req.setAttribute("recentCheckIns", recentCheckIns);
            req.setAttribute("recentBookings", recentBookings);

            req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
        } catch (Exception e) {
            LOGGER.severe("AdminDashboardServlet error: " + e.getMessage());
            req.setAttribute("error", "Dashboard data could not be loaded: " + e.getMessage());
            req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
        }
    }
}
