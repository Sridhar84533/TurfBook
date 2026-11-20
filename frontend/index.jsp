<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.turfbook.model.Turf" %>
<%@ page import="com.turfbook.model.User" %>
<%@ page import="com.turfbook.service.TurfService" %>
<%@ page import="com.turfbook.util.DatabaseSeeder" %>
<%@ page import="java.util.List" %>
<%
    // Ensure database has default seed data
    try {
        DatabaseSeeder.seedIfEmpty();
    } catch (Exception ignored) {}

    TurfService turfService = new TurfService();
    List<Turf> featuredTurfs = turfService.getAllActiveTurfs();
    User currentUser = (User) session.getAttribute("user");

    String ctxPath = request.getContextPath();
    String[] turfFrames = {
        ctxPath + "/assets/images/turf_card1.jpg",
        ctxPath + "/assets/images/turf_card2.jpg",
        ctxPath + "/assets/images/turf_card3.jpg",
        ctxPath + "/assets/images/turf_card4.jpg"
    };
    String fallbackFrame = ctxPath + "/assets/images/turf_fallback.jpg";
    String heroFrame = ctxPath + "/assets/images/turf_hero.jpg";
%>
<!DOCTYPE html>
<html lang="en" class="overflow-x-hidden">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport"/>
  <title>TurfBook &bull; Book Your Game. Own the Turf.</title>
  <link href="https://fonts.googleapis.com" rel="preconnect"/>
  <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&display=block" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;family=Outfit:wght@600;700;800;900&amp;display=swap" rel="stylesheet"/>
  <link href="<%= ctxPath %>/css/style.css" rel="stylesheet"/>
  <script src="<%= ctxPath %>/js/app.js" defer></script>

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
    /* Prevent page shift and guarantee glitch-free intro */
    html, body {
      overflow-x: hidden;
      max-width: 100%;
      width: 100%;
      margin: 0;
      padding: 0;
      background-color: #000;
    }

    /* While intro is active, lock viewport and eliminate any scroll */
    body.intro-active {
      overflow: hidden !important;
      position: fixed !important;
      top: 0 !important;
      left: 0 !important;
      right: 0 !important;
      bottom: 0 !important;
      width: 100% !important;
      height: 100% !important;
      max-width: 100% !important;
      max-height: 100% !important;
      margin: 0 !important;
      padding: 0 !important;
    }

    body.intro-active #main-site-content {
      display: none !important;
      visibility: hidden !important;
      opacity: 0 !important;
      pointer-events: none !important;
    }

    /* When intro ends, main site content is 100% interactive and clickable */
    body:not(.intro-active) #main-site-content {
      display: block !important;
      visibility: visible !important;
      opacity: 1 !important;
      pointer-events: auto !important;
      position: relative !important;
      z-index: 10 !important;
    }

    #main-site-content {
      opacity: 1;
      visibility: visible;
      transition: opacity 0.4s ease-in-out;
      pointer-events: auto;
    }

    /* Fullscreen clean turf.mp4 intro overlay */
    body.intro-active #intro-container {
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      width: 100vw;
      height: 100vh;
      max-width: 100%;
      max-height: 100%;
      z-index: 9999999;
      background-color: #000000;
      display: flex;
      align-items: center;
      justify-content: center;
      overflow: hidden;
      margin: 0;
      padding: 0;
    }

    /* As soon as intro ends, intro-container MUST be completely hidden and non-blocking */
    body:not(.intro-active) #intro-container,
    #intro-container.intro-hidden {
      display: none !important;
      visibility: hidden !important;
      opacity: 0 !important;
      pointer-events: none !important;
      z-index: -99999 !important;
      width: 0 !important;
      height: 0 !important;
    }

    /* Fills the laptop screen edge-to-edge: no black sidebars, no cut-off content */
    #intro-video {
      width: 100%;
      height: 100%;
      max-width: 100%;
      max-height: 100%;
      object-fit: fill;
      object-position: center;
      display: block;
      background-color: #000000;
    }

    /* ==============================
       SCROLL ANIMATION SYSTEM
       ============================== */
    .scroll-slide-left,
    .scroll-slide-right,
    .scroll-slide-up,
    .scroll-slide-scale {
      opacity: 0;
      transition: opacity 0.7s cubic-bezier(0.22, 1, 0.36, 1),
                  transform 0.7s cubic-bezier(0.22, 1, 0.36, 1);
      will-change: opacity, transform;
    }
    .scroll-slide-left  { transform: translateX(-60px); }
    .scroll-slide-right { transform: translateX(60px); }
    .scroll-slide-up    { transform: translateY(50px); }
    .scroll-slide-scale { transform: scale(0.90) translateY(30px); }

    .scroll-slide-left.is-visible,
    .scroll-slide-right.is-visible,
    .scroll-slide-up.is-visible,
    .scroll-slide-scale.is-visible {
      opacity: 1;
      transform: none;
    }
  </style>
</head>
<body class="intro-active bg-surface font-body-md text-on-surface antialiased min-h-screen overflow-x-hidden w-full">

  <!-- ============================================================== -->
  <!-- CLEAN TURF.MP4 VIDEO INTRO (NO EXTRA OVERLAYS, ZERO GLITCH)     -->
  <!-- Exactly as turf.mp4 is with its own audio, loud and clear      -->
  <!-- ============================================================== -->
  <div id="intro-container">

    <!-- The actual turf.mp4 video — clean, full-screen edge-to-edge -->
    <video id="intro-video"
           playsinline
           preload="auto">
      <source src="<%= ctxPath %>/assets/turf.mp4" type="video/mp4"/>
    </video>

    <!-- Top Right Controls: Fullscreen, Sound Toggle & Skip -->
    <div class="absolute top-4 right-4 sm:top-6 sm:right-8 z-50 flex items-center gap-2 sm:gap-3">
      <!-- Fullscreen Toggle Button -->
      <button onclick="toggleFullscreen(event)" id="fs-btn"
              class="px-3 sm:px-3.5 py-1.5 rounded-full bg-black/60 hover:bg-black/80 border border-white/20 text-white transition-all text-xs flex items-center gap-1.5 backdrop-blur-md shadow-lg cursor-pointer"
              title="Toggle Fullscreen">
        <span class="material-symbols-outlined text-[18px]" id="fs-icon">fullscreen</span>
        <span class="font-mono text-xs font-semibold hidden sm:inline" id="fs-label">Fullscreen</span>
      </button>

      <!-- Sound Button -->
      <button onclick="toggleSound(event)" id="sound-btn"
              class="px-3 sm:px-3.5 py-1.5 rounded-full bg-black/60 hover:bg-black/80 border border-white/20 text-white transition-all text-xs flex items-center gap-1.5 backdrop-blur-md shadow-lg cursor-pointer"
              title="Toggle Sound">
        <span class="material-symbols-outlined text-[18px]" id="sound-icon">volume_up</span>
        <span class="font-mono text-xs font-semibold" id="sound-label">Sound ON</span>
      </button>

      <!-- Skip Button -->
      <button onclick="endIntro()"
              class="px-3.5 sm:px-4 py-1.5 rounded-full bg-primary hover:bg-primary-container text-on-primary font-bold text-xs uppercase tracking-wider transition-all shadow-lg flex items-center gap-1.5 backdrop-blur-md cursor-pointer">
        <span>Skip</span>
        <span class="material-symbols-outlined text-sm">arrow_forward</span>
      </button>
    </div>

    <!-- Tap for Fullscreen & Sound Banner (Horizontally centered) -->
    <div id="unmute-banner" onclick="handleBannerClick(event)"
         class="absolute bottom-6 left-1/2 -translate-x-1/2 z-50 px-5 py-2.5 rounded-full bg-black/80 border border-primary-fixed text-white font-medium text-xs sm:text-sm flex items-center gap-2 backdrop-blur-md shadow-2xl cursor-pointer animate-pulse whitespace-nowrap">
      <span class="material-symbols-outlined text-primary-fixed text-lg">fullscreen</span>
      <span>Click anywhere for Fullscreen & Sound</span>
    </div>

  </div><!-- /intro-container -->


  <!-- ============================================================== -->
  <!-- MAIN SITE CONTENT (PROTECTED AGAINST GLITCHES)                 -->
  <!-- Completely hidden until the video intro finishes               -->
  <!-- ============================================================== -->
  <div id="main-site-content">

    <!-- Header -->
    <header class="fixed top-0 left-0 right-0 z-40 bg-surface-container-lowest border-b border-outline-variant/30 shadow-[0_1px_8px_rgba(0,0,0,0.04)]">
      <div class="h-16 max-w-[1280px] w-full mx-auto px-4 sm:px-6 lg:px-8 flex items-center justify-between gap-unit-md">

        <!-- Brand Logo -->
        <div class="flex items-center gap-4 sm:gap-6 lg:gap-8">
          <a class="flex items-center gap-unit-xs group" href="<%= ctxPath %>/index.jsp">
            <div class="w-9 h-9 rounded-lg bg-primary flex items-center justify-center text-on-primary shadow-sm">
              <span class="material-symbols-outlined text-[22px]">sports_soccer</span>
            </div>
            <span class="font-headline-sm text-headline-sm text-on-surface tracking-tight font-bold">Turf<span class="text-primary">Book</span></span>
          </a>
          <nav class="hidden md:flex items-center gap-unit-xs">
            <a class="px-unit-sm py-unit-xs bg-primary-container text-on-primary-container font-semibold rounded-lg text-sm" href="<%= ctxPath %>/index.jsp">Home</a>
            <a class="px-unit-sm py-unit-xs text-on-surface-variant hover:text-on-surface transition-colors font-label-lg rounded-lg text-sm" href="<%= ctxPath %>/turfs">Explore Turfs</a>
            <% if (currentUser != null) { %>
              <a class="px-unit-sm py-unit-xs text-on-surface-variant hover:text-on-surface transition-colors font-label-lg rounded-lg text-sm" href="<%= ctxPath %>/user/booking?action=my-bookings">My Bookings</a>
            <% } %>
            <button onclick="startVisualSequence()"
                    class="ml-2 px-unit-sm py-1.5 flex items-center gap-1.5 text-primary bg-primary/10 hover:bg-primary/20 border border-primary/25 rounded-full font-semibold text-xs transition-all shadow-sm cursor-pointer"
                    title="Replay Video Intro">
              <span class="material-symbols-outlined text-[18px] text-primary" style="font-variation-settings: 'FILL' 1;">play_circle</span>
              <span>Watch Intro</span>
            </button>
          </nav>
        </div>

        <!-- Search & Auth -->
        <div class="flex items-center gap-unit-sm lg:gap-unit-md">
          <form action="<%= ctxPath %>/turfs" method="GET" class="relative hidden sm:block w-40 md:w-56 lg:w-64">
            <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline text-lg pointer-events-none">search</span>
            <input name="search" class="w-full h-10 pl-9 pr-unit-sm bg-surface-container-low border border-outline-variant/50 focus:border-primary rounded-lg font-body-sm text-on-surface placeholder:text-outline outline-none" placeholder="Search turfs, city..." type="text"/>
          </form>
          <% if (currentUser != null) { %>
            <div class="flex items-center gap-unit-xs">
              <a href="<%= "ADMIN".equals(currentUser.getRole().name()) ? ctxPath + "/admin/dashboard" : ctxPath + "/user/dashboard.jsp" %>"
                 class="flex items-center gap-unit-xs pl-unit-xs py-unit-2xs pr-unit-sm rounded-full bg-surface-container-low border border-outline-variant/40 hover:bg-surface-container-high transition-colors">
                <div class="w-8 h-8 rounded-full bg-primary text-on-primary font-bold flex items-center justify-center text-xs">
                  <%= currentUser.getUsername().substring(0, 1).toUpperCase() %>
                </div>
                <span class="hidden md:inline-block font-label-md text-on-surface font-semibold"><%= currentUser.getUsername() %></span>
              </a>
              <a href="<%= ctxPath %>/logout" class="p-2 text-on-surface-variant hover:text-error transition-colors" title="Sign Out">
                <span class="material-symbols-outlined text-[20px]">logout</span>
              </a>
            </div>
          <% } else { %>
            <div class="flex items-center gap-unit-xs">
              <a href="<%= ctxPath %>/login.jsp" class="px-3 sm:px-unit-md py-unit-xs font-semibold text-primary hover:bg-surface-container-low rounded-lg transition-colors text-xs sm:text-sm">Sign In</a>
              <a href="<%= ctxPath %>/register.jsp" class="px-3 sm:px-unit-md py-unit-xs font-semibold bg-primary text-on-primary hover:bg-primary-container rounded-lg shadow-sm transition-colors text-xs sm:text-sm">Sign Up</a>
            </div>
          <% } %>
        </div>
      </div>
    </header>

    <!-- Hero Section -->
    <main class="w-full pt-16 bg-surface overflow-x-hidden min-h-[calc(100vh-220px)]">
      <div class="flex flex-col w-full max-w-full">
        <section class="relative w-full overflow-hidden bg-surface-container-lowest">
          <div class="absolute -top-32 right-10 w-[540px] h-[540px] bg-primary/10 rounded-full blur-3xl pointer-events-none"></div>
          <div class="absolute top-1/2 -left-28 w-[420px] h-[420px] bg-secondary-container/40 rounded-full blur-3xl pointer-events-none"></div>

          <div class="max-w-[1280px] w-full mx-auto px-4 sm:px-6 lg:px-8 pt-6 pb-10 lg:pt-10 lg:pb-14 relative z-10">
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-6 lg:gap-8 items-center">

              <!-- Hero Left -->
              <div class="lg:col-span-7 flex flex-col items-start space-y-3 sm:space-y-4 scroll-slide-left">
                <div class="inline-flex items-center gap-unit-xs px-unit-sm py-unit-2xs rounded-full bg-surface-container-low text-primary shadow-sm font-semibold">
                  <span class="material-symbols-outlined text-base" style="font-variation-settings: 'FILL' 1;">bolt</span>
                  <span class="font-label-sm uppercase tracking-wider text-xs">Book Your Game. Own The Turf.</span>
                </div>
                <h1 class="font-display text-3xl sm:text-4xl lg:text-[46px] lg:leading-[54px] text-on-surface font-bold tracking-tight">
                  Find Your Perfect Turf. <br/>
                  <span class="text-primary underline decoration-primary-fixed decoration-4 underline-offset-8">Book It Instantly.</span>
                </h1>
                <p class="text-sm sm:text-base text-secondary max-w-xl">
                  Discover verified artificial turf arenas in your city, check real-time floodlit slots, and lock in your match with zero phone calls.
                </p>
                <div class="flex flex-wrap items-center gap-unit-sm pt-unit-xs w-full sm:w-auto">
                  <a class="inline-flex items-center justify-center gap-unit-xs px-unit-lg h-11 rounded-lg bg-primary text-on-primary font-bold shadow-md hover:bg-primary-container active:scale-[0.98] transition-all text-sm" href="<%= ctxPath %>/turfs">
                    <span>Explore Turfs</span>
                    <span class="material-symbols-outlined text-lg">arrow_forward</span>
                  </a>
                  <button onclick="startVisualSequence()"
                          class="inline-flex items-center justify-center gap-unit-xs px-unit-lg h-11 rounded-lg bg-surface-container text-on-surface font-semibold hover:bg-surface-container-high transition-all text-sm cursor-pointer">
                    <span class="material-symbols-outlined text-lg text-primary" style="font-variation-settings: 'FILL' 1;">play_circle</span>
                    <span>Watch Intro</span>
                  </button>
                </div>

                <!-- Mini Stats -->
                <div class="pt-2 grid grid-cols-2 sm:grid-cols-4 gap-3 w-full max-w-xl">
                  <div class="p-2.5 rounded-lg bg-surface-container-low text-center">
                    <p class="font-bold text-on-surface text-lg sm:text-xl">450+</p>
                    <p class="text-secondary text-xs">Verified Turfs</p>
                  </div>
                  <div class="p-2.5 rounded-lg bg-surface-container-low text-center">
                    <p class="font-bold text-on-surface text-lg sm:text-xl">99.4%</p>
                    <p class="text-secondary text-xs">On-Time Play</p>
                  </div>
                  <div class="p-2.5 rounded-lg bg-surface-container-low text-center">
                    <p class="font-bold text-primary text-lg sm:text-xl">Instant</p>
                    <p class="text-secondary text-xs">Digital Passes</p>
                  </div>
                  <div class="p-2.5 rounded-lg bg-surface-container-low text-center">
                    <div class="flex items-center justify-center gap-1">
                      <span class="font-bold text-on-surface text-lg sm:text-xl">4.9</span>
                      <span class="material-symbols-outlined text-base text-amber-500" style="font-variation-settings: 'FILL' 1;">star</span>
                    </div>
                    <p class="text-secondary text-xs">Player Rating</p>
                  </div>
                </div>
              </div>

              <!-- Hero Right — Premium Animated Turf Showcase -->
              <div class="lg:col-span-5 relative w-full flex justify-center scroll-slide-right">

                <!-- Background glow aura -->
                <div class="absolute inset-0 pointer-events-none z-0">
                  <div class="absolute top-8 right-4 w-56 h-56 bg-primary/15 rounded-full blur-3xl"></div>
                  <div class="absolute bottom-4 left-4 w-40 h-40 bg-secondary-container/30 rounded-full blur-3xl"></div>
                </div>

                <div class="relative z-10 w-full max-w-[360px] lg:max-w-[400px] flex flex-col gap-3">

                  <!-- Live Status Pill -->
                  <div class="flex items-center justify-between px-4 py-2.5 rounded-xl bg-surface-container-lowest shadow-md border border-outline-variant/30">
                    <div class="flex items-center gap-2">
                      <span class="relative flex h-2.5 w-2.5">
                        <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-primary opacity-75"></span>
                        <span class="relative inline-flex rounded-full h-2.5 w-2.5 bg-primary"></span>
                      </span>
                      <span class="text-on-surface font-semibold text-xs">Live Turf Availability</span>
                    </div>
                    <span class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full bg-primary/10 text-primary font-bold text-[10px] border border-primary/20">
                      <span class="material-symbols-outlined text-[11px]">check_circle</span> Slots Open
                    </span>
                  </div>

                  <!-- Main Turf Image Card -->
                  <div class="relative rounded-2xl overflow-hidden shadow-xl bg-surface-container group" style="aspect-ratio:4/3">
                    <img class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-700"
                         src="<%= heroFrame %>"
                         alt="TurfBook Arena Preview"
                         onerror="this.style.background='#dce9ff'"/>
                    <div class="absolute inset-0 bg-gradient-to-t from-on-surface/70 via-on-surface/10 to-transparent"></div>

                    <!-- Sport tags -->
                    <div class="absolute top-3 left-3 flex gap-1.5">
                      <span class="px-2.5 py-1 rounded-full bg-primary text-on-primary font-bold text-[10px] uppercase tracking-wide shadow">Football 7v7</span>
                      <span class="px-2.5 py-1 rounded-full bg-on-surface/70 backdrop-blur-sm text-surface font-bold text-[10px] uppercase tracking-wide">FIFA 2★</span>
                    </div>

                    <!-- Price badge -->
                    <div class="absolute top-3 right-3 px-3 py-1.5 rounded-xl bg-surface-container-lowest/95 backdrop-blur-md shadow text-right">
                      <p class="font-bold text-primary text-sm">&#8377;1,200</p>
                      <p class="text-secondary text-[9px]">per hour</p>
                    </div>

                    <!-- Venue name at bottom -->
                    <div class="absolute bottom-3 left-3 right-3">
                      <p class="font-bold text-white text-sm leading-tight drop-shadow-md">Green Arena Sports Hub</p>
                      <p class="text-white/70 text-xs flex items-center gap-0.5 mt-0.5">
                        <span class="material-symbols-outlined text-[11px] text-primary">location_on</span>
                        Koramangala, Bengaluru · 1.2 km
                      </p>
                    </div>
                  </div>

                  <!-- Quick Stats Row -->
                  <div class="grid grid-cols-3 gap-2">
                    <div class="flex flex-col items-center py-3 rounded-xl bg-surface-container-lowest border border-outline-variant/30 shadow-sm">
                      <span class="font-bold text-on-surface text-base">4.9</span>
                      <span class="material-symbols-outlined text-[14px] text-amber-500" style="font-variation-settings:'FILL' 1">star</span>
                      <span class="text-secondary text-[10px]">Rating</span>
                    </div>
                    <div class="flex flex-col items-center py-3 rounded-xl bg-surface-container-lowest border border-outline-variant/30 shadow-sm">
                      <span class="font-bold text-primary text-base">8</span>
                      <span class="material-symbols-outlined text-[14px] text-primary">event_available</span>
                      <span class="text-secondary text-[10px]">Slots Today</span>
                    </div>
                    <div class="flex flex-col items-center py-3 rounded-xl bg-surface-container-lowest border border-outline-variant/30 shadow-sm">
                      <span class="font-bold text-on-surface text-base">60s</span>
                      <span class="material-symbols-outlined text-[14px] text-tertiary">bolt</span>
                      <span class="text-secondary text-[10px]">Book Time</span>
                    </div>
                  </div>

                  <!-- CTA -->
                  <a href="<%= ctxPath %>/turfs"
                     class="w-full flex items-center justify-center gap-2 py-3 rounded-xl bg-primary text-on-primary font-bold text-sm shadow-md hover:bg-primary-container active:scale-[0.98] transition-all">
                    <span class="material-symbols-outlined text-lg">sports_soccer</span>
                    <span>Browse All Turfs</span>
                    <span class="material-symbols-outlined text-base">arrow_forward</span>
                  </a>

                </div>
              </div>

            </div>
          </div>
        </section>

        <!-- Filter Bar -->
        <section class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8 -mt-6 lg:-mt-8 relative z-20 scroll-slide-up">
          <div class="w-full p-unit-md lg:p-unit-lg rounded-2xl bg-surface-container-lowest shadow-xl border border-outline-variant/30">
            <form action="<%= ctxPath %>/turfs" method="GET" class="flex flex-col lg:flex-row items-center gap-3 lg:gap-unit-md">
              <div class="flex-1 w-full relative">
                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline text-xl pointer-events-none">search</span>
                <input name="search" class="w-full h-11 pl-10 pr-unit-md bg-surface-container-low rounded-xl text-on-surface placeholder:text-outline outline-none focus:ring-2 focus:ring-primary text-sm" placeholder="Search by turf name, area or sport..." type="text"/>
              </div>
              <div class="w-full lg:w-48 relative">
                <select name="type" class="w-full h-11 px-unit-md bg-surface-container-low rounded-xl text-on-surface outline-none appearance-none cursor-pointer text-sm">
                  <option value="">All Sports</option>
                  <option value="FOOTBALL_7V7">Football 7v7</option>
                  <option value="BOX_CRICKET">Box Cricket</option>
                  <option value="BADMINTON">Badminton</option>
                  <option value="TENNIS">Tennis</option>
                </select>
                <span class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 text-secondary pointer-events-none">unfold_more</span>
              </div>
              <button class="w-full lg:w-auto h-11 px-unit-xl bg-primary hover:bg-primary-container text-on-primary font-bold rounded-xl shadow-md transition-all flex items-center justify-center gap-unit-xs shrink-0 text-sm cursor-pointer" type="submit">
                <span class="material-symbols-outlined text-lg">search</span>
                <span>Find Pitches</span>
              </button>
            </form>
          </div>
        </section>

        <!-- Featured Pitches -->
        <section class="max-w-[1280px] w-full mx-auto px-4 sm:px-6 lg:px-8 py-10 lg:py-14" id="featured-pitches">
          <div class="flex items-end justify-between mb-6 scroll-slide-left">
            <div>
              <span class="uppercase tracking-wider text-primary font-bold text-xs">Featured Venues</span>
              <h2 class="font-bold text-on-surface text-2xl sm:text-3xl">Top Rated Turfs Near You</h2>
            </div>
            <a href="<%= ctxPath %>/turfs" class="text-primary font-bold hover:underline flex items-center gap-1 text-sm">
              <span>View All Arenas</span>
              <span class="material-symbols-outlined text-base">arrow_forward</span>
            </a>
          </div>

          <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 sm:gap-6">
            <%
              int frameIdx = 0;
              if (featuredTurfs != null && !featuredTurfs.isEmpty()) {
                for (Turf turf : featuredTurfs) {
                  String turfImg = (turf.getImageUrl() != null && !turf.getImageUrl().isEmpty())
                      ? turf.getImageUrl()
                      : turfFrames[frameIdx % turfFrames.length];
                  frameIdx++;
            %>
                <div class="bg-surface-container-lowest rounded-2xl overflow-hidden shadow-md hover:shadow-xl transition-all flex flex-col border border-outline-variant/30 group <%= (frameIdx % 2 == 1 ? "scroll-slide-left" : "scroll-slide-right") %> turf-deck-card" data-delay="<%= ((frameIdx - 1) % 4) * 100 %>">
                  <div class="relative h-44 sm:h-48 overflow-hidden bg-surface-container">
                    <img src="<%= turfImg %>"
                         alt="<%= turf.getTurfName() %>"
                         onerror="this.src='<%= fallbackFrame %>'"
                         class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"/>
                    <span class="absolute top-3 left-3 bg-on-surface/80 backdrop-blur-md text-surface font-bold px-2.5 py-1 rounded-full uppercase text-[10px]">
                      <%= turf.getTurfType() != null ? turf.getTurfType().getDisplayName() : "Multi-Sport" %>
                    </span>
                    <span class="absolute top-3 right-3 bg-primary text-on-primary font-bold text-xs px-2.5 py-1 rounded-full">
                      &#8377;<%= (int) turf.getPricePerHour() %>/hr
                    </span>
                  </div>
                  <div class="p-unit-md flex-1 flex flex-col justify-between">
                    <div>
                      <h3 class="font-bold text-on-surface line-clamp-1 text-sm sm:text-base"><%= turf.getTurfName() %></h3>
                      <div class="flex items-center justify-between text-secondary mt-1 text-xs">
                        <p class="flex items-center gap-1 truncate">
                          <span class="material-symbols-outlined text-xs text-primary">location_on</span>
                          <span class="truncate"><%= turf.getFullLocation() %></span>
                        </p>
                        <a href="https://www.google.com/maps/search/?api=1&query=<%= (turf.getLatitude() != 0.0) ? (turf.getLatitude() + "," + turf.getLongitude()) : java.net.URLEncoder.encode(turf.getTurfName() + " " + turf.getFullLocation(), "UTF-8") %>"
                           target="_blank"
                           class="text-xs font-semibold text-[#1a73e8] hover:underline flex items-center gap-0.5 shrink-0 ml-1">
                          <span class="material-symbols-outlined text-[13px]">near_me</span>
                          <span>GPS</span>
                        </a>
                      </div>
                    </div>
                    <div class="pt-unit-sm mt-unit-xs border-t border-outline-variant/20 flex items-center justify-between">
                      <div class="flex items-center gap-1 text-primary font-bold text-xs sm:text-sm">
                        <span class="material-symbols-outlined text-sm" style="font-variation-settings: 'FILL' 1;">star</span>
                        <span>4.9</span>
                      </div>
                      <a href="<%= ctxPath %>/turfs?id=<%= turf.getTurfId() %>" class="px-unit-sm py-1.5 bg-primary hover:bg-primary-container text-on-primary font-bold rounded-lg transition-colors text-xs">
                        Book Now
                      </a>
                    </div>
                  </div>
                </div>
            <%
                }
              } else {
            %>
              <div class="col-span-4 text-center py-unit-xl bg-surface-container-low rounded-2xl">
                <p class="text-secondary text-sm">No turfs currently available. Please check back soon!</p>
              </div>
            <% } %>
          </div>
        </section>

      </div>
    </main>

    <!-- Footer -->
    <footer class="w-full bg-surface-container-lowest border-t border-outline-variant/30 py-6 sm:py-8">
      <div class="max-w-[1280px] w-full mx-auto px-4 sm:px-6 lg:px-8 flex flex-col md:flex-row items-center justify-between gap-4 text-on-surface-variant text-xs sm:text-sm">
        <div class="flex items-center gap-unit-xs">
          <div class="w-7 h-7 rounded bg-primary text-on-primary flex items-center justify-center font-bold text-xs">TB</div>
          <span class="font-bold text-on-surface">TurfBook Platform</span>
          <span>&bull; Book Your Game. Own the Turf.</span>
        </div>
        <div class="flex items-center gap-4">
          <a href="<%= ctxPath %>/turfs" class="hover:text-primary transition-colors">Pitches</a>
          <a href="<%= ctxPath %>/login.jsp" class="hover:text-primary transition-colors">Operator Login</a>
          <span class="font-mono text-xs">MongoDB v7+</span>
        </div>
      </div>
    </footer>

  </div><!-- /main-site-content -->


  <!-- ============================================================== -->
  <!-- INTRO CONTROLLER — PURE TURF.MP4, LOUD AUDIO, NO GLITCHES       -->
  <!-- ============================================================== -->
  <script>
    const introContainer = document.getElementById('intro-container');
    const introVideo     = document.getElementById('intro-video');
    const mainContent    = document.getElementById('main-site-content');
    const soundIcon      = document.getElementById('sound-icon');
    const soundLabel     = document.getElementById('sound-label');
    const fsIcon         = document.getElementById('fs-icon');
    const fsLabel        = document.getElementById('fs-label');
    const unmuteBanner   = document.getElementById('unmute-banner');

    let introEnded = false;

    // Fullscreen API Helpers
    function requestBrowserFullscreen() {
      const elem = document.documentElement;
      try {
        if (!document.fullscreenElement && !document.webkitFullscreenElement) {
          if (elem.requestFullscreen) {
            elem.requestFullscreen().catch(() => {});
          } else if (elem.webkitRequestFullscreen) {
            elem.webkitRequestFullscreen();
          } else if (elem.msRequestFullscreen) {
            elem.msRequestFullscreen();
          }
        }
      } catch(e) {}
    }

    function exitBrowserFullscreen() {
      try {
        if (document.fullscreenElement || document.webkitFullscreenElement) {
          if (document.exitFullscreen) {
            document.exitFullscreen().catch(() => {});
          } else if (document.webkitExitFullscreen) {
            document.webkitExitFullscreen().catch(() => {});
          } else if (document.msExitFullscreen) {
            document.msExitFullscreen().catch(() => {});
          }
        }
      } catch(e) {}
    }

    function toggleFullscreen(e) {
      if (e) e.stopPropagation();
      if (!document.fullscreenElement && !document.webkitFullscreenElement) {
        requestBrowserFullscreen();
      } else {
        exitBrowserFullscreen();
      }
    }

    document.addEventListener('fullscreenchange', () => {
      const isFS = !!(document.fullscreenElement || document.webkitFullscreenElement);
      if (fsIcon) fsIcon.textContent = isFS ? 'fullscreen_exit' : 'fullscreen';
      if (fsLabel) fsLabel.textContent = isFS ? 'Exit FS' : 'Fullscreen';
      if (isFS && unmuteBanner && introVideo && !introVideo.muted) {
        unmuteBanner.classList.add('hidden');
      }
    });

    // Transition smoothly from video intro to index page
    function endIntro() {
      if (introEnded) return;
      introEnded = true;

      // 1. Automatically exit true fullscreen so all rest of pages run in normal screen
      exitBrowserFullscreen();

      // 2. Immediately unlock document scroll and activate main site
      document.body.classList.remove('intro-active');

      // 3. Immediately disable and hide intro container with !important so it NEVER blocks clicks
      introContainer.classList.add('intro-hidden');
      introContainer.style.setProperty('display', 'none', 'important');
      introContainer.style.setProperty('pointer-events', 'none', 'important');
      introContainer.style.setProperty('z-index', '-99999', 'important');
      introContainer.style.setProperty('visibility', 'hidden', 'important');
      introContainer.style.setProperty('opacity', '0', 'important');

      // 4. Pause the video
      if (introVideo) {
        introVideo.pause();
      }

      // 5. Ensure main content is 100% interactive and clickable
      if (mainContent) {
        mainContent.style.setProperty('pointer-events', 'auto', 'important');
        mainContent.style.setProperty('display', 'block', 'important');
        mainContent.style.setProperty('visibility', 'visible', 'important');
        mainContent.style.setProperty('opacity', '1', 'important');
      }
    }

    function updateSoundUI(isUnmuted) {
      if (isUnmuted) {
        soundIcon.textContent = 'volume_up';
        soundLabel.textContent = 'Sound ON';
        if (unmuteBanner && (document.fullscreenElement || document.webkitFullscreenElement)) {
          unmuteBanner.classList.add('hidden');
        }
      } else {
        soundIcon.textContent = 'volume_off';
        soundLabel.textContent = 'Sound Muted';
        if (unmuteBanner) unmuteBanner.classList.remove('hidden');
      }
    }

    function toggleSound(e) {
      if (e) e.stopPropagation();
      if (!introVideo) return;

      if (introVideo.muted) {
        enableSound();
      } else {
        introVideo.muted = true;
        updateSoundUI(false);
      }
    }

    function enableSound() {
      if (!introVideo) return;
      introVideo.muted = false;
      introVideo.volume = 1.0;
      updateSoundUI(true);
    }

    function handleBannerClick(e) {
      if (e) e.stopPropagation();
      enableSound();
      requestBrowserFullscreen();
      if (unmuteBanner) unmuteBanner.classList.add('hidden');
    }

    // Any click or tap anywhere on the screen during intro un-mutes and activates Fullscreen
    document.addEventListener('click', () => {
      if (!introEnded) {
        enableSound();
        requestBrowserFullscreen();
      } else {
        // If intro already ended, ensure browser fullscreen is cleanly released
        if (document.fullscreenElement || document.webkitFullscreenElement) {
          exitBrowserFullscreen();
        }
      }
    });

    // Keyboard support: Escape or Space to skip; 'f' for fullscreen toggle
    document.addEventListener('keydown', (e) => {
      if (!introEnded) {
        if (e.key === 'Escape' || e.key === ' ' || e.key === 'Enter') {
          endIntro();
        } else if (e.key === 'f' || e.key === 'F') {
          toggleFullscreen();
        }
      }
    });

    // ── Mark intro as played so Home tab navigations skip it ────────────
    const _origEndIntro = endIntro;
    function endIntroAndMark() {
      _origEndIntro();
      sessionStorage.setItem('turfbook_intro_played', '1');
    }
    // Patch all callers to use the marking version
    introVideo.removeEventListener('ended', endIntro);
    introVideo.addEventListener('ended', endIntroAndMark);
    window.endIntro = endIntroAndMark;

    // Start video immediately on page load
    window.addEventListener('DOMContentLoaded', () => {
      // ── Skip intro if already played this session (e.g. clicking Home tab) ──
      if (sessionStorage.getItem('turfbook_intro_played') === '1') {
        endIntroAndMark();
        return;
      }

      introVideo.currentTime = 0;
      introVideo.volume = 1.0;
      introVideo.muted = false;

      // Attempt fullscreen if allowed by user activation
      requestBrowserFullscreen();

      const playPromise = introVideo.play();
      if (playPromise !== undefined) {
        playPromise.then(() => {
          // Autoplay with audio succeeded
          updateSoundUI(true);
        }).catch(() => {
          // Browser autoplay restriction: start muted, prompt user to click
          introVideo.muted = true;
          introVideo.play().then(() => {
            updateSoundUI(false);
          }).catch(() => {});
        });
      }
    });


    // Replay intro function (called by "Watch Intro" button)
    window.startVisualSequence = function() {
      // Clear flag so the re-played intro will re-set it on finish
      sessionStorage.removeItem('turfbook_intro_played');
      introEnded = false;
      document.body.classList.add('intro-active');
      introContainer.style.display = 'flex';
      introContainer.style.opacity = '1';
      introContainer.style.transition = 'none';
      introVideo.currentTime = 0;
      introVideo.volume = 1.0;
      introVideo.muted = false;

      requestBrowserFullscreen();

      introVideo.play().then(() => {
        updateSoundUI(true);
      }).catch(() => {
        introVideo.muted = true;
        introVideo.play();
        updateSoundUI(false);
      });
    };
  </script>

  <!-- ============================================================== -->
  <!-- SCROLL ANIMATION OBSERVER                                       -->
  <!-- ============================================================== -->
  <script>
    (function() {
      if (!('IntersectionObserver' in window)) return;

      var observer = new IntersectionObserver(function(entries) {
        entries.forEach(function(entry) {
          if (entry.isIntersecting) {
            var el = entry.target;
            var delay = parseInt(el.getAttribute('data-delay') || '0', 10);
            setTimeout(function() {
              el.classList.add('is-visible');
            }, delay);
            observer.unobserve(el);
          }
        });
      }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' });

      var animated = document.querySelectorAll(
        '.scroll-slide-left, .scroll-slide-right, .scroll-slide-up, .scroll-slide-scale'
      );
      animated.forEach(function(el) {
        observer.observe(el);
      });
    })();
  </script>
</body>
</html>
