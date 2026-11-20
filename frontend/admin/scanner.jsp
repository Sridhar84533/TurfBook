<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.turfbook.model.Booking" %>
<%@ page import="com.turfbook.model.CheckInResult" %>
<%@ page import="com.turfbook.model.User" %>
<%@ page import="java.util.List" %>
<%
    Long todayCheckInsCount = (Long) request.getAttribute("todayCheckInsCount");
    Long todayBookingsCount = (Long) request.getAttribute("todayBookingsCount");
    List<Booking> recentCheckIns = (List<Booking>) request.getAttribute("recentCheckIns");
    Integer preCheckInMinutes = (Integer) request.getAttribute("preCheckInMinutes");
    CheckInResult checkInResult = (CheckInResult) request.getAttribute("checkInResult");

    if (todayCheckInsCount == null) todayCheckInsCount = 0L;
    if (todayBookingsCount == null) todayBookingsCount = 0L;
    if (preCheckInMinutes == null) preCheckInMinutes = 15;
    User currentUser = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport"/>
  <meta name="theme-color" content="#006b2c"/>
  <link rel="manifest" href="<%= request.getContextPath() %>/manifest.json"/>
  <title>QR Gate Check-In • TurfOps Admin</title>
  <link href="https://fonts.googleapis.com" rel="preconnect"/>
  <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&display=block" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;family=Outfit:wght@600;700;800&amp;display=swap" rel="stylesheet"/>
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

  <!-- Responsive Left Sidebar (280px Desktop / Off-canvas Mobile Drawer) -->
  <aside class="admin-sidebar fixed left-0 top-0 h-full w-[280px] bg-surface-container-lowest border-r border-outline-variant/30 z-50 flex flex-col" id="adminSidebar">
    <div class="h-16 px-unit-lg flex items-center border-b border-outline-variant/20 gap-unit-xs justify-between">
      <div class="flex items-center gap-unit-xs">
        <div class="w-8 h-8 rounded-lg bg-primary text-on-primary font-bold flex items-center justify-center shadow-sm">
          <span class="material-symbols-outlined text-[20px]">sports_soccer</span>
        </div>
        <span class="font-headline-sm text-headline-sm text-on-surface font-bold">Turf<span class="text-primary">Ops</span></span>
        <span class="ml-2 text-label-sm px-2 py-0.5 rounded bg-primary/10 text-primary font-bold">ADMIN</span>
      </div>
      <!-- Close drawer on mobile -->
      <button class="lg:hidden p-1.5 rounded-lg text-secondary hover:bg-surface-container-high transition-colors" onclick="closeAdminSidebar()">
        <span class="material-symbols-outlined text-xl">close</span>
      </button>
    </div>

    <!-- Navigation List (Preserves all 11 Admin Modules + QR Scanner) -->
    <nav class="flex-1 px-unit-sm py-unit-md space-y-1 overflow-y-auto">
      <a class="flex items-center gap-unit-sm px-unit-sm py-2.5 rounded-xl text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all font-label-lg" href="<%= request.getContextPath() %>/admin/dashboard">
        <span class="material-symbols-outlined text-xl">dashboard</span>
        <span>Dashboard</span>
      </a>
      <!-- Active QR Scanner Nav -->
      <a class="flex items-center gap-unit-sm px-unit-sm py-2.5 rounded-xl transition-all bg-primary text-on-primary font-bold shadow-sm" href="<%= request.getContextPath() %>/admin/scanner">
        <span class="material-symbols-outlined text-xl">qr_code_scanner</span>
        <span>QR Check-In Scanner</span>
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
        <span>Check-in History</span>
      </a>
    </nav>
  </aside>

  <!-- Main Content Area -->
  <div class="admin-main-wrap pl-[280px]">
    
    <!-- Top Header with Hamburger for Mobile -->
    <header class="admin-header-wrap fixed top-0 left-[280px] right-0 h-16 bg-surface-container-lowest border-b border-outline-variant/30 z-40 flex items-center justify-between px-unit-md lg:px-unit-lg shadow-sm">
      <div class="flex items-center gap-unit-sm">
        <!-- Hamburger Menu Button (visible on mobile / tablets) -->
        <button type="button" class="lg:hidden p-2 rounded-xl text-on-surface hover:bg-surface-container transition-colors" onclick="toggleAdminSidebar()" aria-label="Toggle Navigation Menu">
          <span class="material-symbols-outlined text-2xl">menu</span>
        </button>
        <div class="flex items-center gap-1.5 font-bold text-on-surface text-base lg:text-lg">
          <span class="material-symbols-outlined text-primary text-xl">qr_code_scanner</span>
          <span>QR Gate Check-In</span>
        </div>
      </div>

      <div class="flex items-center gap-unit-sm">
        <a href="<%= request.getContextPath() %>/admin/checkin?action=history" class="hidden sm:flex items-center gap-1 px-unit-sm py-1.5 bg-surface-container hover:bg-surface-container-high text-on-surface text-xs font-bold rounded-lg transition-colors">
          <span class="material-symbols-outlined text-sm">history</span>
          <span>Log (<%= todayCheckInsCount %>)</span>
        </a>
        <div class="flex items-center gap-unit-xs pl-unit-xs py-1 pr-unit-sm rounded-full bg-surface-container-low border border-outline-variant/40">
          <div class="w-7 h-7 rounded-full bg-primary text-on-primary font-bold flex items-center justify-center text-xs">
            <%= (currentUser != null && currentUser.getUsername() != null) ? currentUser.getUsername().substring(0, 1).toUpperCase() : "A" %>
          </div>
          <span class="font-label-md text-on-surface font-bold text-xs sm:text-sm">Admin</span>
        </div>
        <a href="<%= request.getContextPath() %>/logout" class="p-2 text-on-surface-variant hover:text-error transition-colors" title="Sign Out">
          <span class="material-symbols-outlined text-[20px]">logout</span>
        </a>
      </div>
    </header>

    <!-- Main Scanner View -->
    <main class="w-full pt-20 px-unit-md lg:px-unit-lg py-unit-md min-h-screen">
      <div class="max-w-[720px] mx-auto flex flex-col space-y-unit-md">

        <!-- Operational Summary Bar -->
        <div class="grid grid-cols-2 sm:grid-cols-3 gap-unit-xs sm:gap-unit-sm">
          <div class="bg-surface-container-lowest p-3 rounded-xl border border-outline-variant/30 flex items-center gap-2.5 shadow-sm">
            <div class="w-9 h-9 rounded-lg bg-primary/10 text-primary flex items-center justify-center shrink-0">
              <span class="material-symbols-outlined text-xl">done_all</span>
            </div>
            <div>
              <span class="text-[11px] text-secondary font-semibold uppercase block leading-tight">Today Checked In</span>
              <span class="text-base font-bold text-on-surface" id="statTodayCheckins"><%= todayCheckInsCount %></span>
            </div>
          </div>
          <div class="bg-surface-container-lowest p-3 rounded-xl border border-outline-variant/30 flex items-center gap-2.5 shadow-sm">
            <div class="w-9 h-9 rounded-lg bg-secondary-container text-secondary flex items-center justify-center shrink-0">
              <span class="material-symbols-outlined text-xl">calendar_today</span>
            </div>
            <div>
              <span class="text-[11px] text-secondary font-semibold uppercase block leading-tight">Today's Games</span>
              <span class="text-base font-bold text-on-surface"><%= todayBookingsCount %></span>
            </div>
          </div>
          <div class="col-span-2 sm:col-span-1 bg-surface-container-lowest p-3 rounded-xl border border-outline-variant/30 flex items-center gap-2.5 shadow-sm">
            <div class="w-9 h-9 rounded-lg bg-amber-50 text-amber-700 flex items-center justify-center shrink-0">
              <span class="material-symbols-outlined text-xl">schedule</span>
            </div>
            <div>
              <span class="text-[11px] text-secondary font-semibold uppercase block leading-tight">Pre-Checkin Window</span>
              <span class="text-xs font-bold text-on-surface">Opens -<%= preCheckInMinutes %> mins</span>
            </div>
          </div>
        </div>


        <!-- Normal QR Code Scan & Gate Pass Verification Card -->
        <div class="bg-surface-container-lowest p-unit-md sm:p-unit-lg rounded-2xl border border-outline-variant/30 shadow-sm flex flex-col items-center">

        <!-- Live Camera QR Scanner Card -->
        <div class="bg-surface-container-lowest p-unit-md sm:p-unit-lg rounded-2xl border border-outline-variant/30 shadow-sm flex flex-col items-center">
          
          <div class="w-full flex items-center justify-between pb-3 mb-3 border-b border-outline-variant/20">
            <div class="flex items-center gap-2">
              <span class="material-symbols-outlined text-primary text-xl">photo_camera</span>
              <span class="font-bold text-on-surface text-sm sm:text-base">Live Camera Scanner</span>
            </div>
            <div id="cameraStatusBadge" class="flex items-center gap-1.5 px-2.5 py-1 rounded-full text-[11px] font-bold bg-green-100 text-green-800">
              <span class="w-2 h-2 rounded-full bg-green-600 animate-ping"></span>
              <span id="cameraStatusText">Camera Active</span>
            </div>
          </div>

          <!-- Camera Viewfinder with overlay -->
          <div class="relative w-full max-w-[420px] aspect-square rounded-2xl overflow-hidden bg-black border-2 border-primary/40 shadow-inner flex items-center justify-center">
            <!-- Reader element for Html5Qrcode video stream -->
            <div id="qr-reader" class="w-full h-full object-cover"></div>

            <!-- Scanner target overlay reticle -->
            <div id="scanOverlay" class="absolute inset-0 pointer-events-none flex items-center justify-center p-8">
              <div class="relative w-full h-full max-w-[260px] max-h-[260px] border-2 border-dashed border-primary/70 rounded-2xl flex items-center justify-center shadow-lg">
                <!-- 4 corner brackets -->
                <div class="absolute -top-1 -left-1 w-6 h-6 border-t-4 border-l-4 border-primary rounded-tl-lg"></div>
                <div class="absolute -top-1 -right-1 w-6 h-6 border-t-4 border-r-4 border-primary rounded-tr-lg"></div>
                <div class="absolute -bottom-1 -left-1 w-6 h-6 border-b-4 border-l-4 border-primary rounded-bl-lg"></div>
                <div class="absolute -bottom-1 -right-1 w-6 h-6 border-b-4 border-r-4 border-primary rounded-br-lg"></div>
                <!-- Laser line -->
                <div class="w-full h-0.5 bg-gradient-to-r from-transparent via-red-500 to-transparent shadow-[0_0_8px_#ef4444] animate-pulse"></div>
              </div>
            </div>

            <!-- Camera Idle / Permission Message Overlay -->
            <div id="cameraPromptOverlay" class="hidden absolute inset-0 bg-slate-900/90 text-white flex flex-col items-center justify-center p-6 text-center z-10">
              <span class="material-symbols-outlined text-4xl text-amber-400 mb-2">videocam_off</span>
              <p class="font-bold text-sm mb-1" id="cameraPromptTitle">Camera Paused</p>
              <p class="text-xs text-slate-300 max-w-[280px] mb-4" id="cameraPromptMsg">Click below to activate camera for gate check-in.</p>
              <button type="button" onclick="startLiveCamera()" class="px-5 py-2.5 bg-primary hover:bg-primary-container text-on-primary font-bold text-xs rounded-xl shadow-md transition-all flex items-center gap-1.5">
                <span class="material-symbols-outlined text-base">play_arrow</span>
                <span>Activate Camera</span>
              </button>
            </div>
          </div>

          <!-- Camera Controls Toolbar -->
          <div class="w-full max-w-[420px] flex items-center justify-center gap-2 mt-3 pt-2">
            <button type="button" id="btnToggleCamera" onclick="toggleCameraPower()"
                    class="flex-1 py-2.5 px-3 bg-surface-container hover:bg-surface-container-high text-on-surface font-bold text-xs rounded-xl flex items-center justify-center gap-1.5 transition-colors">
              <span class="material-symbols-outlined text-base">power_settings_new</span>
              <span id="btnToggleCameraText">Pause Camera</span>
            </button>
            <button type="button" id="btnSwitchCamera" onclick="switchCameraFacing()"
                    class="py-2.5 px-3 bg-surface-container hover:bg-surface-container-high text-on-surface font-bold text-xs rounded-xl flex items-center justify-center gap-1.5 transition-colors" title="Switch Camera">
              <span class="material-symbols-outlined text-base">flip_camera_ios</span>
              <span class="hidden sm:inline">Flip</span>
            </button>
            <button type="button" id="btnToggleTorch" onclick="toggleCameraTorch()"
                    class="py-2.5 px-3 bg-surface-container hover:bg-surface-container-high text-on-surface font-bold text-xs rounded-xl flex items-center justify-center gap-1.5 transition-colors" title="Flashlight">
              <span class="material-symbols-outlined text-base">flashlight_on</span>
              <span class="hidden sm:inline">Torch</span>
            </button>
          </div>

          <!-- Hidden DOM container for file decoder fallback -->
          <div id="_qrDecoder" style="display:none" aria-hidden="true"></div>
          <input type="file" id="qrGalleryInput" accept="image/*" style="display:none" onchange="handleQrImageCapture(this)"/>

          <!-- Fast Manual Verification Form -->
          <div class="w-full max-w-[460px] mt-5 pt-4 border-t border-outline-variant/20">
            <label for="manualTokenInput" class="block text-xs font-bold text-secondary uppercase tracking-wider mb-2">
              Verify by Code / Booking ID
            </label>
            <form id="manualCheckinForm" onsubmit="handleManualSubmit(event)" class="flex flex-col sm:flex-row gap-2.5">
              <input type="text" id="manualTokenInput" name="token"
                     placeholder="e.g. TB-CHECKIN-XXXXXXXX or BK-XXXX"
                     class="flex-1 px-4 py-3 rounded-xl bg-surface-container-low border border-outline-variant/40 text-sm font-mono font-bold text-on-surface focus:outline-none focus:border-primary shadow-inner" required/>
              <button type="submit" id="btnManualSubmit"
                      class="px-5 py-3 bg-primary hover:bg-primary/90 text-on-primary font-bold text-sm rounded-xl shadow-md transition-all flex items-center justify-center gap-2 active:scale-95">
                <span class="material-symbols-outlined text-lg">check_circle</span>
                <span>Verify &amp; Admit</span>
              </button>
            </form>
          </div>

          <!-- Secondary Option: Gallery QR Screenshot Upload -->
          <div class="w-full max-w-[460px] flex items-center justify-between pt-3 mt-3 border-t border-outline-variant/20 text-xs text-secondary">
            <span>Customer has screenshot of pass?</span>
            <button type="button" onclick="document.getElementById('qrGalleryInput').click()"
                    class="font-bold text-primary hover:underline flex items-center gap-1">
              <span class="material-symbols-outlined text-base">image</span>
              <span>Upload QR Image</span>
            </button>
          </div>

          <!-- Preview & Spinner for Gallery Upload (Hidden by default) -->
          <div id="scanPreviewBox" class="hidden w-full aspect-square max-w-[260px] rounded-2xl overflow-hidden border-4 border-primary/40 shadow-lg relative my-3">
            <img id="scanPreviewImg" src="" alt="QR Preview" class="w-full h-full object-contain bg-black"/>
            <div id="scanSpinner" class="absolute inset-0 flex flex-col items-center justify-center bg-black/60">
              <div class="w-10 h-10 border-4 border-primary border-t-transparent rounded-full animate-spin mb-2"></div>
              <span class="text-white text-xs font-bold">Decoding QR...</span>
            </div>
          </div>
          <div id="scanErrorBox" class="hidden w-full max-w-[460px] p-3 bg-red-50 border border-red-300 rounded-xl text-xs text-red-800 font-medium text-center my-2"></div>
          <button id="btnScanAgain" onclick="resetScan()" class="hidden py-2 px-4 bg-surface-container hover:bg-surface-container-high text-on-surface font-bold text-xs rounded-xl flex items-center gap-1 my-2">
            <span class="material-symbols-outlined text-base">refresh</span>
            <span>Clear Image</span>
          </button>

        </div>


        <!-- Scan Result Display Screen (Modal / Overlay) -->
        <div id="resultModal" class="bg-surface-container-lowest p-unit-md sm:p-unit-lg rounded-2xl border border-outline-variant/30 shadow-md hidden">
          <!-- Dynamically Populated by JavaScript or Server POST -->
          <div id="resultContent"></div>
        </div>

        <!-- Today's Recent Check-Ins List -->
        <div class="bg-surface-container-lowest p-unit-md sm:p-unit-lg rounded-2xl border border-outline-variant/30 shadow-sm">
          <div class="flex items-center justify-between mb-3">
            <div class="flex items-center gap-1.5">
              <span class="material-symbols-outlined text-primary text-xl">history</span>
              <h2 class="font-headline-sm font-bold text-on-surface text-base">Recent Gate Check-Ins</h2>
            </div>
            <a href="<%= request.getContextPath() %>/admin/checkin?action=history" class="text-xs font-bold text-primary hover:underline flex items-center gap-0.5">
              <span>View Full History</span>
              <span class="material-symbols-outlined text-xs">arrow_forward</span>
            </a>
          </div>

          <div id="recentCheckinsList" class="space-y-2">
            <% if (recentCheckIns != null && !recentCheckIns.isEmpty()) { %>
              <% for (Booking b : recentCheckIns) { %>
                <div class="p-3 rounded-xl bg-surface-container-low border border-outline-variant/20 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-1 text-xs">
                  <div>
                    <div class="flex items-center gap-2">
                      <span class="font-mono font-bold text-on-surface"><%= b.getBookingId() %></span>
                      <span class="bg-green-100 text-green-800 font-bold px-2 py-0.5 rounded-full text-[10px]">CHECKED IN</span>
                      <% if (b.getAssignedCourt() > 0) { %>
                        <span class="bg-blue-100 text-blue-800 font-bold px-2 py-0.5 rounded-full text-[10px] flex items-center gap-0.5">
                          <span>🏸 Court <%= b.getAssignedCourt() %></span>
                        </span>
                      <% } %>
                    </div>
                    <p class="font-bold text-on-surface text-sm mt-0.5"><%= b.getTurfName() != null ? b.getTurfName() : b.getTurfId() %></p>
                    <p class="text-secondary"><%= b.getUserName() != null ? b.getUserName() : b.getUserId() %> • <%= b.getStartTime() %> - <%= b.getEndTime() %></p>
                  </div>
                  <div class="text-left sm:text-right mt-1 sm:mt-0">
                    <span class="font-mono text-primary font-semibold block"><%= b.getBookingDate() %></span>
                    <span class="text-[11px] text-secondary">Operator: <%= b.getCheckedInBy() != null ? b.getCheckedInBy() : "admin" %></span>
                  </div>
                </div>
              <% } %>
            <% } else { %>
              <div class="py-6 text-center text-secondary text-xs">
                No players checked in yet today. Ready for arrival.
              </div>
            <% } %>
          </div>
        </div>

      </div>
    </main>
  </div>

  <!-- Audio Beep Feedback using Web Audio API -->
  <script>
    function playBeep(success) {
      try {
        const audioCtx = new (window.AudioContext || window.webkitAudioContext)();
        const osc = audioCtx.createOscillator();
        const gain = audioCtx.createGain();
        osc.connect(gain);
        gain.connect(audioCtx.destination);
        if (success) {
          osc.frequency.setValueAtTime(880, audioCtx.currentTime); // A5 note
          osc.type = 'sine';
          gain.gain.setValueAtTime(0.3, audioCtx.currentTime);
          osc.start();
          osc.stop(audioCtx.currentTime + 0.18);
        } else {
          osc.frequency.setValueAtTime(300, audioCtx.currentTime); // Low buzz
          osc.type = 'sawtooth';
          gain.gain.setValueAtTime(0.25, audioCtx.currentTime);
          osc.start();
          osc.stop(audioCtx.currentTime + 0.3);
        }
      } catch (e) {}
    }
  </script>

  <!-- Local html5-qrcode Library Engine -->
  <script src="<%= request.getContextPath() %>/js/html5-qrcode.min.js"></script>
  <script src="<%= request.getContextPath() %>/js/app.js"></script>

  <!-- Server data hand-off: JSP emits JSON into a data-attribute, JS reads from DOM (no scriptlets in script blocks) -->
  <div id="_serverData"
       data-checkin-result='<%= checkInResult != null ? com.turfbook.util.JSONUtil.toSafeJson(checkInResult) : "" %>'
       style="display:none" aria-hidden="true"></div>

  <!-- Scanner Controller Script -->
  <script>
    var isProcessing = false;
    var html5QrCode = null;
    var fileQrDecoder = null;
    var isCameraRunning = false;
    var currentFacingMode = "environment";
    var isTorchOn = false;

    document.addEventListener('DOMContentLoaded', function() {
      // Initialize live camera engine
      try {
        html5QrCode = new Html5Qrcode("qr-reader");
        fileQrDecoder = new Html5Qrcode("_qrDecoder");
      } catch (e) {
        console.warn("Failed to init Html5Qrcode:", e);
      }

      // Check if redirected with server check-in result
      var serverDataEl = document.getElementById('_serverData');
      if (serverDataEl) {
        var raw = serverDataEl.getAttribute('data-checkin-result');
        if (raw && raw.trim() !== '') {
          try { 
            showCheckInResultModal(JSON.parse(raw)); 
          } catch (e) {}
        }
      }

      // Automatically attempt starting live camera on mobile/desktop
      startLiveCamera();
    });

    function startLiveCamera() {
      if (!html5QrCode) return;
      if (isCameraRunning) return;

      var promptOverlay = document.getElementById('cameraPromptOverlay');
      var statusBadge   = document.getElementById('cameraStatusBadge');
      var statusText    = document.getElementById('cameraStatusText');
      var btnToggleText = document.getElementById('btnToggleCameraText');

      var qrConfig = {
        fps: 15,
        qrbox: function(viewfinderWidth, viewfinderHeight) {
          var minEdge = Math.min(viewfinderWidth, viewfinderHeight);
          var edgeSize = Math.floor(minEdge * 0.72);
          return { width: Math.max(edgeSize, 200), height: Math.max(edgeSize, 200) };
        },
        aspectRatio: 1.0
      };

      html5QrCode.start(
        { facingMode: { ideal: currentFacingMode } },
        qrConfig,
        onLiveQrCodeDetected,
        onLiveQrScanError
      ).then(function() {
        isCameraRunning = true;
        if (promptOverlay) promptOverlay.classList.add('hidden');
        if (statusBadge) {
          statusBadge.className = "flex items-center gap-1.5 px-2.5 py-1 rounded-full text-[11px] font-bold bg-green-100 text-green-800";
        }
        if (statusText) statusText.innerText = "Camera Active";
        if (btnToggleText) btnToggleText.innerText = "Pause Camera";
      }).catch(function(err) {
        console.warn("Camera start failed / permissions denied:", err);
        isCameraRunning = false;
        if (promptOverlay) promptOverlay.classList.remove('hidden');
        var pTitle = document.getElementById('cameraPromptTitle');
        var pMsg   = document.getElementById('cameraPromptMsg');
        if (pTitle) pTitle.innerText = "Camera Permission Required";
        if (pMsg) {
          pMsg.innerText = (err && err.name === 'NotAllowedError')
            ? "Camera access was denied. Please allow camera permissions in your browser bar, or verify using manual code below."
            : "No camera stream available. You can use manual code or photo upload below.";
        }
        if (statusBadge) {
          statusBadge.className = "flex items-center gap-1.5 px-2.5 py-1 rounded-full text-[11px] font-bold bg-amber-100 text-amber-800";
        }
        if (statusText) statusText.innerText = "Camera Idle";
        if (btnToggleText) btnToggleText.innerText = "Start Camera";
      });
    }

    function stopLiveCamera() {
      if (!html5QrCode || !isCameraRunning) return Promise.resolve();
      return html5QrCode.stop().then(function() {
        isCameraRunning = false;
        var promptOverlay = document.getElementById('cameraPromptOverlay');
        var statusBadge   = document.getElementById('cameraStatusBadge');
        var statusText    = document.getElementById('cameraStatusText');
        var btnToggleText = document.getElementById('btnToggleCameraText');

        if (promptOverlay) promptOverlay.classList.remove('hidden');
        var pTitle = document.getElementById('cameraPromptTitle');
        var pMsg   = document.getElementById('cameraPromptMsg');
        if (pTitle) pTitle.innerText = "Camera Paused";
        if (pMsg) pMsg.innerText = "Click below to reactivate camera scanning.";
        if (statusBadge) {
          statusBadge.className = "flex items-center gap-1.5 px-2.5 py-1 rounded-full text-[11px] font-bold bg-slate-100 text-slate-700";
        }
        if (statusText) statusText.innerText = "Camera Paused";
        if (btnToggleText) btnToggleText.innerText = "Start Camera";
      }).catch(function(err) {
        console.warn("Error stopping camera:", err);
      });
    }

    function toggleCameraPower() {
      if (isCameraRunning) {
        stopLiveCamera();
      } else {
        startLiveCamera();
      }
    }

    function switchCameraFacing() {
      currentFacingMode = (currentFacingMode === "environment") ? "user" : "environment";
      if (isCameraRunning) {
        stopLiveCamera().then(function() {
          startLiveCamera();
        });
      }
    }

    function toggleCameraTorch() {
      if (!html5QrCode || !isCameraRunning) return;
      isTorchOn = !isTorchOn;
      try {
        html5QrCode.applyVideoConstraints({
          advanced: [{ torch: isTorchOn }]
        }).catch(function(e) {
          console.warn("Torch not supported on this device/browser:", e);
        });
      } catch (e) {}
    }

    function onLiveQrCodeDetected(decodedText) {
      if (isProcessing) return;
      isProcessing = true;
      if (navigator.vibrate) navigator.vibrate([100, 50, 100]);
      verifyTokenWithBackend(decodedText);
    }

    function onLiveQrScanError(error) {
      // Ignore background continuous scanning noise
    }

    // Called when user captures/selects an image file
    function handleQrImageCapture(input) {
      if (!input.files || !input.files[0]) return;
      var file = input.files[0];

      var previewBox = document.getElementById('scanPreviewBox');
      var previewImg = document.getElementById('scanPreviewImg');
      var spinner    = document.getElementById('scanSpinner');
      var errorBox   = document.getElementById('scanErrorBox');
      var btnAgain   = document.getElementById('btnScanAgain');

      previewImg.src = URL.createObjectURL(file);
      previewBox.classList.remove('hidden');
      spinner.classList.remove('hidden');
      errorBox.classList.add('hidden');
      if (btnAgain) btnAgain.classList.add('hidden');

      if (!fileQrDecoder) fileQrDecoder = new Html5Qrcode('_qrDecoder');

      fileQrDecoder.scanFile(file, false)
        .then(function(decodedText) {
          spinner.classList.add('hidden');
          if (btnAgain) btnAgain.classList.remove('hidden');
          if (navigator.vibrate) navigator.vibrate(80);
          verifyTokenWithBackend(decodedText);
        })
        .catch(function(err) {
          spinner.classList.add('hidden');
          if (btnAgain) btnAgain.classList.remove('hidden');
          errorBox.textContent = 'No QR code found in the image. Please try again with a clearer photo.';
          errorBox.classList.remove('hidden');
        });

      input.value = '';
    }

    function resetScan() {
      var previewBox = document.getElementById('scanPreviewBox');
      var errorBox   = document.getElementById('scanErrorBox');
      var btnAgain   = document.getElementById('btnScanAgain');
      var manualInput = document.getElementById('manualTokenInput');

      if (previewBox) previewBox.classList.add('hidden');
      if (errorBox) errorBox.classList.add('hidden');
      if (btnAgain) btnAgain.classList.add('hidden');
      if (manualInput) manualInput.value = '';
      isProcessing = false;
    }

    function handleManualSubmit(e) {
      e.preventDefault();
      const input = document.getElementById('manualTokenInput');
      const token = input.value.trim();
      if (!token) return;
      verifyTokenWithBackend(token);
    }

    async function verifyTokenWithBackend(token) {
      const url = '<%= request.getContextPath() %>/admin/checkin';
      try {
        const formData = new URLSearchParams();
        formData.append('token', token);
        formData.append('format', 'json');

        const response = await fetch(url, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
            'Accept': 'application/json'
          },
          body: formData.toString()
        });

        if (!response.ok) {
          throw new Error('HTTP ' + response.status + ': Server validation error');
        }

        const data = await response.json();
        showCheckInResultModal(data);

        if (data.success) {
          playBeep(true);
        } else {
          playBeep(false);
        }

      } catch (err) {
        console.error("Check-in request failed:", err);
        playBeep(false);
        showCheckInResultModal({
          success: false,
          resultCode: 'NETWORK_ERROR',
          message: 'Connection failed. Please check local Wi-Fi connectivity to Tomcat.'
        });
      }
    }

    function showCheckInResultModal(res) {
      const modal = document.getElementById('resultModal');
      const content = document.getElementById('resultContent');
      modal.classList.remove('hidden');
      modal.scrollIntoView({ behavior: 'smooth', block: 'center' });

      if (res.success) {
        // Build Badminton Court section if assigned
        let badmintonBadgeHtml = '';
        if (res.booking && (res.booking.assignedCourt > 0 || (res.booking.assignedCourts && res.booking.assignedCourts.length > 0) || res.booking.turfType === 'BADMINTON')) {
          let courtTitle = 'BADMINTON COURT ASSIGNED';
          let courtText = 'COURT #' + (res.booking.assignedCourt > 0 ? res.booking.assignedCourt : 1);
          if (res.booking.assignedCourts && res.booking.assignedCourts.length > 1) {
            courtTitle = 'BADMINTON COURTS ASSIGNED (' + res.booking.assignedCourts.length + ' COURTS)';
            courtText = 'COURTS: ' + res.booking.assignedCourts.map(c => '#' + c).join(', ');
          } else if (res.booking.assignedCourts && res.booking.assignedCourts.length === 1) {
            courtText = 'COURT #' + res.booking.assignedCourts[0];
          }
          badmintonBadgeHtml = `
            <div class="mt-3 p-3.5 bg-gradient-to-r from-blue-600 to-indigo-700 text-white rounded-xl shadow-md flex items-center justify-between">
              <div class="flex items-center gap-2.5">
                <div class="w-10 h-10 rounded-lg bg-white/20 flex items-center justify-center font-bold">
                  <span class="material-symbols-outlined text-2xl">sports_tennis</span>
                </div>
                <div>
                  <span class="text-[10px] uppercase font-bold tracking-wider text-blue-200 block">\${courtTitle}</span>
                  <span class="text-xl font-black tracking-wide block">\${courtText}</span>
                </div>
              </div>
              <div class="text-right">
                <span class="text-[11px] font-semibold text-blue-100 block">Court Verified</span>
                <span class="text-xs bg-white text-blue-900 font-extrabold px-2.5 py-1 rounded-md shadow-sm">PITCH READY</span>
              </div>
            </div>
          `;
        }

        // SUCCESS SCREEN
        content.innerHTML = `
          <div class="checkin-success-animate p-4 bg-green-50 border-2 border-green-500 rounded-2xl">
            <div class="flex items-center gap-3 mb-3">
              <div class="w-12 h-12 rounded-xl bg-green-600 text-white flex items-center justify-center shrink-0 shadow-md">
                <span class="material-symbols-outlined text-3xl">check_circle</span>
              </div>
              <div>
                <span class="text-xs uppercase font-extrabold text-green-700 tracking-wider block">Verified Gate Pass</span>
                <h3 class="text-xl font-bold text-green-950 font-display">✓ CHECK-IN SUCCESSFUL</h3>
              </div>
            </div>

            \${badmintonBadgeHtml}

            <div class="bg-white p-3 rounded-xl border border-green-200 space-y-2 text-xs mt-3">
              <div class="grid grid-cols-2 gap-2 pb-2 border-b border-green-100">
                <div>
                  <span class="text-secondary uppercase text-[10px] font-bold block">Customer / Squad</span>
                  <span class="font-bold text-sm text-on-surface block">\${res.customerName || 'Player'}</span>
                  <span class="text-secondary text-[11px]">\${res.customerPhone || ''}</span>
                </div>
                <div>
                  <span class="text-secondary uppercase text-[10px] font-bold block">Pitch Arena</span>
                  <span class="font-bold text-sm text-on-surface block">\${res.turfName || 'Arena'}</span>
                  <span class="text-secondary text-[11px] truncate block">\${res.turfLocation || ''}</span>
                </div>
              </div>

              <div class="grid grid-cols-3 gap-2">
                <div>
                  <span class="text-secondary uppercase text-[10px] font-bold block">Booking Date</span>
                  <span class="font-semibold text-on-surface block">\${(res.booking && res.booking.bookingDate) || 'Today'}</span>
                </div>
                <div>
                  <span class="text-secondary uppercase text-[10px] font-bold block">Time Slot</span>
                  <span class="font-mono font-bold text-primary block">\${(res.booking && (res.booking.startTime + ' – ' + res.booking.endTime)) || ''}</span>
                </div>
                <div>
                  <span class="text-secondary uppercase text-[10px] font-bold block">Booking ID</span>
                  <span class="font-mono font-bold text-on-surface block">\${(res.booking && res.booking.bookingId) || ''}</span>
                </div>
              </div>

              <div class="grid grid-cols-2 gap-2 pt-2 border-t border-green-100">
                <div>
                  <span class="text-secondary uppercase text-[10px] font-bold block">Checked In At</span>
                  <span class="font-bold text-primary block">\${res.checkInTimeFormatted || 'Just now'}</span>
                </div>
                <div>
                  <span class="text-secondary uppercase text-[10px] font-bold block">Admitted By</span>
                  <span class="font-bold text-secondary block">\${res.checkedInBy || 'admin'}</span>
                </div>
              </div>
            </div>

            <div class="mt-4 flex items-center justify-between gap-2">
              <button onclick="resumeScanning()" class="w-full py-3 bg-green-700 hover:bg-green-800 text-white font-bold text-sm rounded-xl shadow-md flex items-center justify-center gap-2 transition-colors">
                <span class="material-symbols-outlined text-lg">qr_code_scanner</span>
                <span>SCAN NEXT QR</span>
              </button>
            </div>
          </div>
        `;

        // Update local stats counter
        const statEl = document.getElementById('statTodayCheckins');
        if (statEl) {
          const count = parseInt(statEl.innerText || '0', 10);
          statEl.innerText = count + 1;
        }

      } else if (res.resultCode === 'ALREADY_CHECKED_IN') {
        // ALREADY CHECKED IN WARNING
        content.innerHTML = `
          <div class="p-4 bg-amber-50 border-2 border-amber-500 rounded-2xl">
            <div class="flex items-center gap-3 mb-3">
              <div class="w-12 h-12 rounded-xl bg-amber-600 text-white flex items-center justify-center shrink-0 shadow-md">
                <span class="material-symbols-outlined text-3xl">warning</span>
              </div>
              <div>
                <span class="text-xs uppercase font-extrabold text-amber-700 tracking-wider block">Security Alert</span>
                <h3 class="text-lg font-bold text-amber-950 font-display">! ALREADY CHECKED IN</h3>
              </div>
            </div>
            <p class="text-xs text-amber-900 font-semibold mb-3">\${res.message}</p>
            
            <div class="bg-white p-3 rounded-xl border border-amber-200 text-xs space-y-1.5">
              <div class="flex justify-between"><span class="text-secondary">Player:</span><span class="font-bold text-on-surface">\${res.customerName || 'N/A'}</span></div>
              <div class="flex justify-between"><span class="text-secondary">Pitch:</span><span class="font-bold text-on-surface">\${res.turfName || 'N/A'}</span></div>
              <div class="flex justify-between"><span class="text-secondary">Initial Check-In:</span><span class="font-bold text-amber-800">\${res.checkInTimeFormatted || 'Earlier'}</span></div>
              <div class="flex justify-between"><span class="text-secondary">Operator:</span><span class="font-bold text-secondary">\${res.checkedInBy || 'admin'}</span></div>
            </div>

            <button onclick="resumeScanning()" class="w-full mt-3 py-2.5 bg-amber-600 hover:bg-amber-700 text-white font-bold text-xs rounded-xl shadow transition-colors flex items-center justify-center gap-1.5">
              <span class="material-symbols-outlined text-base">refresh</span>
              <span>SCAN NEXT QR</span>
            </button>
          </div>
        `;
      } else {
        // REJECTION / ERROR SCREEN
        content.innerHTML = `
          <div class="p-4 bg-red-50 border-2 border-red-500 rounded-2xl">
            <div class="flex items-center gap-3 mb-2">
              <div class="w-12 h-12 rounded-xl bg-red-600 text-white flex items-center justify-center shrink-0 shadow-md">
                <span class="material-symbols-outlined text-3xl">cancel</span>
              </div>
              <div>
                <span class="text-xs uppercase font-extrabold text-red-700 tracking-wider block">Entry Rejected</span>
                <h3 class="text-lg font-bold text-red-950 font-display">\${res.resultCode || 'INVALID PASS'}</h3>
              </div>
            </div>
            <p class="text-xs text-red-900 font-medium mb-3">\${res.message}</p>
            <button onclick="resumeScanning()" class="w-full py-2.5 bg-red-600 hover:bg-red-700 text-white font-bold text-xs rounded-xl shadow transition-colors flex items-center justify-center gap-1.5">
              <span class="material-symbols-outlined text-base">refresh</span>
              <span>TRY AGAIN / SCAN NEXT</span>
            </button>
          </div>
        `;
      }
    }

    function resumeScanning() {
      isProcessing = false;
      var modal = document.getElementById('resultModal');
      if (modal) modal.classList.add('hidden');
      resetScan();
      if (!isCameraRunning) {
        startLiveCamera();
      }
    }
  </script>
</body>
</html>
