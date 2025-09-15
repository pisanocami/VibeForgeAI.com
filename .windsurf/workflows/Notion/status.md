---
description: Snapshot current Notion links/status and validate required env (Improved & Reusable)
---

# Notion — Status (Improved)

## Objective
Generate a current status snapshot of Notion integration health and artifacts. Validate env vars, required files, and presence of core page IDs.

## Inputs (env)
- NOTION_TOKEN (required)
- NOTION_WORKSPACE_PAGE_ID (recommended for creation flows)

## Checks Performed
- Env validation (presence and non-empty)
- Files present:
  - `project-logs/notion-brand-kickoff.txt` (optional)
  - `project-logs/notion-pages.json` (canonical)
  - `docs/notion/links.md` (generated)
- JSON keys present in `notion-pages.json`:
  - `Root`, `Brand`, `Roadmap`, `Arquitectura`, `Datos`, `DesignSystem`, `Operacion`

## Pre-Flight (safe to auto-run)
// turbo
```powershell
if (!(Test-Path 'project-logs')) { New-Item -ItemType Directory -Path 'project-logs' | Out-Null }
if (!(Test-Path 'docs/notion')) { New-Item -ItemType Directory -Path 'docs/notion' | Out-Null }
```

## Steps
1) Env validation
```powershell
$issues = @()
if (-not $env:NOTION_TOKEN) { $issues += 'Missing env: NOTION_TOKEN' }
if (-not $env:NOTION_WORKSPACE_PAGE_ID) { $issues += 'Recommended env missing: NOTION_WORKSPACE_PAGE_ID' }

if ($issues.Count -gt 0) {
  $issues | ForEach-Object { Write-Error $_ }
} else {
  Write-Output 'Env OK'
}
```

2) Files presence
```powershell
$files = @(
  'project-logs/notion-brand-kickoff.txt',
  'project-logs/notion-pages.json',
  'docs/notion/links.md'
)
$files | ForEach-Object {
  if (Test-Path $_) { Write-Output ("Found: {0}" -f $_) } else { Write-Warning ("Missing: {0}" -f $_) }
}
```

3) JSON keys validation (if JSON exists)
```powershell
if (Test-Path 'project-logs/notion-pages.json') {
  $json = Get-Content -Raw 'project-logs/notion-pages.json' | ConvertFrom-Json
  $required = @('Root','Brand','Roadmap','Arquitectura','Datos','DesignSystem','Operacion')
  $missing = $required | Where-Object { -not $json.PSObject.Properties.Name.Contains($_) -or -not $json.$_ }
  if ($missing.Count -gt 0) {
    Write-Warning ("Missing IDs in JSON: {0}" -f ($missing -join ', '))
  } else {
    Write-Output 'JSON IDs OK'
  }
}
```

4) Persist snapshot
```powershell
$ts = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
$log = "project-logs/notion-status-$ts.md"
@"
# Notion Status — $ts

## Env
- NOTION_TOKEN: $([string]::IsNullOrEmpty($env:NOTION_TOKEN) -replace 'True','MISSING' -replace 'False','SET')
- NOTION_WORKSPACE_PAGE_ID: $([string]::IsNullOrEmpty($env:NOTION_WORKSPACE_PAGE_ID) -replace 'True','MISSING' -replace 'False','SET')

## Files
$(
  $files | ForEach-Object { if (Test-Path $_) { "- Found: $_" } else { "- Missing: $_" } } | Out-String
)

## JSON Summary
$(
  if (Test-Path 'project-logs/notion-pages.json') {
    $json | ConvertTo-Json -Depth 4
  } else { 'no notion-pages.json' }
)
"@ | Set-Content -Encoding UTF8 $log
Write-Output ("Wrote status snapshot: {0}" -f $log)
```

## Next Steps
- If missing JSON or keys → run `workflows/notion/create-dynamic-root.md` then `workflows/notion/sync-links.md`.
- If env missing → set variables in shell/CI and re-run status.
