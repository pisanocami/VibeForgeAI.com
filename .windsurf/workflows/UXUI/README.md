---
description: UX/UI — Índice de Workflows (a11y, contraste, heurísticas, revisión de componentes)
---

# UX/UI — Índice de Workflows

Este directorio centraliza workflows de UX/UI. Reúne checklists ejecutables y enlaces a workflows existentes en otras carpetas.

## Contenido

- Accesibilidad (a11y)
- Contraste y color
- Heurísticas de usabilidad
- Revisión de componentes y estados
- Performance percibida (UX)
- Integración con Design Tokens

## Workflows en este directorio

- `a11y-checklist.md` — Checklist canónico y ejecutable para evaluar accesibilidad.
- `behance-extract-to-tokens.md` — Extraer tokens y artefactos desde un link de Behance (tokens JSON, CSS variables, Tailwind, patrones).

## Workflows relacionados en otras carpetas

- `Development/design-and-styling.md` — Tokens de diseño → Tailwind/shadcn, contraste, artefactos y status JSON.
  - Ruta: `/.windsurf/workflows/Development/design-and-styling.md`
- `Optimization/mejorar-ux-ui.md` — Mejora de UX/UI con checklist, a11y y pautas de contenido.
  - Ruta: `/.windsurf/workflows/Optimization/mejorar-ux-ui.md`

## Cómo usar este índice

1. Empieza por `a11y-checklist.md` para una evaluación rápida y objetiva.
2. Si necesitas alinear diseño con sistema de tokens, usa `Development/design-and-styling.md`.
3. Para mejoras amplias de UX/UI (flujo, copy y microinteracciones), usa `Optimization/mejorar-ux-ui.md`.

## Convenciones

- Estructura YAML con `description` en el frontmatter.
- Instrucciones claras y accionables, con secciones numeradas.
- Usa la anotación `// turbo` solo para pasos 100% seguros de auto-ejecutar (p. ej., comandos de lectura/diagnóstico).

## Roadmap de UX/UI (sugerido)

- a11y: navegación por teclado, foco visible, roles ARIA, landmarks, contraste.
- UX: estados vacíos, errores manejados, loading skeletons, rendimiento percibido.
- UI: coherencia de espaciados, tipografía, densidad, sombras, elevación.
- Contenido: tono, jerarquía, escaneabilidad, i18n.

