---
description: Create a NEW dynamic Notion root page and capture IDs (Reusable, Safe-by-Default)
---

# Notion — Create Dynamic Root (Improved)

## Objective
Create a fresh Notion root page for this project on every run and capture all child IDs without relying on hardcoded IDs (Windsurf Global Rule 1).

## Inputs (env)
- NOTION_TOKEN (required)
- NOTION_WORKSPACE_PAGE_ID (required) — parent page
- BRAND_NAME (optional)
- BRAND_TAGLINE_EN (optional)
- BRAND_TAGLINE_ES (optional)

## Pre-Flight Checks
// turbo
```powershell
# 1) Ensure logs dir
if (!(Test-Path 'project-logs')) { New-Item -ItemType Directory -Path 'project-logs' | Out-Null }

# 2) Validate env variables are present
$required = @('NOTION_TOKEN','NOTION_WORKSPACE_PAGE_ID')
$missing = $required | Where-Object { -not $env:$_ }
if ($missing.Count -gt 0) { Write-Error (
  "Missing required env vars: {0}. Set them in your shell or CI and retry." -f ($missing -join ', ')
); exit 1 }
```

## Primary Path — Script-First (recommended)
```powershell
# Run the repo script that CREATES a new root and prints all IDs
# Use one of the scripts that exist in your repo (examples below):
# npx tsx shared/scripts/notion/brand_kickoff.ts
# npx tsx shared/scripts/notion/notion-project-setup.ts

npx tsx shared/scripts/notion/brand_kickoff.ts |
  Tee-Object -FilePath 'project-logs\notion-brand-kickoff.txt'
```

Expected output
- A brand-new Root ID printed (different on every run)
- Printed child pages (Brand, Roadmap, Arquitectura, Datos, Design System, Operación)
- Log saved to `project-logs/notion-brand-kickoff.txt`

## Alternative — MCP Notion (fallback)
If no script is available, use Notion MCP to:
1) Create page under `parent.page_id = $env:NOTION_WORKSPACE_PAGE_ID`
2) Capture the returned `page_id` dynamically
3) Create the standard subpages as children
4) Write a log to `project-logs/notion-brand-kickoff.txt` listing IDs

## Audit (Rule 1)
- Verify a new root was created (new ID each run)
- Never reuse Root IDs; store latest in `project-logs/notion-pages.json` (via sync-links)
- Do not hardcode IDs in code; only in logs/JSON

## Next Steps
- Run `workflows/notion/sync-links.md` to update JSON index and docs.
- Open `docs/notion/links.md` for quick access.
