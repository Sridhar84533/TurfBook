<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.turfbook.model.User" %>
<%@ page import="com.turfbook.model.Booking" %>
<%@ page import="com.turfbook.service.BookingService" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    BookingService bookingService = new BookingService();
    List<Booking> recentBookings = bookingService.getUserBookings(currentUser.getUserId());
    int confirmedCount = 0;
    if (recentBookings != null) {
        for (Booking b : recentBookings) {
            if ("CONFIRMED".equals(b.getStatus().name())) confirmedCount++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Notifications • TurfBook</title>
  <link href="https://fonts.googleapis.com" rel="preconnect"/>
  <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&display=block" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@600;700;800&display=swap" rel="stylesheet"/>
  <link href="<%= request.getContextPath() %>/css/style.css" rel="stylesheet"/>
  <script src="https://cdn.tailwindcss.com"></script>
  <script id="tailwind-config">
    tailwind.config = {
      darkMode: 'class',
      theme: {
        extend: {
          colors: {
            'surface-container-lowest': '#ffffff', 'on-secondary-container': '#5c647a', 'on-tertiary': '#ffffff',
            'on-secondary': '#ffffff', 'surface-container': '#e5eeff', 'surface-container-high': '#dce9ff',
            'surface-bright': '#f8f9ff', 'error-container': '#ffdad6', 'outline-variant': '#bdcaba',
            'secondary-container': '#dae2fd', 'inverse-surface': '#213145', 'secondary': '#565e74',
            'on-error': '#ffffff', 'primary-fixed-dim': '#62df7d', 'on-primary': '#ffffff',
            'on-primary-container': '#f7fff2', 'surface-container-highest': '#d3e4fe',
            'inverse-on-surface': '#eaf1ff', 'error': '#ba1a1a', 'surface-container-low': '#eff4ff',
            'background': '#f8f9ff', 'outline': '#6e7b6c', 'primary-fixed': '#7ffc97', 'surface': '#f8f9ff',
            'secondary-fixed-dim': '#bec6e0', 'on-background': '#0b1c30', 'on-error-container': '#93000a',
            'on-secondary-fixed': '#131b2e', 'surface-variant': '#d3e4fe', 'secondary-fixed': '#dae2fd',
            'primary': '#006b2c', 'inverse-primary': '#62df7d', 'on-surface': '#0b1c30',
            'primary-container': '#00873a', 'surface-dim': '#cbdbf5', 'tertiary-container': '#00855b',
            'tertiary': '#006947', 'on-surface-variant': '#3e4a3d', 'on-tertiary-container': '#f5fff6'
          },
          borderRadius: { 'DEFAULT': '0.25rem', 'lg': '0.5rem', 'xl': '0.75rem', '2xl': '1rem', 'full': '9999px' },
          spacing: { 'unit-sm': '0.75rem', 'unit-xs': '0.5rem', 'unit-2xs': '0.25rem', 'unit-2xl': '3rem', 'unit-3xl': '4rem', 'unit-lg': '1.5rem', 'unit-xl': '2rem', 'unit-md': '1rem' },
          fontFamily: { 'display': ['Outfit', 'sans-serif'], 'headline-sm': ['Outfit', 'sans-serif'], 'headline-lg': ['Outfit', 'sans-serif'], 'body-lg': ['Inter', 'sans-serif'], 'body-md': ['Inter', 'sans-serif'], 'body-sm': ['Inter', 'sans-serif'], 'label-lg': ['Inter', 'sans-serif'], 'label-md': ['Inter', 'sans-serif'], 'label-sm': ['Inter', 'sans-serif'] }
        }
      }
    };
  </script>
</head>
<body class="bg-surface font-body-md text-on-surface antialiased min-h-screen">

  <!-- Scroll Progress -->
  <div id="scroll-progress"></div>

  <!-- Header -->
  <header class="fixed top-0 left-0 right-0 z-50 bg-surface-container-lowest/90 backdrop-blur-md border-b border-outline-variant/30 shadow-[0_1px_8px_rgba(0,0,0,0.04)]">
    <div class="h-16 max-w-[1280px] mx-auto px-unit-md lg:px-unit-xl flex items-center justify-between gap-unit-md">
      <a class="flex items-center gap-unit-xs group" href="<%= request.getContextPath() %>/index.jsp">
        <div class="w-9 h-9 rounded-lg bg-primary flex items-center justify-center text-on-primary shadow-sm group-hover:scale-105 transition-transform">
          <span class="material-symbols-outlined text-[22px]">sports_soccer</span>
        </div>
        <span class="font-headline-sm text-on-surface tracking-tight font-bold">Turf<span class="text-primary">Book</span></span>
      </a>
      <div class="flex items-center gap-unit-sm">
        <a href="<%= request.getContextPath() %>/turfs" class="px-unit-sm py-unit-xs text-on-surface-variant hover:text-on-surface font-label-lg transition-colors">Explore Turfs</a>
        <a href="<%= request.getContextPath() %>/user/dashboard.jsp" class="px-unit-sm py-unit-xs text-on-surface-variant hover:text-on-surface font-label-lg transition-colors">Dashboard</a>
        <a href="<%= request.getContextPath() %>/logout" class="p-2 text-on-surface-variant hover:text-error transition-colors" title="Sign Out">
          <span class="material-symbols-outlined text-[20px]">logout</span>
        </a>
      </div>
    </div>
  </header>

  <main class="w-full pt-16 bg-surface min-h-screen">
    <div class="max-w-[720px] mx-auto px-unit-md lg:px-0 py-unit-xl pb-unit-3xl">

      <!-- Page Header -->
      <div class="mb-unit-xl stagger-up">
        <div class="flex items-center justify-between">
          <div>
            <span class="font-label-sm uppercase tracking-wider text-primary font-bold">Activity Feed</span>
            <h1 class="font-display font-extrabold text-on-surface text-3xl sm:text-4xl mt-1">Alerts &amp; Notifications</h1>
            <p class="font-body-md text-secondary mt-1">Real-time match updates and platform announcements.</p>
          </div>
          <div class="shrink-0 w-12 h-12 rounded-2xl bg-primary/10 text-primary flex items-center justify-center">
            <span class="material-symbols-outlined text-2xl" style="font-variation-settings: 'FILL' 1;">notifications</span>
          </div>
        </div>
      </div>

      <!-- Notification Items -->
      <div class="space-y-unit-sm">
        
        <!-- System: Welcome -->
        <div class="bg-surface-container-lowest p-unit-lg rounded-2xl shadow-sm border border-outline-variant/30 flex items-start gap-unit-md hover:shadow-md transition-shadow stagger-up">
          <div class="w-12 h-12 rounded-2xl bg-primary/10 text-primary flex items-center justify-center shrink-0 shadow-sm">
            <span class="material-symbols-outlined text-xl" style="font-variation-settings: 'FILL' 1;">verified</span>
          </div>
          <div class="flex-1 min-w-0">
            <div class="flex items-center justify-between">
              <h3 class="font-label-lg font-bold text-on-surface">Welcome to TurfBook!</h3>
              <span class="text-[11px] font-bold text-primary bg-primary/10 px-2 py-0.5 rounded-full uppercase">New</span>
            </div>
            <p class="font-body-sm text-secondary mt-0.5">Your player pass is active. You can now lock in floodlit artificial turf slots with instant confirmation and digital QR entry.</p>
            <span class="text-[11px] text-outline block mt-2 font-mono">Today • Platform Notice</span>
          </div>
        </div>

        <!-- System: Active Pitches -->
        <div class="bg-surface-container-lowest p-unit-lg rounded-2xl shadow-sm border border-outline-variant/30 flex items-start gap-unit-md hover:shadow-md transition-shadow stagger-up" data-delay="0.05s">
          <div class="w-12 h-12 rounded-2xl bg-secondary-container text-on-secondary-container flex items-center justify-center shrink-0 shadow-sm">
            <span class="material-symbols-outlined text-xl" style="font-variation-settings: 'FILL' 1;">stadium</span>
          </div>
          <div class="flex-1 min-w-0">
            <div class="flex items-center justify-between">
              <h3 class="font-label-lg font-bold text-on-surface">Pitches Verified in Bengaluru</h3>
            </div>
            <p class="font-body-sm text-secondary mt-0.5">Green Arena, AstroPark, PowerPlay, and Decathlon Arena are live with 500-Lux LED floodlighting and real-time slot sync.</p>
            <span class="text-[11px] text-outline block mt-2 font-mono">System Update • Arena Operations</span>
          </div>
        </div>

        <% if (confirmedCount > 0) { %>
        <!-- Dynamic: Confirmed Bookings -->
        <div class="bg-surface-container-lowest p-unit-lg rounded-2xl shadow-sm border border-primary/30 flex items-start gap-unit-md hover:shadow-md transition-shadow stagger-up" data-delay="0.1s">
          <div class="w-12 h-12 rounded-2xl bg-primary text-on-primary flex items-center justify-center shrink-0 shadow-md">
            <span class="material-symbols-outlined text-xl" style="font-variation-settings: 'FILL' 1;">event_available</span>
          </div>
          <div class="flex-1 min-w-0">
            <div class="flex items-center justify-between">
              <h3 class="font-label-lg font-bold text-on-surface">Active Match Sessions: <%= confirmedCount %></h3>
              <span class="text-[11px] font-bold text-primary bg-primary/10 px-2 py-0.5 rounded-full uppercase">Live</span>
            </div>
            <p class="font-body-sm text-secondary mt-0.5">You have <%= confirmedCount %> confirmed booking<%= confirmedCount > 1 ? "s" : "" %> upcoming. Your digital pitch pass will be ready at the arena gate.</p>
            <div class="flex items-center gap-unit-sm mt-unit-sm">
              <a href="<%= request.getContextPath() %>/user/booking?action=my-bookings" class="text-xs font-bold text-primary hover:underline flex items-center gap-0.5">
                <span>View My Bookings</span>
                <span class="material-symbols-outlined text-xs">arrow_forward</span>
              </a>
            </div>
            <span class="text-[11px] text-outline block mt-2 font-mono">Booking Confirmation • Razorpay</span>
          </div>
        </div>
        <% } %>

        <!-- System: New Feature -->
        <div class="bg-surface-container-lowest p-unit-lg rounded-2xl shadow-sm border border-outline-variant/30 flex items-start gap-unit-md hover:shadow-md transition-shadow stagger-up" data-delay="0.15s">
          <div class="w-12 h-12 rounded-2xl bg-amber-100 text-amber-700 flex items-center justify-center shrink-0 shadow-sm">
            <span class="material-symbols-outlined text-xl" style="font-variation-settings: 'FILL' 1;">bolt</span>
          </div>
          <div class="flex-1 min-w-0">
            <h3 class="font-label-lg font-bold text-on-surface">GPS Proximity Now Live</h3>
            <p class="font-body-sm text-secondary mt-0.5">TurfBook now supports real satellite geolocation to calculate distances to all verified arenas — find your closest pitch in one tap.</p>
            <a href="<%= request.getContextPath() %>/#location-section" class="mt-unit-sm text-xs font-bold text-amber-700 hover:underline flex items-center gap-0.5 w-fit">
              <span>Try GPS Finder</span>
              <span class="material-symbols-outlined text-xs">near_me</span>
            </a>
            <span class="text-[11px] text-outline block mt-2 font-mono">Feature Update • Platform v2</span>
          </div>
        </div>

        <!-- System: Security -->
        <div class="bg-surface-container-lowest p-unit-lg rounded-2xl shadow-sm border border-outline-variant/30 flex items-start gap-unit-md hover:shadow-md transition-shadow stagger-up" data-delay="0.2s">
          <div class="w-12 h-12 rounded-2xl bg-surface-container text-on-surface-variant flex items-center justify-center shrink-0 shadow-sm">
            <span class="material-symbols-outlined text-xl" style="font-variation-settings: 'FILL' 1;">security</span>
          </div>
          <div class="flex-1 min-w-0">
            <h3 class="font-label-lg font-bold text-on-surface">Account Security Active</h3>
            <p class="font-body-sm text-secondary mt-0.5">Your account is secured with bcrypt password hashing. All payment transactions are protected by Razorpay's 256-bit TLS encryption.</p>
            <span class="text-[11px] text-outline block mt-2 font-mono">Security Notice • Automatic</span>
          </div>
        </div>

      </div>

      <!-- Explore CTA -->
      <div class="mt-unit-2xl pt-unit-xl border-t border-outline-variant/20 text-center stagger-up" data-delay="0.25s">
        <p class="font-body-md text-secondary mb-unit-md">Ready to lock in your next match?</p>
        <a href="<%= request.getContextPath() %>/turfs" class="inline-flex items-center gap-unit-xs px-unit-2xl h-12 rounded-xl bg-primary hover:bg-primary-container text-on-primary font-label-md font-bold shadow-lg transition-all btn-magnetic">
          <span class="material-symbols-outlined text-xl">stadium</span>
          <span>Explore Turfs</span>
        </a>
      </div>

    </div>
  </main>

  <script src="<%= request.getContextPath() %>/js/app.js"></script>
</body>
</html>
