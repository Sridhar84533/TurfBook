<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <!DOCTYPE html>
  <html lang="en">

  <head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Sign In • TurfBook</title>
    <meta name="description"
      content="Sign in to TurfBook — manage bookings, access your pitch pass, or manage turfs as admin." />
    <link href="https://fonts.googleapis.com" rel="preconnect" />
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect" />
    <link
      href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&display=block"
      rel="stylesheet" />
    <link
      href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@600;700;800&display=swap"
      rel="stylesheet" />
    <link href="<%= request.getContextPath() %>/css/style.css" rel="stylesheet" />
    <script src="https://cdn.tailwindcss.com"></script>
    <script id="tailwind-config">
      tailwind.config = {
        darkMode: "class",
        theme: {
          extend: {
            colors: {
              "primary": "#006b2c", "on-primary": "#ffffff", "primary-container": "#00873a",
              "on-primary-container": "#f7fff2", "primary-fixed": "#7ffc97", "primary-fixed-dim": "#62df7d",
              "surface": "#f8f9ff", "surface-container-lowest": "#ffffff", "surface-container-low": "#eff4ff",
              "surface-container": "#e5eeff", "surface-container-high": "#dce9ff",
              "on-surface": "#0b1c30", "on-surface-variant": "#3e4a3d",
              "outline": "#6e7b6c", "outline-variant": "#bdcaba",
              "secondary": "#565e74", "error": "#ba1a1a", "error-container": "#ffdad6",
              "tertiary": "#006947", "tertiary-container": "#00855b",
              "inverse-primary": "#62df7d", "on-error": "#ffffff"
            },
            borderRadius: { "DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px" },
            spacing: { "unit-sm": "0.75rem", "unit-xl": "2rem", "unit-xs": "0.5rem", "unit-md": "1rem", "unit-lg": "1.5rem", "unit-2xs": "0.25rem" },
            fontFamily: { "display": ["Outfit"], "body-md": ["Inter"], "body-sm": ["Inter"], "label-lg": ["Inter"], "label-md": ["Inter"] }
          }
        }
      };
    </script>
    <style>
      html,
      body {
        margin: 0;
        padding: 0;
      }

      body {
        overscroll-behavior: none;
      }

      ::-webkit-scrollbar {
        display: none;
      }

      .field-group:focus-within .field-box {
        border-color: #006b2c !important;
        box-shadow: 0 0 0 3px rgba(0, 107, 44, 0.12);
      }

      .pitch-bg {
        background-color: #013d1a;
        background-image:
          repeating-linear-gradient(0deg, transparent, transparent 44px, rgba(255, 255, 255, 0.025) 44px, rgba(255, 255, 255, 0.025) 45px),
          repeating-linear-gradient(90deg, transparent, transparent 44px, rgba(255, 255, 255, 0.025) 44px, rgba(255, 255, 255, 0.025) 45px);
      }

      @keyframes cardIn {
        from {
          opacity: 0;
          transform: translateY(22px);
        }

        to {
          opacity: 1;
          transform: translateY(0);
        }
      }

      .login-card {
        animation: cardIn 0.38s ease-out forwards;
      }

      .or-divider {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        color: #9eaaa0;
        font-size: 0.71rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.07em;
      }

      .or-divider::before,
      .or-divider::after {
        content: '';
        flex: 1;
        height: 1px;
        background: #e2e8e2;
      }

      @keyframes spin {
        to {
          transform: rotate(360deg);
        }
      }
    </style>
  </head>

  <body class="min-h-screen font-body-md text-on-surface antialiased flex flex-col" style="background:#f4f7f4;">

    <!-- TOP NAV -->
    <header
      style="width:100%; padding:16px 24px; display:flex; align-items:center; justify-content:space-between; max-width:1200px; margin:0 auto; box-sizing:border-box;">
      <a href="<%= request.getContextPath() %>/index.jsp"
        style="display:flex; align-items:center; gap:8px; text-decoration:none;">
        <div
          style="width:36px; height:36px; border-radius:10px; background:#006b2c; display:flex; align-items:center; justify-content:center;">
          <span class="material-symbols-outlined" style="font-size:19px; color:#fff;">sports_soccer</span>
        </div>
        <span
          style="font-family:'Outfit',sans-serif; font-weight:800; font-size:1.15rem; color:#0b1c30; letter-spacing:-0.015em;">
          Turf<span style="color:#006b2c;">Book</span>
        </span>
      </a>
      <a href="<%= request.getContextPath() %>/index.jsp"
        style="display:flex; align-items:center; gap:4px; font-family:'Inter',sans-serif; font-size:0.82rem; font-weight:600; color:#565e74; text-decoration:none;">
        <span class="material-symbols-outlined" style="font-size:17px;">arrow_back</span>
        Back to home
      </a>
    </header>

    <!-- MAIN -->
    <main style="flex:1; display:flex; align-items:center; justify-content:center; padding:40px 16px;">
      <div
        style="width:100%; max-width:1060px; margin:0 auto; display:grid; grid-template-columns:1fr 1fr; gap:32px; align-items:stretch;">

        <!-- LEFT HERO (hidden on mobile via media query) -->
        <div class="pitch-bg"
          style="border-radius:20px; overflow:hidden; box-shadow:0 20px 50px rgba(0,0,0,0.2); position:relative; display:flex; flex-direction:column; justify-content:space-between; padding:36px; min-height:560px;">
          <div
            style="position:absolute; inset:0; background:linear-gradient(135deg,rgba(1,61,26,0.85),rgba(0,107,44,0.6),rgba(1,61,26,0.95));">
          </div>
          <!-- Pitch lines -->
          <div style="position:absolute; top:50%; left:0; right:0; height:1px; background:rgba(255,255,255,0.1);"></div>
          <div
            style="position:absolute; top:50%; left:50%; width:140px; height:140px; border-radius:50%; border:1px solid rgba(255,255,255,0.1); transform:translate(-50%,-50%);">
          </div>

          <!-- Top content -->
          <div style="position:relative; z-index:1;">
            <div
              style="display:inline-flex; align-items:center; gap:6px; padding:6px 14px; border-radius:999px; background:rgba(255,255,255,0.1); margin-bottom:18px;">
              <span class="material-symbols-outlined" style="font-size:14px; color:#7ffc97;">bolt</span>
              <span
                style="font-family:'Inter',sans-serif; font-size:0.67rem; font-weight:700; text-transform:uppercase; letter-spacing:0.09em; color:#7ffc97;">Instant
                Pitch Booking</span>
            </div>
            <h1
              style="font-family:'Outfit',sans-serif; font-size:2.15rem; font-weight:800; color:#fff; line-height:1.15; letter-spacing:-0.025em; margin:0 0 12px 0;">
              Book Your Game.<br /><span style="color:#62df7d;">Own the Turf.</span>
            </h1>
            <p
              style="font-family:'Inter',sans-serif; font-size:0.875rem; color:rgba(255,255,255,0.7); line-height:1.65; max-width:270px; margin:0 0 20px 0;">
              One login for everyone — players, squad captains, and arena managers. Your role is detected automatically.
            </p>
            <!-- 3 feature rows -->
            <div style="display:flex; flex-direction:column; gap:10px;">
              <div
                style="display:flex; align-items:center; gap:12px; padding:12px; border-radius:14px; background:rgba(255,255,255,0.07);">
                <div
                  style="width:32px; height:32px; border-radius:10px; background:rgba(0,135,58,0.55); display:flex; align-items:center; justify-content:center; flex-shrink:0;">
                  <span class="material-symbols-outlined" style="font-size:16px; color:#62df7d;">verified</span>
                </div>
                <div>
                  <div style="font-family:'Inter',sans-serif; font-size:0.8rem; font-weight:700; color:#fff;">450+
                    Verified Grounds</div>
                  <div style="font-family:'Inter',sans-serif; font-size:0.71rem; color:rgba(255,255,255,0.5);">FIFA
                    &amp; Box Cricket certified</div>
                </div>
              </div>
              <div
                style="display:flex; align-items:center; gap:12px; padding:12px; border-radius:14px; background:rgba(255,255,255,0.07);">
                <div
                  style="width:32px; height:32px; border-radius:10px; background:rgba(0,105,71,0.55); display:flex; align-items:center; justify-content:center; flex-shrink:0;">
                  <span class="material-symbols-outlined"
                    style="font-size:16px; color:#6ffbbe;">account_balance_wallet</span>
                </div>
                <div>
                  <div style="font-family:'Inter',sans-serif; font-size:0.8rem; font-weight:700; color:#fff;">Instant
                    UPI Pay</div>
                  <div style="font-family:'Inter',sans-serif; font-size:0.71rem; color:rgba(255,255,255,0.5);">Auto slot
                    lock &amp; digital pass</div>
                </div>
              </div>
              <div
                style="display:flex; align-items:center; gap:12px; padding:12px; border-radius:14px; background:rgba(255,255,255,0.07);">
                <div
                  style="width:32px; height:32px; border-radius:10px; background:rgba(0,135,58,0.55); display:flex; align-items:center; justify-content:center; flex-shrink:0;">
                  <span class="material-symbols-outlined"
                    style="font-size:16px; color:#62df7d;">admin_panel_settings</span>
                </div>
                <div>
                  <div style="font-family:'Inter',sans-serif; font-size:0.8rem; font-weight:700; color:#fff;">One Login
                    for All Roles</div>
                  <div style="font-family:'Inter',sans-serif; font-size:0.71rem; color:rgba(255,255,255,0.5);">Admin
                    &amp; Player — same door</div>
                </div>
              </div>
            </div>
          </div>

          <!-- Testimonial -->
          <div
            style="position:relative; z-index:1; padding:16px; border-radius:14px; background:rgba(255,255,255,0.09); border:1px solid rgba(255,255,255,0.1); margin-top:20px;">
            <div style="display:flex; gap:2px; margin-bottom:8px;">
              <span class="material-symbols-outlined"
                style="font-size:13px; color:#fbbf24; font-variation-settings:'FILL' 1;">star</span>
              <span class="material-symbols-outlined"
                style="font-size:13px; color:#fbbf24; font-variation-settings:'FILL' 1;">star</span>
              <span class="material-symbols-outlined"
                style="font-size:13px; color:#fbbf24; font-variation-settings:'FILL' 1;">star</span>
              <span class="material-symbols-outlined"
                style="font-size:13px; color:#fbbf24; font-variation-settings:'FILL' 1;">star</span>
              <span class="material-symbols-outlined"
                style="font-size:13px; color:#fbbf24; font-variation-settings:'FILL' 1;">star</span>
            </div>
            <p
              style="font-family:'Inter',sans-serif; font-size:0.78rem; font-style:italic; color:rgba(255,255,255,0.8); line-height:1.55; margin:0 0 10px 0;">
              "We lock prime Friday 8 PM slots in under 40 seconds — no more endless phone calls to turf owners."
            </p>
            <div style="display:flex; align-items:center; gap:8px;">
              <div
                style="width:30px; height:30px; border-radius:50%; background:rgba(255,255,255,0.15); display:flex; align-items:center; justify-content:center; font-family:'Inter',sans-serif; font-size:11px; font-weight:700; color:#fff;">
                DK</div>
              <div>
                <div style="font-family:'Inter',sans-serif; font-size:0.74rem; font-weight:700; color:#fff;">Dhiraj
                  Kapoor</div>
                <div style="font-family:'Inter',sans-serif; font-size:0.67rem; color:#62df7d;">Captain • Thunder
                  Strikers FC</div>
              </div>
            </div>
          </div>
        </div>

        <!-- RIGHT LOGIN CARD -->
        <div style="display:flex; align-items:center; justify-content:center;">
          <div class="login-card"
            style="width:100%; max-width:430px; background:#fff; border-radius:20px; box-shadow:0 8px 40px rgba(0,0,0,0.1); border:1px solid rgba(0,0,0,0.06); padding:32px;">

            <!-- Header -->
            <div style="margin-bottom:24px;">
              <div style="display:flex; align-items:center; gap:10px; margin-bottom:14px;">
                <div
                  style="width:36px; height:36px; border-radius:12px; background:#006b2c; display:flex; align-items:center; justify-content:center; color:#fff; font-family:'Inter',sans-serif; font-weight:700; font-size:13px; box-shadow:0 2px 6px rgba(0,107,44,0.3);">
                  TB</div>
                <span
                  style="font-family:'Inter',sans-serif; font-size:0.67rem; font-weight:700; text-transform:uppercase; letter-spacing:0.1em; color:#006b2c; background:#dcfce7; padding:3px 10px; border-radius:999px;">Secure
                  Portal</span>
              </div>
              <h2
                style="font-family:'Outfit',sans-serif; font-size:1.65rem; font-weight:800; color:#0b1c30; line-height:1.2; letter-spacing:-0.02em; margin:0 0 8px 0;">
                Welcome Back</h2>
              <p style="font-family:'Inter',sans-serif; font-size:0.84rem; color:#565e74; margin:0; line-height:1.6;">
                Enter your credentials — players and admins use this same login page.
              </p>
                  <!-- Server alerts -->
            <%
              String error = (String) request.getAttribute("error");
              if (error == null || error.isEmpty()) {
                  error = request.getParameter("error");
              }
              String redirectParam = request.getParameter("redirect");
              String success = (String) session.getAttribute("success");
              if (success != null) session.removeAttribute("success");
            %>
              <% if (error != null && !error.isEmpty()) { %>
                <div id="error-alert"
                  style="margin-bottom:18px; padding:14px; border-radius:14px; background:#fff1f2; border:1px solid #fecaca; display:flex; align-items:flex-start; gap:10px;">
                  <span class="material-symbols-outlined"
                    style="font-size:20px; color:#ef4444; flex-shrink:0; margin-top:1px;">error</span>
                  <div style="flex:1;">
                    <p
                      style="font-family:'Inter',sans-serif; font-size:0.78rem; font-weight:700; color:#b91c1c; margin:0 0 2px 0;">
                      Access Restricted</p>
                    <p style="font-family:'Inter',sans-serif; font-size:0.77rem; color:#991b1b; margin:0;">
                      <%= error %>
                    </p>
                  </div>
                  <button type="button" onclick="document.getElementById('error-alert').style.display='none'"
                    style="background:none; border:none; cursor:pointer; color:#f87171; padding:0; display:flex;">
                    <span class="material-symbols-outlined" style="font-size:17px;">close</span>
                  </button>
                </div>
                <% } %>
                  <% if (success != null && !success.isEmpty()) { %>
                    <div
                      style="margin-bottom:18px; padding:14px; border-radius:14px; background:#f0fdf4; border:1px solid #bbf7d0; display:flex; align-items:flex-start; gap:10px;">
                      <span class="material-symbols-outlined"
                        style="font-size:20px; color:#16a34a; flex-shrink:0; margin-top:1px;">check_circle</span>
                      <p style="font-family:'Inter',sans-serif; font-size:0.82rem; color:#166534; margin:0;">
                        <%= success %>
                      </p>
                    </div>
                    <% } %>

                      <!-- Form -->
                      <form action="<%= request.getContextPath() %>/login" method="POST" id="login-form"
                        style="display:flex; flex-direction:column; gap:16px;">
                        <% if (redirectParam != null && !redirectParam.isEmpty()) { %>
                          <input type="hidden" name="redirect" value="<%= redirectParam.replace("\"", "&quot;") %>"/>
                        <% } %>

                        <!-- Username -->
                        <div class="field-group" style="display:flex; flex-direction:column; gap:6px;">
                          <label for="identity-input"
                            style="font-family:'Inter',sans-serif; font-size:0.8rem; font-weight:600; color:#0b1c30;">
                            Email</label>
                          <div class="field-box"
                            style="position:relative; display:flex; align-items:center; border-radius:12px; border:1px solid #d1d5db; background:#f9fafb; transition:all 0.2s;">
                            <span class="material-symbols-outlined"
                              style="position:absolute; left:14px; font-size:18px; color:#9ca3af; pointer-events:none;">person</span>
                            <input id="identity-input" name="identity" type="text" placeholder="" required
                              autocomplete="username" value="<%= request.getParameter(" identity") !=null ?
                              request.getParameter("identity") : "" %>"
                            style="width:100%; height:46px; padding:0 14px 0 42px; font-family:'Inter',sans-serif;
                            font-size:0.875rem; color:#111827; background:transparent; border:none; outline:none;
                            border-radius:12px;"/>
                          </div>
                        </div>

                        <!-- Password -->
                        <div class="field-group" style="display:flex; flex-direction:column; gap:6px;">
                          <div style="display:flex; align-items:center; justify-content:space-between;">
                            <label for="password-input"
                              style="font-family:'Inter',sans-serif; font-size:0.8rem; font-weight:600; color:#0b1c30;">Password</label>
                            <span onclick="alert('Contact your administrator to reset your password.')"
                              style="font-family:'Inter',sans-serif; font-size:0.77rem; font-weight:600; color:#006b2c; cursor:pointer;">Forgot
                              Password?</span>
                          </div>
                          <div class="field-box"
                            style="position:relative; display:flex; align-items:center; border-radius:12px; border:1px solid #d1d5db; background:#f9fafb; transition:all 0.2s;">
                            <span class="material-symbols-outlined"
                              style="position:absolute; left:14px; font-size:18px; color:#9ca3af; pointer-events:none;">lock</span>
                            <input id="password-input" name="password" type="password" placeholder="••••••••••" required
                              autocomplete="current-password"
                              style="width:100%; height:46px; padding:0 48px 0 42px; font-family:'Inter',sans-serif; font-size:0.875rem; color:#111827; background:transparent; border:none; outline:none; border-radius:12px;" />
                            <button type="button" onclick="togglePassword()"
                              style="position:absolute; right:14px; background:none; border:none; cursor:pointer; color:#9ca3af; padding:0; display:flex; align-items:center;">
                              <span class="material-symbols-outlined" id="pwd-eye-icon"
                                style="font-size:20px;">visibility</span>
                            </button>
                          </div>
                        </div>

                        <!-- Remember me -->
                        <label style="display:flex; align-items:center; gap:8px; cursor:pointer;">
                          <input type="checkbox" checked
                            style="width:16px; height:16px; accent-color:#006b2c; cursor:pointer;" />
                          <span style="font-family:'Inter',sans-serif; font-size:0.8rem; color:#565e74;">Keep me signed
                            in for 30 days</span>
                        </label>

                        <!-- Submit button -->
                        <button type="submit" id="submit-btn"
                          style="width:100%; height:48px; border-radius:12px; background:#006b2c; color:#fff; border:none; cursor:pointer; font-family:'Inter',sans-serif; font-size:0.9rem; font-weight:700; display:flex; align-items:center; justify-content:center; gap:8px; box-shadow:0 4px 14px rgba(0,107,44,0.3); transition:all 0.2s; margin-top:4px;">
                          <span class="material-symbols-outlined" style="font-size:19px;">login</span>
                          Sign In to TurfBook
                        </button>

                      </form>

                      <!-- Sign up link -->
                      <div style="text-align:center; margin-top:22px; padding-top:18px; border-top:1px solid #f0f0f0;">
                        <p style="font-family:'Inter',sans-serif; font-size:0.84rem; color:#565e74; margin:0;">
                          Don't have an account?
                          <a href="<%= request.getContextPath() %>/register.jsp"
                            style="color:#006b2c; font-family:'Inter',sans-serif; font-weight:700; text-decoration:none; display:inline-flex; align-items:center; gap:3px; margin-left:4px;">
                            Create Account
                            <span class="material-symbols-outlined" style="font-size:14px;">arrow_forward</span>
                          </a>
                        </p>
                      </div>

          </div>
        </div>

      </div>
    </main>

    <!-- FOOTER -->
    <footer style="padding:18px; text-align:center; font-family:'Inter',sans-serif; font-size:0.75rem; color:#9ca3af;">
      &copy; 2026 TurfBook &nbsp;&middot;&nbsp; Book Your Game. Own the Turf. &nbsp;&middot;&nbsp; MongoDB Real-Time
      Active
    </footer>

    <script>
      function togglePassword() {
        var p = document.getElementById('password-input');
        var i = document.getElementById('pwd-eye-icon');
        if (p.type === 'password') { p.type = 'text'; i.innerText = 'visibility_off'; }
        else { p.type = 'password'; i.innerText = 'visibility'; }
      }

      document.getElementById('login-form').addEventListener('submit', function () {
        var btn = document.getElementById('submit-btn');
        btn.innerHTML = '<span class="material-symbols-outlined" style="font-size:18px;animation:spin 0.9s linear infinite;">progress_activity</span>&nbsp;Signing in\u2026';
        btn.disabled = true;
        btn.style.opacity = '0.75';
      });

      /* Hide left panel on mobile */
      (function () {
        var style = document.createElement('style');
        style.textContent = '@media(max-width:768px){main>div{grid-template-columns:1fr!important;}main>div>div:first-child{display:none!important;}}';
        document.head.appendChild(style);
      })();
    </script>
    <script src="<%= request.getContextPath() %>/js/app.js"></script>
  </body>

  </html>