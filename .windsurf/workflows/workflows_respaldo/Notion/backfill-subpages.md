---
description: Ensure standard Notion subpages exist under a dynamic Root; create any missing ones (Improved & Reusable)
---

# Notion — Backfill Subpages (Improved)

## Objective
Guarantee that the standard subpages exist under the current dynamic Root and create missing ones safely (no hardcoded IDs).

## Inputs
- Env: `NOTION_TOKEN` (required)
- Source of truth for Root ID:
  - `project-logs/notion-pages.json` (preferred) OR
  - `TARGET_ROOT_ID` env var

## Required Subpages
- Brand, Roadmap, Arquitectura, Datos, Design System, Operación

## Pre-Flight
// turbo
```powershell
if (!(Test-Path 'project-logs')) { New-Item -ItemType Directory -Path 'project-logs' | Out-Null }
if (-not $env:NOTION_TOKEN) { Write-Error 'Missing NOTION_TOKEN'; exit 1 }
```

## Steps — Script-First
```powershell
# Determine root ID
if (Test-Path 'project-logs/notion-pages.json') {
  $json = Get-Content -Raw 'project-logs/notion-pages.json' | ConvertFrom-Json
  $rootId = if ($env:TARGET_ROOT_ID) { $env:TARGET_ROOT_ID } else { $json.Root }
} else {
  $rootId = $env:TARGET_ROOT_ID
}
if (-not $rootId) { Write-Error 'No Root ID available. Run create-dynamic-root + sync-links first.'; exit 1 }

# Run backfill script (create missing subpages only)
# Example placeholder; implement script to call Notion API and upsert children by name
# npx tsx shared/scripts/notion/backfill-subpages.ts --root $rootId |
#   Tee-Object -FilePath 'project-logs/notion-backfill.txt'
```

## Expected Output
- All standard subpages present under Root
- Log written to `project-logs/notion-backfill.txt` with actions (created/skipped)
- `project-logs/notion-pages.json` updated if new IDs were created (via `sync-links`)

## Audit
- Re-run `workflows/notion/status.md` and ensure required keys are present in JSON
- Commit logs/json updates for team visibility
