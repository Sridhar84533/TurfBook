<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <!DOCTYPE html>
  <html lang="en">

  <head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Create Account • TurfBook</title>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0"
      rel="stylesheet" />
    <link href="https://fonts.googleapis.com" rel="preconnect" />
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect" />
    <link
      href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&amp;family=Outfit:wght@600;700&amp;display=swap"
      rel="stylesheet" />
    <link href="<%= request.getContextPath() %>/css/style.css" rel="stylesheet" />
    <style>
      @layer base {

        html,
        body {
          margin: 0;
          padding: 0;
        }

        body {
          overscroll-behavior: none;
        }

        main> :first-child {
          margin-top: 0 !important;
        }

        main> :last-child {
          margin-bottom: 0 !important;
        }
      }

      ::-webkit-scrollbar {
        display: none;
      }
    </style>
    <script src="https://cdn.tailwindcss.com"></script>
    <script id="tailwind-config">
      tailwind.config = {
        darkMode: "class",
        theme: {
          extend: {
            "colors": {
              "on-secondary-container": "#5c647a", "primary": "#006b2c", "tertiary-container": "#00855b",
              "surface-container-highest": "#d3e4fe", "on-error": "#ffffff", "outline": "#6e7b6c",
              "on-surface-variant": "#3e4a3d", "on-primary-fixed": "#002109", "on-primary": "#ffffff",
              "on-tertiary-container": "#f5fff6", "surface-container": "#e5eeff", "tertiary": "#006947",
              "error-container": "#ffdad6", "surface-variant": "#d3e4fe", "surface-tint": "#006e2d",
              "secondary-fixed": "#dae2fd", "on-primary-fixed-variant": "#005320", "inverse-primary": "#62df7d",
              "surface-bright": "#f8f9ff", "secondary-container": "#dae2fd", "on-tertiary-fixed": "#002113",
              "surface-container-high": "#dce9ff", "surface-container-low": "#eff4ff", "on-tertiary": "#ffffff",
              "surface-container-lowest": "#ffffff", "on-secondary-fixed-variant": "#3f465c", "error": "#ba1a1a",
              "inverse-on-surface": "#eaf1ff", "surface-dim": "#cbdbf5", "background": "#f8f9ff",
              "secondary": "#565e74", "on-error-container": "#93000a", "surface": "#f8f9ff",
              "tertiary-fixed-dim": "#4edea3", "primary-fixed": "#7ffc97", "on-surface": "#0b1c30",
              "on-secondary": "#ffffff", "primary-container": "#00873a", "secondary-fixed-dim": "#bec6e0",
              "on-background": "#0b1c30", "on-tertiary-fixed-variant": "#005236", "primary-fixed-dim": "#62df7d",
              "tertiary-fixed": "#6ffbbe", "outline-variant": "#bdcaba", "on-secondary-fixed": "#131b2e",
              "on-primary-container": "#f7fff2", "inverse-surface": "#213145"
            },
            "borderRadius": { "DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px" },
            "spacing": { "unit-sm": "0.75rem", "unit-2xl": "3rem", "unit-xl": "2rem", "unit-xs": "0.5rem", "unit-md": "1rem", "unit-lg": "1.5rem", "unit-2xs": "0.25rem" },
            "fontFamily": { "display": ["outfit"], "headline-sm": ["outfit"], "headline-xl": ["outfit"], "headline-lg": ["outfit"], "headline-md": ["outfit"], "body-lg": ["inter"], "body-md": ["inter"], "body-sm": ["inter"], "label-lg": ["inter"], "label-md": ["inter"], "label-sm": ["inter"] }
          }
        }
      };
    </script>
  </head>

  <body
    class="min-h-screen bg-background font-body-md text-body-md text-on-surface antialiased flex flex-col justify-between">
    <!-- Header -->
    <header class="w-full max-w-[1280px] mx-auto px-unit-lg py-unit-lg flex items-center justify-between">
      <a class="flex items-center gap-unit-xs group" href="<%= request.getContextPath() %>/index.jsp">
        <div class="w-9 h-9 rounded-lg bg-primary flex items-center justify-center text-on-primary shadow-sm">
          <span class="material-symbols-outlined text-[22px]">sports_soccer</span>
        </div>
        <span
          class="font-headline-sm text-headline-sm text-on-surface group-hover:text-primary transition-colors font-bold">Turf<span
            class="text-primary">Book</span></span>
      </a>
      <a class="inline-flex items-center gap-unit-xs text-on-surface-variant hover:text-primary font-label-md text-label-md transition-colors"
        href="<%= request.getContextPath() %>/index.jsp">
        <span class="material-symbols-outlined text-[18px]">arrow_back</span>Back to home
      </a>
    </header>

    <main class="w-full flex-1 flex flex-col items-center justify-center px-unit-md py-unit-xl">
      <div class="flex flex-col w-full max-w-[1280px] mx-auto px-unit-xs sm:px-unit-md">
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-unit-lg xl:gap-unit-xl items-stretch">

          <!-- Left Column: Value Proposition -->
          <div
            class="lg:col-span-5 flex flex-col justify-between rounded-xl bg-surface-container-low p-unit-lg xl:p-unit-xl relative overflow-hidden shadow-sm border border-outline-variant/20">
            <div class="relative z-10 flex flex-col gap-unit-lg">
              <div class="flex items-center gap-unit-xs">
                <span class="inline-flex items-center justify-center w-8 h-8 rounded-full bg-primary text-on-primary">
                  <span class="material-symbols-outlined text-[18px]">stadium</span>
                </span>
                <span class="font-label-sm text-label-sm uppercase tracking-wider text-primary font-bold">TurfBook Pro
                  Pass</span>
              </div>

              <div class="flex flex-col gap-unit-2xs">
                <h2 class="font-headline-lg text-headline-lg text-on-surface font-bold">Pitches Ready. Game On.</h2>
                <p class="font-body-md text-body-md text-on-surface-variant">Step straight onto pristine FIFA-certified
                  astro-turf and floodlit arenas with effortless team coordination.</p>
              </div>

              <div class="flex flex-col gap-unit-md mt-unit-xs">
                <div class="flex items-start gap-unit-sm p-unit-sm rounded-lg bg-surface-container-lowest shadow-sm">
                  <div
                    class="w-10 h-10 rounded-lg bg-primary-fixed flex items-center justify-center shrink-0 text-on-primary-fixed">
                    <span class="material-symbols-outlined text-[22px]">loyalty</span>
                  </div>
                  <div class="flex flex-col">
                    <span class="font-title font-semibold text-on-surface">Zero Booking Fees</span>
                    <span class="font-body-sm text-on-surface-variant">100% waiver applied automatically across all demo
                      matches.</span>
                  </div>
                </div>

                <div class="flex items-start gap-unit-sm p-unit-sm rounded-lg bg-surface-container-lowest shadow-sm">
                  <div
                    class="w-10 h-10 rounded-lg bg-secondary-container flex items-center justify-center shrink-0 text-on-secondary-fixed">
                    <span class="material-symbols-outlined text-[22px]">wb_twilight</span>
                  </div>
                  <div class="flex flex-col">
                    <span class="font-title font-semibold text-on-surface">Prime Floodlit Slots</span>
                    <span class="font-body-sm text-on-surface-variant">Priority advance access to peak 7 PM – 11 PM
                      night slots.</span>
                  </div>
                </div>

                <div class="flex items-start gap-unit-sm p-unit-sm rounded-lg bg-surface-container-lowest shadow-sm">
                  <div
                    class="w-10 h-10 rounded-lg bg-tertiary-container flex items-center justify-center shrink-0 text-on-tertiary">
                    <span class="material-symbols-outlined text-[22px]">groups</span>
                  </div>
                  <div class="flex flex-col">
                    <span class="font-title font-semibold text-on-surface">Squad Split Payments</span>
                    <span class="font-body-sm text-on-surface-variant">Generate shareable split-payment links directly
                      for team chats.</span>
                  </div>
                </div>
              </div>
            </div>

            <div
              class="relative z-10 flex items-center justify-between pt-unit-lg text-on-surface-variant font-body-sm text-body-sm border-t border-outline-variant/30 mt-unit-md">
              <div class="flex items-center gap-unit-2xs">
                <span class="material-symbols-outlined text-primary text-[18px]">verified_user</span>
                <span>Turf Partners: <strong>140+ Venues</strong></span>
              </div>
              <div class="flex items-center gap-unit-2xs">
                <span class="material-symbols-outlined text-primary text-[18px]">star</span>
                <span>Rated <strong>4.9 / 5</strong></span>
              </div>
            </div>
          </div>

          <!-- Right Column: Registration Form -->
          <div
            class="lg:col-span-7 flex flex-col justify-center rounded-xl bg-surface-container-lowest p-unit-lg md:p-unit-xl shadow-md border border-outline-variant/30">
            <div class="flex flex-col gap-unit-2xs mb-unit-lg">
              <div class="inline-flex items-center gap-unit-xs">
                <span
                  class="font-label-sm text-label-sm px-unit-xs py-0.5 rounded-full bg-primary-fixed text-on-primary-fixed font-bold tracking-wide">
                  PLAYER REGISTRATION
                </span>
                <span class="font-mono text-xs text-primary font-semibold">GET ₹200 BONUS CREDIT</span>
              </div>
              <h1 class="font-headline-xl text-headline-xl text-on-surface font-bold mt-unit-2xs">Create Your TurfBook
                Account</h1>
              <p class="font-body-md text-body-md text-on-surface-variant">
                Join over 85,000+ players booking top-grade turfs across the country.
              </p>
            </div>

            <!-- Server Error Message -->
            <% String error=(String) request.getAttribute("error"); %>
              <% if (error !=null && !error.isEmpty()) { %>
                <div
                  class="mb-unit-md p-unit-sm rounded-lg bg-error-container text-on-error-container flex items-start justify-between gap-unit-sm shadow-sm"
                  id="reg-error">
                  <div class="flex items-start gap-unit-xs">
                    <span class="material-symbols-outlined text-error text-[20px] shrink-0 mt-0.5">error</span>
                    <div class="font-body-sm text-body-sm">
                      <span class="font-label-md text-label-md block font-bold">Registration Failed</span>
                      <%= error %>
                    </div>
                  </div>
                  <button class="text-on-error-container hover:opacity-75 p-0.5 rounded transition-opacity"
                    onclick="document.getElementById('reg-error').classList.add('hidden')" type="button">
                    <span class="material-symbols-outlined text-[18px]">close</span>
                  </button>
                </div>
                <% } %>

                  <!-- Form Container -->
                  <form action="<%= request.getContextPath() %>/register" class="flex flex-col gap-unit-md"
                    id="signup-form" method="POST">

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-unit-md">
                      <!-- Username Field -->
                      <div class="flex flex-col gap-1.5">
                        <label class="font-label-md text-label-md text-on-surface font-semibold" for="username">
                          Player Username <span class="text-error">*</span>
                        </label>
                        <div class="relative flex items-center">
                          <span class="font-mono text-secondary absolute left-unit-xs font-bold">@</span>
                          <input
                            class="w-full h-11 pl-8 pr-unit-md bg-surface-container-low text-on-surface font-body-md text-body-md rounded-lg border border-outline-variant/40 focus:outline-none focus:bg-surface-container-lowest focus:ring-2 focus:ring-primary transition-all"
                            id="username" name="username" placeholder="" required="" type="text"
                            value="<%= request.getParameter(" username") !=null ? request.getParameter("username") : ""
                            %>"/>
                        </div>
                        <span class="text-[11px] text-on-surface-variant">Letters, numbers, and underscores (3-20
                          chars)</span>
                      </div>

                      <!-- Phone Field -->
                      <div class="flex flex-col gap-1.5">
                        <label class="font-label-md text-label-md text-on-surface font-semibold" for="phone">
                          Phone Number <span class="text-error">*</span>
                        </label>
                        <div class="relative flex items-center">
                          <span
                            class="material-symbols-outlined absolute left-unit-xs text-secondary text-[20px]">phone</span>
                          <input
                            class="w-full h-11 pl-10 pr-unit-md bg-surface-container-low text-on-surface font-body-md text-body-md rounded-lg border border-outline-variant/40 focus:outline-none focus:bg-surface-container-lowest focus:ring-2 focus:ring-primary transition-all"
                            id="phone" name="phone" placeholder="" required="" type="tel"
                            value="<%= request.getParameter(" phone") !=null ? request.getParameter("phone") : "" %>"/>
                        </div>
                        <span class="text-[11px] text-on-surface-variant">10-digit mobile number</span>
                      </div>
                    </div>

                    <!-- Email Address -->
                    <div class="flex flex-col gap-1.5">
                      <label class="font-label-md text-label-md text-on-surface font-semibold" for="email">
                        Email Address <span class="text-error">*</span>
                      </label>
                      <div class="relative flex items-center">
                        <span
                          class="material-symbols-outlined absolute left-unit-xs text-secondary text-[20px]">mail</span>
                        <input
                          class="w-full h-11 pl-10 pr-unit-md bg-surface-container-low text-on-surface font-body-md text-body-md rounded-lg border border-outline-variant/40 focus:outline-none focus:bg-surface-container-lowest focus:ring-2 focus:ring-primary transition-all"
                          id="email" name="email" placeholder="" required="" type="email"
                          value="<%= request.getParameter(" email") !=null ? request.getParameter("email") : "" %>"/>
                      </div>
                    </div>

                    <!-- Passwords -->
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-unit-md">
                      <div class="flex flex-col gap-1.5">
                        <label class="font-label-md text-label-md text-on-surface font-semibold" for="password">
                          Password <span class="text-error">*</span>
                        </label>
                        <div class="relative flex items-center">
                          <span
                            class="material-symbols-outlined absolute left-unit-xs text-secondary text-[20px]">lock</span>
                          <input
                            class="w-full h-11 pl-10 pr-10 bg-surface-container-low text-on-surface font-body-md text-body-md rounded-lg border border-outline-variant/40 focus:outline-none focus:bg-surface-container-lowest focus:ring-2 focus:ring-primary transition-all"
                            id="password" name="password" placeholder="" required="" type="password" />
                          <button class="absolute right-unit-xs text-secondary hover:text-on-surface flex items-center"
                            onclick="togglePassword('password', this)" type="button">
                            <span class="material-symbols-outlined text-[20px]">visibility</span>
                          </button>
                        </div>
                        <span class="text-[11px] text-on-surface-variant">Uppercase, lowercase, digit, special
                          char</span>
                      </div>

                      <div class="flex flex-col gap-1.5">
                        <label class="font-label-md text-label-md text-on-surface font-semibold" for="confirmPassword">
                          Confirm Password <span class="text-error">*</span>
                        </label>
                        <div class="relative flex items-center">
                          <span
                            class="material-symbols-outlined absolute left-unit-xs text-secondary text-[20px]">verified_user</span>
                          <input
                            class="w-full h-11 pl-10 pr-10 bg-surface-container-low text-on-surface font-body-md text-body-md rounded-lg border border-outline-variant/40 focus:outline-none focus:bg-surface-container-lowest focus:ring-2 focus:ring-primary transition-all"
                            id="confirmPassword" name="confirmPassword" placeholder="Repeat your password" required=""
                            type="password" />
                          <button class="absolute right-unit-xs text-secondary hover:text-on-surface flex items-center"
                            onclick="togglePassword('confirmPassword', this)" type="button">
                            <span class="material-symbols-outlined text-[20px]">visibility</span>
                          </button>
                        </div>
                        <span class="text-[11px] text-on-surface-variant">Must match password</span>
                      </div>
                    </div>

                    <!-- Submit Button -->
                    <div class="pt-unit-xs flex flex-col gap-unit-xs">
                      <button
                        class="w-full h-12 rounded-lg bg-primary hover:bg-primary-container text-on-primary font-headline-sm text-headline-sm font-bold flex items-center justify-center gap-unit-xs transition-all shadow-md active:scale-[0.99]"
                        type="submit">
                        <span>Complete Registration &amp; Get ₹200 Turf Credit</span>
                        <span class="material-symbols-outlined text-[20px]">sports_score</span>
                      </button>

                      <div
                        class="flex items-center justify-center gap-unit-xs font-body-sm text-body-sm text-on-surface-variant mt-unit-2xs">
                        <span>Already registered with TurfBook?</span>
                        <a class="text-primary font-title font-bold hover:underline flex items-center gap-0.5"
                          href="<%= request.getContextPath() %>/login.jsp">
                          <span>Sign In here</span>
                          <span class="material-symbols-outlined text-[16px]">arrow_forward</span>
                        </a>
                      </div>
                    </div>

                  </form>

                  <div
                    class="mt-unit-lg pt-unit-md bg-surface-container-low p-unit-sm rounded-lg flex flex-wrap items-center justify-around gap-unit-sm">
                    <div class="flex items-center gap-1.5 text-on-surface-variant font-label-sm text-label-sm">
                      <span class="material-symbols-outlined text-primary text-[16px]">lock</span>
                      <span>BCrypt Password Security</span>
                    </div>
                    <div class="flex items-center gap-1.5 text-on-surface-variant font-label-sm text-label-sm">
                      <span class="material-symbols-outlined text-primary text-[16px]">storage</span>
                      <span>MongoDB Real-Time</span>
                    </div>
                    <div class="flex items-center gap-1.5 text-on-surface-variant font-label-sm text-label-sm">
                      <span class="material-symbols-outlined text-primary text-[16px]">bolt</span>
                      <span>Instant Digital Pass</span>
                    </div>
                  </div>

          </div>
        </div>
      </div>
    </main>

    <footer class="w-full py-unit-lg text-center font-body-sm text-body-sm text-on-surface-variant">
      <div class="max-w-[1280px] mx-auto px-unit-lg flex flex-col sm:flex-row items-center justify-center gap-unit-md">
        <span>© 2026 TurfBook Platform. Book Your Game. Own the Turf.</span>
        <span class="hidden sm:inline">•</span>
        <span class="hover:text-on-surface">MongoDB Real-Time Active</span>
      </div>
    </footer>

    <script>
      function togglePassword(fieldId, btn) {
        const field = document.getElementById(fieldId);
        const icon = btn.querySelector('.material-symbols-outlined');
        if (field.type === 'password') {
          field.type = 'text';
          icon.innerText = 'visibility_off';
        } else {
          field.type = 'password';
          icon.innerText = 'visibility';
        }
      }
    </script>
    <script src="<%= request.getContextPath() %>/js/app.js"></script>
  </body>

  </html>