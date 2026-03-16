(() => {
  const STORAGE_KEY = "html_of_jsx.docs.syntax";
  const DEFAULT_SYNTAX = "reason";
  const root = document.documentElement;
  const syntaxButtons = Array.from(document.querySelectorAll("[data-doc-syntax]"));
  const copyButtons = Array.from(document.querySelectorAll("[data-doc-copy]"));

  const normalizeSyntax = (value) => (value === "mlx" ? "mlx" : "reason");

  const setActiveSyntax = (value) => {
    const syntax = normalizeSyntax(value);
    root.setAttribute("data-doc-syntax", syntax);

    syntaxButtons.forEach((button) => {
      const isActive = button.getAttribute("data-doc-syntax") === syntax;
      button.classList.toggle("is-active", isActive);
      button.setAttribute("aria-pressed", isActive ? "true" : "false");
    });
  };

  const rememberedSyntax = normalizeSyntax(localStorage.getItem(STORAGE_KEY));
  setActiveSyntax(rememberedSyntax || DEFAULT_SYNTAX);

  syntaxButtons.forEach((button) => {
    button.addEventListener("click", () => {
      const nextSyntax = normalizeSyntax(button.getAttribute("data-doc-syntax"));
      localStorage.setItem(STORAGE_KEY, nextSyntax);
      setActiveSyntax(nextSyntax);
    });
  });

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
})();
