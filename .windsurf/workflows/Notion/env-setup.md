---
description: Notion Env Setup — Safe, Reusable, Windows-friendly
---

# Notion — Env Setup (Reusable)

## Objective
Validate and set required environment variables safely for Notion workflows (local shell and CI), without hardcoding secrets.

## Required Vars
- `NOTION_TOKEN` — Integration token with edit access
- `NOTION_WORKSPACE_PAGE_ID` — Parent page (workspace root for this project)

## Optional Vars
- `BRAND_NAME`, `BRAND_TAGLINE_EN`, `BRAND_TAGLINE_ES`
- `NOTION_WORKSPACE_ROOT_URL` — Used in docs generation
- `FORCE_NOTION_ROLLBACK` — `1` to allow rollback actions (archive only)

## Local (PowerShell) — Safe to Auto-Run
// turbo
```powershell
# Create logs dir if missing
if (!(Test-Path 'project-logs')) { New-Item -ItemType Directory -Path 'project-logs' | Out-Null }

# Check presence (without printing values)
$required = @('NOTION_TOKEN','NOTION_WORKSPACE_PAGE_ID')
$missing = $required | Where-Object { -not $env:$_ }
if ($missing.Count -gt 0) {
  Write-Warning ("Missing env vars (set them in this session): {0}" -f ($missing -join ', '))
}

# Example — set for THIS session only (do NOT commit)
# $env:NOTION_TOKEN = '...'                 # paste securely
# $env:NOTION_WORKSPACE_PAGE_ID = '...'     # paste securely

# Verify set
$required | ForEach-Object {
  if ($env:$_) { Write-Output ("SET: {0}" -f $_) } else { Write-Warning ("MISSING: {0}" -f $_) }
}
```

## CI Setup (Generic)
- Add `NOTION_TOKEN` and `NOTION_WORKSPACE_PAGE_ID` as masked secrets in your CI provider.
- Export them into job environments without echoing their values.
- Ensure status workflow (`workflows/notion/status.md`) runs in CI to validate presence.

## Security Notes
- Never commit `.env` files with real values.
- Provide `docs/.env.sample` as a reference (no values).
- Prefer short-lived shells and rotate tokens periodically.
