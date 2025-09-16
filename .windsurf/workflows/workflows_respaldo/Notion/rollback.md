---
description: Archive/cleanup Notion pages created during tests or misruns, with safeguards (Improved & Reusable)
---

# Notion — Rollback / Cleanup (Improved)

## Objective
Provide a safe rollback for Notion artifacts created by automated scripts (tests/misruns), without deleting production content.

## Guardrails
- Default action: archive (never delete) — reversible in Notion UI.
- Require explicit confirmation env flag `FORCE_NOTION_ROLLBACK=1` to perform any write.
- Log every action to `project-logs/notion-rollback.txt` with timestamps and page IDs.

## Inputs (env)
- NOTION_TOKEN (required)
- TARGET_ROOT_ID (optional) — overrides JSON if set

## Sources of Truth
- `project-logs/notion-pages.json` — canonical IDs
- or `project-logs/notion-brand-kickoff.txt` — latest script output

## Pre-Flight
// turbo
```powershell
if (!(Test-Path 'project-logs')) { New-Item -ItemType Directory -Path 'project-logs' | Out-Null }

if (-not $env:NOTION_TOKEN) { Write-Error 'Missing NOTION_TOKEN env var'; exit 1 }
if ($env:FORCE_NOTION_ROLLBACK -ne '1') {
  Write-Error 'Set FORCE_NOTION_ROLLBACK=1 to enable rollback actions (archive only). Aborting.'
  exit 1
}
```

## Steps
1) Identify targets
```powershell
if (Test-Path 'project-logs/notion-pages.json') {
  $json = Get-Content -Raw 'project-logs/notion-pages.json' | ConvertFrom-Json
  $rootId = if ($env:TARGET_ROOT_ID) { $env:TARGET_ROOT_ID } else { $json.Root }
  Write-Output "Target Root ID: $rootId"
} else {
  Write-Error 'notion-pages.json not found. Provide TARGET_ROOT_ID or run create-dynamic-root + sync-links first.'
  exit 1
}
```

2) Archive children, then root (Script-first)
```powershell
# Example placeholder — implement the script to call Notion API and archive by ID
# npx tsx shared/scripts/notion/rollback.ts --root $rootId |
#   Tee-Object -FilePath 'project-logs/notion-rollback.txt'
```

3) Verify in Notion UI
- Confirm pages are archived (moved to trash), not permanently deleted

## Audit
- Commit `project-logs/notion-rollback.txt` for traceability if appropriate
- Ensure no hardcoded IDs were used — only env/logs/JSON

## Troubleshooting
- 401/403: Ensure integration has access to the parent/root and `NOTION_TOKEN` is valid
- Missing IDs: Re-run `workflows/notion/create-dynamic-root.md` then `workflows/notion/sync-links.md`
```
