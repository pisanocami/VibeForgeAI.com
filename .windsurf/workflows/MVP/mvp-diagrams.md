---
description: MVP — Diagramas de arquitectura y flujo (rápido y enfocado)
auto_execution_mode: 3
---

# /mvp-diagrams — Diagramas esenciales del MVP

Genera los diagramas mínimos necesarios para entender el MVP: estructura del proyecto, flujo de datos, dependencias y componentes clave. Reutiliza `/documentation/architecture-diagrams` y guarda los artefactos bajo `docs/mvp/diagrams/`.

Related: `/documentation/architecture-diagrams`, `/mvp-docs`

## Preflight (Windows PowerShell) — seguro para auto‑ejecutar
// turbo
```powershell
$paths = @('docs/mvp/diagrams','project-logs/diagrams')
$paths | ForEach-Object { if (!(Test-Path $_)) { New-Item -ItemType Directory -Path $_ | Out-Null } }
```

## Intake libre (AutoParse)
// turbo
```powershell
$cfgPath = 'project-logs/mvp/intake/latest.json'
$RUN_DIAGRAMS = $true

if (Test-Path $cfgPath) {
  try {
    $cfg = Get-Content $cfgPath | ConvertFrom-Json
    $select = @($cfg.select)
    if ($select.Length -gt 0 -and -not ($select -contains 'diagrams')) { $RUN_DIAGRAMS = $false }
  } catch { Write-Host "[mvp-diagrams] No se pudo leer $cfgPath: $($_.Exception.Message)" }
} else {
  $req = $env:MVP_REQUEST
  $reqPath = "docs/mvp/REQUEST.txt"
  if (-not $req -and (Test-Path $reqPath)) { $req = Get-Content -Raw $reqPath }
  if ($req) {
    $lower = $req.ToLower()
    if ($lower -match 'sin diagrama|no diagram') { $RUN_DIAGRAMS = $false } else { $RUN_DIAGRAMS = $true }
  }
}

Write-Host "[mvp-diagrams] RUN_DIAGRAMS=$RUN_DIAGRAMS"
```

> Nota: Los pasos se ejecutarán solo si `RUN_DIAGRAMS` es verdadero.

## Pasos
1) Ejecuta `/documentation/architecture-diagrams`.
// turbo
   - Ejecutar solo si `RUN_DIAGRAMS` es verdadero.
2) Copia o referencia los artefactos generados hacia `docs/mvp/diagrams/`.
// turbo
   - Ejecutar solo si `RUN_DIAGRAMS` es verdadero.
3) Genera un índice `docs/mvp/diagrams/README.md` con enlaces a:
// turbo
   - `project-structure.md`
   - `data-flow.md`
   - `component-architecture.md`
   - `dependencies.md`
   - Ejecutar solo si `RUN_DIAGRAMS` es verdadero.

## Artefactos
- `docs/mvp/diagrams/` (4–5 diagramas Mermaid/PNG)
- `docs/mvp/diagrams/README.md` (índice)

## Aceptación (Done)
- Diagrama de estructura + flujo de datos presentes
- Diagrama de componentes o dependencias presente
- Índice con enlaces funcionando