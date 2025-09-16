---
description: MVP Workflows — Overview & Usage (AutoParse + Orchestrator)
category: mvp
stability: stable
---

# MVP Workflows — Guía Completa

Este directorio contiene workflows para construir un MVP de forma rápida y orquestada, con soporte de entrada libre en lenguaje natural.

Workflows incluidos:
- `/mvp-builder` — Orquestador (selecciona y ejecuta módulos: docs, frontend, backend, diagrams, security)
- `/mvp-docs` — Documentación base (PRD, API Docs, Diagramas) con publicación opcional en Notion (Regla 1)
- `/mvp-diagrams` — Diagramas esenciales (estructura, flujo, componentes, dependencias)
- `/mvp-frontend` — Frontend seleccionable (React+Vite por defecto; Next.js/SvelteKit/Angular)
- `/mvp-backend` — Backend seleccionable (Fastify por defecto; Express/Nest/Hono; opcional FastAPI)
- `/mvp-security` — Auditorías rápidas de seguridad (deps, SAST opcional, secretos, a11y)

## Quick Start
1) Provee una solicitud en lenguaje natural (elige una):
   - Variable de entorno (Windows PowerShell):
     ```powershell
     $env:MVP_REQUEST = "Landing con login y dashboard, Next.js con MongoDB. Sin backend separado (API Routes). Incluir auditoría de seguridad."
     ```
   - Archivo:
     ```powershell
     New-Item -ItemType Directory -Force -Path docs/mvp | Out-Null
     @"
     MVP: Front en React/Vite con Tailwind y shadcn; Backend Fastify; DB Postgres (Neon). Agregar diagramas.
     "@ | Out-File -Encoding UTF8 -FilePath docs/mvp/REQUEST.txt
     ```
2) Ejecuta el orquestador: `/mvp-builder`
   - El orquestador parsea la entrada y guarda la config en `project-logs/mvp/intake/latest.json`.
3) Si necesitas solo una parte, ejecuta los workflows especializados.

## Prerrequisitos
- Node.js 18+ y npm
- Windows PowerShell (para ejecutar pasos `// turbo` AutoRun)
- Notion (solo si vas a publicar):
  - `NOTION_TOKEN` y `NOTION_WORKSPACE_PAGE_ID` configurados en tu entorno.
  - Ver `/.windsurf/workflows/Notion/create-dynamic-root.md` para detalles.
  - Plantilla de variables: `docs/mvp/env.example.ps1` (cópialo a `env.ps1` y cárgalo con `. .\env.ps1`).
- Opcional según tu selección:
  - Semgrep instalado si vas a correr SAST en `/mvp-security`
  - Python 3.x si eliges `fastapi` en `/mvp-backend`

Para ejemplos de solicitudes en lenguaje natural, revisa `docs/mvp/REQUEST.examples.txt`.

## Cómo se interpreta tu solicitud (AutoParse)
El sistema reconoce palabras clave para inferir:
- Módulos (SELECT): `docs`, `frontend`, `backend`, `diagrams`, `security`
  - docs/diagrams: “documentación”, “doc”, “diagrama/diagram”
  - security: “seguridad”, “OWASP”, “audit/auditor”
  - solo front/back: “solo front/only front”, “solo back/only back”
  - sin backend: “sin backend”, “estático/estatica/static”
- Frontend (FRONTEND_TECH):
  - `nextjs` (“next”), `sveltekit` (“svelte”), `angular` (“angular”), por defecto `react-vite`
- Backend (BACKEND_TECH):
  - `fastapi` (“fastapi”/“python”), `express`, `nest`, `hono` (edge/serverless), por defecto `fastify`
- Base de datos (DB):
  - `mongodb` (“mongo”), `sqlite`, `neon-postgres` (“postgres”/“neon”)
- UI (UI_LIBS):
  - `tailwind+shadcn` (“shadcn”), `tailwind` (“tailwind”), `none` (“chakra/mui/bootstrap”)

Orden de precedencia:
1) `project-logs/mvp/intake/latest.json` (si existe)
2) Variables de entorno (p. ej. `FRONTEND_TECH`, `BACKEND_TECH`, `DB`, `UI_LIBS`)
3) `MVP_REQUEST` o `docs/mvp/REQUEST.txt`
4) Defaults: React+Vite, Fastify, Neon/Postgres, Tailwind+shadcn, SELECT=[docs, frontend, backend, diagrams]

Para reiniciar el parseo:
```powershell
Remove-Item project-logs/mvp/intake/latest.json -ErrorAction SilentlyContinue
```

## Presets útiles
- Solo documentación: `SELECT = [docs, diagrams]`
- MVP mínimo ejecutable: `SELECT = [docs, frontend, backend, diagrams]`
- Hardening rápido: añade `security`

## Publicación en Notion (Regla 1)
- Los workflows publican en Notion creando SIEMPRE una nueva página raíz con `/create-dynamic-root`.
- No se usan IDs codificados ni de corridas previas. Los enlaces se registran en `project-logs/mvp/logs/run-*.md`.

## Estructura de artefactos
- `docs/mvp/` — PRD, API, diagramas
- `apps/front/` — Frontend scaffold
- `apps/back/` — Backend scaffold
- `project-logs/mvp/logs/` — Bitácoras de ejecución
- `project-logs/mvp/intake/latest.json` — Config inferida

## Troubleshooting
- “No respeta mi selección”: Define variables de override antes de ejecutar (`FRONTEND_TECH`, `BACKEND_TECH`, `DB`, `UI_LIBS`).
- “Cambios no toman efecto”: Borra `project-logs/mvp/intake/latest.json` y vuelve a ejecutar.
- “Semgrep no está instalado”: El paso SAST se salta si la herramienta no está disponible.
- “Quiero Next.js sin backend separado”: Usa “API Routes”, el parser quita `backend` del SELECT cuando detecta “sin backend/static”.

## Recomendaciones extra
- CI y quality gates: ejecutar `/ci-quality-gates`
- E2E: `/playwright-e2e`
- Unit tests: `/vitest-unit`
- Observabilidad: `/monitoring-and-observability`
- Deploy: `/ci-cd-pipeline`

## Criterios de aceptación (MVP completo)
- Módulos seleccionados ejecutados sin errores
- Front y Back corriendo en local cuando aplica
- Documentación básica generada (PRD, API, diagramas)
- Seguridad básica revisada (si se incluyó)
- (Opcional) Publicación en Notion con raíz creada dinámicamente

## Changelog
- 2025-09-16 — Primera versión del paquete MVP con AutoParse + Orquestador
