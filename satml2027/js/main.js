(function () {
  "use strict";

  var body = document.body;
  var header = document.getElementById("header");
  var nav = document.getElementById("nav-menu-container");
  var menuButton = document.getElementById("mobile-nav-toggle");
  var internalNavLinks = Array.from(document.querySelectorAll('.nav-link[href^="#"]'));

  function closeNavigation() {
    body.classList.remove("nav-open");
    menuButton.setAttribute("aria-expanded", "false");
    menuButton.setAttribute("aria-label", "Open navigation");
  }

  function updateScrollState() {
    var hasScrolled = window.scrollY > 48;
    header.classList.toggle("header-scrolled", hasScrolled);
  }

  menuButton.addEventListener("click", function () {
    var willOpen = !body.classList.contains("nav-open");
    body.classList.toggle("nav-open", willOpen);
    menuButton.setAttribute("aria-expanded", String(willOpen));
    menuButton.setAttribute("aria-label", willOpen ? "Close navigation" : "Open navigation");
  });

  nav.addEventListener("click", function (event) {
    if (event.target.closest('a[href^="#"]')) {
      closeNavigation();
    }
  });

  document.addEventListener("click", function (event) {
    if (body.classList.contains("nav-open") && !nav.contains(event.target) && !menuButton.contains(event.target)) {
      closeNavigation();
    }
  });

  document.addEventListener("keydown", function (event) {
    if (event.key === "Escape" && body.classList.contains("nav-open")) {
      closeNavigation();
      menuButton.focus();
    }
  });

  window.addEventListener("resize", function () {
    if (window.innerWidth > 1050) {
      closeNavigation();
    }
  });

  window.addEventListener("scroll", updateScrollState, { passive: true });
  updateScrollState();

  if ("IntersectionObserver" in window) {
    var sectionLinks = new Map();
    internalNavLinks.forEach(function (link) {
      var target = document.querySelector(link.getAttribute("href"));
      if (target) {
        sectionLinks.set(target.id, link);
      }
    });

    var observer = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (!entry.isIntersecting || !sectionLinks.has(entry.target.id)) {
          return;
        }
        internalNavLinks.forEach(function (link) {
          link.classList.remove("active");
        });
        sectionLinks.get(entry.target.id).classList.add("active");
      });
    }, {
      rootMargin: "-35% 0px -55% 0px",
      threshold: 0
    });

    sectionLinks.forEach(function (_link, id) {
      observer.observe(document.getElementById(id));
    });
  }
})();
