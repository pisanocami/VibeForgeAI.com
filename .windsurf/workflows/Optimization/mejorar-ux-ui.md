---
description: Canonical — UX/UI Improvement (checklist, a11y, contrast, artifacts, status JSON)
category: optimization
stability: stable
---

# Optimization — Mejorar UX/UI (AGI‑grade)

Directed (aplica a este workflow específico). Este blueprint convierte el análisis UX/UI en un proceso reproducible, con artefactos, umbrales de aceptación y salidas machine‑readable para orquestación.

Related: `/development/design-and-styling`, `/analysis/analizar-performance`, `/optimization/optimizar-bundle`, `/general/agent`

## Objetivo
Evaluar y mejorar la experiencia de usuario y la interfaz (información, jerarquía visual, accesibilidad, contraste, navegación por teclado, motion seguro) alineado a la marca AetherIQ (Aurora Indigo), maximizando performance y coherencia.

## Entradas
- URL (local o deploy) a auditar (opcional si es app local)
- Rutas de componentes/páginas afectadas (ej.: `client/src/pages/*`, `client/src/components/*`)
- Tokens de marca activos (Tailwind + CSS variables)

## Preflight (Windows PowerShell) — seguro para auto‑ejecutar
// turbo
```powershell
$paths = @('project-logs','project-logs/ux','docs/ux')
$paths | ForEach-Object { if (!(Test-Path $_)) { New-Item -ItemType Directory -Path $_ | Out-Null } }
```

## Herramientas recomendadas
- Navegación/Automatización: MCP Puppeteer (`puppeteer/*`) o MCP Playwright (`mcp-playwright/*`)
- Medición: Lighthouse (CLI) y `performance.getEntriesByType('resource')`
- Accesibilidad: Axe (inyectado en navegador) o Lighthouse a11y
- Contraste: script propio (Node) con `colord`/`polished` o equivalentes

## Pasos
1) Descubrimiento y alcance
- Identificar pantallas/rutas clave, estados (empty, error, loading), y tamaños de viewport (mobile/desktop)
- Registrar supuestos y objetivos (p.ej., onboarding en 2 clicks, reducción de scroll, estabilidad visual)

2) Captura inicial
- Screenshot de página/estado principal
- Dump de DOM key facts (número de headings por nivel, labels/alt, roles ARIA)
- Lighthouse rápido para baseline de perf/a11y/SEO/best‑practices

3) Checklist UX/UI
- Estructura: jerarquía de headings H1‑H6, F/Z‑pattern, agrupaciones, consistencia de espaciado (4/8pt)
- Navegación: foco visible, tab‑order lógico, skip‑links si aplica
- Estados: hover/active/disabled/focus/visited consistentes y accesibles
- Legibilidad: tamaños de tipografía, contraste, alturas de línea, truncado/ellipsis,
- Motion: reducir animaciones intrusivas; respeta `prefers-reduced-motion`
- Responsiveness: breakpoints y legibilidad en mobile/desktop, hit targets (44x44px)

4) Accesibilidad (Axe/Lighthouse)
- Ejecutar auditoría a11y (Axe) y recoger issues por severidad
- Verificar landmarks/roles, labels en inputs, descripciones alternativas

5) Contraste AA/AAA (tokens AetherIQ)
- Generar matriz de contraste (texto primario/secundario/sobre superficies y estados)
- Señalar pares por debajo de AA y proponer ajustes (tono/saturación/luminosidad)

6) Plan de mejoras (priorizado)
- Mapear cada hallazgo → archivo(s) fuente y componente(s)
- Prioridad: críticos (a11y/contraste) → navegación → legibilidad → estética
- Definir cambios con diffs sugeridos (no destructivos)

7) Validación post‑cambio
- Repetir Lighthouse y Axe; comparar métricas con baseline
- Asegurar que los umbrales se cumplan (ver Aceptación)

## Artefactos
- `project-logs/ux/report.md` — resumen humano con hallazgos, capturas y plan
- `project-logs/ux/axe.json` — issues de accesibilidad
- `project-logs/ux/contrast.json` — pares de contraste medidos + resultado (AA/AAA)
- `project-logs/ux/screenshots/initial.png` y `final.png`
- `project-logs/ux/status.json` — estado machine‑readable

## Status JSON (ejemplo)
```json
{
  "screens": ["/", "/dashboard"],
  "a11y": { "critical": 0, "serious": 1, "moderate": 2, "minor": 3 },
  "contrast": { "testedPairs": 28, "aaPass": 26, "aaaPass": 18 },
  "perf": { "LCP": 2.2, "CLS": 0.05 },
  "status": "needs-attention",
  "artifacts": [
    "project-logs/ux/report.md",
    "project-logs/ux/axe.json",
    "project-logs/ux/contrast.json"
  ],
  "timestamp": "${ISO_TIMESTAMP}"
}
```

## Aceptación (Done)
- A11y: 0 críticos y 0 serios en pantallas clave; `focus` visible; navegación por teclado completa
- Contraste: AA en texto y controles; AAA en inputs/labels críticos si aplica
- UX: tab‑order lógico; hit targets ≥ 44x44px; estados coherentes; `prefers-reduced-motion` respetado
- Perf (complementario): LCP < 2.5s; CLS < 0.1 en pantallas clave

## Ejemplos de comandos
- Lighthouse (local):
```powershell
npm run perf:lighthouse
```
- Capturas (Puppeteer MCP): `puppeteer_screenshot` sobre la URL objetivo y guardar a `project-logs/ux/screenshots/*.png` (ver `/general/agent` para patrones)

## Fallback sin scripts
- Ejecutar Lighthouse GUI o extensiones Axe; registrar hallazgos manualmente en `project-logs/ux/report.md`

## Dry‑run
- `--dryRun` o modo “solo evaluación”: recopila hallazgos y artefactos, sin aplicar cambios de código

## Notas de implementación
- Conectar con tokens: si un color falla contraste, proponer ajuste en tokens (Tailwind/CSS vars) y revalidar
- Documentar en `docs/ux/` patrones de navegación y componentes estándar accesibles
