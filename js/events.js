(function () {
  "use strict";

  // Single source for event names, URLs, and newest-first ordering on every page.
  // Load with defer so these menus are ready before the legacy mobile nav is cloned.
  var label = "All Events";
  var events = [
    { name: "AdvML-Frontiers '27", url: "/satml2027/" },
    { name: "AdvML-Frontiers '26", url: "/past/colm2026/" },
    { name: "AdvML-Frontiers '24", url: "/past/neurips2024/" },
    { name: "AdvML-Frontiers '23", url: "/past/icml2023/" },
    { name: "AdvML-Frontiers '22", url: "/past/icml2022/" }
  ];

  document.querySelectorAll("[data-events-menu]").forEach(function (container) {
    var isDetails = container.getAttribute("data-events-menu") === "details";
    var menu = isDetails ? document.createElement("details") : container;
    var toggle = document.createElement(isDetails ? "summary" : "a");
    var list = document.createElement("ul");

    toggle.textContent = label;
    list.setAttribute("aria-label", label);

    if (isDetails) {
      menu.className = "past-events-menu";
    } else {
      container.classList.add("dropdown", "menu-has-children");
      toggle.href = "/satml2027/";
      toggle.setAttribute("aria-haspopup", "true");
      // Align the last desktop dropdown with the navbar's right edge.
      list.style.left = "auto";
      list.style.right = "0";
    }

    events.forEach(function (event) {
      var item = document.createElement("li");
      var link = document.createElement("a");
      link.setAttribute("href", event.url);
      link.textContent = event.name;
      item.appendChild(link);
      list.appendChild(item);
    });

    container.replaceChildren();
    menu.appendChild(toggle);
    menu.appendChild(list);
    if (isDetails) {
      container.appendChild(menu);
    }
  });
})();
