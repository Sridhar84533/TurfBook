<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.turfbook.model.Booking" %>
<%@ page import="com.turfbook.model.User" %>
<%@ page import="java.util.List" %>
<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    User currentUser = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>My Bookings • TurfBook</title>
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
          <a class="px-unit-sm py-unit-xs bg-primary-container text-on-primary-container font-semibold rounded-lg" href="<%= request.getContextPath() %>/user/booking?action=my-bookings">My Bookings</a>
        </nav>
      </div>

      <div class="flex items-center gap-unit-sm">
        <% if (currentUser != null) { %>
          <a href="<%= "ADMIN".equals(currentUser.getRole().name()) ? request.getContextPath() + "/admin/dashboard" : request.getContextPath() + "/user/dashboard.jsp" %>" class="flex items-center gap-unit-xs pl-unit-xs py-unit-2xs pr-unit-sm rounded-full bg-surface-container-low border border-outline-variant/40 hover:bg-surface-container-high transition-colors">
            <div class="w-8 h-8 rounded-full bg-primary text-on-primary font-bold flex items-center justify-center text-xs">
              <%= currentUser.getUsername().substring(0, 1).toUpperCase() %>
            </div>
            <span class="hidden md:inline-block font-label-md text-on-surface font-semibold"><%= currentUser.getUsername() %></span>
          </a>
          <a href="<%= request.getContextPath() %>/logout" class="p-2 text-on-surface-variant hover:text-error transition-colors" title="Sign Out">
            <span class="material-symbols-outlined text-[20px]">logout</span>
          </a>
        <% } %>
      </div>
    </div>
  </header>

  <main class="w-full pt-16 bg-surface px-unit-md lg:px-unit-xl py-unit-xl min-h-screen">
    <div class="max-w-[1280px] mx-auto flex flex-col w-full pb-unit-3xl">
      
      <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-unit-md mb-unit-xl">
        <div>
          <span class="font-label-sm uppercase tracking-wider text-primary font-bold">Player Manifest</span>
          <h1 class="font-headline-xl font-bold text-on-surface">My Match Bookings</h1>
        </div>
        <a href="<%= request.getContextPath() %>/turfs" class="px-unit-lg py-2.5 bg-primary hover:bg-primary-container text-on-primary font-label-md font-bold rounded-xl shadow-md transition-all flex items-center gap-1.5">
          <span class="material-symbols-outlined text-base">sports_soccer</span>
          <span>Book New Match</span>
        </a>
      </div>

      <!-- Bookings List -->
      <% if (bookings != null && !bookings.isEmpty()) { %>
        <div class="space-y-unit-md">
          <% for (Booking b : bookings) { %>
            <div class="bg-surface-container-lowest rounded-2xl p-unit-lg shadow-sm border border-outline-variant/30 flex flex-col md:flex-row items-start md:items-center justify-between gap-unit-md hover:shadow-md transition-shadow">
              
              <div class="space-y-1">
                <div class="flex items-center gap-unit-xs">
                  <span class="font-mono text-xs font-bold text-secondary uppercase bg-surface-container px-2 py-0.5 rounded">
                    <%= b.getBookingId() %>
                  </span>
                  <% if (b.getCheckInStatus() == com.turfbook.enums.CheckInStatus.CHECKED_IN) { %>
                    <span class="bg-blue-100 text-blue-800 text-xs font-bold px-2.5 py-0.5 rounded-full flex items-center gap-1">
                      <span class="material-symbols-outlined text-xs">done_all</span>
                      Checked In
                    </span>
                  <% } else if (b.isExpired() || "EXPIRED".equals(b.getStatus().name())) { %>
                    <span class="bg-slate-100 text-slate-700 border border-slate-300 text-xs font-bold px-2.5 py-0.5 rounded-full flex items-center gap-1">
                      <span class="material-symbols-outlined text-xs text-amber-600">history</span>
                      Expired
                    </span>
                  <% } else if ("CONFIRMED".equals(b.getStatus().name())) { %>
                    <span class="bg-green-100 text-green-800 text-xs font-bold px-2.5 py-0.5 rounded-full flex items-center gap-1">
                      <span class="material-symbols-outlined text-xs">check_circle</span>
                      Confirmed
                    </span>
                  <% } else if ("PENDING".equals(b.getStatus().name())) { %>
                    <span class="bg-amber-100 text-amber-800 text-xs font-bold px-2.5 py-0.5 rounded-full flex items-center gap-1">
                      <span class="material-symbols-outlined text-xs">pending</span>
                      Pending Payment
                    </span>
                  <% } else { %>
                    <span class="bg-red-100 text-red-800 text-xs font-bold px-2.5 py-0.5 rounded-full">
                      <%= b.getStatus().name() %>
                    </span>
                  <% } %>
                  <% if (b.getCourtCount() > 0) { %>
                    <span class="bg-blue-100 text-blue-800 text-xs font-bold px-2.5 py-0.5 rounded-full flex items-center gap-1">
                      <span>🏸 <%= b.getCourtsDisplay() %></span>
                    </span>
                  <% } %>
                </div>

                <h2 class="font-headline-sm font-bold text-on-surface">
                  <%= b.getTurfName() != null ? b.getTurfName() : b.getTurfId() %>
                </h2>
                
                <div class="flex flex-wrap items-center gap-x-unit-md gap-y-1 text-body-sm text-secondary pt-1">
                  <span class="flex items-center gap-1">
                    <span class="material-symbols-outlined text-xs text-primary">calendar_month</span>
                    <%= b.getBookingDate() %>
                  </span>
                  <span>•</span>
                  <span class="flex items-center gap-1 font-mono font-semibold text-primary">
                    <span class="material-symbols-outlined text-xs">schedule</span>
                    <%= b.getStartTime() %> – <%= b.getEndTime() %>
                  </span>
                  <span>•</span>
                  <span>₹<%= (int) b.getTotalAmount() %></span>
                  <span>•</span>
                  <a href="https://www.google.com/maps/search/?api=1&query=<%= java.net.URLEncoder.encode((b.getTurfName() != null ? b.getTurfName() : "Turf") + " " + (b.getTurfLocation() != null ? b.getTurfLocation() : "Bengaluru"), "UTF-8") %>" target="_blank" class="inline-flex items-center gap-1 text-xs font-semibold text-[#1a73e8] hover:underline" title="Navigate to pitch on Google Maps">
                    <span class="material-symbols-outlined text-[15px]">near_me</span>
                    <span>GPS Map</span>
                  </a>
                </div>
              </div>

              <div class="flex flex-wrap items-center gap-unit-xs self-start md:self-center mt-2 md:mt-0">
                <% if ("PENDING".equals(b.getStatus().name())) { %>
                  <a href="<%= request.getContextPath() %>/user/payment?bookingId=<%= b.getBookingId() %>" class="px-unit-md py-2 bg-amber-500 hover:bg-amber-600 text-white font-label-sm font-bold rounded-lg transition-colors">
                    Complete Pay
                  </a>
                <% } %>
                <a href="<%= request.getContextPath() %>/user/booking?action=details&id=<%= b.getBookingId() %>" class="px-unit-md py-2 bg-primary hover:bg-primary-container text-on-primary font-label-sm font-bold rounded-lg transition-colors flex items-center gap-1 shadow-sm">
                  <span class="material-symbols-outlined text-base">qr_code_2</span>
                  <span>Booking Pass</span>
                </a>
                <a href="<%= request.getContextPath() %>/user/booking?action=details&id=<%= b.getBookingId() %>&print=true" target="_blank" class="p-2 rounded-lg bg-surface-container hover:bg-surface-container-high text-on-surface transition-colors" title="Print Pass / PDF">
                  <span class="material-symbols-outlined text-base">print</span>
                </a>
                <a href="https://www.google.com/maps/search/?api=1&query=<%= java.net.URLEncoder.encode((b.getTurfName() != null ? b.getTurfName() : "Turf") + " " + (b.getTurfLocation() != null ? b.getTurfLocation() : "Bengaluru"), "UTF-8") %>" target="_blank" class="p-2 rounded-lg bg-surface-container hover:bg-surface-container-high text-[#1a73e8] transition-colors" title="Open Google Maps GPS">
                  <span class="material-symbols-outlined text-base">near_me</span>
                </a>
              </div>

            </div>
          <% } %>
        </div>
      <% } else { %>
        <div class="text-center py-unit-3xl bg-surface-container-lowest rounded-2xl border border-outline-variant/30">
          <span class="material-symbols-outlined text-5xl text-outline mb-2">sports_soccer</span>
          <h3 class="font-headline-sm font-bold text-on-surface">No Match Bookings Yet</h3>
          <p class="font-body-md text-secondary mt-1 max-w-sm mx-auto">Lock in your first floodlit arena slot and take the field with your squad.</p>
          <a href="<%= request.getContextPath() %>/turfs" class="mt-unit-md inline-flex items-center gap-1.5 px-unit-lg py-2.5 bg-primary text-on-primary font-label-md font-bold rounded-xl shadow-md">
            <span>Explore Arenas</span>
            <span class="material-symbols-outlined text-base">arrow_forward</span>
          </a>
        </div>
      <% } %>

    </div>
  </main>
  <script src="<%= request.getContextPath() %>/js/app.js"></script>
</body>
</html>
