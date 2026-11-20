<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.turfbook.model.Turf" %>
<%@ page import="com.turfbook.model.User" %>
<%@ page import="java.util.List" %>
<%
    List<Turf> turfs = (List<Turf>) request.getAttribute("turfs");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    User currentUser = (User) session.getAttribute("user");

    int totalTurfs = turfs != null ? turfs.size() : 0;
    int activeCount = 0;
    double avgPrice = 0.0;
    double totalPrice = 0.0;
    if (turfs != null && !turfs.isEmpty()) {
        for (Turf t : turfs) {
            if (t.getStatus() != null && "ACTIVE".equalsIgnoreCase(t.getStatus().name())) {
                activeCount++;
            }
            totalPrice += t.getPricePerHour();
        }
        avgPrice = totalPrice / totalTurfs;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <meta name="theme-color" content="#006b2c"/>
  <link rel="manifest" href="<%= request.getContextPath() %>/manifest.json"/>
  <title>Turf Pitches Management • TurfOps Admin</title>
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
      <a class="flex items-center gap-unit-sm px-unit-sm py-2.5 rounded-xl transition-all bg-primary text-on-primary font-bold shadow-sm" href="<%= request.getContextPath() %>/admin/turf?action=list">
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

  <!-- Right Main Area -->
  <div class="admin-main-wrap pl-[280px]">
    <header class="admin-header-wrap fixed top-0 left-[280px] right-0 h-16 bg-surface-container-lowest border-b border-outline-variant/30 z-40 flex items-center justify-between px-unit-md lg:px-unit-lg shadow-sm">
      <div class="flex items-center gap-unit-sm">
        <button type="button" class="lg:hidden p-2 rounded-xl text-on-surface hover:bg-surface-container transition-colors" onclick="toggleAdminSidebar()" aria-label="Open menu">
          <span class="material-symbols-outlined text-2xl">menu</span>
        </button>
        <div class="flex items-center gap-unit-xs text-sm font-semibold text-secondary">
          <span class="hidden sm:inline">Operator Control Center</span>
          <span class="text-outline hidden sm:inline">/</span>
          <span class="font-bold text-on-surface">Turf Pitches Management</span>
        </div>
      </div>

      <div class="flex items-center gap-unit-sm">
        <a href="<%= request.getContextPath() %>/admin/turf?action=add" class="px-3 py-1.5 bg-primary hover:bg-primary-container text-on-primary font-bold text-xs rounded-xl shadow-sm flex items-center gap-1.5 transition-all">
          <span class="material-symbols-outlined text-base">add</span>
          <span class="hidden sm:inline">Add Pitch</span>
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
              <span class="font-label-sm uppercase tracking-wider text-primary font-bold">Facility Operations</span>
              <span class="bg-primary/10 text-primary text-[11px] font-bold px-2 py-0.5 rounded-full"><%= totalTurfs %> Pitches Listed</span>
            </div>
            <h1 class="font-headline-lg font-bold text-on-surface mt-0.5 text-2xl lg:text-3xl">Grounds &amp; Pitches Inventory</h1>
            <p class="font-body-md text-secondary text-xs sm:text-sm">Manage sports arenas, hourly pricing, geolocation, and operational status in MongoDB.</p>
          </div>
          <div class="flex flex-wrap items-center gap-unit-xs sm:gap-unit-sm w-full sm:w-auto">
            <a href="<%= request.getContextPath() %>/admin/turf?action=add" class="flex-1 sm:flex-none px-unit-md py-2.5 bg-primary hover:bg-primary-container text-on-primary font-label-md font-bold rounded-xl shadow-sm transition-all flex items-center justify-center gap-1.5">
              <span class="material-symbols-outlined text-lg">add_circle</span>
              <span>Add New Pitch</span>
            </a>
            <a href="<%= request.getContextPath() %>/admin/scanner" class="flex-1 sm:flex-none px-unit-md py-2.5 bg-surface-container hover:bg-surface-container-high text-on-surface font-label-md font-bold rounded-xl transition-colors flex items-center justify-center gap-1.5">
              <span class="material-symbols-outlined text-lg">qr_code_scanner</span>
              <span>Scan QR</span>
            </a>
          </div>
        </div>

        <!-- Telemetry Stats Row -->
        <div class="grid grid-cols-2 md:grid-cols-4 gap-unit-md">
          <div class="bg-surface-container-lowest p-4 rounded-2xl border border-outline-variant/30 shadow-sm flex items-center gap-3">
            <div class="w-10 h-10 rounded-xl bg-primary/10 text-primary flex items-center justify-center flex-shrink-0">
              <span class="material-symbols-outlined text-xl">stadium</span>
            </div>
            <div>
              <span class="text-xs text-secondary font-medium block">Total Grounds</span>
              <span class="text-xl font-bold font-headline-sm text-on-surface"><%= totalTurfs %></span>
            </div>
          </div>
          <div class="bg-surface-container-lowest p-4 rounded-2xl border border-outline-variant/30 shadow-sm flex items-center gap-3">
            <div class="w-10 h-10 rounded-xl bg-green-100 text-green-700 flex items-center justify-center flex-shrink-0">
              <span class="material-symbols-outlined text-xl">check_circle</span>
            </div>
            <div>
              <span class="text-xs text-secondary font-medium block">Active Grounds</span>
              <span class="text-xl font-bold font-headline-sm text-green-700"><%= activeCount %></span>
            </div>
          </div>
          <div class="bg-surface-container-lowest p-4 rounded-2xl border border-outline-variant/30 shadow-sm flex items-center gap-3">
            <div class="w-10 h-10 rounded-xl bg-amber-100 text-amber-700 flex items-center justify-center flex-shrink-0">
              <span class="material-symbols-outlined text-xl">build_circle</span>
            </div>
            <div>
              <span class="text-xs text-secondary font-medium block">Maintenance</span>
              <span class="text-xl font-bold font-headline-sm text-amber-700"><%= totalTurfs - activeCount %></span>
            </div>
          </div>
          <div class="bg-surface-container-lowest p-4 rounded-2xl border border-outline-variant/30 shadow-sm flex items-center gap-3">
            <div class="w-10 h-10 rounded-xl bg-blue-100 text-blue-700 flex items-center justify-center flex-shrink-0">
              <span class="material-symbols-outlined text-xl">payments</span>
            </div>
            <div>
              <span class="text-xs text-secondary font-medium block">Average Rate</span>
              <span class="text-xl font-bold font-headline-sm text-on-surface">₹<%= (int) avgPrice %>/hr</span>
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

        <!-- Search & Filter Controls -->
        <div class="bg-surface-container-lowest p-3 sm:p-4 rounded-2xl border border-outline-variant/30 shadow-sm flex flex-col md:flex-row items-stretch md:items-center justify-between gap-3">
          <div class="relative flex-1">
            <span class="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-secondary text-lg">search</span>
            <input type="text" id="turfSearch" onkeyup="filterTurfsTable()" placeholder="Search by arena name, location, or turf ID..." class="w-full pl-10 pr-4 py-2.5 rounded-xl bg-surface-container-low border border-outline-variant/40 text-on-surface text-xs sm:text-sm focus:outline-none focus:border-primary transition-colors"/>
          </div>
          <div class="flex items-center gap-2 overflow-x-auto pb-1 md:pb-0">
            <button onclick="setSportFilter('ALL')" class="sport-filter-btn px-3 py-1.5 rounded-lg text-xs font-bold bg-primary text-on-primary transition-all shadow-sm" data-sport="ALL">All Sports</button>
            <button onclick="setSportFilter('FOOTBALL')" class="sport-filter-btn px-3 py-1.5 rounded-lg text-xs font-bold bg-surface-container text-secondary hover:text-on-surface transition-all" data-sport="FOOTBALL">Football</button>
            <button onclick="setSportFilter('CRICKET')" class="sport-filter-btn px-3 py-1.5 rounded-lg text-xs font-bold bg-surface-container text-secondary hover:text-on-surface transition-all" data-sport="CRICKET">Cricket</button>
            <button onclick="setSportFilter('MULTI')" class="sport-filter-btn px-3 py-1.5 rounded-lg text-xs font-bold bg-surface-container text-secondary hover:text-on-surface transition-all" data-sport="MULTI">Multi-Sport</button>
          </div>
        </div>

        <!-- Turfs Table Card -->
        <div class="bg-surface-container-lowest rounded-2xl shadow-sm border border-outline-variant/30 overflow-hidden">
          <div class="table-responsive">
            <table class="w-full text-left border-collapse text-xs sm:text-sm" id="turfsTable">
              <thead>
                <tr class="bg-surface-container-low text-xs uppercase font-bold text-secondary border-b border-outline-variant/30">
                  <th class="py-3.5 px-4">Ground ID &amp; Name</th>
                  <th class="py-3.5 px-4">Type / Sport</th>
                  <th class="py-3.5 px-4">City &amp; Location</th>
                  <th class="py-3.5 px-4">Rate / Hr</th>
                  <th class="py-3.5 px-4">Status</th>
                  <th class="py-3.5 px-4 text-right">Actions</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-outline-variant/20 font-medium">
                <% if (turfs != null && !turfs.isEmpty()) { %>
                  <% for (Turf t : turfs) { 
                       String sportCat = "MULTI";
                       String typeStr = t.getTurfType() != null ? t.getTurfType().name() : "";
                       if (typeStr.contains("FOOTBALL") || typeStr.contains("SOCCER")) sportCat = "FOOTBALL";
                       else if (typeStr.contains("CRICKET")) sportCat = "CRICKET";
                  %>
                    <tr class="hover:bg-surface-container-low/50 transition-colors turf-row" data-sport="<%= sportCat %>">
                      <td class="py-4 px-4 whitespace-nowrap">
                        <div class="flex items-center gap-3">
                          <div class="w-10 h-10 rounded-xl bg-primary/10 text-primary flex items-center justify-center flex-shrink-0 font-bold">
                            <span class="material-symbols-outlined text-xl">stadium</span>
                          </div>
                          <div>
                            <div class="font-bold text-on-surface text-sm sm:text-base"><%= t.getTurfName() %></div>
                            <span class="font-mono text-[11px] text-secondary bg-surface-container px-2 py-0.5 rounded-md inline-block mt-0.5"><%= t.getTurfId() %></span>
                          </div>
                        </div>
                      </td>
                      <td class="py-4 px-4 font-medium whitespace-nowrap">
                        <span class="px-2.5 py-1 rounded-full text-xs font-bold <%= "FOOTBALL".equals(sportCat) ? "bg-green-100 text-green-800" : "CRICKET".equals(sportCat) ? "bg-blue-100 text-blue-800" : "bg-purple-100 text-purple-800" %>">
                          <%= t.getTurfType() != null ? t.getTurfType().getDisplayName() : "Multi-Sport" %>
                        </span>
                      </td>
                      <td class="py-4 px-4 whitespace-nowrap">
                        <div class="font-semibold text-on-surface"><%= t.getCity() %></div>
                        <a href="https://www.google.com/maps/search/?api=1&query=<%= (t.getLatitude() != 0.0 && t.getLongitude() != 0.0) ? (t.getLatitude() + "," + t.getLongitude()) : java.net.URLEncoder.encode(t.getTurfName() + " " + t.getCity(), "UTF-8") %>" target="_blank" class="inline-flex items-center gap-1 text-[11px] text-primary font-bold hover:underline mt-0.5" title="View GPS Coordinates on Google Maps">
                          <span class="material-symbols-outlined text-[13px]">near_me</span>
                          <span>GPS (<%= t.getLatitude() != 0.0 ? String.format("%.2f, %.2f", t.getLatitude(), t.getLongitude()) : "Map" %>)</span>
                        </a>
                      </td>
                      <td class="py-4 px-4 font-bold text-primary text-sm sm:text-base whitespace-nowrap">
                        ₹<%= (int) t.getPricePerHour() %>
                        <span class="text-xs font-normal text-secondary">/hr</span>
                      </td>
                      <td class="py-4 px-4 whitespace-nowrap">
                        <% if ("ACTIVE".equalsIgnoreCase(t.getStatus().name())) { %>
                          <span class="bg-green-100 text-green-800 text-xs font-bold px-2.5 py-1 rounded-full inline-flex items-center gap-1.5 shadow-xs">
                            <span class="w-1.5 h-1.5 rounded-full bg-green-600 animate-pulse"></span>
                            ACTIVE
                          </span>
                        <% } else { %>
                          <span class="bg-amber-100 text-amber-800 text-xs font-bold px-2.5 py-1 rounded-full inline-flex items-center gap-1.5">
                            <span class="w-1.5 h-1.5 rounded-full bg-amber-600"></span>
                            <%= t.getStatus().name() %>
                          </span>
                        <% } %>
                      </td>
                      <td class="py-4 px-4 text-right space-x-1.5 whitespace-nowrap">
                        <a href="<%= request.getContextPath() %>/admin/turf?action=edit&id=<%= t.getTurfId() %>" class="inline-flex items-center gap-1 px-3 py-1.5 rounded-xl bg-surface-container hover:bg-surface-container-high text-on-surface text-xs font-bold transition-all shadow-xs" title="Edit Turf Details">
                          <span class="material-symbols-outlined text-sm">edit</span>
                          <span>Edit</span>
                        </a>
                        <% if ("ACTIVE".equalsIgnoreCase(t.getStatus().name())) { %>
                          <a href="<%= request.getContextPath() %>/admin/turf?action=deactivate&id=<%= t.getTurfId() %>" class="inline-flex items-center gap-1 px-3 py-1.5 rounded-xl bg-error-container text-on-error-container text-xs font-bold hover:opacity-85 transition-all shadow-xs" onclick="return confirm('Deactivate <%= t.getTurfName() %>?');" title="Deactivate Pitch">
                            <span class="material-symbols-outlined text-sm">block</span>
                            <span>Deactivate</span>
                          </a>
                        <% } else { %>
                          <a href="<%= request.getContextPath() %>/admin/turf?action=activate&id=<%= t.getTurfId() %>" class="inline-flex items-center gap-1 px-3 py-1.5 rounded-xl bg-green-100 text-green-800 text-xs font-bold hover:bg-green-200 transition-all shadow-xs" title="Activate Pitch">
                            <span class="material-symbols-outlined text-sm">check_circle</span>
                            <span>Activate</span>
                          </a>
                        <% } %>
                      </td>
                    </tr>
                  <% } %>
                <% } else { %>
                  <tr id="emptyTurfsRow">
                    <td colspan="6" class="py-12 text-center text-secondary">
                      <div class="flex flex-col items-center justify-center gap-2">
                        <span class="material-symbols-outlined text-4xl text-outline">stadium</span>
                        <p class="font-bold text-on-surface">No turf grounds found</p>
                        <p class="text-xs text-secondary">Click "Add New Pitch" above to register your first ground.</p>
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
    let currentSportFilter = 'ALL';
    function setSportFilter(sport) {
      currentSportFilter = sport;
      document.querySelectorAll('.sport-filter-btn').forEach(btn => {
        if (btn.getAttribute('data-sport') === sport) {
          btn.className = 'sport-filter-btn px-3 py-1.5 rounded-lg text-xs font-bold bg-primary text-on-primary transition-all shadow-sm';
        } else {
          btn.className = 'sport-filter-btn px-3 py-1.5 rounded-lg text-xs font-bold bg-surface-container text-secondary hover:text-on-surface transition-all';
        }
      });
      filterTurfsTable();
    }

    function filterTurfsTable() {
      const q = (document.getElementById('turfSearch').value || '').toLowerCase().trim();
      const rows = document.querySelectorAll('.turf-row');
      rows.forEach(row => {
        const text = row.innerText.toLowerCase();
        const sport = row.getAttribute('data-sport') || 'MULTI';
        const matchesQuery = !q || text.includes(q);
        const matchesSport = currentSportFilter === 'ALL' || sport === currentSportFilter;
        row.style.display = (matchesQuery && matchesSport) ? '' : 'none';
      });
    }
  </script>
</body>
</html>
