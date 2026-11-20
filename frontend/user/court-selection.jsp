<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.turfbook.model.Turf" %>
<%@ page import="com.turfbook.model.User" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.time.LocalTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.TextStyle" %>
<%@ page import="java.util.Locale" %>
<%
    Turf turf = (Turf) request.getAttribute("turf");
    String bookingDate = (String) request.getAttribute("bookingDate");
    String startTime   = (String) request.getAttribute("startTime");
    String endTime     = (String) request.getAttribute("endTime");
    @SuppressWarnings("unchecked")
    Set<Integer> occupiedCourts = (Set<Integer>) request.getAttribute("occupiedCourts");
    User currentUser = (User) session.getAttribute("user");

    if (turf == null || bookingDate == null || startTime == null || endTime == null) {
        response.sendRedirect(request.getContextPath() + "/turfs");
        return;
    }
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Format display time 24h → 12h
    DateTimeFormatter fmt24 = DateTimeFormatter.ofPattern("HH:mm");
    DateTimeFormatter fmt12 = DateTimeFormatter.ofPattern("h:mm a");
    String displayStart = LocalTime.parse(startTime, fmt24).format(fmt12);
    String displayEnd   = LocalTime.parse(endTime,   fmt24).format(fmt12);

    // Calculate duration
    int startMinutes = Integer.parseInt(startTime.split(":")[0]) * 60 + Integer.parseInt(startTime.split(":")[1]);
    int endMinutes   = Integer.parseInt(endTime.split(":")[0])   * 60 + Integer.parseInt(endTime.split(":")[1]);
    int durationMins = endMinutes - startMinutes;

    // Format the booking date nicely: "05 October 2026"
    LocalDate ld = LocalDate.parse(bookingDate);
    String displayDate = String.format("%02d %s %d",
        ld.getDayOfMonth(),
        ld.getMonth().getDisplayName(TextStyle.FULL, Locale.ENGLISH),
        ld.getYear());

    // Court count from admin config
    int courtCount = turf.getCourtCount() > 0 ? turf.getCourtCount() : 4;
    int pricePerHour = (int) turf.getPricePerHour();
    double durationHours = durationMins / 60.0;
    int totalAmount = (int) Math.round(durationHours * pricePerHour);

    // Error from redirect-back
    String errorMsg = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Select Court – <%= turf.getTurfName() %> • TurfBook</title>
  <link href="https://fonts.googleapis.com" rel="preconnect"/>
  <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&display=block" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@600;700&display=swap" rel="stylesheet"/>
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
            'surface-bright': '#f8f9ff', 'error-container': '#ffdad6',
            'secondary-container': '#dae2fd', 'outline-variant': '#bdcaba', 'inverse-surface': '#213145',
            'secondary': '#565e74', 'on-error': '#ffffff', 'primary-fixed-dim': '#62df7d',
            'on-primary': '#ffffff', 'surface-tint': '#006e2d', 'on-primary-container': '#f7fff2',
            'inverse-on-surface': '#eaf1ff', 'error': '#ba1a1a', 'surface-container-low': '#eff4ff',
            'background': '#f8f9ff', 'outline': '#6e7b6c', 'primary-fixed': '#7ffc97',
            'surface': '#f8f9ff', 'secondary-fixed-dim': '#bec6e0', 'on-background': '#0b1c30',
            'on-surface': '#0b1c30', 'primary-container': '#00873a', 'surface-dim': '#cbdbf5',
            'tertiary-container': '#00855b', 'tertiary': '#006947', 'on-surface-variant': '#3e4a3d',
            'primary': '#006b2c', 'inverse-primary': '#62df7d', 'surface-variant': '#d3e4fe',
            'secondary-fixed': '#dae2fd'
          },
          borderRadius: { 'DEFAULT': '0.25rem', 'lg': '0.5rem', 'xl': '0.75rem', 'full': '9999px' },
          fontFamily: { 'display': ['outfit'], 'body-md': ['inter'], 'body-sm': ['inter'], 'label-lg': ['inter'], 'label-md': ['inter'], 'headline-sm': ['outfit'], 'headline-lg': ['outfit'] }
        }
      }
    };
  </script>
  <style>
    .material-symbols-outlined {
      font-family: 'Material Symbols Outlined', sans-serif !important;
      font-weight: normal; font-style: normal; font-size: 24px; line-height: 1;
      letter-spacing: normal; text-transform: none; display: inline-flex;
      align-items: center; justify-content: center; white-space: nowrap;
      word-wrap: normal; direction: ltr; -webkit-font-smoothing: antialiased;
      -moz-osx-font-smoothing: grayscale; text-rendering: optimizeLegibility;
      font-feature-settings: 'liga'; flex-shrink: 0;
    }
    ::-webkit-scrollbar { display: none; }
    html, body { margin: 0; padding: 0; }

    /* Court card styles */
    .court-card {
      cursor: pointer;
      transition: all 0.18s cubic-bezier(0.4, 0, 0.2, 1);
      border: 2px solid transparent;
      position: relative;
      overflow: hidden;
    }
    .court-card:hover:not(.court-booked) {
      border-color: #006b2c;
      box-shadow: 0 4px 20px rgba(0,107,44,0.13);
      transform: translateY(-2px);
    }
    .court-card.court-selected {
      border-color: #006b2c !important;
      background: #f0fff5 !important;
      box-shadow: 0 4px 24px rgba(0,107,44,0.18);
    }
    .court-card.court-booked {
      opacity: 0.52;
      cursor: not-allowed;
      background: #f4f4f7;
    }
    .court-card.court-selected .court-check {
      display: flex !important;
    }
    .court-check { display: none; }

    /* Sticky summary on desktop */
    @media (min-width: 1024px) {
      .summary-sticky { position: sticky; top: 80px; }
    }
  </style>
</head>
<body class="bg-surface font-body-md text-on-surface antialiased min-h-screen">

  <!-- ── Header ────────────────────────────────────────────────── -->
  <header class="fixed top-0 left-0 right-0 z-50 bg-surface-container-lowest border-b border-outline-variant/30 shadow-[0_1px_8px_rgba(0,0,0,0.04)]">
    <div class="h-16 max-w-[1280px] mx-auto px-4 lg:px-8 flex items-center justify-between gap-4">
      <div class="flex items-center gap-4">
        <!-- Back button -->
        <a href="<%= request.getContextPath() %>/turf?action=details&id=<%= turf.getTurfId() %>&date=<%= bookingDate %>"
           class="flex items-center gap-1.5 px-3 py-2 rounded-xl bg-surface-container-low border border-outline-variant/30 hover:bg-surface-container text-on-surface-variant hover:text-on-surface transition-colors">
          <span class="material-symbols-outlined text-[20px]">arrow_back</span>
          <span class="text-sm font-semibold hidden sm:inline">Back</span>
        </a>
        <!-- Logo -->
        <a class="flex items-center gap-2 group" href="<%= request.getContextPath() %>/index.jsp">
          <div class="w-9 h-9 rounded-lg bg-primary flex items-center justify-center text-on-primary shadow-sm">
            <span class="material-symbols-outlined text-[22px]">sports_soccer</span>
          </div>
          <span class="font-headline-sm text-on-surface tracking-tight font-bold hidden sm:inline">Turf<span class="text-primary">Book</span></span>
        </a>
      </div>
      <div class="flex items-center gap-3">
        <!-- Badminton badge -->
        <span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-blue-100 text-blue-800 font-label-md font-bold text-sm">
          <span class="material-symbols-outlined text-[16px]">sports_tennis</span>
          BADMINTON
        </span>
        <!-- User avatar -->
        <a href="<%= request.getContextPath() %>/user/dashboard.jsp"
           class="flex items-center gap-2 pl-1 py-1 pr-3 rounded-full bg-surface-container-low border border-outline-variant/40 hover:bg-surface-container transition-colors">
          <div class="w-8 h-8 rounded-full bg-primary text-on-primary font-bold flex items-center justify-center text-xs">
            <%= currentUser.getUsername().substring(0, 1).toUpperCase() %>
          </div>
          <span class="hidden md:inline font-label-md text-on-surface font-semibold"><%= currentUser.getUsername() %></span>
        </a>
      </div>
    </div>
  </header>

  <main class="w-full pt-20 pb-16 bg-surface min-h-screen">
    <div class="max-w-[1280px] mx-auto px-4 lg:px-8">

      <!-- ── Page Header ─────────────────────────────────────────── -->
      <div class="mb-6">
        <p class="text-sm text-secondary font-semibold uppercase tracking-wider mb-1"><%= turf.getTurfName() %></p>
        <h1 class="font-headline-lg text-3xl lg:text-4xl font-bold text-on-surface tracking-tight">SELECT YOUR COURT</h1>
        <p class="text-on-surface-variant text-sm mt-1">Choose your preferred court for the selected time slot</p>
      </div>

      <!-- ── Error Banner ─────────────────────────────────────────── -->
      <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
      <div class="mb-5 p-4 rounded-xl bg-error-container border border-error/30 flex items-start gap-3">
        <span class="material-symbols-outlined text-error text-[20px] mt-0.5 flex-shrink-0">error</span>
        <div>
          <p class="font-label-md font-bold text-error">Court No Longer Available</p>
          <p class="text-sm text-on-surface mt-0.5"><%= errorMsg %></p>
        </div>
      </div>
      <% } %>

      <!-- ── Selected Slot Banner ─────────────────────────────────── -->
      <div class="mb-6 p-4 rounded-2xl bg-surface-container-lowest border border-outline-variant/30 shadow-sm">
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
          <!-- Date once at page level -->
          <div class="flex items-center gap-3">
            <div class="w-10 h-10 rounded-xl bg-primary/10 flex items-center justify-center flex-shrink-0">
              <span class="material-symbols-outlined text-primary text-[22px]">calendar_today</span>
            </div>
            <div>
              <p class="text-[11px] text-secondary font-bold uppercase tracking-wider">Date</p>
              <p class="font-label-lg font-bold text-on-surface"><%= displayDate %></p>
            </div>
          </div>
          <!-- Separator -->
          <div class="hidden sm:block w-px h-10 bg-outline-variant/30"></div>
          <!-- Time -->
          <div class="flex items-center gap-3">
            <div class="w-10 h-10 rounded-xl bg-primary/10 flex items-center justify-center flex-shrink-0">
              <span class="material-symbols-outlined text-primary text-[22px]">schedule</span>
            </div>
            <div>
              <p class="text-[11px] text-secondary font-bold uppercase tracking-wider">Time</p>
              <p class="font-label-lg font-bold text-on-surface"><%= displayStart %> – <%= displayEnd %></p>
            </div>
          </div>
          <!-- Separator -->
          <div class="hidden sm:block w-px h-10 bg-outline-variant/30"></div>
          <!-- Duration -->
          <div class="flex items-center gap-3">
            <div class="w-10 h-10 rounded-xl bg-primary/10 flex items-center justify-center flex-shrink-0">
              <span class="material-symbols-outlined text-primary text-[22px]">timer</span>
            </div>
            <div>
              <p class="text-[11px] text-secondary font-bold uppercase tracking-wider">Duration</p>
              <p class="font-label-lg font-bold text-on-surface"><%= durationMins %> Mins</p>
            </div>
          </div>
        </div>
      </div>

      <!-- ── Main Grid: Courts + Summary ───────────────────────────── -->
      <div class="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">

        <!-- ── Court Cards (Left 7 cols) ──────────────────────────── -->
        <div class="lg:col-span-7">
          <div class="flex items-center justify-between mb-4">
            <h2 class="font-headline-sm text-xl font-bold text-on-surface">
              SELECT YOUR COURT
            </h2>
            <span class="text-sm text-secondary font-semibold"><%= courtCount %> Courts Available</span>
          </div>

          <div class="grid grid-cols-1 sm:grid-cols-2 gap-4" id="courts-grid">
            <%
              for (int i = 1; i <= courtCount; i++) {
                boolean booked = (occupiedCourts != null && occupiedCourts.contains(i));
                String courtName = "Premium Hybrid Court " + i;
            %>
            <div class="court-card bg-surface-container-lowest rounded-2xl p-5 shadow-sm border border-outline-variant/20
                        <%= booked ? "court-booked" : "court-available" %>"
                 id="court-card-<%= i %>"
                 data-court="<%= i %>"
                 data-court-name="<%= courtName %>"
                 onclick="<%= booked ? "" : "toggleCourt(" + i + ", '" + courtName + "', " + pricePerHour + ")" %>">

              <!-- Check indicator (shown when selected) -->
              <div class="court-check absolute top-3 right-3 w-7 h-7 rounded-full bg-primary items-center justify-center">
                <span class="material-symbols-outlined text-on-primary text-[16px]">check</span>
              </div>

              <!-- Court icon & number -->
              <div class="flex items-start justify-between mb-4">
                <div class="w-12 h-12 rounded-xl flex items-center justify-center
                            <%= booked ? "bg-slate-100" : "bg-primary/10" %>">
                  <span class="material-symbols-outlined text-[26px] <%= booked ? "text-slate-400" : "text-primary" %>">sports_tennis</span>
                </div>
                <!-- Status badge -->
                <% if (booked) { %>
                  <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full bg-slate-200 text-slate-600 text-[11px] font-bold uppercase tracking-wide">
                    <span class="w-1.5 h-1.5 rounded-full bg-slate-400"></span>
                    BOOKED
                  </span>
                <% } else { %>
                  <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full bg-green-100 text-green-800 text-[11px] font-bold uppercase tracking-wide">
                    <span class="w-1.5 h-1.5 rounded-full bg-green-500 animate-pulse"></span>
                    AVAILABLE
                  </span>
                <% } %>
              </div>

              <!-- Court name & price -->
              <div>
                <p class="font-label-lg font-bold text-on-surface text-[15px]">COURT <%= i %></p>
                <p class="text-secondary text-sm mt-0.5 font-medium"><%= courtName %></p>
              </div>

              <div class="mt-4 pt-4 border-t border-outline-variant/20 flex items-center justify-between">
                <div>
                  <p class="text-[11px] text-secondary font-semibold uppercase tracking-wide">Court Rate</p>
                  <p class="font-headline-sm text-lg font-bold text-primary">₹<%= pricePerHour %></p>
                  <p class="text-[11px] text-secondary">per hour</p>
                </div>
                <% if (!booked) { %>
                  <div class="text-primary">
                    <span class="material-symbols-outlined text-[28px]">chevron_right</span>
                  </div>
                <% } %>
              </div>
            </div>
            <% } %>
          </div>
        </div>

        <!-- ── Booking Summary (Right 5 cols) ───────────────────────── -->
        <div class="lg:col-span-5 summary-sticky">
          <div class="bg-surface-container-lowest rounded-2xl shadow-xl border border-outline-variant/30 overflow-hidden" id="summary-panel">

            <!-- Summary Header -->
            <div class="bg-primary px-5 py-4">
              <p class="text-on-primary text-[11px] font-bold uppercase tracking-widest mb-0.5">Booking Summary</p>
              <p class="text-on-primary/80 text-sm">Review your selection before continuing</p>
            </div>

            <div class="p-5 space-y-4">

              <!-- No court selected state -->
              <div id="no-court-msg" class="py-6 text-center">
                <div class="w-14 h-14 rounded-full bg-surface-container-low flex items-center justify-center mx-auto mb-3">
                  <span class="material-symbols-outlined text-on-surface-variant text-[30px]">sports_tennis</span>
                </div>
                <p class="font-label-md font-semibold text-on-surface-variant">Select one or more courts to continue</p>
                <p class="text-sm text-secondary mt-1">Click any available court on the left</p>
              </div>

              <!-- Summary details (shown after selecting) -->
              <div id="summary-details" class="hidden space-y-3">
                <!-- Turf -->
                <div class="flex justify-between items-start py-2 border-b border-outline-variant/20">
                  <span class="text-sm text-secondary font-semibold">Turf Name</span>
                  <span class="text-sm font-bold text-on-surface text-right max-w-[180px]"><%= turf.getTurfName() %></span>
                </div>
                <!-- Sport -->
                <div class="flex justify-between items-start py-2 border-b border-outline-variant/20">
                  <span class="text-sm text-secondary font-semibold">Sport</span>
                  <span class="inline-flex items-center gap-1 px-2 py-0.5 rounded-full bg-blue-100 text-blue-800 text-xs font-bold">
                    <span class="material-symbols-outlined text-[12px]">sports_tennis</span>
                    Badminton
                  </span>
                </div>
                <!-- Date -->
                <div class="flex justify-between items-start py-2 border-b border-outline-variant/20">
                  <span class="text-sm text-secondary font-semibold">Selected Date</span>
                  <span class="text-sm font-bold text-on-surface"><%= displayDate %></span>
                </div>
                <!-- Time -->
                <div class="flex justify-between items-start py-2 border-b border-outline-variant/20">
                  <span class="text-sm text-secondary font-semibold">Time Slot</span>
                  <span class="text-sm font-bold text-on-surface"><%= displayStart %> – <%= displayEnd %></span>
                </div>
                <!-- Duration -->
                <div class="flex justify-between items-start py-2 border-b border-outline-variant/20">
                  <span class="text-sm text-secondary font-semibold">Duration</span>
                  <span class="text-sm font-bold text-on-surface"><%= durationMins %> Minutes</span>
                </div>
                <!-- Number of Selected Courts -->
                <div class="flex justify-between items-start py-2 border-b border-outline-variant/20">
                  <span class="text-sm text-secondary font-semibold">Number of Courts</span>
                  <span class="text-sm font-bold text-primary" id="summary-court-count">0 Courts</span>
                </div>
                <!-- Names of All Selected Courts -->
                <div class="flex justify-between items-start py-2 border-b border-outline-variant/20">
                  <span class="text-sm text-secondary font-semibold">Selected Courts</span>
                  <span class="text-sm font-bold text-on-surface text-right max-w-[200px] break-words" id="summary-court-name">—</span>
                </div>
                <!-- Rate Per Court -->
                <div class="flex justify-between items-start py-2 border-b border-outline-variant/20">
                  <span class="text-sm text-secondary font-semibold">Rate Per Court</span>
                  <span class="text-sm font-bold text-on-surface">₹<%= pricePerHour %>/hour</span>
                </div>
                <!-- Total -->
                <div class="pt-3 border-t border-outline-variant/30">
                  <div class="flex justify-between items-center">
                    <span class="font-label-lg font-bold text-on-surface text-base">Total Amount</span>
                    <span class="font-headline-sm text-2xl font-bold text-primary" id="summary-total-amount">₹0</span>
                  </div>
                  <p class="text-[11px] text-secondary text-right mt-1 font-mono" id="summary-calc-formula"></p>
                </div>
              </div>

              <!-- CTA Form -->
              <form id="booking-form" action="<%= request.getContextPath() %>/user/booking" method="POST" class="mt-4">
                <input type="hidden" name="turfId"          value="<%= turf.getTurfId() %>"/>
                <input type="hidden" name="bookingDate"     value="<%= bookingDate %>"/>
                <input type="hidden" name="startTime"       value="<%= startTime %>"/>
                <input type="hidden" name="endTime"         value="<%= endTime %>"/>
                <input type="hidden" name="assignedCourts"  id="assignedCourts" value=""/>
                <input type="hidden" name="assignedCourt"   id="assignedCourt"  value=""/>

                <button type="submit" id="continue-btn"
                        class="w-full py-3.5 px-5 rounded-xl font-label-lg font-bold shadow-md transition-all flex items-center justify-center gap-2
                               bg-slate-200 text-slate-500 cursor-not-allowed"
                        disabled>
                  <span class="material-symbols-outlined text-[20px]">sports_tennis</span>
                  <span id="cta-text">Select at Least One Court</span>
                </button>
              </form>

              <p class="text-center text-[11px] text-secondary">
                <span class="material-symbols-outlined text-[13px] align-middle text-primary">verified</span>
                100% Secure • Single Transaction • Instant QR Pass
              </p>
            </div>
          </div>

          <!-- Back to slot selection link -->
          <a href="<%= request.getContextPath() %>/turf?action=details&id=<%= turf.getTurfId() %>&date=<%= bookingDate %>"
             class="flex items-center justify-center gap-1.5 mt-4 py-2.5 rounded-xl border border-outline-variant/40 text-on-surface-variant hover:text-on-surface hover:bg-surface-container-low transition-colors text-sm font-semibold">
            <span class="material-symbols-outlined text-[18px]">arrow_back</span>
            Change Time Slot
          </a>
        </div>

      </div>
    </div>
  </main>

  <script>
    var selectedCourts = {}; // map: courtNum -> { name, price }
    var durationHours = <%= durationHours %>;
    var pricePerHour = <%= pricePerHour %>;

    function toggleCourt(courtNum, courtName, rate) {
      var card = document.getElementById('court-card-' + courtNum);
      if (!card || card.classList.contains('court-booked')) return;

      if (selectedCourts[courtNum]) {
        // Deselect court
        delete selectedCourts[courtNum];
        card.classList.remove('court-selected');
      } else {
        // Select court
        selectedCourts[courtNum] = { name: courtName, rate: rate };
        card.classList.add('court-selected');
      }

      updateSummary();
    }

    function updateSummary() {
      var courtNums = Object.keys(selectedCourts).map(Number).sort(function(a, b) { return a - b; });
      var count = courtNums.length;
      var btn = document.getElementById('continue-btn');
      var ctaText = document.getElementById('cta-text');

      if (count === 0) {
        document.getElementById('no-court-msg').classList.remove('hidden');
        document.getElementById('summary-details').classList.add('hidden');
        document.getElementById('assignedCourts').value = '';
        document.getElementById('assignedCourt').value = '';
        btn.disabled = true;
        btn.className = 'w-full py-3.5 px-5 rounded-xl font-label-lg font-bold shadow-md transition-all flex items-center justify-center gap-2 bg-slate-200 text-slate-500 cursor-not-allowed';
        ctaText.textContent = 'Select at Least One Court';
        return;
      }

      document.getElementById('no-court-msg').classList.add('hidden');
      document.getElementById('summary-details').classList.remove('hidden');

      // Update court count and names
      document.getElementById('summary-court-count').textContent = count + (count === 1 ? ' Court' : ' Courts');
      var courtNames = courtNums.map(function(n) { return 'Court ' + n; }).join(', ');
      document.getElementById('summary-court-name').textContent = courtNames;

      // Dynamic calculation: Number of Courts * Rate * Duration
      var total = Math.round(count * durationHours * pricePerHour);
      document.getElementById('summary-total-amount').textContent = '₹' + total;
      document.getElementById('summary-calc-formula').textContent = count + ' court' + (count > 1 ? 's' : '') + ' × ₹' + pricePerHour + '/hr × ' + durationHours + ' hr = ₹' + total;

      // Update hidden form fields
      document.getElementById('assignedCourts').value = courtNums.join(',');
      document.getElementById('assignedCourt').value = courtNums[0];

      // Enable CTA button
      btn.disabled = false;
      btn.className = 'w-full py-3.5 px-5 rounded-xl font-label-lg font-bold shadow-md transition-all flex items-center justify-center gap-2 bg-primary text-on-primary hover:bg-primary-container active:scale-[0.98] cursor-pointer';
      ctaText.textContent = 'Proceed to Booking • ₹' + total;
    }

    // Validate before submission
    document.getElementById('booking-form').addEventListener('submit', function(e) {
      var courts = document.getElementById('assignedCourts').value;
      if (!courts || courts.trim() === '') {
        e.preventDefault();
        alert('Please select at least one available court to continue.');
      }
    });
  </script>
</body>
</html>
