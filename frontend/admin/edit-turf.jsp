<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.turfbook.model.Turf" %>
<%@ page import="com.turfbook.model.User" %>
<%@ page import="com.turfbook.enums.TurfType" %>
<%@ page import="com.turfbook.enums.TurfStatus" %>
<%
    Turf turf = (Turf) request.getAttribute("turf");
    if (turf == null) {
        response.sendRedirect(request.getContextPath() + "/admin/turf?action=list");
        return;
    }
    String error = (String) request.getAttribute("error");
    TurfType[] turfTypes = (TurfType[]) request.getAttribute("turfTypes");
    TurfStatus[] turfStatuses = (TurfStatus[]) request.getAttribute("turfStatuses");
    if (turfTypes == null) turfTypes = TurfType.values();
    if (turfStatuses == null) turfStatuses = TurfStatus.values();
    String amenitiesJoined = turf.getAmenities() != null ? String.join(", ", turf.getAmenities()) : "";
    User currentUser = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <meta name="theme-color" content="#006b2c"/>
  <link rel="manifest" href="<%= request.getContextPath() %>/manifest.json"/>
  <title>Edit <%= turf.getTurfName() %> • TurfOps Admin</title>
  <link href="https://fonts.googleapis.com" rel="preconnect"/>
  <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&display=block" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@600;700;800&display=swap" rel="stylesheet"/>
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
          borderRadius: { 'DEFAULT': '0.25rem', 'lg': '0.5rem', 'xl': '0.75rem', '2xl': '1rem', 'full': '9999px' },
          spacing: { 'unit-sm': '0.75rem', 'unit-xs': '0.5rem', 'unit-2xs': '0.25rem', 'unit-2xl': '3rem', 'unit-3xl': '4rem', 'admin-sidebar-width': '280px', 'unit-lg': '1.5rem', 'unit-xl': '2rem', 'unit-md': '1rem' },
          fontFamily: { 'display': ['outfit'], 'headline-sm': ['outfit'], 'headline-xl': ['outfit'], 'headline-lg': ['outfit'], 'body-lg': ['inter'], 'body-md': ['inter'], 'body-sm': ['inter'], 'label-lg': ['inter'], 'label-md': ['inter'], 'label-sm': ['inter'] }
        }
      }
    };
  </script>
</head>
<body class="bg-surface font-body-md text-on-surface antialiased min-h-screen">

  <!-- Mobile Backdrop Overlay -->
  <div class="admin-sidebar-backdrop" id="adminBackdrop" onclick="closeAdminSidebar()"></div>

  <!-- Left Sidebar (280px Desktop / Off-canvas Mobile Drawer) -->
  <aside class="admin-sidebar fixed left-0 top-0 h-full w-[280px] bg-surface-container-lowest border-r border-outline-variant/30 z-50 flex flex-col" id="adminSidebar">
    <div class="h-16 px-unit-lg flex items-center border-b border-outline-variant/20 gap-unit-xs justify-between">
      <div class="flex items-center gap-unit-xs">
        <div class="w-8 h-8 rounded-lg bg-primary text-on-primary font-bold flex items-center justify-center shadow-sm">
          <span class="material-symbols-outlined text-[20px]">sports_soccer</span>
        </div>
        <span class="font-headline-sm text-headline-sm text-on-surface font-bold">Turf<span class="text-primary">Ops</span></span>
        <span class="ml-2 text-label-sm px-2 py-0.5 rounded bg-primary/10 text-primary font-bold">ADMIN</span>
      </div>
      <button class="lg:hidden p-1.5 rounded-lg text-secondary hover:bg-surface-container-high transition-colors" onclick="closeAdminSidebar()">
        <span class="material-symbols-outlined text-xl">close</span>
      </button>
    </div>

    <!-- Complete 12 Admin Modules -->
    <nav class="flex-1 px-unit-sm py-unit-md space-y-1 overflow-y-auto">
      <a class="flex items-center gap-unit-sm px-unit-sm py-2.5 rounded-xl text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all font-label-lg" href="<%= request.getContextPath() %>/admin/dashboard">
        <span class="material-symbols-outlined text-xl">dashboard</span>
        <span>Dashboard</span>
      </a>
      <a class="flex items-center gap-unit-sm px-unit-sm py-2.5 rounded-xl text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all font-label-lg" href="<%= request.getContextPath() %>/admin/scanner">
        <span class="material-symbols-outlined text-xl text-primary font-bold">qr_code_scanner</span>
        <span class="font-bold text-on-surface">QR Gate Scanner</span>
      </a>
      <a class="flex items-center gap-unit-sm px-unit-sm py-2.5 rounded-xl transition-all bg-primary text-on-primary font-bold shadow-sm" href="<%= request.getContextPath() %>/admin/turf?action=list">
        <span class="material-symbols-outlined text-xl">stadium</span>
        <span>Turf Pitches</span>
      </a>
      <a class="flex items-center gap-unit-sm px-unit-sm py-2.5 rounded-xl text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all font-label-lg" href="<%= request.getContextPath() %>/admin/bookings">
        <span class="material-symbols-outlined text-xl">receipt_long</span>
        <span>Reservations</span>
      </a>
      <a class="flex items-center gap-unit-sm px-unit-sm py-2.5 rounded-xl text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all font-label-lg" href="<%= request.getContextPath() %>/admin/payments">
        <span class="material-symbols-outlined text-xl">payments</span>
        <span>Slot Payments</span>
      </a>
      <a class="flex items-center gap-unit-sm px-unit-sm py-2.5 rounded-xl text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all font-label-lg" href="<%= request.getContextPath() %>/admin/users">
        <span class="material-symbols-outlined text-xl">group</span>
        <span>Users Directory</span>
      </a>
      <a class="flex items-center gap-unit-sm px-unit-sm py-2.5 rounded-xl text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all font-label-lg" href="<%= request.getContextPath() %>/admin/reviews">
        <span class="material-symbols-outlined text-xl">reviews</span>
        <span>Reviews &amp; Mod</span>
      </a>
      <a class="flex items-center gap-unit-sm px-unit-sm py-2.5 rounded-xl text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all font-label-lg" href="<%= request.getContextPath() %>/admin/turf?action=add">
        <span class="material-symbols-outlined text-xl">add_circle</span>
        <span>Add Pitch</span>
      </a>
      <a class="flex items-center gap-unit-sm px-unit-sm py-2.5 rounded-xl text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all font-label-lg" href="<%= request.getContextPath() %>/admin/reports.jsp">
        <span class="material-symbols-outlined text-xl">analytics</span>
        <span>Reports</span>
      </a>
      <a class="flex items-center gap-unit-sm px-unit-sm py-2.5 rounded-xl text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all font-label-lg" href="<%= request.getContextPath() %>/admin/notifications.jsp">
        <span class="material-symbols-outlined text-xl">notifications</span>
        <span>Alerts</span>
      </a>
      <a class="flex items-center gap-unit-sm px-unit-sm py-2.5 rounded-xl text-on-surface-variant hover:bg-surface-container-low hover:text-on-surface transition-all font-label-lg" href="<%= request.getContextPath() %>/admin/checkin?action=history">
        <span class="material-symbols-outlined text-xl">history</span>
        <span>Check-In Log</span>
      </a>
    </nav>
  </aside>

  <!-- Right Main Area -->
  <div class="admin-main-wrap pl-[280px]">
    <header class="admin-header-wrap fixed top-0 left-[280px] right-0 h-16 bg-surface-container-lowest border-b border-outline-variant/30 z-40 flex items-center justify-between px-unit-md lg:px-unit-lg shadow-sm">
      <div class="flex items-center gap-2">
        <button type="button" class="lg:hidden p-2 rounded-xl text-on-surface hover:bg-surface-container transition-colors" onclick="toggleAdminSidebar()" aria-label="Open menu">
          <span class="material-symbols-outlined text-2xl">menu</span>
        </button>
        <a href="<%= request.getContextPath() %>/admin/turf?action=list" class="text-secondary hover:text-on-surface flex items-center gap-1 text-sm font-semibold transition-colors">
          <span class="material-symbols-outlined text-base">arrow_back</span>
          <span>Pitches</span>
        </a>
        <span class="text-outline">/</span>
        <span class="font-bold text-on-surface text-sm sm:text-base">Edit <%= turf.getTurfName() %></span>
      </div>

      <div class="flex items-center gap-unit-sm">
        <div class="flex items-center gap-unit-xs pl-unit-xs py-1 pr-unit-sm rounded-full bg-surface-container-low border border-outline-variant/40">
          <div class="w-7 h-7 rounded-full bg-primary text-on-primary font-bold flex items-center justify-center text-xs">
            <%= (currentUser != null && currentUser.getUsername() != null) ? currentUser.getUsername().substring(0, 1).toUpperCase() : "A" %>
          </div>
          <span class="font-label-md text-on-surface font-bold text-xs sm:text-sm">Admin Ops</span>
        </div>
        <a href="<%= request.getContextPath() %>/logout" class="p-2 text-on-surface-variant hover:text-error transition-colors" title="Sign Out">
          <span class="material-symbols-outlined text-[20px]">logout</span>
        </a>
      </div>
    </header>

    <main class="w-full pt-20 px-unit-md lg:px-unit-lg py-unit-lg min-h-screen">
      <div class="max-w-[880px] flex flex-col w-full space-y-unit-lg pb-unit-3xl">
        
        <!-- Header Banner -->
        <div class="bg-surface-container-lowest p-unit-md sm:p-unit-lg rounded-2xl shadow-sm border border-outline-variant/30 flex items-center justify-between gap-4">
          <div>
            <div class="flex items-center gap-2">
              <span class="font-label-sm uppercase tracking-wider text-primary font-bold">Catalog Maintenance</span>
              <span class="font-mono text-xs text-secondary bg-surface-container px-2 py-0.5 rounded"><%= turf.getTurfId() %></span>
            </div>
            <h1 class="font-headline-lg font-bold text-on-surface mt-1 text-2xl sm:text-3xl">Edit Ground Specifications</h1>
            <p class="font-body-md text-secondary text-xs sm:text-sm mt-0.5">Modify pricing, capacity, geolocation coordinates, and ground status in real-time.</p>
          </div>
          <span class="text-xs font-bold px-3 py-1 rounded-full <%= "ACTIVE".equalsIgnoreCase(turf.getStatus().name()) ? "bg-green-100 text-green-800" : "bg-amber-100 text-amber-800" %>">
            <%= turf.getStatus().name() %>
          </span>
        </div>

        <% if (error != null && !error.isEmpty()) { %>
          <div class="p-unit-sm rounded-xl bg-error-container text-on-error-container font-body-sm font-semibold text-xs sm:text-sm flex items-center gap-2">
            <span class="material-symbols-outlined text-base">error</span>
            <span><%= error %></span>
          </div>
        <% } %>

        <div class="bg-surface-container-lowest rounded-2xl p-unit-lg sm:p-unit-xl shadow-sm border border-outline-variant/30">
          <form action="<%= request.getContextPath() %>/admin/turf" method="POST" class="space-y-6">
            <input type="hidden" name="action" value="edit"/>
            <input type="hidden" name="turfId" value="<%= turf.getTurfId() %>"/>

            <!-- Name & Sport Type -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-unit-md">
              <div class="space-y-1.5">
                <label class="font-label-md font-bold text-on-surface block" for="turfName">Turf Name <span class="text-error">*</span></label>
                <input type="text" id="turfName" name="turfName" required value="<%= turf.getTurfName() %>"
                       class="w-full h-11 px-4 bg-surface-container-low rounded-xl font-body-md text-on-surface border border-outline-variant/40 outline-none focus:ring-2 focus:ring-primary focus:border-primary transition-all"/>
              </div>

              <div class="space-y-1.5">
                <label class="font-label-md font-bold text-on-surface block" for="turfType">Sport Type <span class="text-error">*</span></label>
                <select id="turfType" name="turfType" required
                        class="w-full h-11 px-4 bg-surface-container-low rounded-xl font-body-md text-on-surface border border-outline-variant/40 outline-none focus:ring-2 focus:ring-primary focus:border-primary transition-all">
                  <% for (TurfType type : turfTypes) { %>
                    <option value="<%= type.name() %>" <%= turf.getTurfType() != null && turf.getTurfType().equals(type) ? "selected" : "" %>><%= type.getDisplayName() %></option>
                  <% } %>
                </select>
              </div>
            </div>

            <!-- Description -->
            <div class="space-y-1.5">
              <label class="font-label-md font-bold text-on-surface block" for="description">Description</label>
              <textarea id="description" name="description" rows="3"
                        class="w-full p-4 bg-surface-container-low rounded-xl font-body-md text-on-surface border border-outline-variant/40 outline-none focus:ring-2 focus:ring-primary focus:border-primary transition-all"><%= turf.getDescription() != null ? turf.getDescription() : "" %></textarea>
            </div>

            <!-- Price, Capacity, Status -->
            <div class="grid grid-cols-1 sm:grid-cols-3 gap-unit-md">
              <div class="space-y-1.5">
                <label class="font-label-md font-bold text-on-surface block" for="pricePerHour">Price / Hour (₹) <span class="text-error">*</span></label>
                <input type="number" id="pricePerHour" name="pricePerHour" required min="100" step="50" value="<%= (int) turf.getPricePerHour() %>"
                       class="w-full h-11 px-4 bg-surface-container-low rounded-xl font-body-md text-on-surface border border-outline-variant/40 outline-none focus:ring-2 focus:ring-primary focus:border-primary transition-all"/>
              </div>

              <div class="space-y-1.5">
                <label class="font-label-md font-bold text-on-surface block" for="capacity">Player Capacity <span class="text-error">*</span></label>
                <input type="number" id="capacity" name="capacity" required min="2" max="50" value="<%= turf.getCapacity() %>"
                       class="w-full h-11 px-4 bg-surface-container-low rounded-xl font-body-md text-on-surface border border-outline-variant/40 outline-none focus:ring-2 focus:ring-primary focus:border-primary transition-all"/>
              </div>

              <div class="space-y-1.5">
                <label class="font-label-md font-bold text-on-surface block" for="status">Status</label>
                <select id="status" name="status"
                        class="w-full h-11 px-4 bg-surface-container-low rounded-xl font-body-md text-on-surface border border-outline-variant/40 outline-none focus:ring-2 focus:ring-primary focus:border-primary transition-all">
                  <% for (TurfStatus status : turfStatuses) { %>
                    <option value="<%= status.name() %>" <%= turf.getStatus() != null && turf.getStatus().equals(status) ? "selected" : "" %>><%= status.name() %></option>
                  <% } %>
                </select>
              </div>
            </div>

            <!-- Location Details -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-unit-md">
              <div class="space-y-1.5">
                <label class="font-label-md font-bold text-on-surface block" for="address">Address</label>
                <input type="text" id="address" name="address" value="<%= turf.getAddress() != null ? turf.getAddress() : "" %>"
                       class="w-full h-11 px-4 bg-surface-container-low rounded-xl font-body-md text-on-surface border border-outline-variant/40 outline-none focus:ring-2 focus:ring-primary focus:border-primary transition-all"/>
              </div>

              <div class="space-y-1.5">
                <label class="font-label-md font-bold text-on-surface block" for="city">City <span class="text-error">*</span></label>
                <input type="text" id="city" name="city" required value="<%= turf.getCity() != null ? turf.getCity() : "" %>"
                       class="w-full h-11 px-4 bg-surface-container-low rounded-xl font-body-md text-on-surface border border-outline-variant/40 outline-none focus:ring-2 focus:ring-primary focus:border-primary transition-all"/>
              </div>
            </div>

            <!-- State & Postal -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-unit-md">
              <div class="space-y-1.5">
                <label class="font-label-md font-bold text-on-surface block" for="state">State</label>
                <input type="text" id="state" name="state" value="<%= turf.getState() != null ? turf.getState() : "" %>"
                       class="w-full h-11 px-4 bg-surface-container-low rounded-xl font-body-md text-on-surface border border-outline-variant/40 outline-none focus:ring-2 focus:ring-primary focus:border-primary transition-all"/>
              </div>

              <div class="space-y-1.5">
                <label class="font-label-md font-bold text-on-surface block" for="postalCode">Postal Code</label>
                <input type="text" id="postalCode" name="postalCode" value="<%= turf.getPostalCode() != null ? turf.getPostalCode() : "" %>"
                       class="w-full h-11 px-4 bg-surface-container-low rounded-xl font-body-md text-on-surface border border-outline-variant/40 outline-none focus:ring-2 focus:ring-primary focus:border-primary transition-all"/>
              </div>
            </div>

            <!-- GPS Coordinates -->
            <div class="p-4 rounded-xl bg-surface-container-low border border-outline-variant/30 space-y-3">
              <div class="flex items-center justify-between">
                <div class="flex items-center gap-1.5">
                  <span class="material-symbols-outlined text-primary text-base">pin_drop</span>
                  <span class="font-label-md font-bold text-on-surface">GPS Coordinates</span>
                </div>
                <button type="button" onclick="previewGpsMap()" class="text-xs text-primary font-bold hover:underline flex items-center gap-1">
                  <span class="material-symbols-outlined text-[14px]">near_me</span>
                  <span>Test on Google Maps</span>
                </button>
              </div>
              <div class="grid grid-cols-1 sm:grid-cols-2 gap-unit-md">
                <div class="space-y-1">
                  <label class="font-label-sm text-secondary font-medium block" for="latitude">Latitude</label>
                  <input type="number" id="latitude" name="latitude" step="0.0001" value="<%= turf.getLatitude() != 0.0 ? turf.getLatitude() : 12.9716 %>"
                         class="w-full h-10 px-3 bg-surface-container-lowest rounded-lg font-body-md text-on-surface border border-outline-variant/40 outline-none focus:ring-2 focus:ring-primary"/>
                </div>

                <div class="space-y-1">
                  <label class="font-label-sm text-secondary font-medium block" for="longitude">Longitude</label>
                  <input type="number" id="longitude" name="longitude" step="0.0001" value="<%= turf.getLongitude() != 0.0 ? turf.getLongitude() : 77.5946 %>"
                         class="w-full h-10 px-3 bg-surface-container-lowest rounded-lg font-body-md text-on-surface border border-outline-variant/40 outline-none focus:ring-2 focus:ring-primary"/>
                </div>
              </div>
            </div>

            <!-- Amenities & Image URL -->
            <div class="space-y-1.5">
              <label class="font-label-md font-bold text-on-surface block" for="amenities">Amenities (Comma separated)</label>
              <input type="text" id="amenities" name="amenities" value="<%= amenitiesJoined %>"
                     class="w-full h-11 px-4 bg-surface-container-low rounded-xl font-body-md text-on-surface border border-outline-variant/40 outline-none focus:ring-2 focus:ring-primary focus:border-primary transition-all"/>
            </div>

            <%
              String currentMainImg = turf.getImageUrl() != null ? turf.getImageUrl() : "";
              String currentSubtitle = turf.getBannerSubtitle() != null ? turf.getBannerSubtitle() : "";
              String currentGal1 = turf.getGalleryImage1() != null ? turf.getGalleryImage1() : "";
              String currentCap1 = turf.getGalleryCaption1() != null ? turf.getGalleryCaption1() : "";
              String currentGal2 = turf.getGalleryImage2() != null ? turf.getGalleryImage2() : "";
              String currentCap2 = turf.getGalleryCaption2() != null ? turf.getGalleryCaption2() : "";
            %>

            <!-- ================= TURF PHOTOGRAPHY & BANNER SUITE ================= -->
            <div class="p-5 rounded-2xl bg-surface-container-low border border-outline-variant/30 space-y-5">
              <div class="flex items-center justify-between border-b border-outline-variant/20 pb-3">
                <div class="flex items-center gap-2">
                  <span class="material-symbols-outlined text-primary text-2xl">add_photo_alternate</span>
                  <div>
                    <h3 class="font-bold text-on-surface text-sm">Turf Photography, Banner &amp; Gallery</h3>
                    <p class="text-secondary text-xs">Update pitch banner and side gallery images either by file upload or manual URL.</p>
                  </div>
                </div>
                <span class="text-xs font-semibold px-2.5 py-0.5 rounded-full bg-primary/10 text-primary">Upload or URL</span>
              </div>

              <!-- 1. MAIN PITCH BANNER -->
              <div class="p-4 rounded-xl bg-surface-container-lowest border border-outline-variant/30 space-y-3">
                <div class="flex items-center justify-between">
                  <label class="font-label-md font-bold text-on-surface flex items-center gap-1.5" for="imageUrl">
                    <span class="material-symbols-outlined text-lg text-primary">panorama</span>
                    <span>Pitch Banner / Cover Photo <span class="text-error">*</span></span>
                  </label>
                  <div class="inline-flex p-0.5 bg-surface-container rounded-lg text-xs font-semibold">
                    <button type="button" onclick="setPhotoInputMode('main', 'url')" id="btn-mode-main-url" class="px-2.5 py-1 rounded-md bg-white text-primary shadow-xs font-bold transition-all">
                      🌐 Image URL
                    </button>
                    <button type="button" onclick="setPhotoInputMode('main', 'upload')" id="btn-mode-main-upload" class="px-2.5 py-1 rounded-md text-secondary hover:text-on-surface transition-all">
                      📁 Upload File
                    </button>
                  </div>
                </div>

                <!-- URL Mode Box -->
                <div id="box-main-url" class="space-y-1">
                  <input type="text" id="imageUrl" name="imageUrl" placeholder="https://..." 
                         value="<%= currentMainImg %>"
                         oninput="updateImagePreview('imageUrl', 'preview-main')"
                         class="w-full h-11 px-4 bg-surface-container-low rounded-xl font-body-md text-on-surface border border-outline-variant/40 outline-none focus:ring-2 focus:ring-primary focus:border-primary transition-all"/>
                </div>

                <!-- Upload Mode Box -->
                <div id="box-main-upload" class="hidden space-y-1">
                  <label class="flex items-center justify-center gap-2 h-11 px-4 bg-surface-container-low border-2 border-dashed border-primary/40 hover:border-primary rounded-xl cursor-pointer transition-all text-xs font-bold text-primary">
                    <span class="material-symbols-outlined text-lg">cloud_upload</span>
                    <span id="label-upload-main">Click to select an image from your computer</span>
                    <input type="file" accept="image/*" class="hidden" onchange="handleFileChosen(this, 'imageUrl', 'preview-main', 'label-upload-main')"/>
                  </label>
                </div>

                <!-- Preview + Subtitle -->
                <div class="flex flex-col sm:flex-row gap-4 items-start pt-2">
                  <div class="w-full sm:w-48 h-28 rounded-lg overflow-hidden bg-surface-container border border-outline-variant/30 flex-shrink-0 relative">
                    <img id="preview-main" src="<%= !currentMainImg.isEmpty() ? currentMainImg : "https://via.placeholder.com/300x160?text=Banner+Photo" %>" class="w-full h-full object-cover" onerror="this.src='https://via.placeholder.com/300x160?text=Banner+Photo'"/>
                    <span class="absolute bottom-1 right-1 bg-black/60 text-[10px] text-white px-1.5 py-0.5 rounded">Banner Preview</span>
                  </div>
                  <div class="flex-1 w-full space-y-1.5">
                    <label class="font-label-sm font-semibold text-secondary block" for="bannerSubtitle">Banner Subtitle / Tagline</label>
                    <input type="text" id="bannerSubtitle" name="bannerSubtitle" placeholder="e.g. 500 Lux anti-glare floodlights with shock-padded monofilament turf"
                           value="<%= currentSubtitle %>"
                           class="w-full h-10 px-3 bg-surface-container-low rounded-lg font-body-sm text-on-surface border border-outline-variant/40 outline-none focus:ring-2 focus:ring-primary"/>
                    <p class="text-[11px] text-secondary">Displayed directly across the bottom banner on the public turf page.</p>
                  </div>
                </div>
              </div>

              <!-- 2. GALLERY PHOTOS (Side Photos) -->
              <div class="grid grid-cols-1 md:grid-cols-2 gap-4">

                <!-- Gallery Image 1 -->
                <div class="p-4 rounded-xl bg-surface-container-lowest border border-outline-variant/30 space-y-3">
                  <div class="flex items-center justify-between">
                    <label class="font-label-md font-bold text-on-surface flex items-center gap-1.5" for="galleryImage1">
                      <span class="material-symbols-outlined text-lg text-primary">photo</span>
                      <span>Side Gallery Photo 1</span>
                    </label>
                    <div class="inline-flex p-0.5 bg-surface-container rounded-lg text-xs font-semibold">
                      <button type="button" onclick="setPhotoInputMode('gal1', 'url')" id="btn-mode-gal1-url" class="px-2 py-0.5 rounded-md bg-white text-primary shadow-xs font-bold transition-all">
                        🌐 URL
                      </button>
                      <button type="button" onclick="setPhotoInputMode('gal1', 'upload')" id="btn-mode-gal1-upload" class="px-2 py-0.5 rounded-md text-secondary hover:text-on-surface transition-all">
                        📁 Upload
                      </button>
                    </div>
                  </div>

                  <div id="box-gal1-url" class="space-y-1">
                    <input type="text" id="galleryImage1" name="galleryImage1" placeholder="https://..."
                           value="<%= currentGal1 %>"
                           oninput="updateImagePreview('galleryImage1', 'preview-gal1')"
                           class="w-full h-10 px-3 bg-surface-container-low rounded-lg font-body-sm text-on-surface border border-outline-variant/40 outline-none focus:ring-2 focus:ring-primary"/>
                  </div>
                  <div id="box-gal1-upload" class="hidden space-y-1">
                    <label class="flex items-center justify-center gap-2 h-10 px-3 bg-surface-container-low border-2 border-dashed border-primary/40 hover:border-primary rounded-lg cursor-pointer transition-all text-xs font-bold text-primary">
                      <span class="material-symbols-outlined text-base">cloud_upload</span>
                      <span id="label-upload-gal1">Choose Photo 1</span>
                      <input type="file" accept="image/*" class="hidden" onchange="handleFileChosen(this, 'galleryImage1', 'preview-gal1', 'label-upload-gal1')"/>
                    </label>
                  </div>

                  <div class="flex gap-3 items-center">
                    <div class="w-20 h-16 rounded-lg overflow-hidden bg-surface-container border border-outline-variant/30 flex-shrink-0">
                      <img id="preview-gal1" src="<%= !currentGal1.isEmpty() ? currentGal1 : "https://via.placeholder.com/150?text=Photo+1" %>" class="w-full h-full object-cover" onerror="this.src='https://via.placeholder.com/150?text=Photo+1'"/>
                    </div>
                    <div class="flex-1 space-y-1">
                      <label class="font-label-xs font-semibold text-secondary block" for="galleryCaption1">Caption / Label</label>
                      <input type="text" id="galleryCaption1" name="galleryCaption1" placeholder="e.g. Perimeter Netting or BWF Court Matting"
                             value="<%= currentCap1 %>"
                             class="w-full h-9 px-3 bg-surface-container-low rounded-lg font-body-xs text-on-surface border border-outline-variant/40 outline-none focus:ring-2 focus:ring-primary text-xs"/>
                    </div>
                  </div>
                </div>

                <!-- Gallery Image 2 -->
                <div class="p-4 rounded-xl bg-surface-container-lowest border border-outline-variant/30 space-y-3">
                  <div class="flex items-center justify-between">
                    <label class="font-label-md font-bold text-on-surface flex items-center gap-1.5" for="galleryImage2">
                      <span class="material-symbols-outlined text-lg text-primary">photo</span>
                      <span>Side Gallery Photo 2</span>
                    </label>
                    <div class="inline-flex p-0.5 bg-surface-container rounded-lg text-xs font-semibold">
                      <button type="button" onclick="setPhotoInputMode('gal2', 'url')" id="btn-mode-gal2-url" class="px-2 py-0.5 rounded-md bg-white text-primary shadow-xs font-bold transition-all">
                        🌐 URL
                      </button>
                      <button type="button" onclick="setPhotoInputMode('gal2', 'upload')" id="btn-mode-gal2-upload" class="px-2 py-0.5 rounded-md text-secondary hover:text-on-surface transition-all">
                        📁 Upload
                      </button>
                    </div>
                  </div>

                  <div id="box-gal2-url" class="space-y-1">
                    <input type="text" id="galleryImage2" name="galleryImage2" placeholder="https://..."
                           value="<%= currentGal2 %>"
                           oninput="updateImagePreview('galleryImage2', 'preview-gal2')"
                           class="w-full h-10 px-3 bg-surface-container-low rounded-lg font-body-sm text-on-surface border border-outline-variant/40 outline-none focus:ring-2 focus:ring-primary"/>
                  </div>
                  <div id="box-gal2-upload" class="hidden space-y-1">
                    <label class="flex items-center justify-center gap-2 h-10 px-3 bg-surface-container-low border-2 border-dashed border-primary/40 hover:border-primary rounded-lg cursor-pointer transition-all text-xs font-bold text-primary">
                      <span class="material-symbols-outlined text-base">cloud_upload</span>
                      <span id="label-upload-gal2">Choose Photo 2</span>
                      <input type="file" accept="image/*" class="hidden" onchange="handleFileChosen(this, 'galleryImage2', 'preview-gal2', 'label-upload-gal2')"/>
                    </label>
                  </div>

                  <div class="flex gap-3 items-center">
                    <div class="w-20 h-16 rounded-lg overflow-hidden bg-surface-container border border-outline-variant/30 flex-shrink-0">
                      <img id="preview-gal2" src="<%= !currentGal2.isEmpty() ? currentGal2 : "https://via.placeholder.com/150?text=Photo+2" %>" class="w-full h-full object-cover" onerror="this.src='https://via.placeholder.com/150?text=Photo+2'"/>
                    </div>
                    <div class="flex-1 space-y-1">
                      <label class="font-label-xs font-semibold text-secondary block" for="galleryCaption2">Caption / Label</label>
                      <input type="text" id="galleryCaption2" name="galleryCaption2" placeholder="e.g. Locker &amp; Showers or Pro Shop"
                             value="<%= currentCap2 %>"
                             class="w-full h-9 px-3 bg-surface-container-low rounded-lg font-body-xs text-on-surface border border-outline-variant/40 outline-none focus:ring-2 focus:ring-primary text-xs"/>
                    </div>
                  </div>
                </div>

              </div>
            </div>

            <!-- ====== BADMINTON COURT CONFIGURATION (only visible when BADMINTON selected) ====== -->
            <div id="badmintonConfig" class="<%= turf.isBadminton() ? "" : "hidden" %> p-5 rounded-2xl bg-blue-50 border-2 border-blue-200 space-y-4">
              <div class="flex items-center gap-2">
                <span class="material-symbols-outlined text-blue-600 text-2xl">sports_tennis</span>
                <div>
                  <h3 class="font-bold text-blue-900 text-sm">Badminton Court Configuration</h3>
                  <p class="text-blue-700 text-xs">Configure courts and operating schedule for slot-based availability.</p>
                </div>
              </div>
              <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div class="space-y-1.5">
                  <label class="font-label-md font-bold text-blue-900 block" for="courtCount">Number of Courts <span class="text-error">*</span></label>
                  <input type="number" id="courtCount" name="courtCount" min="1" max="20" value="<%= turf.getCourtCount() > 0 ? turf.getCourtCount() : 4 %>"
                         class="w-full h-11 px-4 bg-white rounded-xl font-body-md text-on-surface border border-blue-300 outline-none focus:ring-2 focus:ring-blue-500 transition-all"/>
                  <p class="text-xs text-blue-600">How many parallel courts can be booked at the same time?</p>
                </div>
                <div class="space-y-1.5">
                  <label class="font-label-md font-bold text-blue-900 block" for="slotDurationMinutes">Slot Duration (minutes) <span class="text-error">*</span></label>
                  <select id="slotDurationMinutes" name="slotDurationMinutes"
                          class="w-full h-11 px-4 bg-white rounded-xl font-body-md text-on-surface border border-blue-300 outline-none focus:ring-2 focus:ring-blue-500 transition-all">
                    <option value="30" <%= turf.getSlotDurationMinutes() == 30 ? "selected" : "" %>>30 minutes</option>
                    <option value="45" <%= turf.getSlotDurationMinutes() == 45 ? "selected" : "" %>>45 minutes</option>
                    <option value="60" <%= turf.getSlotDurationMinutes() == 60 || turf.getSlotDurationMinutes() == 0 ? "selected" : "" %>>60 minutes (1 hour)</option>
                    <option value="90" <%= turf.getSlotDurationMinutes() == 90 ? "selected" : "" %>>90 minutes</option>
                    <option value="120" <%= turf.getSlotDurationMinutes() == 120 ? "selected" : "" %>>120 minutes (2 hours)</option>
                  </select>
                </div>
                <div class="space-y-1.5">
                  <label class="font-label-md font-bold text-blue-900 block" for="openingTime">Opening Time <span class="text-error">*</span></label>
                  <input type="time" id="openingTime" name="openingTime" value="<%= turf.getOpeningTime() != null ? turf.getOpeningTime() : "07:00" %>"
                         class="w-full h-11 px-4 bg-white rounded-xl font-body-md text-on-surface border border-blue-300 outline-none focus:ring-2 focus:ring-blue-500 transition-all"/>
                </div>
                <div class="space-y-1.5">
                  <label class="font-label-md font-bold text-blue-900 block" for="closingTime">Closing Time <span class="text-error">*</span></label>
                  <input type="time" id="closingTime" name="closingTime" value="<%= turf.getClosingTime() != null ? turf.getClosingTime() : "00:00" %>"
                         class="w-full h-11 px-4 bg-white rounded-xl font-body-md text-on-surface border border-blue-300 outline-none focus:ring-2 focus:ring-blue-500 transition-all"/>
                  <p class="text-xs text-blue-600">Use 00:00 to indicate midnight closing (end of day).</p>
                </div>
              </div>
            </div>

            <!-- Submit Button -->
            <div class="pt-4 flex items-center gap-3 border-t border-outline-variant/20">
              <a href="<%= request.getContextPath() %>/admin/turf?action=list" class="px-5 py-2.5 bg-surface-container hover:bg-surface-container-high text-on-surface font-label-md font-bold rounded-xl transition-colors">
                Cancel
              </a>
              <button type="submit" class="px-6 py-2.5 bg-primary hover:bg-primary-container text-on-primary font-label-md font-bold rounded-xl shadow-md transition-all flex items-center gap-2">
                <span class="material-symbols-outlined text-lg">save</span>
                <span>Update Ground Specs</span>
              </button>
            </div>

          </form>
        </div>

      </div>
    </main>
  </div>

  <script src="<%= request.getContextPath() %>/js/app.js"></script>
  <script>
    function previewGpsMap() {
      var lat = document.getElementById('latitude').value || '12.9716';
      var lng = document.getElementById('longitude').value || '77.5946';
      window.open('https://www.google.com/maps/search/?api=1&query=' + lat + ',' + lng, '_blank');
    }

    // Show/hide badminton configuration section
    function toggleBadmintonConfig() {
      var typeEl = document.getElementById('turfType');
      var configEl = document.getElementById('badmintonConfig');
      if (!typeEl || !configEl) return;
      if (typeEl.value === 'BADMINTON') {
        configEl.classList.remove('hidden');
        document.getElementById('courtCount').required = true;
        document.getElementById('openingTime').required = true;
        document.getElementById('closingTime').required = true;
      } else {
        configEl.classList.add('hidden');
        document.getElementById('courtCount').required = false;
        document.getElementById('openingTime').required = false;
        document.getElementById('closingTime').required = false;
      }
    }
    document.getElementById('turfType')?.addEventListener('change', toggleBadmintonConfig);
    toggleBadmintonConfig();

    // Photo Suite handlers
    function setPhotoInputMode(section, mode) {
      var urlBox = document.getElementById('box-' + section + '-url');
      var uploadBox = document.getElementById('box-' + section + '-upload');
      var btnUrl = document.getElementById('btn-mode-' + section + '-url');
      var btnUpload = document.getElementById('btn-mode-' + section + '-upload');

      if (!urlBox || !uploadBox) return;

      if (mode === 'url') {
        urlBox.classList.remove('hidden');
        uploadBox.classList.add('hidden');
        btnUrl.className = "px-2.5 py-1 rounded-md bg-white text-primary shadow-xs font-bold transition-all";
        btnUpload.className = "px-2.5 py-1 rounded-md text-secondary hover:text-on-surface transition-all";
      } else {
        urlBox.classList.add('hidden');
        uploadBox.classList.remove('hidden');
        btnUpload.className = "px-2.5 py-1 rounded-md bg-white text-primary shadow-xs font-bold transition-all";
        btnUrl.className = "px-2.5 py-1 rounded-md text-secondary hover:text-on-surface transition-all";
      }
    }

    function updateImagePreview(inputId, previewImgId) {
      var input = document.getElementById(inputId);
      var preview = document.getElementById(previewImgId);
      if (input && preview) {
        var val = input.value.trim();
        if (val) preview.src = val;
      }
    }

    function handleFileChosen(fileInput, targetInputId, previewImgId, labelId) {
      var file = fileInput.files && fileInput.files[0];
      if (!file) return;

      var labelEl = document.getElementById(labelId);
      if (labelEl) labelEl.textContent = "Processing " + file.name + "...";

      var reader = new FileReader();
      reader.onload = function(e) {
        var img = new Image();
        img.onload = function() {
          var canvas = document.createElement('canvas');
          var maxDim = 1200;
          var w = img.width;
          var h = img.height;
          if (w > maxDim || h > maxDim) {
            if (w > h) {
              h = Math.round((h * maxDim) / w);
              w = maxDim;
            } else {
              w = Math.round((w * maxDim) / h);
              h = maxDim;
            }
          }
          canvas.width = w;
          canvas.height = h;
          var ctx = canvas.getContext('2d');
          ctx.drawImage(img, 0, 0, w, h);
          var dataUrl = canvas.toDataURL('image/jpeg', 0.85);

          var targetInput = document.getElementById(targetInputId);
          if (targetInput) targetInput.value = dataUrl;

          var preview = document.getElementById(previewImgId);
          if (preview) preview.src = dataUrl;

          if (labelEl) labelEl.textContent = "✓ Uploaded: " + file.name;
        };
        img.src = e.target.result;
      };
      reader.readAsDataURL(file);
    }
  </script>
</body>
</html>
