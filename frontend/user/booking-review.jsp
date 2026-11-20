<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.turfbook.model.Booking" %>
<%@ page import="com.turfbook.model.User" %>
<%
    Booking booking = (Booking) session.getAttribute("pendingBooking");
    if (booking == null) {
        String bookingId = request.getParameter("bookingId");
        if (bookingId != null) {
            response.sendRedirect(request.getContextPath() + "/user/payment?bookingId=" + bookingId);
            return;
        }
        response.sendRedirect(request.getContextPath() + "/user/booking?action=my-bookings");
        return;
    }
    User currentUser = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Review Booking • TurfBook</title>
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
      <a href="<%= request.getContextPath() %>/turfs" class="font-label-md font-semibold text-on-surface-variant hover:text-primary transition-colors flex items-center gap-1">
        <span class="material-symbols-outlined text-base">swap_horiz</span>
        <span>Change Slot</span>
      </a>
    </div>
  </header>

  <main class="w-full pt-16 bg-surface min-h-screen flex items-start justify-center py-unit-xl px-unit-md">
    <div class="w-full max-w-[560px]">
      
      <!-- 5-Step Booking Pipeline -->
      <div class="booking-pipeline mb-unit-xl stagger-up">
        <div class="step-node completed">
          <div class="step-dot"><span class="material-symbols-outlined text-sm" style="font-variation-settings: 'FILL' 1;">check</span></div>
          <span class="text-xs font-semibold text-secondary">Search</span>
        </div>
        <div class="step-connector filled"></div>
        <div class="step-node completed">
          <div class="step-dot"><span class="material-symbols-outlined text-sm" style="font-variation-settings: 'FILL' 1;">check</span></div>
          <span class="text-xs font-semibold text-secondary">Choose</span>
        </div>
        <div class="step-connector filled"></div>
        <div class="step-node active">
          <div class="step-dot">3</div>
          <span class="text-xs font-bold text-on-surface">Review</span>
        </div>
        <div class="step-connector"></div>
        <div class="step-node">
          <div class="step-dot">4</div>
          <span class="text-xs font-semibold text-secondary">Pay</span>
        </div>
        <div class="step-connector"></div>
        <div class="step-node">
          <div class="step-dot">5</div>
          <span class="text-xs font-semibold text-secondary">Pass</span>
        </div>
      </div>

      <!-- Booking Review Card -->
      <div class="bg-surface-container-lowest rounded-2xl shadow-xl border border-outline-variant/30 overflow-hidden stagger-up" data-delay="0.15s">
        
        <!-- Card Header -->
        <div class="bg-[#0b1c30] px-unit-xl py-unit-lg text-white">
          <div class="flex items-center gap-unit-sm">
            <div class="w-10 h-10 rounded-xl bg-primary/20 text-primary-fixed flex items-center justify-center">
              <span class="material-symbols-outlined text-xl">event_seat</span>
            </div>
            <div>
              <p class="text-xs text-slate-400 uppercase font-semibold tracking-wider">Step 3 of 5</p>
              <h1 class="font-display font-bold text-white text-xl">Review Match Slot</h1>
            </div>
          </div>
        </div>

        <!-- Booking Details Body -->
        <div class="p-unit-lg sm:p-unit-xl space-y-unit-md">

          <p class="font-body-sm text-secondary">Confirm your arena and match timing before proceeding to secure payment.</p>

          <!-- Booking Info Table -->
          <div class="rounded-xl bg-surface-container-low border border-outline-variant/20 overflow-hidden">
            <div class="divide-y divide-outline-variant/20">
              <div class="flex items-center justify-between px-unit-md py-unit-sm">
                <span class="text-xs text-secondary uppercase font-semibold tracking-wide flex items-center gap-1">
                  <span class="material-symbols-outlined text-xs">confirmation_number</span> Booking ID
                </span>
                <span class="font-mono font-bold text-on-surface text-sm"><%= booking.getBookingId() %></span>
              </div>
              <div class="flex items-center justify-between px-unit-md py-unit-sm">
                <span class="text-xs text-secondary uppercase font-semibold tracking-wide flex items-center gap-1">
                  <span class="material-symbols-outlined text-xs">stadium</span> Arena Name
                </span>
                <span class="font-bold text-on-surface"><%= booking.getTurfName() != null ? booking.getTurfName() : booking.getTurfId() %></span>
              </div>
              <div class="flex items-center justify-between px-unit-md py-unit-sm">
                <span class="text-xs text-secondary uppercase font-semibold tracking-wide flex items-center gap-1">
                  <span class="material-symbols-outlined text-xs">calendar_month</span> Match Date
                </span>
                <span class="font-semibold text-on-surface"><%= booking.getBookingDate() %></span>
              </div>
              <div class="flex items-center justify-between px-unit-md py-unit-sm">
                <span class="text-xs text-secondary uppercase font-semibold tracking-wide flex items-center gap-1">
                  <span class="material-symbols-outlined text-xs">schedule</span> Time Slot
                </span>
                <span class="font-mono font-bold text-primary"><%= booking.getStartTime() %> – <%= booking.getEndTime() %></span>
              </div>
              <div class="flex items-center justify-between px-unit-md py-unit-md bg-surface-container">
                <span class="font-label-lg font-bold text-on-surface flex items-center gap-1">
                  <span class="material-symbols-outlined text-base text-primary">currency_rupee</span> Total Due
                </span>
                <span class="font-display font-black text-primary text-xl">₹<%= (int) booking.getTotalAmount() %></span>
              </div>
            </div>
          </div>

          <!-- Trust Badges -->
          <div class="grid grid-cols-3 gap-unit-xs">
            <div class="text-center p-unit-xs rounded-xl bg-surface-container-low border border-outline-variant/20">
              <span class="material-symbols-outlined text-lg text-primary block mb-0.5" style="font-variation-settings: 'FILL' 1;">lock</span>
              <p class="text-[11px] text-secondary font-semibold">Secure Pay</p>
            </div>
            <div class="text-center p-unit-xs rounded-xl bg-surface-container-low border border-outline-variant/20">
              <span class="material-symbols-outlined text-lg text-primary block mb-0.5" style="font-variation-settings: 'FILL' 1;">bolt</span>
              <p class="text-[11px] text-secondary font-semibold">Instant Pass</p>
            </div>
            <div class="text-center p-unit-xs rounded-xl bg-surface-container-low border border-outline-variant/20">
              <span class="material-symbols-outlined text-lg text-primary block mb-0.5" style="font-variation-settings: 'FILL' 1;">qr_code</span>
              <p class="text-[11px] text-secondary font-semibold">QR Entry</p>
            </div>
          </div>

          <!-- Action Buttons -->
          <div class="flex items-center gap-unit-md pt-unit-xs">
            <a href="<%= request.getContextPath() %>/turfs" class="flex-1 py-3 bg-surface-container text-on-surface font-label-md font-bold rounded-xl text-center hover:bg-surface-container-high transition-colors">
              Cancel
            </a>
            <a href="<%= request.getContextPath() %>/user/payment?bookingId=<%= booking.getBookingId() %>" class="flex-1 py-3 bg-primary hover:bg-primary-container text-on-primary font-label-md font-bold rounded-xl text-center shadow-lg transition-all btn-magnetic flex items-center justify-center gap-1">
              <span>Proceed to Pay</span>
              <span class="material-symbols-outlined text-base">arrow_forward</span>
            </a>
          </div>
          
          <p class="text-center text-xs text-secondary">Protected by Razorpay 256-bit TLS encryption</p>
        </div>
      </div>

    </div>
  </main>

  <script src="<%= request.getContextPath() %>/js/app.js"></script>
</body>
</html>
