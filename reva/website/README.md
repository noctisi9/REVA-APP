# REVA website (River prototype, hardened)

Static HTML/CSS/JS — no build step. Open `index.html` directly, or serve
the folder with any static host (Firebase Hosting, Netlify, etc.).

## What changed from the original prototype

- Removed unused Vite/React/TypeScript scaffold (`src/`, `public/`,
  `tsconfig.json`, the Node `package.json`) — none of it was actually
  loaded by the site, it was dead weight.
- Compressed and dimension-capped the images in `assets/img/`.
- Added a real favicon set (`favicon.ico`, 16/32/512px PNGs) and an Apple
  touch icon, generated from REVA's own brand mark.
- Added `robots.txt`, `sitemap.xml`, `llms.txt`, and a branded `404.html`.
- Added meta descriptions, canonical tags, Open Graph/Twitter card tags,
  and an OG share image (`assets/img/og-share.jpg`) to every page.
- Added breadcrumb navigation + JSON-LD (BreadcrumbList/WebSite schema).
- Added a working hamburger menu for narrow screens on the subpages'
  fixed nav bar (discovery/healing/community/legal pages) — the original
  just shrank text at breakpoints with no true mobile menu.
- Added a cookie-consent banner (main.js), and privacy.html, terms.html,
  cookies.html — none of these existed before, and the footer had no
  links to them.
- Fixed real issues found in the prototype:
  - index.html never actually loaded main.js — its own ripple button
    effects were silently broken.
  - The hero stats bar showed fabricated numbers ("27K+ trauma stories",
    "876K+ healing resources") presented as real metrics — replaced with
    honest, non-numeric claims. Swap in real figures once you have them.
  - The IG/X/Facebook icons in the hero footer linked to dead "#"
    anchors — Facebook now points at a placeholder page URL (update it
    in index.html once you have the real one); IG/X are marked "coming
    soon" instead of silently broken.

## Before you publish

- Replace "reva-app.com" in sitemap.xml, robots.txt, llms.txt, and every
  canonical/og:url tag with your real domain.
- Have privacy.html, terms.html, cookies.html reviewed — same
  placeholder structure as the app's legal pages.
- Update the Facebook URL placeholder once your page is live.
