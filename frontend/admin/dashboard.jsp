<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.turfbook.model.Booking" %>
<%@ page import="com.turfbook.model.User" %>
<%@ page import="java.util.List" %>
<%
    Long activeTurfs = (Long) request.getAttribute("activeTurfs");
    Long totalUsers = (Long) request.getAttribute("totalUsers");
    Long totalBookings = (Long) request.getAttribute("totalBookings");
    Double totalRevenue = (Double) request.getAttribute("totalRevenue");

    Long todayBookingsCount = (Long) request.getAttribute("todayBookingsCount");
    Long todayCheckInsCount = (Long) request.getAttribute("todayCheckInsCount");
    Double todayRevenue = (Double) request.getAttribute("todayRevenue");
    Long pendingBookingsCount = (Long) request.getAttribute("pendingBookingsCount");

    List<Booking> todayBookings = (List<Booking>) request.getAttribute("todayBookings");
    List<Booking> recentCheckIns = (List<Booking>) request.getAttribute("recentCheckIns");
    List<Booking> recentBookings = (List<Booking>) request.getAttribute("recentBookings");

    User currentUser = (User) session.getAttribute("user");

    if (activeTurfs == null) activeTurfs = 4L;
    if (totalUsers == null) totalUsers = 2L;
    if (totalBookings == null) totalBookings = 0L;
    if (totalRevenue == null) totalRevenue = 0.0;
    if (todayBookingsCount == null) todayBookingsCount = 0L;
    if (todayCheckInsCount == null) todayCheckInsCount = 0L;
    if (todayRevenue == null) todayRevenue = 0.0;
    if (pendingBookingsCount == null) pendingBookingsCount = 0L;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <meta name="theme-color" content="#006b2c"/>
  <link rel="manifest" href="<%= request.getContextPath() %>/manifest.json"/>
  <title>Admin Dashboard • TurfOps</title>
  <link href="https://fonts.googleapis.com" rel="preconnect"/>
  <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&display=block" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;family=Outfit:wght@600;700;800&amp;display=swap" rel="stylesheet"/>
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
          borderRadius: { 'DEFAULT': '0.25rem', 'lg': '0.5rem', 'xl': '0.75rem', 'full': '9999px' },
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
      <!-- Close drawer button on mobile -->
      <button class="lg:hidden p-1.5 rounded-lg text-secondary hover:bg-surface-container-high" onclick="closeAdminSidebar()">
        <span class="material-symbols-outlined text-xl">close</span>
      </button>
    </div>

    <!-- Complete 11 Admin Modules + QR Scanner -->
    <nav class="flex-1 px-unit-sm py-unit-md space-y-1 overflow-y-auto">
      <a class="flex items-center gap-unit-sm px-unit-sm py-2.5 rounded-xl transition-all bg-primary text-on-primary font-bold shadow-sm" href="<%= request.getContextPath() %>/admin/dashboard">
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
      <a class="flex items-center gap-unit-sm px-unit-sm py-2.5 rounded-xl text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all font-label-lg" href="<%= request.getContextPath() %>/admin/bookings">
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

  <!-- Right Main Area with responsive padding -->
  <div class="admin-main-wrap pl-[280px]">
    
    <!-- Top Admin Header -->
    <header class="admin-header-wrap fixed top-0 left-[280px] right-0 h-16 bg-surface-container-lowest border-b border-outline-variant/30 z-40 flex items-center justify-between px-unit-md lg:px-unit-lg shadow-sm">
      <div class="flex items-center gap-unit-sm">
        <!-- Hamburger Button on Mobile -->
        <button type="button" class="lg:hidden p-2 rounded-xl text-on-surface hover:bg-surface-container transition-colors" onclick="toggleAdminSidebar()" aria-label="Open menu">
          <span class="material-symbols-outlined text-2xl">menu</span>
        </button>
        <div class="flex items-center gap-unit-xs text-sm font-semibold text-secondary">
          <span class="hidden sm:inline">Operator Control Center</span>
          <span class="sm:hidden font-bold text-on-surface">TurfBook Admin</span>
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

    <!-- Main Content -->
    <main class="w-full pt-20 px-unit-md lg:px-unit-lg py-unit-lg min-h-screen">
      <div class="flex flex-col w-full space-y-unit-lg">
        
        <!-- Welcome Bar -->
        <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-unit-md bg-surface-container-lowest p-unit-md sm:p-unit-lg rounded-2xl shadow-sm border border-outline-variant/30">
          <div>
            <div class="flex items-center gap-2">
              <span class="font-label-sm uppercase tracking-wider text-primary font-bold">System Status</span>
              <span class="bg-primary/10 text-primary text-[11px] font-bold px-2 py-0.5 rounded-full">Live Ground Telemetry</span>
            </div>
            <h1 class="font-headline-lg font-bold text-on-surface mt-0.5 text-2xl lg:text-3xl">TurfOps Command Center</h1>
            <p class="font-body-md text-secondary text-xs sm:text-sm">Real-time ground metrics, mobile gate dispatch, and revenue matrix.</p>
          </div>
          <div class="flex flex-wrap items-center gap-unit-xs sm:gap-unit-sm w-full sm:w-auto">
            <a href="<%= request.getContextPath() %>/admin/scanner" class="flex-1 sm:flex-none px-unit-md py-2.5 bg-primary hover:bg-primary-container text-on-primary font-label-md font-bold rounded-xl shadow-sm transition-all flex items-center justify-center gap-1.5">
              <span class="material-symbols-outlined text-lg">qr_code_scanner</span>
              <span>Scan QR Pass</span>
            </a>
            <a href="<%= request.getContextPath() %>/admin/turf?action=add" class="flex-1 sm:flex-none px-unit-md py-2.5 bg-surface-container hover:bg-surface-container-high text-on-surface font-label-md font-bold rounded-xl transition-colors flex items-center justify-center gap-1">
              <span class="material-symbols-outlined text-lg">add</span>
              <span>Add Pitch</span>
            </a>
          </div>
        </div>

        <!-- OPERATIONAL TODAY MATRIX (Prioritized for Mobile & Gate Operations) -->
        <div class="bg-surface-container-lowest p-unit-md sm:p-unit-lg rounded-2xl border border-outline-variant/30 shadow-sm">
          <div class="flex items-center justify-between mb-3">
            <div>
              <span class="font-label-sm uppercase tracking-wider text-primary font-bold">Operational Telemetry</span>
              <h2 class="font-headline-sm font-bold text-on-surface text-lg">Today's Ground Operations</h2>
            </div>
            <span class="text-xs font-mono font-semibold text-secondary bg-surface-container px-2.5 py-1 rounded-md">
              <%= java.time.LocalDate.now().toString() %>
            </span>
          </div>

          <div class="grid grid-cols-2 lg:grid-cols-5 gap-unit-xs sm:gap-unit-sm">
            <div class="p-3 bg-surface-container-low rounded-xl border border-outline-variant/20">
              <span class="text-[11px] text-secondary font-bold uppercase block">Today's Bookings</span>
              <span class="text-xl font-bold text-on-surface"><%= todayBookingsCount %></span>
              <span class="text-[10px] text-primary block mt-0.5">Scheduled Matches</span>
            </div>
            <div class="p-3 bg-green-50 rounded-xl border border-green-200">
              <span class="text-[11px] text-green-800 font-bold uppercase block">Today's Check-Ins</span>
              <span class="text-xl font-bold text-green-900"><%= todayCheckInsCount %></span>
              <span class="text-[10px] text-green-700 block mt-0.5">Admitted through Gate</span>
            </div>
            <div class="p-3 bg-surface-container-low rounded-xl border border-outline-variant/20">
              <span class="text-[11px] text-secondary font-bold uppercase block">Today's Revenue</span>
              <span class="text-xl font-bold text-primary">₹<%= (int) todayRevenue.doubleValue() %></span>
              <span class="text-[10px] text-secondary block mt-0.5">Settled</span>
            </div>
            <div class="p-3 bg-surface-container-low rounded-xl border border-outline-variant/20">
              <span class="text-[11px] text-secondary font-bold uppercase block">Active Turfs</span>
              <span class="text-xl font-bold text-on-surface"><%= activeTurfs %></span>
              <span class="text-[10px] text-primary block mt-0.5">Available Pitches</span>
            </div>
            <div class="p-3 bg-amber-50 rounded-xl border border-amber-200 col-span-2 lg:col-span-1">
              <span class="text-[11px] text-amber-800 font-bold uppercase block">Pending Payment</span>
              <span class="text-xl font-bold text-amber-900"><%= pendingBookingsCount %></span>
              <span class="text-[10px] text-amber-700 block mt-0.5">Awaiting Checkout</span>
            </div>
          </div>

          <!-- Quick Action Buttons Bar -->
          <div class="mt-4 pt-3 border-t border-outline-variant/20">
            <span class="text-[11px] font-bold text-secondary uppercase tracking-wider block mb-2">Operator Quick Actions</span>
            <div class="grid grid-cols-3 sm:grid-cols-6 gap-2">
              <a href="<%= request.getContextPath() %>/admin/scanner" class="py-2.5 px-2 bg-primary text-white font-bold text-xs rounded-xl shadow-sm text-center flex flex-col items-center gap-1 hover:bg-primary-container transition-all">
                <span class="material-symbols-outlined text-lg">qr_code_scanner</span>
                <span class="truncate">SCAN QR</span>
              </a>
              <a href="<%= request.getContextPath() %>/admin/bookings" class="py-2.5 px-2 bg-surface-container hover:bg-surface-container-high text-on-surface font-bold text-xs rounded-xl text-center flex flex-col items-center gap-1 transition-colors">
                <span class="material-symbols-outlined text-lg">receipt_long</span>
                <span class="truncate">BOOKINGS</span>
              </a>
              <a href="<%= request.getContextPath() %>/admin/turf?action=list" class="py-2.5 px-2 bg-surface-container hover:bg-surface-container-high text-on-surface font-bold text-xs rounded-xl text-center flex flex-col items-center gap-1 transition-colors">
                <span class="material-symbols-outlined text-lg">stadium</span>
                <span class="truncate">TURFS</span>
              </a>
              <a href="<%= request.getContextPath() %>/admin/turf?action=add" class="py-2.5 px-2 bg-surface-container hover:bg-surface-container-high text-on-surface font-bold text-xs rounded-xl text-center flex flex-col items-center gap-1 transition-colors">
                <span class="material-symbols-outlined text-lg">add_circle</span>
                <span class="truncate">ADD TURF</span>
              </a>
              <a href="<%= request.getContextPath() %>/admin/users" class="py-2.5 px-2 bg-surface-container hover:bg-surface-container-high text-on-surface font-bold text-xs rounded-xl text-center flex flex-col items-center gap-1 transition-colors">
                <span class="material-symbols-outlined text-lg">group</span>
                <span class="truncate">USERS</span>
              </a>
              <a href="<%= request.getContextPath() %>/admin/payments" class="py-2.5 px-2 bg-surface-container hover:bg-surface-container-high text-on-surface font-bold text-xs rounded-xl text-center flex flex-col items-center gap-1 transition-colors">
                <span class="material-symbols-outlined text-lg">payments</span>
                <span class="truncate">PAYMENTS</span>
              </a>
            </div>
          </div>
        </div>

        <!-- 4 Key Admin KPIs with Real MongoDB Data -->
        <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-unit-md">
          
          <div class="bg-surface-container-lowest p-unit-lg rounded-2xl shadow-sm hover:shadow-md transition-all border border-outline-variant/30 flex items-start justify-between">
            <div>
              <span class="font-label-sm uppercase tracking-wider text-secondary font-bold">Active Pitches</span>
              <h2 class="font-headline-xl font-bold text-on-surface mt-1"><%= activeTurfs %></h2>
              <span class="text-xs text-primary font-bold mt-2 inline-block">100% Grounds Operational</span>
            </div>
            <div class="w-12 h-12 rounded-xl bg-surface-container text-primary flex items-center justify-center">
              <span class="material-symbols-outlined text-2xl">stadium</span>
            </div>
          </div>

          <div class="bg-surface-container-lowest p-unit-lg rounded-2xl shadow-sm hover:shadow-md transition-all border border-outline-variant/30 flex items-start justify-between">
            <div>
              <span class="font-label-sm uppercase tracking-wider text-secondary font-bold">Total Reservations</span>
              <h2 class="font-headline-xl font-bold text-on-surface mt-1"><%= totalBookings %></h2>
              <span class="text-xs text-primary font-bold mt-2 inline-block">All Channels Active</span>
            </div>
            <div class="w-12 h-12 rounded-xl bg-secondary-container/50 text-secondary flex items-center justify-center">
              <span class="material-symbols-outlined text-2xl">receipt_long</span>
            </div>
          </div>

          <div class="bg-surface-container-lowest p-unit-lg rounded-2xl shadow-sm hover:shadow-md transition-all border border-outline-variant/30 flex items-start justify-between">
            <div>
              <span class="font-label-sm uppercase tracking-wider text-secondary font-bold">Registered Players</span>
              <h2 class="font-headline-xl font-bold text-on-surface mt-1"><%= totalUsers %></h2>
              <span class="text-xs text-secondary font-semibold mt-2 inline-block">Role Verified</span>
            </div>
            <div class="w-12 h-12 rounded-xl bg-tertiary-container/30 text-tertiary flex items-center justify-center">
              <span class="material-symbols-outlined text-2xl">group</span>
            </div>
          </div>

          <div class="bg-surface-container-lowest p-unit-lg rounded-2xl shadow-sm hover:shadow-md transition-all border border-outline-variant/30 flex items-start justify-between">
            <div>
              <span class="font-label-sm uppercase tracking-wider text-secondary font-bold">Gross Revenue</span>
              <h2 class="font-headline-xl font-bold text-primary mt-1">₹<%= (int) totalRevenue.doubleValue() %></h2>
              <span class="text-xs text-primary font-bold mt-2 inline-block">Settled via Razorpay / UPI</span>
            </div>
            <div class="w-12 h-12 rounded-xl bg-surface-container-high text-on-secondary-container flex items-center justify-center">
              <span class="material-symbols-outlined text-2xl">payments</span>
            </div>
          </div>

        </div>

        <!-- TWO COLUMN SECTION: Today's Bookings + Recent Check-Ins -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-unit-md">
          
          <!-- Today's Bookings Manifest -->
          <div class="bg-surface-container-lowest p-unit-md sm:p-unit-lg rounded-2xl border border-outline-variant/30 shadow-sm">
            <div class="flex items-center justify-between mb-3">
              <div class="flex items-center gap-1.5">
                <span class="material-symbols-outlined text-primary text-xl">event_available</span>
                <h3 class="font-headline-sm font-bold text-on-surface text-base">Today's Match Bookings</h3>
              </div>
              <a href="<%= request.getContextPath() %>/admin/bookings" class="text-xs font-bold text-primary hover:underline">All Bookings</a>
            </div>

            <div class="space-y-2">
              <% if (todayBookings != null && !todayBookings.isEmpty()) { %>
                <% for (Booking b : todayBookings) { %>
                  <div class="p-3 rounded-xl bg-surface-container-low border border-outline-variant/20 flex items-center justify-between text-xs">
                    <div>
                      <div class="flex items-center gap-1.5">
                        <span class="font-mono font-bold text-on-surface"><%= b.getBookingId() %></span>
                        <% if (b.getCheckInStatus() == com.turfbook.enums.CheckInStatus.CHECKED_IN) { %>
                          <span class="bg-green-100 text-green-800 font-bold px-2 py-0.2 rounded-full text-[10px]">CHECKED IN</span>
                        <% } else { %>
                          <span class="bg-amber-100 text-amber-800 font-bold px-2 py-0.2 rounded-full text-[10px]">CONFIRMED</span>
                        <% } %>
                      </div>
                      <p class="font-semibold text-on-surface text-sm mt-0.5"><%= b.getTurfName() != null ? b.getTurfName() : b.getTurfId() %></p>
                      <p class="text-secondary font-mono text-[11px]"><%= b.getStartTime() %> – <%= b.getEndTime() %> • ₹<%= (int) b.getTotalAmount() %></p>
                    </div>
                    <div class="text-right">
                      <% if (b.getCheckInStatus() == com.turfbook.enums.CheckInStatus.CHECKED_IN) { %>
                        <span class="text-green-700 font-bold flex items-center gap-0.5 text-xs">
                          <span class="material-symbols-outlined text-sm">check_circle</span>
                          Admitted
                        </span>
                      <% } else { %>
                        <a href="<%= request.getContextPath() %>/admin/scanner" class="px-2.5 py-1 bg-primary text-white font-bold text-[11px] rounded-lg shadow-sm">
                          Scan Pass
                        </a>
                      <% } %>
                    </div>
                  </div>
                <% } %>
              <% } else { %>
                <div class="py-6 text-center text-secondary text-xs">
                  No match reservations scheduled for today yet.
                </div>
              <% } %>
            </div>
          </div>

          <!-- Today's / Recent Check-Ins -->
          <div class="bg-surface-container-lowest p-unit-md sm:p-unit-lg rounded-2xl border border-outline-variant/30 shadow-sm">
            <div class="flex items-center justify-between mb-3">
              <div class="flex items-center gap-1.5">
                <span class="material-symbols-outlined text-primary text-xl">done_all</span>
                <h3 class="font-headline-sm font-bold text-on-surface text-base">Recent Gate Check-Ins</h3>
              </div>
              <a href="<%= request.getContextPath() %>/admin/checkin?action=history" class="text-xs font-bold text-primary hover:underline">Full Log</a>
            </div>

            <div class="space-y-2">
              <% if (recentCheckIns != null && !recentCheckIns.isEmpty()) { %>
                <% for (Booking b : recentCheckIns) { %>
                  <div class="p-3 rounded-xl bg-surface-container-low border border-outline-variant/20 flex items-center justify-between text-xs">
                    <div>
                      <div class="flex items-center gap-1.5">
                        <span class="font-mono font-bold text-on-surface"><%= b.getBookingId() %></span>
                        <span class="bg-green-100 text-green-800 font-bold px-2 py-0.2 rounded-full text-[10px]">CHECKED IN</span>
                      </div>
                      <p class="font-semibold text-on-surface text-sm mt-0.5"><%= b.getTurfName() != null ? b.getTurfName() : b.getTurfId() %></p>
                      <p class="text-secondary text-[11px]"><%= b.getUserName() != null ? b.getUserName() : b.getUserId() %> • <%= b.getStartTime() %> - <%= b.getEndTime() %></p>
                    </div>
                    <div class="text-right">
                      <span class="font-mono text-primary font-semibold block text-[11px]"><%= b.getBookingDate() %></span>
                      <span class="text-[10px] text-secondary">by <%= b.getCheckedInBy() != null ? b.getCheckedInBy() : "admin" %></span>
                    </div>
                  </div>
                <% } %>
              <% } else { %>
                <div class="py-6 text-center text-secondary text-xs">
                  No gate check-ins logged yet today.
                </div>
              <% } %>
            </div>
          </div>

        </div>

        <!-- Real-Time Ground Performance Visualizer (Weekly Utilization Chart) -->
        <div class="bg-surface-container-lowest p-unit-lg rounded-2xl border border-outline-variant/30 shadow-sm">
          <div class="flex items-center justify-between mb-unit-md">
            <div>
              <span class="font-label-sm uppercase tracking-wider text-primary font-bold">Operational Matrix</span>
              <h3 class="font-headline-sm font-bold text-on-surface text-lg">Weekly Booking Dispatch &amp; Utilization</h3>
            </div>
            <span class="text-xs font-mono text-secondary bg-surface-container px-2.5 py-1 rounded-md">Live Stream</span>
          </div>

          <div class="grid grid-cols-7 gap-2 h-36 items-end pt-4 border-b border-outline-variant/20 pb-2">
            <div class="flex flex-col items-center gap-1.5 h-full justify-end">
              <div class="w-full bg-primary/20 rounded-t-lg transition-all duration-700 hover:bg-primary" style="height: 45%;"></div>
              <span class="text-[11px] font-mono text-secondary font-semibold">Mon</span>
            </div>
            <div class="flex flex-col items-center gap-1.5 h-full justify-end">
              <div class="w-full bg-primary/30 rounded-t-lg transition-all duration-700 hover:bg-primary" style="height: 60%;"></div>
              <span class="text-[11px] font-mono text-secondary font-semibold">Tue</span>
            </div>
            <div class="flex flex-col items-center gap-1.5 h-full justify-end">
              <div class="w-full bg-primary/40 rounded-t-lg transition-all duration-700 hover:bg-primary" style="height: 52%;"></div>
              <span class="text-[11px] font-mono text-secondary font-semibold">Wed</span>
            </div>
            <div class="flex flex-col items-center gap-1.5 h-full justify-end">
              <div class="w-full bg-primary/50 rounded-t-lg transition-all duration-700 hover:bg-primary" style="height: 78%;"></div>
              <span class="text-[11px] font-mono text-secondary font-semibold">Thu</span>
            </div>
            <div class="flex flex-col items-center gap-1.5 h-full justify-end">
              <div class="w-full bg-primary/70 rounded-t-lg transition-all duration-700 hover:bg-primary" style="height: 92%;"></div>
              <span class="text-[11px] font-mono text-secondary font-semibold">Fri</span>
            </div>
            <div class="flex flex-col items-center gap-1.5 h-full justify-end">
              <div class="w-full bg-primary rounded-t-lg transition-all duration-700 shadow-md" style="height: 100%;"></div>
              <span class="text-[11px] font-mono text-primary font-bold">Sat</span>
            </div>
            <div class="flex flex-col items-center gap-1.5 h-full justify-end">
              <div class="w-full bg-primary/90 rounded-t-lg transition-all duration-700 shadow-sm" style="height: 96%;"></div>
              <span class="text-[11px] font-mono text-primary font-bold">Sun</span>
            </div>
          </div>
        </div>

        <!-- Quick Hub Actions -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-unit-md">
          <a href="<%= request.getContextPath() %>/admin/turf?action=list" class="p-unit-lg rounded-2xl bg-surface-container-lowest border border-outline-variant/30 shadow-sm hover:shadow-md transition-all flex items-center gap-unit-md group">
            <div class="w-12 h-12 rounded-xl bg-primary/10 text-primary flex items-center justify-center group-hover:bg-primary group-hover:text-on-primary transition-colors">
              <span class="material-symbols-outlined text-2xl">sports_soccer</span>
            </div>
            <div>
              <h3 class="font-label-lg font-bold text-on-surface">Manage Grounds</h3>
              <p class="text-xs text-secondary mt-0.5">Activate, deactivate, or edit turf specifications</p>
            </div>
          </a>

          <a href="<%= request.getContextPath() %>/admin/bookings" class="p-unit-lg rounded-2xl bg-surface-container-lowest border border-outline-variant/30 shadow-sm hover:shadow-md transition-all flex items-center gap-unit-md group">
            <div class="w-12 h-12 rounded-xl bg-primary/10 text-primary flex items-center justify-center group-hover:bg-primary group-hover:text-on-primary transition-colors">
              <span class="material-symbols-outlined text-2xl">receipt_long</span>
            </div>
            <div>
              <h3 class="font-label-lg font-bold text-on-surface">Booking Manifest</h3>
              <p class="text-xs text-secondary mt-0.5">Inspect reservations and cancel duplicate slots</p>
            </div>
          </a>

          <a href="<%= request.getContextPath() %>/admin/users" class="p-unit-lg rounded-2xl bg-surface-container-lowest border border-outline-variant/30 shadow-sm hover:shadow-md transition-all flex items-center gap-unit-md group">
            <div class="w-12 h-12 rounded-xl bg-primary/10 text-primary flex items-center justify-center group-hover:bg-primary group-hover:text-on-primary transition-colors">
              <span class="material-symbols-outlined text-2xl">group</span>
            </div>
            <div>
              <h3 class="font-label-lg font-bold text-on-surface">User Directory</h3>
              <p class="text-xs text-secondary mt-0.5">View all registered players and roles</p>
            </div>
          </a>
        </div>

      </div>
    </main>
  </div>
  <script src="<%= request.getContextPath() %>/js/app.js"></script>
</body>
</html>
