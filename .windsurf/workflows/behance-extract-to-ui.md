---
description: Extract design tokens and UI assets from a Behance link and inject them into the project (colors, type, spacing, radii, shadows, icons, images) with Tailwind and component theme updates
---

# Goal
Automate importing a Behance design into this codebase by extracting design tokens and assets, then generating:
- tokens.json (canonical)
- CSS variables (global)
- Tailwind config (theme extensions)
- component theme map (shadcn/ui or local UI kit)
- assets (logos, icons, previews)
- a styleguide page to preview tokens/components

# Inputs
- Behance URL (e.g., https://www.behance.net/gallery/XXXXXXXX/Project-Name)
- Optional: brand name, preferred font families (fallbacks), output prefix (e.g. "brand")

# Prereqs
- Node 18+
- pnpm or npm
- This repository checked out locally

# Steps
1) Prepare tooling
- __Install utilities__
  - color extraction: `node-vibrant` or `colorthief`
  - image download & parsing: `node-fetch`, `sharp`
  - HTML scraping: `playwright` or `puppeteer`
  - font info: `fontkit` (optional) or parse computed styles

// turbo
- __Install deps__
  - pnpm add -D playwright sharp node-vibrant node-fetch@3

2) Scrape Behance
- __Open the Behance URL headless__
  - Scroll to lazy-load images and text sections.
  - Collect:
    - hero/cover images
    - logo variants if present
    - UI screenshots
    - dominant color palettes per image (top 6)
    - any visible brand color swatches
    - headings/paragraph snippets to infer typography sizes/weights
- __Save raw findings__ to `.design-cache/behance.json` and assets under `public/brand/`.

3) Build tokens
- __Colors__
  - Merge palettes → pick base (primary, secondary, accent, success, warning, danger, neutral.{50..900})
  - Convert to hex and HSL.
- __Typography__
  - Map font families (primary, secondary), weights (400/500/600/700), sizes (`xs..7xl`), line-heights.
- __Spacing & Radii__
  - Create consistent scale (e.g. 0, 1, 2, 3, 4, 6, 8, 10, 12)
  - Radii: `sm, md, lg, xl, full`
- __Shadows__
  - Elevation set: `sm, md, lg, xl`
- __Output__
  - Write `src/design/tokens.json` with all categories.

4) Generate CSS variables
- __Create `src/styles/tokens.css`__
  - Define `:root { --color-primary: ... }` etc for all tokens.
  - Provide dark mode variants under `.dark { ... }` if found.

5) Tailwind integration
- __Update `tailwind.config.ts`__ to reference CSS variables or direct token values:
  - theme.colors: `primary`, `secondary`, `accent`, `success`, `warning`, `danger`, `neutral`
  - theme.extend.fontFamily, fontSize, borderRadius, boxShadow, spacing
- __Safelist__ key utilities if needed (badges, buttons states).

6) Component theme mapping
- __Map tokens to components__ (shadcn/ui or local):
  - Button variants (primary, secondary, ghost, danger)
  - Card surface/background/border
  - Badge variants
  - Inputs/selects focus ring and border
- __Create `src/design/theme.ts`__ exporting a map used by components.

7) Assets
- __Download hero/logo/icon images__ → `public/brand/`
- __Optimize__ with `sharp` (resize web previews, webp versions)

8) Styleguide page
- __Create `/styleguide` route__
  - Sections: Colors (swatches), Typography (scale), Spacing, Radii, Shadows, Components preview (buttons, cards, inputs, badges)

9) Apply & verify
- __Import `tokens.css`__ in `src/main.tsx` or global stylesheet.
- __Run dev server__ and review `/styleguide`.
- __Iterate mapping__ if colors/contrast are off.

# Commands (suggested)
- pnpm dlx playwright install
- pnpm add -D playwright sharp node-vibrant node-fetch@3
- pnpm dev

# Artifacts
- `src/design/tokens.json`
- `src/styles/tokens.css`
- `src/design/theme.ts`
- `public/brand/*`
- `src/pages/styleguide/Styleguide.tsx`

# Notes
- Behance blocks some scraping; use Playwright with realistic UA and throttled scrolling.
- Ensure WCAG AA contrast on primary text/background combinations.
- If fonts are proprietary, fall back to Google Fonts with similar metrics and document the substitution.
