<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.turfbook.model.Booking" %>
<%@ page import="com.turfbook.model.User" %>
<%@ page import="java.util.List" %>
<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    User currentUser = (User) session.getAttribute("user");

    int totalBookings = bookings != null ? bookings.size() : 0;
    int confirmedCount = 0;
    int checkedInCount = 0;
    int cancelledCount = 0;
    double totalRevenue = 0.0;

    if (bookings != null) {
        for (Booking b : bookings) {
            if (b.getCheckInStatus() == com.turfbook.enums.CheckInStatus.CHECKED_IN) {
                checkedInCount++;
            }
            if ("CONFIRMED".equalsIgnoreCase(b.getStatus().name())) {
                confirmedCount++;
                totalRevenue += b.getTotalAmount();
            } else if ("CANCELLED".equalsIgnoreCase(b.getStatus().name())) {
                cancelledCount++;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <meta name="theme-color" content="#006b2c"/>
  <link rel="manifest" href="<%= request.getContextPath() %>/manifest.json"/>
  <title>Reservations Manifest • TurfOps Admin</title>
  <link href="https://fonts.googleapis.com" rel="preconnect"/>
  <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&display=block" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@600;700;800&display=swap" rel="stylesheet"/>
  <link href="<%= request.getContextPath() %>/css/style.css" rel="stylesheet"/>
  <style>
    @layer base{html,body{margin:0;padding:0;}body{overscroll-behavior:none;}main>:first-child{margin-top:0!important;}main>:last-child{margin-bottom:0!important;}}
    ::-webkit-scrollbar{display:none;}
  </style>
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
          borderRadius: { 'DEFAULT': '0.25rem', 'lg': '0.5rem', 'xl': '0.75rem', '2xl': '1rem', 'full': '9999px' },
          spacing: { 'unit-sm': '0.75rem', 'unit-xs': '0.5rem', 'unit-2xs': '0.25rem', 'unit-2xl': '3rem', 'unit-3xl': '4rem', 'admin-sidebar-width': '280px', 'unit-lg': '1.5rem', 'unit-xl': '2rem', 'unit-md': '1rem' },
          fontFamily: { 'display': ['outfit'], 'headline-sm': ['outfit'], 'headline-xl': ['outfit'], 'headline-lg': ['outfit'], 'body-lg': ['inter'], 'body-md': ['inter'], 'body-sm': ['inter'], 'label-lg': ['inter'], 'label-md': ['inter'], 'label-sm': ['inter'] }
        }
      }
    };
  </script>
</head>
<body class="bg-surface font-body-md text-on-surface antialiased min-h-screen">

  <!-- Mobile Backdrop Overlay -->
  <div class="admin-sidebar-backdrop" id="adminBackdrop" onclick="closeAdminSidebar()"></div>

  <!-- Left Sidebar (280px Desktop / Off-canvas Mobile Drawer) -->
  <aside class="admin-sidebar fixed left-0 top-0 h-full w-[280px] bg-surface-container-lowest border-r border-outline-variant/30 z-50 flex flex-col" id="adminSidebar">
    <div class="h-16 px-unit-lg flex items-center border-b border-outline-variant/20 gap-unit-xs justify-between">
      <div class="flex items-center gap-unit-xs">
        <div class="w-8 h-8 rounded-lg bg-primary text-on-primary font-bold flex items-center justify-center shadow-sm">
          <span class="material-symbols-outlined text-[20px]">sports_soccer</span>
        </div>
        <span class="font-headline-sm text-headline-sm text-on-surface font-bold">Turf<span class="text-primary">Ops</span></span>
        <span class="ml-2 text-label-sm px-2 py-0.5 rounded bg-primary/10 text-primary font-bold">ADMIN</span>
      </div>
      <button class="lg:hidden p-1.5 rounded-lg text-secondary hover:bg-surface-container-high transition-colors" onclick="closeAdminSidebar()">
        <span class="material-symbols-outlined text-xl">close</span>
      </button>
    </div>

    <!-- Complete 12 Admin Modules -->
    <nav class="flex-1 px-unit-sm py-unit-md space-y-1 overflow-y-auto">
      <a class="flex items-center gap-unit-sm px-unit-sm py-2.5 rounded-xl text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all font-label-lg" href="<%= request.getContextPath() %>/admin/dashboard">
        <span class="material-symbols-outlined text-xl">dashboard</span>
        <span>Dashboard</span>
      </a>
      <a class="flex items-center gap-unit-sm px-unit-sm py-2.5 rounded-xl text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all font-label-lg" href="<%= request.getContextPath() %>/admin/scanner">
        <span class="material-symbols-outlined text-xl text-primary font-bold">qr_code_scanner</span>
        <span class="font-bold text-on-surface">QR Gate Scanner</span>
      </a>
      <a class="flex items-center gap-unit-sm px-unit-sm py-2.5 rounded-xl text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all font-label-lg" href="<%= request.getContextPath() %>/admin/turf?action=list">
        <span class="material-symbols-outlined text-xl">stadium</span>
        <span>Turf Pitches</span>
      </a>
      <a class="flex items-center gap-unit-sm px-unit-sm py-2.5 rounded-xl transition-all bg-primary text-on-primary font-bold shadow-sm" href="<%= request.getContextPath() %>/admin/bookings">
        <span class="material-symbols-outlined text-xl">receipt_long</span>
        <span>Reservations</span>
      </a>
      <a class="flex items-center gap-unit-sm px-unit-sm py-2.5 rounded-xl text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all font-label-lg" href="<%= request.getContextPath() %>/admin/payments">
        <span class="material-symbols-outlined text-xl">payments</span>
        <span>Slot Payments</span>
      </a>
      <a class="flex items-center gap-unit-sm px-unit-sm py-2.5 rounded-xl text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all font-label-lg" href="<%= request.getContextPath() %>/admin/users">
        <span class="material-symbols-outlined text-xl">group</span>
        <span>Users Directory</span>
      </a>
      <a class="flex items-center gap-unit-sm px-unit-sm py-2.5 rounded-xl text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all font-label-lg" href="<%= request.getContextPath() %>/admin/reviews">
        <span class="material-symbols-outlined text-xl">reviews</span>
        <span>Reviews &amp; Mod</span>
      </a>
      <a class="flex items-center gap-unit-sm px-unit-sm py-2.5 rounded-xl text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all font-label-lg" href="<%= request.getContextPath() %>/admin/turf?action=add">
        <span class="material-symbols-outlined text-xl">add_circle</span>
        <span>Add Pitch</span>
      </a>
      <a class="flex items-center gap-unit-sm px-unit-sm py-2.5 rounded-xl text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all font-label-lg" href="<%= request.getContextPath() %>/admin/reports.jsp">
        <span class="material-symbols-outlined text-xl">analytics</span>
        <span>Reports</span>
      </a>
      <a class="flex items-center gap-unit-sm px-unit-sm py-2.5 rounded-xl text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all font-label-lg" href="<%= request.getContextPath() %>/admin/notifications.jsp">
        <span class="material-symbols-outlined text-xl">notifications</span>
        <span>Alerts</span>
      </a>
      <a class="flex items-center gap-unit-sm px-unit-sm py-2.5 rounded-xl text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all font-label-lg" href="<%= request.getContextPath() %>/admin/checkin?action=history">
        <span class="material-symbols-outlined text-xl">history</span>
        <span>Check-In Log</span>
      </a>
    </nav>
  </aside>

  <!-- Right Content Area -->
  <div class="admin-main-wrap pl-[280px]">
    <header class="admin-header-wrap fixed top-0 left-[280px] right-0 h-16 bg-surface-container-lowest border-b border-outline-variant/30 z-40 flex items-center justify-between px-unit-md lg:px-unit-lg shadow-sm">
      <div class="flex items-center gap-unit-sm">
        <button type="button" class="lg:hidden p-2 rounded-xl text-on-surface hover:bg-surface-container transition-colors" onclick="toggleAdminSidebar()" aria-label="Open menu">
          <span class="material-symbols-outlined text-2xl">menu</span>
        </button>
        <div class="flex items-center gap-unit-xs text-sm font-semibold text-secondary">
          <span class="hidden sm:inline">Operator Control Center</span>
          <span class="text-outline hidden sm:inline">/</span>
          <span class="font-bold text-on-surface">Reservations Manifest</span>
        </div>
      </div>

      <div class="flex items-center gap-unit-sm">
        <a href="<%= request.getContextPath() %>/admin/scanner" class="px-3 py-1.5 bg-primary hover:bg-primary-container text-on-primary font-bold text-xs rounded-xl shadow-sm flex items-center gap-1.5 transition-all">
          <span class="material-symbols-outlined text-base">qr_code_scanner</span>
          <span class="hidden sm:inline">Scan QR</span>
        </a>
        <div class="flex items-center gap-unit-xs pl-unit-xs py-1 pr-unit-sm rounded-full bg-surface-container-low border border-outline-variant/40">
          <div class="w-7 h-7 rounded-full bg-primary text-on-primary font-bold flex items-center justify-center text-xs">
            <%= (currentUser != null && currentUser.getUsername() != null) ? currentUser.getUsername().substring(0, 1).toUpperCase() : "A" %>
          </div>
          <span class="font-label-md text-on-surface font-bold text-xs sm:text-sm">Admin Ops</span>
        </div>
        <a href="<%= request.getContextPath() %>/logout" class="p-2 text-on-surface-variant hover:text-error transition-colors" title="Sign Out">
          <span class="material-symbols-outlined text-[20px]">logout</span>
        </a>
      </div>
    </header>

    <main class="w-full pt-20 px-unit-md lg:px-unit-lg py-unit-lg min-h-screen">
      <div class="flex flex-col w-full space-y-unit-lg pb-unit-3xl">
        
        <!-- Header Banner -->
        <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-unit-md bg-surface-container-lowest p-unit-md sm:p-unit-lg rounded-2xl shadow-sm border border-outline-variant/30">
          <div>
            <div class="flex items-center gap-2">
              <span class="font-label-sm uppercase tracking-wider text-primary font-bold">Booking Database</span>
              <span class="bg-primary/10 text-primary text-[11px] font-bold px-2 py-0.5 rounded-full"><%= totalBookings %> Total Slots</span>
            </div>
            <h1 class="font-headline-lg font-bold text-on-surface mt-0.5 text-2xl lg:text-3xl">Match Booking Manifest</h1>
            <p class="font-body-md text-secondary text-xs sm:text-sm">Real-time player reservations ledger, QR gate validation, payment clearance, and cancellations.</p>
          </div>
          <div class="flex flex-wrap items-center gap-unit-xs sm:gap-unit-sm w-full sm:w-auto">
            <a href="<%= request.getContextPath() %>/admin/scanner" class="flex-1 sm:flex-none px-unit-md py-2.5 bg-primary hover:bg-primary-container text-on-primary font-label-md font-bold rounded-xl shadow-sm transition-all flex items-center justify-center gap-1.5">
              <span class="material-symbols-outlined text-lg">qr_code_scanner</span>
              <span>Open Scanner</span>
            </a>
            <a href="<%= request.getContextPath() %>/admin/checkin?action=history" class="flex-1 sm:flex-none px-unit-md py-2.5 bg-surface-container hover:bg-surface-container-high text-on-surface font-label-md font-bold rounded-xl transition-colors flex items-center justify-center gap-1.5">
              <span class="material-symbols-outlined text-lg">history</span>
              <span>Check-In Log</span>
            </a>
          </div>
        </div>

        <!-- Telemetry Stats Row -->
        <div class="grid grid-cols-2 md:grid-cols-4 gap-unit-md">
          <div class="bg-surface-container-lowest p-4 rounded-2xl border border-outline-variant/30 shadow-sm flex items-center gap-3">
            <div class="w-10 h-10 rounded-xl bg-primary/10 text-primary flex items-center justify-center flex-shrink-0">
              <span class="material-symbols-outlined text-xl">receipt_long</span>
            </div>
            <div>
              <span class="text-xs text-secondary font-medium block">Total Bookings</span>
              <span class="text-xl font-bold font-headline-sm text-on-surface"><%= totalBookings %></span>
            </div>
          </div>
          <div class="bg-surface-container-lowest p-4 rounded-2xl border border-outline-variant/30 shadow-sm flex items-center gap-3">
            <div class="w-10 h-10 rounded-xl bg-blue-100 text-blue-700 flex items-center justify-center flex-shrink-0">
              <span class="material-symbols-outlined text-xl">done_all</span>
            </div>
            <div>
              <span class="text-xs text-secondary font-medium block">Checked-In Gate</span>
              <span class="text-xl font-bold font-headline-sm text-blue-700"><%= checkedInCount %></span>
            </div>
          </div>
          <div class="bg-surface-container-lowest p-4 rounded-2xl border border-outline-variant/30 shadow-sm flex items-center gap-3">
            <div class="w-10 h-10 rounded-xl bg-green-100 text-green-700 flex items-center justify-center flex-shrink-0">
              <span class="material-symbols-outlined text-xl">check_circle</span>
            </div>
            <div>
              <span class="text-xs text-secondary font-medium block">Confirmed Matches</span>
              <span class="text-xl font-bold font-headline-sm text-green-700"><%= confirmedCount %></span>
            </div>
          </div>
          <div class="bg-surface-container-lowest p-4 rounded-2xl border border-outline-variant/30 shadow-sm flex items-center gap-3">
            <div class="w-10 h-10 rounded-xl bg-amber-100 text-amber-700 flex items-center justify-center flex-shrink-0">
              <span class="material-symbols-outlined text-xl">payments</span>
            </div>
            <div>
              <span class="text-xs text-secondary font-medium block">Active Revenue</span>
              <span class="text-xl font-bold font-headline-sm text-on-surface">₹<%= (int) totalRevenue %></span>
            </div>
          </div>
        </div>

        <% if (success != null && !success.isEmpty()) { %>
          <div class="p-unit-sm rounded-xl bg-green-100 text-green-800 border border-green-300 font-body-sm font-semibold text-xs sm:text-sm flex items-center gap-2">
            <span class="material-symbols-outlined text-base">check_circle</span>
            <span><%= success %></span>
          </div>
        <% } %>

        <% if (error != null && !error.isEmpty()) { %>
          <div class="p-unit-sm rounded-xl bg-error-container text-on-error-container font-body-sm font-semibold text-xs sm:text-sm flex items-center gap-2">
            <span class="material-symbols-outlined text-base">error</span>
            <span><%= error %></span>
          </div>
        <% } %>

        <!-- Filter & Search Controls -->
        <div class="bg-surface-container-lowest p-3 sm:p-4 rounded-2xl border border-outline-variant/30 shadow-sm flex flex-col md:flex-row items-stretch md:items-center justify-between gap-3">
          <div class="relative flex-1">
            <span class="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-secondary text-lg">search</span>
            <input type="text" id="bookingSearch" onkeyup="filterBookingsTable()" placeholder="Search by player, pitch, booking ID, date..." class="w-full pl-10 pr-4 py-2.5 rounded-xl bg-surface-container-low border border-outline-variant/40 text-on-surface text-xs sm:text-sm focus:outline-none focus:border-primary transition-colors"/>
          </div>
          <div class="flex items-center gap-2 overflow-x-auto pb-1 md:pb-0">
            <button onclick="setStatusFilter('ALL')" class="status-filter-btn px-3 py-1.5 rounded-lg text-xs font-bold bg-primary text-on-primary transition-all shadow-sm" data-status="ALL">All Slots</button>
            <button onclick="setStatusFilter('CHECKED_IN')" class="status-filter-btn px-3 py-1.5 rounded-lg text-xs font-bold bg-surface-container text-secondary hover:text-on-surface transition-all" data-status="CHECKED_IN">Checked-In</button>
            <button onclick="setStatusFilter('CONFIRMED')" class="status-filter-btn px-3 py-1.5 rounded-lg text-xs font-bold bg-surface-container text-secondary hover:text-on-surface transition-all" data-status="CONFIRMED">Confirmed</button>
            <button onclick="setStatusFilter('CANCELLED')" class="status-filter-btn px-3 py-1.5 rounded-lg text-xs font-bold bg-surface-container text-secondary hover:text-on-surface transition-all" data-status="CANCELLED">Cancelled</button>
          </div>
        </div>

        <!-- Bookings Table Card -->
        <div class="bg-surface-container-lowest rounded-2xl shadow-sm border border-outline-variant/30 overflow-hidden">
          <div class="table-responsive">
            <table class="w-full text-left border-collapse text-xs sm:text-sm" id="bookingsTable">
              <thead>
                <tr class="bg-surface-container-low text-xs uppercase font-bold text-secondary border-b border-outline-variant/30">
                  <th class="py-3.5 px-4">Booking ID</th>
                  <th class="py-3.5 px-4">Player</th>
                  <th class="py-3.5 px-4">Pitch Arena</th>
                  <th class="py-3.5 px-4">Date &amp; Slot</th>
                  <th class="py-3.5 px-4">Amount</th>
                  <th class="py-3.5 px-4">Gate Status</th>
                  <th class="py-3.5 px-4 text-right">Action</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-outline-variant/20 font-medium">
                <% if (bookings != null && !bookings.isEmpty()) { %>
                  <% for (Booking b : bookings) { 
                       boolean isCheckedIn = (b.getCheckInStatus() == com.turfbook.enums.CheckInStatus.CHECKED_IN);
                       String statusName = b.getStatus() != null ? b.getStatus().name() : "PENDING";
                       String filterStatus = isCheckedIn ? "CHECKED_IN" : statusName;
                  %>
                    <tr class="hover:bg-surface-container-low/50 transition-colors booking-row" data-status="<%= filterStatus %>">
                      <td class="py-4 px-4 whitespace-nowrap">
                        <span class="font-mono text-xs font-bold text-on-surface bg-surface-container-low px-2 py-1 rounded-md border border-outline-variant/30 inline-block">
                          <%= b.getBookingId() %>
                        </span>
                      </td>
                      <td class="py-4 px-4 whitespace-nowrap">
                        <div class="flex items-center gap-2.5">
                          <div class="w-8 h-8 rounded-full bg-secondary/15 text-on-surface font-bold flex items-center justify-center text-xs">
                            <%= (b.getUserName() != null && !b.getUserName().isEmpty()) ? b.getUserName().substring(0, 1).toUpperCase() : "P" %>
                          </div>
                          <div>
                            <div class="font-bold text-on-surface text-sm"><%= b.getUserName() != null ? b.getUserName() : "Player" %></div>
                            <span class="text-[11px] text-secondary font-mono"><%= b.getUserId() %></span>
                          </div>
                        </div>
                      </td>
                      <td class="py-4 px-4 min-w-[160px]">
                        <div class="font-bold text-on-surface text-sm flex items-center gap-1.5 flex-wrap">
                          <span><%= b.getTurfName() != null ? b.getTurfName() : b.getTurfId() %></span>
                          <% if (b.getCourtCount() > 0) { %>
                            <span class="inline-flex items-center gap-1 px-2 py-0.5 rounded-full bg-blue-100 text-blue-800 text-[10px] font-bold" title="<%= b.getCourtsDisplay() %>">
                              🏸 <%= b.getCourtsDisplay() %> (<%= b.getCourtCount() %> <%= b.getCourtCount() == 1 ? "Court" : "Courts" %>)
                            </span>
                          <% } %>
                        </div>
                        <a href="https://www.google.com/maps/search/?api=1&query=<%= java.net.URLEncoder.encode((b.getTurfName() != null ? b.getTurfName() : "Turf") + " " + (b.getTurfLocation() != null ? b.getTurfLocation() : "Bengaluru"), "UTF-8") %>" target="_blank" class="inline-flex items-center gap-1 text-[11px] text-primary font-semibold hover:underline mt-0.5">
                          <span class="material-symbols-outlined text-[13px]">near_me</span>
                          <span><%= b.getTurfLocation() != null ? b.getTurfLocation() : "View Location" %></span>
                        </a>
                      </td>
                      <td class="py-4 px-4 whitespace-nowrap">
                        <div class="font-semibold text-on-surface text-xs sm:text-sm"><%= b.getBookingDate() %></div>
                        <span class="font-mono text-xs font-bold text-primary bg-primary/10 px-2 py-0.5 rounded-md inline-block mt-0.5"><%= b.getStartTime() %> – <%= b.getEndTime() %></span>
                      </td>
                      <td class="py-4 px-4 font-bold text-on-surface text-sm sm:text-base whitespace-nowrap">
                        ₹<%= (int) b.getTotalAmount() %>
                      </td>
                      <td class="py-4 px-4 whitespace-nowrap">
                        <% if (isCheckedIn) { %>
                          <span class="bg-blue-100 text-blue-800 text-xs font-bold px-2.5 py-1 rounded-full inline-flex items-center gap-1 shadow-xs">
                            <span class="material-symbols-outlined text-xs">done_all</span>
                            CHECKED IN
                          </span>
                        <% } else if (b.isExpired() || "EXPIRED".equalsIgnoreCase(statusName)) { %>
                          <span class="bg-slate-100 text-slate-700 border border-slate-300 text-xs font-bold px-2.5 py-1 rounded-full">EXPIRED</span>
                        <% } else if ("CONFIRMED".equalsIgnoreCase(statusName)) { %>
                          <span class="bg-green-100 text-green-800 text-xs font-bold px-2.5 py-1 rounded-full inline-flex items-center gap-1 shadow-xs">
                            <span class="w-1.5 h-1.5 rounded-full bg-green-600"></span>
                            CONFIRMED
                          </span>
                        <% } else if ("PENDING".equalsIgnoreCase(statusName)) { %>
                          <span class="bg-amber-100 text-amber-800 text-xs font-bold px-2.5 py-1 rounded-full inline-flex items-center gap-1">
                            <span class="w-1.5 h-1.5 rounded-full bg-amber-600"></span>
                            PENDING
                          </span>
                        <% } else { %>
                          <span class="bg-red-100 text-red-800 text-xs font-bold px-2.5 py-1 rounded-full"><%= statusName %></span>
                        <% } %>
                      </td>
                      <td class="py-4 px-4 text-right whitespace-nowrap">
                        <% if (!"CANCELLED".equalsIgnoreCase(statusName)) { %>
                          <form action="<%= request.getContextPath() %>/admin/bookings" method="POST" class="inline" onsubmit="return confirm('Cancel reservation #<%= b.getBookingId() %>? This will refund and release the slot.');">
                            <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>"/>
                            <input type="hidden" name="action" value="cancel"/>
                            <button type="submit" class="inline-flex items-center gap-1 px-3 py-1.5 rounded-xl bg-error-container text-on-error-container text-xs font-bold hover:opacity-85 transition-all shadow-xs" title="Cancel Booking">
                              <span class="material-symbols-outlined text-sm">cancel</span>
                              <span>Cancel</span>
                            </button>
                          </form>
                        <% } else { %>
                          <span class="text-xs text-secondary/70 italic px-2 py-1 rounded bg-surface-container">Cancelled</span>
                        <% } %>
                      </td>
                    </tr>
                  <% } %>
                <% } else { %>
                  <tr id="emptyBookingsRow">
                    <td colspan="7" class="py-12 text-center text-secondary">
                      <div class="flex flex-col items-center justify-center gap-2">
                        <span class="material-symbols-outlined text-4xl text-outline">receipt_long</span>
                        <p class="font-bold text-on-surface">No reservations recorded yet</p>
                        <p class="text-xs text-secondary">When players book match slots, they will appear in this manifest.</p>
                      </div>
                    </td>
                  </tr>
                <% } %>
              </tbody>
            </table>
          </div>
        </div>

      </div>
    </main>
  </div>

  <script src="<%= request.getContextPath() %>/js/app.js"></script>
  <script>
    let currentStatusFilter = 'ALL';
    function setStatusFilter(status) {
      currentStatusFilter = status;
      document.querySelectorAll('.status-filter-btn').forEach(btn => {
        if (btn.getAttribute('data-status') === status) {
          btn.className = 'status-filter-btn px-3 py-1.5 rounded-lg text-xs font-bold bg-primary text-on-primary transition-all shadow-sm';
        } else {
          btn.className = 'status-filter-btn px-3 py-1.5 rounded-lg text-xs font-bold bg-surface-container text-secondary hover:text-on-surface transition-all';
        }
      });
      filterBookingsTable();
    }

    function filterBookingsTable() {
      const q = (document.getElementById('bookingSearch').value || '').toLowerCase().trim();
      const rows = document.querySelectorAll('.booking-row');
      rows.forEach(row => {
        const text = row.innerText.toLowerCase();
        const status = row.getAttribute('data-status') || '';
        const matchesQuery = !q || text.includes(q);
        const matchesStatus = currentStatusFilter === 'ALL' || status === currentStatusFilter;
        row.style.display = (matchesQuery && matchesStatus) ? '' : 'none';
      });
    }
  </script>
</body>
</html>
