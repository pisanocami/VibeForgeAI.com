---
description: Branding — Design Tokens (colors, typography, spacing, radii, shadows)
---

Translate brand strategy into a system of tokens ready for product implementation.

## Steps
1) Color system
   - Primary, neutrals, semantic states (success, warning, error, info)
   - Light/dark pairs; contrast AA/AAA checks
2) Typography
   - Font families, scale (e.g., Major Third), line-height, weights
   - Usage map (display, headings, body, monospace)
3) Spacing & Sizing
   - 4/8pt grid, container widths, breakpoints
4) Radii & Elevation
   - Border radii scale, shadows/elevation levels
5) Motion
   - Durations, easing curves, interaction guidelines
6) Output
   - Save to: `project-logs/product/brand-tokens-{timestamp}.md`
   - Pair with `/design-and-styling` to wire tokens into Tailwind/theme

## Quality Gates
- Contrast tooling: see `project-logs/ux/contrast.json`
- AA at minimum for text/UI states
