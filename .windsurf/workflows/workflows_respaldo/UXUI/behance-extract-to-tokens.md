---
description: UX/UI — Extraer tokens y artefactos desde un link de Behance hacia el proyecto (tokens JSON, CSS variables, Tailwind, patrones)
---

# UX/UI — Behance → Tokens y Artefactos de Diseño

Este workflow toma un link de Behance y sistematiza la extracción de colores, tipografías, espaciados, sombras, radii, iconografía, patrones UI y wireframes. Genera artefactos listos para usar en un proyecto web (CSS variables, tokens.json, Tailwind, documentación de patrones).

## Entradas requeridas

- `behance_url`: URL del proyecto/portfolio en Behance
- `project_slug`: identificador corto del proyecto (para rutas y nombres de archivo)
- (Opcional) `brand_primary_font`, `brand_secondary_font`
- (Opcional) `output_root` (por defecto: `docs/projects/{project_slug}/design/`)

## Artefactos de salida

- `docs/projects/{project_slug}/design/sources/` — capturas/exports del Behance
- `docs/projects/{project_slug}/design/tokens/tokens.json` — Design Tokens canonizados
- `docs/projects/{project_slug}/design/tokens/css-variables.css` — Variables CSS generadas
- `docs/projects/{project_slug}/design/tokens/tailwind.config.extend.json` — Extensiones para Tailwind
- `docs/projects/{project_slug}/design/patterns/*.md` — Patrones (Cards, Lists, Forms, Nav, Modals, Hero, Empty states)
- `docs/projects/{project_slug}/design/wireframes/` — Wireframes/flows referenciados

## Nota sobre acceso a Behance

- Behance API puede requerir API Key y/o estar limitada. Este workflow es híbrido:
  - Vía web manual/semi-automática: export de imágenes/slices y lectura estructurada.
  - Vía herramientas locales: extracción de paletas y análisis de texto/medidas con apoyo de utilidades.

## 1) Captura de fuentes del Behance

- Abre `behance_url` y localiza secciones clave: branding, UI kit, tipografía, paleta, componentes, layouts, wireframes.
- Exporta o captura en alta resolución (PNG/JPEG) las láminas relevantes. Nombra archivos con prefijos por categoría, por ejemplo:
  - `palette_*.png`, `typography_*.png`, `components_button_*.png`, `components_card_*.png`, `layout_grid_*.png`, `wireframe_checkout_*.png`.
- Guarda en `docs/projects/{project_slug}/design/sources/`.

## 2) Extracción de paleta y colores de estado

- Usa una herramienta de paletas (p. ej., Adobe Color, ColorThief, Vibrant) para extraer:
  - `primary`, `secondary`, `accent`, `neutral`
  - Estados: `success`, `warning`, `error`, `info`
  - Superficies: `bg`, `muted`, `card`, `popover`
- Valida contraste por WCAG AA en texto normal y grande.
- Canoniza nombres de tokens: `color.{role}.{scale}` (ej: `color.primary.500`).

## 3) Tipografía y escalas

- Identifica familias tipográficas en las láminas (titulares, cuerpo, mono si existe) y pesos utilizados.
- Define escalas: `font.size` (ej., 12, 14, 16, 20, 24, 32, 48), `line.height`, `letter.spacing`, `font.weight`.
- Mapea estilos: `display`, `h1…h6`, `lead`, `body`, `caption`, `button`.

## 4) Espaciado, radii, sombras, bordes

- Deriva escalas de espaciado (4, 8, 12, 16, 24, 32…) y normalízalas.
- Define `radius.{sm|md|lg|xl|full}` a partir de ejemplos de componentes.
- Define `shadow.{sm|md|lg}` según elevaciones observadas.
- Define `border.width` y `border.color` por estados.

## 5) Componentes y patrones

- Catalogar componentes clave: Buttons, Inputs, Selects, Cards, Modals, Alerts, Nav, Tabs, Tables, Badges, Chips.
- Para cada componente, documentar estados: default, hover, focus, active, disabled, error, loading.
- Extraer patrones: List/Detail, Auth, Checkout, Search, Empty states.
- Documentar en `docs/projects/{project_slug}/design/patterns/*.md` con screenshots y tokens asociados.

## 6) Wireframes y flujos

- Identificar wireframes/flows en Behance (si existen) y exportarlos a `wireframes/`.
- Anotar entradas/salidas, estados vacíos, errores, loaders.

## 7) Generación de tokens y artefactos

- Construye `tokens.json` (W3C Design Tokens style) con namespaces:
  - `color`, `font`, `size` (espaciados), `radius`, `shadow`, `border`, `opacity`, `z`, `duration`.
- Genera `css-variables.css` con `:root { --color-primary-500: #... }`.
- Genera `tailwind.config.extend.json` para integrar escalas en Tailwind.

## 8) Validación a11y y consistencia

- Valida contraste y estados con el workflow `UXUI/a11y-checklist.md`.
- Prueba tokens en 2 temas (light/dark) si aplica.

## 9) Entrega e integración en el proyecto

- Integra CSS variables en la app y extiende Tailwind.
- Publica documentos de patrones y wireframes en `docs/`.

## Estructura de carpetas (sugerida)

```
docs/projects/{project_slug}/design/
  sources/
  tokens/
    tokens.json
    css-variables.css
    tailwind.config.extend.json
  patterns/
    buttons.md
    forms.md
    cards.md
    navigation.md
    modals.md
    empty-states.md
  wireframes/
```

// turbo
## Comandos — Generar archivos base (seguros)

- Crear estructura base de carpetas y archivos vacíos para comenzar:

```powershell
# Sustituye <slug>
$newRoot = "docs/projects/<slug>/design"
mkdir -Force "$newRoot/sources" | Out-Null
mkdir -Force "$newRoot/tokens" | Out-Null
mkdir -Force "$newRoot/patterns" | Out-Null
mkdir -Force "$newRoot/wireframes" | Out-Null

# Artefactos iniciales
"{}" | Out-File -Encoding utf8 "$newRoot/tokens/tokens.json"
":root {\n}\n" | Out-File -Encoding utf8 "$newRoot/tokens/css-variables.css"
"{\n  \"theme\": {\n    \"extend\": {}\n  }\n}\n" | Out-File -Encoding utf8 "$newRoot/tokens/tailwind.config.extend.json"
```

## Plantillas de salida

- `tokens.json` (ejemplo mínimo):

```json
{
  "$schema": "https://design-tokens.org/schema.json",
  "color": {
    "primary": { "500": { "value": "#0057FF" } },
    "bg": { "base": { "value": "#FFFFFF" }, "muted": { "value": "#F7F7F8" } },
    "text": { "base": { "value": "#0A0A0A" }, "muted": { "value": "#6B7280" } }
  },
  "font": {
    "family": { "base": { "value": "Inter, system-ui, sans-serif" } },
    "size": { "base": { "value": "16px" }, "h1": { "value": "48px" } },
    "weight": { "regular": { "value": 400 }, "bold": { "value": 700 } }
  },
  "size": { "2": { "value": "8px" }, "4": { "value": "16px" }, "6": { "value": "24px" } },
  "radius": { "md": { "value": "8px" } },
  "shadow": { "md": { "value": "0 4px 12px rgba(0,0,0,0.08)" } }
}
```

- `css-variables.css` (ejemplo mínimo):

```css
:root {
  --color-primary-500: #0057FF;
  --color-bg-base: #FFFFFF;
  --color-text-base: #0A0A0A;
  --radius-md: 8px;
}
```

- `tailwind.config.extend.json` (ejemplo mínimo):

```json
{
  "theme": {
    "extend": {
      "colors": {
        "primary": {
          "500": "var(--color-primary-500)"
        },
        "bg": {
          "base": "var(--color-bg-base)"
        },
        "text": {
          "base": "var(--color-text-base)"
        }
      },
      "borderRadius": {
        "md": "var(--radius-md)"
      }
    }
  }
}
```

## Sugerencias y mejores prácticas

- Nombrar tokens por rol (semántico) antes que por color literal.
- Mantener una fuente de verdad en `tokens.json`; derivar CSS/Tailwind automáticamente.
- Versionar los artefactos en `docs/` con ejemplos visuales (antes/después).
- Referenciar acceso y derechos de uso de tipografías e imágenes del Behance.

## Integración con otros workflows

- `UXUI/a11y-checklist.md` — Validación de contraste y foco.
- `Development/design-and-styling.md` — Unión con sistema de diseño/tokens.
- `Optimization/mejorar-ux-ui.md` — Mejora holística y priorización de cambios.
