<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.turfbook.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Player Profile • TurfBook</title>
  <meta name="description" content="View and manage your TurfBook player profile, bookings, and account settings."/>
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
      <div class="flex items-center gap-unit-sm">
        <a href="<%= request.getContextPath() %>/turfs" class="px-unit-sm py-unit-xs text-on-surface-variant hover:text-on-surface font-label-lg transition-colors">Explore Turfs</a>
        <a href="<%= request.getContextPath() %>/user/dashboard.jsp" class="px-unit-sm py-unit-xs text-on-surface-variant hover:text-on-surface font-label-lg transition-colors">Dashboard</a>
        <a href="<%= request.getContextPath() %>/logout" class="p-2 text-on-surface-variant hover:text-error transition-colors" title="Sign Out">
          <span class="material-symbols-outlined text-[20px]">logout</span>
        </a>
      </div>
    </div>
  </header>

  <main class="w-full pt-16 bg-surface min-h-screen">
    <div class="max-w-[800px] mx-auto px-unit-md lg:px-0 py-unit-xl pb-unit-3xl">
      
      <!-- Page Header -->
      <div class="mb-unit-xl stagger-up">
        <span class="font-label-sm uppercase tracking-wider text-primary font-bold">Account</span>
        <h1 class="font-display font-extrabold text-on-surface text-3xl sm:text-4xl mt-1">Player Profile</h1>
        <p class="font-body-md text-secondary mt-1">Your TurfBook player identity and account details.</p>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-unit-lg">
        
        <!-- Profile Card (left column on large) -->
        <div class="lg:col-span-1 stagger-up" data-delay="0.1s">
          <div class="bg-surface-container-lowest rounded-2xl p-unit-xl shadow-md border border-outline-variant/30 flex flex-col items-center text-center gap-unit-md">
            <!-- Avatar -->
            <div class="relative">
              <div class="w-24 h-24 rounded-full bg-primary text-on-primary font-extrabold text-4xl flex items-center justify-center shadow-xl ring-4 ring-primary/20">
                <%= currentUser.getUsername().substring(0, 1).toUpperCase() %>
              </div>
              <div class="absolute bottom-0 right-0 w-8 h-8 rounded-full bg-surface-container-lowest border-2 border-outline-variant/30 flex items-center justify-center shadow-sm">
                <span class="material-symbols-outlined text-[16px] text-primary">verified</span>
              </div>
            </div>
            
            <div>
              <h2 class="font-display font-bold text-on-surface text-xl"><%= currentUser.getUsername() %></h2>
              <p class="font-body-sm text-secondary mt-0.5"><%= currentUser.getEmail() %></p>
              <span class="mt-2 inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-bold uppercase tracking-wider
                <%= "ADMIN".equals(currentUser.getRole().name()) ? "bg-amber-100 text-amber-700" : "bg-primary/10 text-primary" %>">
                <span class="material-symbols-outlined text-xs"><%= "ADMIN".equals(currentUser.getRole().name()) ? "admin_panel_settings" : "person" %></span>
                <%= currentUser.getRole().name() %>
              </span>
            </div>

            <!-- Quick Stats -->
            <div class="w-full grid grid-cols-2 gap-unit-sm pt-unit-md border-t border-outline-variant/20">
              <div class="text-center p-unit-xs rounded-xl bg-surface-container-low">
                <p class="font-display font-bold text-on-surface text-xl">—</p>
                <p class="text-xs text-secondary">Matches</p>
              </div>
              <div class="text-center p-unit-xs rounded-xl bg-surface-container-low">
                <p class="font-display font-bold text-primary text-xl">4.9</p>
                <p class="text-xs text-secondary">Rating</p>
              </div>
            </div>

            <!-- Action Links -->
            <div class="w-full flex flex-col gap-unit-xs pt-unit-xs">
              <a href="<%= request.getContextPath() %>/user/booking?action=my-bookings" class="w-full py-2.5 bg-primary hover:bg-primary-container text-on-primary font-label-md font-bold rounded-xl text-center shadow-sm transition-all btn-magnetic">
                My Bookings
              </a>
              <a href="<%= request.getContextPath() %>/user/dashboard.jsp" class="w-full py-2.5 bg-surface-container hover:bg-surface-container-high text-on-surface font-label-md font-semibold rounded-xl text-center transition-colors">
                Dashboard
              </a>
              <a href="<%= request.getContextPath() %>/logout" class="w-full py-2.5 hover:bg-error-container text-error font-label-md font-semibold rounded-xl text-center transition-colors">
                Sign Out
              </a>
            </div>
          </div>
        </div>

        <!-- Info + Settings Panel (right column) -->
        <div class="lg:col-span-2 flex flex-col gap-unit-lg">
          
          <!-- Account Details Card -->
          <div class="bg-surface-container-lowest rounded-2xl p-unit-lg sm:p-unit-xl shadow-md border border-outline-variant/30 stagger-up" data-delay="0.2s">
            <div class="flex items-center gap-unit-sm mb-unit-lg">
              <div class="w-10 h-10 rounded-xl bg-primary/10 text-primary flex items-center justify-center">
                <span class="material-symbols-outlined text-xl">manage_accounts</span>
              </div>
              <div>
                <h3 class="font-headline-sm font-bold text-on-surface">Account Information</h3>
                <p class="text-xs text-secondary">Your registered TurfBook credentials</p>
              </div>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-unit-md">
              <div class="p-unit-md rounded-xl bg-surface-container-low border border-outline-variant/20">
                <span class="text-xs text-secondary uppercase font-semibold tracking-wide flex items-center gap-1 mb-1">
                  <span class="material-symbols-outlined text-xs">person</span> Username
                </span>
                <span class="font-bold text-on-surface block">@<%= currentUser.getUsername() %></span>
              </div>
              <div class="p-unit-md rounded-xl bg-surface-container-low border border-outline-variant/20">
                <span class="text-xs text-secondary uppercase font-semibold tracking-wide flex items-center gap-1 mb-1">
                  <span class="material-symbols-outlined text-xs">mail</span> Email Address
                </span>
                <span class="font-bold text-on-surface block text-sm"><%= currentUser.getEmail() %></span>
              </div>
              <div class="p-unit-md rounded-xl bg-surface-container-low border border-outline-variant/20">
                <span class="text-xs text-secondary uppercase font-semibold tracking-wide flex items-center gap-1 mb-1">
                  <span class="material-symbols-outlined text-xs">phone</span> Phone Number
                </span>
                <span class="font-bold text-on-surface block"><%= currentUser.getPhone() != null && !currentUser.getPhone().isEmpty() ? currentUser.getPhone() : "—" %></span>
              </div>
              <div class="p-unit-md rounded-xl bg-surface-container-low border border-outline-variant/20">
                <span class="text-xs text-secondary uppercase font-semibold tracking-wide flex items-center gap-1 mb-1">
                  <span class="material-symbols-outlined text-xs">shield</span> Access Level
                </span>
                <span class="font-bold text-primary block"><%= currentUser.getRole().name() %></span>
              </div>
            </div>
          </div>

          <!-- Platform Perks Card -->
          <div class="bg-surface-container-lowest rounded-2xl p-unit-lg sm:p-unit-xl shadow-md border border-outline-variant/30 stagger-up" data-delay="0.3s">
            <div class="flex items-center gap-unit-sm mb-unit-lg">
              <div class="w-10 h-10 rounded-xl bg-primary/10 text-primary flex items-center justify-center">
                <span class="material-symbols-outlined text-xl">workspace_premium</span>
              </div>
              <div>
                <h3 class="font-headline-sm font-bold text-on-surface">Your TurfBook Perks</h3>
                <p class="text-xs text-secondary">Active benefits on your player account</p>
              </div>
            </div>
            <div class="space-y-unit-sm">
              <% String[] perks = {"Instant Digital Pitch Pass (QR)", "Real-Time Slot Availability", "Razorpay Secure Payments", "Nationwide Arena Network", "Match History & Receipts"}; %>
              <% for (String perk : perks) { %>
                <div class="flex items-center gap-unit-sm p-unit-sm rounded-xl bg-surface-container-low border border-outline-variant/20">
                  <div class="w-7 h-7 rounded-full bg-primary/10 text-primary flex items-center justify-center shrink-0">
                    <span class="material-symbols-outlined text-[14px]" style="font-variation-settings: 'FILL' 1;">check_circle</span>
                  </div>
                  <span class="font-label-md font-semibold text-on-surface"><%= perk %></span>
                </div>
              <% } %>
            </div>
          </div>

        </div>
      </div>
    </div>
  </main>

  <script src="<%= request.getContextPath() %>/js/app.js"></script>
</body>
</html>
