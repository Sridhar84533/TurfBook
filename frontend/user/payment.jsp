<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.turfbook.model.Booking" %>
<%@ page import="com.turfbook.model.User" %>
<%
    Booking booking = (Booking) request.getAttribute("booking");
    if (booking == null) {
        response.sendRedirect(request.getContextPath() + "/user/booking?action=my-bookings");
        return;
    }
    String error = (String) request.getAttribute("error");
    User currentUser = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Payment • TurfBook Checkout</title>
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
      <a class="flex items-center gap-unit-xs group" href="<%= request.getContextPath() %>/index.jsp">
        <div class="w-9 h-9 rounded-lg bg-primary flex items-center justify-center text-on-primary shadow-sm">
          <span class="material-symbols-outlined text-[22px]">sports_soccer</span>
        </div>
        <span class="font-headline-sm text-headline-sm text-on-surface tracking-tight font-bold">Turf<span class="text-primary">Book</span></span>
      </a>
      <span class="font-label-sm uppercase font-bold text-primary px-3 py-1 rounded-full bg-primary/10">256-Bit SSL Encrypted</span>
    </div>
  </header>

  <main class="w-full pt-16 bg-surface px-unit-md lg:px-unit-xl py-unit-xl min-h-screen">
    <div class="max-w-[1280px] mx-auto flex flex-col w-full pb-unit-3xl">
      


      <!-- Error message -->
      <% if (error != null && !error.isEmpty()) { %>
        <div class="mb-unit-md p-unit-md rounded-xl bg-error-container text-on-error-container flex items-start gap-unit-sm shadow-sm">
          <span class="material-symbols-outlined text-error text-[22px] shrink-0 mt-0.5">error</span>
          <div>
            <span class="font-label-md font-bold block">Payment Alert</span>
            <span class="font-body-sm"><%= error %></span>
          </div>
        </div>
      <% } %>

      <div class="grid grid-cols-1 lg:grid-cols-12 gap-unit-lg items-start">
        
        <!-- Left Column: Payment Form (7 cols) -->
        <div class="lg:col-span-7 flex flex-col gap-unit-lg">
          
          <!-- Squad Split Banner -->
          <div class="bg-gradient-to-r from-surface-container to-surface-container-high p-unit-md rounded-xl shadow-sm flex flex-col sm:flex-row items-start sm:items-center justify-between gap-unit-md border border-outline-variant/30">
            <div class="flex items-center gap-unit-sm">
              <div class="w-11 h-11 rounded-lg bg-surface-container-lowest text-primary flex items-center justify-center shadow-sm">
                <span class="material-symbols-outlined text-[24px]">groups</span>
              </div>
              <div>
                <div class="flex items-center gap-unit-2xs">
                  <span class="font-label-lg font-bold text-on-surface">Split Bill with Squad</span>
                  <span class="bg-primary-fixed text-on-primary-fixed font-label-sm px-2 py-0.5 rounded-full font-bold">10 Players</span>
                </div>
                <p class="font-body-sm text-on-surface-variant">₹<%= (int)(booking.getTotalAmount() / 10) %> per player • Shareable link</p>
              </div>
            </div>
            <button type="button" onclick="alert('Squad split payment link copied to clipboard!');" class="px-unit-md py-1.5 bg-surface-container-lowest text-on-surface font-label-md font-semibold rounded-lg shadow-sm hover:bg-surface-bright flex items-center gap-1">
              <span class="material-symbols-outlined text-primary text-base">share</span>
              <span>Share Link</span>
            </button>
          </div>

          <!-- Razorpay Themed Checkout Container -->
          <div class="bg-surface-container-lowest rounded-2xl shadow-md border border-outline-variant/30 overflow-hidden">
            
            <!-- Razorpay Signature Header -->
            <div class="bg-[#0c2340] text-white p-unit-lg flex flex-col sm:flex-row items-start sm:items-center justify-between gap-unit-md">
              <div class="flex items-center gap-3">
                <div class="w-10 h-10 rounded-xl bg-[#2b64ff] flex items-center justify-center text-white font-bold shadow-sm">
                  <span class="material-symbols-outlined text-[24px]">payments</span>
                </div>
                <div>
                  <div class="flex items-center gap-2">
                    <span class="font-headline-sm font-bold text-white tracking-tight">Razorpay</span>
                    <span class="text-[10px] font-bold uppercase tracking-wider bg-[#2b64ff]/30 text-[#85b6ff] px-2 py-0.5 rounded-full border border-[#2b64ff]/50">Trusted Checkout</span>
                  </div>
                  <p class="text-xs text-slate-300 mt-0.5">TurfBook Sports Arena • Order #RZP-<%= booking.getBookingId() %></p>
                </div>
              </div>
              <div class="text-right self-end sm:self-center">
                <span class="text-[11px] text-slate-300 block uppercase tracking-wider font-semibold">Amount to Pay</span>
                <span class="font-headline-lg font-bold text-[#62df7d]">₹<%= (int) booking.getTotalAmount() %></span>
              </div>
            </div>

            <!-- Razorpay Method Selectors & Content -->
            <form action="<%= request.getContextPath() %>/user/payment" method="POST" id="payForm" onsubmit="return triggerRazorpay(event);" class="p-unit-lg space-y-unit-lg">
              <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>"/>
              <input type="hidden" id="paymentMethod" name="paymentMethod" value="UPI"/>

              <!-- Razorpay Mode Tabs -->
              <div class="grid grid-cols-2 sm:grid-cols-4 gap-2 bg-surface-container-low p-1.5 rounded-xl border border-outline-variant/20">
                <button type="button" class="rzp-tab py-2.5 px-unit-xs rounded-lg font-label-md font-bold bg-white text-[#0c2340] shadow-sm flex items-center justify-center gap-1.5 transition-all text-xs sm:text-sm" onclick="switchRzpTab('UPI', this)">
                  <span class="material-symbols-outlined text-base text-[#2b64ff]">qr_code_2</span>
                  <span>UPI / QR</span>
                </button>
                <button type="button" class="rzp-tab py-2.5 px-unit-xs rounded-lg font-label-md font-medium text-secondary hover:text-on-surface flex items-center justify-center gap-1.5 transition-all text-xs sm:text-sm" onclick="switchRzpTab('CARD', this)">
                  <span class="material-symbols-outlined text-base">credit_card</span>
                  <span>Cards</span>
                </button>
                <button type="button" class="rzp-tab py-2.5 px-unit-xs rounded-lg font-label-md font-medium text-secondary hover:text-on-surface flex items-center justify-center gap-1.5 transition-all text-xs sm:text-sm" onclick="switchRzpTab('NET_BANKING', this)">
                  <span class="material-symbols-outlined text-base">account_balance</span>
                  <span>NetBanking</span>
                </button>
                <button type="button" class="rzp-tab py-2.5 px-unit-xs rounded-lg font-label-md font-medium text-secondary hover:text-on-surface flex items-center justify-center gap-1.5 transition-all text-xs sm:text-sm" onclick="switchRzpTab('CASH', this)">
                  <span class="material-symbols-outlined text-base">storefront</span>
                  <span>Pay on Pitch</span>
                </button>
              </div>

              <!-- Tab 1: UPI / QR Code Box -->
              <div id="rzp-box-upi" class="space-y-unit-md">
                <div class="p-unit-md rounded-2xl bg-surface-container-low/70 border border-outline-variant/30 flex flex-col sm:flex-row items-center gap-unit-lg">
                  <div class="w-36 h-36 bg-white p-2.5 rounded-2xl border-2 border-[#2b64ff]/20 shadow-sm flex flex-col items-center justify-center shrink-0">
                    <img src="https://api.qrserver.com/v1/create-qr-code/?size=120x120&data=upi://pay?pa=turfbook@okhdfcbank%26pn=TurfBook%26am=<%= (int) booking.getTotalAmount() %>%26cu=INR" 
                         alt="UPI QR Code" 
                         onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=120&auto=format&fit=crop&q=80';"
                         class="w-28 h-28 object-contain"/>
                    <span class="text-[9px] font-bold text-secondary tracking-wider mt-0.5">SCAN &amp; PAY</span>
                  </div>
                  <div class="space-y-2 text-center sm:text-left flex-1">
                    <div class="flex items-center justify-center sm:justify-start gap-1.5 text-xs font-bold text-primary">
                      <span class="material-symbols-outlined text-sm">verified</span>
                      <span>Zero Extra Convenience Surcharge</span>
                    </div>
                    <h3 class="font-headline-sm font-bold text-on-surface text-base">Scan with any UPI Application</h3>
                    <p class="text-xs text-secondary">Open Google Pay, PhonePe, Paytm, or BHIM on your mobile phone to scan &amp; approve.</p>
                    <div class="flex flex-wrap items-center justify-center sm:justify-start gap-1.5 pt-1">
                      <span class="px-2 py-0.5 rounded-md bg-white text-[11px] font-semibold text-slate-700 border border-slate-200 shadow-2xs">Google Pay</span>
                      <span class="px-2 py-0.5 rounded-md bg-white text-[11px] font-semibold text-slate-700 border border-slate-200 shadow-2xs">PhonePe</span>
                      <span class="px-2 py-0.5 rounded-md bg-white text-[11px] font-semibold text-slate-700 border border-slate-200 shadow-2xs">Paytm</span>
                      <span class="px-2 py-0.5 rounded-md bg-white text-[11px] font-semibold text-slate-700 border border-slate-200 shadow-2xs">Cred UPI</span>
                    </div>
                  </div>
                </div>

                <div class="space-y-1.5">
                  <label class="font-label-md font-semibold text-on-surface block" for="vpaId">Or Enter Any UPI ID (VPA)</label>
                  <div class="flex items-center gap-2">
                    <input type="text" id="vpaId" placeholder="e.g. striker@okhdfcbank" value="<%= currentUser.getUsername() %>@okhdfcbank"
                           class="flex-1 h-11 px-unit-md bg-surface-container-low rounded-xl font-body-md text-on-surface border border-outline-variant/40 outline-none focus:ring-2 focus:ring-[#2b64ff]"/>
                    <button type="button" onclick="alert('UPI ID verified successfully! Click Pay Now to approve.');" class="h-11 px-unit-md bg-surface-container hover:bg-surface-container-high text-on-surface font-label-md font-bold rounded-xl transition-colors">
                      Verify
                    </button>
                  </div>
                </div>
              </div>

              <!-- Tab 2: Credit / Debit Cards Box -->
              <div id="rzp-box-card" class="space-y-unit-md hidden">
                <div class="p-unit-md rounded-2xl bg-gradient-to-br from-[#0c2340] to-[#1e3a8a] text-white p-unit-md shadow-md space-y-unit-md">
                  <div class="flex items-center justify-between">
                    <span class="text-xs font-mono tracking-wider text-slate-300">TURFBOOK SPORTS PASS CARD</span>
                    <span class="material-symbols-outlined text-amber-300 text-3xl">contactless</span>
                  </div>
                  <div class="font-mono text-lg tracking-widest text-center py-1">
                    4532 •••• •••• 8821
                  </div>
                  <div class="flex items-center justify-between text-xs font-mono">
                    <div>
                      <span class="text-[9px] text-slate-400 block uppercase">Card Holder</span>
                      <span class="font-bold tracking-wide"><%= currentUser.getUsername().toUpperCase() %></span>
                    </div>
                    <div>
                      <span class="text-[9px] text-slate-400 block uppercase">Expires</span>
                      <span class="font-bold">12/28</span>
                    </div>
                  </div>
                </div>

                <div class="space-y-unit-sm">
                  <div class="space-y-1.5">
                    <label class="font-label-sm font-semibold text-on-surface block" for="cardNumber">Card Number</label>
                    <div class="relative flex items-center">
                      <input type="text" id="cardNumber" placeholder="4532 8901 2345 6789" value="4532 8901 2345 6789" maxlength="19"
                             class="w-full h-11 pl-unit-md pr-12 bg-surface-container-low rounded-xl font-mono text-sm text-on-surface border border-outline-variant/40 outline-none focus:ring-2 focus:ring-[#2b64ff]"/>
                      <span class="material-symbols-outlined absolute right-3 text-secondary text-xl">credit_card</span>
                    </div>
                  </div>

                  <div class="grid grid-cols-2 gap-unit-md">
                    <div class="space-y-1.5">
                      <label class="font-label-sm font-semibold text-on-surface block" for="cardExpiry">Valid Thru</label>
                      <input type="text" id="cardExpiry" placeholder="MM / YY" value="12/28" maxlength="5"
                             class="w-full h-11 px-unit-md bg-surface-container-low rounded-xl font-mono text-sm text-on-surface border border-outline-variant/40 outline-none focus:ring-2 focus:ring-[#2b64ff]"/>
                    </div>
                    <div class="space-y-1.5">
                      <label class="font-label-sm font-semibold text-on-surface block" for="cardCvv">CVV / CVC</label>
                      <input type="password" id="cardCvv" placeholder="•••" value="782" maxlength="4"
                             class="w-full h-11 px-unit-md bg-surface-container-low rounded-xl font-mono text-sm text-on-surface border border-outline-variant/40 outline-none focus:ring-2 focus:ring-[#2b64ff]"/>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Tab 3: Net Banking Box -->
              <div id="rzp-box-netbanking" class="space-y-unit-md hidden">
                <span class="font-label-md font-semibold text-on-surface block">Select Your Bank</span>
                <div class="grid grid-cols-2 sm:grid-cols-3 gap-2">
                  <label class="p-3 rounded-xl border border-outline-variant/30 hover:border-[#2b64ff] bg-surface-container-low flex items-center gap-2 cursor-pointer transition-all">
                    <input type="radio" name="bankSelect" checked class="accent-[#2b64ff]"/>
                    <span class="font-semibold text-xs text-on-surface">HDFC Bank</span>
                  </label>
                  <label class="p-3 rounded-xl border border-outline-variant/30 hover:border-[#2b64ff] bg-surface-container-low flex items-center gap-2 cursor-pointer transition-all">
                    <input type="radio" name="bankSelect" class="accent-[#2b64ff]"/>
                    <span class="font-semibold text-xs text-on-surface">State Bank (SBI)</span>
                  </label>
                  <label class="p-3 rounded-xl border border-outline-variant/30 hover:border-[#2b64ff] bg-surface-container-low flex items-center gap-2 cursor-pointer transition-all">
                    <input type="radio" name="bankSelect" class="accent-[#2b64ff]"/>
                    <span class="font-semibold text-xs text-on-surface">ICICI Bank</span>
                  </label>
                  <label class="p-3 rounded-xl border border-outline-variant/30 hover:border-[#2b64ff] bg-surface-container-low flex items-center gap-2 cursor-pointer transition-all">
                    <input type="radio" name="bankSelect" class="accent-[#2b64ff]"/>
                    <span class="font-semibold text-xs text-on-surface">Axis Bank</span>
                  </label>
                  <label class="p-3 rounded-xl border border-outline-variant/30 hover:border-[#2b64ff] bg-surface-container-low flex items-center gap-2 cursor-pointer transition-all">
                    <input type="radio" name="bankSelect" class="accent-[#2b64ff]"/>
                    <span class="font-semibold text-xs text-on-surface">Kotak Bank</span>
                  </label>
                  <label class="p-3 rounded-xl border border-outline-variant/30 hover:border-[#2b64ff] bg-surface-container-low flex items-center gap-2 cursor-pointer transition-all">
                    <input type="radio" name="bankSelect" class="accent-[#2b64ff]"/>
                    <span class="font-semibold text-xs text-on-surface">Other Banks</span>
                  </label>
                </div>
              </div>

              <!-- Tab 4: Cash on Arrival Box -->
              <div id="rzp-box-cash" class="p-unit-md rounded-xl bg-surface-container-low space-y-1.5 hidden">
                <div class="flex items-center gap-2 text-on-surface font-bold text-sm">
                  <span class="material-symbols-outlined text-primary">storefront</span>
                  <span>Pay at Ground Gate Counter</span>
                </div>
                <p class="text-xs text-secondary leading-relaxed">
                  Your time slot will be provisionally reserved in MongoDB. Please settle the match dues in cash or UPI at the turf entry desk before kickoff.
                </p>
              </div>

              <!-- Razorpay Pay Button -->
              <button type="submit" id="rzpSubmitBtn" class="w-full h-13 py-3.5 rounded-xl bg-[#2b64ff] hover:bg-[#1a52e8] text-white font-label-lg font-bold shadow-lg shadow-[#2b64ff]/25 transition-all flex items-center justify-center gap-2 active:scale-[0.99]">
                <span class="material-symbols-outlined text-[20px]">lock</span>
                <span id="rzpBtnText">Pay ₹<%= (int) booking.getTotalAmount() %> via Razorpay</span>
              </button>

              <div class="flex items-center justify-center gap-2 text-xs text-secondary pt-1">
                <span class="material-symbols-outlined text-sm text-[#2b64ff]">verified_user</span>
                <span>PCI-DSS Level 1 Compliant • 256-Bit Bank Grade Encryption</span>
              </div>
            </form>

          </div>

        </div>

        <!-- Right Column: Booking Summary & GPS Preview (5 cols) -->
        <div class="lg:col-span-5">
          <div class="bg-surface-container-lowest rounded-xl shadow-sm p-unit-lg border border-outline-variant/30 space-y-unit-md sticky top-20">
            <h3 class="font-headline-sm font-bold text-on-surface border-b border-outline-variant/20 pb-unit-sm">Reservation Summary</h3>
            
            <div class="space-y-unit-sm">
              <div class="flex justify-between">
                <span class="text-secondary font-body-sm">Booking ID:</span>
                <span class="font-mono font-bold text-on-surface text-sm"><%= booking.getBookingId() %></span>
              </div>
              <div class="flex justify-between">
                <span class="text-secondary font-body-sm">Arena:</span>
                <span class="font-semibold text-on-surface text-sm"><%= booking.getTurfName() != null ? booking.getTurfName() : booking.getTurfId() %></span>
              </div>
              <div class="flex justify-between">
                <span class="text-secondary font-body-sm">Match Date:</span>
                <span class="font-semibold text-on-surface text-sm"><%= booking.getBookingDate() %></span>
              </div>
              <div class="flex justify-between">
                <span class="text-secondary font-body-sm">Match Slot:</span>
                <span class="font-mono font-bold text-primary text-sm"><%= booking.getStartTime() %> – <%= booking.getEndTime() %></span>
              </div>
              <% if (booking.getCourtCount() > 0) { %>
              <div class="flex justify-between items-center">
                <span class="text-secondary font-body-sm">Courts:</span>
                <span class="inline-flex items-center gap-1 px-2 py-0.5 rounded-md bg-blue-100 text-blue-800 text-xs font-bold">
                  🏸 <%= booking.getCourtsDisplay() %> (<%= booking.getCourtCount() %> <%= booking.getCourtCount() == 1 ? "Court" : "Courts" %>)
                </span>
              </div>
              <% } %>
            </div>

            <!-- GPS Location Preview -->
            <div class="p-3 rounded-xl bg-surface-container-low border border-outline-variant/20 flex items-center justify-between gap-2">
              <div class="flex items-center gap-2 truncate">
                <span class="material-symbols-outlined text-[#1a73e8] text-xl shrink-0">location_on</span>
                <div class="truncate text-xs">
                  <span class="font-bold text-on-surface block truncate"><%= booking.getTurfName() != null ? booking.getTurfName() : "Turf Arena" %></span>
                  <span class="text-secondary truncate block"><%= booking.getTurfLocation() != null ? booking.getTurfLocation() : "Bengaluru" %></span>
                </div>
              </div>
              <a href="https://www.google.com/maps/search/?api=1&query=<%= java.net.URLEncoder.encode((booking.getTurfName() != null ? booking.getTurfName() : "Turf") + " " + (booking.getTurfLocation() != null ? booking.getTurfLocation() : "Bengaluru"), "UTF-8") %>" target="_blank" class="px-2.5 py-1.5 rounded-lg bg-[#1a73e8]/10 hover:bg-[#1a73e8]/20 text-[#1a73e8] text-xs font-bold shrink-0 transition-colors flex items-center gap-1" title="Preview Pitch on Google Maps">
                <span class="material-symbols-outlined text-xs">near_me</span>
                <span>GPS</span>
              </a>
            </div>

            <div class="border-t border-outline-variant/20 pt-unit-sm space-y-2">
              <div class="flex justify-between text-body-sm">
                <span class="text-secondary">Pitch Charges</span>
                <span class="font-semibold text-on-surface">₹<%= (int) booking.getTotalAmount() %></span>
              </div>
              <div class="flex justify-between text-body-sm">
                <span class="text-secondary">Convenience Fee</span>
                <span class="text-primary font-semibold">FREE (₹0)</span>
              </div>
              <div class="flex justify-between items-baseline pt-2 border-t border-outline-variant/30">
                <span class="font-label-lg font-bold text-on-surface">Total Amount</span>
                <span class="font-headline-sm font-bold text-primary">₹<%= (int) booking.getTotalAmount() %></span>
              </div>
            </div>

            <div class="p-2.5 rounded-lg bg-surface-container-low text-[11px] text-secondary">
              🔒 Simulated Razorpay Gateway • MongoDB Real-Time Sync
            </div>

          </div>
        </div>

      </div>

    </div>
  </main>

  <!-- Razorpay Simulation Modal Overlay -->
  <div id="rzpModal" class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm hidden flex items-center justify-center p-4 animate-fade-in">
    <div class="w-full max-w-md bg-white rounded-2xl shadow-2xl overflow-hidden border border-slate-200">
      <!-- Modal Header -->
      <div class="bg-[#0c2340] text-white p-5 flex items-center justify-between">
        <div class="flex items-center gap-2.5">
          <div class="w-8 h-8 rounded-lg bg-[#2b64ff] flex items-center justify-center font-bold text-white text-sm">
            R
          </div>
          <div>
            <div class="flex items-center gap-1.5">
              <span class="font-bold text-white tracking-tight">Razorpay Checkout</span>
              <span class="text-[9px] bg-emerald-500/20 text-emerald-300 px-1.5 py-0.2 rounded font-bold">SANDBOX</span>
            </div>
            <span class="text-xs text-slate-300">Merchant: TurfBook Arena Ltd</span>
          </div>
        </div>
        <div class="text-right">
          <span class="text-sm font-bold text-[#62df7d]">₹<%= (int) booking.getTotalAmount() %></span>
        </div>
      </div>

      <!-- Modal Body -->
      <div class="p-6 text-center space-y-4">
        <div class="w-16 h-16 mx-auto rounded-full bg-blue-50 border-4 border-blue-100 flex items-center justify-center">
          <svg class="animate-spin h-8 w-8 text-[#2b64ff]" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"></path>
          </svg>
        </div>

        <div>
          <h4 id="rzpStatusTitle" class="font-bold text-slate-800 text-lg">Authorizing Payment...</h4>
          <p id="rzpStatusDesc" class="text-xs text-slate-500 mt-1">Connecting to simulated banking network. Please do not close or reload.</p>
        </div>

        <div class="w-full bg-slate-100 rounded-full h-1.5 overflow-hidden">
          <div id="rzpProgressBar" class="bg-[#2b64ff] h-1.5 w-1/3 transition-all duration-700"></div>
        </div>

        <div class="text-[11px] text-slate-400 font-mono">
          Ref: TB-<%= booking.getBookingId() %> • Razorpay 256-Bit SSL
        </div>
      </div>
    </div>
  </div>

  <script>
    function switchRzpTab(method, btn) {
      document.getElementById('paymentMethod').value = method;
      
      // Update tab styles
      document.querySelectorAll('.rzp-tab').forEach(b => {
        b.className = 'rzp-tab py-2.5 px-unit-xs rounded-lg font-label-md font-medium text-secondary hover:text-on-surface flex items-center justify-center gap-1.5 transition-all text-xs sm:text-sm';
      });
      btn.className = 'rzp-tab py-2.5 px-unit-xs rounded-lg font-label-md font-bold bg-white text-[#0c2340] shadow-sm flex items-center justify-center gap-1.5 transition-all text-xs sm:text-sm';

      // Toggle views
      document.getElementById('rzp-box-upi').classList.add('hidden');
      document.getElementById('rzp-box-card').classList.add('hidden');
      document.getElementById('rzp-box-netbanking').classList.add('hidden');
      document.getElementById('rzp-box-cash').classList.add('hidden');

      if (method === 'UPI') {
        document.getElementById('rzp-box-upi').classList.remove('hidden');
        document.getElementById('rzpBtnText').innerText = 'Pay ₹<%= (int) booking.getTotalAmount() %> via Razorpay UPI';
      } else if (method === 'CARD') {
        document.getElementById('rzp-box-card').classList.remove('hidden');
        document.getElementById('rzpBtnText').innerText = 'Pay ₹<%= (int) booking.getTotalAmount() %> via Card';
      } else if (method === 'NET_BANKING') {
        document.getElementById('rzp-box-netbanking').classList.remove('hidden');
        document.getElementById('rzpBtnText').innerText = 'Pay ₹<%= (int) booking.getTotalAmount() %> via NetBanking';
      } else if (method === 'CASH') {
        document.getElementById('rzp-box-cash').classList.remove('hidden');
        document.getElementById('rzpBtnText').innerText = 'Confirm Reservation (Pay on Pitch)';
      }
    }

    var rzpTriggered = false;
    function triggerRazorpay(e) {
      if (rzpTriggered) return true;
      e.preventDefault();

      var modal = document.getElementById('rzpModal');
      modal.classList.remove('hidden');

      var bar = document.getElementById('rzpProgressBar');
      var title = document.getElementById('rzpStatusTitle');
      var desc = document.getElementById('rzpStatusDesc');

      setTimeout(function() {
        bar.style.width = '70%';
        title.innerText = 'Simulating 3D Secure / Bank Approval...';
        desc.innerText = 'Validating payment token with Razorpay gateway.';
      }, 600);

      setTimeout(function() {
        bar.style.width = '100%';
        title.innerText = 'Payment Approved!';
        desc.innerText = 'Redirecting to your digital pitch pass...';
      }, 1200);

      setTimeout(function() {
        rzpTriggered = true;
        document.getElementById('payForm').submit();
      }, 1600);

      return false;
    }
  </script>
  <script src="<%= request.getContextPath() %>/js/app.js"></script>
</body>
</html>
