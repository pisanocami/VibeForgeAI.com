---
description: Notion Workflows Index — PM Brain (Improved & Reusable)
---

# Notion Workflows — Project Manager Brain

Use these workflows to centralize Notion operations for AetherIQ (and other projects). They are safe-by-default, auditable, and follow Windsurf Global Rules.

- Rule 1: Always create a NEW root dynamically per execution. Never rely on hardcoded IDs or prior context.
- Rule 2: Clear documentation.
- Rule 3–5: Robust error handling and clear messages.

## Core Workflows
- `create-dynamic-root.md` — Create a new dynamic root and capture child IDs (Regla 1).
- `sync-links.md` — Keep Notion IDs and links in sync across the repo.
- `status.md` — Snapshot current Notion links/status and validate required env.
- `rollback.md` — Archive/cleanup pages created during tests or misruns, with safeguards.
- `seed-portal-structure.md` — Seed standard portal subpages under the latest dynamic root.

## Optional Workflows (existing at repo root)
- `workflows/notion-seed-subpages.md`
- `workflows/notion-seed-templates.md`

## How to Run
Prefer npm scripts for repeatability:
```powershell
npm run notion:root     # dynamic root creation
npm run notion:sync     # sync links/docs
npm run notion:status   # validate env & summarize
npm run notion:rollback # archive safe rollback
```
Or run scripts directly with `npx tsx` as indicated in each workflow.

## Orquestación recomendada
1) `env-setup.md` — Verifica/establece `NOTION_TOKEN` y `NOTION_WORKSPACE_PAGE_ID` sin exponer valores.
2) `status.md` — Chequeo inicial (archivos/carpetas/JSON).  
3) `create-dynamic-root.md` — Crea SIEMPRE una raíz nueva (Regla 1).
4) `sync-links.md` — Genera/actualiza `project-logs/notion-pages.json` y `docs/notion/links.md`.
5) `backfill-subpages.md` — Asegura subpáginas estándar; crea las faltantes.
6) `seed-templates.md` — (Opcional) Inserta bloques/plantillas iniciales.
7) `status.md` — Snapshot final y auditoría.

## Conventions
- Source of truth for IDs: `project-logs/notion-brand-kickoff.txt` → `project-logs/notion-pages.json`.
- Documentation: `docs/notion/links.md` + `docs/brand.md`.
- Never hardcode IDs in code; use logs/JSON.

## Duplicados a consolidar (sin romper nada)
Para evitar confusión, mantén como fuente principal los workflows en `workflows/notion/`.  
Los siguientes archivos en la raíz son duplicados funcionales y se consolidarán gradualmente bajo `workflows/notion/legacy/`:
- `workflows/notion-create-dynamic-root.md`
- `workflows/notion-sync-links.md`
- `workflows/notion-rollback.md`
- `workflows/notion-seed-subpages.md`
- `workflows/notion-seed-templates.md`

No moveremos archivos hasta tener tu aprobación; mientras tanto, el índice de `workflows/README.md` los agrupa lógicamente.

## Directory Structure
- `workflows/notion/` — This index + core Notion workflows (improved & reusable)
- `docs/notion/` — Human-facing docs and quick links
- `project-logs/` — Machine/log-generated artifacts from runs
