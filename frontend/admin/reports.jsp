<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.turfbook.model.Turf" %>
<%@ page import="com.turfbook.model.User" %>
<%@ page import="com.turfbook.service.TurfService" %>
<%@ page import="com.turfbook.service.PaymentService" %>
<%@ page import="com.turfbook.dao.BookingDAO" %>
<%@ page import="java.util.List" %>
<%
    TurfService turfService = new TurfService();
    PaymentService paymentService = new PaymentService();
    BookingDAO bookingDAO = new BookingDAO();

    List<Turf> turfs = turfService.getAllTurfs();
    double revenue = paymentService.getTotalRevenue();
    long bookingsCount = bookingDAO.countTotalBookings();
    User currentUser = (User) session.getAttribute("user");

    int turfCount = (turfs != null) ? turfs.size() : 0;
    double avgYield = bookingsCount > 0 ? (revenue / bookingsCount) : 0.0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <meta name="theme-color" content="#006b2c"/>
  <link rel="manifest" href="<%= request.getContextPath() %>/manifest.json"/>
  <title>Facility Reports • TurfOps Admin</title>
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
      <a class="flex items-center gap-unit-sm px-unit-sm py-2.5 rounded-xl transition-all bg-primary text-on-primary font-bold shadow-sm" href="<%= request.getContextPath() %>/admin/reports.jsp">
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
          <span class="font-bold text-on-surface">Analytics &amp; Performance Reports</span>
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
              <span class="font-label-sm uppercase tracking-wider text-primary font-bold">Executive Analytics</span>
              <span class="bg-primary/10 text-primary text-[11px] font-bold px-2 py-0.5 rounded-full">Automated Aggregation</span>
            </div>
            <h1 class="font-headline-lg font-bold text-on-surface mt-0.5 text-2xl lg:text-3xl">Facility Utilization &amp; Revenue Reports</h1>
            <p class="font-body-md text-secondary text-xs sm:text-sm">Aggregated telemetry, pitch yield metrics, and match capacity across all registered venues.</p>
          </div>
          <div class="flex items-center gap-2">
            <button onclick="window.print()" class="px-4 py-2 rounded-xl bg-surface-container hover:bg-surface-container-high text-on-surface text-xs font-bold transition-all flex items-center gap-1.5 shadow-xs">
              <span class="material-symbols-outlined text-base">print</span>
              <span>Print Report</span>
            </button>
          </div>
        </div>

        <!-- Telemetry Stats Row -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-unit-md">
          <div class="bg-surface-container-lowest p-unit-lg rounded-2xl shadow-sm border border-outline-variant/30">
            <span class="font-label-sm uppercase font-bold text-secondary">Total Settled Volume</span>
            <div class="font-headline-xl font-bold text-primary mt-1 text-3xl">₹<%= (int) revenue %></div>
            <span class="text-xs text-secondary mt-1 block">Razorpay / UPI test clearing</span>
          </div>

          <div class="bg-surface-container-lowest p-unit-lg rounded-2xl shadow-sm border border-outline-variant/30">
            <span class="font-label-sm uppercase font-bold text-secondary">Match Sessions</span>
            <div class="font-headline-xl font-bold text-on-surface mt-1 text-3xl"><%= bookingsCount %></div>
            <span class="text-xs text-primary font-bold mt-1 block">Scheduled match slots</span>
          </div>

          <div class="bg-surface-container-lowest p-unit-lg rounded-2xl shadow-sm border border-outline-variant/30">
            <span class="font-label-sm uppercase font-bold text-secondary">Operational Grounds</span>
            <div class="font-headline-xl font-bold text-on-surface mt-1 text-3xl"><%= turfCount %></div>
            <span class="text-xs text-secondary mt-1 block">Metro Hubs &amp; Suburbs</span>
          </div>

          <div class="bg-surface-container-lowest p-unit-lg rounded-2xl shadow-sm border border-outline-variant/30">
            <span class="font-label-sm uppercase font-bold text-secondary">Avg Slot Yield</span>
            <div class="font-headline-xl font-bold text-green-700 mt-1 text-3xl">₹<%= (int) avgYield %></div>
            <span class="text-xs text-secondary mt-1 block">Gross per reservation</span>
          </div>
        </div>

        <!-- Pitches Yield Summary Card Table -->
        <div class="bg-surface-container-lowest p-unit-lg rounded-2xl shadow-sm border border-outline-variant/30 space-y-unit-md">
          <div class="flex items-center justify-between">
            <div>
              <span class="font-label-sm uppercase tracking-wider text-primary font-bold">Catalog Breakdown</span>
              <h2 class="font-headline-sm font-bold text-on-surface text-lg">Pitches Yield &amp; Capacity Manifest</h2>
            </div>
            <a href="<%= request.getContextPath() %>/admin/turf?action=list" class="text-xs font-bold text-primary hover:underline flex items-center gap-1">
              <span>View All Grounds</span>
              <span class="material-symbols-outlined text-sm">arrow_forward</span>
            </a>
          </div>

          <div class="divide-y divide-outline-variant/20">
            <% if (turfs != null && !turfs.isEmpty()) { %>
              <% for (Turf t : turfs) { %>
                <div class="py-4 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 hover:bg-surface-container-low/40 p-2 rounded-xl transition-colors">
                  <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-xl bg-primary/10 text-primary flex items-center justify-center font-bold flex-shrink-0">
                      <span class="material-symbols-outlined text-xl">stadium</span>
                    </div>
                    <div>
                      <span class="font-bold text-on-surface text-sm sm:text-base block"><%= t.getTurfName() %></span>
                      <span class="text-xs text-secondary"><%= t.getCity() %> • <%= t.getTurfType() != null ? t.getTurfType().getDisplayName() : "Multi-Sport" %> • <span class="font-mono"><%= t.getTurfId() %></span></span>
                    </div>
                  </div>
                  <div class="flex items-center gap-4 self-end sm:self-auto text-right">
                    <div>
                      <span class="font-bold text-primary text-sm sm:text-base block">₹<%= (int) t.getPricePerHour() %>/hr</span>
                      <span class="text-xs text-secondary block">Capacity: <%= t.getCapacity() %> Players</span>
                    </div>
                    <a href="<%= request.getContextPath() %>/admin/turf?action=edit&id=<%= t.getTurfId() %>" class="px-2.5 py-1.5 rounded-lg bg-surface-container hover:bg-surface-container-high text-xs font-bold text-on-surface transition-colors">
                      Edit
                    </a>
                  </div>
                </div>
              <% } %>
            <% } else { %>
              <div class="py-8 text-center text-secondary">
                No artificial turf grounds listed yet.
              </div>
            <% } %>
          </div>
        </div>

      </div>
    </main>
  </div>

  <script src="<%= request.getContextPath() %>/js/app.js"></script>
</body>
</html>
