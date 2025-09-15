---
description: Keep Notion IDs and links in sync across the repo (Improved & Reusable)
---

# Notion — Sync Links (Improved)

## Objective
Synchronize the latest Notion IDs into a canonical JSON file and regenerate human-friendly links docs. Works with script output or existing JSON.

## Inputs
- Kickoff log (optional): `project-logs/notion-brand-kickoff.txt`
- Canonical JSON: `project-logs/notion-pages.json`
- Optional env: `NOTION_WORKSPACE_ROOT_URL`

## Pre-Flight
// turbo
```powershell
if (!(Test-Path 'project-logs')) { New-Item -ItemType Directory -Path 'project-logs' | Out-Null }
if (!(Test-Path 'docs/notion')) { New-Item -ItemType Directory -Path 'docs/notion' | Out-Null }
```

## Primary Path — Script-First
```powershell
# Parse latest IDs and regenerate docs
npx tsx shared/scripts/notion/sync-links.ts
```

Expected artifacts
- `project-logs/notion-pages.json` (canonical IDs)
- `docs/notion/links.md` (quick links)
- Optionally updates `docs/brand.md`

## Fallback Path — No Script Available
1) If kickoff log exists, parse it and merge into JSON
2) If only JSON exists, ensure all required keys are present
3) Generate `docs/notion/links.md` from JSON

Minimal required keys in JSON
```json
{
  "Root": "...",
  "Brand": "...",
  "Roadmap": "...",
  "Arquitectura": "...",
  "Datos": "...",
  "DesignSystem": "...",
  "Operacion": "..."
}
```

## Audit
- Commit `project-logs/notion-pages.json` and `docs/notion/links.md`
- Never hardcode IDs in code; always read from JSON/logs

## Troubleshooting
- If script fails, ensure Node/tsx installed and `NOTION_TOKEN` set in shell
- If pages are missing, re-run `workflows/notion/create-dynamic-root.md` or create missing subpages
