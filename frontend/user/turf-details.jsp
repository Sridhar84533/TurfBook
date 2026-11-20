<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.turfbook.model.Turf" %>
<%@ page import="com.turfbook.model.User" %>
<%@ page import="com.turfbook.model.Review" %>
<%@ page import="com.turfbook.service.ReviewService" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
    Turf turf = (Turf) request.getAttribute("turf");
    if (turf == null) {
        response.sendRedirect(request.getContextPath() + "/turfs");
        return;
    }
    User currentUser = (User) session.getAttribute("user");
    ReviewService reviewService = new ReviewService();
    List<Review> reviews = reviewService.getReviewsForTurf(turf.getTurfId());
    double avgRating = reviewService.getAverageRating(turf.getTurfId());
    if (avgRating == 0.0) avgRating = 4.9;

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String todayDate = sdf.format(new Date());
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title><%= turf.getTurfName() %> • TurfBook</title>
  <!-- Fonts loaded FIRST before Tailwind to ensure icons render as glyphs -->
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
  <style>
    /* ===== CRITICAL: Material Symbols Icon Fix =====
       Forces icon font rendering and prevents icon names from
       appearing as literal text when font is loading. */
    .material-symbols-outlined {
      font-family: 'Material Symbols Outlined', sans-serif !important;
      font-weight: normal;
      font-style: normal;
      font-size: 24px;
      line-height: 1;
      letter-spacing: normal;
      text-transform: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      white-space: nowrap;
      word-wrap: normal;
      direction: ltr;
      -webkit-font-smoothing: antialiased;
      -moz-osx-font-smoothing: grayscale;
      text-rendering: optimizeLegibility;
      font-feature-settings: 'liga';
      flex-shrink: 0;
    }
    /* Highlights bar: ensure icon box doesn't collapse and items align */
    .highlight-item {
      display: flex;
      align-items: center;
      gap: 0.75rem;
      padding: 0.5rem;
    }
    .highlight-icon-box {
      width: 2.5rem;
      height: 2.5rem;
      min-width: 2.5rem;
      border-radius: 0.75rem;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
    }
    .highlight-text p {
      margin: 0;
      line-height: 1.3;
    }
    /* Feature cards icon fix */
    .feature-card-icon {
      display: block;
      margin-bottom: 0.25rem;
    }
    /* Slot RESERVATION header text */
    #booking-card .slot-label {
      font-size: 0.7rem;
      text-transform: uppercase;
      letter-spacing: 0.08em;
      font-weight: 700;
    }
    /* Scrollbar hidden */
    ::-webkit-scrollbar { display: none; }
    html, body { margin: 0; padding: 0; }
    body { overscroll-behavior: none; }
  </style>
</head>
<body class="bg-surface font-body-md text-on-surface antialiased min-h-screen" data-context-path="<%= request.getContextPath() %>">
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

  <main class="w-full pt-16 bg-surface px-unit-md lg:px-unit-xl py-unit-lg min-h-screen">
    <div class="max-w-[1280px] mx-auto flex flex-col w-full pb-unit-3xl">
      
      <!-- Breadcrumb -->
      <nav class="flex items-center gap-unit-xs text-body-sm text-secondary mb-unit-md select-none">
        <a class="hover:text-primary transition-colors flex items-center gap-1" href="<%= request.getContextPath() %>/index.jsp">
          <span class="material-symbols-outlined text-[16px]">home</span>
          <span>Home</span>
        </a>
        <span class="text-outline-variant font-mono">/</span>
        <a class="hover:text-primary transition-colors" href="<%= request.getContextPath() %>/turfs">Explore Turfs</a>
        <span class="text-outline-variant font-mono">/</span>
        <span class="text-on-surface font-semibold truncate max-w-[240px]"><%= turf.getTurfName() %></span>
      </nav>

      <!-- Title & Action Bar -->
      <div class="flex flex-col lg:flex-row lg:items-center justify-between gap-unit-lg mb-unit-lg">
        <div class="space-y-unit-xs">
          <div class="flex flex-wrap items-center gap-unit-xs">
            <span class="inline-flex items-center gap-1 px-unit-xs py-unit-2xs rounded-full bg-surface-container-high text-on-surface-variant font-label-sm font-bold tracking-wider uppercase">
              <span class="material-symbols-outlined text-[15px] text-primary" style="font-variation-settings: 'FILL' 1;">verified</span>
              FIFA Quality Pro Certified
            </span>
            <span class="inline-flex items-center gap-1 px-unit-xs py-unit-2xs rounded-full bg-secondary-container/60 text-secondary font-label-sm font-bold">
              <span class="material-symbols-outlined text-[14px]">sports_soccer</span>
              <%= turf.getTurfType() != null ? turf.getTurfType().getDisplayName() : "Multi-Sport" %>
            </span>
          </div>
          <h1 class="font-headline-xl text-headline-xl text-on-surface font-bold tracking-tight">
            <%= turf.getTurfName() %>
          </h1>
          <div class="flex flex-wrap items-center gap-x-unit-lg gap-y-unit-xs text-body-md text-secondary">
            <div class="flex items-center gap-1.5 text-on-surface font-semibold">
              <span class="material-symbols-outlined text-primary text-[20px]" style="font-variation-settings: 'FILL' 1;">star</span>
              <span class="font-headline-sm leading-none"><%= String.format("%.1f", avgRating) %></span>
              <span class="text-secondary font-normal font-body-sm">(<%= reviews.size() %> reviews)</span>
            </div>
            <span class="hidden sm:inline text-outline-variant">•</span>
            <a href="https://www.google.com/maps/search/?api=1&query=<%= (turf.getLatitude() != 0.0 && turf.getLongitude() != 0.0) ? (turf.getLatitude() + "," + turf.getLongitude()) : java.net.URLEncoder.encode(turf.getTurfName() + " " + turf.getFullLocation(), "UTF-8") %>" target="_blank" class="flex items-center gap-1.5 text-on-surface-variant hover:text-[#1a73e8] transition-colors group" title="Open GPS directions on Google Maps">
              <span class="material-symbols-outlined text-[18px] text-primary group-hover:text-[#1a73e8]">location_on</span>
              <span class="underline decoration-dotted"><%= turf.getFullLocation() %></span>
              <span class="inline-flex items-center gap-0.5 px-2 py-0.5 rounded-md bg-[#1a73e8]/10 text-[#1a73e8] text-xs font-bold">
                <span class="material-symbols-outlined text-[12px]">near_me</span>
                <span>GPS Map</span>
              </span>
            </a>
          </div>
        </div>

        <div class="flex items-center gap-unit-sm self-start lg:self-center">
          <a class="inline-flex items-center gap-2 px-unit-lg py-unit-xs rounded-xl bg-primary text-on-primary font-label-lg font-bold shadow-sm hover:bg-primary-container transition-all" href="#booking-card">
            <span class="material-symbols-outlined text-[18px]">sports_score</span>
            <span>Book Match Slot</span>
          </a>
        </div>
      </div>

      <!-- Photo Bento Grid -->
      <section class="grid grid-cols-1 md:grid-cols-12 gap-unit-sm mb-unit-xl rounded-2xl overflow-hidden shadow-sm">
        <div class="relative md:col-span-8 group overflow-hidden min-h-[380px] lg:min-h-[440px] bg-surface-container-high">
          <img class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105" src="<%= turf.getImageUrl() != null && !turf.getImageUrl().isEmpty() ? turf.getImageUrl() : "https://lh3.googleusercontent.com/aida-public/AB6AXuASJmx0yf-bLu9fQFarxZEWw0ti9S8rkRZwbnP6cjBXQQyuI8MlE882pz-XHfRmBcpaTG75wPu3Jbd8uuILK1IDg9WsDyJ7-kLmLw3TQq5VW5DjQshZUVOXVycl9fr4fB2G9sabV_3-y5jqhB3OJaUdVjPUw66OdmAptX0cZgIOBqrOr75skFzTWnyqrPCNcfTH9m3faOSPUTkWjq-hMHnVAAlByqrYrYTl9fv-D4Bpgk3fLFCLx_f0BQ" %>"/>
          <div class="absolute inset-0 bg-gradient-to-t from-on-surface/90 via-on-surface/20 to-transparent"></div>
          <div class="absolute bottom-unit-lg left-unit-lg right-unit-lg text-white">
            <p class="font-headline-sm font-bold text-white"><%= turf.getTurfName() %> • <%= turf.isBadminton() ? "Championship Courts" : "Championship Pitch" %></p>
            <p class="font-body-sm text-white/80 mt-1"><%= (turf.getBannerSubtitle() != null && !turf.getBannerSubtitle().isEmpty()) ? turf.getBannerSubtitle() : (turf.isBadminton() ? "Tournament-grade synthetic courts with anti-glare LED illumination" : "500 Lux anti-glare floodlights with shock-padded monofilament turf") %></p>
          </div>
        </div>

        <div class="md:col-span-4 grid grid-cols-2 md:grid-cols-1 gap-unit-sm">
          <div class="relative group overflow-hidden h-[180px] md:h-[214px] bg-surface-container-high rounded-xl">
            <%
              String gal1Img = (turf.getGalleryImage1() != null && !turf.getGalleryImage1().isEmpty()) ? turf.getGalleryImage1() :
                (turf.isBadminton() ? "https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?w=800&auto=format&fit=crop&q=80" : "https://lh3.googleusercontent.com/aida-public/AB6AXuArAJoO1DOX_Knz2vDtk8ye2qgaEovwDYqUUVkQrwwZppLlCcfNg6p4rz3EhcVennEoZXrKXKgjvUwMQmHgRVdQ1xFF6M7udrmmHdpo8MZ7X61tmS4lHiDUFsnfEyB7T3i3s85pWCZB0j7RYsUuSSRPsQxhS8wEIJcg_T2PkBQ5QO0gFTWH3Zh7jKonI9CbUgoTN-dmKJnwX5WFum07wc1DD-M53VlGFvsndZR_9b0CreuKuQ_cnmsr5Q");
              String gal1Cap = (turf.getGalleryCaption1() != null && !turf.getGalleryCaption1().isEmpty()) ? turf.getGalleryCaption1() :
                (turf.isBadminton() ? "BWF Standard Matting" : "Perimeter Netting");
            %>
            <img class="w-full h-full object-cover" src="<%= gal1Img %>"/>
            <div class="absolute inset-0 bg-gradient-to-t from-on-surface/80 via-transparent to-transparent"></div>
            <span class="absolute bottom-2 left-2 text-white font-label-sm font-bold"><%= gal1Cap %></span>
          </div>
          <div class="relative group overflow-hidden h-[180px] md:h-[214px] bg-surface-container-high rounded-xl">
            <%
              String gal2Img = (turf.getGalleryImage2() != null && !turf.getGalleryImage2().isEmpty()) ? turf.getGalleryImage2() :
                (turf.isBadminton() ? "https://images.unsplash.com/photo-1544717305-2782549b5136?w=800&auto=format&fit=crop&q=80" : "https://lh3.googleusercontent.com/aida-public/AB6AXuCXmLGeBvL-Gx_wZVPzzmn0tcsqh6bje1NxsEzNUFX__KKmn-pnmqhpR1NuBAMl-tojbUpRmLfNNAiInRAnHI74yDMBZ37TMAHftB4OdRyP3ShKBzCCg1OWvMzQuTRoos6oKdCDsUZJHYk03WR-TVvNdngossYxxnKw26_ZP3jEfT4Y2VMzth2lNrnfAxtdw53_oy9ouGEzy3AYGGdKbQ0aCoRYd3vtjxdKgiJTqfXrlm5cr6uhNR8WIA");
              String gal2Cap = (turf.getGalleryCaption2() != null && !turf.getGalleryCaption2().isEmpty()) ? turf.getGalleryCaption2() :
                "Locker & Showers";
            %>
            <img class="w-full h-full object-cover" src="<%= gal2Img %>"/>
            <div class="absolute inset-0 bg-gradient-to-t from-on-surface/80 via-transparent to-transparent"></div>
            <span class="absolute bottom-2 left-2 text-white font-label-sm font-bold"><%= gal2Cap %></span>
          </div>
        </div>
      </section>

      <!-- Highlights Bar -->
      <section class="bg-surface-container-lowest rounded-2xl p-unit-md shadow-sm mb-unit-xl border border-outline-variant/30">
        <div class="grid grid-cols-2 sm:grid-cols-4 gap-unit-md">
          <div class="highlight-item">
            <div class="highlight-icon-box bg-surface-container text-primary">
              <span class="material-symbols-outlined" style="font-size:22px;">wb_twilight</span>
            </div>
            <div class="highlight-text">
              <p class="font-label-md font-bold text-on-surface">500 Lux</p>
              <p class="font-body-sm text-secondary" style="font-size:12px;">LED Floodlights</p>
            </div>
          </div>
          <div class="highlight-item">
            <div class="highlight-icon-box bg-surface-container text-primary">
              <span class="material-symbols-outlined" style="font-size:22px;">grass</span>
            </div>
            <div class="highlight-text">
              <p class="font-label-md font-bold text-on-surface">FIFA Spec</p>
              <p class="font-body-sm text-secondary" style="font-size:12px;">Synthetic Grass</p>
            </div>
          </div>
          <div class="highlight-item">
            <div class="highlight-icon-box bg-surface-container text-primary">
              <span class="material-symbols-outlined" style="font-size:22px;">local_parking</span>
            </div>
            <div class="highlight-text">
              <p class="font-label-md font-bold text-on-surface">Free Parking</p>
              <p class="font-body-sm text-secondary" style="font-size:12px;">Cars &amp; 2-Wheelers</p>
            </div>
          </div>
          <div class="highlight-item">
            <div class="highlight-icon-box bg-surface-container text-primary">
              <span class="material-symbols-outlined" style="font-size:22px;">shower</span>
            </div>
            <div class="highlight-text">
              <p class="font-label-md font-bold text-on-surface">Clean Showers</p>
              <p class="font-body-sm text-secondary" style="font-size:12px;">Changing Rooms</p>
            </div>
          </div>
        </div>
      </section>

      <!-- Main Two Columns -->
      <div class="grid grid-cols-1 lg:grid-cols-12 gap-unit-xl items-start">
        
        <!-- Left: Details & Amenities & Reviews (8 Cols) -->
        <div class="lg:col-span-8 space-y-unit-xl">
          
          <!-- About The Facility -->
          <section class="bg-surface-container-lowest rounded-2xl p-unit-lg shadow-sm border border-outline-variant/30 space-y-unit-md">
            <div class="flex items-center gap-2">
              <span class="material-symbols-outlined text-primary text-[22px]">verified_user</span>
              <h2 class="font-headline-sm font-bold text-on-surface">About the Sports Hub</h2>
            </div>
            <p class="font-body-md text-secondary leading-relaxed">
              <%= turf.getDescription() != null && !turf.getDescription().isEmpty() ? turf.getDescription() : "Engineered for high-intensity competitive gameplay and casual weekend fixtures, this arena features 50mm diamond-spine monofilament yarn. The surface is cushioned by an advanced cellular polyethylene shock pad underlay, designed to minimize knee trauma and guarantee true ball roll." %>
            </p>
            <div class="grid grid-cols-1 sm:grid-cols-3 gap-unit-sm pt-unit-xs">
              <div class="p-unit-md rounded-xl bg-surface-container-low">
                <span class="material-symbols-outlined text-primary feature-card-icon" style="font-size:20px;">layers</span>
                <p class="font-label-md font-bold text-on-surface mt-2">10mm Shock Pad</p>
                <p class="font-body-sm text-secondary mt-1">Impact absorption layer prevents joint stress</p>
              </div>
              <div class="p-unit-md rounded-xl bg-surface-container-low">
                <span class="material-symbols-outlined text-primary feature-card-icon" style="font-size:20px;">grain</span>
                <p class="font-label-md font-bold text-on-surface mt-2">Cryogenic Infill</p>
                <p class="font-body-sm text-secondary mt-1">Odorless non-compacting rubber pellet blend</p>
              </div>
              <div class="p-unit-md rounded-xl bg-surface-container-low">
                <span class="material-symbols-outlined text-primary feature-card-icon" style="font-size:20px;">vertical_align_top</span>
                <p class="font-label-md font-bold text-on-surface mt-2">Zero-Puddle Drainage</p>
                <p class="font-body-sm text-secondary mt-1">Rapid evacuation allows play 15 mins post rain</p>
              </div>
            </div>
          </section>

          <!-- Amenities -->
          <% if (turf.getAmenities() != null && !turf.getAmenities().isEmpty()) { %>
            <section class="bg-surface-container-lowest rounded-2xl p-unit-lg shadow-sm border border-outline-variant/30 space-y-unit-md">
              <h3 class="font-headline-sm font-bold text-on-surface">Available Amenities</h3>
              <div class="flex flex-wrap gap-2">
                <% for (String amenity : turf.getAmenities()) { %>
                  <span class="px-3 py-1.5 rounded-xl bg-surface-container-low border border-outline-variant/30 text-on-surface font-label-md font-semibold flex items-center gap-1.5">
                    <span class="material-symbols-outlined text-primary text-base">check_circle</span>
                    <%= amenity %>
                  </span>
                <% } %>
              </div>
            </section>
          <% } %>

          <!-- Reviews Section -->
          <section class="bg-surface-container-lowest rounded-2xl p-unit-lg shadow-sm border border-outline-variant/30 space-y-unit-lg">
            <div class="flex items-center justify-between">
              <div class="flex items-center gap-2">
                <span class="material-symbols-outlined text-primary text-[22px]">reviews</span>
                <h3 class="font-headline-sm font-bold text-on-surface">Player Reviews &amp; Scores</h3>
              </div>
              <span class="font-headline-sm font-bold text-primary flex items-center gap-1">
                <span class="material-symbols-outlined text-[20px]" style="font-variation-settings: 'FILL' 1;">star</span>
                <%= String.format("%.1f", avgRating) %>
              </span>
            </div>

            <!-- Submit Review Form -->
            <% if (currentUser != null) { %>
              <form action="<%= request.getContextPath() %>/user/review" method="POST" class="p-unit-md rounded-xl bg-surface-container-low space-y-unit-sm">
                <input type="hidden" name="turfId" value="<%= turf.getTurfId() %>"/>
                <h4 class="font-label-lg font-bold text-on-surface">Leave a Review</h4>
                <div class="flex items-center gap-unit-md">
                  <label class="font-label-md text-secondary">Rating:</label>
                  <select name="rating" class="h-9 px-unit-sm rounded-lg bg-surface-container-lowest font-body-sm text-on-surface border border-outline-variant/40">
                    <option value="5">⭐⭐⭐⭐⭐ (5 - Exceptional)</option>
                    <option value="4">⭐⭐⭐⭐ (4 - Very Good)</option>
                    <option value="3">⭐⭐⭐ (3 - Average)</option>
                    <option value="2">⭐⭐ (2 - Below Expectations)</option>
                    <option value="1">⭐ (1 - Poor)</option>
                  </select>
                </div>
                <textarea name="comment" required rows="2" class="w-full p-unit-sm rounded-lg bg-surface-container-lowest font-body-sm text-on-surface border border-outline-variant/40 outline-none focus:ring-2 focus:ring-primary" placeholder="How was the turf grip, floodlighting, and match experience?"></textarea>
                <button type="submit" class="px-unit-lg py-2 bg-primary hover:bg-primary-container text-on-primary font-label-md font-bold rounded-lg transition-colors">
                  Post Review
                </button>
              </form>
            <% } %>

            <!-- Reviews List -->
            <div class="space-y-unit-md">
              <% if (!reviews.isEmpty()) { %>
                <% for (Review r : reviews) { %>
                  <div class="p-unit-md rounded-xl bg-surface-container-low/60 border border-outline-variant/20 space-y-1">
                    <div class="flex items-center justify-between">
                      <span class="font-label-md font-bold text-on-surface"><%= r.getUserId() %></span>
                      <div class="flex text-amber-500">
                        <% for (int s = 0; s < r.getRating(); s++) { %>
                          <span class="material-symbols-outlined text-[16px]" style="font-variation-settings: 'FILL' 1;">star</span>
                        <% } %>
                      </div>
                    </div>
                    <p class="font-body-sm text-secondary"><%= r.getComment() %></p>
                  </div>
                <% } %>
              <% } else { %>
                <p class="text-body-sm text-secondary italic">No reviews yet. Be the first to book and review this ground!</p>
              <% } %>
            </div>
          </section>

        </div>

        <!-- Right: Sticky Booking Console (4 Cols) -->
        <div class="lg:col-span-4 sticky top-20" id="booking-card">
          <div class="bg-surface-container-lowest rounded-2xl p-unit-lg shadow-xl border border-outline-variant/30 space-y-unit-md">
            
            <div class="flex items-start justify-between pb-unit-sm border-b border-outline-variant/20">
              <div>
                <span class="font-label-sm uppercase tracking-wider text-secondary font-bold">Slot Reservation</span>
                <div class="flex items-baseline gap-1 mt-0.5">
                  <span class="font-headline-lg font-bold text-primary" id="displayRate">₹<%= (int) turf.getPricePerHour() %></span>
                  <span class="font-body-sm text-secondary">/ 60 min session</span>
                </div>
              </div>
              <span class="inline-flex items-center gap-1 px-unit-xs py-1 rounded-full bg-primary/10 text-primary font-label-sm font-bold">
                <span class="w-1.5 h-1.5 rounded-full bg-primary animate-ping"></span>
                Instant Confirm
              </span>
            </div>

            <!-- Booking Form -->
            <form action="<%= request.getContextPath() %>/user/booking" method="POST" class="space-y-unit-md" id="pitch-booking-form">
              <input type="hidden" name="turfId" value="<%= turf.getTurfId() %>"/>

              <!-- Date Picker -->
              <div class="space-y-1.5">
                <label class="font-label-md font-semibold text-on-surface flex items-center justify-between" for="bookingDate">
                  <span>Match Date</span>
                  <span class="text-xs text-primary font-bold">Select Date</span>
                </label>
                <input type="date" id="bookingDate" name="bookingDate" value="<%= todayDate %>" min="<%= todayDate %>" required
                       class="w-full h-11 px-unit-sm bg-surface-container-low rounded-xl text-body-md text-on-surface border border-outline-variant/40 outline-none focus:ring-2 focus:ring-primary"/>
              </div>

              <% if (turf.isBadminton()) { %>
                <!-- Badminton Court Availability Selector -->
                <div class="space-y-2.5">
                  <div class="p-2.5 rounded-xl bg-blue-50 border border-blue-200 flex items-center justify-between text-xs text-blue-900">
                    <div class="flex items-center gap-1.5">
                      <span class="material-symbols-outlined text-blue-600 text-lg">sports_tennis</span>
                      <span class="font-bold"><%= turf.getCourtCount() %> Parallel Courts</span>
                    </div>
                    <span class="text-[11px] font-semibold text-blue-700 bg-blue-100 px-2 py-0.5 rounded-md"><%= turf.getSlotDurationMinutes() %> min slots</span>
                  </div>

                  <div class="flex items-center justify-between">
                    <label class="font-label-md font-semibold text-on-surface block">Available Time Slots</label>
                    <span id="badminton-slot-count" class="text-xs text-secondary font-medium">Checking...</span>
                  </div>
                  <p class="text-[11px] text-secondary">Click a slot to choose your court</p>

                  <!-- Slot Cards Grid with real-time court availability -->
                  <div id="badminton-slots-grid" class="grid grid-cols-1 sm:grid-cols-2 gap-2 max-h-[300px] overflow-y-auto pr-1">
                    <div class="col-span-2 py-6 text-center text-secondary text-xs flex items-center justify-center gap-2">
                      <div class="w-4 h-4 border-2 border-primary border-t-transparent rounded-full animate-spin"></div>
                      <span>Loading court availability...</span>
                    </div>
                  </div>


                </div>
              <% } else { %>
                <!-- Popular Slot Selector (Non-badminton turfs) -->
                <div class="space-y-2">
                  <label class="font-label-md font-semibold text-on-surface block">Select Time Slot</label>
                  <div class="grid grid-cols-2 gap-unit-xs" id="slot-container">
                    <button type="button" class="slot-pill p-2 rounded-xl border text-left transition-all border-outline-variant/40 bg-surface-container-low hover:bg-surface-container" onclick="pickSlot('18:00', '19:00', this)">
                      <span class="font-mono text-xs font-bold block">18:00 - 19:00</span>
                      <span class="text-[11px] text-secondary">Floodlit Evening</span>
                    </button>
                    <button type="button" class="slot-pill p-2 rounded-xl border text-left transition-all border-primary bg-primary text-on-primary shadow-sm" onclick="pickSlot('19:00', '20:00', this)">
                      <span class="font-mono text-xs font-bold block">19:00 - 20:00</span>
                      <span class="text-[11px] opacity-90">Prime Match Time</span>
                    </button>
                    <button type="button" class="slot-pill p-2 rounded-xl border text-left transition-all border-outline-variant/40 bg-surface-container-low hover:bg-surface-container" onclick="pickSlot('20:00', '21:00', this)">
                      <span class="font-mono text-xs font-bold block">20:00 - 21:00</span>
                      <span class="text-[11px] text-secondary">Prime Night Slot</span>
                    </button>
                    <button type="button" class="slot-pill p-2 rounded-xl border text-left transition-all border-outline-variant/40 bg-surface-container-low hover:bg-surface-container" onclick="pickSlot('21:00', '22:00', this)">
                      <span class="font-mono text-xs font-bold block">21:00 - 22:00</span>
                      <span class="text-[11px] text-secondary">Late Game</span>
                    </button>
                  </div>
                </div>
              <% } %>

              <!-- Hidden inputs for selected slot -->
              <input type="hidden" id="startTime" name="startTime" value="19:00"/>
              <input type="hidden" id="endTime" name="endTime" value="20:00"/>

              <!-- Price Breakdown -->
              <div class="p-unit-sm rounded-xl bg-surface-container-low/70 space-y-2 text-body-sm">
                <div class="flex justify-between text-secondary">
                  <span>Pitch Rate (1 Hour)</span>
                  <span class="font-semibold text-on-surface">₹<%= (int) turf.getPricePerHour() %></span>
                </div>
                <div class="flex justify-between text-secondary">
                  <span>Platform Fee</span>
                  <span class="text-primary font-semibold">FREE (₹0)</span>
                </div>
                <div class="flex justify-between text-secondary">
                  <span>Floodlights &amp; Nets</span>
                  <span class="font-semibold text-on-surface">Included</span>
                </div>
                <div class="pt-2 border-t border-outline-variant/30 flex justify-between items-baseline">
                  <span class="font-label-md font-bold text-on-surface">Total Payable</span>
                  <span class="font-headline-sm font-bold text-primary">₹<%= (int) turf.getPricePerHour() %></span>
                </div>
              </div>

              <!-- Submit CTA -->
              <% if (turf.isBadminton()) { %>
                <%-- Badminton: slot click navigates to court-selection page — no form submit here --%>
                <div class="w-full py-3 px-unit-md rounded-xl bg-surface-container-low border border-outline-variant/30 text-on-surface-variant font-label-md text-center text-sm">
                  <span class="material-symbols-outlined text-[16px] align-middle mr-1">sports_tennis</span>
                  Select a time slot above to choose your court
                </div>
              <% } else if (currentUser != null) { %>
                <button type="submit" class="w-full py-3 px-unit-md rounded-xl bg-primary text-on-primary font-label-lg font-bold shadow-md hover:bg-primary-container transition-all flex items-center justify-center gap-2 active:scale-[0.98]">
                  <span class="material-symbols-outlined text-[20px]">sports_soccer</span>
                  <span>Proceed to Slot Booking</span>
                </button>
              <% } else { %>
                <a href="<%= request.getContextPath() %>/login.jsp" class="w-full py-3 px-unit-md rounded-xl bg-primary text-on-primary font-label-lg font-bold shadow-md hover:bg-primary-container transition-all flex items-center justify-center gap-2 text-center">
                  <span class="material-symbols-outlined text-[20px]">login</span>
                  <span>Login to Book Slot</span>
                </a>
              <% } %>
            </form>

            <div class="flex items-start gap-unit-xs p-unit-xs rounded-xl bg-surface-container-low/40">
              <span class="material-symbols-outlined text-primary text-[18px] mt-0.5 shrink-0">verified</span>
              <div class="text-[12px] leading-tight text-secondary">
                <span class="font-semibold text-on-surface">100% Rain Guarantee:</span>
                Cancel or reschedule free of cost up to 4 hours before kick-off.
              </div>
            </div>

          </div>
        </div>

      </div>

    </div>
  </main>

  <script>
    function pickSlot(start, end, btn) {
      document.getElementById('startTime').value = start;
      document.getElementById('endTime').value = end;
      
      const pills = document.querySelectorAll('.slot-pill');
      pills.forEach(p => {
        p.className = 'slot-pill p-2 rounded-xl border text-left transition-all border-outline-variant/40 bg-surface-container-low hover:bg-surface-container';
      });
      btn.className = 'slot-pill p-2 rounded-xl border text-left transition-all border-primary bg-primary text-on-primary shadow-sm';
    }

    // Badminton slot availability
    var badmintonSlotsGrid = document.getElementById('badminton-slots-grid');
    if (badmintonSlotsGrid) {
      var selectedSlotStart = '';
      var selectedSlotEnd = '';

      function loadBadmintonSlots() {
        var dateInput = document.getElementById('bookingDate');
        var date = dateInput ? dateInput.value : '';
        if (!date) return;

        var grid = document.getElementById('badminton-slots-grid');
        var countEl = document.getElementById('badminton-slot-count');
        if (!grid) return;

        grid.innerHTML = '<div class="col-span-2 py-8 text-center text-secondary text-xs flex items-center justify-center gap-2"><div class="w-4 h-4 border-2 border-primary border-t-transparent rounded-full animate-spin"></div><span>Checking court availability...</span></div>';
        if (countEl) countEl.innerText = 'Checking...';

        fetch('<%= request.getContextPath() %>/api/badminton/availability?turfId=<%= turf.getTurfId() %>&date=' + encodeURIComponent(date))
          .then(function(res) { return res.json(); })
          .then(function(data) {
            if (!data.success || !data.slots || data.slots.length === 0) {
              grid.innerHTML = '<div class="col-span-2 py-6 text-center text-secondary text-xs">No active slots available for this date. Please pick another date.</div>';
              if (countEl) countEl.innerText = '0 slots';
              return;
            }

            if (countEl) countEl.innerText = data.slots.length + ' slots';
            grid.innerHTML = '';

            data.slots.forEach(function(slot) {
              var isAvail = slot.available && slot.availableCourts > 0;
              var btn = document.createElement('button');
              btn.type = 'button';
              btn.className = isAvail
                ? 'badminton-slot-btn p-2.5 rounded-xl border text-left transition-all border-outline-variant/40 bg-surface-container-low hover:border-primary flex flex-col justify-between'
                : 'p-2.5 rounded-xl border text-left opacity-45 bg-slate-100 border-slate-200 cursor-not-allowed flex flex-col justify-between';

              if (!isAvail) {
                btn.disabled = true;
              }

              var courtBadge = isAvail
                ? '<span class="text-[10px] font-bold text-green-700 bg-green-100 px-1.5 py-0.5 rounded">' + slot.availableCourts + '/' + slot.totalCourts + ' Free</span>'
                : '<span class="text-[10px] font-bold text-slate-500 bg-slate-200 px-1.5 py-0.5 rounded">Full</span>';

              btn.innerHTML = '<div class="flex items-center justify-between w-full mb-1">' +
                                '<span class="font-mono text-xs font-bold">' + slot.startTime + ' - ' + slot.endTime + '</span>' +
                                courtBadge +
                              '</div>' +
                              '<span class="text-[10px] text-secondary">' + (slot.label || '') + '</span>';

              if (isAvail) {
                (function(s) {
                  btn.onclick = function() {
                    var date = document.getElementById('bookingDate').value;
                    var ctx = document.body.getAttribute('data-context-path') || '';
                    window.location.href = ctx + '/user/booking?action=court-selection'
                      + '&turfId=<%= turf.getTurfId() %>'
                      + '&date=' + encodeURIComponent(date)
                      + '&startTime=' + encodeURIComponent(s.startTime)
                      + '&endTime=' + encodeURIComponent(s.endTime);
                  };
                })(slot);
              }

              grid.appendChild(btn);
            });
          })
          .catch(function(err) {
            console.error('Failed to fetch badminton availability:', err);
            grid.innerHTML = '<div class="col-span-2 py-6 text-center text-red-600 text-xs">Failed to load real-time court availability. Please try again.</div>';
          });
      }

      document.getElementById('bookingDate')?.addEventListener('change', loadBadmintonSlots);
      document.addEventListener('DOMContentLoaded', loadBadmintonSlots);
    }
  </script>
  <script src="<%= request.getContextPath() %>/js/app.js"></script>
</body>
</html>
