---
description: Branding — Orchestrator (end‑to‑end pipeline for brand)
---

Coordina todos los workflows de Branding en un pipeline reproducible, con preflights seguros en Windows, salidas estandarizadas y gobernanza de Notion.

## Objetivo
- Ejecutar de forma ordenada: intake → definición → tokens → identidad visual → voz/mensajes → asset kit → validación/entrega.
- Asegurar artefactos y logs en `project-logs/` y `docs/`.
- Cumplir Regla Global de Notion: raíz dinámica por ejecución, sin IDs hardcodeados.

## Preflight (Windows PowerShell) — seguro para auto‑ejecutar
// turbo
```powershell
$paths = @('project-logs','project-logs/product','project-logs/ux','project-logs/design','docs/design')
$paths | ForEach-Object { if (!(Test-Path $_)) { New-Item -ItemType Directory -Path $_ | Out-Null } }
```

## Requisitos
- Tokens y Tailwind: ver `/design-and-styling` y `tailwind.config.ts` + `src/index.css`.
- Notion (si se crean páginas desde scripts):
  - Debe crearse una página raíz dinámica por ejecución (NUNCA usar IDs fijos).
  - El script debe leer el Workspace/Page container desde variables de entorno y crear la raíz.
  - Registrar el ID generado dinámicamente y utilizarlo para subpáginas.
- Artefactos: guardar outputs en `project-logs/` con timestamp ISO.

## Orden recomendado (Workflows)
1) Brand Intake — `/brand-intake`
   - Captura inputs crudos → brief estructurado.
   - Output: `project-logs/product/brand-intake-{timestamp}.md`

2) Brand Definition — `/brand-definition`
   - Esencia, visión/misión, posicionamiento, principios.
   - Output: `project-logs/product/brand-vision-{timestamp}.md`

3) Brand Tokens — `/brand-tokens`
   - Colores, tipografía, spacing, radii, sombras, motion + contrast AA/AAA.
   - Output: `project-logs/product/brand-tokens-{timestamp}.md`
   - Acción: emparejar con `/design-and-styling` para cablear a Tailwind/shadcn.

4) Visual Identity — `/visual-identity`
   - Logo system, paleta aplicada, tipografía aplicada, grid/layout, imagery.
   - Output: `project-logs/product/brand-assets-{timestamp}.md`

5) Content Voice — `/content-voice`
   - Perfil de voz, arquitectura de mensajes, patrones, localización.
   - Output: `project-logs/product/brand-voice-{timestamp}.md`

6) Asset Kit — `/asset-kit`
   - Exportar logos/iconos, favicons, tiles; token files; plantillas; guías de uso.
   - Output: `project-logs/product/brand-guidelines-{timestamp}.md`

7) Validation & Handoff — `/validation-and-handoff`
   - Validar, iterar, documentar cambios y empaquetar handoff.
   - Output: `project-logs/product/brand-handoff-{timestamp}.md`

## Gates de calidad y checks
- Accesibilidad: contraste AA mínimo (texto y estados UI). Ver `project-logs/ux/contrast.json`.
- Consistencia: no usar hex “mágicos” directo en componentes; usar clases Tailwind o variables CSS.
- Tokens ↔ Tailwind/shadcn: verificar mapeos en `tailwind.config.ts` y `src/index.css`.
- Versionado: cada output debe incluir fecha y versión, y actualizar bitácora.

## Integración con código (resumen)
- Tailwind: `tailwind.config.ts` debe mapear tokens semánticos (background, foreground, primary, etc.).
- CSS Variables: `src/index.css` debe definir `:root` y `.dark` para tokens, y respetar `prefers-color-scheme`.
- Componentes: usar clases derivadas de tokens (no valores ad‑hoc).

## Notion — Regla de Raíz Dinámica (obligatoria)
Si cualquier paso crea páginas en Notion, asegurar:
- El script crea una NUEVA página raíz por ejecución y obtiene su ID dinámicamente.
- Usar ese ID para crear subpáginas (no IDs hardcodeados ni de contexto previo).
- Documentar el ID en `project-logs/product/notion-root-{timestamp}.json` para trazabilidad.

## Artefactos estandarizados
- Logs: `project-logs/**`. Diseñar nombres `kebab-case` + timestamp.
- Documentación: `docs/design/` para resúmenes ejecutivos o guías.
- Imágenes/recursos: `public/brand/`.

## Ejecución sugerida (manual)
1. Ejecuta `/brand-intake` y revisa el brief.
2. Ejecuta `/brand-definition` y valida con stakeholders.
3. Ejecuta `/brand-tokens` y luego `/design-and-styling` para cableado a código.
4. Ejecuta `/visual-identity` y revisa accesibilidad/contraste.
5. Ejecuta `/content-voice` y prueba mensajes en superficies clave.
6. Ejecuta `/asset-kit` para empaquetado final.
7. Ejecuta `/validation-and-handoff` para cierre y versionado.

## Siguientes pasos automatizables
- Hooks para generar automáticamente `contrast.json` y validar AA/AAA tras cambios en tokens.
- Script para compilar un `brand-status.json` con enlaces a todos los artefactos.
