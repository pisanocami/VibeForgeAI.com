---
description: Seed standard portal subpages under the latest dynamic Notion root (Reusable & Safe-by-Default)
---

# Notion — Seed Portal Structure (Dynamic)

## Objective
Create a standard set of subpages under the MOST RECENT dynamically-created Notion Root page for this project, without hardcoding any IDs. Fully aligned with Windsurf Global Rule 1.

## Inputs (env)
- NOTION_TOKEN (required)
- NOTION_WORKSPACE_PAGE_ID (required) — Parent page where the dynamic Root is created by `create-dynamic-root.md`
- BRAND_NAME (optional)
- BRAND_TAGLINE_EN (optional)
- BRAND_TAGLINE_ES (optional)

## Pre-Flight
// turbo
```powershell
# Ensure output directories
if (!(Test-Path 'project-logs')) { New-Item -ItemType Directory -Path 'project-logs' | Out-Null }
if (!(Test-Path 'docs/notion')) { New-Item -ItemType Directory -Path 'docs/notion' | Out-Null }

# Validate required env vars
$required = @('NOTION_TOKEN','NOTION_WORKSPACE_PAGE_ID')
$missing = $required | Where-Object { -not $env:$_ }
if ($missing.Count -gt 0) { Write-Error (
  "Missing required env vars: {0}. Set them in your shell or CI and retry." -f ($missing -join ', ')
); exit 1 }

# Determine latest Root ID
$rootId = $null
if (Test-Path 'project-logs/notion-pages.json') {
  try {
    $json = Get-Content 'project-logs/notion-pages.json' -Raw | ConvertFrom-Json
    $rootId = $json.rootId
  } catch { }
}
if (-not $rootId -and (Test-Path 'project-logs/notion-brand-kickoff.txt')) {
  # Fallback: parse last Root ID line from kickoff log (script-dependent format)
  $lines = Get-Content 'project-logs/notion-brand-kickoff.txt'
  $match = ($lines | Select-String -Pattern 'Root ID:\s*([a-f0-9-]{32,})' | Select-Object -Last 1)
  if ($match) { $rootId = $match.Matches[0].Groups[1].Value }
}
if (-not $rootId) {
  Write-Error "No Root ID found. Run workflows/notion/create-dynamic-root.md first, then retry."
  exit 1
}
Write-Host ("Seeding under Root ID: {0}" -f $rootId)
```

## Standard Subpages to Create
- Overview
- Architecture
- Development Roadmap
- Backlog & Grooming
- API Integrations
- Design System
- Operations (Runbooks)
- Security & Compliance
- SLOs & Error Budgets
- ADRs (Architecture Decision Records)
- Data & Analytics (Warehouse, ETL)
- MLOps & Models
- Marketing Intelligence
- Competitive Intelligence
- Mobile & PWA
- Help Center & Knowledge Base
- Release Management
- Status Dashboard

> Tip: Names are standardized to match `app_brainstorming/` documents for easy mapping.

## Primary Path — Script-First
If your repo provides a TS script to seed pages, run it now. Example:

```powershell
# Example (adjust to your script path/name)
# Reads Root ID from notion-pages.json and creates subpages:
# npx tsx shared/scripts/notion/seed-portal-structure.ts --root $rootId \
#   --brandName "$env:BRAND_NAME" --taglineEn "$env:BRAND_TAGLINE_EN" --taglineEs "$env:BRAND_TAGLINE_ES"

Write-Host "Script-first path not configured in this repo. Use the Fallback Path below."
```

## Fallback Path — MCP Notion / Manual API
Use Notion MCP or your preferred Notion API client to:

1) Create child pages under the Root ID (`$rootId`) using the titles above.
2) For each created page, capture its `page_id` and append to `project-logs/notion-brand-kickoff.txt` in this format:

```text
[Seed] Created: Architecture — page_id=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

3) Build or update `project-logs/notion-pages.json` (canonical) to include:

```json
{
  "rootId": "<the-latest-root-id>",
  "pages": {
    "Overview": "<page_id>",
    "Architecture": "<page_id>",
    "Development Roadmap": "<page_id>",
    "Backlog & Grooming": "<page_id>",
    "API Integrations": "<page_id>",
    "Design System": "<page_id>",
    "Operations (Runbooks)": "<page_id>",
    "Security & Compliance": "<page_id>",
    "SLOs & Error Budgets": "<page_id>",
    "ADRs": "<page_id>",
    "Data & Analytics": "<page_id>",
    "MLOps & Models": "<page_id>",
    "Marketing Intelligence": "<page_id>",
    "Competitive Intelligence": "<page_id>",
    "Mobile & PWA": "<page_id>",
    "Help Center & Knowledge Base": "<page_id>",
    "Release Management": "<page_id>",
    "Status Dashboard": "<page_id>"
  }
}
```

4) Run `workflows/notion/sync-links.md` afterwards to regenerate `docs/notion/links.md`.

## Expected Artifacts
- Updated `project-logs/notion-brand-kickoff.txt` with created pages
- Updated/created `project-logs/notion-pages.json` (canonical IDs)
- `docs/notion/links.md` regenerated after running Sync Links

## Audit (Rule 1)
- A NEW Root must be created each run via `create-dynamic-root.md` (do not reuse).
- This workflow MUST NOT rely on hardcoded IDs; it reads the latest Root ID from logs/JSON.
- All created IDs are stored only in `project-logs/*.txt` and `project-logs/notion-pages.json`.

## Troubleshooting
- "No Root ID found": run `workflows/notion/create-dynamic-root.md` first.
- Permission error: ensure `NOTION_TOKEN` has access to the parent workspace page and is configured as an internal integration with edit permissions.
- Pages not visible: confirm they were created under the correct Root and the Root is under your intended workspace page.
