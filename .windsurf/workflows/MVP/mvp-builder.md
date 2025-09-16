---
description: Orquestador MVP — Ejecuta en cadena docs, frontend, backend, diagramas y seguridad con selección de tecnología
category: mvp
stability: experimental
---

# /mvp-builder — Orquestador de MVP

Orquesta la creación de un MVP mínimo seleccionando qué módulos ejecutar (docs, frontend, backend, diagramas, seguridad) y qué tecnologías usar en front/back. Sigue prácticas Windows‑friendly y publica en Notion cumpliendo la Regla 1 (crear nueva raíz cada ejecución).

Related: `/mvp-docs`, `/mvp-frontend`, `/mvp-backend`, `/mvp-diagrams`, `/mvp-security`, `/create-dynamic-root`

## Inputs
- `SELECT`: lista de módulos a ejecutar — valores: `docs`, `frontend`, `backend`, `diagrams`, `security`
- `FRONTEND_TECH`: `react-vite` (default) | `nextjs` | `sveltekit` | `angular`
- `BACKEND_TECH`: `fastify` (default) | `express` | `nest` | `hono` | `fastapi`
- `DB`: `neon-postgres` (default) | `sqlite` | `mongodb`
- `TARGET_ROOT`: monorepo (`apps/front`, `apps/back`) por defecto

## Paso 0: Preflight (AutoRun)
// turbo
```powershell
$paths = @('apps/front','apps/back','docs/mvp','project-logs/mvp/logs')
$paths | ForEach-Object { if (!(Test-Path $_)) { New-Item -ItemType Directory -Path $_ | Out-Null } }
$log = "project-logs/mvp/logs/run-$(Get-Date -Format yyyyMMdd-HHmmss).md"
"# /mvp-builder run $(Get-Date)" | Out-File -Encoding UTF8 -FilePath $log
```

## Paso 0.0: Intake de entrada libre (AutoParse)
// turbo
```powershell
# Lee entrada libre y la transforma en configuración estructurada
$intakeDir = "project-logs/mvp/intake"
if (!(Test-Path $intakeDir)) { New-Item -ItemType Directory -Path $intakeDir | Out-Null }

$req = $env:MVP_REQUEST
$reqPath = "docs/mvp/REQUEST.txt"
if (-not $req -and (Test-Path $reqPath)) { $req = Get-Content -Raw $reqPath }

if (-not $req) {
  $example = @"
# Escribe aquí en lenguaje natural lo que necesitas para tu MVP.
# Ejemplos:
# - "Necesito un landing con login y dashboard, Next.js con MongoDB. Sin backend separado; usar API Routes. Incluir auditoría de seguridad."
# - "Solo documentación (PRD y diagramas) por ahora."
# - "Front en React/Vite con Tailwind y shadcn; backend Fastify con Postgres (Neon)."
"@
  New-Item -ItemType Directory -Force -Path (Split-Path $reqPath -Parent) | Out-Null
  $example | Out-File -Encoding utf8 -FilePath "docs/mvp/REQUEST.example.txt"
}

# Defaults
$select = @()
$frontend = 'react-vite'
$backend = 'fastify'
$db = 'neon-postgres'
$ui = 'tailwind+shadcn'

function AddSelect([string]$s) { if (-not ($select -contains $s)) { $global:select += $s } }

if ($req) {
  $lower = $req.ToLower()

  # Módulos
  if ($lower -match 'documenta|doc|diagrama|diagram') { AddSelect 'docs'; AddSelect 'diagrams' }
  if ($lower -match 'seguridad|security|owasp|audit') { AddSelect 'security' }
  if ($lower -match 'solo doc|only doc|sin front|no front') { }
  elseif ($lower -match 'only front|solo front') { AddSelect 'frontend' }
  elseif ($lower -match 'only back|solo back') { AddSelect 'backend' }
  else { AddSelect 'frontend'; AddSelect 'backend'; AddSelect 'diagrams'; AddSelect 'docs' }

  # Frontend
  if ($lower -match 'next') { $frontend = 'nextjs' }
  elseif ($lower -match 'svelte') { $frontend = 'sveltekit' }
  elseif ($lower -match 'angular') { $frontend = 'angular' }

  # Backend
  if ($lower -match 'fastapi|python') { $backend = 'fastapi' }
  elseif ($lower -match 'express') { $backend = 'express' }
  elseif ($lower -match 'nest') { $backend = 'nest' }
  elseif ($lower -match 'hono|edge|serverless') { $backend = 'hono' }

  # Base de datos
  if ($lower -match 'mongo') { $db = 'mongodb' }
  elseif ($lower -match 'sqlite') { $db = 'sqlite' }
  elseif ($lower -match 'postgres|neon') { $db = 'neon-postgres' }

  # UI libs
  if ($lower -match 'shadcn') { $ui = 'tailwind+shadcn' }
  elseif ($lower -match 'tailwind') { $ui = 'tailwind' }
  elseif ($lower -match 'chakra|mui|bootstrap') { $ui = 'none' }

  # Sin backend explícito
  if ($lower -match 'sin backend|static|estatico|estática') {
    $select = $select | Where-Object { $_ -ne 'backend' }
  }
}

if ($select.Count -eq 0) { $select = @('docs','frontend','backend','diagrams') }

$cfg = [ordered]@{
  request = $req
  select = $select
  frontend_tech = $frontend
  backend_tech = $backend
  db = $db
  ui_libs = $ui
  timestamp = (Get-Date).ToString('s')
}

$cfgPath = Join-Path $intakeDir 'latest.json'
$cfg | ConvertTo-Json -Depth 5 | Out-File -Encoding utf8 -FilePath $cfgPath
Write-Host "[mvp-builder] Free-form intake parsed to $cfgPath"
```

## Paso 1: Ejecución condicional de módulos
Antes de ejecutar, si existe configuración parseada de intake, úsala para fijar variables de selección y tecnologías:
```powershell
$cfgPath = 'project-logs/mvp/intake/latest.json'
if (Test-Path $cfgPath) {
  $cfg = Get-Content $cfgPath | ConvertFrom-Json
  $SELECT = @($cfg.select)
  $FRONTEND_TECH = $cfg.frontend_tech
  $BACKEND_TECH = $cfg.backend_tech
  $DB = $cfg.db
  Write-Host "[mvp-builder] Using SELECT=$($SELECT -join ', '), FRONTEND=$FRONTEND_TECH, BACKEND=$BACKEND_TECH, DB=$DB"
}
- Si `docs` ∈ SELECT → Ejecuta `/mvp-docs`
- Si `frontend` ∈ SELECT → Ejecuta `/mvp-frontend` con `FRONTEND_TECH`
- Si `backend` ∈ SELECT → Ejecuta `/mvp-backend` con `BACKEND_TECH` y `DB`
- Si `diagrams` ∈ SELECT → Ejecuta `/mvp-diagrams`
- Si `security` ∈ SELECT → Ejecuta `/mvp-security`

## Paso 2: Integración Front–Back
- Configura `apps/front/src/lib/api-client.ts` apuntando a la URL local del backend.
- Añade scripts para levantar ambos servicios (opcional `concurrently`).

## Paso 3: Publicación en Notion (opcional, cumpliendo Regla 1)
- Ejecuta `/create-dynamic-root` para crear SIEMPRE una nueva página raíz.
- Publica subpáginas del MVP: PRD, API, Diagramas.
- Escribe las URLs en `$log`.

## Paso 4: Resumen y próximos pasos
- Generar `project-logs/mvp/summary-{date}.md` con:
  - Módulos ejecutados
  - Tech stack seleccionado
  - Rutas locales y, si aplica, URLs Notion

## Presets útiles
- Solo documentación: `SELECT = [docs, diagrams]`
- MVP mínimo ejecutable: `SELECT = [docs, frontend, backend, diagrams]`
- Hardening rápido: añade `security`

## Aceptación (Done)
- Módulos solicitados ejecutados
- Front y Back corriendo localmente (si se seleccionaron)
- Artefactos de documentación presentes
- (Opcional) Notion raíz creada dinámicamente y enlaces registrados
