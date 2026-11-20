<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.turfbook.model.Booking" %>
<%@ page import="com.turfbook.model.Payment" %>
<%@ page import="com.turfbook.model.Turf" %>
<%@ page import="com.turfbook.model.User" %>
<%@ page import="com.turfbook.service.TurfService" %>
<%@ page import="com.turfbook.util.QRCodeUtil" %>
<%@ page import="com.turfbook.dao.UserDAO" %>
<%
    Booking booking = (Booking) request.getAttribute("booking");
    Payment payment = (Payment) request.getAttribute("payment");
    User currentUser = (User) session.getAttribute("user");

    Turf bookedTurf = null;
    if (booking != null && booking.getTurfId() != null) {
        try {
            bookedTurf = (new TurfService()).getTurfById(booking.getTurfId());
        } catch (Exception ignored) {}
    }

    User customer = currentUser;
    if (customer == null && booking != null && booking.getUserId() != null) {
        try {
            customer = (new UserDAO()).findById(booking.getUserId());
        } catch (Exception ignored) {}
    }

    String qrToken = (booking != null && booking.getQrToken() != null && !booking.getQrToken().isEmpty())
            ? booking.getQrToken()
            : (booking != null ? "TB-CHECKIN-" + booking.getBookingId() : "TB-CHECKIN-DEMO");

    String qrCheckInUrl = QRCodeUtil.buildCheckInUrl(request, qrToken);
    String qrDataUri = QRCodeUtil.generateQRCodeDataUri(qrCheckInUrl, 360, 360);

    String mapsQuery = "";
    if (bookedTurf != null && bookedTurf.getLatitude() != 0.0 && bookedTurf.getLongitude() != 0.0) {
        mapsQuery = bookedTurf.getLatitude() + "," + bookedTurf.getLongitude();
    } else if (bookedTurf != null && bookedTurf.getFullLocation() != null) {
        mapsQuery = java.net.URLEncoder.encode(bookedTurf.getTurfName() + " " + bookedTurf.getFullLocation(), "UTF-8");
    } else if (booking != null && booking.getTurfLocation() != null) {
        mapsQuery = java.net.URLEncoder.encode(booking.getTurfName() + " " + booking.getTurfLocation(), "UTF-8");
    } else {
        mapsQuery = "Sports+Turf+Bengaluru";
    }
    String mapsUrl = "https://www.google.com/maps/search/?api=1&query=" + mapsQuery;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <meta name="theme-color" content="#006b2c"/>
  <link rel="manifest" href="<%= request.getContextPath() %>/manifest.json"/>
  <title>Booking Confirmed • TurfBook QR Pass</title>
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
          borderRadius: { 'DEFAULT': '0.25rem', 'lg': '0.5rem', 'xl': '0.75rem', 'full': '9999px' },
          spacing: { 'unit-sm': '0.75rem', 'unit-xs': '0.5rem', 'unit-2xs': '0.25rem', 'unit-2xl': '3rem', 'unit-3xl': '4rem', 'unit-lg': '1.5rem', 'unit-xl': '2rem', 'unit-md': '1rem' },
          fontFamily: { 'display': ['outfit'], 'headline-sm': ['outfit'], 'headline-xl': ['outfit'], 'headline-lg': ['outfit'], 'body-lg': ['inter'], 'body-md': ['inter'], 'body-sm': ['inter'], 'label-lg': ['inter'], 'label-md': ['inter'], 'label-sm': ['inter'] }
        }
      }
    };
  </script>
</head>
<body class="bg-surface font-body-md text-on-surface antialiased min-h-screen">
  <!-- Header (Hidden on Print) -->
  <header class="no-print fixed top-0 left-0 right-0 z-50 bg-surface-container-lowest border-b border-outline-variant/30 shadow-[0_1px_8px_rgba(0,0,0,0.04)]">
    <div class="h-16 max-w-[1280px] mx-auto px-unit-md lg:px-unit-xl flex items-center justify-between gap-unit-md">
      <a class="flex items-center gap-unit-xs group" href="<%= request.getContextPath() %>/index.jsp">
        <div class="w-9 h-9 rounded-lg bg-primary flex items-center justify-center text-on-primary shadow-sm">
          <span class="material-symbols-outlined text-[22px]">sports_soccer</span>
        </div>
        <span class="font-headline-sm text-headline-sm text-on-surface tracking-tight font-bold">Turf<span class="text-primary">Book</span></span>
      </a>
      <div class="flex items-center gap-unit-sm">
        <a href="<%= request.getContextPath() %>/user/booking?action=my-bookings" class="font-label-md font-bold text-primary hover:underline flex items-center gap-1">
          <span>My Bookings</span>
          <span class="material-symbols-outlined text-base">arrow_forward</span>
        </a>
      </div>
    </div>
  </header>

  <main class="w-full pt-20 px-unit-md lg:px-unit-xl py-unit-xl min-h-screen flex items-center justify-center">
    <div class="max-w-[680px] w-full mx-auto flex flex-col items-center">
      


      <!-- Animated Checkmark SVG (Hidden on Print) -->
      <div class="no-print my-unit-xs flex items-center justify-center">
        <svg class="checkmark-svg" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 52 52">
          <circle class="checkmark-circle" cx="26" cy="26" r="25" fill="none"/>
          <path class="checkmark-check" fill="none" d="M14.1 27.2l7.1 7.2 16.7-16.8"/>
        </svg>
      </div>

      <div class="no-print text-center mb-unit-lg">
        <h1 class="font-display font-extrabold text-on-surface text-3xl sm:text-4xl tracking-tight">BOOKING CONFIRMED</h1>
        <p class="font-body-md text-secondary max-w-md mx-auto mt-1">
          Your game is locked in. Present this digital ticket or printed pass at the venue entrance.
        </p>
      </div>

      <!-- Professional Digital Booking Pass (Printable on A4) -->
      <div class="printable-pass w-full bg-surface-container-lowest rounded-2xl shadow-xl border border-outline-variant/40 overflow-hidden relative" id="ticket-pass">
        
        <!-- Pass Header -->
        <div class="bg-primary px-unit-lg py-4 text-on-primary flex items-center justify-between">
          <div class="flex items-center gap-unit-xs">
            <div class="w-8 h-8 rounded-lg bg-white/15 flex items-center justify-center text-white">
              <span class="material-symbols-outlined text-xl">sports_soccer</span>
            </div>
            <div>
              <span class="text-xs font-bold tracking-widest uppercase text-primary-fixed block">TURFBOOK PASS</span>
              <span class="text-[11px] text-white/80 italic font-medium">Book Your Game. Own the Turf.</span>
            </div>
          </div>
          <div class="text-right">
            <span class="bg-primary-fixed text-on-primary-fixed font-bold text-xs px-3 py-1 rounded-full uppercase tracking-wider inline-block">
              <%= booking != null ? booking.getStatus().name() : "CONFIRMED" %>
            </span>
            <div class="text-[11px] text-white/80 font-mono mt-0.5"><%= booking != null ? booking.getBookingId() : "TB-PASS" %></div>
          </div>
        </div>

        <!-- Pass Body -->
        <div class="p-unit-lg space-y-unit-md">

          <!-- QR Code Centerpiece -->
          <div class="flex flex-col items-center justify-center p-unit-md bg-surface-container-low rounded-2xl border border-outline-variant/30 text-center">
            <div class="p-3 bg-white rounded-xl shadow-md border-2 border-primary/20 inline-block">
              <% if (!qrDataUri.isEmpty()) { %>
                <img src="<%= qrDataUri %>" alt="Booking QR Code" class="print-qr-code w-48 h-48 sm:w-56 sm:h-56 object-contain" id="bookingQrImage"/>
              <% } else { %>
                <img src="<%= request.getContextPath() %>/qr?token=<%= java.net.URLEncoder.encode(qrToken, "UTF-8") %>" alt="Booking QR Code" class="print-qr-code w-48 h-48 sm:w-56 sm:h-56 object-contain"/>
              <% } %>
            </div>
            <div class="mt-2.5">
              <span class="font-mono text-xs font-bold text-primary tracking-wider bg-white px-3 py-1 rounded-full border border-primary/20 inline-block">
                <%= qrToken %>
              </span>
              <p class="text-xs text-secondary mt-1 font-medium">
                Scan with TurfBook Admin Scanner upon gate entry. Single-use authenticated token.
              </p>
            </div>
          </div>

          <!-- Turf Information -->
          <div class="pb-unit-sm border-b border-outline-variant/20">
            <span class="text-xs uppercase font-extrabold text-primary tracking-wider block mb-1">Turf Information</span>
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-unit-xs">
              <div>
                <span class="text-[11px] text-secondary uppercase font-semibold block">Venue Name</span>
                <span class="font-headline-sm font-bold text-on-surface text-base block">
                  <%= bookedTurf != null ? bookedTurf.getTurfName() : (booking != null && booking.getTurfName() != null ? booking.getTurfName() : "Turf Arena") %>
                </span>
                <span class="text-xs text-secondary"><%= bookedTurf != null ? bookedTurf.getTurfType() : "Sports Pitch" %></span>
              </div>
              <div>
                <span class="text-[11px] text-secondary uppercase font-semibold block">Full Address</span>
                <span class="text-xs font-medium text-on-surface block">
                  <%= bookedTurf != null ? (bookedTurf.getAddress() + ", " + bookedTurf.getCity() + ", " + bookedTurf.getState() + " " + bookedTurf.getPostalCode()) : (booking != null && booking.getTurfLocation() != null ? booking.getTurfLocation() : "Bengaluru, Karnataka") %>
                </span>
                <% if (bookedTurf != null && bookedTurf.getLatitude() != 0.0) { %>
                  <span class="text-[11px] font-mono text-secondary">GPS: <%= bookedTurf.getLatitude() %>, <%= bookedTurf.getLongitude() %></span>
                <% } %>
              </div>
            </div>
          </div>

          <!-- Booking Information -->
          <div class="pb-unit-sm border-b border-outline-variant/20">
            <span class="text-xs uppercase font-extrabold text-primary tracking-wider block mb-1">Booking Information</span>
            <div class="grid grid-cols-2 sm:grid-cols-4 gap-unit-xs">
              <div>
                <span class="text-[11px] text-secondary uppercase font-semibold block">Match Date</span>
                <span class="text-xs font-bold text-on-surface block"><%= booking != null ? booking.getBookingDate() : "" %></span>
              </div>
              <div>
                <span class="text-[11px] text-secondary uppercase font-semibold block">Time Slot</span>
                <span class="text-xs font-mono font-bold text-primary block"><%= booking != null ? booking.getStartTime() + " – " + booking.getEndTime() : "" %></span>
              </div>
              <div>
                <span class="text-[11px] text-secondary uppercase font-semibold block">Duration</span>
                <span class="text-xs font-bold text-on-surface block"><%= booking != null ? booking.getDuration() : 1.0 %> Hour(s)</span>
              </div>
              <div>
                <span class="text-[11px] text-secondary uppercase font-semibold block">Pass Status</span>
                <span class="text-xs font-bold text-green-700 block">CONFIRMED</span>
              </div>
            </div>
            <% if (booking != null && booking.getCourtCount() > 0) { %>
              <div class="mt-3 p-3 bg-blue-50 border-2 border-blue-400 rounded-xl flex items-center justify-between">
                <div class="flex items-center gap-2.5">
                  <span class="material-symbols-outlined text-blue-700 text-2xl">sports_tennis</span>
                  <div>
                    <span class="text-[10px] uppercase font-bold text-blue-800 tracking-wider">
                      <%= booking.getCourtCount() > 1 ? "Assigned Courts (" + booking.getCourtCount() + ")" : "Assigned Court" %>
                    </span>
                    <span class="text-base font-black text-blue-950 block">🏸 <%= booking.getCourtsDisplay() %></span>
                  </div>
                </div>
                <span class="bg-blue-600 text-white font-black text-xs px-3 py-1 rounded-lg"><%= booking.getCourtsBadgeText() %></span>
              </div>
            <% } %>
          </div>

          <!-- Customer Information -->
          <div class="pb-unit-sm border-b border-outline-variant/20">
            <span class="text-xs uppercase font-extrabold text-primary tracking-wider block mb-1">Customer Information</span>
            <div class="grid grid-cols-2 sm:grid-cols-4 gap-unit-xs">
              <div>
                <span class="text-[11px] text-secondary uppercase font-semibold block">Player Name</span>
                <span class="text-xs font-bold text-on-surface block"><%= customer != null ? customer.getUsername() : (booking != null ? booking.getUserId() : "Player") %></span>
              </div>
              <div>
                <span class="text-[11px] text-secondary uppercase font-semibold block">Username</span>
                <span class="text-xs text-on-surface block">@<%= customer != null ? customer.getUsername() : "player" %></span>
              </div>
              <div>
                <span class="text-[11px] text-secondary uppercase font-semibold block">Email</span>
                <span class="text-xs text-on-surface truncate block"><%= customer != null && customer.getEmail() != null ? customer.getEmail() : "N/A" %></span>
              </div>
              <div>
                <span class="text-[11px] text-secondary uppercase font-semibold block">Phone</span>
                <span class="text-xs text-on-surface block"><%= customer != null && customer.getPhone() != null ? customer.getPhone() : "N/A" %></span>
              </div>
            </div>
          </div>

          <!-- Payment Information -->
          <div>
            <span class="text-xs uppercase font-extrabold text-primary tracking-wider block mb-1">Payment Information</span>
            <div class="grid grid-cols-2 sm:grid-cols-4 gap-unit-xs">
              <div>
                <span class="text-[11px] text-secondary uppercase font-semibold block">Total Amount</span>
                <span class="font-headline-sm font-bold text-on-surface text-base block">₹<%= booking != null ? (int) booking.getTotalAmount() : 0 %></span>
              </div>
              <div>
                <span class="text-[11px] text-secondary uppercase font-semibold block">Payment Method</span>
                <span class="text-xs font-bold text-secondary block"><%= payment != null ? payment.getPaymentMethod() : "UPI SIMULATION" %></span>
              </div>
              <div>
                <span class="text-[11px] text-secondary uppercase font-semibold block">Txn Reference</span>
                <span class="text-[11px] font-mono font-semibold text-secondary block truncate"><%= payment != null ? payment.getTransactionReference() : ("TXN-" + (booking != null ? booking.getBookingId() : "")) %></span>
              </div>
              <div>
                <span class="text-[11px] text-secondary uppercase font-semibold block">Payment Status</span>
                <span class="text-xs font-bold text-primary flex items-center gap-1">
                  <span class="material-symbols-outlined text-xs">check_circle</span>
                  PAID
                </span>
              </div>
            </div>
          </div>

        </div>

        <!-- Venue Location & GPS Navigation Box (Hidden on Print) -->
        <div class="no-print bg-surface-container-low p-unit-md border-t border-outline-variant/30 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-unit-md">
          <div class="flex items-start gap-2.5">
            <div class="w-9 h-9 rounded-xl bg-primary/10 text-primary flex items-center justify-center shrink-0 mt-0.5">
              <span class="material-symbols-outlined text-[22px]">location_on</span>
            </div>
            <div>
              <span class="text-xs font-bold uppercase tracking-wider text-primary block">Pitch GPS Destination</span>
              <a href="<%= mapsUrl %>" target="_blank" class="font-bold text-sm text-on-surface hover:text-primary transition-colors flex items-center gap-1 group" title="Click to navigate on Google Maps">
                <span><%= bookedTurf != null ? bookedTurf.getFullLocation() : (booking != null && booking.getTurfLocation() != null ? booking.getTurfLocation() : "Koramangala, Bengaluru") %></span>
                <span class="material-symbols-outlined text-xs group-hover:translate-x-0.5 transition-transform text-primary">open_in_new</span>
              </a>
            </div>
          </div>
          <a href="<%= mapsUrl %>" target="_blank" class="w-full sm:w-auto px-unit-md py-2 bg-[#1a73e8] hover:bg-[#1557b0] text-white font-label-sm font-bold rounded-xl shadow-sm transition-all flex items-center justify-center gap-1.5 shrink-0" title="Opens GPS directions in Google Maps">
            <span class="material-symbols-outlined text-base">near_me</span>
            <span>Google Maps GPS</span>
          </a>
        </div>

        <!-- Notice & Verification Footer -->
        <div class="bg-surface-container-lowest px-unit-lg py-3 text-center text-xs text-secondary border-t border-outline-variant/20">
          <p class="font-bold text-on-surface">Present this QR code at the turf during your booked time slot.</p>
          <p class="text-[11px] text-secondary mt-0.5">Valid only for match slot <%= booking != null ? booking.getBookingDate() + " (" + booking.getStartTime() + " - " + booking.getEndTime() + ")" : "" %>. Single check-in permitted.</p>
        </div>
      </div>

      <!-- Action Buttons (Hidden on Print) -->
      <div class="no-print flex flex-wrap items-center justify-center gap-unit-md mt-unit-xl w-full">
        <button onclick="window.print()" class="px-unit-xl py-3 bg-primary hover:bg-primary-container text-on-primary font-label-md font-bold rounded-xl transition-all shadow-lg flex items-center gap-2">
          <span class="material-symbols-outlined text-lg">print</span>
          <span>PRINT / SAVE PDF PASS</span>
        </button>
        <a href="<%= mapsUrl %>" target="_blank" class="px-unit-lg py-3 bg-[#1a73e8] hover:bg-[#1557b0] text-white font-label-md font-bold rounded-xl transition-all flex items-center gap-2 shadow-md">
          <span class="material-symbols-outlined text-lg">near_me</span>
          <span>GET DIRECTIONS</span>
        </a>
        <a href="<%= request.getContextPath() %>/user/booking?action=my-bookings" class="px-unit-lg py-3 bg-surface-container hover:bg-surface-container-high text-on-surface font-label-md font-bold rounded-xl transition-all flex items-center gap-1.5 shadow-sm">
          <span class="material-symbols-outlined text-base">receipt_long</span>
          <span>MY BOOKINGS</span>
        </a>
      </div>

    </div>
  </main>
  <script src="<%= request.getContextPath() %>/js/app.js"></script>
</body>
</html>
