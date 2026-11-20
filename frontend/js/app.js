/**
 * TurfBook Front-End Application Helpers
 * Connects Stitch UI widgets with Java Servlets and MongoDB APIs
 */

document.addEventListener('DOMContentLoaded', () => {
  initDateLimits();
});

function initDateLimits() {
  const dateInputs = document.querySelectorAll('input[type="date"]');
  const today = new Date().toISOString().split('T')[0];
  dateInputs.forEach(input => {
    if (!input.getAttribute('min')) {
      input.setAttribute('min', today);
    }
  });
}

function togglePassword(inputId, iconElement) {
  const input = document.getElementById(inputId);
  if (!input) return;
  
  if (input.type === 'password') {
    input.type = 'text';
    if (iconElement) iconElement.innerText = 'visibility_off';
  } else {
    input.type = 'password';
    if (iconElement) iconElement.innerText = 'visibility';
  }
}

function copyToClipboard(text, successMsg) {
  if (navigator.clipboard) {
    navigator.clipboard.writeText(text).then(() => {
      alert(successMsg || 'Copied to clipboard!');
    });
  } else {
    alert('Copied: ' + text);
  }
}

/**
 * Universal Scroll-Driven Animation Observer
 * Elements slide in dynamically from Left and Right as the user scrolls
 */
function initScrollSlideAnimations() {
  const animatedElements = document.querySelectorAll(
    '.scroll-slide-left, .scroll-slide-right, .scroll-slide-up, .scroll-slide-scale, [data-scroll-slide]'
  );

  if (!animatedElements || animatedElements.length === 0) return;

  // If IntersectionObserver is unsupported, reveal all
  if (!('IntersectionObserver' in window)) {
    animatedElements.forEach(el => el.classList.add('is-visible'));
    return;
  }

  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('is-visible');
      } else {
        // Reset when scrolled past bottom to allow smooth re-entry animation
        const rect = entry.target.getBoundingClientRect();
        if (rect.top > window.innerHeight) {
          entry.target.classList.remove('is-visible');
        }
      }
    });
  }, {
    root: null,
    rootMargin: '0px 0px -40px 0px',
    threshold: 0.1
  });

  animatedElements.forEach(el => {
    observer.observe(el);
  });
}

document.addEventListener('DOMContentLoaded', () => {
  initScrollSlideAnimations();
});

// Also trigger on window load & dynamic content updates
window.addEventListener('load', () => {
  initScrollSlideAnimations();
});

/**
 * Mobile Admin Drawer Navigation
 */
function toggleAdminSidebar() {
  const sidebar = document.getElementById('adminSidebar');
  const backdrop = document.getElementById('adminBackdrop');
  if (!sidebar) return;

  const isOpen = sidebar.classList.contains('open');
  if (isOpen) {
    sidebar.classList.remove('open');
    if (backdrop) backdrop.classList.remove('active');
    document.body.style.overflow = '';
  } else {
    sidebar.classList.add('open');
    if (backdrop) backdrop.classList.add('active');
    document.body.style.overflow = 'hidden';
  }
}

function closeAdminSidebar() {
  const sidebar = document.getElementById('adminSidebar');
  const backdrop = document.getElementById('adminBackdrop');
  if (sidebar) sidebar.classList.remove('open');
  if (backdrop) backdrop.classList.remove('active');
  document.body.style.overflow = '';
}

// Register PWA Service Worker
if ('serviceWorker' in navigator && window.location.protocol.startsWith('http')) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('./sw.js').catch(() => {
      // SW registered in scope
    });
  });
}


