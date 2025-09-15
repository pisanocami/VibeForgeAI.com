---
description: Canonical — Design & Styling Workflow (tokens → Tailwind/shadcn, contrast, artifacts, status JSON)
category: engineering
stability: stable
---

# Development — Design & Styling (AGI‑grade)

Directed (aplica a este workflow específico). Este blueprint cablea los tokens de AetherIQ (Aurora Indigo) a Tailwind y shadcn/ui con validaciones de contraste, artefactos y salidas machine‑readable.

Related: `/branding/brand-tokens`, `/optimization/mejorar-ux-ui`, `/optimization/optimizar-bundle`, `/general/agent`

## Objetivo
Asegurar que los tokens de marca (color, tipografía, spacing, radii, sombras y motion) están correctamente mapeados a Tailwind y al sistema de diseño (shadcn/ui), manteniendo accesibilidad (AA/AAA) y coherencia en toda la app.

## Entradas
- Tokens de AetherIQ (paleta Aurora Indigo, tipografía, radii, sombras)
- Archivos de estilo: `tailwind.config.ts`, `client/src/styles/globals.css`
- Componentes UI base (botón, input, card, alert, navbar)

## Preflight (Windows PowerShell) — seguro para auto‑ejecutar
// turbo
```powershell
$paths = @('project-logs','project-logs/design','project-logs/ux','docs/design')
$paths | ForEach-Object { if (!(Test-Path $_)) { New-Item -ItemType Directory -Path $_ | Out-Null } }
```

## Pasos
1) Fuente de verdad de tokens (verificación)
- Confirmar que los tokens de color existen en `tailwind.config.ts` bajo `theme.extend.colors` y que las variables CSS existen en `globals.css` (`:root` y `.dark`).
- Estándar: no usar hex “mágicos” en componentes; usar variables o clases Tailwind derivadas.

2) Tailwind — mapping de colores y escala
- En `tailwind.config.ts`, mapear la paleta Aurora Indigo y semánticos (success/warning/error/info). Ejemplo (documental):
```ts
// tailwind.config.ts (fragmento de ejemplo)
export default {
  theme: {
    extend: {
      colors: {
        brand: {
          50: '#EEF2FF', 100: '#E0E7FF', 200: '#C7D2FE', 300: '#A5B4FC',
          400: '#818CF8', 500: '#6366F1', 600: '#4F46E5', 700: '#4338CA',
          800: '#3730A3', 900: '#312E81'
        },
        success: { DEFAULT: '#16A34A' },
        warning: { DEFAULT: '#D97706' },
        error:   { DEFAULT: '#DC2626' },
        info:    { DEFAULT: '#0EA5E9' }
      }
    }
  }
}
```

3) CSS Variables — temas light/dark y shadcn
- En `client/src/styles/globals.css`, definir variables de tema y respetar `prefers-color-scheme`.
```css
:root {
  /* shadcn tokens base (HSL recomendado) */
  --background: 0 0% 100%;
  --foreground: 222 47% 11%;
  --primary: 241 83% 60%; /* ~#4F46E5 */
  --primary-foreground: 0 0% 100%;
  --muted: 220 14% 96%;
  --muted-foreground: 220 9% 46%;
  --card: 0 0% 100%;
  --card-foreground: 222 47% 11%;
  --border: 220 13% 91%;
  --ring: 241 83% 60%;
  --radius: 0.75rem; /* 12px */
}

.dark {
  --background: 222 47% 11%;
  --foreground: 210 20% 98%;
  --primary: 241 83% 66%;
  --primary-foreground: 222 47% 11%;
  --muted: 222 47% 17%;
  --muted-foreground: 215 16% 75%;
  --card: 222 47% 13%;
  --card-foreground: 210 20% 98%;
  --border: 222 47% 20%;
  --ring: 241 83% 66%;
  --radius: 0.75rem;
}
```
- Asegurar que el preset de shadcn mapea tokens a Tailwind: `colors: { primary: 'hsl(var(--primary))', ... }`.

4) Integración Tailwind ↔ shadcn
- Agregar mapeo semántico en `tailwind.config.ts`:
```ts
extend: {
  colors: {
    background: 'hsl(var(--background))',
    foreground: 'hsl(var(--foreground))',
    primary:    'hsl(var(--primary))',
    'primary-foreground': 'hsl(var(--primary-foreground))',
    muted:      'hsl(var(--muted))',
    'muted-foreground': 'hsl(var(--muted-foreground))',
    card:       'hsl(var(--card))',
    'card-foreground': 'hsl(var(--card-foreground))',
    border:     'hsl(var(--border))',
    ring:       'hsl(var(--ring))'
  },
  borderRadius: {
    lg: 'var(--radius)',
    md: 'calc(var(--radius) - 2px)',
    sm: 'calc(var(--radius) - 4px)'
  }
}
```

5) Tipografía, spacing y motion
- Tipografía: definir escala y pesos (ej.: Major Third), y mapear `font-sans`, `font-mono`.
- Spacing: asegurar grid 4/8pt en componentes (paddings/margins estándar).
- Motion: respetar `@media (prefers-reduced-motion: reduce)` y limitar efectos intensos.

6) Uso en componentes (ejemplos documentales)
- Botón: `bg-primary text-primary-foreground hover:bg-primary/90 rounded-lg`
- Card: `bg-card text-card-foreground border-border`
- Input: `focus:ring-2 focus:ring-ring focus:border-border rounded-md`
- Navbar: usar `background/foreground` y `muted` para superficies secundarias.

7) Contraste AA/AAA (validación)
- Generar `project-logs/ux/contrast.json` con pares fg/bg críticos (texto en fondos, botones, inputs, estados hover/disabled).
- Ajustar variables HSL si algún par < AA (4.5:1 texto normal, 3:1 texto grande). Revalidar.

8) Validaciones de coherencia
- Grep de hex directos en `client/src/**/*.{tsx,css}` (evitar “magia”).
- Verificar `tsc --noEmit` y lint de estilos (si aplica).

## Artefactos
- `project-logs/design/wiring.md` — resumen de mapeos realizados y pendientes
- `project-logs/ux/contrast.json` — reporte de contraste
- `project-logs/design/status.json` — estado machine‑readable

## Status JSON (ejemplo)
```json
{
  "themes": ["light","dark"],
  "tokens": { "colors": true, "typography": true, "radii": true, "motion": true },
  "contrast": { "testedPairs": 24, "aaPass": 24, "aaaPass": 16 },
  "codeSmells": { "hardcodedHex": 0 },
  "status": "pass",
  "artifacts": [
    "project-logs/design/wiring.md",
    "project-logs/ux/contrast.json"
  ],
  "timestamp": "${ISO_TIMESTAMP}"
}
```

## Aceptación (Done)
- AA para todo texto y controles; AAA para inputs/labels críticos si aplica
- Sin hex “mágicos” en componentes (0 hallazgos)
- `tsc --noEmit` sin errores; estilos consistentes con 4/8pt
- Temas light/dark coherentes; ring/border definidos por tokens

## Fallback sin scripts
- Validar manualmente contraste con herramientas online; registrar resultados en `project-logs/ux/contrast.json`

## Dry‑run
- `--dryRun` ejecuta validaciones y genera artefactos sin modificar tokens/código

## Notas
- Mantener los tokens semánticos como capa de abstracción: cambios de branding no deben requerir tocar componentes.
