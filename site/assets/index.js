(() => {
  const SYNTAX_STORAGE_KEY = "html_of_jsx.docs.syntax";
  const SYNTAX_QUERY_KEY = "syntax";
  const THEME_STORAGE_KEY = "html_of_jsx.docs.theme";
  const DEFAULT_SYNTAX = "reason";
  const root = document.documentElement;
  const syntaxToggleEl = document.querySelector(".syntax-toggle");
  const syntaxControls = [
    ...document.querySelectorAll(".syntax-toggle [data-doc-syntax]"),
    ...document.querySelectorAll(".doc-code-pair__tab[data-doc-syntax]"),
  ];
  const themeToggleButton = document.querySelector("[data-doc-theme-toggle]");
  const copyButtons = Array.from(document.querySelectorAll("[data-doc-copy]"));
  const navToggle = document.getElementById("nav-toggle");
  const sidebarEl = document.getElementById("doc-sidebar");
  const hamburgerLabel = document.querySelector(".nav-hamburger");

  const normalizeSyntax = (value) =>
    value === "mlx" || value === "reason" ? value : null;

  // Tracks whether the current URL advertises ?syntax=. Updated on init and
  // whenever updateSyntaxQueryParam rewrites history. Used by the document
  // click handler to short-circuit before walking the DOM with closest().
  let currentUrlHasSyntax =
    window.location.search.indexOf(SYNTAX_QUERY_KEY + "=") !== -1;

  const updateSyntaxQueryParam = (syntax) => {
    try {
      const url = new URL(window.location.href);
      // Only keep an existing ?syntax= param canonical. If the URL doesn't
      // already advertise a syntax, leave it clean — localStorage handles
      // persistence, and we don't want to pollute every URL after a toggle.
      if (!url.searchParams.has(SYNTAX_QUERY_KEY)) return;
      if (url.searchParams.get(SYNTAX_QUERY_KEY) === syntax) return;
      url.searchParams.set(SYNTAX_QUERY_KEY, syntax);
      window.history.replaceState(window.history.state, "", url.toString());
      currentUrlHasSyntax = true;
    } catch (_error) {}
  };

  let activeSyntax = DEFAULT_SYNTAX;

  const setActiveSyntax = (value, { updateQuery = true } = {}) => {
    const syntax = normalizeSyntax(value) || DEFAULT_SYNTAX;
    activeSyntax = syntax;
    root.setAttribute("data-doc-syntax", syntax);

    if (syntaxToggleEl) {
      syntaxToggleEl.setAttribute("data-active-syntax", syntax);
    }

    syntaxControls.forEach((button) => {
      const isActive = button.getAttribute("data-doc-syntax") === syntax;
      button.classList.toggle("is-active", isActive);
      button.setAttribute("aria-pressed", isActive ? "true" : "false");
    });

    if (updateQuery) {
      updateSyntaxQueryParam(syntax);
    }
  };

  // The inline <head> script already resolved the syntax from ?syntax= and
  // localStorage and set data-doc-syntax + data-syntax-ready before paint.
  // Sync the toggle UI to that value without overwriting the query param.
  const initialSyntax =
    normalizeSyntax(root.getAttribute("data-doc-syntax")) || DEFAULT_SYNTAX;
  setActiveSyntax(initialSyntax, { updateQuery: false });

  const persistAndApplySyntax = (value) => {
    const nextSyntax = normalizeSyntax(value) || DEFAULT_SYNTAX;
    try {
      localStorage.setItem(SYNTAX_STORAGE_KEY, nextSyntax);
    } catch (_error) {}
    setActiveSyntax(nextSyntax);
  };

  syntaxControls.forEach((button) => {
    button.addEventListener("click", () => {
      persistAndApplySyntax(button.getAttribute("data-doc-syntax"));
    });
  });

  const prefersDarkScheme = window.matchMedia("(prefers-color-scheme: dark)");

  const normalizeTheme = (value) => (value === "light" || value === "dark" ? value : null);

  const systemTheme = () => (prefersDarkScheme.matches ? "dark" : "light");

  const effectiveTheme = () => {
    const activeTheme = normalizeTheme(root.getAttribute("data-doc-theme"));
    if (activeTheme) {
      return activeTheme;
    }

    return systemTheme();
  };

  const updateThemeToggle = () => {
    if (!themeToggleButton) {
      return;
    }

    const theme = effectiveTheme();
    const nextTheme = theme === "dark" ? "light" : "dark";
    themeToggleButton.setAttribute("data-theme", theme);
    themeToggleButton.setAttribute("aria-pressed", theme === "dark" ? "true" : "false");
    themeToggleButton.setAttribute("aria-label", `Switch to ${nextTheme} theme`);
    themeToggleButton.setAttribute("title", `Switch to ${nextTheme} theme`);
  };

  const applyTheme = (theme) => {
    if (theme === "light" || theme === "dark") {
      root.setAttribute("data-doc-theme", theme);
    }

    updateThemeToggle();
  };

  const rememberedTheme = normalizeTheme(localStorage.getItem(THEME_STORAGE_KEY));
  applyTheme(rememberedTheme ?? systemTheme());

  const onSystemThemeChange = () => {
    if (!normalizeTheme(localStorage.getItem(THEME_STORAGE_KEY))) {
      applyTheme(systemTheme());
    }
  };

  if (typeof prefersDarkScheme.addEventListener === "function") {
    prefersDarkScheme.addEventListener("change", onSystemThemeChange);
  } else {
    prefersDarkScheme.addListener(onSystemThemeChange);
  }

  if (themeToggleButton) {
    themeToggleButton.addEventListener("click", () => {
      const nextTheme = effectiveTheme() === "dark" ? "light" : "dark";
      localStorage.setItem(THEME_STORAGE_KEY, nextTheme);
      applyTheme(nextTheme);
    });
  }

  const copyText = async (text) => {
    if (navigator.clipboard && window.isSecureContext) {
      await navigator.clipboard.writeText(text);
      return;
    }

    const textarea = document.createElement("textarea");
    textarea.value = text;
    textarea.style.position = "fixed";
    textarea.style.opacity = "0";
    document.body.appendChild(textarea);
    textarea.focus();
    textarea.select();
    document.execCommand("copy");
    document.body.removeChild(textarea);
  };

  // Same-origin link clicks should preserve `?syntax=` so the URL stays
  // canonical across navigations — but only when the *current* URL already
  // advertises a syntax. If the user is on a clean URL, we leave outgoing
  // links alone; localStorage handles persistence on the next page.
  document.addEventListener("click", (event) => {
    // Hot path: if the current URL doesn't have ?syntax=, we never forward it
    // to outgoing links. Bail before any DOM traversal.
    if (!currentUrlHasSyntax) return;
    if (event.defaultPrevented) return;
    if (event.button !== 0) return;
    if (event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return;

    const anchor = event.target?.closest?.("a[href]");
    if (!anchor) return;
    if (anchor.target && anchor.target !== "" && anchor.target !== "_self") return;
    if (anchor.hasAttribute("download")) return;

    // Cheap pre-filters before constructing a URL: skip pure-fragment
    // navigations (so smooth-scroll for `#section` keeps working) and skip
    // anchors whose href already advertises a syntax param.
    const rawHref = anchor.getAttribute("href");
    if (!rawHref || rawHref[0] === "#") return;
    if (rawHref.indexOf(SYNTAX_QUERY_KEY + "=") !== -1) return;

    let destination;
    try {
      destination = new URL(anchor.href, window.location.href);
    } catch (_error) {
      return;
    }

    if (destination.origin !== window.location.origin) return;
    if (destination.searchParams.has(SYNTAX_QUERY_KEY)) return;

    // Skip same-document navigations (e.g. `<a href="page#frag">` from the
    // same page) so the browser performs an in-page scroll instead of a full
    // reload triggered by the new query param.
    if (
      destination.pathname === window.location.pathname &&
      destination.search === window.location.search
    ) {
      return;
    }

    destination.searchParams.set(SYNTAX_QUERY_KEY, activeSyntax);
    anchor.href = destination.toString();
  });

  copyButtons.forEach((button) => {
    button.addEventListener("click", async () => {
      const figure = button.closest(".doc-code");
      const code = figure?.querySelector(".doc-code__code");
      const text = code?.innerText ?? "";
      if (!text) return;

      const label = button.querySelector(".doc-code__copy-label");
      const originalLabel = label?.textContent || "Copy";

      try {
        await copyText(text.trimEnd());
        if (label) {
          label.textContent = "Copied";
        }
        button.classList.add("is-copied");
      } catch {
        if (label) {
          label.textContent = "Failed";
        }
      }

      window.setTimeout(() => {
        if (label) {
          label.textContent = originalLabel;
        }
        button.classList.remove("is-copied");
      }, 1200);
    });
  });

  // Mobile drawer: ARIA wiring, focus management, link-click close, Esc close.
  if (navToggle && sidebarEl && hamburgerLabel) {
    const syncDrawerAria = () => {
      const open = navToggle.checked;
      hamburgerLabel.setAttribute("aria-expanded", open ? "true" : "false");
      sidebarEl.setAttribute("aria-hidden", open ? "false" : "true");
    };

    const closeDrawer = () => {
      if (navToggle.checked) {
        navToggle.checked = false;
        syncDrawerAria();
      }
    };

    // Make the label keyboard-activatable as a button.
    hamburgerLabel.setAttribute("role", "button");
    hamburgerLabel.setAttribute("tabindex", "0");
    syncDrawerAria();

    hamburgerLabel.addEventListener("keydown", (event) => {
      if (event.key === "Enter" || event.key === " ") {
        event.preventDefault();
        navToggle.checked = !navToggle.checked;
        syncDrawerAria();
      }
    });

    navToggle.addEventListener("change", syncDrawerAria);

    // Close on Esc
    document.addEventListener("keydown", (event) => {
      if (event.key === "Escape" && navToggle.checked) {
        closeDrawer();
        // Return focus to the hamburger
        hamburgerLabel.focus();
      }
    });

    // Close on sidebar link click (so navigation feels right on mobile)
    sidebarEl.addEventListener("click", (event) => {
      const anchor = event.target?.closest?.("a[href]");
      if (anchor) {
        closeDrawer();
      }
    });

    // Close drawer when transitioning back to desktop width.
    const desktopMq = window.matchMedia("(min-width: 881px)");
    const onDesktopChange = () => {
      if (desktopMq.matches) closeDrawer();
    };
    if (typeof desktopMq.addEventListener === "function") {
      desktopMq.addEventListener("change", onDesktopChange);
    } else {
      desktopMq.addListener(onDesktopChange);
    }
  }
})();
