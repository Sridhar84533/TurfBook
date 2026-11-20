<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.turfbook.model.Turf" %>
<%@ page import="com.turfbook.model.User" %>
<%@ page import="com.turfbook.service.TurfService" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
    Turf turf = (Turf) request.getAttribute("turf");
    String error = (String) request.getAttribute("error");
    User currentUser = (User) session.getAttribute("user");
    TurfService turfService = new TurfService();
    List<Turf> allTurfs = turfService.getAllActiveTurfs();

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String today = sdf.format(new Date());
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Book Turf Slot • TurfBook</title>
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
          <a class="px-unit-sm py-unit-xs text-on-surface-variant hover:text-on-surface transition-colors font-label-lg rounded-lg" href="<%= request.getContextPath() %>/user/booking?action=my-bookings">My Bookings</a>
        </nav>
      </div>
      <div class="flex items-center gap-unit-sm">
        <% if (currentUser != null) { %>
          <div class="flex items-center gap-unit-xs">
            <span class="font-label-md font-semibold text-on-surface"><%= currentUser.getUsername() %></span>
            <a href="<%= request.getContextPath() %>/logout" class="p-1.5 text-on-surface-variant hover:text-error">
              <span class="material-symbols-outlined text-[20px]">logout</span>
            </a>
          </div>
        <% } %>
      </div>
    </div>
  </header>

  <main class="w-full pt-16 bg-surface px-unit-md lg:px-unit-xl py-unit-xl min-h-screen">
    <div class="max-w-[800px] mx-auto flex flex-col w-full pb-unit-3xl">
      
      <!-- Connected 5-Step Progress Pipeline -->
      <div class="bg-surface-container-lowest p-unit-md rounded-2xl shadow-sm border border-outline-variant/30 mb-unit-lg">
        <div class="booking-pipeline">
          <div class="step-node active">
            <div class="step-dot">01</div>
            <span class="font-label-sm font-bold text-primary">DATE</span>
          </div>
          <div class="step-connector filled"></div>
          <div class="step-node active">
            <div class="step-dot">02</div>
            <span class="font-label-sm font-bold text-primary">TIME</span>
          </div>
          <div class="step-connector"></div>
          <div class="step-node">
            <div class="step-dot">03</div>
            <span class="font-label-sm text-secondary">REVIEW</span>
          </div>
          <div class="step-connector"></div>
          <div class="step-node">
            <div class="step-dot">04</div>
            <span class="font-label-sm text-secondary">PAYMENT</span>
          </div>
          <div class="step-connector"></div>
          <div class="step-node">
            <div class="step-dot">05</div>
            <span class="font-label-sm text-secondary">CONFIRMED</span>
          </div>
        </div>
      </div>

      <!-- Error Alert -->
      <% if (error != null && !error.isEmpty()) { %>
        <div class="mb-unit-md p-unit-md rounded-xl bg-error-container text-on-error-container flex items-start gap-unit-sm shadow-sm">
          <span class="material-symbols-outlined text-error text-[22px] shrink-0 mt-0.5">error</span>
          <div>
            <span class="font-label-md font-bold block">Booking Notice</span>
            <span class="font-body-sm"><%= error %></span>
          </div>
        </div>
      <% } %>

      <!-- Booking Card -->
      <div class="bg-surface-container-lowest rounded-2xl p-unit-lg sm:p-unit-xl shadow-md border border-outline-variant/30">
        <h1 class="font-headline-lg font-bold text-on-surface mb-unit-xs">Reserve Match Pitch</h1>
        <p class="font-body-md text-secondary mb-unit-lg">Choose your arena, date, and preferred match slot.</p>

        <form action="<%= request.getContextPath() %>/user/booking" method="POST" class="space-y-unit-lg">
          
          <!-- Turf Selection -->
          <div class="space-y-1.5">
            <label class="font-label-md font-semibold text-on-surface block" for="turfId">Select Arena</label>
            <div class="relative">
              <select name="turfId" id="turfId" required class="w-full h-12 px-unit-md bg-surface-container-low rounded-xl font-body-md text-on-surface border border-outline-variant/40 outline-none appearance-none focus:ring-2 focus:ring-primary">
                <% if (turf != null) { %>
                  <option value="<%= turf.getTurfId() %>" selected><%= turf.getTurfName() %> (<%= turf.getCity() %>) - ₹<%= (int) turf.getPricePerHour() %>/hr</option>
                <% } else { %>
                  <option value="">-- Choose a Ground --</option>
                <% } %>
                <% if (allTurfs != null) { %>
                  <% for (Turf t : allTurfs) { %>
                    <% if (turf == null || !t.getTurfId().equals(turf.getTurfId())) { %>
                      <option value="<%= t.getTurfId() %>"><%= t.getTurfName() %> (<%= t.getCity() %>) - ₹<%= (int) t.getPricePerHour() %>/hr</option>
                    <% } %>
                  <% } %>
                <% } %>
              </select>
              <span class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 text-secondary pointer-events-none">unfold_more</span>
            </div>
          </div>

          <!-- Date Picker -->
          <div class="space-y-1.5">
            <label class="font-label-md font-semibold text-on-surface block" for="bookingDate">Match Date</label>
            <input type="date" name="bookingDate" id="bookingDate" value="<%= today %>" min="<%= today %>" required
                   class="w-full h-12 px-unit-md bg-surface-container-low rounded-xl font-body-md text-on-surface border border-outline-variant/40 outline-none focus:ring-2 focus:ring-primary"/>
          </div>

          <!-- Time Slot Selection -->
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-unit-md">
            <div class="space-y-1.5">
              <label class="font-label-md font-semibold text-on-surface block" for="startTime">Start Time</label>
              <select name="startTime" id="startTime" required class="w-full h-12 px-unit-md bg-surface-container-low rounded-xl font-body-md text-on-surface border border-outline-variant/40 outline-none focus:ring-2 focus:ring-primary">
                <option value="06:00">06:00 AM</option>
                <option value="07:00">07:00 AM</option>
                <option value="08:00">08:00 AM</option>
                <option value="09:00">09:00 AM</option>
                <option value="16:00">04:00 PM</option>
                <option value="17:00">05:00 PM</option>
                <option value="18:00">06:00 PM</option>
                <option value="19:00" selected>07:00 PM</option>
                <option value="20:00">08:00 PM</option>
                <option value="21:00">09:00 PM</option>
                <option value="22:00">10:00 PM</option>
              </select>
            </div>

            <div class="space-y-1.5">
              <label class="font-label-md font-semibold text-on-surface block" for="endTime">End Time</label>
              <select name="endTime" id="endTime" required class="w-full h-12 px-unit-md bg-surface-container-low rounded-xl font-body-md text-on-surface border border-outline-variant/40 outline-none focus:ring-2 focus:ring-primary">
                <option value="07:00">07:00 AM</option>
                <option value="08:00">08:00 AM</option>
                <option value="09:00">09:00 AM</option>
                <option value="10:00">10:00 AM</option>
                <option value="17:00">05:00 PM</option>
                <option value="18:00">06:00 PM</option>
                <option value="19:00">07:00 PM</option>
                <option value="20:00" selected>08:00 PM</option>
                <option value="21:00">09:00 PM</option>
                <option value="22:00">10:00 PM</option>
                <option value="23:00">11:00 PM</option>
              </select>
            </div>
          </div>

          <div class="p-unit-md rounded-xl bg-surface-container-low flex items-center justify-between text-body-sm">
            <span class="text-secondary font-medium">Auto Price Calculation</span>
            <span class="text-primary font-bold">Rates calculated server-side per hour</span>
          </div>

          <!-- Submit Button -->
          <button type="submit" class="w-full h-12 rounded-xl bg-primary hover:bg-primary-container text-on-primary font-label-lg font-bold shadow-md transition-all flex items-center justify-center gap-2 active:scale-[0.99]">
            <span class="material-symbols-outlined text-[20px]">payments</span>
            <span>Proceed to Payment</span>
          </button>
        </form>

      </div>

    </div>
  </main>
  <script src="<%= request.getContextPath() %>/js/app.js"></script>
</body>
</html>
