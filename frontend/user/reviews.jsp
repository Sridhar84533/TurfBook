<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.turfbook.model.Review" %>
<%@ page import="com.turfbook.model.User" %>
<%@ page import="com.turfbook.service.ReviewService" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("user");
    ReviewService reviewService = new ReviewService();
    List<Review> allReviews = reviewService.getAllReviews();
    double platformAvg = 4.9;
    int totalReviews = (allReviews != null) ? allReviews.size() : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Player Reviews • TurfBook</title>
  <meta name="description" content="Real verified reviews from TurfBook players across all sports arenas."/>
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
        <% if (currentUser != null) { %>
          <a href="<%= request.getContextPath() %>/user/dashboard.jsp" class="px-unit-sm py-unit-xs text-on-surface-variant hover:text-on-surface font-label-lg transition-colors">Dashboard</a>
        <% } else { %>
          <a href="<%= request.getContextPath() %>/login.jsp" class="px-unit-md py-unit-xs font-label-md font-semibold bg-primary text-on-primary rounded-lg shadow-sm transition-all btn-magnetic">Sign In</a>
        <% } %>
      </div>
    </div>
  </header>

  <main class="w-full pt-16 bg-surface min-h-screen">
    <div class="max-w-[900px] mx-auto px-unit-md lg:px-0 py-unit-xl pb-unit-3xl">

      <!-- Page Header -->
      <div class="mb-unit-xl stagger-up">
        <span class="font-label-sm uppercase tracking-wider text-primary font-bold">Community Feedback</span>
        <h1 class="font-display font-extrabold text-on-surface text-3xl sm:text-4xl mt-1">Player Reviews</h1>
        <p class="font-body-md text-secondary mt-1">Verified match feedback from real players across all pitches.</p>
      </div>

      <!-- Platform Rating Bar -->
      <div class="bg-surface-container-lowest rounded-2xl p-unit-lg sm:p-unit-xl shadow-md border border-outline-variant/30 mb-unit-xl stagger-up" data-delay="0.1s">
        <div class="grid grid-cols-1 sm:grid-cols-3 gap-unit-lg items-center">
          <div class="text-center sm:border-r border-outline-variant/20">
            <p class="font-display font-black text-on-surface" style="font-size: 4rem; line-height: 1;">4.9</p>
            <div class="flex justify-center gap-0.5 my-1">
              <% for (int i = 0; i < 5; i++) { %>
                <span class="material-symbols-outlined text-xl text-amber-500" style="font-variation-settings: 'FILL' 1;">star</span>
              <% } %>
            </div>
            <p class="text-xs text-secondary font-semibold">Platform Rating</p>
          </div>
          <div class="text-center sm:border-r border-outline-variant/20">
            <p class="font-display font-black text-primary text-5xl"><%= totalReviews > 0 ? totalReviews : "2.4K" %>+</p>
            <p class="text-xs text-secondary font-semibold mt-1">Verified Reviews</p>
          </div>
          <div class="text-center">
            <p class="font-display font-black text-on-surface text-5xl">99<span class="text-3xl text-primary">%</span></p>
            <p class="text-xs text-secondary font-semibold mt-1">Would Recommend</p>
          </div>
        </div>
      </div>

      <!-- Reviews Grid -->
      <div class="space-y-unit-md">
        <% if (allReviews != null && !allReviews.isEmpty()) { %>
          <% int reviewIndex = 0; %>
          <% for (Review r : allReviews) { %>
            <% reviewIndex++; %>
            <div class="bg-surface-container-lowest p-unit-lg rounded-2xl shadow-sm border border-outline-variant/30 hover:shadow-md transition-shadow stagger-up" data-delay="<%= (reviewIndex * 0.08) %>s">
              <div class="flex items-start gap-unit-md">
                <!-- User Avatar -->
                <div class="w-11 h-11 rounded-full bg-primary text-on-primary font-bold flex items-center justify-center shrink-0 text-base shadow-sm">
                  <%= r.getUserId() != null && r.getUserId().length() > 0 ? r.getUserId().substring(0, 1).toUpperCase() : "P" %>
                </div>
                <div class="flex-1 min-w-0">
                  <div class="flex items-center justify-between flex-wrap gap-unit-xs">
                    <div>
                      <h3 class="font-label-lg font-bold text-on-surface">Verified Player</h3>
                      <p class="text-xs text-outline font-mono">ID: <%= r.getUserId() != null ? r.getUserId().substring(0, Math.min(8, r.getUserId().length())) %>... • Ground <%= r.getTurfId() != null ? r.getTurfId().substring(0, Math.min(6, r.getTurfId().length())) : "—" %></p>
                    </div>
                    <div class="flex items-center gap-0.5">
                      <% for (int s = 0; s < Math.min(r.getRating(), 5); s++) { %>
                        <span class="material-symbols-outlined text-sm text-amber-500" style="font-variation-settings: 'FILL' 1;">star</span>
                      <% } %>
                      <% for (int s = r.getRating(); s < 5; s++) { %>
                        <span class="material-symbols-outlined text-sm text-outline">star</span>
                      <% } %>
                      <span class="ml-1 font-bold text-xs text-on-surface"><%= r.getRating() %>/5</span>
                    </div>
                  </div>
                  <% if (r.getComment() != null && !r.getComment().isEmpty()) { %>
                    <p class="font-body-md text-secondary mt-unit-xs leading-relaxed">"<%= r.getComment() %>"</p>
                  <% } %>
                  <div class="flex items-center gap-unit-sm mt-unit-sm pt-unit-xs border-t border-outline-variant/20">
                    <span class="inline-flex items-center gap-1 text-xs font-semibold text-primary">
                      <span class="material-symbols-outlined text-xs" style="font-variation-settings: 'FILL' 1;">verified</span> Verified Match Play
                    </span>
                  </div>
                </div>
              </div>
            </div>
          <% } %>
        <% } else { %>
          <!-- Empty state for no reviews -->
          <div class="text-center py-unit-3xl bg-surface-container-lowest rounded-2xl border border-outline-variant/30 shadow-sm stagger-up">
            <div class="w-16 h-16 rounded-2xl bg-primary/10 text-primary flex items-center justify-center mx-auto mb-unit-md">
              <span class="material-symbols-outlined text-3xl">rate_review</span>
            </div>
            <h3 class="font-headline-sm font-bold text-on-surface">No Reviews Yet</h3>
            <p class="font-body-md text-secondary mt-1 max-w-sm mx-auto">Be the first to review an arena after your match. Your feedback helps other players choose the right pitch.</p>
            <a href="<%= request.getContextPath() %>/turfs" class="mt-unit-lg inline-flex items-center gap-unit-xs px-unit-xl py-2.5 bg-primary text-on-primary font-label-md font-bold rounded-xl shadow-md transition-all btn-magnetic">
              <span class="material-symbols-outlined text-lg">stadium</span>
              <span>Explore Turfs</span>
            </a>
          </div>
        <% } %>
      </div>

    </div>
  </main>

  <!-- CTA Banner -->
  <section class="w-full bg-[#0b1c30] text-white py-unit-xl">
    <div class="max-w-[900px] mx-auto px-unit-md flex flex-col sm:flex-row items-center justify-between gap-unit-md">
      <div>
        <h2 class="font-display font-bold text-xl">Played a match recently?</h2>
        <p class="text-slate-400 text-sm mt-0.5">Share your experience to help the TurfBook community find great pitches.</p>
      </div>
      <a href="<%= request.getContextPath() %>/turfs" class="shrink-0 px-unit-xl py-2.5 bg-primary hover:bg-primary-container text-on-primary font-label-md font-bold rounded-xl shadow-md transition-all btn-magnetic">
        Book &amp; Review
      </a>
    </div>
  </section>

  <script src="<%= request.getContextPath() %>/js/app.js"></script>
</body>
</html>
