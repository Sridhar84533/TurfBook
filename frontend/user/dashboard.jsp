<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.turfbook.model.Booking" %>
<%@ page import="com.turfbook.model.Turf" %>
<%@ page import="com.turfbook.model.User" %>
<%@ page import="com.turfbook.service.BookingService" %>
<%@ page import="com.turfbook.service.TurfService" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    BookingService bookingService = new BookingService();
    TurfService turfService = new TurfService();
    List<Booking> userBookings = bookingService.getUserBookings(currentUser.getUserId());
    List<Turf> allTurfs = turfService.getAllActiveTurfs();
    
    int totalMatches = userBookings != null ? userBookings.size() : 0;
    double totalSpent = 0;
    int confirmedCount = 0;
    int expiredCount = 0;
    Booking nextBooking = null;

    if (userBookings != null) {
        for (Booking b : userBookings) {
            totalSpent += b.getTotalAmount();
            boolean isExp = b.isExpired() || "EXPIRED".equals(b.getStatus().name());
            if (isExp) {
                expiredCount++;
            } else if ("CONFIRMED".equals(b.getStatus().name())) {
                confirmedCount++;
                if (nextBooking == null) nextBooking = b;
            }
        }
    }

    Turf nextTurf = null;
    if (nextBooking != null) {
        nextTurf = turfService.getTurfById(nextBooking.getTurfId());
        if (nextTurf != null && nextBooking.getTurfName() == null) {
            nextBooking.setTurfName(nextTurf.getTurfName());
            nextBooking.setTurfLocation(nextTurf.getFullLocation());
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Player Dashboard • TurfBook</title>
  <link href="https://fonts.googleapis.com" rel="preconnect"/>
  <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&display=block" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;family=Outfit:wght@600;700&amp;display=swap" rel="stylesheet"/>
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
            'surface-bright': '#f8f9ff', 'error-container': '#ffdad6', 'on-tertiary-fixed-variant': '#005236',
            'secondary-container': '#dae2fd', 'on-secondary-fixed-variant': '#3f465c', 'tertiary-fixed-dim': '#4edea3',
            'outline-variant': '#bdcaba', 'inverse-surface': '#213145', 'secondary': '#565e74',
            'on-tertiary-fixed': '#002113', 'on-error': '#ffffff', 'primary-fixed-dim': '#62df7d',
            'on-primary': '#ffffff', 'surface-tint': '#006e2d', 'on-primary-container': '#f7fff2',
            'on-primary-fixed-variant': '#005320', 'tertiary-fixed': '#6ffbbe', 'surface-container-highest': '#d3e4fe',
            'inverse-on-surface': '#eaf1ff', 'error': '#ba1a1a', 'surface-container-low': '#eff4ff',
            'background': '#f8f9ff', 'on-primary-fixed': '#002109', 'outline': '#6e7b6c',
            'on-tertiary-container': '#f5fff6', 'primary-fixed': '#7ffc97', 'surface': '#f8f9ff',
            'secondary-fixed-dim': '#bec6e0', 'on-background': '#0b1c30', 'on-error-container': '#93000a',
            'on-secondary-fixed': '#131b2e', 'surface-variant': '#d3e4fe', 'secondary-fixed': '#dae2fd',
            'primary': '#006b2c', 'inverse-primary': '#62df7d', 'on-surface': '#0b1c30',
            'primary-container': '#00873a', 'surface-dim': '#cbdbf5', 'tertiary-container': '#00855b',
            'tertiary': '#006947', 'on-surface-variant': '#3e4a3d'
          },
          borderRadius: { 'DEFAULT': '0.25rem', 'lg': '0.5rem', 'xl': '0.75rem', 'full': '9999px' },
          spacing: { 'unit-sm': '0.75rem', 'unit-xs': '0.5rem', 'unit-2xs': '0.25rem', 'unit-2xl': '3rem', 'unit-3xl': '4rem', 'unit-lg': '1.5rem', 'unit-xl': '2rem', 'unit-md': '1rem' },
          fontFamily: { 'display': ['outfit'], 'headline-sm': ['outfit'], 'headline-xl': ['outfit'], 'headline-lg': ['outfit'], 'body-lg': ['inter'], 'body-md': ['inter'], 'body-sm': ['inter'], 'label-lg': ['inter'], 'label-md': ['inter'], 'label-sm': ['inter'] }
        }
      }
    };
  </script>
</head>
<body class="bg-surface font-body-md text-on-surface antialiased min-h-screen">
  <!-- Header -->
  <header class="fixed top-0 left-0 right-0 z-50 bg-surface-container-lowest border-b border-outline-variant/30 shadow-[0_1px_8px_rgba(0,0,0,0.04)]">
    <div class="h-16 max-w-[1280px] mx-auto px-unit-md lg:px-unit-xl flex items-center justify-between gap-unit-md">
      <div class="flex items-center gap-unit-xl">
        <a class="flex items-center gap-unit-xs group" href="<%= request.getContextPath() %>/index.jsp">
          <div class="w-9 h-9 rounded-lg bg-primary flex items-center justify-center text-on-primary shadow-sm">
            <span class="material-symbols-outlined text-[22px]">sports_soccer</span>
          </div>
          <span class="font-headline-sm text-headline-sm text-on-surface tracking-tight font-bold">Turf<span class="text-primary">Book</span></span>
        </a>
        <nav class="hidden lg:flex items-center gap-unit-xs">
          <a class="px-unit-sm py-unit-xs text-on-surface-variant hover:text-on-surface transition-colors font-label-lg rounded-lg" href="<%= request.getContextPath() %>/index.jsp">Home</a>
          <a class="px-unit-sm py-unit-xs text-on-surface-variant hover:text-on-surface transition-colors font-label-lg rounded-lg" href="<%= request.getContextPath() %>/turfs">Explore Turfs</a>
          <a class="px-unit-sm py-unit-xs text-on-surface-variant hover:text-on-surface transition-colors font-label-lg rounded-lg" href="<%= request.getContextPath() %>/user/booking?action=my-bookings">My Bookings</a>
          <a class="px-unit-sm py-unit-xs bg-primary-container text-on-primary-container font-semibold rounded-lg" href="<%= request.getContextPath() %>/user/dashboard.jsp">Dashboard</a>
        </nav>
      </div>

      <div class="flex items-center gap-unit-sm">
        <div class="flex items-center gap-unit-xs pl-unit-xs py-unit-2xs pr-unit-sm rounded-full bg-surface-container-low border border-outline-variant/40">
          <div class="w-8 h-8 rounded-full bg-primary text-on-primary font-bold flex items-center justify-center text-xs">
            <%= currentUser.getUsername().substring(0, 1).toUpperCase() %>
          </div>
          <span class="hidden md:inline-block font-label-md text-on-surface font-semibold"><%= currentUser.getUsername() %></span>
        </div>
        <a href="<%= request.getContextPath() %>/logout" class="p-2 text-on-surface-variant hover:text-error transition-colors" title="Sign Out">
          <span class="material-symbols-outlined text-[20px]">logout</span>
        </a>
      </div>
    </div>
  </header>

  <main class="w-full pt-16 bg-surface px-unit-md lg:px-unit-xl py-unit-lg min-h-screen">
    <div class="max-w-[1280px] mx-auto flex flex-col w-full gap-unit-xl pb-unit-3xl">
      
      <!-- Top Banner -->
      <div class="relative overflow-hidden rounded-2xl bg-surface-container-lowest p-unit-lg shadow-sm border border-outline-variant/30 mt-unit-sm">
        <div class="relative flex flex-col md:flex-row md:items-center justify-between gap-unit-md z-10">
          <div>
            <div class="flex items-center gap-unit-xs mb-unit-2xs">
              <span class="inline-flex items-center gap-1.5 px-unit-xs py-0.5 rounded-full bg-surface-container text-primary font-label-sm uppercase font-bold tracking-wider">
                <span class="w-2 h-2 rounded-full bg-primary animate-ping"></span>
                Player Hub
              </span>
              <span class="text-outline text-body-sm">•</span>
              <span class="text-secondary text-body-sm font-mono"><%= currentUser.getEmail() %></span>
            </div>
            <h1 class="font-headline-xl font-bold text-on-surface">Welcome Back, <%= currentUser.getUsername() %></h1>
            <p class="font-body-md text-secondary mt-1">Ready for your next fixture? You have <span class="font-bold text-primary"><%= confirmedCount %> active bookings</span><%= expiredCount > 0 ? (" and <span class='font-bold text-amber-700'>" + expiredCount + " expired</span>") : "" %>.</p>
          </div>
          <div class="flex items-center gap-unit-sm shrink-0">
            <a href="<%= request.getContextPath() %>/turfs" class="inline-flex items-center gap-unit-xs px-unit-lg py-2.5 rounded-xl bg-primary hover:bg-primary-container text-on-primary font-label-lg font-bold shadow-md transition-all">
              <span class="material-symbols-outlined text-lg">sports_soccer</span>
              <span>Book a Turf</span>
            </a>
          </div>
        </div>
      </div>

      <!-- 4 Key Stat Cards -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-unit-md">
        <div class="p-unit-md rounded-2xl bg-surface-container-lowest shadow-sm hover:shadow-md transition-all border border-outline-variant/30 flex items-center justify-between stagger-up" data-delay="0.05s">
          <div>
            <span class="font-label-sm uppercase tracking-wider text-secondary font-bold">Confirmed Slots</span>
            <div class="flex items-baseline gap-unit-xs mt-1">
              <span class="font-headline-xl font-bold text-on-surface" data-count="<%= confirmedCount %>"><%= confirmedCount %></span>
              <span class="font-label-sm text-primary font-bold">Active</span>
            </div>
          </div>
          <div class="w-12 h-12 rounded-xl bg-surface-container-low flex items-center justify-center text-primary">
            <span class="material-symbols-outlined text-2xl">event_available</span>
          </div>
        </div>

        <div class="p-unit-md rounded-2xl bg-surface-container-lowest shadow-sm hover:shadow-md transition-all border border-outline-variant/30 flex items-center justify-between stagger-up" data-delay="0.1s">
          <div>
            <span class="font-label-sm uppercase tracking-wider text-secondary font-bold">Total Bookings</span>
            <div class="flex items-baseline gap-unit-xs mt-1">
              <span class="font-headline-xl font-bold text-on-surface" data-count="<%= totalMatches %>"><%= totalMatches %></span>
              <span class="font-label-sm text-secondary font-medium"><%= expiredCount > 0 ? (expiredCount + " Expired") : "Recorded" %></span>
            </div>
          </div>
          <div class="w-12 h-12 rounded-xl bg-secondary-container/40 flex items-center justify-center text-secondary">
            <span class="material-symbols-outlined text-2xl">military_tech</span>
          </div>
        </div>

        <div class="p-unit-md rounded-2xl bg-surface-container-lowest shadow-sm hover:shadow-md transition-all border border-outline-variant/30 flex items-center justify-between stagger-up" data-delay="0.15s">
          <div>
            <span class="font-label-sm uppercase tracking-wider text-secondary font-bold">Total Invested</span>
            <div class="flex items-baseline gap-unit-xs mt-1">
              <span class="font-headline-xl font-bold text-on-surface" data-count="<%= (int) totalSpent %>" data-prefix="₹">₹<%= (int) totalSpent %></span>
            </div>
          </div>
          <div class="w-12 h-12 rounded-xl bg-surface-container flex items-center justify-center text-primary">
            <span class="material-symbols-outlined text-2xl">account_balance_wallet</span>
          </div>
        </div>

        <div class="p-unit-md rounded-2xl bg-surface-container-lowest shadow-sm hover:shadow-md transition-all border border-outline-variant/30 flex items-center justify-between stagger-up" data-delay="0.2s">
          <div>
            <span class="font-label-sm uppercase tracking-wider text-secondary font-bold">Account Tier</span>
            <div class="flex items-baseline gap-unit-xs mt-1">
              <span class="font-headline-lg font-bold text-primary">Player Pro</span>
            </div>
          </div>
          <div class="w-12 h-12 rounded-xl bg-primary-fixed/40 flex items-center justify-center text-on-primary-fixed">
            <span class="material-symbols-outlined text-2xl">verified</span>
          </div>
        </div>
      </div>

      <!-- Spotlight: Next Match or Quick CTA -->
      <% if (nextBooking != null) { 
           String nextTurfImg = (nextTurf != null && nextTurf.getImageUrl() != null && !nextTurf.getImageUrl().isEmpty())
               ? nextTurf.getImageUrl()
               : "https://images.unsplash.com/photo-1529900748604-07564a03e7a6?auto=format&fit=crop&w=1200&q=80";
           String nextGpsQuery = (nextTurf != null && nextTurf.getLatitude() != 0.0) 
               ? (nextTurf.getLatitude() + "," + nextTurf.getLongitude()) 
               : java.net.URLEncoder.encode((nextBooking.getTurfName() != null ? nextBooking.getTurfName() : "Turf") + " " + (nextBooking.getTurfLocation() != null ? nextBooking.getTurfLocation() : "Bengaluru"), "UTF-8");
      %>
        <div class="bg-surface-container-lowest rounded-2xl shadow-md border border-outline-variant/30 overflow-hidden flex flex-col md:flex-row items-stretch">
          <div class="md:w-5/12 relative min-h-[180px] bg-surface-container-high overflow-hidden">
            <img src="<%= nextTurfImg %>" 
                 alt="Turf Arena" 
                 onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=800&auto=format&fit=crop&q=80';"
                 class="w-full h-full object-cover"/>
            <div class="absolute inset-0 bg-gradient-to-t from-black/70 via-black/20 to-transparent"></div>
            <div class="absolute top-3 left-3 flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-black/60 backdrop-blur-md text-white text-xs font-bold">
              <span class="w-2 h-2 rounded-full bg-[#62df7d] animate-pulse"></span>
              <span>Next Game</span>
            </div>
            <div class="absolute bottom-3 left-3 right-3 text-white">
              <span class="text-xs font-semibold text-[#7ffc97] uppercase tracking-wider block">Confirmed Pitch</span>
              <h3 class="font-headline-sm font-bold text-white leading-tight"><%= nextBooking.getTurfName() != null ? nextBooking.getTurfName() : "Reserved Pitch" %></h3>
            </div>
          </div>

          <div class="md:w-7/12 p-unit-lg flex flex-col justify-between gap-unit-md">
            <div>
              <div class="flex items-center justify-between gap-2">
                <span class="font-label-sm uppercase tracking-wider text-primary font-bold">Upcoming Match Spotlight</span>
                <span class="bg-green-100 text-green-800 text-xs font-bold px-2.5 py-0.5 rounded-full">Pass Active</span>
              </div>
              <p class="font-body-md text-secondary mt-1">
                Date: <strong class="text-on-surface"><%= nextBooking.getBookingDate() %></strong> • 
                Slot: <strong class="text-primary font-mono"><%= nextBooking.getStartTime() %> – <%= nextBooking.getEndTime() %></strong>
              </p>
              <div class="flex items-center gap-2 mt-2 text-sm text-secondary">
                <span class="material-symbols-outlined text-base text-primary">location_on</span>
                <span><%= nextBooking.getTurfLocation() != null ? nextBooking.getTurfLocation() : "Bengaluru Arena" %></span>
              </div>
            </div>

            <div class="flex flex-wrap items-center gap-unit-sm pt-unit-xs">
              <a href="https://www.google.com/maps/search/?api=1&query=<%= nextGpsQuery %>" target="_blank" class="px-unit-md py-2 bg-[#1a73e8] hover:bg-[#1557b0] text-white font-label-md font-bold rounded-xl shadow-sm transition-all flex items-center gap-1.5" title="Navigate to pitch with Google Maps">
                <span class="material-symbols-outlined text-base">near_me</span>
                <span>Google Maps GPS</span>
              </a>
              <a href="<%= request.getContextPath() %>/user/booking?action=details&id=<%= nextBooking.getBookingId() %>" class="px-unit-lg py-2 bg-primary hover:bg-primary-container text-on-primary font-label-md font-bold rounded-xl shadow-sm transition-all flex items-center gap-1.5">
                <span class="material-symbols-outlined text-base">qr_code_2</span>
                <span>View Match Pass</span>
              </a>
            </div>
          </div>
        </div>
      <% } else { %>
        <div class="bg-surface-container-lowest rounded-2xl p-unit-lg shadow-sm border border-outline-variant/30 flex flex-col sm:flex-row items-center justify-between gap-unit-md">
          <div>
            <h2 class="font-headline-sm font-bold text-on-surface">No upcoming matches scheduled</h2>
            <p class="font-body-md text-secondary mt-1">Browse floodlit grounds in your city and lock in a prime evening game.</p>
          </div>
          <a href="<%= request.getContextPath() %>/turfs" class="px-unit-lg py-2.5 bg-primary hover:bg-primary-container text-on-primary font-label-lg font-bold rounded-xl shadow-sm transition-all">
            Find Open Pitches
          </a>
        </div>
      <% } %>

      <!-- Available Grounds & Pitches Bento Section -->
      <div class="space-y-unit-md">
        <div class="flex items-center justify-between">
          <div>
            <span class="font-label-sm uppercase tracking-wider text-primary font-bold">Featured Grounds</span>
            <h2 class="font-headline-lg font-bold text-on-surface">Explore &amp; Book Sports Pitches</h2>
          </div>
          <a href="<%= request.getContextPath() %>/turfs" class="text-primary font-label-md font-bold hover:underline flex items-center gap-1">
            <span>Explore All Pitches</span>
            <span class="material-symbols-outlined text-base">arrow_forward</span>
          </a>
        </div>

        <% if (allTurfs != null && !allTurfs.isEmpty()) { %>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-unit-lg">
            <% for (Turf t : allTurfs) { 
                 String turfImg = (t.getImageUrl() != null && !t.getImageUrl().isEmpty())
                     ? t.getImageUrl()
                     : "https://images.unsplash.com/photo-1529900748604-07564a03e7a6?auto=format&fit=crop&w=800&q=80";
                 String gpsQuery = (t.getLatitude() != 0.0) 
                     ? (t.getLatitude() + "," + t.getLongitude()) 
                     : java.net.URLEncoder.encode(t.getTurfName() + " " + t.getCity(), "UTF-8");
            %>
              <div class="bg-surface-container-lowest rounded-2xl overflow-hidden shadow-sm hover:shadow-xl transition-all border border-outline-variant/30 flex flex-col group">
                <div class="relative h-48 overflow-hidden bg-surface-container">
                  <img src="<%= turfImg %>" 
                       alt="<%= t.getTurfName() %>"
                       onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=800&auto=format&fit=crop&q=80';"
                       class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"/>
                  <span class="absolute top-3 left-3 bg-on-surface/80 backdrop-blur-md text-surface font-label-sm px-2.5 py-1 rounded-full uppercase font-bold text-[11px]">
                    <%= t.getTurfType() != null ? t.getTurfType().getDisplayName() : "Multi-Sport" %>
                  </span>
                  <div class="absolute bottom-3 right-3 bg-surface-container-lowest/95 backdrop-blur-md px-2.5 py-0.5 rounded-lg shadow-sm text-right">
                    <span class="font-headline-sm font-bold text-primary text-sm">₹<%= (int) t.getPricePerHour() %></span>
                    <span class="font-label-sm text-secondary text-[11px]">/ hr</span>
                  </div>
                </div>

                <div class="p-unit-md flex-1 flex flex-col justify-between space-y-unit-sm">
                  <div>
                    <h3 class="font-headline-sm font-bold text-on-surface group-hover:text-primary transition-colors text-base line-clamp-1">
                      <%= t.getTurfName() %>
                    </h3>
                    <div class="flex items-center justify-between text-xs text-secondary mt-1">
                      <div class="flex items-center gap-1">
                        <span class="material-symbols-outlined text-xs text-primary">location_on</span>
                        <span><%= t.getCity() %></span>
                      </div>
                      <a href="https://www.google.com/maps/search/?api=1&query=<%= gpsQuery %>" target="_blank" class="text-[#1a73e8] font-semibold hover:underline flex items-center gap-0.5" title="Open Google Maps GPS">
                        <span class="material-symbols-outlined text-[13px]">near_me</span>
                        <span>GPS</span>
                      </a>
                    </div>
                  </div>

                  <div class="pt-2 border-t border-outline-variant/20 flex items-center justify-between gap-2">
                    <span class="text-xs text-secondary font-mono">Capacity: <%= t.getCapacity() %> players</span>
                    <a href="<%= request.getContextPath() %>/turfs?id=<%= t.getTurfId() %>" class="px-unit-md py-1.5 bg-primary hover:bg-primary-container text-on-primary font-label-sm font-bold rounded-lg shadow-sm transition-all flex items-center gap-1">
                      <span>Book Slot</span>
                      <span class="material-symbols-outlined text-xs">arrow_forward</span>
                    </a>
                  </div>
                </div>
              </div>
            <% } %>
          </div>
        <% } %>
      </div>

      <!-- Recent Matches List -->
      <div class="bg-surface-container-lowest rounded-2xl p-unit-lg shadow-sm border border-outline-variant/30 space-y-unit-md">
        <div class="flex items-center justify-between border-b border-outline-variant/20 pb-unit-sm">
          <h3 class="font-headline-sm font-bold text-on-surface">Your Bookings Activity</h3>
          <a href="<%= request.getContextPath() %>/user/booking?action=my-bookings" class="text-primary font-label-md font-bold hover:underline">
            View All →
          </a>
        </div>

        <% if (userBookings != null && !userBookings.isEmpty()) { %>
          <div class="divide-y divide-outline-variant/20">
            <% for (Booking b : userBookings) { 
                 String bGpsQuery = java.net.URLEncoder.encode((b.getTurfName() != null ? b.getTurfName() : "Turf") + " " + (b.getTurfLocation() != null ? b.getTurfLocation() : "Bengaluru"), "UTF-8");
                 boolean bExpired = b.isExpired() || "EXPIRED".equals(b.getStatus().name());
            %>
              <div class="py-unit-sm flex flex-col sm:flex-row sm:items-center justify-between gap-unit-sm">
                <div>
                  <div class="flex items-center gap-unit-xs">
                    <span class="font-mono text-xs font-bold text-secondary"><%= b.getBookingId() %></span>
                    <% if (bExpired) { %>
                      <span class="text-xs font-bold px-2 py-0.5 rounded-full bg-slate-100 text-slate-700 border border-slate-300 flex items-center gap-0.5">
                        <span class="material-symbols-outlined text-[12px] text-amber-600">history</span>
                        EXPIRED
                      </span>
                    <% } else if ("CONFIRMED".equals(b.getStatus().name())) { %>
                      <span class="text-xs font-bold px-2 py-0.5 rounded-full bg-green-100 text-green-800 flex items-center gap-0.5">
                        <span class="material-symbols-outlined text-[12px]">check_circle</span>
                        CONFIRMED
                      </span>
                    <% } else if ("PENDING".equals(b.getStatus().name())) { %>
                      <span class="text-xs font-bold px-2 py-0.5 rounded-full bg-amber-100 text-amber-800">
                        PENDING
                      </span>
                    <% } else { %>
                      <span class="text-xs font-bold px-2 py-0.5 rounded-full bg-surface-container text-secondary">
                        <%= b.getStatus().name() %>
                      </span>
                    <% } %>
                  </div>
                  <div class="flex items-center gap-1.5 flex-wrap mt-0.5">
                    <span class="font-label-lg font-bold text-on-surface"><%= b.getTurfName() != null ? b.getTurfName() : b.getTurfId() %></span>
                    <% if (b.getCourtCount() > 0) { %>
                      <span class="inline-flex items-center gap-1 px-2 py-0.5 rounded-full bg-blue-100 text-blue-800 text-[10px] font-bold">
                        🏸 <%= b.getCourtsDisplay() %>
                      </span>
                    <% } %>
                  </div>
                  <div class="flex items-center gap-2 text-xs text-secondary">
                    <span><%= b.getBookingDate() %> • <%= b.getStartTime() %> – <%= b.getEndTime() %></span>
                    <span>•</span>
                    <a href="https://www.google.com/maps/search/?api=1&query=<%= bGpsQuery %>" target="_blank" class="text-[#1a73e8] hover:underline font-semibold flex items-center gap-0.5" title="Navigate on Google Maps">
                      <span class="material-symbols-outlined text-[13px]">near_me</span>
                      <span>GPS</span>
                    </a>
                  </div>
                </div>
                <div class="flex items-center gap-unit-md">
                  <span class="font-headline-sm font-bold text-on-surface">₹<%= (int) b.getTotalAmount() %></span>
                  <a href="<%= request.getContextPath() %>/user/booking?action=details&id=<%= b.getBookingId() %>" class="px-unit-md py-1.5 <%= bExpired ? "bg-surface-container-high text-slate-700" : "bg-surface-container text-primary" %> hover:bg-surface-container-highest font-label-sm font-bold rounded-lg transition-colors flex items-center gap-1">
                    <span><%= bExpired ? "Archived Pass" : "Pass" %></span>
                    <span class="material-symbols-outlined text-xs">arrow_forward</span>
                  </a>
                </div>
              </div>
            <% } %>
          </div>
        <% } else { %>
          <p class="text-body-sm text-secondary italic py-unit-sm">No match history yet.</p>
        <% } %>
      </div>

    </div>
  </main>
  <script src="<%= request.getContextPath() %>/js/app.js"></script>
</body>
</html>
