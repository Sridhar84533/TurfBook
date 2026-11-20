<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.turfbook.model.Turf" %>
<%@ page import="com.turfbook.model.User" %>
<%@ page import="java.util.List" %>
<%
    List<Turf> turfs = (List<Turf>) request.getAttribute("turfs");
    String searchQuery = (String) request.getAttribute("searchQuery");
    String selectedType = (String) request.getAttribute("selectedType");
    User currentUser = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Explore Turfs • TurfBook</title>
  <link href="https://fonts.googleapis.com" rel="preconnect"/>
  <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&display=block" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;family=Outfit:wght@600;700&amp;display=swap" rel="stylesheet"/>
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
          <a class="px-unit-sm py-unit-xs bg-primary-container text-on-primary-container font-semibold rounded-lg" href="<%= request.getContextPath() %>/turfs">Explore Turfs</a>
          <% if (currentUser != null) { %>
            <a class="px-unit-sm py-unit-xs text-on-surface-variant hover:text-on-surface transition-colors font-label-lg rounded-lg" href="<%= request.getContextPath() %>/user/booking?action=my-bookings">My Bookings</a>
          <% } %>
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
        <% } else { %>
          <a href="<%= request.getContextPath() %>/login.jsp" class="px-unit-md py-unit-xs font-label-md font-semibold text-primary hover:bg-surface-container-low rounded-lg transition-colors">Sign In</a>
          <a href="<%= request.getContextPath() %>/register.jsp" class="px-unit-md py-unit-xs font-label-md font-semibold bg-primary text-on-primary hover:bg-primary-container rounded-lg shadow-sm transition-colors">Sign Up</a>
        <% } %>
      </div>
    </div>
  </header>

  <main class="w-full pt-16 bg-surface min-h-[calc(100vh-220px)]">
    <div class="flex flex-col w-full">
      
      <!-- Sub-Hero Banner -->
      <section class="w-full bg-surface-container-low px-unit-md lg:px-unit-xl py-unit-xl border-b border-outline-variant/20">
        <div class="max-w-[1280px] mx-auto flex flex-col md:flex-row md:items-end justify-between gap-unit-lg">
          <div class="space-y-unit-xs max-w-2xl">
            <div class="inline-flex items-center gap-unit-2xs px-unit-sm py-unit-2xs rounded-full bg-primary/10 text-primary font-label-sm uppercase font-bold tracking-wider">
              <span class="material-symbols-outlined text-sm" style="font-variation-settings: 'FILL' 1;">bolt</span>
              <span>Instant Confirmation System</span>
            </div>
            <h1 class="font-headline-xl text-headline-xl text-on-surface font-bold tracking-tight">Explore Sports Arenas</h1>
            <p class="font-body-lg text-body-lg text-secondary">
              Discover verified sports turfs, floodlit arenas, and synthetic pitches in your city.
            </p>
          </div>

          <div class="flex items-center gap-unit-sm">
            <div class="bg-surface-container-lowest px-unit-md py-unit-sm rounded-xl shadow-sm flex items-center gap-unit-sm border border-outline-variant/30">
              <span class="material-symbols-outlined text-primary text-2xl">sports_soccer</span>
              <div>
                <div class="font-title font-bold text-on-surface"><%= turfs != null ? turfs.size() : 0 %></div>
                <div class="font-body-sm text-secondary">Pitches Live</div>
              </div>
            </div>
            <div class="bg-surface-container-lowest px-unit-md py-unit-sm rounded-xl shadow-sm flex items-center gap-unit-sm border border-outline-variant/30">
              <span class="material-symbols-outlined text-tertiary text-2xl">wb_twilight</span>
              <div>
                <div class="font-title font-bold text-on-surface">24/7</div>
                <div class="font-body-sm text-secondary">Floodlit Arenas</div>
              </div>
            </div>
          </div>
        </div>

        <!-- Search Bar -->
        <div class="max-w-[1280px] mx-auto mt-unit-lg">
          <form action="<%= request.getContextPath() %>/turfs" method="GET" class="bg-surface-container-lowest p-unit-xs rounded-xl shadow-sm flex flex-col sm:flex-row items-center gap-unit-xs border border-outline-variant/30">
            <div class="relative flex-1 w-full flex items-center">
              <span class="material-symbols-outlined text-secondary ml-unit-sm text-xl pointer-events-none">search</span>
              <input class="w-full h-12 pl-unit-xs pr-unit-xl bg-transparent font-body-md text-on-surface placeholder:text-outline outline-none" name="search" placeholder="Search by turf name, locality, or landmark (e.g., Koramangala Arena)..." type="text" value="<%= searchQuery != null ? searchQuery : "" %>"/>
            </div>
            <div class="flex items-center w-full sm:w-auto gap-unit-xs px-unit-xs">
              <button class="w-full sm:w-auto px-unit-lg h-11 bg-primary hover:bg-primary-container text-on-primary font-label-lg font-bold rounded-lg shadow-sm transition-all flex items-center justify-center gap-unit-xs" type="submit">
                <span>Find Pitches</span>
                <span class="material-symbols-outlined text-base">arrow_forward</span>
              </button>
            </div>
          </form>

          <!-- Sport Category Pills -->
          <div class="flex flex-wrap items-center gap-unit-xs mt-unit-md">
            <a href="<%= request.getContextPath() %>/turfs" class="px-unit-md py-1.5 rounded-full font-label-md font-semibold transition-all <%= (selectedType == null || selectedType.isEmpty()) ? "bg-primary text-on-primary shadow-sm" : "bg-surface-container-lowest text-on-surface border border-outline-variant/40 hover:bg-surface-container" %>">
              All Sports
            </a>
            <a href="<%= request.getContextPath() %>/turfs?type=FOOTBALL_7V7" class="px-unit-md py-1.5 rounded-full font-label-md font-semibold transition-all <%= "FOOTBALL_7V7".equals(selectedType) ? "bg-primary text-on-primary shadow-sm" : "bg-surface-container-lowest text-on-surface border border-outline-variant/40 hover:bg-surface-container" %>">
              Football 7v7
            </a>
            <a href="<%= request.getContextPath() %>/turfs?type=BOX_CRICKET" class="px-unit-md py-1.5 rounded-full font-label-md font-semibold transition-all <%= "BOX_CRICKET".equals(selectedType) ? "bg-primary text-on-primary shadow-sm" : "bg-surface-container-lowest text-on-surface border border-outline-variant/40 hover:bg-surface-container" %>">
              Box Cricket
            </a>
            <a href="<%= request.getContextPath() %>/turfs?type=BADMINTON" class="px-unit-md py-1.5 rounded-full font-label-md font-semibold transition-all <%= "BADMINTON".equals(selectedType) ? "bg-primary text-on-primary shadow-sm" : "bg-surface-container-lowest text-on-surface border border-outline-variant/40 hover:bg-surface-container" %>">
              Badminton
            </a>
            <a href="<%= request.getContextPath() %>/turfs?type=TENNIS" class="px-unit-md py-1.5 rounded-full font-label-md font-semibold transition-all <%= "TENNIS".equals(selectedType) ? "bg-primary text-on-primary shadow-sm" : "bg-surface-container-lowest text-on-surface border border-outline-variant/40 hover:bg-surface-container" %>">
              Tennis / Padel
            </a>
          </div>
        </div>
      </section>

      <!-- Turf Cards Canvas -->
      <section class="max-w-[1280px] mx-auto px-unit-md lg:px-unit-xl py-unit-xl w-full">
        <% if (turfs != null && !turfs.isEmpty()) { %>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-unit-lg">
            <% int expIdx = 0; %>
            <% for (Turf turf : turfs) { %>
              <% expIdx++; %>
              <div class="turf-card bg-surface-container-lowest rounded-2xl overflow-hidden shadow-sm hover:shadow-xl transition-all duration-300 border border-outline-variant/30 flex flex-col group stagger-up" data-delay="<%= (expIdx * 0.08) %>s">
                <div class="relative h-56 overflow-hidden bg-surface-container reveal-mask">
                  <img src="<%= turf.getImageUrl() != null && !turf.getImageUrl().isEmpty() ? turf.getImageUrl() : "https://images.unsplash.com/photo-1529900748604-07564a03e7a6?auto=format&fit=crop&w=800&q=80" %>" 
                       alt="<%= turf.getTurfName() %>"
                       onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=800&auto=format&fit=crop&q=80';"
                       class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"/>
                  <span class="absolute top-3 left-3 bg-on-surface/80 backdrop-blur-md text-surface font-label-sm px-2.5 py-1 rounded-full uppercase font-bold text-xs">
                    <%= turf.getTurfType() != null ? turf.getTurfType().getDisplayName() : "Multi-Sport" %>
                  </span>
                  <div class="absolute bottom-3 right-3 bg-surface-container-lowest/95 backdrop-blur-md px-3 py-1 rounded-xl shadow-sm text-right">
                    <span class="font-headline-sm font-bold text-primary">₹<%= (int) turf.getPricePerHour() %></span>
                    <span class="text-[11px] text-secondary">/hr</span>
                  </div>
                </div>

                <div class="p-unit-md flex-1 flex flex-col justify-between">
                  <div>
                    <div class="flex items-center justify-between">
                      <h2 class="font-headline-sm font-bold text-on-surface line-clamp-1 group-hover:text-primary transition-colors"><%= turf.getTurfName() %></h2>
                      <div class="flex items-center gap-1 text-primary font-bold text-sm">
                        <span class="material-symbols-outlined text-sm" style="font-variation-settings: 'FILL' 1;">star</span>
                        <span>4.9</span>
                      </div>
                    </div>
                    <div class="flex items-center justify-between mt-1 text-body-sm text-secondary">
                      <p class="flex items-center gap-1 truncate text-xs">
                        <span class="material-symbols-outlined text-xs text-primary">location_on</span>
                        <span><%= turf.getFullLocation() %></span>
                      </p>
                      <a href="https://www.google.com/maps/search/?api=1&query=<%= (turf.getLatitude() != 0.0) ? (turf.getLatitude() + "," + turf.getLongitude()) : java.net.URLEncoder.encode(turf.getTurfName() + " " + turf.getFullLocation(), "UTF-8") %>" target="_blank" class="text-xs font-semibold text-[#1a73e8] hover:underline flex items-center gap-0.5 shrink-0 ml-1" title="Open Google Maps GPS">
                        <span class="material-symbols-outlined text-[13px]">near_me</span>
                        <span>GPS</span>
                      </a>
                    </div>
                    <p class="font-body-sm text-on-surface-variant line-clamp-2 mt-2 text-xs">
                      <%= turf.getDescription() != null ? turf.getDescription() : "High performance synthetic astro-turf with professional floodlights." %>
                    </p>
                    
                    <!-- Amenities -->
                    <% if (turf.getAmenities() != null && !turf.getAmenities().isEmpty()) { %>
                      <div class="flex flex-wrap gap-1.5 mt-unit-sm">
                        <% for (int i = 0; i < Math.min(turf.getAmenities().size(), 3); i++) { %>
                          <span class="text-[11px] px-2 py-0.5 rounded-md bg-surface-container text-on-surface-variant font-medium">
                            <%= turf.getAmenities().get(i) %>
                          </span>
                        <% } %>
                      </div>
                    <% } %>
                  </div>

                  <div class="pt-unit-md mt-unit-md border-t border-outline-variant/20 flex items-center justify-between gap-unit-xs">
                    <a href="<%= request.getContextPath() %>/turfs?id=<%= turf.getTurfId() %>" class="flex-1 py-2.5 bg-surface-container hover:bg-surface-container-high text-on-surface font-label-md font-semibold rounded-xl text-center transition-colors">
                      Inspect Pitch
                    </a>
                    <a href="<%= request.getContextPath() %>/turfs?id=<%= turf.getTurfId() %>#booking-card" class="btn-magnetic flex-1 py-2.5 bg-primary hover:bg-primary-container text-on-primary font-label-md font-bold rounded-xl text-center shadow-sm transition-colors flex items-center justify-center gap-1" data-cursor="BOOK">
                      <span>Book Slot</span>
                      <span class="material-symbols-outlined text-sm">bolt</span>
                    </a>
                  </div>

                </div>
              </div>
            <% } %>
          </div>
        <% } else { %>
          <div class="text-center py-unit-3xl bg-surface-container-lowest rounded-2xl border border-outline-variant/30">
            <span class="material-symbols-outlined text-5xl text-outline mb-2">sports_soccer</span>
            <h3 class="font-headline-sm font-bold text-on-surface">No turfs match your criteria</h3>
            <p class="font-body-md text-secondary mt-1 max-w-md mx-auto">Try clearing your filters or searching for another locality or sport.</p>
            <a href="<%= request.getContextPath() %>/turfs" class="mt-unit-md inline-flex items-center gap-1 px-unit-lg py-2 bg-primary text-on-primary font-label-md font-bold rounded-lg shadow-sm">
              <span>View All Turfs</span>
            </a>
          </div>
        <% } %>
      </section>

    </div>
  </main>

  <!-- Footer -->
  <footer class="w-full bg-surface-container-lowest border-t border-outline-variant/30 py-unit-lg text-center font-body-sm text-on-surface-variant">
    <div class="max-w-[1280px] mx-auto px-unit-md flex flex-col sm:flex-row items-center justify-between gap-unit-sm">
      <span>© 2026 TurfBook Platform. Book Your Game. Own the Turf.</span>
      <span>MongoDB Real-Time</span>
    </div>
  </footer>
  <script src="<%= request.getContextPath() %>/js/app.js"></script>
</body>
</html>
